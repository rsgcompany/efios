//
//  LoginViewController.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "LoginViewController.h"
#import "GlobalMethods.h"
#import "Global.h"
#import "DishesViewController.h"
#import "STTwitter.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "Registration.h"



@interface LoginViewController ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@end
//static NSString *apiKey=@"yW7fcaIoF7bafrFFHUk5Rsbej";
//static NSString *consumerKey=@"55VF3trdWOdMskhuhCrAosxE96k9mg92FMnAOYAriqWbYWjWTD";

static NSString *apiKey=@"TJqDoM0AJyeLnZYCQQJIfuyNm";
static NSString *consumerKey=@"yIPITPHBFJ7CuwN857MvtGwflwF0ViZa7D3YEa78VjW9z98tx4";
NSString *emailToSend;
NSString *dupEmail;

@implementation LoginViewController
@synthesize loginButton, loginButton2;
@synthesize  CurrentUserProfile, CurrentFacebookID, CurrentTwitterID, CurrentUserPassword, currentTextField;
#define FIELDS_COUNT  3

#pragma mark -
#pragma mark - ViewcontrollerLifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIBarButtonItem appearance] setTitleTextAttributes: [GlobalMethods barbuttonFont] forState:UIControlStateNormal];
    
    
    NSAttributedString * email1 = [[NSAttributedString alloc] initWithString:@"Your Email" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    emailFld.attributedPlaceholder = email1;
    NSAttributedString * PW = [[NSAttributedString alloc] initWithString:@"Your Password" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    passwdFld.attributedPlaceholder = PW;
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);
    self.socialBackBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);


    // Do any additional setup after loading the view from its nib.
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self updateCurrentLocation];

    CALayer *layer = [self.btnSignin layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    self.btnSignin.titleLabel.font=[UIFont fontWithName:Bold size:15];
    forgotBtn.titleLabel.font=[UIFont fontWithName:SemiBold size:13];
    
    self.lblNotReg.font=[UIFont fontWithName:Bold size:14];
    self.btnSignUp.titleLabel.font=[UIFont fontWithName:SemiBold size:14];
    self.ahshucksView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.verificationPopup.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];

