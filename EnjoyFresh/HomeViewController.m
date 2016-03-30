//
//  HomeViewController.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "HomeViewController.h"
#import "Global.h"
#import "LoginViewController.h"
#import "Registration.h"
#import "SettingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface HomeViewController ()
@property (nonatomic, strong) STTwitterAPI *twitter;

@end

static NSString *apiKey=@"TJqDoM0AJyeLnZYCQQJIfuyNm";
static NSString *consumerKey=@"yIPITPHBFJ7CuwN857MvtGwflwF0ViZa7D3YEa78VjW9z98tx4";


@implementation HomeViewController
#pragma mark -
#pragma mark - ViewcontrollerLifeCycleMethods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    appDel.profileUpdated = NO;
    
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=(id)self;
    
    NSDictionary *dict=[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"];
    if(dict !=nil && !appDel.profileUpdated)
    {
        //[self performSegueWithIdentifier:@"DishesSegue" sender:self];
        LAContext *context = [[LAContext alloc] init];
        
        NSError *error = nil;
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                    localizedReason:@"Please provide your authorised touch id to login to app"
                              reply:^(BOOL success, NSError *error) {
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      if (error) {
//                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                                                          message:@"There was a problem verifying your identity."
//                                                                                         delegate:nil
//                                                                                cancelButtonTitle:@"Ok"
//                                                                                otherButtonTitles:nil];
//                                          [alert show];
                                          [self performSegueWithIdentifier:@"loginSegue" sender:self];
                                      }
                                      
                                      if (success) {
                                          [self performSegueWithIdentifier:@"DishesSegue" sender:self];
                                          
                                      } else {
                                          
                                      }
                                  
                                  });
                                  
                              }];
            
        } else {
            [self performSegueWithIdentifier:@"DishesSegue" sender:self];

        }

    }
    
    self.btnSignin.layer.cornerRadius=3.0f;
    self.btnGuest.layer.cornerRadius=3.0f;

    
       imgsArr=@[@"scrollBack15.png",@"scrollBack25.png",@"scrollBack35.png",@"scrollBack45.png"];
    
    ////////////////For ScrollView Pagging Images//////////
    
        for (int i=0; i<[imgsArr count]; i++)
        {
            UIImageView *v = [[UIImageView alloc] init];
            v.image=[UIImage imageNamed:[imgsArr objectAtIndex:i]];
    
            CGRect rect=v.frame;
            rect.origin.x=320*i;
            rect.origin.y=-20;
    
            rect.size.width = 320;
            rect.size.height = self.view.bounds.size.height;
    
            v.frame=rect;
            v.tag=i;
            _contentWidth = v.frame.size.height;
    
            [scroll addSubview:v];
            [scroll sendSubviewToBack:v];
        }
        scroll.contentSize = CGSizeMake(imgsArr.count*320, 0);
        pagecontroler.numberOfPages=[imgsArr count];
        scroll.pagingEnabled = YES;

/*    headingArr=[NSMutableArray arrayWithObjects:@"Secret off-menu items",@"Exclusive communal dining events",@"Special tasting menu",@"Chef-led workshops", nil];
        textBoxArr=[[NSMutableArray alloc]init];
    NSString *string1=@"May be the item is too labor-intensive to offer regularly.The ingredients are only available seasonally or our chefs just want to try out something new.Either way,these secret items are total treat.";
    [textBoxArr addObject:string1];
    NSString *string2=@"Everything's better when shared! Join a special chef's table with a friend, or roll solo to meet other, local food-loving friends.";
    [textBoxArr addObject:string2];
    NSString *string3=@"Taste only the best of the best! Try way more than you'd ever be able to in a normal sitting with one of our special chef-curated tasting menus.";
    [textBoxArr addObject:string3];
    NSString *string4=@"Learn from our inspired chefs, in action! Sign up for a workshop and level-up your gastronomical game back at home with your newfound skills.";
    [textBoxArr addObject:string4];*/

    
    //getting location latitude and longitude
    
    UITapGestureRecognizer *swipeGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToGetDishes)];
    swipeGesture.delegate=self;
    [self.btnGuest addGestureRecognizer:swipeGesture];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self updateCurrentLocation];
    
    if(!IS_IPHONE5)
    {
        pagecontroler.center=CGPointMake(pagecontroler.center.x, pagecontroler.center.y+30);
    }
    
    
    self.lblHeading.font=[UIFont fontWithName:Regular size:17];
    self.lblText.font=[UIFont fontWithName:Regular size:13];
    self.btnRegister.titleLabel.font=[UIFont fontWithName:Bold size:15];
    self.btnSignin.titleLabel.font=[UIFont fontWithName:Bold size:15];

   /* self.FBloginButton.backgroundColor=[UIColor clearColor];
    self.FBloginButton.readPermissions=@[@"public_profile", @"email", @"user_friends",@"user_birthday"];
    
    for (id loginObject in _FBloginButton.subviews)
    {
        if ([loginObject isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton1 =  loginObject;
            [loginButton1 setBackgroundImage:[UIImage imageNamed:@"facebook-login_03.png"] forState:UIControlStateNormal];
            loginButton1.frame = CGRectMake(0,0,280,40);
            [loginButton1 setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton1 setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton1 addTarget:self action:@selector(facebookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([loginObject isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  loginObject;
            loginLabel.text = @"Sign in with facebook";
            loginLabel.textAlignment = UITextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 0, 271, 37);
        }
    }*/
    
    
}

