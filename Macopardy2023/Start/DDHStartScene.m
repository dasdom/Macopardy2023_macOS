//  Created by Dominik Hauser on 03.04.23.
//  
//

#import "DDHStartScene.h"
#import "DDHNodesFactory.h"

@implementation DDHStartScene

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

        SCNNode *roundSelectionNode = [DDHNodesFactory roundSelectionNodeWithText:@"Round 1"];

        [rootNode addChildNode:roundSelectionNode];
    }
    return self;
}

@end
