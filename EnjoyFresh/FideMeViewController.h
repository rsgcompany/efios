//
//  FideMeViewController.h
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 15/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragOutMenuView.h"
#import "EHDragOutViewBottomToTopStrategy.h"
#import "Find_me_custom.h"
#import "Global.h"
#import "GlobalMethods.h"
#import <MapKit/MapKit.h>
#import "Place.h"
#import "DropDown.h"
#import "PlaceMark.h"
#import "SettingViewController.h"
#import "FideMeViewController.h"
#import "ParseAndGetData.h"
#import "NotificationViewController.h"
#import "FavouriteViewController.h"

@interface FideMeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,parseAndGetDataDelegate,DropDownDelegate>
{
    IBOutlet MKMapView *mapview;
    IBOutlet UIButton *dropDwnBtn;
    UITableView *table;

    DropDown *drp;
}
- (IBAction)Back_Btn:(id)sender;
-(IBAction)dropDownBtnClicked:(id)sender;

@end
