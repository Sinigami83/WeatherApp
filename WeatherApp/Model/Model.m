//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import "Model.h"

@implementation Model

- (instancetype)initWithServerResponse:(NSDictionary *)responseObject
{
    self = [super init];
    if (self) {
        _date = [responseObject objectForKey:@"dt"];
        _temerature = [[responseObject objectForKey:@"main"] objectForKey:@"temp"];
        _hour = [responseObject objectForKey:@"dt"];
        // *weatherIcon = [responseObject objectForKey:@"weather"];
        //_image = [[NSURL URLWithString:@"https://openweathermap.org/img/w/%@", weatherIcon]; // icon https://openweathermap.org/img/w/10d.png
    }
    return self;
}

@end