//    ////////////// Set Place Holder Text
//    emailFld=[GlobalMethods setPlaceholdText:@"Your email" forTxtFld:emailFld];
//    passwdFld=[GlobalMethods setPlaceholdText:@"Your password" forTxtFld:passwdFld];
    
    btnRegFacebook.backgroundColor=[UIColor clearColor];
    btnRegFacebook.readPermissions=@[@"public_profile", @"email", @"user_friends",@"user_birthday"];
    btnRegFacebook.frame=CGRectMake(13, 79, 145, 27);
    
    for (id loginObject in btnRegFacebook.subviews)
    {
        if ([loginObject isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton1 =  loginObject;
            [loginButton1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [loginButton1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
            [loginButton1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
            
            loginButton1.titleLabel.font=[UIFont fontWithName:Regular size:17.0f];
            
            [loginButton1 setTitle:@"" forState:UIControlStateSelected];
            loginButton1.layer.cornerRadius=4.0f;
            loginButton1.backgroundColor=[UIColor colorWithRed:59.0f/255.0f green:89.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            loginButton1.backgroundColor=[UIColor clearColor];
            
            [loginButton1 addTarget:self action:@selector(facebookBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([loginObject isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  loginObject;
            loginLabel.text = @"";
            loginLabel.frame = CGRectMake(-40, 0, 300, 30);
            loginLabel.alpha=0.0f;
            loginLabel.font=[UIFont systemFontOfSize:14.0f];
        }
    }
    
    
    //////////////
//    socialEmailFld=[GlobalMethods setPlaceholdText:@"Your email" forTxtFld:socialEmailFld];
//    zipFld=[GlobalMethods setPlaceholdText:@"Your Zipcode" forTxtFld:zipFld];
//    promoFld=[GlobalMethods setPlaceholdText:@"Enter PromoCode" forTxtFld:promoFld];
    socilLoginBtn.titleLabel.font=[UIFont fontWithName:Regular size:16.0f];
    socilTitle.font=[UIFont fontWithName:Regular size:18.0f];
    [socialLbl setFont:[UIFont fontWithName:SemiBold size:18.0f]];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClicked:)];
    barButtonPrev = [[UIBarButtonItem alloc] initWithTitle:@"Prev"  style:UIBarButtonItemStyleDone target:self action:@selector(previousButtonClicked:)];
    barButtonNext = [[UIBarButtonItem alloc] initWithTitle:@"Next"  style:UIBarButtonItemStyleDone target:self action:@selector(nextButtonClicked:)];
    
    
    
    
    NSArray *itemsArray = @[barButtonPrev,barButtonNext,flexableItem,doneButton];
    [toolbar setItems:itemsArray];
    [zipFld setInputAccessoryView:toolbar];
    [promoFld setInputAccessoryView:toolbar];
    [socialEmailFld setInputAccessoryView:toolbar];
}

- (IBAction)RegisterButtonClicked:(id)sender;
{
    Registration *regist=[[Registration alloc]initWithNibName:@"Registration" bundle:nil];
    [self.navigationController pushViewController:regist animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(fromReg)
    {
        fromReg=NO;
    }
    NSDictionary *dict=[[NSUserDefaults standardUserDefaults]valueForKey:@"credentials"];
    if (dict!=nil) {
        emailFld.text=[dict valueForKey:@"Email"];
        passwdFld.text= [dict valueForKey:@"Password"];
        CurrentUserPassword = [dict valueForKey:@"Password"];
    }
    
    if(self.IsInitialRegistration)
    {
        [self.view addSubview:InitialRegistration];
        self.IsInitialRegistration = NO;
    }
}
#pragma mark -
#pragma mark - KeyBoardToolBar Methods
-(void)previousButtonClicked:(id)sender
{
    id firstResponder = [self getFirstResponder];
    UITextField *fr=firstResponder;
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = fr.tag;
        NSUInteger previousTag = tag == 1 ? 1 : tag - 1;
        [self checkBarButton:previousTag];
        
        [self animateView:previousTag];
        UITextField *previousField = (UITextField *)[self.view viewWithTag:previousTag];
        [previousField becomeFirstResponder];
    }
}
-(void)nextButtonClicked:(id)sender
{
    id firstResponder = [self getFirstResponder];
    
    UITextField *fr=firstResponder;
    
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = fr.tag;
        NSUInteger nextTag = tag == FIELDS_COUNT ? FIELDS_COUNT : tag + 1;
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
    }
}

- (void)updateCurrentLocation {
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:locationManager.location // You can pass aLocation here instead
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       dispatch_async(dispatch_get_main_queue(),^ {
                           // do stuff with placemarks on the main thread
                           
                           if (placemarks.count == 1) {
                               
                               CLPlacemark *place = [placemarks objectAtIndex:0];
                               
                               
                               self.zipString = [place.addressDictionary valueForKey:@"ZIP"];
                               self.socialZip.text=[place.addressDictionary valueForKey:@"ZIP"];
                               
                           }
                           
                       });
                       
                   }];
}
-(void)doneButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    [socialScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)checkBarButton:(NSUInteger)tag
{
    [barButtonPrev setEnabled:tag == 1 ? NO : YES];
    [barButtonNext setEnabled:tag == FIELDS_COUNT ? NO : YES];
    //     barButtonNext.width = 0.01;
    //    barButtonNext.width = 0;
}
- (void)animateView:(NSUInteger)tag
{
    if(IS_IPHONE5)
    {
        if (tag > 2)
            [socialScroll setContentOffset:CGPointMake(0, 44.0f * (tag - 1)) animated:YES];
        else
            [socialScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
        if (tag > 0)
            [socialScroll setContentOffset:CGPointMake(0, 55.0f * (tag - 0)) animated:YES];
        else
            [socialScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (id)getFirstResponder
{
    NSUInteger index = 0;
    while (index <= FIELDS_COUNT) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return NO;
}
#pragma mark
#pragma mark -  Twitter Methods
- (void)loginInSafariAction:(id)sender
{
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:apiKey
                                                 consumerSecret:consumerKey];
    
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        //        NSLog(@"-- url: %@", url);
        //        NSLog(@"-- oauthToken: %@", oauthToken);
        
        [[UIApplication sharedApplication] openURL:url];
        
    } oauthCallback:@"com.enjoyfresh.EnjoyFresh://572122021-2VXAVL5uISZbcpZq80UF52S1AbLWmneKDDjtkCpR/"
                    errorBlock:^(NSError *error)
     {
         //                        NSLog(@"-- error: %@", error);
         [[[UIAlertView alloc]initWithTitle:AppTitle message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
     }];
}
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    NSLog(@"verifier %@", verifier);
    
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName)
     {
         appDel.twitterObj = _twitter;
         twitterScrenNme =screenName;
         CurrentTwitterID = userID;
         twitterId=userID;
         
         appDel.oauthToken = oauthToken;
         appDel.oauthTokenSecret = oauthTokenSecret;
         
         hud=nil;
         [hud setHidden:YES];
         [hud removeFromSuperview];
         if(hud==nil)
         {
             hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
             hud.delegate = self;
             [hud show:YES];
             [self.view addSubview:hud];
         }
         
         
         //[self getInfo ];
                  
         socialDict=[[NSDictionary alloc]initWithObjectsAndKeys:screenName,@"FirstName",screenName,@"LastName",@"",@"Email",twitterId,@"FBUserId", nil];
         
         if(appDel.CurrentCustomerDetails == nil)
         {
             appDel.CurrentCustomerDetails = [[ProfileClass alloc] init];
         }
         
         appDel.CurrentCustomerDetails.user_first_name = screenName;
         appDel.CurrentCustomerDetails.user_last_name = screenName;
         appDel.CurrentCustomerDetails.user_email = @"";
         appDel.CurrentCustomerDetails.user_twitter = twitterId;
         
         [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
         
         
         [emailImg setHidden:NO];
         [socialEmailFld setHidden:NO];
         parseInt=3;
//         NSString *urlquerystring=[NSString stringWithFormat:@"checkTWUser?twitterId=%@",twitterId];
//         [parser parseAndGetDataForGetMethod:urlquerystring];
         NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:twitterId,@"twitterId", nil];
         [parser parseAndGetDataForPostMethod:params withUlr:@"checkTWUser"];
         
         
     } errorBlock:^(NSError *error) {
         
         [[[UIAlertView alloc]initWithTitle:AppTitle message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
         NSLog(@"-- %@", [error localizedDescription]);
     }];
}
- (void) getInfo
{
    // Request access to the Twitter accounts
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            // Check if the users has setup at least one Twitter account
            
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                
                // Creating a request to get the info about a user on Twitter
                
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:twitterScrenNme forKey:@"screen_name"]];
                [twitterInfoRequest setAccount:twitterAccount];
                
                // Making the request
                
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Check if we reached the reate limit
                        
                        if ([urlResponse statusCode] == 429) {
                            //                            NSLog(@"Rate limit reached");
                            return;
                        }
                        
                        // Check if there was an error
                        
                        if (error) {
                            //                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        
                        // Check if there is some response data
                        
                        if (responseData) {
                            
                            NSError *error = nil;
                            NSDictionary *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            NSArray *nmesArr=[[TWData valueForKey:@"name"] componentsSeparatedByString:@" "];
                            twitterId=[TWData valueForKey:@"id_str"];
                            CurrentTwitterID = twitterId;
                            NSString *lastName;
                            if (nmesArr.count>1) {
                                lastName=[nmesArr objectAtIndex:1];
                            }
                            else{
                                lastName=@" ";
                            }
                            socialDict=[[NSDictionary alloc]initWithObjectsAndKeys:[nmesArr objectAtIndex:0],@"FirstName",lastName,@"LastName",@"",@"Email",twitterId,@"FBUserId", nil];
                            
                            if(appDel.CurrentCustomerDetails == nil)
                            {
                                appDel.CurrentCustomerDetails = [[ProfileClass alloc] init];
                            }
                            
                            appDel.CurrentCustomerDetails.user_first_name = [nmesArr objectAtIndex:0];
                            appDel.CurrentCustomerDetails.user_last_name = lastName;
                            appDel.CurrentCustomerDetails.user_email = @"";
                            appDel.CurrentCustomerDetails.user_twitter = twitterId;
                            
                            [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
                            
                            
                            if(hud==nil)
                            {
                                hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
                                hud.delegate = self;
                                [hud show:YES];
                                [self.view addSubview:hud];
                            }
                            [emailImg setHidden:NO];
                            [socialEmailFld setHidden:NO];
                            parseInt=3;
//                            NSString *urlquerystring=[NSString stringWithFormat:@"checkTWUser?twitterId=%@",twitterId];
//                            [parser parseAndGetDataForGetMethod:urlquerystring];
                            NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:twitterId,@"twitterId", nil];
                            [parser parseAndGetDataForPostMethod:params withUlr:@"checkTWUser"];
                        }
                    });
                }];
            }
        }
        else
        {
            NSLog(@"No access granted");
        }
    }];
}
#pragma mark
#pragma mark - Facebook Actions
-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"You are logged in.");
    
    //    [self toggleHiddenState:NO];
}
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [emailImg setHidden:YES];
   // [socialEmailFld setHidden:YES];
    CurrentFacebookID = [NSString stringWithFormat:@"%@", [user objectForKey:@"id"]];
    socialDict=[[NSDictionary alloc]initWithObjectsAndKeys:user.first_name,@"FirstName",user.last_name,@"LastName",[user objectForKey:@"email"],@"Email",[user objectForKey:@"id"],@"FBUserId", nil];
    
    appDel.CurrentCustomerDetails  = [appDel.objDBClass GetUserProfileDetails];
    
    if(appDel.CurrentCustomerDetails == nil)
    {
        appDel.CurrentCustomerDetails = [[ProfileClass alloc] init];
    }
    
    appDel.CurrentCustomerDetails.user_first_name = user.first_name;
    appDel.CurrentCustomerDetails.user_last_name = user.last_name;
    appDel.CurrentCustomerDetails.user_email = [user objectForKey:@"email"];
    appDel.CurrentCustomerDetails.user_fb = [user objectForKey:@"id"];
    
    [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
    
    [self performSelector:@selector(cleardata) withObject:nil afterDelay:0.1f];
    
    socialDict=[[NSDictionary alloc]initWithObjectsAndKeys:
                user.first_name,@"FirstName",
                user.last_name,@"LastName",
                appDel.CurrentCustomerDetails.user_email,@"Email",
                appDel.CurrentCustomerDetails.user_fb,@"FBUserId", nil];
    
    if(hud==nil)
    {
        hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    parseInt=3;
    NSString *urlquerystring=[NSString stringWithFormat:@"checkFBUser?facebookId=%@&email=%@",
                              [user objectForKey:@"id"], [user objectForKey:@"email"]];
    [parser parseAndGetDataForGetMethod:urlquerystring];
    emailToSend=[user objectForKey:@"email"];
    dupEmail=[user objectForKey:@"email"];
    
}
-(void)cleardata
{
    loginButton.delegate=nil;
    loginButton2.delegate=nil;
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession setActiveSession:nil];
    
}
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"You are logged out.");
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}

