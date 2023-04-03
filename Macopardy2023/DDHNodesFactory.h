//  Created by Dominik Hauser on 11.03.23.
//  
//

#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHNodesFactory : NSObject
+ (CGSize)boxSize;
+ (SCNNode *)answerBox:(NSString *)text categoryIndex:(NSInteger)categoryIndex levelIndex:(NSInteger)levelIndex;
+ (NSString *)nodeNameForCategoryIndex:(NSInteger)categoryIndex levelIndex:(NSInteger)levelIndex;
+ (SCNNode *)categoryName:(NSString *)name;
+ (SCNText *)textGeometryWithText:(NSString *)text;
+ (SCNNode *)playerNodeWithName:(NSString *)name color:(NSColor *)color width:(CGFloat)width;
+ (SCNNode *)openPointsNodeWithPoints:(NSInteger)points;
+ (void)center:(SCNNode *)node;
@end

NS_ASSUME_NONNULL_END
