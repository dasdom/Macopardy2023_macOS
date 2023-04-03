//  Created by Dominik Hauser on 28.03.23.
//  
//

#import "DDHBoardScene.h"
#import "DDHNodesFactory.h"
#import "DDHRound.h"
#import "DDHCategory.h"
#import "DDHLevel.h"
#import "DDHPlayer.h"

@interface DDHBoardScene ()
@property (assign) SCNVector3 previousPosition;
@end

@implementation DDHBoardScene

- (instancetype)init {
  if (self = [super init]) {
    SCNNode *rootNode = [self rootNode];

    _cameraNode = [SCNNode node];
    _cameraNode.camera = [SCNCamera camera];
    _cameraNode.position = SCNVector3Make(0, 0, 60);
    [rootNode addChildNode:_cameraNode];

    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 40);
    [rootNode addChildNode:lightNode];

    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [NSColor darkGrayColor];
    [rootNode addChildNode:ambientLightNode];
  }
  return self;
}

- (void)updateWithRound:(DDHRound *)round {
  SCNNode *rootNode = [self rootNode];

  CGSize boxSize = DDHNodesFactory.boxSize;
  NSArray<DDHCategory *> *categories = [round categories];
  __block CGFloat maxYPos = CGFLOAT_MIN;
  __block CGFloat minYPos = CGFLOAT_MAX;
  __block CGFloat minXPos = CGFLOAT_MAX;
  __block CGFloat maxXPos = CGFLOAT_MIN;

  [categories enumerateObjectsUsingBlock:^(DDHCategory * _Nonnull category, NSUInteger categoryIndex, BOOL * _Nonnull stop) {

    CGFloat xPos = (NSInteger)(categoryIndex - ([categories count] - 1)/2) * (boxSize.width + 0.5) - boxSize.width * 0.5;
    minXPos = MIN(xPos, minXPos);
    maxXPos = MAX(xPos, maxXPos);

    NSArray<DDHLevel *> *levels = [category levels];

    SCNNode *categoryName = [DDHNodesFactory categoryName:category.name];
    CGFloat categoryNameYPos = (NSInteger)([levels count]/2) * (boxSize.height + 5) - boxSize.height + 1 + 0.8 * boxSize.height;
    [categoryName setPosition:SCNVector3Make(xPos, categoryNameYPos, 0)];

    [rootNode addChildNode:categoryName];

    [levels enumerateObjectsUsingBlock:^(DDHLevel * _Nonnull level, NSUInteger levelIndex, BOOL * _Nonnull stop) {

      CGFloat yPos = (NSInteger)([levels count]/2 - levelIndex) * (boxSize.height + 1) - boxSize.height + 0.8 * boxSize.height;

      NSString *valueString = [NSString stringWithFormat:@"%ld", [level value]];
      SCNNode *box = [DDHNodesFactory answerBox:valueString categoryIndex:categoryIndex levelIndex:levelIndex];
//      NSLog(@"%f, %f, %ld", xPos, yPos, (long)level.value);
      [box setPosition:SCNVector3Make(xPos, yPos, 0)];

      [rootNode addChildNode:box];

      maxYPos = MAX(yPos, maxYPos);
      minYPos = MIN(yPos, minYPos);
    }];
  }];

//  NSLog(@"maxYPos: %f", maxYPos);
//  NSLog(@"minXPos: %f, maxXPos: %f", minXPos, maxXPos);

  __block NSMutableArray<SCNNode *> *playerNodes = [[NSMutableArray alloc] initWithCapacity:3];
  NSArray<DDHPlayer *> *players = [round players];
  [players enumerateObjectsUsingBlock:^(DDHPlayer * _Nonnull player, NSUInteger playerIndex, BOOL * _Nonnull stop) {

    CGFloat playerBoxWidth = (maxXPos + boxSize.width - minXPos) / players.count - 1;
//    NSLog(@"boxSize.width: %f, count: %ld", boxSize.width, players.count);
//    NSLog(@"playerBoxWidth: %f", playerBoxWidth);
    CGFloat xPos = minXPos + (playerBoxWidth + 1) * playerIndex + (playerBoxWidth - boxSize.width) / 2 + 0.5;
    CGFloat yPos = minYPos - boxSize.height;
//    NSLog(@"%f, %f", xPos, yPos);

    [player setPlayerNumber:playerIndex];

    NSColor *color = [DDHPlayer colorForNumber:[player playerNumber]];

    SCNNode *playerNode = [DDHNodesFactory playerNodeWithName:[player name] color:color width:playerBoxWidth];
    [playerNode setPosition:SCNVector3Make(xPos, yPos, 0)];

    [playerNodes addObject:playerNode];

    [rootNode addChildNode:playerNode];

  }];

  [self setPlayerNodes:[playerNodes copy]];

  CGFloat xPos = 0;
  CGFloat yPos = minYPos - boxSize.height*5/3;

  SCNNode *node = [DDHNodesFactory openPointsNodeWithPoints:[round stillOpenPoints]];
  [node setPosition:SCNVector3Make(xPos, yPos, 0)];

  [rootNode addChildNode:node];

  [self setOpenPointsNode:node];
}

