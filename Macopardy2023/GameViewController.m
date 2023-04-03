//  Created by Dominik Hauser on 03.04.23.
//  
//

#import "GameViewController.h"
#import "DDHGameView.h"
#import "DDHJSONLoader.h"
#import "DDHRound.h"
#import "DDHLevel.h"
#import "DDHBoardScene.h"

@interface GameViewController ()
@property (nonatomic, strong) DDHRound *round;
@end

@implementation GameViewController

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

    DDHGameView *gameView = (DDHGameView *)self.view;

    DDHRound *round = [DDHJSONLoader loadRound:1 playerNames:@[@"One", @"Two", @"Three", @"Nobody"]];
    [gameView showBoardForRound:round];
    [self setRound:round];
}

- (void)handleTap:(NSGestureRecognizer *)gestureRecognizer {
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // check what nodes are tapped
    CGPoint point = [gestureRecognizer locationInView:scnView];
    NSNumber *bitmask = [NSNumber numberWithInt:1 << 2];
    NSArray *hitResults = [scnView hitTest:point options:@{SCNHitTestOptionCategoryBitMask: bitmask}];

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
        [boardScene showAnswerForNode:node level:level];
    } else if ([node eulerAngles].y < 0.001) {
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

    NSString *playerName = [playerNode name];
    NSLog(@"node: %@", playerName);

    NSString *nameOfShownNode = [[boardScene shownNode] name];

    DDHLevel *level = [round levelForName:nameOfShownNode];
    [level setPlayerName:playerName];

    DDHPlayer *player = [round playerForName:playerName];

    [boardScene updateColorOfShownNodeForPlayer:player andResetLevel:level];

    [boardScene updatePlayerNodesWithRound:round];
}

@end
