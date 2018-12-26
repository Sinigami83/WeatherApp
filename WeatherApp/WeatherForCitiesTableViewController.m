//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import "WeatherForCitiesTableViewController.h"
#import "ServerManager.h"
#import "Model.h"
#import "UIImageView+AFNetworking.h"


@interface WeatherForCitiesTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray<Model *> *weatherForCities;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *cityNameTextField;

@end

@implementation WeatherForCitiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cityNameTextField.text = @"London";
    [self find];
}

#pragma mark - API

- (IBAction)find
{
    [self getWeatherFromServer];
}

- (void)getWeatherFromServer
{
    [[ServerManager sharedManager]
     getWeatherWithCity:self.cityNameTextField.text
     onSuccess:^(NSArray *coutries) {
         self.weatherForCities = coutries;

         [self.tableView reloadData];
     } onFailure:^(NSError *error) {
         NSLog(@"Error %@", [error localizedDescription]);
     }];
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.weatherForCities count];
}
*/
/*
 - (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 return ;
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.weatherForCities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Model *weather = self.weatherForCities[indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %lu", weather.temerature, weather.hour];
    [cell.imageView setImageWithURL:weather.image];
    return cell;
}

#pragma mark - get

- (NSArray *)weatherForCities
{
    if (!_weatherForCities) {
        _weatherForCities = [[NSArray alloc] init];
    }
    return _weatherForCities;
}

@end
