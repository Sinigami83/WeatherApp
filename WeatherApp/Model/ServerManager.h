//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

+ (ServerManager *)sharedManager;

- (void)getWeatherWithCity:(NSString *)city
                 onSuccess:(void(^)(NSArray *coutries))success
                 onFailure:(void(^)(NSError *error))failure;
@end
