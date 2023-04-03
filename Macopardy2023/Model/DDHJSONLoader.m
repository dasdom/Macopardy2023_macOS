//  Created by Dominik Hauser on 12.03.23.
//  
//

#import "DDHJSONLoader.h"
#import "DDHRound.h"

@implementation DDHJSONLoader
+ (DDHRound *)loadRound:(NSInteger)number playerNames:(NSArray<NSString *> *)playerNames {
  NSString *fileName = [NSString stringWithFormat:@"round%ld", number];
  NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"json"];
  NSData *data = [[NSData alloc] initWithContentsOfURL:url];
  NSError *jsonError = nil;
  NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
  return [[DDHRound alloc] initWithDictionary:jsonDictionary number:number playerNames:playerNames];
}
@end
