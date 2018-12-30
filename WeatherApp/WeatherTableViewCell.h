//
//  Created by Nodir Latipov on 12/28/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeatherTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger numberSection;
@end

