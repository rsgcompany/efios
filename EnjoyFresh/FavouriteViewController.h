//
//  FavouriteViewController.h
//  EnjoyFresh
//
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "ParseAndGetData.h"
#import "DropDown.h"
#import "FideMeViewController.h"
#import "FavoritesClass.h"
#import "DBClass.h"
#import "RestaurantDetailViewController.h"
@interface FavouriteViewController : UIViewController<MBProgressHUDDelegate,parseAndGetDataDelegate,DropDownDelegate>
{
    ParseAndGetData *parser;
    DropDown *drp;
    MBProgressHUD *hud;

    NSArray *favoritsArr;
    NSMutableArray *favsArray;
    IBOutlet UITableView *favrtTbl;
    IBOutlet UILabel *titleLbl;
    IBOutlet UIButton *dropDwnBtn;
    UIView *imgView;
    NSMutableDictionary *required;
}
-(IBAction)backBtnClicked:(id)sender;
-(IBAction)dropDownBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, retain) FavoritesClass *UserFavorites;
@end
