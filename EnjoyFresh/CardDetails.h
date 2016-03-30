//
//  CardDetails.h
//  EnjoyFresh
//
//  Created by Tesla on 17/10/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardDetails : NSObject

@property (strong, nonatomic) NSString *card_type;
@property (strong, nonatomic) NSString *card_name;
@property (strong, nonatomic) NSString *card_number;
@property (strong, nonatomic) NSString *card_month;
@property (strong, nonatomic) NSString *card_year;
@property (strong, nonatomic) NSString *card_cvv;
@property (strong, nonatomic) NSString *card_address;
@property (strong, nonatomic) NSString *card_city;
@property (strong, nonatomic) NSString *card_state;
@property (strong, nonatomic) NSString *card_zip;
@property (strong, nonatomic) NSString *card_display;

@end
