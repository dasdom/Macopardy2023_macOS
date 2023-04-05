//  Created by Dominik Hauser on 04.04.23.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PeerConnector : NSObject
@property (readonly, nonatomic) MCSession *session;
@end

NS_ASSUME_NONNULL_END
