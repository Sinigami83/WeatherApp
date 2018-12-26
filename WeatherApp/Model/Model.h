//
//  Created by Nodir Latipov on 12/25/18.
//  Copyright © 2018 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Model : NSObject
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *temerature;
@property (nonatomic, assign) NSUInteger hour;
@property (nonatomic, strong) NSURL *image;

- (instancetype)initWithServerResponse:(NSDictionary *)responseObject;

@end
