//  Created by Dominik Hauser on 12.03.23.
//  
//


#import "DDHCategory.h"
#import "DDHLevel.h"

@implementation DDHCategory
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _name = [dictionary valueForKey:@"name"];

    NSArray *rawLevels = [dictionary valueForKey:@"levels"];
    NSMutableArray *levels = [[NSMutableArray alloc] init];
    [rawLevels enumerateObjectsUsingBlock:^(NSDictionary<NSString *, NSObject *>  * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {

      DDHLevel *level = [[DDHLevel alloc] initWithDictionary:dict];
      [levels addObject:level];
    }];

    _levels = [levels copy];
  }
  return self;
}
@end
