//
//  ReviewClass.h
//  EnjoyFresh
//
//  Created by Tesla on 07/10/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewClass : NSObject

@property (strong, nonatomic) NSString *dish_id;
@property (strong, nonatomic) NSString *dish_type_id;

@property (strong, nonatomic) NSString *review_date_added;
@property (strong, nonatomic) NSString *review_first_name;
@property (strong, nonatomic) NSString *review_image;
@property (strong, nonatomic) NSString *review_last_name;
@property (strong, nonatomic) NSString *review_rating;
@property (strong, nonatomic) NSString *review_text;
@property (strong, nonatomic) NSString *review_id;
@property (strong, nonatomic) NSString *review_user_id;

@end
