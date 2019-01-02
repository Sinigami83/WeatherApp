//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import "WeatherForecastModel.h"


@implementation WeatherForecastModel

- (instancetype)initWithServerResponse:(NSDictionary *)responseObject
{
    self = [super init];
    if (self) {
        NSNumber *dateInString = [responseObject objectForKey:@"dt"];
        _date = [NSDate dateWithTimeIntervalSince1970:[dateInString doubleValue]];

        NSNumber *temperature = [[responseObject objectForKey:@"main"] objectForKey:@"temp"];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setRoundingMode:NSNumberFormatterRoundUp];
        [numberFormatter setMaximumFractionDigits:0];
        NSString *numberInString = [numberFormatter stringFromNumber:temperature];
        _temerature = numberInString.doubleValue;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *hourComponent = [calendar components:NSCalendarUnitHour
                                                      fromDate:self.date];
        NSUInteger hour = [hourComponent hour];
        _hour = hour;

        NSArray *weatherIcon = [responseObject objectForKey:@"weather"];
        NSNumber *icon = [weatherIcon[0] objectForKey:@"icon"];
        _image = [NSString stringWithFormat:@"%@", icon];
    }
    return self;
}

@end
