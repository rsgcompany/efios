//
//  RPPReviewTableViewCell.h
//  EnjoyFresh
//
//  Created by Siva  on 19/06/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface RPPReviewTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *review_str;

@property (strong, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *commentsDate;
@property (strong, nonatomic) IBOutlet UILabel *review;
@property (strong, nonatomic) IBOutlet UILabel *dishName_lbl;
@property (strong, nonatomic) IBOutlet UIImageView *cellTxtBack;

@end
