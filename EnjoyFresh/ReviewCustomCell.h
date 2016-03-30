//
//  ReviewCustomCell.h
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 08/09/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewCustomCell : UITableViewCell
{
    
}
@property(nonatomic,retain) IBOutlet UILabel *review_date,*review_rgt,*name_rgt,*User_review,*Name;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *lblStar;

@end
