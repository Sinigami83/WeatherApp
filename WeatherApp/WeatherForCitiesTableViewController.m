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
@property (nonatomic, strong) NSMutableArray *indexPaths;
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

         //[self.tableView reloadData];

         self.indexPaths = [[NSMutableArray alloc] init];
         NSDate *lastDate = self.weatherForCities[0].date;
         for (int i = 0, section = 0, row = 0; i < [self.weatherForCities count]; ++i) {
             if ([self compareTwoDate:lastDate
                           secondDate:self.weatherForCities[i].date] == NSOrderedAscending) {
                 ++section;
                 row = 0;
                 lastDate = self.weatherForCities[i].date;
             } else {
                 ++row;
             }
             [self.indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
         }

         [self.tableView performBatchUpdates:^{
             [self.tableView insertRowsAtIndexPaths:self.indexPaths withRowAnimation:UITableViewRowAnimationTop];
         } completion:^(BOOL finished) {

         }];

     } onFailure:^(NSError *error) {
         NSLog(@"Error %@", [error localizedDescription]);
     }];
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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

    cell.textLabel.text = [NSString stringWithFormat:@"Temperatue - %@, hour - %lu", weather.temerature, weather.hour];
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

#pragma mark - for compare

- (NSDateComponents *)dayComponents:(NSDate *)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSCalendarUnit flags = NSCalendarUnitDay;
    NSDateComponents *daysComponents = [calendar components:flags
                                                   fromDate:date];
    return daysComponents;
}

- (NSComparisonResult)compareTwoDate:(NSDate *)firstDate
            secondDate:(NSDate *)secondDate
{
    NSDateComponents *firstDateComponents = [self dayComponents: firstDate];
    NSDateComponents *secondDateComponents = [self dayComponents: secondDate];

    NSUInteger firstDay     = [firstDateComponents day];
    NSUInteger secondDay    = [secondDateComponents day];

    if (firstDay == secondDay) {
        return NSOrderedSame;
    } else if (firstDay < secondDay) {
        return NSOrderedAscending;
    }
    return NSOrderedDescending;
}

@end
