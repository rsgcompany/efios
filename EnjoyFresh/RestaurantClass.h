//
//  RestaurantClass.h
//  EnjoyFresh
//
//  Created by Tesla on 07/10/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantClass : NSObject

@property (strong, nonatomic) NSString *restaurant_id;
@property (strong, nonatomic) NSString *restaurant_address;
@property (strong, nonatomic) NSString *restaurant_city;
@property (strong, nonatomic) NSString *restaurant_city_tax;
@property (strong, nonatomic) NSString *restaurant_description;
@property (strong, nonatomic) NSString *restaurant_lat;
@property (strong, nonatomic) NSString *restaurant_lon;
@property (strong, nonatomic) NSString *restaurant_owner_name;
@property (strong, nonatomic) NSString *restaurant_phone;
@property (strong, nonatomic) NSString *restaurant_state;
@property (strong, nonatomic) NSString *restaurant_state_tax;
@property (strong, nonatomic) NSString *restaurant_title;
@property (strong, nonatomic) NSString *restaurant_zip;
@property (strong, nonatomic) NSString *restaurant_is_favorite;
@property (strong, nonatomic) NSString *user_id;

@property (strong, nonatomic) NSMutableArray *restaurant_images;

@end
