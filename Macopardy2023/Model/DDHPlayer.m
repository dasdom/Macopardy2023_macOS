//  Created by Dominik Hauser on 27.03.23.
//  
//

#import "DDHPlayer.h"

@implementation DDHPlayer
+ (NSColor *)colorForNumber:(NSInteger)number {
  NSColor *color = [NSColor whiteColor];
  if (number == 0) {
    color = [NSColor systemRedColor];
  } else if (number == 1) {
    color = [NSColor systemGreenColor];
  } else if (number == 2) {
    color = [NSColor systemBlueColor];
  } else {
    color = [NSColor grayColor];
  }
  return color;
}

- (instancetype)initWithName:(NSString *)name {
  if (self = [super init]) {
    _name = name;
  }
  return self;
}
@end
