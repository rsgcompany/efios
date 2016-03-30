//
//  NotificationViewController.h
//  EnjoyFresh
//
//  Created by S Murali Krishna on 10/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseAndGetData.h"
#import "DropDown.h"
#import "SettingViewController.h"
#import "FideMeViewController.h"
#import "OrderHistory.h"
@interface NotificationViewController : UIViewController<parseAndGetDataDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,DropDownDelegate>
{
    DropDown *drp;
    ParseAndGetData *parser;
    MBProgressHUD *hud;
    NSArray *notificationArr;
    IBOutlet UITableView *notificationsTbl;
    IBOutlet UILabel *titleLbl;
    IBOutlet UIButton *dropDwnBtn;
    NSArray *dishAvailble;
    UIView *imgView;

}
-(IBAction)backBtnClicked:(id)sender;
-(IBAction)dropDownBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) NSString *dishId;

@end
