//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import "ServerManager.h"
#import "Model.h"


@interface ServerManager()
@end

@implementation ServerManager

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

    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSString *stringURL = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/forecast?appid=bb87c4e7d376b1ad20e1cd1683c0824d&q=%@&units=metric", city];
    NSURL *url = [NSURL URLWithString:stringURL];

    NSURLSessionDataTask *dataTask =
        [session dataTaskWithURL:url
               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                   NSError *err;
                   NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingAllowFragments
                                                                                  error:&err];
                   NSLog(@"JSON: %@", responseJSON);
                   if (error) {
                       NSLog(@"ERROR!");
                       return;
                   }

                   NSArray *weathers = [responseJSON objectForKey:@"list"];

                   NSMutableArray<Model *> *weatherForCity = [[NSMutableArray alloc] init];

                   for (NSDictionary *weather in weathers) {
                       Model *row = [[Model alloc] initWithServerResponse:weather];
                       [weatherForCity addObject:row];
                   }

                   if (success) {
                       success(weatherForCity);
                   }

               }];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [dataTask resume];
    });

}

@end
