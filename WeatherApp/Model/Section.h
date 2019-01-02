//
//  Created by Nodir Latipov on 12/29/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionRow.h"


@interface Section : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<SectionRow *> *rows;

@end
