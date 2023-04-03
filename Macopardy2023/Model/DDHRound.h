//  Created by Dominik Hauser on 12.03.23.
//  
//

#import <Foundation/Foundation.h>

@class DDHCategory;
@class DDHPlayer;
@class DDHLevel;

@interface DDHRound : NSObject
@property (nonatomic) NSInteger number;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray<DDHCategory *> *categories;
@property (strong, nonatomic) NSArray<DDHPlayer *> *players;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary number:(NSInteger)number playerNames:(NSArray<NSString *> *)playerNames;
- (NSInteger)stillOpenPoints;
- (DDHPlayer *)playerForName:(NSString *)name;
- (NSInteger)pointsForPlayerWithName:(NSString *)name;
- (DDHLevel *)levelForName:(NSString *)name;
- (NSArray<NSString *> *)playedLevel;
@end
