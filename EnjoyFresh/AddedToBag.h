//
//  AddedToBag.h
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 19/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishesViewController.h"
#import "ParseAndGetData.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>


@interface AddedToBag : UIViewController<parseAndGetDataDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate >
{
    float price;
    
    IBOutlet UILabel *Hearder_lbl;
    IBOutlet UILabel *Dish_Name;
    IBOutlet UILabel *Chef_Name;
    IBOutlet UILabel *Dish_Type;
    IBOutlet UILabel *Ingredient;
    IBOutlet UILabel *Availability;
    NSDictionary * checkOutArr;
    CLLocationManager *locationManager;

    IBOutlet UIButton *Quantity_Plus_Btn;

    IBOutlet UILabel *Quantity;
    IBOutlet UIButton *Quantity_Minus_Btn;
    IBOutlet UIButton *AddToBag_Btn;
    IBOutlet UIButton *Cancel_Btn;
    NSString *qty_available;
    IBOutlet UILabel *promoType_order;
    
    IBOutlet UIView *checkOutVw,*firstScren;
    
    IBOutlet UILabel *PromoTypeValue;
    MBProgressHUD *hud;
    ParseAndGetData *parser;
    int parseInt;
    IBOutlet UILabel *Price_lbl;

    IBOutlet UIImageView *Dishimage;
////// Chekout Screen
    IBOutlet UILabel *Hearder_checkout;
    //// Right and top labels
    IBOutlet UILabel *dishLocation_Order;
    IBOutlet UILabel *DishName_Order;
    IBOutlet UILabel *DishRestaurant_order;
    IBOutlet UILabel *Qty_Order;
    IBOutlet UILabel *ActualDishAmt_Order;
    IBOutlet UILabel *discountAmt_Order;
    IBOutlet UILabel *TaxAmt_Order;
    IBOutlet UILabel *TotalAmt_Order;
    /// left label
    IBOutlet UILabel *Qty_order_left;
    IBOutlet UILabel *actualDishAmt_Order_Left;
    IBOutlet UILabel *discountamt_order_Left;
    IBOutlet UILabel *Totalamt_Order_left;
    IBOutlet UILabel *Tax_Order_left;

    IBOutlet UIButton *OrderNowBtn;

    IBOutlet UIButton *payPal_btn;
    IBOutlet UIButton *authNet_btn;
    IBOutlet UILabel *AvileOfferPromo;
    IBOutlet UIButton *Refer_Btn;
    IBOutlet UIButton *First_Btn;
    IBOutlet UIButton *Sweep_Btn;
    
    IBOutlet UIButton *credit_btn;
    
    IBOutlet UIButton *none_btn;
    
    IBOutlet UIButton *splPromo_btn;
    IBOutlet UILabel *remainingCredit_btn;
    IBOutlet UIImageView *dishImage2;
    UIView *optsView;
    UIView *addressView1;
    UITableView *addressTable;
    NSMutableArray *addrssArray;
    NSMutableArray *deliveryAdd;
    NSMutableDictionary *addressDict;
    NSString *addressId;
    UIPickerView *pickerView;
    UIAlertController *stateActionSheet;
    UIActionSheet *action;
    NSString *selectedState;
    NSDictionary *addrFromLocation;
    UITableView *datesTable;
    UIView *datesView;
    NSMutableArray *datesArray;
    NSArray *arrayDate;
    int selectedIndx;
    UIScrollView *tipsView;
    
    IBOutlet UIView *promoView,*tipSubView;
    IBOutlet UILabel *tipLabel;
    IBOutlet UIButton *choseOfferBtn;
    
    IBOutlet UIImageView *deliveryImage;

}
@property(nonatomic,retain) NSArray *states;
@property(nonatomic,retain) NSArray *arrayDate;
@property(nonatomic,assign) int selectedIndx;
@property(nonatomic,retain)NSDictionary *Item_details;
@property(nonatomic,retain)NSString *pageFlag;
@property(nonatomic,retain) NSMutableArray *addrssArray;
@property(nonatomic,retain) NSMutableArray *deliveryAdd;
@property(nonatomic,retain) NSMutableDictionary *addressDict;
@property(nonatomic,retain) NSString *addressId;
@property(nonatomic,retain) NSString *selectedState;
@property(nonatomic,retain) NSString *selectedFutureDate;
@property (strong, nonatomic)UITableView *datesTable;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNum;

@property (strong, nonatomic) IBOutlet UIImageView *drpImage;

@property (strong, nonatomic) IBOutlet UIButton *btndropDown;

@property (strong, nonatomic) IBOutlet UIButton *apply_btn;
@property (strong, nonatomic) IBOutlet UILabel *remainLbl;
- (IBAction)select_payment:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *promoTxt;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
- (IBAction)Promo_offerBtn_Clicked:(id)sender;
-(IBAction)checkoutClicked:(id)sender;
- (IBAction)applyPromo:(id)sender;
- (IBAction)showDates:(id)sender;

- (IBAction)Qty_Plus_Minus:(id)sender;
- (IBAction)addToBagBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblbAddress;
@property (strong, nonatomic) IBOutlet UIButton *promoCodeBtn;
@property (strong, nonatomic) IBOutlet UIView *offerView;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UITextField *txtZip;
@property (strong, nonatomic) IBOutlet UIButton *btnDineOpt;
@property (strong, nonatomic) IBOutlet UIView *payselView;
- (IBAction)showDineOpts:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *totalView;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UILabel *lbldate1;
@property (strong, nonatomic) IBOutlet UIView *zipcodePopupView;
@property (strong, nonatomic) IBOutlet UITextField *txtSuiteNo;
@property (strong, nonatomic) IBOutlet UITextField *txtInstructions;
@property (strong, nonatomic) IBOutlet UIButton *btnPopCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnPopSubmit;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) IBOutlet UITextField *phoneText;
@property (strong, nonatomic) IBOutlet UITextField *zipText;
- (IBAction)submitForNotification:(id)sender;
- (IBAction)removeZipPopup:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *addressView;
@property (strong, nonatomic) IBOutlet UIButton *btnAddress;
- (IBAction)showAddress:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtAddrs;
@property (strong, nonatomic) IBOutlet UITextField *txtAdrs;
@property (strong, nonatomic) IBOutlet UIButton *btnStates;
@property (strong, nonatomic) IBOutlet UIButton *btnAddnewAddr;
@property (strong, nonatomic) IBOutlet UIButton *btnTips;


- (IBAction)newAddress:(id)sender;

- (IBAction)showStates:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *dropDown;
- (IBAction)Cancel_Btn_Clicked:(id)sender;
- (IBAction)closeZippopup:(id)sender;
@end
