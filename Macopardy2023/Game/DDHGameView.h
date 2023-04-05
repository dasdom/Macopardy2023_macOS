//  Created by Dominik Hauser on 03.04.23.
//  
//


#import <SceneKit/SceneKit.h>

@class DDHRound;
@class DDHBoardScene;

NS_ASSUME_NONNULL_BEGIN

@interface DDHGameView : SCNView
@property (nonatomic, strong) NSButton *connectButton;
- (void)showBoardForRound:(DDHRound *)round;
- (DDHBoardScene *)boardScene;
@end

NS_ASSUME_NONNULL_END