- (SCNNode *)playerNodeForName:(NSString *)name {
  __block SCNNode *playerNode;
  [[self playerNodes] enumerateObjectsUsingBlock:^(SCNNode * _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([[node name] isEqualToString:name]) {
      playerNode = node;
      *stop = YES;
    }
  }];
  return playerNode;
}

- (void)showAnswerForNode:(SCNNode *)node level:(DDHLevel *)level {

    SCNNode *textNode = [[node childNodes] firstObject];

    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.5];

    self.previousPosition = node.position;
    node.scale = SCNVector3Make(3, 3, 1);
    node.position = SCNVector3Make(0, 0, 10);

    [SCNTransaction setCompletionBlock:^{
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        textNode.opacity = 0;

        [SCNTransaction setCompletionBlock:^{
            SCNText *textGeometry = [DDHNodesFactory textGeometryWithText:[level answer]];
            [textGeometry setWrapped:YES];
            [textGeometry setContainerFrame:CGRectMake(0, 0, 190, 190)];
            [textNode setScale:SCNVector3Make(0.04, 0.04, 0.04)];
            [textNode setGeometry:textGeometry];
            [DDHNodesFactory center:textNode];

            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            textNode.opacity = 1;
            [SCNTransaction commit];
        }];

        [SCNTransaction commit];
    }];

    [SCNTransaction commit];
}

- (void)showQuestionForNode:(SCNNode *)node level:(DDHLevel *)level {

    SCNNode *textNode = [[node childNodes] firstObject];

    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.5];

    SCNVector3 eulerAngles = node.eulerAngles;
    eulerAngles.y = M_PI;
    node.eulerAngles = eulerAngles;

    eulerAngles = textNode.eulerAngles;
    eulerAngles.y = M_PI;
    textNode.eulerAngles = eulerAngles;

    textNode.opacity = 0;

    [SCNTransaction setCompletionBlock:^{

        [textNode setPosition:SCNVector3Make(0, 0, -3)];

        SCNText *textGeometry = [DDHNodesFactory textGeometryWithText:[level question]];
        [textGeometry setWrapped:YES];
        [textGeometry setContainerFrame:CGRectMake(0, 0, 190, 190)];
        [textNode setGeometry:textGeometry];
        [DDHNodesFactory center:textNode];

        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];

        textNode.opacity = 1;

        [SCNTransaction commit];
    }];

    [SCNTransaction commit];

    [self setShownNode:node];
}

- (void)updateColorOfShownNodeForPlayer:(DDHPlayer *)player andResetLevel:(DDHLevel *)level {
    NSColor *color = [DDHPlayer colorForNumber:[player playerNumber]];

    SCNMaterial *material = [[SCNMaterial alloc] init];
    [[material diffuse] setContents:color];

    [[[self shownNode] geometry] setMaterials:@[material]];

    [self resetShownNodeWithLevel:level];
}

- (void)resetShownNodeWithLevel:(DDHLevel *)level {

    SCNNode *node = [self shownNode];

    SCNNode *textNode = [[node childNodes] firstObject];

    textNode.opacity = 0;

    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.5];

    node.scale = SCNVector3Make(1, 1, 1);
    node.position = [self previousPosition];

    SCNVector3 eulerAngles = node.eulerAngles;
    eulerAngles.y = 0;
    node.eulerAngles = eulerAngles;

    eulerAngles = textNode.eulerAngles;
    eulerAngles.y = 0;
    textNode.eulerAngles = eulerAngles;

    [SCNTransaction setCompletionBlock:^{
        NSString *text = [NSString stringWithFormat:@"%ld", (long)[level value]];
        SCNText *textGeometry = [DDHNodesFactory textGeometryWithText:text];
        [textGeometry setWrapped:YES];
        [textGeometry setContainerFrame:CGRectMake(0, 0, 190, 190)];
        [textNode setPosition:SCNVector3Make(0, 0, 3)];
        [textNode setScale:SCNVector3Make(0.2, 0.2, 0.2)];

        [textNode setGeometry:textGeometry];
        [DDHNodesFactory center:textNode];

        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        textNode.opacity = 1;
        [SCNTransaction commit];
    }];

    [SCNTransaction commit];

    [self setShownNode:nil];
}

- (void)updatePlayerNode:(SCNNode *)playerNode withPoints:(NSInteger)points {
    NSString *playerNodeText = [NSString stringWithFormat:@"%@: %ld", [playerNode name], points];
    SCNText *textGeometry = [DDHNodesFactory textGeometryWithText:playerNodeText];
    SCNNode *playerTextNode = [[playerNode childNodes] firstObject];
    [playerTextNode setGeometry:textGeometry];

    [DDHNodesFactory center:playerTextNode];
}

- (void)updatePlayerNodesWithRound:(DDHRound *)round {
    [[round players] enumerateObjectsUsingBlock:^(DDHPlayer * _Nonnull player, NSUInteger idx, BOOL * _Nonnull stop) {
        SCNNode *playerNode = [self playerNodeForName:[player name]];
        NSInteger points = [round pointsForPlayerWithName:[player name]];
        [self updatePlayerNode:playerNode withPoints:points];
    }];

    SCNNode *openPointsNode = [self openPointsNode];
    NSInteger points = [round stillOpenPoints];
    [self updatePlayerNode:openPointsNode withPoints:points];
}

@end
