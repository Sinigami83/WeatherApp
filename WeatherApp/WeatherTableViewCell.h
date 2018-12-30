//
//  Created by Nodir Latipov on 12/28/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionRow.h"

@interface WeatherTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<SectionRow *> *weatherForOneDay;

- (void)setCollectionView:(UICollectionView *)collectionView;
@end

