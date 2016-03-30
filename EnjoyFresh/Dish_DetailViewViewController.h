//
//  Dish_DetailViewViewController.h
//  EnjoyFresh
//
//  Created by Mohnishvardhan on 12/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DropDown.h"
#import "ParseAndGetData.h"
#import "AddedToBag.h"
#import "CommentsViewController.h"
#import "ReviewCustomCell.h"
#import "MapViewAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import "DBClass.h"
#import "FavoritesClass.h"
#import <MessageUI/MessageUI.h>
#import "Global.h"
#import "GlobalMethods.h"
#import <Social/Social.h>
#import "STTwitter.h"
#import "NotifyMeView.h"

@interface Dish_DetailViewViewController : UIViewController<DropDownDelegate,parseAndGetDataDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,DropDownDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate >
{
    DropDown *drp;
    ParseAndGetData *parser;
    
    IBOutlet UILabel *ratingONIMage;
    
    IBOutlet UILabel *titleLbl;

    AddedToBag*addTOBag;
    UIView *imgView;
    int parseInt;
    NotifyMeView *notify;
    IBOutlet UIImageView *Restaurant_img;
    IBOutlet UILabel *Restaurant_desc;
    IBOutlet UILabel *Restaurant_Nme;
    IBOutlet UILabel *Dish_Header_Entree;
    
    IBOutlet UIButton *Dish_like_btn;
    IBOutlet UIButton *Dish_like_btn2;
    IBOutlet UIButton *dropDwnBtn;

    IBOutlet UILabel *Dish_price_lbl;
    IBOutlet UIButton *Dish_Order_Btn;
    IBOutlet UIImageView *Main_Dish_img;
    IBOutlet UIButton *Dish_ingrident_Btn;
    IBOutlet UIButton *Dish_Desc_Btn;
    IBOutlet UIButton *Dish_Availble_Btn;
    IBOutlet UIImageView *restaurant_img2;
    
    
    IBOutlet UILabel *Noreview_Lbl;
    IBOutlet UILabel *price_lbl2;
    IBOutlet UILabel *restaurant_desclbl2;
    IBOutlet UILabel *Restaurant_name_Lbl2;
    IBOutlet UILabel *Rate_lbl;
    IBOutlet UIScrollView *Detail_scroll_view;
    IBOutlet UITextView *Selected_Btn_Display_lbl;
    IBOutlet UILabel *review_lbl;
    NSMutableArray *favarr;
    NSArray *dishiesReview;
    
    IBOutlet UILabel *order_by_lbl;
    
    IBOutlet UILabel *avail_by_lbl;
    IBOutlet UITableView *reviewTbl;
    
    IBOutlet UIButton *btnUnderScore;
    
    IBOutlet UIButton *shareButton;
    
    IBOutlet UIView *shareOptionsView;
    IBOutlet UIButton *fbShareButton;
    IBOutlet UIButton *twitterShareButton;
    IBOutlet UIButton *msgShareButton;
    IBOutlet UIButton *emailShareOption;
    
    IBOutlet UILabel *lblF;
    IBOutlet UILabel *lblT;
    IBOutlet UILabel *lblM;
    IBOutlet UILabel *lblE;
    
    UIPickerView *pickerview;
    UIActionSheet *action;

    NSMutableArray *datesArray;
    NSString  *pageFlag;
    NSArray *restArray;
    UITableView *datesTable;
    UIView *datesView;
    NSArray *arrayDates;

}
@property (strong, atomic)  NSString* pageFlag;
@property (strong, atomic)  NSString* selectedDateInExplore;

@property (strong, nonatomic) IBOutlet UILabel *lblRestName;
@property (strong, atomic)  NSString* selectedFutureDate;
@property (strong, nonatomic) IBOutlet UITextView *dishDesTxtView;

@property (strong, atomic) NSArray *restArray;
@property (strong, atomic) NSArray *arrayDates;

@property (strong, nonatomic)UITableView *datesTable;

@property (strong, atomic) UIView * layerView;
@property (strong, atomic) UIAlertController * searchActionSheet;
@property (strong, nonatomic) IBOutlet UIButton *rightArr;
@property (strong, nonatomic) IBOutlet UIButton *leftArr;

@property (strong, nonatomic) IBOutlet UILabel *rateCount;
@property (nonatomic,strong)NSMutableDictionary *Dish_Details_dic;
@property (strong, nonatomic) IBOutlet MKMapView *RestaurantMap;
@property (nonatomic) CLLocationCoordinate2D restLocation;
@property (strong, nonatomic) NSString *distanceValue;
@property (strong, nonatomic) NSString *restaurantAddress;
@property (nonatomic, retain) FavoritesClass *UserFavorites;
@property (nonatomic, retain)  NSArray *restaur;
@property (nonatomic , strong) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *availLbl;
@property (nonatomic , strong) NSMutableString *currentDishTitle, *currentDishTweet,*currentTweeturl,
*currentDishRestaurant, *currentDishDescription, *currentDishName,*currentDishName1;
@property (strong, nonatomic) IBOutlet UILabel *lblCityState;
@property (nonatomic , strong) UIImage *currentDishImage;
@property (nonatomic) BOOL shareViewIsHidden,dropDownClick;
@property (strong, nonatomic) IBOutlet UIButton *rpp_btn;
@property (strong, nonatomic) IBOutlet UILabel *lblRating;
@property (strong, nonatomic) IBOutlet UIButton *dish_reviews_btn;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UIView *viewForMap;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollImg;
@property (strong, nonatomic) IBOutlet UIPageControl *pagectrl;
@property (strong, nonatomic) IBOutlet UIView *viewForTable;
@property (strong, nonatomic) IBOutlet UIButton *btnSoldout;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *lblStar;
- (IBAction)Restaurant_details_btn:(id)sender;
- (IBAction)scrRight:(id)sender;
- (IBAction)scrLeft:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnReadMore;
@property (strong, nonatomic) IBOutlet UIButton *btnDropDown;

- (IBAction)shareClicked:(id)sender;
- (IBAction)selected_btn_display:(id)sender;
- (IBAction)Like_Btn_Clicked:(id)sender;
- (IBAction)Order_Btn_Clicked:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)menuBtnClicked:(id)sender;
- (IBAction)fbShareCiicked:(id)sender;
- (IBAction)twitterShareClicked:(id)sender;
- (IBAction)emailShareClicked:(id)sender;
- (IBAction)msgShareClicked:(id)sender;
- (IBAction)selectDateClicked:(id)sender;
- (IBAction)readMore:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *descriptinView;
@property (strong, nonatomic) IBOutlet UIView *dishDetailsView;
@property (strong, nonatomic) IBOutlet UIImageView *drpImage;

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@end