-(void)swipeToGetDishes{
    
    appDel.accessToken=@"";
    [self performSegueWithIdentifier:@"DishesSegue" sender:self];    
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
                               
                               NSLog(@"zip code:%@",self.zipString);
                           }
                           
                       });
                       
                   }];
}

#pragma mark -UNITING A COMMUNITY OF FOOD LOVERS TO INSPIRED CHEFS
#pragma mark - Button Actions
-(IBAction)socailBackBtnClicked:(id)sender
{
    [socialView removeFromSuperview];
}
- (IBAction)twitterButtonClicked:(id)sender {
    
    ////////login with IOSActions
    [self.view endEditing:YES];
    appDel.isFB=NO;
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        twitterScrenNme =username;
        [self getInfoTwitter];
    } errorBlock:^(NSError *error)
     {
         [self loginInSafariAction:nil];
         
     }];
    
    
}


/*- (IBAction)facebookButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    appDel.isFB=YES;
    
    self.FBloginButton.delegate = self;
    
    for (id loginObject in _FBloginButton.subviews)
    {
        if ([loginObject isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  loginObject;
            loginLabel.text = @"";
            loginLabel.frame = CGRectMake(-11, 0, 300, 40);
            loginLabel.textAlignment=NSTextAlignmentCenter;
            loginLabel.font=[UIFont systemFontOfSize:14.0f];
        }
    }
    
}*/

- (IBAction)Continue_Guest_Clicked:(id)sender
{
        appDel.accessToken=@"";
    DishesViewController *dishes=[[DishesViewController alloc]initWithNibName:@"DishesViewController" bundle:nil];
    [self.navigationController pushViewController:dishes animated:YES];
}
-(IBAction)LoginBtnClicked:(id)sender
{
}
-(IBAction)RegisterBtnClicked:(id)sender
{
    //mixpanel api call

    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Signup Clicked_iOSMobile" properties:nil];
    
    [self performSegueWithIdentifier:@"RegisterSegue" sender:self];
    
}


#pragma mark
#pragma mark -  Twitter Methods
- (void)loginInSafariAction:(id)sender
{
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:apiKey
                                                 consumerSecret:consumerKey];
    //[self.twitter postt]
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
         _CurrentTwitterID = userID;
         twitterId=userID;
         
         appDel.oauthToken = oauthToken;
         appDel.oauthTokenSecret = oauthTokenSecret;
         
         hud=nil;
         [hud setHidden:YES];
         [hud removeFromSuperview];
         if(hud==nil)
         {
             hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
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
         NSString *urlquerystring=[NSString stringWithFormat:@"checkTWUser?twitterId=%@",twitterId];
         [parser parseAndGetDataForGetMethod:urlquerystring];
         
         
     } errorBlock:^(NSError *error) {
         
         [[[UIAlertView alloc]initWithTitle:AppTitle message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
         NSLog(@"-- %@", [error localizedDescription]);
     }];
}

