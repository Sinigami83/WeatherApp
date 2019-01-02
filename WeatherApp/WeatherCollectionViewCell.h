//
//  Created by Nodir Latipov on 12/28/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeatherCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *weatherForDayLabel;
@property (nonatomic, weak) IBOutlet UIImageView *weatherIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *temperatureLable;

@end