# pragma mark -
# pragma mark - Button Actions

- (IBAction)facebookBtnClicked:(id)sender {
    {
        [self.view endEditing:YES];
        appDel.isFB=YES;
        
        btnRegFacebook.delegate = self;
        
        for (id loginObject in btnRegFacebook.subviews)
        {
            if ([loginObject isKindOfClass:[UILabel class]])
            {
                UILabel * loginLabel =  loginObject;
                loginLabel.text = @"";
                loginLabel.frame = CGRectMake(-11, 0, 300, 45);
                loginLabel.textAlignment=NSTextAlignmentCenter;
                loginLabel.font=[UIFont systemFontOfSize:14.0f];
            }
        }
        
    }
}



- (IBAction)twitterBtnClicked:(id)sender
{
    ////////login with IOSActions
    [self.view endEditing:YES];
    appDel.isFB=NO;
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        twitterScrenNme =username;
        [self getInfo ];
        
    } errorBlock:^(NSError *error)
     {
         [self loginInSafariAction:nil];
         
     }];
    
}
-(IBAction)loginBtnClicked:(id)sende
{
    [self.view endEditing:YES];
    
    if([emailFld.text length])
    {
        if ([passwdFld.text length])
        {
            if([GlobalMethods isItValidEmail:emailFld.text])
            {
                if(hud != nil)
                {
                    [self.view addSubview:hud];
                    hud = nil;
                }
                
                if(hud==nil)
                {
                    hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
                    hud.delegate = self;
                    [hud show:YES];
                    [self.view addSubview:hud];
                }
                parseInt=1;
                emailToSend=[NSString stringWithFormat:@"%@",emailFld.text];
                dupEmail=[NSString stringWithFormat:@"%@",emailFld.text];

                NSString *devicetoken=[GlobalMethods getUDIDOfdevice];
                
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:emailFld.text, @"email",
                                        passwdFld.text, @"password", devicetoken,@"devicetoken",[appDel.token length]?appDel.token:@"",@"apn_device_token",nil];
                [parser parseAndGetDataForPostMethod:params withUlr:@"customerLogin"];
            }
            else
                [GlobalMethods showAlertwithString:@"Please enter a valid Email"];
        }
        else
            [GlobalMethods showAlertwithString:@"Please enter your password"];
    }
    else
        [GlobalMethods showAlertwithString:@"Please enter your Email"];
}
- (IBAction)heperLinkClicked:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [sender setAlpha:0];
    } completion:^(BOOL finished) {
        [sender setAlpha:1.0];
    }];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://enjoyfresh.rightsource-global.com/tos"]];
}

