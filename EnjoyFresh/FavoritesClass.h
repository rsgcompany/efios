//
//  FavoritesClass.h
//  EnjoyFresh
//
//  Created by Tesla on 07/10/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoritesClass : NSObject

@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *restaurant_id;
@property (strong, nonatomic) NSString *restaurant_city;
@property (strong, nonatomic) NSString *restaurant_title;
@property (strong, nonatomic) NSString *restaurant_is_favorite;
@property (strong, nonatomic) NSString *restaurant_image_thumbnail;

@property (strong, nonatomic) NSMutableArray *restaurant_images_large;
@property (strong, nonatomic) NSMutableArray *restaurant_images_small;


@end
