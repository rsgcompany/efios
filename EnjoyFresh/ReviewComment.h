//
//  ReviewComment.h
//  EnjoyFresh
//
//  Created by Tesla on 07/10/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewComment : NSObject

@property (strong, nonatomic) NSString *review_id;
@property (strong, nonatomic) NSString *review_comment_text;
@property (strong, nonatomic) NSString *review_comment_id;
@property (strong, nonatomic) NSString *review_comment_date_added;
@property (strong, nonatomic) NSString *review_comment_first_name;
@property (strong, nonatomic) NSString *review_comment_last_name;
@property (strong, nonatomic) NSString *review_comment_user_id;

@end