- (IBAction)resendCode:(id)sender {
    if (hud==nil) {
        hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
   parseInt=6;
    if (emailToSend==nil) {
        emailToSend=dupEmail;
    }
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:emailToSend,@"email", nil];
    [parser parseAndGetDataForPostMethod:params withUlr:@"resendTwilioPin"];

}
#pragma mark -
#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==111) {
        if (buttonIndex==1) {
            NSString *emStr= [alertView textFieldAtIndex:0].text;
            if (![emStr length])
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Forgot password" message:@"Please enter your Email" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                alert.tag=111;
                [alert show];
            }
            
            else if(![GlobalMethods isItValidEmail:emStr])
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Forgot password" message:@"Please enter a valid Email" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                alert.tag=111;
                [alert show];
            }
            else
            {
                if(hud==nil)
                {
                    hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
                    hud.delegate = self;
                    [hud show:YES];
                    [self.view addSubview:hud];
                }
                parseInt=2;
                
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:emStr, @"email",nil];
                [parser parseAndGetDataForPostMethod:params withUlr:@"forgotPassword"];
            }
        }
    }
}
-(IBAction)forgotPwdBtnClicked:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Forgot password" message:@"Please enter your Email" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag=111;
    [alert show];
    
    [self.view endEditing:YES];
    //     if([emailFld.text length])
    //     {
    //         if([GlobalMethods isItValidEmail:emailFld.text])
    //         {
    //             if(hud==nil)
    //             {
    //                 hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    //                 hud.delegate = self;
    //                 [hud show:YES];
    //                 [self.view addSubview:hud];
    //             }
    //             parseInt=2;
    //
    //             NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:emailFld.text, @"email",nil];
    //             [parser parseAndGetDataForPostMethod:params withUlr:@"forgotPassword"];
    //         }
    //         else
    //             [GlobalMethods showAlertwithString:@"Please enter a valid Email"];
    //     }
    //    else
    //        [GlobalMethods showAlertwithString:@"Please enter your Email"];
    
}
-(IBAction)BackBtnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
///////////////social loginview buttons///////////////
-(IBAction)agressBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    if([agressBtn currentImage]!=[UIImage imageNamed:@"checked"])
        [agressBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    else
        [agressBtn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
}
-(IBAction)sendMeOffersBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    if([OffersBtn currentImage]!=[UIImage imageNamed:@"checked"])
        [OffersBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    else
        [OffersBtn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
}
-(IBAction)acceptSweepBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    if([acceptBtn currentImage]!=[UIImage imageNamed:@"checked"])
        [acceptBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    else
        [acceptBtn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
}
-(IBAction)socailBackBtnClicked:(id)sender
{
    [socialView removeFromSuperview];
    [self.verificationPopup removeFromSuperview];
}
-(IBAction)socailLoginBtnClicked:(id)sender
{
    
    NSDictionary *add=appDel.addrFromLocation;
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [_socialPhone.text stringByTrimmingCharactersInSet:charSet];
    int val=(int)[trimmedString length];
    if (appDel.isFB)
    {
        
        if (![socialEmailFld.text length]||[GlobalMethods checkWhiteSpace:socialEmailFld.text]){
            socialEmailFld.text=nil;
            [GlobalMethods showAlertwithString:@"Please enter a your Email"];
        }
        else if(![GlobalMethods isItValidEmail:socialEmailFld.text]){
            [GlobalMethods showAlertwithString:@"Please enter a valid Email"];

        }
        else if (val!=10){
            [GlobalMethods showAlertwithString:@"Please enter valid Phone Number"];
        }
        else if(![self.socialPhone.text length] || [GlobalMethods checkWhiteSpace:socialEmailFld.text]){
            self.socialPhone.text=nil;
            [GlobalMethods showAlertwithString:@"Please enter a Phone Number"];
        }
        else if(![self.socialZip.text length]|| [GlobalMethods checkWhiteSpace:self.socialZip.text]){
            self.socialZip.text=nil;
            [GlobalMethods showAlertwithString:@"Please enter a Zip Code"];
        }
        
        
        else{
            if(hud==nil)
            {
                hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
                hud.delegate = self;
                [hud show:YES];
                [self.view addSubview:hud];
            }
            NSString *devicetoken=[GlobalMethods getUDIDOfdevice];
            int ofer=0;
            if([OffersBtn currentImage]==[UIImage imageNamed:@"checked_checkbox"])
                ofer=1;
            
            parseInt=4;
            emailToSend=[socialDict valueForKey:@"Email"];
            dupEmail=[socialDict valueForKey:@"Email"];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.socialZip.text,@"zipcode",
                                    devicetoken,@"devicetoken",[socialDict valueForKey:@"FirstName"],@"firstname",[socialDict valueForKey:@"LastName"],@"lastname",self.socialPhone.text,@"mobile",[promoFld.text length]?promoFld.text:@"",@"promoId",[socialDict valueForKey:@"Email"],@"email",[socialDict valueForKey:@"FBUserId"],@"facebookId",[appDel.token length]?appDel.token:@"",@"apn_device_token",[NSNumber numberWithInt:ofer],@"offers",nil];
            
            appDel.CurrentCustomerDetails.user_devicetoken = devicetoken;
            appDel.CurrentCustomerDetails.user_zipcode = zipFld.text;
            
            [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
            
            [parser parseAndGetDataForPostMethod:params withUlr:@"facebookRegister"];
            
        }
    }
    else
    {
        if (![socialEmailFld.text length]||[GlobalMethods checkWhiteSpace:socialEmailFld.text]){
            socialEmailFld.text=nil;
            [GlobalMethods showAlertwithString:@"Please enter a your Email"];
        }
        else if(![GlobalMethods isItValidEmail:socialEmailFld.text]){
            [GlobalMethods showAlertwithString:@"Please enter a valid Email"];
            
        }
        else if(![self.socialPhone.text length] || [GlobalMethods checkWhiteSpace:socialEmailFld.text]){
            self.socialPhone.text=nil;
            [GlobalMethods showAlertwithString:@"Please enter a Phone Number"];
        }
        else if (val!=10){
            [GlobalMethods showAlertwithString:@"Please enter valid Phone Number"];
            
        }
        else if(![self.socialZip.text length]|| [GlobalMethods checkWhiteSpace:self.socialZip.text]){
            self.socialZip.text=nil;
            [GlobalMethods showAlertwithString:@"Please enter a Zip Code"];
        }
        
        else
        {
            if(hud==nil)
            {
                hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
                hud.delegate = self;
                [hud show:YES];
                [self.view addSubview:hud];
            }
            NSString *devicetoken=[GlobalMethods getUDIDOfdevice];
            int ofer=0;
            if([OffersBtn currentImage]==[UIImage imageNamed:@"checked_checkbox"])
                ofer=1;
            
            parseInt=4;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.socialZip.text,@"zipcode",
                                    devicetoken,@"devicetoken",[socialDict valueForKey:@"FirstName"],@"firstname",[socialDict valueForKey:@"LastName"],@"lastname",[NSString stringWithFormat:@"%@",self.socialPhone.text],@"mobile",[promoFld.text length]?promoFld.text:@"",@"promoId",socialEmailFld.text,@"email",[socialDict valueForKey:@"FBUserId"],@"twitterId",[appDel.token length]?appDel.token:@"",@"apn_device_token",[NSNumber numberWithInt:ofer],@"offers",nil];
            
            appDel.CurrentCustomerDetails.user_devicetoken = devicetoken;
            appDel.CurrentCustomerDetails.user_zipcode = self.zipString;
            
            [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
            
            [parser parseAndGetDataForPostMethod:params withUlr:@"twitterRegister"];
        }
        
    }
}
#pragma mark
#pragma mark - TextField Delgates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
    
    if(!IS_IPHONE5)
        [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if (!emailImg.isHidden)
    {
        NSUInteger tag = [textField tag];
        [self animateView:tag];
        [self checkBarButton:tag];
    }
    else
    {
        NSUInteger tag = [textField tag];
        [self animateView:tag];
        [self checkBarButton:tag];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [socialScroll setContentOffset:CGPointMake(0, 0) animated:YES];

    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField==zipFld || textField==self.socialZip)
    {
        if (textField.text.length >= 5 && range.length == 0)
            return NO;
    }
    if( textField== self.socialPhone)
    {
        if (textField.text.length >= 10 && range.length == 0)
            return NO;
    }
    if (textField.keyboardType == UIKeyboardTypeNumbersAndPunctuation)
    {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            // BasicAlert(@"", @"This field accepts only numeric entries.");
            return NO;
        }
    }
    if([string isEqualToString:@" "]){
        // Returning no here to restrict whitespace
        return NO;
    }
    return YES;
}
#pragma mark
#pragma mark - ParseAndGetData Delegates
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    [currentTextField resignFirstResponder];
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [socialScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    BOOL errMsg=[[result valueForKey:@"error"]boolValue];
    NSString *strErrorMessage = [result valueForKey:@"message"];
    if((!errMsg || strErrorMessage.length > 0) && (strErrorMessage))
    {
        //[GlobalMethods showAlertwithString: strErrorMessage];
        NSLog(@"Login View Result: %@", result);
        
        //User Needs to Enter Further Information, After Successful FB or Twitter Connect.
        if([strErrorMessage isEqualToString:@"There is no user registered with this Facebook account. Please register"] ||
           [strErrorMessage isEqualToString:@"There is no user registered with this Twitter account. Please register"])
        {
            [self.view addSubview: socialView];
            [self.view bringSubviewToFront: socialView];
            if (appDel.isFB){
                socialEmailFld.text=[socialDict valueForKey:@"Email"];
            }
            else{
                socialEmailFld.text=nil;
 
            }
        }
        //User Already has a record stored - this condition is obsolete with recent changes in APIs
        else if([strErrorMessage isEqualToString:@"This email is already registered with EnjoyFresh. Proceeding with Login..."])
        {
            [GlobalMethods showAlertwithString: @"Email already taken! Please use a different email address."];
            
            //            [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
            //
            //            DishesViewController *dishes=[[DishesViewController alloc]initWithNibName:@"DishesViewController" bundle:nil];
            //            [self.navigationController pushViewController:dishes animated:YES];
        }
        else if([strErrorMessage isEqualToString:@"User is not verified"])
        {
            //[GlobalMethods showAlertwithString: @"Email already taken! Please use a different email address."];
            self.ahshucksView.frame=CGRectMake(0, 64,self.ahshucksView.frame.size.width, self.ahshucksView.frame.size.height);
            [self.view addSubview:self.ahshucksView];
            [self.view bringSubviewToFront:self.ahshucksView];

            emailToSend=[result valueForKey:@"email"];
        }
        else
        {
            [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
        }
        
    }
    else
    {
        NSLog(@"Login View Result: %@", result);
        NSLog(@"passwdFld.text: %@", passwdFld.text);
        CurrentUserPassword = passwdFld.text ;
        appDel.CurrentCustomerDetails.user_password = passwdFld.text ;
        
        if(parseInt==1)
        {
            
            appDel.accessToken=[result valueForKey:@"accessToken"];
            
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:[result valueForKey:@"profile"]];
            
            appDel.CurrentCustomerDetails  = [appDel.objDBClass GetUserProfileDetails];
            
            
            if(appDel.CurrentCustomerDetails == nil)
            {
                appDel.CurrentCustomerDetails = [[ProfileClass alloc] init];
            }
            
            appDel.CurrentCustomerDetails.user_auth_id
            = [NSString stringWithFormat:@"%@", [dict valueForKey:@"customerProfileId"]]  ;
            appDel.CurrentCustomerDetails.user_devicetoken = [dict valueForKey:@"devicetoken"];
            appDel.CurrentCustomerDetails.user_zipcode = [dict valueForKey:@"zipcode"];
            appDel.CurrentCustomerDetails.user_image = [dict valueForKey:@"image"];
            appDel.CurrentCustomerDetails.user_password = passwdFld.text ;
            appDel.CurrentCustomerDetails.user_email = [dict valueForKey:@"email"];
            appDel.CurrentCustomerDetails.user_first_name = [dict valueForKey:@"first_name"];
            appDel.CurrentCustomerDetails.user_last_name = [dict valueForKey:@"last_name"];
            appDel.CurrentCustomerDetails.user_is_discount_applied
            = [NSString stringWithFormat:@"%@", [dict valueForKey:@"is_discount_applied"]]  ;
            appDel.CurrentCustomerDetails.user_is_sweep
            = [NSString stringWithFormat:@"%@", [dict valueForKey:@"is_sweep"]]  ;
            appDel.CurrentCustomerDetails.user_mobile = [dict valueForKey:@"mobile"];
            appDel.CurrentCustomerDetails.user_ref_promo = [dict valueForKey:@"ref_promo"];
            appDel.CurrentCustomerDetails.user_ref_promo_count
            = [NSString stringWithFormat:@"%@", [dict valueForKey:@"ref_promo_count"]]  ;
            appDel.CurrentCustomerDetails.user_id  = [dict valueForKey:@"user_id"];
            
            // [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
            
            CurrentUserProfile = appDel.CurrentCustomerDetails;
            
            [self InsertUserProfileDetails:dict];
            
            for(id favDetails in [result valueForKey:@"favorites"])
            {
                NSMutableDictionary *favs=[[NSMutableDictionary alloc]initWithDictionary:favDetails];
                [self InsertUserFavorites:favs];
            }
            
            
            
            [dict setObject:passwdFld.text forKey:@"password"];
            
            
            for (NSString * key in [dict allKeys])
            {
                if ([[dict objectForKey:key] isKindOfClass:[NSNull class]])
                    [dict setObject:@"" forKey:key];
            }
            @try {
                NSArray * favcount=[[result  valueForKey:@"favorites"] valueForKey:@"dish_id"];
                // appDel.orderHistroy_count=[[result  valueForKey:@"ordeHistory"] count];
                
                [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[favcount count]] forKey:@"FAVCount"];
                
                [dict setObject:(NSMutableArray *)[[result  valueForKey:@"deliveryAddresses"] mutableCopy] forKey:@"deliveryAddresses"];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserProfile"];
                //[[NSUserDefaults standardUserDefaults] setObject:favcount forKey:@"FAVCount"];
                //////save recent username and pwd to show after logoutr
                NSDictionary *loginDict=[[NSDictionary alloc]initWithObjectsAndKeys:emailFld.text,@"Email",passwdFld.text,@"Password", nil];
                [[NSUserDefaults standardUserDefaults] setObject:loginDict forKey:@"credentials"];
                
                [[NSUserDefaults standardUserDefaults ] synchronize];
                loginDict=nil;

            }
            @catch (NSException *exception) {
                NSLog(@"excep:%@",exception);
            }
            
            
            [self performSegueWithIdentifier:@"LoginSegue" sender:self];
//            DishesViewController *dishes=[[DishesViewController alloc]initWithNibName:@"DishesViewController" bundle:nil];
//            [self.navigationController pushViewController:dishes animated:YES];
        }
        else if(parseInt==2 || parseInt==6)
        {
            [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
        }
        else if(parseInt==3)
        {
            NSLog(@"Login View Result: %@", result);
            
            if([[result valueForKey:@"message"]isEqualToString:@"User not exist"])
            {
                [self.view addSubview:socialView];
                [hud hide:YES];
                [hud removeFromSuperview];
                hud=nil;
                return;
            }
            
            
            appDel.accessToken=[result valueForKey:@"accessToken"];
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:[result valueForKey:@"profile"]];
            [self InsertUserProfileDetails:dict];
            
            for(id favDetails in [result valueForKey:@"favorites"])
            {
                NSMutableDictionary *favs=[[NSMutableDictionary alloc]initWithDictionary:favDetails];
                [self InsertUserFavorites:favs];
            }
            
            [dict setObject:@"" forKey:@"password"];
            for (NSString * key in [dict allKeys])
            {
                if ([[dict objectForKey:key] isKindOfClass:[NSNull class]])
                    [dict setObject:@"" forKey:key];
            }
            NSArray * favcount=[[result  valueForKey:@"favorites"] valueForKey:@"dish_id"];
            appDel.orderHistroy_count=[[result  valueForKey:@"ordeHistory"] count];
            @try {
                [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[favcount count]] forKey:@"FAVCount"];
                [dict setObject:(NSMutableArray *)[[result  valueForKey:@"deliveryAddresses"] mutableCopy] forKey:@"deliveryAddresses"];
                
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserProfile"];
                //[[NSUserDefaults standardUserDefaults] setObject:favcount forKey:@"FAVCount"];
                [[NSUserDefaults standardUserDefaults ] synchronize];
            }
            @catch (NSException *exception) {
                
            }
            
            
            appDel.CurrentCustomerDetails  = [appDel.objDBClass GetUserProfileDetails];
            
            
            if(appDel.CurrentCustomerDetails == nil)
            {
                appDel.CurrentCustomerDetails = [[ProfileClass alloc] init];
            }
            
            appDel.CurrentCustomerDetails.user_auth_id
            = [NSString stringWithFormat:@"%@", [dict valueForKey:@"customerProfileId"]]  ;
            appDel.CurrentCustomerDetails.user_devicetoken = [dict valueForKey:@"devicetoken"];
            appDel.CurrentCustomerDetails.user_zipcode = [dict valueForKey:@"zipcode"];
            appDel.CurrentCustomerDetails.user_image = [dict valueForKey:@"image"];
            appDel.CurrentCustomerDetails.user_password = passwdFld.text ;
            appDel.CurrentCustomerDetails.user_email = [dict valueForKey:@"email"];
            appDel.CurrentCustomerDetails.user_first_name = [dict valueForKey:@"first_name"];
            appDel.CurrentCustomerDetails.user_last_name = [dict valueForKey:@"last_name"];
            appDel.CurrentCustomerDetails.user_is_discount_applied
            = [NSString stringWithFormat:@"%@", [dict valueForKey:@"is_discount_applied"]]  ;
            appDel.CurrentCustomerDetails.user_is_sweep
            = [NSString stringWithFormat:@"%@", [dict valueForKey:@"is_sweep"]]  ;
            appDel.CurrentCustomerDetails.user_mobile = [dict valueForKey:@"mobile"];
            appDel.CurrentCustomerDetails.user_ref_promo = [dict valueForKey:@"ref_promo"];
            appDel.CurrentCustomerDetails.user_ref_promo_count
            = [NSString stringWithFormat:@"%@", [dict valueForKey:@"ref_promo_count"]]  ;
            appDel.CurrentCustomerDetails.user_id  = [dict valueForKey:@"user_id"];
            
            appDel.CurrentCustomerDetails.user_fb = CurrentFacebookID;
            appDel.CurrentCustomerDetails.user_twitter = CurrentTwitterID;
            
            //[appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
            
            CurrentUserProfile = [appDel.objDBClass GetUserProfileDetails];
            
            [self InsertUserProfileDetails:dict];
            @try {
                [self performSegueWithIdentifier:@"LoginSegue" sender:nil];

            }
            @catch (NSException *exception) {
                NSLog(@"exp:%@",exception);
            }
            

            
//            DishesViewController *dishes=[[DishesViewController alloc]initWithNibName:@"DishesViewController" bundle:nil];
//            [self.navigationController pushViewController:dishes animated:YES];
        }
        else if(parseInt==4)
        {
            self.verificationPopup.frame=CGRectMake(0, 64,self.verificationPopup.frame.size.width, self.verificationPopup.frame.size.height);

            [self.view addSubview: self.verificationPopup];
            [self.view bringSubviewToFront: self.verificationPopup];

        }
        else if(parseInt==5)
        {
            NSLog(@"Login View Result: %@", result);
            
            appDel.accessToken=[result valueForKey:@"accessToken"];
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:[result valueForKey:@"profile"]];
            [self InsertUserProfileDetails:dict];
            
            for(id favDetails in [result valueForKey:@"favorites"])
            {
                NSMutableDictionary *favs=[[NSMutableDictionary alloc]initWithDictionary:favDetails];
                [self InsertUserFavorites:favs];
            }
            
            [dict setObject:@"" forKey:@"password"];
            for (NSString * key in [dict allKeys])
            {
                if ([[dict objectForKey:key] isKindOfClass:[NSNull class]])
                    [dict setObject:@"" forKey:key];
            }
            @try {
                NSArray * favcount=[[result  valueForKey:@"favorites"] valueForKey:@"dish_id"];
                appDel.orderHistroy_count=[[result  valueForKey:@"ordeHistory"] count];
                [dict setObject:(NSMutableArray*)[result  valueForKey:@"deliveryAddresses"] forKey:@"deliveryAddresses"];
                
                [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[favcount count]] forKey:@"FAVCount"];
                
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserProfile"];
                [[NSUserDefaults standardUserDefaults] setObject:favcount forKey:@"FAVCount"];
                [[NSUserDefaults standardUserDefaults ] synchronize];

            }
            @catch (NSException *exception) {
                
            }
           
            
            appDel.CurrentCustomerDetails  = [appDel.objDBClass GetUserProfileDetails];
            
            
            if(appDel.CurrentCustomerDetails == nil)
            {
                appDel.CurrentCustomerDetails = [[ProfileClass alloc] init];
            }
            
            appDel.CurrentCustomerDetails.user_auth_id
            = [NSString stringWithFormat:@"%@", [dict valueForKey:@"customerProfileId"]]  ;
            appDel.CurrentCustomerDetails.user_devicetoken = [dict valueForKey:@"devicetoken"];
            appDel.CurrentCustomerDetails.user_zipcode = [dict valueForKey:@"zipcode"];
            appDel.CurrentCustomerDetails.user_image = [dict valueForKey:@"image"];
            appDel.CurrentCustomerDetails.user_password = passwdFld.text ;
            appDel.CurrentCustomerDetails.user_email = [dict valueForKey:@"email"];
            appDel.CurrentCustomerDetails.user_first_name = [dict valueForKey:@"first_name"];
            appDel.CurrentCustomerDetails.user_last_name = [dict valueForKey:@"last_name"];
            appDel.CurrentCustomerDetails.user_is_discount_applied
            = [NSString stringWithFormat:@"%@", [dict valueForKey:@"is_discount_applied"]]  ;
            appDel.CurrentCustomerDetails.user_is_sweep
            = [NSString stringWithFormat:@"%@", [dict valueForKey:@"is_sweep"]]  ;
            appDel.CurrentCustomerDetails.user_mobile = [dict valueForKey:@"mobile"];
            appDel.CurrentCustomerDetails.user_ref_promo = [dict valueForKey:@"ref_promo"];
            appDel.CurrentCustomerDetails.user_ref_promo_count
            = [NSString stringWithFormat:@"%@", [dict valueForKey:@"ref_promo_count"]]  ;
            appDel.CurrentCustomerDetails.user_id  = [dict valueForKey:@"user_id"];
            
            //[appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
            
            //CurrentUserProfile = [appDel.objDBClass GetUserProfileDetails];
            
            [self InsertUserProfileDetails:dict];
            [self performSegueWithIdentifier:@"LoginSegue" sender:self];

        }
        else
        {
            [self.view addSubview:InitialRegistration];
        }
    }
    [hud hide:YES];
    [hud removeFromSuperview];
    hud=nil;
}

