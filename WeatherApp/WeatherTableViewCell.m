//
//  Created by Nodir Latipov on 12/28/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import "WeatherTableViewCell.h"
#import "WeatherCollectionViewCell.h"

@interface WeatherTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@end


@implementation WeatherTableViewCell

- (void)setCollectionView:(UICollectionView *)collectionView
{
    _collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.weatherForOneDay.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    SectionRow *row = self.weatherForOneDay[indexPath.row];
    NSString *hour = [NSString stringWithFormat:@"%lu", row.hour];
    cell.weatherForDayLabel.text = hour;
    cell.weatherIconImageView.image = [UIImage imageNamed:row.image]; ;
    cell.temperatureLable.text = [NSString stringWithFormat:@"%.0f ℃", row.temperature];
    return cell;
}

@end
