//  Created by Dominik Hauser on 12.03.23.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHLevel : NSObject
@property (assign, nonatomic) NSInteger value;
@property (strong, nonatomic) NSString *answer;
@property (strong, nonatomic) NSString *question;
@property (strong, nonatomic) NSString *playerName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
