//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "Model.h"


@interface ServerManager()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation ServerManager

+ (ServerManager *)sharedManager
{
    static ServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });

    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *strURL = @"https://api.openweathermap.org/data/2.5/";
        NSURL *url = [NSURL URLWithString:strURL];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void)getWeatherWithCity:(NSString *)city
                 onSuccess:(void(^)(NSArray *coutries))success
                 onFailure:(void(^)(NSError *error))failure
{
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
    @"bb87c4e7d376b1ad20e1cd1683c0824d", @"appid",
    @"metric",  @"units",
    @"en",      @"lang",
    @"like",    @"type",
    city,       @"q",
    //@"3",       @"cnt",
    nil];

    [self.sessionManager
     GET:@"forecast"
     parameters:params
     progress:nil
     success:^(NSURLSessionTask *task, NSDictionary *responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *weathers = [responseObject objectForKey:@"list"];

        NSMutableArray<Model *> *weatherForCity = [[NSMutableArray alloc] init];

        for (NSDictionary *weather in weathers) {
            Model *row = [[Model alloc] initWithServerResponse:weather];
            [weatherForCity addObject:row];
        }

        if (success) {
            success(weatherForCity);
        }

        } failure:^(NSURLSessionTask *operation, NSError *error) {
            if (failure) {
                failure(error);
            }
            NSLog(@"Error: %@", error);
        }];
}

@end
