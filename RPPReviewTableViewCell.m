//
//  RPPReviewTableViewCell.m
//  EnjoyFresh
//
//  Created by Siva  on 19/06/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import "RPPReviewTableViewCell.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>


@implementation RPPReviewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.userProfileImage.layer.cornerRadius=15.50f;
   // self.userProfileImage.layer.borderWidth=1.0f;
    self.userProfileImage.layer.masksToBounds=YES;
    
    [self.review setFont:[UIFont fontWithName:Regular size:11]];
    self.userName.font=[UIFont fontWithName:Regular size:11.0f];
    self.commentsDate.font=[UIFont fontWithName:Medium size:8.0f];
    self.dishName_lbl.font=[UIFont fontWithName:SemiBold size:11.0f];
    
    self.cellTxtBack.layer.masksToBounds = YES;
    

    self.cellTxtBack.layer.cornerRadius=5.0f;


    //self.userProfileImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
