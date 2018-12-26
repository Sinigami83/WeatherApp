//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import "WeatherForCitiesTableViewController.h"
#import "Model/ServerManager.h"
#import "Model/Model.h"

@interface WeatherForCitiesTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray<Model *> *weatherForCities;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *cityNameTextField;

@end

@implementation WeatherForCitiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cityNameTextField.text = @"Tashkent";
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.weatherForCities[indexPath.row].temerature,
                           self.weatherForCities[indexPath.row].hour];

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
