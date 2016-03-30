//
//  ProfileClass.h
//  EnjoyFresh
//
//  Created by Tesla on 07/10/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileClass : NSObject

@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_devicetoken;
@property (strong, nonatomic) NSString *user_email;
@property (strong, nonatomic) NSString *user_first_name;
@property (strong, nonatomic) NSString *user_image;
@property (strong, nonatomic) NSString *user_is_discount_applied;
@property (strong, nonatomic) NSString *user_is_sweep;
@property (strong, nonatomic) NSString *user_last_name;
@property (strong, nonatomic) NSString *user_mobile;
@property (strong, nonatomic) NSString *user_ref_promo;
@property (strong, nonatomic) NSString *user_ref_promo_count;
@property (strong, nonatomic) NSString *user_zipcode;
@property (strong, nonatomic) NSString *user_fb;
@property (strong, nonatomic) NSString *user_twitter;
@property (strong, nonatomic) NSString *user_password;
@property (strong, nonatomic) NSString *user_auth_id;

@end
