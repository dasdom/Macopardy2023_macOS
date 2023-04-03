//  Created by Dominik Hauser on 12.03.23.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHLevel;

@interface DDHCategory : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray<DDHLevel *> *levels;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
