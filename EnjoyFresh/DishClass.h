//
//  DishClass.h
//  EnjoyFresh
//
//  Created by Tesla on 07/10/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishClass : NSObject

@property (strong, nonatomic) NSString *dish_avail_by_ampm;
@property (strong, nonatomic) NSString *dish_avail_by_date;
@property (strong, nonatomic) NSString *dish_avail_by_hr;
@property (strong, nonatomic) NSString *dish_avail_by_min;
@property (strong, nonatomic) NSString *dish_avail_by_time;
@property (strong, nonatomic) NSString *dish_available;

@property (strong, nonatomic) NSString *dish_order_by_ampm;
@property (strong, nonatomic) NSString *dish_order_by_date;
@property (strong, nonatomic) NSString *dish_order_by_hr;
@property (strong, nonatomic) NSString *dish_order_by_min;
@property (strong, nonatomic) NSString *dish_order_by_time;

@property (strong, nonatomic) NSString *dish_category_title;
@property (strong, nonatomic) NSString *dish_category_type_id;

@property (strong, nonatomic) NSString *dish_category_commission;
@property (strong, nonatomic) NSString *dish_commission;
@property (strong, nonatomic) NSString *dish_description;
@property (strong, nonatomic) NSString *dish_id;
@property (strong, nonatomic) NSString *dish_rating;
@property (strong, nonatomic) NSString *dish_title;
@property (strong, nonatomic) NSString *dish_type_id;
@property (strong, nonatomic) NSString *dish_price;
@property (strong, nonatomic) NSString *dish_qty;

@property (strong, nonatomic) NSMutableArray *dish_images;
@property (strong, nonatomic) NSMutableArray *dish_ingrediants;
@property (strong, nonatomic) NSMutableArray *dish_dietary;


@end
