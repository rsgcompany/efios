//
//  RestaurantDetailViewController.h
//  EnjoyFresh
//
//  Created by Siva  on 11/06/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import <MapKit/MapKit.h>
#import "ParseAndGetData.h"
#import "MBProgressHUD.h"
#import "SettingViewController.h"
#import "DropDown.h"
#import "NMRangeSlider.h"
#import "AddedToBag.h"
#import "UIImage+StackBlur.h"
#import "PaymentViewController.h"
#import "PayPalMobile.h"

#import "DBClass.h"
#import "ProfileClass.h"
#import "FavoritesClass.h"
#import "MapViewAnnotation.h"

@class AddedToBag;

@interface RestaurantDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate, CLLocationManagerDelegate,MBProgressHUDDelegate,parseAndGetDataDelegate,UIAlertViewDelegate>{
   
    AddedToBag *addTOBag;
    DropDown *drp;

    NSMutableArray *refinedArray;
    NSMutableArray *dateaAddedArr;
    NSMutableArray *userNamesArr;
    NSMutableDictionary *restaurantArray;
    MBProgressHUD *hud;
    ParseAndGetData *parser;
    NSArray *dishes;
    NSArray *dishImages;
    NSDictionary *detailsDict;
    MKMapView *mapLView;
    NSMutableArray *reviewsArray;
    NSMutableArray *dishTitles;
    NSMutableArray *favarr;

    IBOutlet UIView *shareOptionsView;
    IBOutlet UIButton *fbShareButton;
    IBOutlet UIButton *twitterShareButton;
    IBOutlet UIButton *msgShareButton;
    IBOutlet UIButton *emailShareOption;
    
    IBOutlet UILabel *lblF;
    IBOutlet UILabel *lblT;
    IBOutlet UILabel *lblM;
    IBOutlet UILabel *lblE;
    UIView *imgView;
}

@property (nonatomic , strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D restLocation;
@property (strong, nonatomic) NSString *restaurantAddress;
@property (strong, nonatomic) NSString *distanceValue;
@property (strong, nonatomic) IBOutlet UILabel *restName;
@property (strong, nonatomic) IBOutlet UILabel *restName1;
@property (nonatomic) BOOL shareViewIsHidden;
@property (nonatomic, retain) FavoritesClass *UserFavorites;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic , strong) NSMutableString *currentDishTitle, *currentDishTweet,
*currentDishRestaurant, *currentDishDescription, *currentDishName,*currentTweeturl;
@property (nonatomic , strong) UIImage *currentDishImage;

@property (strong,nonatomic) NSMutableDictionary *restaurantArray;
@property (strong, nonatomic) IBOutlet UIView *headerForReviews;
@property (strong, nonatomic) IBOutlet UIView *headerForDishes;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)menu_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *dropDownBtn;
- (IBAction)fbShaeClicked:(id)sender;
- (IBAction)twitterShareClicked:(id)sender;
- (IBAction)messageShareClicked:(id)sender;
- (IBAction)emailShareClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *locationView;
@property (strong, nonatomic) IBOutlet UILabel *lblNoReview;
@property (strong, nonatomic) IBOutlet UITableView *reviewTable;
@property (strong, nonatomic) IBOutlet UIButton *btnLocation;
@property (strong, nonatomic) IBOutlet UIButton *btnReviews;
- (IBAction)showReviews:(id)sender;
- (IBAction)showLocation:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblestName;
@property (strong, nonatomic) IBOutlet UILabel *lblResAddress;
@property (strong, nonatomic) IBOutlet MKMapView *mapview;
@property (strong, nonatomic) IBOutlet UIButton *btnFav;
- (IBAction)setFav:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnUnderScore;
@property (strong, nonatomic) IBOutlet UILabel *rCount;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *btnDishes;
- (IBAction)showDishes:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *dishesView;
@property (strong, nonatomic) IBOutlet UIView *detailsView;
@property (strong, nonatomic) IBOutlet UITableView *dishesTable;
@property (strong, nonatomic) IBOutlet UILabel *lblRestName;
@property (strong, nonatomic) IBOutlet UILabel *lblStar;
@property (strong, nonatomic) IBOutlet UILabel *lblRemStar;
@property (strong, nonatomic) IBOutlet UITextView *txtResDes;
@property (strong, nonatomic) IBOutlet UIButton *btnReadMore;
@property (strong, nonatomic) IBOutlet UIImageView *restImage;
@property (strong, nonatomic) IBOutlet UIScrollView *imgScroll;
@property (strong, nonatomic) IBOutlet UIButton *btnRight;
@property (strong, nonatomic) IBOutlet UIButton *btnleft;
@property (strong, nonatomic) IBOutlet UIView *descriptionView;
- (IBAction)readMoreLess:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *reviewsView;
@end
