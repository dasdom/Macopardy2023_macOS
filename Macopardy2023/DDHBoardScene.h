//  Created by Dominik Hauser on 28.03.23.
//  
//

#import <SceneKit/SceneKit.h>

@class DDHRound;
@class DDHLevel;
@class DDHPlayer;

@interface DDHBoardScene : SCNScene
@property (nonatomic, strong) SCNNode *cameraNode;
@property (nonatomic, strong) NSArray<SCNNode *> *playerNodes;
@property (nonatomic, strong) SCNNode *openPointsNode;
@property (nonatomic, strong) SCNNode *shownNode;
- (void)updateWithRound:(DDHRound *)round;
- (SCNNode *)playerNodeForName:(NSString *)name;
- (void)showAnswerForNode:(SCNNode *)node level:(DDHLevel *)level;
- (void)showQuestionForNode:(SCNNode *)node level:(DDHLevel *)level;
- (void)updateColorOfShownNodeForPlayer:(DDHPlayer *)player andResetLevel:(DDHLevel *)level;
- (void)resetShownNodeWithLevel:(DDHLevel *)level;
- (void)updatePlayerNodesWithRound:(DDHRound *)round;
@end