@synthesize UserFavorites;
- (void) InsertUserFavorites : (NSDictionary *) favs
{
    UserFavorites = [[FavoritesClass alloc] init];
    NSMutableArray *ImagesStringArray = [favs objectForKey:@"images"];
    
    if(ImagesStringArray.count > 0)
    {
        NSMutableDictionary *ThumbNailImage = ImagesStringArray[0];
        UserFavorites.restaurant_image_thumbnail = [ThumbNailImage objectForKey:@"path_th"];
    }
    
    UserFavorites.restaurant_id = [NSString stringWithFormat:@"%@", [favs objectForKey:@"restaurant_id"]];
    UserFavorites.restaurant_city = [NSString stringWithFormat:@"%@", [favs objectForKey:@"restaurant_city"]];
    UserFavorites.restaurant_title = [NSString stringWithFormat:@"%@", [favs objectForKey:@"restaurant_title"]];
    UserFavorites.restaurant_is_favorite = @"Y";
    
    [appDel.objDBClass AddUserFavorite: UserFavorites];
}

- (void) InsertUserProfileDetails : (NSDictionary *) dict
{
    if(appDel.CurrentCustomerDetails == nil)
    {
        appDel.CurrentCustomerDetails = [[ProfileClass alloc] init];
    }
    appDel.CurrentCustomerDetails.user_id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"user_id"]];
    appDel.CurrentCustomerDetails.user_devicetoken = [NSString stringWithFormat:@"%@", [dict objectForKey:@"devicetoken"]];
    appDel.CurrentCustomerDetails.user_email = [NSString stringWithFormat:@"%@", [dict objectForKey:@"email"]];
    appDel.CurrentCustomerDetails.user_first_name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"first_name"]];
    appDel.CurrentCustomerDetails.user_image = [NSString stringWithFormat:@"%@", [dict objectForKey:@"image"]];
    appDel.CurrentCustomerDetails.user_is_discount_applied =
    [NSString stringWithFormat:@"%@", [dict objectForKey:@"is_discount_applied"]];
    appDel.CurrentCustomerDetails.user_is_sweep = [NSString stringWithFormat:@"%@", [dict objectForKey:@"is_sweep"]];
    appDel.CurrentCustomerDetails.user_last_name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"last_name"]];
    appDel.CurrentCustomerDetails.user_mobile = [NSString stringWithFormat:@"%@", [dict objectForKey:@"mobile"]];
    appDel.CurrentCustomerDetails.user_ref_promo = [NSString stringWithFormat:@"%@", [dict objectForKey:@"ref_promo"]];
    appDel.CurrentCustomerDetails.user_ref_promo_count =
    [NSString stringWithFormat:@"%@", [dict objectForKey:@"ref_promo_count"]];
    appDel.CurrentCustomerDetails.user_zipcode = [NSString stringWithFormat:@"%@", [dict objectForKey:@"zipcode"]];
    appDel.CurrentCustomerDetails.user_twitter = CurrentTwitterID;
    appDel.CurrentCustomerDetails.user_fb = CurrentFacebookID;
    appDel.CurrentCustomerDetails.user_password = CurrentUserPassword;
    appDel.CurrentCustomerDetails.user_auth_id =  [NSString stringWithFormat:@"%@", [dict objectForKey:@"customerProfileId"]];
    
    [appDel.objDBClass InserUserProfileDetails: appDel.CurrentCustomerDetails];
    
    
}

