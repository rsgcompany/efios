//
//  OderHistoryDetail.h
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 26/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "GlobalMethods.h"
#import "DropDown.h"
#import "AddedToBag.h"
#import "ParseAndGetData.h"
#import "MBProgressHUD.h"
#import "ReviewViewController.h"
@interface OderHistoryDetail : UIViewController<DropDownDelegate,UITextViewDelegate,parseAndGetDataDelegate,UIScrollViewDelegate,MBProgressHUDDelegate>
{
    
    DropDown *drp;
    AddedToBag *addTOBag;
    ParseAndGetData *parser;
    MBProgressHUD *hud;

    int parseint;

    
    IBOutlet UIImageView *dish_img;

    IBOutlet UILabel *total_paid;
    IBOutlet UILabel *Location;
    IBOutlet UILabel *dish_restaurent;
    IBOutlet UILabel *dish_name;
    IBOutlet UILabel *Oder_quantity;
    IBOutlet UILabel *Order_id;
    IBOutlet UILabel *Dish_amount;
    IBOutlet UILabel *dish_discount_applied;
    IBOutlet UILabel *dish_discount_amount;
    IBOutlet UILabel *Actual_amount_paid;
    IBOutlet UILabel *tax_left;
    
    IBOutlet UILabel *tax_amount;
    IBOutlet UIButton *Star1;
    IBOutlet UIButton *Star5;
    IBOutlet UIButton *Star4;
    IBOutlet UIButton *Star3;
    IBOutlet UIButton *star2;
    IBOutlet UIButton *order_again_btn;
    IBOutlet UIButton *drop_downBtn;
    IBOutlet UIButton *Submit_Btn;

    IBOutlet UITextView *Review_text;
    
    IBOutlet UILabel *discount_amt_left;
    IBOutlet UILabel *quantity_left;
    IBOutlet UILabel *amount_paid_left;
    IBOutlet UILabel *Actaul_dish_amt_left;
    IBOutlet UILabel *OrderId_left;
    IBOutlet UILabel *discount_applied_left;
    IBOutlet UILabel *RateANDReview_left;
    IBOutlet UILabel *Hearder;
    
    IBOutlet UILabel *payment_mode_label;
    IBOutlet UILabel *payment_mode_value;
    
    IBOutlet UILabel *order_date_label;
    IBOutlet UILabel *order_date_value;
    
    IBOutlet  UIScrollView *scroll;
    
    int dish_Rating;
    
    IBOutlet UIButton *seeMoreReviewsBtn;
    IBOutlet UILabel *User_rating;
    IBOutlet UIButton *Delete_ReviewBtn;
    
    
    NSArray *all_review;
    NSArray *dishAvailble;
    UIView *imgView;
    NSString *reviewid;
}
@property (strong, nonatomic) IBOutlet UILabel *lblAvlDate;
@property(nonatomic,retain)NSString *userid;
@property(nonatomic,retain)NSString *reviewid;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

@property(nonatomic,retain)NSDictionary *Orderdetails_dict;
- (IBAction)Back_btn:(id)sender;
- (IBAction)SeeMoreBtn_clicked:(id)sender;
- (IBAction)deleteBtnClicked:(id)sender;
- (IBAction)Star_btn_clicked:(id)sender;
- (IBAction)order_btn_clicked:(id)sender;
- (IBAction)ropDownBtnClicked:(id)sender;

- (IBAction)Submit_Btn_Clicked:(id)sender;

@end
