//
//  PaymentViewController.h
//  EnjoyFresh
//
//  Created by S Murali Krishna on 10/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "DropDown.h"
#import "FideMeViewController.h"
#import "addNewCard.h"
#import "UIImageView+WebCache.h"
#import "ParseAndGetData.h"
#import "MBProgressHUD.h"
#import "DBClass.h"
#import "CardDetails.h"
#import "ProfileClass.h"

@interface PaymentViewController : UIViewController<DropDownDelegate,parseAndGetDataDelegate,MBProgressHUDDelegate,UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UIAlertViewDelegate>
{
    DropDown *drp;
    IBOutlet UIButton *Proceed_btn;
    ParseAndGetData *parser;
    MBProgressHUD *hud;
    int parseInt,selectdCard,localCardsCount;

    IBOutlet UIImageView *profileImg;
    IBOutlet UIButton *dropDwnBtn;
    IBOutlet UITableView *Card_tbl;
    NSMutableArray *listofcards;
    
    IBOutlet UILabel *UserName;
    BOOL tapbool;
    int tapint ;
    IBOutlet UILabel *doublletap_lbl;
    IBOutlet UILabel *UserEmail;
    NSString *isShopping;
    //OrderConfirmationView *ordCnfView;
    NSDictionary *proDict;
    
    UIPickerView *pickerview;
    UIActionSheet *action;
    UIAlertController *stateActionSheet;
    
    NSArray *keys;
    NSArray *monthsArray;
    NSMutableArray *yearsArray;
    NSString *customerProfileID;
    UIView *imgView;
    
    NSString *selectedState;
    NSString *selectedMonth;
    NSString *selectedYear;
    NSDateComponents *compo;
    NSDictionary *selectedCardDetails;

}
@property(nonatomic,retain) NSDictionary *proDict,*selectedCardDetails;
@property (nonatomic,retain)NSString *dishId,*quantity,*promoType, *currentCardNumber,*customerProfileID;
@property (nonatomic,retain)CardDetails *CurrenCardDetails;
@property (nonatomic,retain)ProfileClass *CurrentUserProfile;
@property (nonatomic,retain)NSString *isShopping;
@property (nonatomic) BOOL fromCheckOut, isLoadAction;

-(void)payMentDone;
- (IBAction)addNewCard:(id)sender;
- (IBAction)showPicker:(id)sender;

-(IBAction)backBtnClicked:(id)sender;
-(IBAction)dropDownBtnClicked:(id)sender;
-(void)getAuthnetCard:(id)sender;
- (IBAction)updateCardDetails:(id)sender;
-(IBAction)processdBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *cardDetailView;
@property (strong, nonatomic) IBOutlet UIButton *cards_btn;
- (IBAction)showCards:(id)sender;
- (IBAction)deleteCard:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblCardNumber;
@property (strong, nonatomic) IBOutlet UILabel *lbltitle;
@property (strong, nonatomic) IBOutlet UIButton *btnAddNewCard;
@property (strong, nonatomic) IBOutlet UIImageView *dopDownImg;

@property (strong, nonatomic) IBOutlet UILabel *lblSaveCard;
@property (strong, nonatomic) IBOutlet UITextField *txtNameOnCard;
@property (strong, nonatomic) IBOutlet UITextField *txtMonth;
@property (strong, nonatomic) IBOutlet UITextField *txtYear;
@property (strong, nonatomic) IBOutlet UITextField *txtCvv;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UITextField *txtZip;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;
@property (strong, nonatomic) IBOutlet UIButton *btnMonth;
@property (strong, nonatomic) IBOutlet UIButton *btnYear;
@property (strong, nonatomic) IBOutlet UIButton *btnState;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UILabel *lblOr;

@end
