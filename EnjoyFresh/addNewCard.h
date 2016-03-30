//
//  addNewCard.h
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 30/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDown.h"
#import "DBClass.h"
#import "CardDetails.h"
#import "ParseAndGetData.h"
#import "MBProgressHUD.h"

@interface addNewCard : UIViewController<UITextFieldDelegate,DropDownDelegate, UIPickerViewDelegate,UIPickerViewDataSource, MBProgressHUDDelegate>
{
    
    DropDown *drp;
    IBOutlet UIButton *visa_Card_btn;
    IBOutlet UIButton *Amex_Card_btn;
    IBOutlet UIButton *Discover_card_btn;
    IBOutlet UIButton *master_card_btn;
    
    ParseAndGetData *parser;
    MBProgressHUD *hud;
    int parseInt;

    IBOutlet UITextField *month_lbl;
    NSDateComponents *compo;
    
    IBOutlet UITextField *year_lbl;
    IBOutlet UILabel *headerLbl;
    IBOutlet UIButton *dropDownBtn;
    IBOutlet UITextField *nameOnCard;
    IBOutlet UITextField *cardNumber;
    IBOutlet UITextField *cVV;
    IBOutlet UITextField *experationDate;
    IBOutlet UITextField *cardAddress;
    IBOutlet UITextField *cardCity;
    IBOutlet UITextField *cardZipCode;
    UIView* dateView;
    
    UIBarButtonItem *barButtonPrev,*barButtonNext;

    IBOutlet UITextField *cardState;
    UIDatePicker *datePicker;
    IBOutlet UIScrollView *scroll;
    
    IBOutlet UIButton *btnStates;
    IBOutlet UIButton *done_Btn_full;

    IBOutlet UIButton *delete_card_btn;
    IBOutlet UIButton *done_btn_half;
    
    UIPickerView *pickerview;
    UIActionSheet *action;
    UIAlertController *stateActionSheet;
    NSArray *keys;
    
    NSString *selectedState;
    NSString *selectedMonth;
    NSString *selectedYear;
    
    NSArray *monthsArray;
    NSMutableArray *yearsArray;
    UIView *imgView;
}
@property (nonatomic,retain)NSDictionary *cardDetails;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic,retain)CardDetails *CurrenCardDetails;

@property (nonatomic) BOOL fromCheckOut, isLoadAction;
@property(nonatomic,retain) NSDictionary *proDict;


- (IBAction)Edit_DoneClicked:(id)sender;
- (IBAction)Delete_btn_clicked:(id)sender;

- (IBAction)Select_card_type:(id)sender;
- (IBAction)dropDownBtnClicked:(id)sender;
- (IBAction)doneBtnClicked:(id)sender;
- (IBAction)expiration_Clicked:(id)sender;
- (IBAction)getStatesPop:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtState;

- (IBAction)showDates:(id)sender;

- (IBAction)backBtnClicked:(id)sender;

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@end