-(void)getInfoTwitter{
    
    
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
                            _CurrentTwitterID = twitterId;
                            socialDict=[[NSDictionary alloc]initWithObjectsAndKeys:[nmesArr objectAtIndex:0],@"FirstName",[nmesArr objectAtIndex:1],@"LastName",@"",@"Email",twitterId,@"FBUserId", nil];
                            
                            if(appDel.CurrentCustomerDetails == nil)
                            {
                                appDel.CurrentCustomerDetails = [[ProfileClass alloc] init];
                            }
                            
                            appDel.CurrentCustomerDetails.user_first_name = [nmesArr objectAtIndex:0];
                            appDel.CurrentCustomerDetails.user_last_name = [nmesArr objectAtIndex:1];
                            appDel.CurrentCustomerDetails.user_email = @"";
                            appDel.CurrentCustomerDetails.user_twitter = twitterId;
                            
                            [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
                            
                            
                            if(hud==nil)
                            {
                                hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                                [hud show:YES];
                                [self.view addSubview:hud];
                                hud.delegate = (id)self;
                                
                            }
                            [emailImg setHidden:NO];
                            [socialEmailFld setHidden:NO];
                            parseInt=3;
                            NSString *urlquerystring=[NSString stringWithFormat:@"checkTWUser?twitterId=%@",twitterId];
                            [parser parseAndGetDataForGetMethod:urlquerystring];
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


-(IBAction)socailLoginBtnClicked:(id)sender
{
    
    if (appDel.isFB)
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
        //if([OffersBtn currentImage]==[UIImage imageNamed:@"checked_checkbox"])
        //ofer=1;
        
        parseInt=4;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.zipString,@"zipcode",
                                devicetoken,@"devicetoken",[socialDict valueForKey:@"FirstName"],@"firstname",[socialDict valueForKey:@"LastName"],@"lastname",[promoFld.text length]?promoFld.text:@"",@"promoId",[socialDict valueForKey:@"Email"],@"email",[socialDict valueForKey:@"FBUserId"],@"facebookId",[NSNumber numberWithInt:ofer],@"offers",nil];
        
        appDel.CurrentCustomerDetails.user_devicetoken = devicetoken;
        appDel.CurrentCustomerDetails.user_zipcode = self.zipString;
        
        [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
        
        [parser parseAndGetDataForPostMethod:params withUlr:@"facebookRegister"];
        
        
    }
    else
    {
        if (![socialEmailFld.text length])
            [GlobalMethods showAlertwithString:@"Please enter a your Email"];
        else if(![GlobalMethods isItValidEmail:socialEmailFld.text])
            [GlobalMethods showAlertwithString:@"Please enter a valid Email"];
        
        else
        {
            NSString *devicetoken=[GlobalMethods getUDIDOfdevice];
            int ofer=0;
            
            parseInt=4;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.zipString,@"zipcode",
                                    devicetoken,@"devicetoken",[socialDict valueForKey:@"FirstName"],@"firstname",[socialDict valueForKey:@"LastName"],@"lastname",[promoFld.text length]?promoFld.text:@"",@"promoId",socialEmailFld.text,@"email",[socialDict valueForKey:@"FBUserId"],@"twitterId",[NSNumber numberWithInt:ofer],@"offers",nil];
            
            appDel.CurrentCustomerDetails.user_devicetoken = devicetoken;
            appDel.CurrentCustomerDetails.user_zipcode = self.zipString;
            
            [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
            
            
            [parser parseAndGetDataForPostMethod:params withUlr:@"twitterRegister"];
        }
        
    }
}


#pragma mark
#pragma mark - HUD Delegtes
- (void)hudWasHidden:(MBProgressHUD *)huda {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    hud = nil;
}

#pragma mark
#pragma mark - parse Delegtes
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    //    [currentTextField resignFirstResponder];
    //    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    //    [socialScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
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
        else
        {
            [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
        }
        
    }
    else
    {
        //        NSLog(@"Login View Result: %@", result);
        //        NSLog(@"passwdFld.text: %@", passwdFld.text);
        //        CurrentUserPassword = passwdFld.text ;
        //        appDel.CurrentCustomerDetails.user_password = passwdFld.text ;
        if(parseInt==2)
        {
            [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
        }
        else if(parseInt==3)
        {
            NSLog(@"Login View Result: %@", result);
            
            if([[result valueForKey:@"message"]isEqualToString:@"User not exist"])
            {
                //[self.view addSubview:socialView];
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
            
            [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[favcount count]] forKey:@"FAVCount"];
            
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserProfile"];
            //[[NSUserDefaults standardUserDefaults] setObject:favcount forKey:@"FAVCount"];
            [[NSUserDefaults standardUserDefaults ] synchronize];
            
            
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
            appDel.CurrentCustomerDetails.user_password = @"";
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
            
            appDel.CurrentCustomerDetails.user_fb = _CurrentFacebookID;
            appDel.CurrentCustomerDetails.user_twitter = _CurrentTwitterID;
            
            //[appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
            
            _CurrentUserProfile = [appDel.objDBClass GetUserProfileDetails];
            
            [self InsertUserProfileDetails:dict];
            
            [self performSegueWithIdentifier:@"DishesSegue" sender:self];

//            DishesViewController *dishes=[[DishesViewController alloc]initWithNibName:@"DishesViewController" bundle:nil];
//            [self.navigationController pushViewController:dishes animated:YES];
        }
        else if(parseInt==4)
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
            NSArray * favcount=[[result  valueForKey:@"favorites"] valueForKey:@"dish_id"];
            appDel.orderHistroy_count=[[result  valueForKey:@"ordeHistory"] count];
            
            [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[favcount count]] forKey:@"FAVCount"];
            
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserProfile"];
            [[NSUserDefaults standardUserDefaults] setObject:favcount forKey:@"FAVCount"];
            [[NSUserDefaults standardUserDefaults ] synchronize];
            
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
            appDel.CurrentCustomerDetails.user_password = @"" ;
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
            [self performSegueWithIdentifier:@"DishesSegue" sender:self];

//            DishesViewController *dishes=[[DishesViewController alloc]initWithNibName:@"DishesViewController" bundle:nil];
//            [self.navigationController pushViewController:dishes animated:YES];
        }
        else
        {
            //[self.view addSubview:InitialRegistration];
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
    appDel.CurrentCustomerDetails.user_twitter = _CurrentTwitterID;
    appDel.CurrentCustomerDetails.user_fb = _CurrentFacebookID;
    appDel.CurrentCustomerDetails.user_password = _CurrentUserPassword;
    appDel.CurrentCustomerDetails.user_auth_id =  [NSString stringWithFormat:@"%@", [dict objectForKey:@"customerProfileId"]];
    
    [appDel.objDBClass InserUserProfileDetails: appDel.CurrentCustomerDetails];
    
    
}

-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    [hud hide:YES];
    [GlobalMethods showAlertwithString:err];
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
    [socialEmailFld setHidden:YES];
    _CurrentFacebookID = [NSString stringWithFormat:@"%@", [user objectForKey:@"id"]];
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
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    parseInt=3;
    NSString *urlquerystring=[NSString stringWithFormat:@"checkFBUser?facebookId=%@&email=%@",
                              [user objectForKey:@"id"], [user objectForKey:@"email"]];
    [parser parseAndGetDataForGetMethod:urlquerystring];
    
}
-(void)cleardata
{
//    _FBloginButton.delegate=nil;
//    [FBSession.activeSession closeAndClearTokenInformation];
//    [FBSession setActiveSession:nil];
//    
}
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"You are logged out.");
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}


#pragma mark
#pragma mark - Location manager delegate

// this delegate is called when the app successfully finds your current location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // this creates a MKReverseGeocoder to find a placemark using the found coordinates
    
}

// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}

#pragma mark -
#pragma mark - ScrollView Delegate Methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scroll.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = scroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pagecontroler.currentPage = page; // you need to have a **iVar** with getter for pageControl
    
    
    self.lblText.text = [textBoxArr objectAtIndex:page];
    self.lblHeading.text= [headingArr objectAtIndex:page];
}

#pragma mark -
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loginSegue"]) {
        LoginViewController *controller = ([segue.destinationViewController isKindOfClass:[LoginViewController class]]) ? segue.destinationViewController : nil;
        
        controller.zipString=self.zipString;

    }
}

@end



