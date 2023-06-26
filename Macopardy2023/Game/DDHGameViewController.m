//  Created by Dominik Hauser on 03.04.23.
//  
//

@import MultipeerConnectivity;

#import "DDHGameViewController.h"
#import "DDHGameView.h"
#import "DDHJSONLoader.h"
#import "DDHRound.h"
#import "DDHLevel.h"
#import "DDHBoardScene.h"

static NSString * const BuzzerServiceType = @"macopardy-buz";

@interface DDHGameViewController () <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>
@property (nonatomic, strong) DDHRound *round;
@property (nonatomic, strong) MCPeerID *localPeerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (assign) BOOL buzzerActive;
@property (nonatomic, strong) NSString *buzzedPlayerName;
@end

@implementation DDHGameViewController

- (void)loadView {
    DDHGameView *contentView = [[DDHGameView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];
    [self setView:contentView];
}

- (DDHGameView *)contentView {
    return (DDHGameView *)[self view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SCNView *scnView = (SCNView *)self.view;

    // Add a click gesture recognizer
    NSClickGestureRecognizer *clickGesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:clickGesture];
    [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
    scnView.gestureRecognizers = gestureRecognizers;
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
}

- (void)startRoundWithPlayerNames:(NSArray<NSString *> *)playerNames {
    DDHGameView *gameView = (DDHGameView *)self.view;

    NSArray *modifyedPlayerNames = [playerNames arrayByAddingObject:@"Nobody"];
    DDHRound *round = [DDHJSONLoader loadRound:1 playerNames:modifyedPlayerNames];
    [gameView showBoardForRound:round];
    [self setRound:round];
}

- (void)handleTap:(NSGestureRecognizer *)gestureRecognizer {
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // check what nodes are tapped
    CGPoint point = [gestureRecognizer locationInView:scnView];
    NSNumber *bitmask = [NSNumber numberWithInt:1 << 1];
    NSArray *hitResults = [scnView hitTest:point options:@{SCNHitTestOptionCategoryBitMask: bitmask}];

    if ([hitResults count] > 0) {
        [self connect];
        return;
    }

    bitmask = [NSNumber numberWithInt:1 << 2];
    hitResults = [scnView hitTest:point options:@{SCNHitTestOptionCategoryBitMask: bitmask}];

    DDHRound *round = [self round];

    if ([hitResults count] > 0) {
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        [self handleLevelTapWithHitTestResult:result round:round];
        return;
    }

    bitmask = [NSNumber numberWithInt:1 << 3];
    hitResults = [scnView hitTest:point options:@{SCNHitTestOptionCategoryBitMask: bitmask}];

    if ([hitResults count] > 0) {
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        [self handlePlayerTapWithHitTestResult:result round:round];
    }
}

- (void)handleLevelTapWithHitTestResult:(SCNHitTestResult *)hitTestResult round:(DDHRound *)round {

    SCNNode *node = [hitTestResult node];

    if (node == nil) {
        return;
    }
    // get its material

    NSString *name = [node name];
    NSLog(@"node: %@", name);
    if ([[round playedLevel] containsObject:name]) {
        return;
    }

    DDHLevel *level = [round levelForName:name];

    NSLog(@"Answer: %@", [level answer]);

    DDHGameView *gameView = [self contentView];
    DDHBoardScene *boardScene = [gameView boardScene];
    if ([node scale].x < 2) {
        [self setBuzzerActive:YES];
        [boardScene showAnswerForNode:node level:level];
    } else if ([node eulerAngles].y < 0.001 && [self buzzedPlayerName] != nil) {
        [self setBuzzerActive:NO];
        [boardScene showQuestionForNode:node level:level];
    }
}

- (void)handlePlayerTapWithHitTestResult:(SCNHitTestResult *)hitTestResult round:(DDHRound *)round {
    SCNNode *playerNode = [hitTestResult node];

    if (playerNode == nil) {
        return;
    }
    DDHGameView *gameView = [self contentView];
    DDHBoardScene *boardScene = [gameView boardScene];
    if ([boardScene shownNode] == nil) {
        return;
    }

    [self setBuzzedPlayerName:nil];
    [gameView setBackgroundColor:[NSColor whiteColor]];

    NSString *playerName = [playerNode name];
    NSLog(@"node: %@", playerName);

    NSString *nameOfShownNode = [[boardScene shownNode] name];

    DDHLevel *level = [round levelForName:nameOfShownNode];
    [level setPlayerName:playerName];

    DDHPlayer *player = [round playerForName:playerName];

    [boardScene updateColorOfShownNodeForPlayer:player andResetLevel:level];

    [boardScene updatePlayerNodesWithRound:round];
}

- (void)connect {
    NSLog(@"connect");

    MCPeerID *localPeerID = [[MCPeerID alloc] initWithDisplayName:@"Macopardy Host"];

    [self setLocalPeerID:localPeerID];

    _session = [[MCSession alloc] initWithPeer:localPeerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
    [_session setDelegate:self];

    _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:localPeerID discoveryInfo:nil serviceType:BuzzerServiceType];
    [_advertiser setDelegate:self];
    [_advertiser startAdvertisingPeer];
}

// MARK: - MCNearbyServiceAdvertiserDelegate
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession * _Nullable))invitationHandler {

    invitationHandler(YES, [self session]);
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    NSLog(@"error: %@", error);
}

