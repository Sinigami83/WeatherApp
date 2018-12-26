//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import "Model.h"

@interface Model()
@end

@implementation Model

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
        _temerature = [numberFormatter numberFromString:numberInString];


        NSDateComponents *hourComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitHour
                                                                          fromDate:_date];
        NSUInteger firstDay = [hourComponent hour];
        _hour = firstDay;

        NSArray *weatherIcon = [responseObject objectForKey:@"weather"];
        NSNumber *icon = [weatherIcon[0] objectForKey:@"icon"];
        NSString *url = [NSString stringWithFormat:@"https://openweathermap.org/img/w/%@", icon];
        _image = [NSURL URLWithString:url]; 
    }
    return self;
}

@end
