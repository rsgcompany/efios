//
//  Registration.h
//  EnjoyFresh
//pull now
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseAndGetData.h"
#import "MBProgressHUD.h"
#import "DBClass.h"
#import "ProfileClass.h"
#import "STTwitter.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>


@interface Registration : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,FBLoginViewDelegate,parseAndGetDataDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate>
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UITextField *firstNameFld,*emailFld,*mobileFld,*passwdFld,*zipCode,*lastNameFld,*promoFld,*phoneNumber;
    IBOutlet UILabel *titleLbl;
    
    CLLocationManager *locationManager;
    ParseAndGetData *parser;
    MBProgressHUD *hud;
    IBOutlet UIButton *term_lbl,*SweepTakeBtn,*offersBtn,*hyperLnkBtn,*sweepsLink;
    UIBarButtonItem *barButtonPrev,*barButtonNext;
    IBOutlet UIButton *btnCheckOffers;
    NSString *zipString;
    IBOutlet FBLoginView *btnRegFacebook;
    
    IBOutlet UIView *socialView;
    IBOutlet UIButton *socilLoginBtn;
    IBOutlet UIScrollView *socialScroll;
    IBOutlet UITextField *socialEmailFld,*promoFld2;
    
    NSString *twitterScrenNme;
    NSString *twitterId;
    NSDictionary *socialDict;

}
@property (strong, nonatomic) IBOutlet UIView *verificationPopupView;

@property (strong, nonatomic) IBOutlet UITextField *socialPhone;
@property (strong, nonatomic) IBOutlet UITextField *emailFld;
@property (strong, nonatomic) IBOutlet UITextField *passwdFld;
@property (strong, nonatomic) IBOutlet UITextField *zipCode;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;


@property(nonatomic,assign)BOOL fromLogin;
@property(nonatomic,retain)NSDictionary *socialDict;
@property(nonatomic,retain)NSString *loginType;
@property(nonatomic,retain)NSString *zipString;

@property (nonatomic, retain) IBOutlet FBLoginView *FBloginButton;
@property (strong, nonatomic) IBOutlet UIButton *btnTerms;
- (IBAction)showTermsConditions:(id)sender;

@property(nonatomic,strong)ProfileClass *CurrentUserDetails;
@property (nonatomic) BOOL IsInitialRegistration;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)facebookButtonClicked:(id)sender;
- (IBAction)twitterLogin:(id)sender;

-(IBAction)socailBackBtnClicked:(id)sender;
-(IBAction)socailLoginBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnFB;

-(IBAction)BackBtnClicked:(id)sender;
- (IBAction)registrtionBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitter;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) IBOutlet UIButton *btnback2;
@property (strong, nonatomic) IBOutlet UILabel *lblLastStep;
- (IBAction)submitCode:(id)sender;
- (IBAction)resendCode:(id)sender;
- (IBAction)submitCodeFromAhshk:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtCode;
@property (strong, nonatomic) IBOutlet UIView *ahshucksPopup;
- (IBAction)resendCodeFromAhshk:(id)sender;
- (IBAction)removeAhshucks:(id)sender;

- (IBAction)removeVerfication:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *ahsTxtcode;
@property (strong, nonatomic) IBOutlet UITextField *socialZip;

@property (strong, nonatomic) IBOutlet UIView *resendView;
@property (nonatomic, retain) ProfileClass *CurrentUserProfile;
@property (nonatomic, retain) FavoritesClass *UserFavorites;
@property (nonatomic, retain) NSString *CurrentFacebookID;
@property (nonatomic, retain) NSString *CurrentTwitterID;
@property (nonatomic, retain) NSString *CurrentUserPassword;
///////For Twitter
- (void)loginInSafariAction:(id)sender;
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier;
@end
