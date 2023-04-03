//  Created by Dominik Hauser on 12.03.23.
//  
//


#import "DDHLevel.h"

@implementation DDHLevel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _value = [[dictionary valueForKey:@"value"] integerValue];
    _answer = [dictionary valueForKey:@"answer"];
    _question = [dictionary valueForKey:@"question"];
  }
  return self;
}
@end
