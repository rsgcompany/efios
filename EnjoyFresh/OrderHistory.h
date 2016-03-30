//
//  OrderHistory.h
//  EnjoyFresh
//
//  Created by S Murali Krishna on 10/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseAndGetData.h"
#import "DropDown.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"


@interface OrderHistory : UIViewController<parseAndGetDataDelegate,DropDownDelegate,MBProgressHUDDelegate>
{
    ParseAndGetData *parser;
    DropDown *drp;
    
    NSArray *ordersArr;
    NSArray *copyOrdersArr;

    NSMutableArray *pastOrdersArray;
    NSMutableArray *latestOrdersArray;

    IBOutlet UITableView *orderTbl;
    IBOutlet UILabel *titleLbl;
    IBOutlet UIButton *dropDwnBtn;
    NSString *User_id;
    
    BOOL viewDidLoad;
    MBProgressHUD *hud;
    UIView *imgView;
}
@property (nonatomic,assign) BOOL fromNotif;
@property (strong, nonatomic) NSString *dishId;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
-(IBAction)backBtnClicked:(id)sender;
-(IBAction)dropDownBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentCtrl;
- (IBAction)selectedActionSegment:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
