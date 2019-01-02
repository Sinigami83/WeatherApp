//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import "LoadingDataFromServer.h"
#import "WeatherForecastModel.h"


@interface LoadingDataFromServer()
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation LoadingDataFromServer

+ (LoadingDataFromServer *)sharedManager
{
    static LoadingDataFromServer *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LoadingDataFromServer alloc] init];
    });

    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfig];
    }
    return self;
}

- (void)getWeatherWithCity:(NSString *)city
                 onSuccess:(void(^)(NSArray *coutries))success
                 onFailure:(void(^)(NSError *error))failure
{
    NSString *stringURL = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/forecast?appid=bb87c4e7d376b1ad20e1cd1683c0824d&q=%@&units=metric&type=like&lang=en", city];
    NSURL *url = [NSURL URLWithString:stringURL];

    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithURL:url
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    NSArray *weathersForCity = [self handleWeathersLoaded:data];
                    if (weathersForCity != nil) {
                        if (success != nil) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                success(weathersForCity);
                            });
                        }
                    } else {
                        if (failure != nil) {
                            failure(nil);
                        }
                    }
                }];
    [dataTask resume];
}

- (nullable NSArray *)handleWeathersLoaded:(NSData *)data
{
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:NULL];
    NSArray *weathers = [responseJSON objectForKey:@"list"];
    
    NSMutableArray<WeatherForecastModel *> *weatherForCity = [[NSMutableArray alloc] init];
    if (weathers == nil) {
        return nil;
    }

    for (NSDictionary *weather in weathers) {
        WeatherForecastModel *row = [[WeatherForecastModel alloc] initWithServerResponse:weather];
        [weatherForCity addObject:row];
    }
    return weatherForCity;
}

@end
