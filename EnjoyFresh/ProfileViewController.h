//
//  ProfileViewController.h
//  EnjoyFresh
//
//  Created by S Murali Krishna on 10/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseAndGetData.h"
#import "DropDown.h"
#import "FideMeViewController.h"
#import "MBProgressHUD.h"
@interface ProfileViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,parseAndGetDataDelegate,DropDownDelegate,MBProgressHUDDelegate,UINavigationControllerDelegate>
{
    MBProgressHUD *hud;
    ParseAndGetData *parser;
    DropDown *drp;
    
    IBOutlet UIActivityIndicatorView *imgLoadActivity;

    IBOutlet UIImageView *profileImg;
    IBOutlet UIScrollView *scroll;
    IBOutlet UITextField *firstNameFld,*lastNameFld,*zipFLd,*emailFld,*mobileFld;
    IBOutlet UILabel *emailLbl,*titleLbl,*userNmeLbl;
    IBOutlet UIButton *dropDwnBtn,*updateBtn;
    
    IBOutlet UITextField *txtPassword;
    int parseInt;
    UIImagePickerController * imagePicker;
    UIBarButtonItem *barButtonPrev,*barButtonNext;
    UIView *imgView;
}
@property(nonatomic,strong)NSData *imgData;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property(nonatomic,strong) NSMutableArray *dict;
-(IBAction)backBtnClicked:(id)sender;
-(IBAction)dropDownBtnClicked:(id)sender;
-(IBAction)updateBtnclicked:(id)sender;
@end

