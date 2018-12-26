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
        NSArray *weatherIcon = [responseObject objectForKey:@"weather"];
        NSNumber *icon = [weatherIcon[0] objectForKey:@"icon"];
        NSString *url = [NSString stringWithFormat:@"https://openweathermap.org/img/w/%@", icon];
        _image = [NSURL URLWithString:url]; 
    }
    return self;
}

@end