// MARK: - MCSessionDelegate
- (void)session:(nonnull MCSession *)session peer:(nonnull MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"Peer [%@] changed state to %@", peerID.displayName, [self stringForPeerConnectionState:state]);

    if ([[session connectedPeers] count] == 3) {
        __block NSMutableArray *peerDisplayNames = [[NSMutableArray alloc] init];
        [[session connectedPeers] enumerateObjectsUsingBlock:^(MCPeerID * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [peerDisplayNames addObject:[obj displayName]];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startRoundWithPlayerNames:[peerDisplayNames copy]];
        });
    }
}

- (void)session:(nonnull MCSession *)session didReceiveData:(nonnull NSData *)data fromPeer:(nonnull MCPeerID *)peerID {

    if (NO == [self buzzerActive] && nil == [self buzzedPlayerName]) {
        return;
    }
    NSString *receivedMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSLog(@"%@ from %@", receivedMessage, peerID.displayName);

    dispatch_async(dispatch_get_main_queue(), ^{
        DDHRound *round = [self round];
        DDHGameView *gameView = [self contentView];
        DDHBoardScene *boardScene = [gameView boardScene];

        [self setBuzzedPlayerName:peerID.displayName];

        NSColor *color = [boardScene colorForPlayerName:peerID.displayName round:round];
        [gameView setBackgroundColor:color];
    });
}

- (void)session:(nonnull MCSession *)session didFinishReceivingResourceWithName:(nonnull NSString *)resourceName fromPeer:(nonnull MCPeerID *)peerID atURL:(nullable NSURL *)localURL withError:(nullable NSError *)error {

}

- (void)session:(nonnull MCSession *)session didReceiveStream:(nonnull NSInputStream *)stream withName:(nonnull NSString *)streamName fromPeer:(nonnull MCPeerID *)peerID {

}

- (void)session:(nonnull MCSession *)session didStartReceivingResourceWithName:(nonnull NSString *)resourceName fromPeer:(nonnull MCPeerID *)peerID withProgress:(nonnull NSProgress *)progress {

}

// MARK: - Helper
- (NSString *)stringForPeerConnectionState:(MCSessionState)state {
    switch (state) {
        case MCSessionStateConnected:
            return @"Connected";
            break;
        case MCSessionStateConnecting:
            return @"Connecting";
            break;
        case MCSessionStateNotConnected:
            return @"Not Connected";
            break;
    }
}
@end
