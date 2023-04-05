//  Created by Dominik Hauser on 03.04.23.
//  
//

#import "DDHGameView.h"
#import "DDHBoardScene.h"
#import "DDHStartScene.h"
#import <SpriteKit/SpriteKit.h>

@implementation DDHGameView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setScene:[[DDHStartScene alloc] init]];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)showBoardForRound:(DDHRound *)round {
    DDHBoardScene *scene = [[DDHBoardScene alloc] init];
    [scene updateWithRound:round];

    [self presentScene:scene
        withTransition:[SKTransition crossFadeWithDuration:1]
   incomingPointOfView:[scene cameraNode]
     completionHandler:^{
    }];
}

- (DDHBoardScene *)boardScene {
    return (DDHBoardScene *)[self scene];
}

@end
