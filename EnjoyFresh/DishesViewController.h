//
//  DishesViewController.h
//  EnjoyFresh
//mohnish vardhan
//  Created by S Murali Krishna on 09/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
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
#import "CKCalendarView.h"
#import <CoreLocation/CoreLocation.h>

#import "DIshesCustomCell.h"
#import "UIScrollView+DXRefresh.h"
#define stars @"★★★★★"

@class AddedToBag;
@interface DishesViewController : UIViewController<parseAndGetDataDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,DropDownDelegate,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UISearchBarDelegate,DropDownDelegate,PayPalPaymentDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,CLLocationManagerDelegate>
{
    DropDown *drp;
    MBProgressHUD *hud;
    ParseAndGetData *parser;
    AddedToBag *addTOBag;
    int tagint;
    IBOutlet UILabel *titleLbl;
    IBOutlet UITableView *dishes_Tbl;
    IBOutlet UIView *dietaryVw,*location_view,*date_view;
    IBOutlet UISwitch *switch1,*switch2,*switch3,*switch4,*switch5;
    IBOutlet UIButton *dropDwnBtn;
    
    UISearchBar *search_bar;
    UIView* searchLayer;
    UIImageView*  blurView;
    UIPickerView *pickerview;
    NSMutableArray *categoryArr;
    NSMutableArray *offeringTypeArr;

    NSString *selCat;
    UIActionSheet *action;
    NSString *dietryStr;
    NSMutableArray *dishesArr,*dishesCopyArr;
    NSMutableArray *arr1;
    NSMutableArray *array;
    BOOL sliderFirst;
    int parseInt,pickerSelIndex,datePickerSelIndex;
    UIView *viewheader;
    UIButton *dietaryBtn,*locBtn,*catBtn,*dateBtn;
    NSDictionary *currentFavdict;
    IBOutlet UIButton *btnLocUnderScore;
    IBOutlet UIButton *btnDietaryUnderScore;
    IBOutlet UIButton *btnUnderScore;
    IBOutlet UIButton *btnDateUnderScore;
    NSString *catStr,*ditStr,*locStr,*dateStr;
    NSDateFormatter *dteFmter;
    NSDictionary *productDict;
    NSString *qtyStr;
    NSMutableArray *datesArray;
    NSArray *uniqueDatesArray;
    NSString *selectedDate;
    NSString *drpSelectedDate;

    NSString *dishstrId;
    NSString *quantityStr;
    NSDictionary *prodDic;
    NSMutableArray *favsArray;

    NSMutableArray *favarr;
    UIView *imgView;
    CLLocationManager *locationManager;
    NSDictionary *addrFromLocation;
    
    UITableView *datesTable;
    UIView *datesView;
    NSArray *arrayDates;
    DIshesCustomCell *cellToChange;
    NSString *drpSelDate;
    NSInteger totalDishcount;
    BOOL isFetchAll,isLoadMoreData;
}

@property (strong, nonatomic) IBOutlet UILabel *lblHeadLoc;
@property(nonatomic,retain)    NSString *dishstrId;
@property(nonatomic,retain)    NSString *quantityStr;
@property(nonatomic,retain)    NSDictionary *prodDic;
@property (strong, nonatomic) IBOutlet UIButton *btnRefine;

@property (strong, nonatomic) IBOutlet UIButton *btnClearAll;
@property (strong, nonatomic) IBOutlet UIButton *btnCategory;
@property (strong, nonatomic) IBOutlet UIButton *btnOffering;
@property (strong, nonatomic) IBOutlet UIButton *btnDietary;
@property (strong, nonatomic) IBOutlet UIButton *btnDistance;
@property (strong, nonatomic) IBOutlet UIButton *btnDate;
@property (strong, nonatomic) IBOutlet UIView *cuisineDietaryView;
@property (strong, nonatomic) IBOutlet UIView *sliderOfferingView;
@property (strong, nonatomic) IBOutlet UIView *offeringView;

@property (strong, nonatomic) IBOutlet UIScrollView *refineScroll;
@property(nonatomic,retain)NSArray *dishesArr;
@property(nonatomic,retain)NSArray *dishesCopyArr;


@property(nonatomic,retain)    NSMutableArray *Favarr;
@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider;
@property (weak, nonatomic) IBOutlet UILabel *lowerLabel,*upperLabel;
@property (strong, atomic) UIAlertController * searchActionSheet;
@property (strong, atomic) UIView * layerView;

-(IBAction)labelSliderChanged:(NMRangeSlider*)sender;
-(IBAction)menuBtnClicked:(id)sender;
-(void)checkaddtoBagDishID:(NSString*)dishId Quantity:(NSString*)quantity paytype:(NSString*)paytpe product:(NSDictionary*)proctdict;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIPickerView *datePicker;
@property (nonatomic, retain) ProfileClass *CurrentUserProfile;
@property (nonatomic, retain) FavoritesClass *UserFavorites;
@property (nonatomic) BOOL IsInitialLoad;
@property (nonatomic) NSInteger CurrentButtonTag;
@property (strong, nonatomic) IBOutlet UIView *shareView;
@property (nonatomic , strong) NSMutableString *currentDishTitle, *currentDishTweet,*currentTweeturl,
*currentDishRestaurant, *currentDishDescription;
@property (nonatomic , strong) NSMutableString *currentDishName,*currentDishName1;
@property (nonatomic , strong) UIImage *currentDishImage;
@property (strong, nonatomic) IBOutlet UIView *tempView;

@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property (strong, nonatomic) IBOutlet UIView *calendarView;
@property(nonatomic, strong) NSArray *disabledDates;
@property (strong, nonatomic) IBOutlet UIButton *btnUnderscore;
@property (strong, nonatomic) IBOutlet UIScrollView *dateScroll;
@property (nonatomic) BOOL shareViewIsHidden;
- (IBAction)refineSearchMethod:(id)sender;
- (IBAction)resetDistance:(id)sender;
- (IBAction)distaneSearch:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnresetOfferings;
- (IBAction)resetOfferings:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnDatenight;
@property (strong, nonatomic) IBOutlet UIButton *btnCommunal;
@property (strong, nonatomic) IBOutlet UIButton *btnPopUp;
@property (strong, nonatomic) IBOutlet UIButton *btnFoodCases;
@property (strong, nonatomic) IBOutlet UILabel *lowerMiles;
@property (strong, nonatomic) IBOutlet UITextField *txtfindZip;

@property (strong, nonatomic) IBOutlet UILabel *uppermiles;

@property (strong, nonatomic) IBOutlet UIButton *btnDelivery;
@property (strong, nonatomic) IBOutlet UIButton *btnAll;
@property (strong, nonatomic) IBOutlet UIButton *btnDinein;
@property (strong, nonatomic) IBOutlet UIButton *btnPickup;
- (IBAction)deliveryOptions:(id)sender;

- (IBAction)fbShareClicked:(id)sender;
- (IBAction)twitterShareClicked:(id)sender;
- (IBAction)emailShareClicked:(id)sender;
- (IBAction)msgShareClicked:(id)sender;
- (IBAction)showRefineFilters:(id)sender;

- (IBAction)clearRefineFilters:(id)sender;
- (IBAction)offeringTypeSelectedAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSearchNear;

- (IBAction)searchNearMe:(id)sender;
- (IBAction)showNotifications:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnNotifications;

#define SYSTEM_VERSION_LESS_THAN(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@end
