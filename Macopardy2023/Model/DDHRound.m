//  Created by Dominik Hauser on 12.03.23.
//  
//

#import "DDHRound.h"
#import "DDHCategory.h"
#import "DDHPlayer.h"
#import "DDHLevel.h"
#import "DDHNodesFactory.h"

@implementation DDHRound
- (instancetype)initWithDictionary:(NSDictionary *)dictionary number:(NSInteger)number playerNames:(NSArray<NSString *> *)playerNames {
  if (self = [super init]) {
    _name = [dictionary valueForKey:@"name"];

    NSArray *rawCategories = [dictionary valueForKey:@"categories"];
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    [rawCategories enumerateObjectsUsingBlock:^(NSDictionary<NSString *, NSObject *> *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {

      DDHCategory *category = [[DDHCategory alloc] initWithDictionary:dict];
      [categories addObject:category];
    }];
    _categories = [categories copy];

    self.number = number;

    NSMutableArray<DDHPlayer *> *players = [[NSMutableArray alloc] init];
    [playerNames enumerateObjectsUsingBlock:^(NSString * _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
      DDHPlayer *player = [[DDHPlayer alloc] initWithName:name];
      [players addObject:player];
    }];

    _players = players;
  }
  return self;
}

- (NSInteger)stillOpenPoints {
  return [self pointsForPlayerWithName:nil];
}

- (DDHPlayer *)playerForName:(NSString *)name {
  __block DDHPlayer *player;
  [[self players] enumerateObjectsUsingBlock:^(DDHPlayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([[obj name] isEqualToString:name]) {
      player = obj;
      *stop = YES;
    }
  }];
  return player;
}

- (NSInteger)pointsForPlayerWithName:(NSString *)name {
  __block NSInteger points = 0;
  [[self categories] enumerateObjectsUsingBlock:^(DDHCategory * _Nonnull category, NSUInteger idx, BOOL * _Nonnull stop) {
    [[category levels] enumerateObjectsUsingBlock:^(DDHLevel * _Nonnull level, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([name length] > 0) {
        if ([[level playerName] isEqualToString:name]) {
          points += [level value];
        }
      } else if ([[level playerName] length] < 1) {
        points += [level value];
      }
    }];
  }];
  return points;
}

- (DDHLevel *)levelForName:(NSString *)name {
    NSArray<NSString *> *nameComponents = [name componentsSeparatedByString:@","];
    NSInteger categoryIndex = [[nameComponents firstObject] integerValue];
    DDHCategory *category = [[self categories] objectAtIndex:categoryIndex];

    NSInteger levelIndex = [[nameComponents lastObject] integerValue];
    return [[category levels] objectAtIndex:levelIndex];
}

- (NSArray<NSString *> *)playedLevel {
    __block NSMutableArray *playedLevel = [[NSMutableArray alloc] init];
    [[self categories] enumerateObjectsUsingBlock:^(DDHCategory * _Nonnull category, NSUInteger categoryIndex, BOOL * _Nonnull stop) {
        [[category levels] enumerateObjectsUsingBlock:^(DDHLevel * _Nonnull level, NSUInteger levelIndex, BOOL * _Nonnull stop) {
            if ([[level playerName] length] > 0) {
                NSString *nodeName = [DDHNodesFactory nodeNameForCategoryIndex:categoryIndex levelIndex:levelIndex];
                [playedLevel addObject:nodeName];
            }
        }];
    }];
    return [playedLevel copy];
}

@end
