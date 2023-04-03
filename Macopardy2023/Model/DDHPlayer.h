//  Created by Dominik Hauser on 27.03.23.
//  
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHPlayer : NSObject
@property (nonatomic, strong) NSString *name;
@property (assign) NSInteger points;
@property (nonatomic) NSInteger playerNumber;

+ (NSColor *)colorForNumber:(NSInteger)number;
- (instancetype)initWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
