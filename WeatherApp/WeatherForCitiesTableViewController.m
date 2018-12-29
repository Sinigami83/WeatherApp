//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import "WeatherForCitiesTableViewController.h"
#import "ServerManager.h"
#import "WeatherForecastModel.h"
#import "WeatherCollectionViewCell.h"
#import "WeatherTableViewCell.h"


@interface WeatherForCitiesTableViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray<WeatherForecastModel *> *weatherForCities;
@property (nonatomic, strong) NSArray<WeatherForecastModel *> *weatherForOneDay;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *placeholderText;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *indexPaths;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation WeatherForCitiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    self.placeholderText.text = @"London";
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self find];
}

#pragma mark - API

- (IBAction)find
{
    [self getWeatherFromServer];
}

- (void)getWeatherFromServer
{
    ServerManager *SM = [[ServerManager alloc] init];
    [SM getWeatherWithCity:self.placeholderText.text
                 onSuccess:^(NSArray *weathers) {

                     [self handleWeathersLoaded:weathers];

                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.tableView reloadData];
                     });


     } onFailure:^(NSError *error) {
          NSLog(@"Error %@", [error localizedDescription]);
     }];
}

- (void)handleWeathersLoaded:(NSArray *)weathers
{
    self.weatherForCities = weathers;

    self.indexPaths = [[NSMutableArray alloc] init];

    NSDate *lastDate = self.weatherForCities[0].date;

    for (int i = 0, section = 0, row = 1; i < [self.weatherForCities count]; ++i) {

        NSComparisonResult ordererSet = [self compareTwoDate:lastDate secondDate:self.weatherForCities[i].date];
        if (ordererSet != NSOrderedSame) {
            [self.indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
            ++section;
            row = 1;
            lastDate = self.weatherForCities[i].date;
        } else {
            ++row;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexPaths count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSUInteger index = 0;
    for (int i = 0; i < section; ++i) {
        index += self.indexPaths[i].row;
    }

    self.dateFormatter.locale = [NSLocale currentLocale];
    self.dateFormatter.dateFormat = @"dd-MM-yyyy";
    NSString *dateStr = [self.dateFormatter stringFromDate:self.weatherForCities[index].date];
    return dateStr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSUInteger index = 0;
    for (int i = 0; i < indexPath.section; ++i) {
        index += self.indexPaths[i].row;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.indexPaths[indexPath.section].row; ++i) {
        [arr addObject:self.weatherForCities[index + i]];
    }
    self.weatherForOneDay = arr;
    return cell;

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.weatherForOneDay.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSUInteger index = 0;
    for (int i = 0; i < indexPath.section; ++i) {
        index += self.indexPaths[i].row;
    }
    WeatherForecastModel *weather = self.weatherForOneDay[index + indexPath.row];
    NSString *day = [NSString stringWithFormat:@"%lu", weather.hour];
    cell.weatherForDayLabel.text = day;
    cell.weatherIconImageView.image = [UIImage imageNamed:weather.image]; ;
    cell.temperatureLable.text = [NSString stringWithFormat:@"%.0f ℃", weather.temerature];
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
    NSDateComponents *firstDateComponents   = [self dayComponents: firstDate];
    NSDateComponents *secondDateComponents  = [self dayComponents: secondDate];

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
