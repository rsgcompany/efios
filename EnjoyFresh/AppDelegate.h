//
//  AppDelegate.h
//  EnjoyFreshsfsd sdf sdf 
//MOHNISHVARDHAN
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.



// AZ0VKxBmSM_lhTe2n4UpTAMRhSllw1Vwi51e5ga467YTtmuU3j_NjY7ghUSd
 //////up live
// ATU_uBBuOJNnyVp9Et9ynNq0CEkY90v-YfeoDb3E11PfkFjdSuk0xZnqwP7D
 ////test//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DishesViewController.h"
//#import "PaymentViewController.h"
#import "DBClass.h"
#import "ProfileClass.h"
#import "STTwitter.h"
#import <Twitter/Twitter.h>
#import "Registration.h"
#import "Stripe.h"


#import "Mixpanel.h"

@class PaymentViewController;

#define MIXPANEL_TOKEN @"257c40f7035f66f3e0128911860337cb"


@class DishesViewController;
@class HomeViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate, MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>
{
    CLLocationManager *locationManager;
    PaymentViewController *paymentVC;
    
    NSDictionary *addrFromLocation;
    NSString *token;
    NSString *verifier;
}

@property (nonatomic) int orderHistroy_count;
@property(nonatomic,retain)NSString *parse_ObjectId;
@property(nonatomic,retain)NSString *favClickedBeforeLogin;
@property(nonatomic,retain)NSString *resFavClickedBeforeLogin;
@property(nonatomic,retain) NSMutableDictionary *deliveryAddr;
@property(nonatomic,retain) NSDictionary *addrFromLocation;

@property(strong,nonatomic)ProfileClass *CurrentCustomerDetails;
@property (nonatomic, strong) STTwitterAPI *twitterObj;
@property(strong,nonatomic)UINavigationController *nav;
@property(strong,nonatomic)UIWindow *window;
@property(strong,nonatomic)HomeViewController  *homeContrller;
@property(strong,nonatomic)DishesViewController *dishesVC;
@property(strong,nonatomic) PaymentViewController *paymentVC;

@property(strong,nonatomic)NSString *accessToken,*latStr,*longStr;
@property(assign,nonatomic)BOOL isFB,profileChanged, profileUpdated,calendarFLag,reviewSubmit,reviewSubmit1,rememberDateFlag,pushFlag;
@property (nonatomic) BOOL IsProcessComplete,backButtonClick;

@property(nonatomic, strong)    NSString *orderClickedBeforeLogin;
@property(nonatomic, strong)    NSString *orderClickedBeforeLogin1;
@property(nonatomic, strong)    NSString *dateSelected;
@property(nonatomic, strong)    NSString *dateSelectedId;


@property(nonatomic, strong)    NSString *currentTagID;
@property(nonatomic, strong)    DBClass *objDBClass;
@property (nonatomic, retain)   NSString *CurrentRestaurantID;
@property (nonatomic, retain)   NSString *CurrentRestaurantCity;
@property (nonatomic, retain)   NSString *CurrentRestaurantOwner;
@property (nonatomic, retain)   NSString *currentDishId;
//@property (nonatomic, strong)   PFInstallation *currentInstallation;
//@property (nonatomic, strong)   NSString *parseObjectID;
@property (nonatomic, strong)   NSString *DeviceToken;
@property (nonatomic, strong) NSString *token;

@property(nonatomic, strong)    NSString *oauthToken;
@property(nonatomic, strong)    NSString *oauthTokenSecret;

@end
