//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingDataFromServer : NSObject

+ (LoadingDataFromServer *)sharedManager;

- (void)getWeatherWithCity:(NSString *)city
                 onSuccess:(void(^)(NSArray *coutries))success
                 onFailure:(void(^)(NSError *error))failure;
@end
