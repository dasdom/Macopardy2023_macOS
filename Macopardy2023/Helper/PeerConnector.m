//  Created by Dominik Hauser on 04.04.23.
//  
//

@import MultipeerConnectivity;

#import "PeerConnector.h"

@interface PeerConnector () <MCSessionDelegate>

@property (retain, nonatomic) MCAdvertiserAssistant *advertiserAssistant;
@end

@implementation PeerConnector

- (instancetype)initWithDisplayName:(NSString *)displayName serviceType:(NSString *)serviceType {
    if (self = [super init]) {
        MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:displayName];

        _session = [[MCSession alloc] initWithPeer:peerID securityIdentity:nil encryptionPreference:MCEncryptionNone];

        [_session setDelegate:self];

        _advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:serviceType discoveryInfo:nil session:_session];

        [_advertiserAssistant start];
    }
    return self;
}

- (void)dealloc {
    [_advertiserAssistant stop];
    [_session disconnect];
}

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

- (void)session:(nonnull MCSession *)session peer:(nonnull MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"Peer [%@] changed state to %@", peerID.displayName, [self stringForPeerConnectionState:state]);
}

- (void)session:(nonnull MCSession *)session didReceiveData:(nonnull NSData *)data fromPeer:(nonnull MCPeerID *)peerID {
    NSString *receivedMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSLog(@"%@ from %@", receivedMessage, peerID.displayName);
}

- (void)session:(nonnull MCSession *)session didFinishReceivingResourceWithName:(nonnull NSString *)resourceName fromPeer:(nonnull MCPeerID *)peerID atURL:(nullable NSURL *)localURL withError:(nullable NSError *)error {

}

- (void)session:(nonnull MCSession *)session didReceiveStream:(nonnull NSInputStream *)stream withName:(nonnull NSString *)streamName fromPeer:(nonnull MCPeerID *)peerID {

}

- (void)session:(nonnull MCSession *)session didStartReceivingResourceWithName:(nonnull NSString *)resourceName fromPeer:(nonnull MCPeerID *)peerID withProgress:(nonnull NSProgress *)progress {
    
}


@end
