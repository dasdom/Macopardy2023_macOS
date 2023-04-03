//  Created by Dominik Hauser on 12.03.23.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHRound;

@interface DDHJSONLoader : NSObject
+ (DDHRound *)loadRound:(NSInteger)number playerNames:(NSArray<NSString *> *)playerNames;
@end

NS_ASSUME_NONNULL_END
