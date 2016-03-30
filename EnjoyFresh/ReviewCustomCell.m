//
//  ReviewCustomCell.m
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 08/09/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "ReviewCustomCell.h"
#import "Global.h"
@implementation ReviewCustomCell
@synthesize review_date,review_rgt,name_rgt,User_review,Name;

- (void)awakeFromNib
{
        // Initialization code
    
   // [name_rgt setFont:[UIFont fontWithName:Bold size:15]];
        [Name setFont:[UIFont fontWithName:ExtraBold size:11]];
        [review_rgt setFont:[UIFont fontWithName:SemiBold size:10]];
    
        [User_review setFont:[UIFont fontWithName:Regular size:11]];
        [review_date setFont:[UIFont fontWithName:Medium size:10]];
        
    self.userImage.layer.cornerRadius=16.0f;
    // self.userProfileImage.layer.borderWidth=1.0f;
    self.userImage.layer.masksToBounds=YES;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
