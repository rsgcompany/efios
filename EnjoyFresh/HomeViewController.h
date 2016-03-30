//
//  HomeViewController.h
//  EnjoyFresh
//ds 
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishesViewController.h"
#import "STTwitter.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>


@interface HomeViewController : UIViewController <UIScrollViewDelegate,UITextViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UIButton *loginBtn,*registerBtn;
    IBOutlet UIScrollView *scroll;
//    IBOutlet UIView *bottomVw;
//    IBOutlet UILabel *botomTxtLbl;
    NSArray *imgsArr;
    NSMutableArray *textBoxArr,*headingArr;
    IBOutlet UIPageControl *pagecontroler;
    int _contentWidth;
    int parseInt;
    
    IBOutlet FBLoginView *btnRegFacebook;
    IBOutlet UIView *socialView;
    IBOutlet UIButton *socilLoginBtn;
    IBOutlet UIScrollView *socialScroll;
    IBOutlet UITextField *socialEmailFld,*promoFld;
    IBOutlet UIImageView *emailImg;

    CLLocationManager *locationManager;

    IBOutlet UIButton *ContincueAsguest_Btn;
    
    NSString *twitterScrenNme;
    MBProgressHUD *hud;
    NSString *twitterId;
    NSDictionary *socialDict;
    ParseAndGetData *parser;

}

///////For Twitter
- (void)loginInSafariAction:(id)sender;
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier;
@property (strong, nonatomic) IBOutlet UILabel *lblHeading;
@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIButton *btnSignin;


-(IBAction)LoginBtnClicked:(id)sender;
-(IBAction)RegisterBtnClicked:(id)sender;
-(IBAction)socailBackBtnClicked:(id)sender;
-(IBAction)socailLoginBtnClicked:(id)sender;

@property(nonatomic,retain)NSString *zipString;

@property (strong, nonatomic) IBOutlet UIButton *btnGuest;

@property (nonatomic, retain) ProfileClass *CurrentUserProfile;
@property (nonatomic, retain) FavoritesClass *UserFavorites;
@property (nonatomic, retain) NSString *CurrentFacebookID;
@property (nonatomic, retain) NSString *CurrentTwitterID;
@property (nonatomic, retain) NSString *CurrentUserPassword;
@end