-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    [hud hide:YES];
    [GlobalMethods showAlertwithString:err];
}




#pragma mark
#pragma mark - HUD Delegtes
- (void)hudWasHidden:(MBProgressHUD *)huda {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    hud = nil;
}
- (IBAction)registerBtnAction:(id)sender {
    [self performSegueWithIdentifier:@"RegisterSegue" sender:self];
}
- (IBAction)submitCode:(id)sender {
    [self.view endEditing:YES];

    if ([self.ahtxtCode.text length] && ![GlobalMethods checkWhiteSpace:self.ahtxtCode.text]) {
        if (hud==nil) {
            hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
            hud.delegate = self;
            [hud show:YES];
            [self.view addSubview:hud];
        }
        NSLog(@"%@",emailToSend);
        if (emailToSend==nil) {
            emailToSend=dupEmail;
        }
        parseInt=1;
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.ahtxtCode.text,@"twilioPin",emailToSend,@"email", nil];
        [parser parseAndGetDataForPostMethod:params withUlr:@"verifyTwilioPin"];
    }
    
}
- (IBAction)submitFromVerification:(id)sender {
    [self.view endEditing:YES];

    if ([self.txtVerfCode.text length] && ![GlobalMethods checkWhiteSpace:self.txtVerfCode.text]) {
        if (hud==nil) {
            hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
            hud.delegate = self;
            [hud show:YES];
            [self.view addSubview:hud];
        }
        parseInt=5;
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.txtVerfCode.text,@"twilioPin",socialEmailFld.text,@"email", nil];
        [parser parseAndGetDataForPostMethod:params withUlr:@"verifyTwilioPin"];
    }
   
}

- (IBAction)resendFromVerification:(id)sender {
    [self.view endEditing:YES];

    if (hud==nil) {
        hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    parseInt=6;
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:socialEmailFld.text,@"email", nil];
    [parser parseAndGetDataForPostMethod:params withUlr:@"resendTwilioPin"];
}
- (IBAction)removeAhshucks:(id)sender {
    [self.ahshucksView removeFromSuperview];
}

- (IBAction)removeVerification:(id)sender {
    [socialView removeFromSuperview];
    [self.verificationPopup removeFromSuperview];
}
@end