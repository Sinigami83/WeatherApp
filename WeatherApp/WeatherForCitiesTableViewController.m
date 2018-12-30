//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import "WeatherForCitiesTableViewController.h"
#import "LoadingDataFromServer.h"
#import "WeatherForecastModel.h"
#import "WeatherCollectionViewCell.h"
#import "WeatherTableViewCell.h"
#import "Section.h"


@interface WeatherForCitiesTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray<WeatherForecastModel *> *weatherForCities;
@property (nonatomic, strong) NSArray<SectionRow *> *weatherForOneDay;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *placeholderText;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *indexPaths;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSArray<Section *> *dataForPrint;
@end

@implementation WeatherForCitiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    self.placeholderText.text = @"London";

    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd-MM-yyyy";

    [self find];
}

#pragma mark - API

- (IBAction)find
{
    [self getWeatherFromServer];
}

- (void)getWeatherFromServer
{
    [[LoadingDataFromServer sharedManager]
     getWeatherWithCity:self.placeholderText.text
              onSuccess:^(NSArray *weathers) {

        self.weatherForCities = weathers;

        [self reloadData];

     } onFailure:^(NSError *error) {
          NSLog(@"Error %@", [error localizedDescription]);
     }];
}

- (void)reloadData
{
    NSMutableArray *sections = [NSMutableArray array];
    NSMutableArray *rows = [NSMutableArray array];

    NSDate *weatherDate = self.weatherForCities[0].date;
    for (WeatherForecastModel *w in self.weatherForCities) {

        NSComparisonResult result = [self compareTwoDate:weatherDate secondDate:w.date];
        if (result != NSOrderedSame) {
            Section *s = [[Section alloc] init];
            s.title = [self.dateFormatter stringFromDate:weatherDate];
            s.rows = rows;
            [sections addObject:s];
            weatherDate = w.date;
            [rows removeAllObjects];
        }

        SectionRow *row = [[SectionRow alloc] init];
        row.temperature = w.temerature;
        row.hour = w.hour;
        row.image = w.image;
        [rows addObject:row];
    }

    self.dataForPrint = sections;

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataForPrint count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.dataForPrint[section].title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    cell.weatherForOneDay = self.dataForPrint[indexPath.section].rows;
    [cell.collectionView reloadData];
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
