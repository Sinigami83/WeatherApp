//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import "WeatherForTheCityTableViewController.h"
#import "AFNetworking/AFHTTPSessionManager.h"


@interface WeatherForTheCityTableViewController ()
@property (nonatomic, strong) NSArray *weatherForCities;
@end

@implementation WeatherForTheCityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSArray *)weatherForCities
{
    if (!_weatherForCities) {
        _weatherForCities = [[NSArray alloc] init];
    }
    return _weatherForCities;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.weatherForCities count];
}


@end
