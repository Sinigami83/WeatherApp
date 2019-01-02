//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeatherForecastModel : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) double temerature;
@property (nonatomic, assign) NSUInteger hour;
@property (nonatomic, strong) NSString *image;
- (instancetype)initWithServerResponse:(NSDictionary *)responseObject;

@end
