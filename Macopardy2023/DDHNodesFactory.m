//  Created by Dominik Hauser on 11.03.23.
//  
//

#import "DDHNodesFactory.h"

@implementation DDHNodesFactory

+ (CGSize)boxSize {
  return CGSizeMake(20, 10);
}

+ (SCNGeometry *)boxGeometryWithSize:(CGSize)size length:(CGFloat)length {
  return [SCNBox boxWithWidth:size.width height:size.height length:length chamferRadius:length * 0.1];
}

+ (SCNNode *)answerBox:(NSString *)text categoryIndex:(NSInteger)categoryIndex levelIndex:(NSInteger)levelIndex {
  SCNMaterial *material = [[SCNMaterial alloc] init];
  [[material diffuse] setContents:[NSColor colorWithHue:0.1 saturation:0.4 brightness:0.4 alpha:1]];

  CGSize boxSize = [self boxSize];
  CGFloat length = 5;
  SCNGeometry *geometry = [self boxGeometryWithSize:boxSize length:length];
  [geometry setMaterials:@[material]];

  SCNText *textGeometry = [SCNText textWithString:text extrusionDepth:length/3];
//  [textGeometry setFont:[UIFont systemFontOfSize: 0.8]];
  [textGeometry setFlatness:0.1];
  [textGeometry setAlignmentMode:@"center"];

  SCNNode *textNode = [SCNNode nodeWithGeometry:textGeometry];
  [textNode setPosition:SCNVector3Make(0, 0, length/2)];
  [textNode setScale:SCNVector3Make(0.2, 0.2, 0.2)];
  [self center:textNode];

  SCNNode *node = [SCNNode nodeWithGeometry:geometry];
  [node setName:[DDHNodesFactory nodeNameForCategoryIndex:categoryIndex levelIndex:levelIndex]];
  [node setCategoryBitMask:1 << 2];
  [node addChildNode:textNode];

  return node;
}

+ (NSString *)nodeNameForCategoryIndex:(NSInteger)categoryIndex levelIndex:(NSInteger)levelIndex {
  return [NSString stringWithFormat:@"%ld,%ld", (long)categoryIndex, (long)levelIndex];
}

+ (SCNText *)textGeometryWithText:(NSString *)text {
  SCNText *textGeometry = [SCNText textWithString:text extrusionDepth:5/3];
  [textGeometry setFlatness:0.1];
  [textGeometry setAlignmentMode:@"center"];
  return textGeometry;
}

+ (SCNNode *)categoryName:(NSString *)name {
  SCNMaterial *material = [[SCNMaterial alloc] init];
  [[material diffuse] setContents:[NSColor grayColor]];

  CGSize boxSize = [self boxSize];
  CGFloat length = 2;
  SCNGeometry *geometry = [SCNBox boxWithWidth:boxSize.width height:boxSize.height/2 length:length chamferRadius:0.1];
  [geometry setMaterials:@[material]];

  SCNText *textGeometry = [SCNText textWithString:name extrusionDepth:length/3];
  [textGeometry setAlignmentMode:@"center"];

  SCNNode *textNode = [SCNNode nodeWithGeometry:textGeometry];
  [textNode setPosition:SCNVector3Make(0, 0, length/2)];
  [textNode setScale:SCNVector3Make(0.1, 0.1, 0.1)];
  [self center:textNode];

  SCNNode *node = [SCNNode nodeWithGeometry:geometry];

  [node addChildNode:textNode];

  return node;
}

+ (SCNNode *)playerNodeWithName:(NSString *)name color:(NSColor *)color width:(CGFloat)width {
  SCNMaterial *material = [[SCNMaterial alloc] init];
  [[material diffuse] setContents:color];

  CGSize boxSize = [self boxSize];
  CGFloat length = 2;
  SCNGeometry *geometry = [SCNBox boxWithWidth:width height:boxSize.height/2 length:length chamferRadius:0.1];
  [geometry setMaterials:@[material]];

  SCNText *textGeometry = [SCNText textWithString:name extrusionDepth:length/3];
  [textGeometry setAlignmentMode:@"center"];

  SCNNode *textNode = [SCNNode nodeWithGeometry:textGeometry];
  [textNode setPosition:SCNVector3Make(0, 0, length/2)];
  [textNode setScale:SCNVector3Make(0.08, 0.08, 0.08)];
  [self center:textNode];

  SCNNode *node = [SCNNode nodeWithGeometry:geometry];
  [node setName:name];
  [node setCategoryBitMask:1 << 3];

  [node addChildNode:textNode];

  return node;
}

+ (SCNNode *)openPointsNodeWithPoints:(NSInteger)points {
  SCNMaterial *material = [[SCNMaterial alloc] init];
  [[material diffuse] setContents:[NSColor lightGrayColor]];

  CGSize boxSize = [self boxSize];
  CGFloat length = 2;
  SCNGeometry *geometry = [SCNBox boxWithWidth:boxSize.width height:boxSize.height/3 length:length chamferRadius:0.1];

  [geometry setMaterials:@[material]];

  NSString *text = [NSString stringWithFormat:@"Open: %ld", (long)points];
  SCNText *textGeometry = [SCNText textWithString:text extrusionDepth:length/3];
  [textGeometry setAlignmentMode:@"center"];

  SCNNode *textNode = [SCNNode nodeWithGeometry:textGeometry];
  [textNode setPosition:SCNVector3Make(0, 0, length/2)];
  [textNode setScale:SCNVector3Make(0.05, 0.05, 0.05)];
  [self center:textNode];

  SCNNode *node = [SCNNode nodeWithGeometry:geometry];
  [node setName:@"Open"];
  [node addChildNode:textNode];

  return node;
}

+ (void)center:(SCNNode *)node {
  SCNVector3 min;
  SCNVector3 max;

  [node getBoundingBoxMin:&min max:&max];

  float translationX = (max.x + min.x) * 0.5;
  float translationY = (max.y + min.y) * 0.5;

  [node setPivot:SCNMatrix4MakeTranslation(translationX, translationY, 0)];
}

@end
