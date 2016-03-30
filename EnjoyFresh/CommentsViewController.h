//
//  CommentsViewController.h
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 08/09/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewCustomCell.h"
@interface CommentsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    IBOutlet UITextView *review_lbl;
    IBOutlet UILabel *review_Name;
    IBOutlet UILabel *header_lbl;
    IBOutlet UITableView *comments;
    NSArray *comments_arr;
    IBOutlet UIView *T_view;
    IBOutlet UILabel *nocomments_lbl;
    IBOutlet UIScrollView *scroll;
    
}
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic,retain) NSString *dishName;
@property (strong, nonatomic) IBOutlet UILabel *replies;

@property (nonatomic,retain)NSDictionary *review_comments;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *lblRating;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblStar;
@property (strong, nonatomic) IBOutlet UILabel *lblDishName;

- (IBAction)back_Btn_clicked:(id)sender;

@end
