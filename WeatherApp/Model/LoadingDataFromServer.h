//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadingDataFromServer : NSObject

+ (LoadingDataFromServer *)sharedManager;

- (void)getWeatherWithCity:(NSString *)city
                 onSuccess:(nullable void(^)(NSArray *coutries))success
                 onFailure:(nullable void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
