//
//  LoginViewController.h
//  EnjoyFresh
//
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseAndGetData.h"
#import "MBProgressHUD.h"
#import "DBClass.h"
#import "ProfileClass.h"
#import "FavoritesClass.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "WebViewVC.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface LoginViewController : UIViewController<UITextFieldDelegate,parseAndGetDataDelegate,MBProgressHUDDelegate,FBSDKLoginButtonDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet UITextField *emailFld;
    IBOutlet UITextField *passwdFld;
    IBOutlet UILabel *orLBl,*titleLBl;
    IBOutlet UIButton *facebookBtn,*twitterBtn, *twitterBtn2, *forgotBtn,*loginBtn,*hyperLnkBtn,*sweepsLink;
    IBOutlet UIScrollView *scroll;
    
    int parseInt;
    CLLocationManager *locationManager;

    NSString *twitterScrenNme;

  //  NSString *emailToSend;

    IBOutlet UILabel *lblRegister;
    ParseAndGetData *parser;
    MBProgressHUD *hud;
    BOOL fromReg;

    IBOutlet UIButton *btnFacebookReg2;
    ///////////////social loginview buttons///////////////
    IBOutlet UITextField *socialEmailFld,*zipFld,*promoFld,*phoneFld;
    IBOutlet UIButton *agressBtn,*OffersBtn,*acceptBtn;
    IBOutlet UIScrollView *socialScroll;
    IBOutlet UIView *socialView;
    IBOutlet UILabel *socilTitle,*socialLbl;
    IBOutlet UIButton *socilLoginBtn;
    IBOutlet UIImageView *emailImg;
    UIBarButtonItem *barButtonPrev,*barButtonNext;
    NSDictionary *socialDict;
    NSString *twitterId;
    IBOutlet UIView *btnRegFacebook;
    IBOutlet UIButton *btnRegTwitter;
    IBOutlet UIButton *btnRegister;
    IBOutlet UIView *InitialRegistration;
    NSMutableArray *favArray;
}
@property (nonatomic, retain) IBOutlet FBLoginView *loginButton, *loginButton2;;
@property (nonatomic) BOOL IsInitialRegistration;

@property (nonatomic, strong)  UITextField *currentTextField;
//@property (nonatomic, retain)    NSString *emailToSend;

@property (strong, nonatomic) IBOutlet UITextField *socialZip;

- (IBAction)RegisterButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)twitterBtnClicked:(id)sender;


-(IBAction)loginBtnClicked:(id)sender;
-(IBAction)forgotPwdBtnClicked:(id)sender;
-(IBAction)BackBtnClicked:(id)sender;
///////For Twitter
- (void)loginInSafariAction:(id)sender;
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier;
///////////////social loginview buttons///////////////

- (IBAction)heperLinkClicked:(id)sender;
;
- (IBAction)resendCode:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *submitCode;
@property (strong, nonatomic) IBOutlet UILabel *errorTextLable;
@property (strong, nonatomic) IBOutlet UIView *submitView;
@property (strong, nonatomic) IBOutlet UIView *ahshucksView;
@property (nonatomic, retain) NSString *zipString;

@property (strong, nonatomic) IBOutlet UIButton *btnSignin;
@property (nonatomic, retain) ProfileClass *CurrentUserProfile;
@property (nonatomic, retain) FavoritesClass *UserFavorites;
@property (nonatomic, retain) NSString *CurrentFacebookID;
@property (nonatomic, retain) NSString *CurrentTwitterID;
@property (nonatomic, retain) NSString *CurrentUserPassword;
@property (strong, nonatomic) IBOutlet UILabel *lblNotReg;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
- (IBAction)registerBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *socialPhone;
- (IBAction)submitCode:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtCode;
@property (strong, nonatomic) IBOutlet UIButton *socialBackBtn;
@property (strong, nonatomic) IBOutlet UIView *verificationPopup;

@property (strong, nonatomic) IBOutlet UITextField *txtVerfCode;
- (IBAction)submitFromVerification:(id)sender;
- (IBAction)resendFromVerification:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *ahtxtCode;
- (IBAction)removeAhshucks:(id)sender;
- (IBAction)removeVerification:(id)sender;

@end
