//
//  DishesViewController.m
//  EnjoyFresh
//  Created by S Murali Krishna on 09/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//
#import <CoreGraphics/CoreGraphics.h>
#import "DishesViewController.h"
#import "Global.h"
#import "GlobalMethods.h"
#import "DIshesCustomCell.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "Dish_DetailViewViewController.h"
#import "NotificationViewController.h"
#import "FavouriteViewController.h"
#import "CKCalendarView.h"
#import "OrderConfirmationView.h"
#import "RestaurantDetailViewController.h"
#include <stdlib.h>

//#define int Cell_height=430;

BOOL senderFlag=NO;
OrderConfirmationView *ordCnfView;
NSMutableDictionary *dict;
int shareIndex;
int favFlag;
int switchTag=nil;
int withRatingCount=0;
int withoutRatingCount=0;
int Cell_height=430;
BOOL fromDropDown=NO;
CGPoint location;

@interface DishesViewController ()<CKCalendarDelegate>
{
}
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic)UIRefreshControl *refreshControl;
@property(nonatomic)CGPoint lastContentOffset;
@property(nonatomic)NSMutableArray *duplicateDatesArray,*availableDatesArray;
@property(nonatomic)BOOL isNOTFirstLunch;
@end
static UIColor *favcolor;
static UIColor *unfavcolor;
@implementation DishesViewController
@synthesize labelSlider,upperLabel,lowerLabel,Favarr,dishesArr,dishstrId,prodDic,quantityStr,currentDishName,dishesCopyArr,currentDishName1;
@synthesize searchActionSheet, layerView;
@synthesize UserFavorites, CurrentUserProfile, IsInitialLoad;
@synthesize CurrentButtonTag;
typedef void(^Completion)(NSDictionary*);


#pragma mark
#pragma mark - ViewController Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.duplicateDatesArray=[NSMutableArray new];
    self.availableDatesArray=[NSMutableArray new];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.languageOrLocale = @"en";
    _payPalConfig.merchantName = @"EnjoyFresh";
    IsInitialLoad = YES;
    
    CurrentButtonTag = 0;

    dishes_Tbl.delegate=self;
    dishes_Tbl.dataSource=self;
    
    //    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    //    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];

    catStr=@"CUISINE";
    ditStr=@"DIETARY";
    locStr=@"DELIVERY";
    dateStr=@"DATE";
    [[UIBarButtonItem appearance] setTitleTextAttributes: [GlobalMethods barbuttonFont] forState:UIControlStateNormal];
    
    appDel.dishesVC=self;
    appDel.IsProcessComplete = NO;
    favarr =[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"FAVCount"]];

    Favarr=[[NSMutableArray alloc]init];
    
    //    favcolor=[UIColor colorWithRed:194/255.0f green:194/255.0f blue:194/255.0f alpha:1.0f];
    //    unfavcolor=[UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    
    unfavcolor=[UIColor colorWithRed:194/255.0f green:194/255.0f blue:194/255.0f alpha:1.0f];
    favcolor=[UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    
    dropDwnBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    titleLbl.font=[UIFont fontWithName:Regular size:18.0f];
    
    
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.delegate = self;
    [hud show:YES];
    [self.view addSubview:hud];
   
    addrFromLocation=[[NSDictionary alloc]init];

    
    NSDictionary *dict=[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"];
    
    NSLog(@"Access Token: %@", appDel.accessToken);
   // [self locationService:self];
    
    //getting location latitude and longitude
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self updateCurrentLocation:^(NSDictionary *result) {
        
        
    }];
    
    
    if(!IS_IPHONE5)
    {
        [dishes_Tbl setFrame:CGRectMake(0, 64, 320, 510)];
    }
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor colorWithRed:138/255.0 green:188/255.0 blue:105/255.0 alpha:1];
    [self.refreshControl addTarget:self
                            action:@selector(getDishes)
                  forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.refreshControl];

    
    categoryArr=[[NSMutableArray alloc]init];
    dietryStr=@"";
    selCat=@"All";
    pickerSelIndex=0;
    
//    self.lowerLabel.center = CGPointMake(38.5, 107.5);
//    self.upperLabel.center = CGPointMake(160.5, 107.5);
    
    arr1=[NSMutableArray new];
    arr1=[NSMutableArray arrayWithObjects:@"Gluten-Free",@"Local Ingredients",@"Organic",@"Vegan",@"Vegetarian",nil];
    
    ///
    searchLayer = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.origin.y-35, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    searchLayer.userInteractionEnabled = NO;
    searchLayer.multipleTouchEnabled = NO;
    
    
    [self.view addSubview:searchLayer];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [searchLayer addGestureRecognizer:tapGesture];
    
    //Favarr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"FAVCount"] ] ;
    
    
    search_bar=[[UISearchBar alloc]initWithFrame:CGRectMake(0,0, 320, 40)];
    [self.view addSubview:search_bar];
    [self hideSearchBar];
    search_bar.delegate=self;
    search_bar.searchBarStyle=UISearchBarStyleMinimal;
    
    [self.scrollView bringSubviewToFront:search_bar];
    self.scrollView.delegate=self;

    [upperLabel setFont:[UIFont fontWithName:Regular size:14.0f]];
    [lowerLabel setFont:[UIFont fontWithName:Regular size:14.0f]];
    [self.lowerMiles setFont:[UIFont fontWithName:Regular size:10]];
    [self.uppermiles setFont:[UIFont fontWithName:Regular size:10]];
    
    [self.lblHeadLoc setFont:[UIFont fontWithName:Regular size:13]];

    
    [self.btnCategory.titleLabel setFont:[UIFont fontWithName:Medium size:11.0f]];
    [self.btnDate.titleLabel setFont:[UIFont fontWithName:Medium size:11.0f]];
    [self.btnDistance.titleLabel setFont:[UIFont fontWithName:Medium size:11.0f]];
    [self.btnOffering.titleLabel setFont:[UIFont fontWithName:Medium size:11.0f]];
    [self.btnDietary.titleLabel setFont:[UIFont fontWithName:Medium size:11.0f]];
    
    [self.btnCategory setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnDistance setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnOffering setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnDietary setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.btnClearAll.hidden=YES;
    for( UIView *v in dietaryVw.subviews)
    {
        if([v isKindOfClass:[UILabel class]])
        {
            [(UILabel *)v setFont:[UIFont fontWithName:Regular size:14.0f]];
        }
    }
    
    dteFmter=[[NSDateFormatter alloc]init];
    [dteFmter setDateFormat:@"yyy/MM/dd"];
    
    if(appDel.accessToken  == nil)
    {
        [self loginInBackGrounForAccessToken:dict];
        return;
    }
    else if((!appDel.accessToken || ![appDel.accessToken length]) && dict !=nil)
    {
        [self loginInBackGrounForAccessToken:dict];
        return;
    }
    else
    {
        [self performSelector:@selector(getDishes) withObject:nil afterDelay:3.0f];
    }
    
    favsArray = [appDel.objDBClass GetAllUserFavorites];

//    cgre
    
    switchTag=0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];

    //[self.scrollView setContentOffset:CGPointMake(0,-20) animated:YES];

    [self hideSearchBar];

}
- (void)appDidBecomeActive:(NSNotification *)notification {
    NSLog(@"did become active notification");
    [self updateCurrentLocation:^(NSDictionary *result) {
        
        
    }];
}

- (void)appWillEnterForeground:(NSNotification *)notification {
    NSLog(@"will enter foreground notification");
}

- (void)updateCurrentLocation :(Completion) compblock {
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:locationManager.location // You can pass aLocation here instead
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                                                 if (placemarks.count == 1) {
                               
                               CLPlacemark *place = [placemarks objectAtIndex:0];
                               
                               addrFromLocation=place.addressDictionary;
                           }
                       compblock(nil);

                   }];
}
-(void)showYourView{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDishes)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    if((appDel.IsProcessComplete || appDel.reviewSubmit1) && appDel.accessToken.length > 0 && appDel.accessToken )
    {
        appDel.IsProcessComplete = NO;
        appDel.reviewSubmit1=NO;
        switchTag=nil;
        selectedDate=nil;
        [self getDishes];
        return;
    }
    
//    if(dishesArr == nil && appDel.accessToken)
//    {
//        [self getDishes];
//        return;
//    }
    else
    {
        [dishes_Tbl reloadData];
        return;
    }
    
    
    if(!IsInitialLoad && appDel.accessToken)
    {
        IsInitialLoad = NO;
        [self getDishes];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    
    
    [Favarr removeAllObjects];
    [Favarr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"FAVCount"]];
    
    if(appDel.profileChanged)
    {
        appDel.profileChanged=NO;
        [self getDishes];
    }
    
#warning "change to production for live"
    
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
    
    if (switchTag == nil) {
        [self cusineArray];
        [self SetUnderScore:self.btnCategory];
        [self.btnCategory setAlpha:0.6f];
        [self.btnCategory setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnCategory.titleLabel.font=[UIFont fontWithName:Bold size:11];

    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)dismissKeyboard: (id)gesture
{
    [searchLayer setHidden:YES];
    if (![search_bar.text length]) {
        dishesArr= [dishesCopyArr copy];
        [dishes_Tbl reloadData];
    }
    [search_bar resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark - User Defined methods
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    location = [touch locationInView:touch.view];
    NSLog(@"positon:%f %f",location.x,location.y);
}

-(void)getOrderView:(NSDictionary *)result{
    ordCnfView =[[OrderConfirmationView alloc]init];
    ordCnfView.orderDetails=result;
    ordCnfView.disDetails=productDict;
    
    CGRect rec=ordCnfView.view.frame;
    ordCnfView.view.frame=rec;
    [self.view addSubview:ordCnfView.view];
    [self.view bringSubviewToFront:ordCnfView.view];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:ordCnfView.view cache:YES];
    [UIView setAnimationDuration:1.0f];
    ordCnfView.view.frame=rec;
    [UIView commitAnimations];
}
-(void)loginInBackGrounForAccessToken:(NSDictionary*)dict
{
    
    [self.view addSubview:hud];
    
    parseInt=1;
    if (hud==nil)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.delegate = self;
        [hud show:YES];
    }
    NSString *devicetoken=[GlobalMethods getUDIDOfdevice];
    CurrentUserProfile = [appDel.objDBClass GetUserProfileDetails];
    
    if(appDel.DeviceToken != nil)
    {
        CurrentUserProfile.user_devicetoken = appDel.DeviceToken;
        [appDel.objDBClass UpdateUserProfileDetails: CurrentUserProfile];
    }
    else
    {
        CurrentUserProfile.user_devicetoken = devicetoken;
        [appDel.objDBClass UpdateUserProfileDetails:CurrentUserProfile];
    }
    
    NSLog(@"User ID: %@", CurrentUserProfile.user_id);
    
    //    if([[dict allKeys]containsObject:@"twitter_id"])
    if(CurrentUserProfile.user_twitter != nil && CurrentUserProfile.user_twitter.length > 1)
    {
        //        NSString *urlquerystring=[NSString stringWithFormat:@"checkTWUser?twitterId=%@",[dict objectForKey:@"twitter_id"]];
        //        [parser parseAndGetDataForGetMethod:urlquerystring];
        
//        NSString *urlquerystring=
//        [NSString stringWithFormat:@"checkTWUser?twitterId=%@", CurrentUserProfile.user_twitter];
//        [parser parseAndGetDataForGetMethod:urlquerystring];
        NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:CurrentUserProfile.user_twitter,@"twitterId", nil];
        [parser parseAndGetDataForPostMethod:params withUlr:@"checkTWUser"];
        
    }
    
    //else if([[dict allKeys]containsObject:@"facebook_id"])
    else if(CurrentUserProfile.user_fb != nil && CurrentUserProfile.user_fb.length > 1)
    {
        //        NSString *urlquerystring=
        //        [NSString stringWithFormat:@"checkFBUser?facebookId=%@",[dict objectForKey:@"facebook_id"]];
        //        [parser parseAndGetDataForGetMethod:urlquerystring];
        
        NSString *urlquerystring=
        [NSString stringWithFormat:@"checkFBUser?facebookId=%@&email=%@",
         CurrentUserProfile.user_fb, CurrentUserProfile.user_email];
        [parser parseAndGetDataForGetMethod:urlquerystring];
        
        
    }
    else if (CurrentUserProfile!=nil)
    {
        //            emailFld.text=[dict valueForKey:@"Email"];
        //            passwdFld.text=[dict valueForKey:@"Password"];
        NSDictionary *dict=[[NSUserDefaults standardUserDefaults]valueForKey:@"credentials"];

        NSLog(@"Device Token: %@", CurrentUserProfile.user_devicetoken);
        
        NSDictionary *params= [NSDictionary dictionaryWithObjectsAndKeys:
                               CurrentUserProfile.user_email, @"email",
                               [dict valueForKey:@"Password"], @"password",
                               CurrentUserProfile.user_devicetoken, @"devicetoken",[appDel.token length]?appDel.token:@"",@"apn_device_token",nil];
        [parser parseAndGetDataForPostMethod:params withUlr:@"customerLogin"];
        
    }
    else
    {
        [self getDishes];
    }
}



-(void)getDishes
{
    NSLog(@"Access Token: %@", appDel.accessToken);
    parseInt=2;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    
    
    if (hud==nil)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.delegate = self;
        [self.view addSubview:hud];
        [hud show:YES];

    }
    
    NSString *zipCd=[[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"]valueForKey:@"zipcode"];
    
    zipCd = appDel.CurrentCustomerDetails.user_zipcode;
    
    NSString *urlquerystring;
    
    NSString *locationZIp=[addrFromLocation valueForKey:@"ZIP"];

    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied && locationZIp!=nil)
    {
        urlquerystring=[NSString stringWithFormat:@"getZipDishInfo?zip=%@&min=0&max=75&findNearMe=1",locationZIp];
    }
    else{
        if([zipCd length])
            urlquerystring=[NSString stringWithFormat:@"getZipDishInfo?accessToken=%@&zip=%@&min=%@&max=%@",appDel.accessToken,zipCd,lowerLabel.text,upperLabel.text];
        else
            urlquerystring=[NSString stringWithFormat:@"getZipDishInfo?zip=94101&min=0&max=25"];
    }
    [parser parseAndGetDataForGetMethod:urlquerystring];
    urlquerystring=nil;
    
}

-(void)getdefaultDishesforZip
{
    parseInt=2;
    
    if (hud==nil)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    NSString *urlquerystring=[NSString stringWithFormat:@"getZipDishInfo?zip=94101&min=0&max=25"];
    [parser parseAndGetDataForGetMethod:urlquerystring];
    urlquerystring=nil;
}
-(void)favouriteBtnClicked:(id)sender
{
    if ([appDel.accessToken isEqualToString:@""])
    {
        switchTag=nil;
        [[[UIAlertView alloc]initWithTitle:AppTitle message:@"Login to Favourite" delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES", nil]show]        ;
        return;
    }
   
    UIButton *btnTemp = (UIButton *)sender;
    int iTag = (int)btnTemp.tag;
    currentFavdict =[[NSDictionary alloc]init];
    currentFavdict=[dishesArr objectAtIndex:iTag];

    if ([[btnTemp currentImage] isEqual:[UIImage imageNamed:@"favoritebl.png"]]) {
        [btnTemp setImage:[UIImage imageNamed:@"favoritered.png"] forState:UIControlStateNormal];

    }
    else{
        [btnTemp setImage:[UIImage imageNamed:@"favoritebl.png"] forState:UIControlStateNormal];
 
    }
//    if (favFlag==1) {
//        [btnTemp setImage:[UIImage imageNamed:@"favoritebl.png"] forState:UIControlStateNormal];
//    }
//    else{
//        [btnTemp setImage:[UIImage imageNamed:@"favoritered.png"] forState:UIControlStateNormal];
//        
//    }

    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken, @"accessToken",[currentFavdict valueForKey:@"restaurant_id"],@"dishId",nil];
    parseInt=10;
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    [parser parseAndGetDataForPostMethod:params withUlr:@"markFavoriteDish"];
}



#pragma mark
#pragma mark - ParseAndGetData Delegates
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    
    BOOL errMsg=[[result valueForKey:@"error"]boolValue];
    
    NSString *strErrorMessage = [result valueForKey:@"message"];
    if((!errMsg || strErrorMessage.length > 0) && (strErrorMessage) && [strErrorMessage isKindOfClass:[NSString class]])
    {
        //[GlobalMethods showAlertwithString: strErrorMessage];
        NSLog(@"Dish Listing Result: %@", result);
        
        if([strErrorMessage isEqualToString:@"There is no user registered with this Facebook account. Please register"] ||
           [strErrorMessage isEqualToString:@"There is no user registered with this Twitter account. Please register"])
        {
            
        }
    }
    switch (parseInt) {
        case 1:
        {
            if (errMsg)
            {
                NSLog(@"Dish Listing Result: %@", result);
                [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
                [hud hide:YES];
                [hud removeFromSuperview];
                hud=nil;
            }
            else
            {
                NSLog(@"Dish Listing Result: %@", result);
                appDel.accessToken=[result valueForKey:@"accessToken"];
                
                NSMutableDictionary *dict12=[[NSMutableDictionary alloc]initWithDictionary:[result valueForKey:@"profile"]];
                
                appDel.CurrentCustomerDetails = [appDel.objDBClass GetUserProfileDetails];
                
                if(appDel.CurrentCustomerDetails == nil)
                {
                    appDel.CurrentCustomerDetails = [[ProfileClass alloc] init];
                }
                
                appDel.CurrentCustomerDetails.user_id = [NSString stringWithFormat:@"%@", [dict12 objectForKey:@"user_id"]];
                appDel.CurrentCustomerDetails.user_devicetoken = [NSString stringWithFormat:@"%@", [dict12 objectForKey:@"devicetoken"]];
                appDel.CurrentCustomerDetails.user_email = [NSString stringWithFormat:@"%@", [dict12 objectForKey:@"email"]];
                appDel.CurrentCustomerDetails.user_first_name = [NSString stringWithFormat:@"%@", [dict12 objectForKey:@"first_name"]];
                appDel.CurrentCustomerDetails.user_image = [NSString stringWithFormat:@"%@", [dict12 objectForKey:@"image"]];
                appDel.CurrentCustomerDetails.user_is_discount_applied =
                [NSString stringWithFormat:@"%@", [dict12 objectForKey:@"is_discount_applied"]];
                appDel.CurrentCustomerDetails.user_is_sweep = [NSString stringWithFormat:@"%@", [dict12 objectForKey:@"is_sweep"]];
                appDel.CurrentCustomerDetails.user_last_name = [NSString stringWithFormat:@"%@", [dict12 objectForKey:@"last_name"]];
                appDel.CurrentCustomerDetails.user_mobile = [NSString stringWithFormat:@"%@", [dict12 objectForKey:@"mobile"]];
                appDel.CurrentCustomerDetails.user_ref_promo = [NSString stringWithFormat:@"%@", [dict12 objectForKey:@"ref_promo"]];
                appDel.CurrentCustomerDetails.user_ref_promo_count =
                [NSString stringWithFormat:@"%@", [dict12 objectForKey:@"ref_promo_count"]];
                appDel.CurrentCustomerDetails.user_zipcode =
                [NSString stringWithFormat:@"%@", [dict12 objectForKey:@"zipcode"]];
                appDel.CurrentCustomerDetails.user_auth_id =  [NSString stringWithFormat:@"%@", [dict12 objectForKey:@"customerProfileId"]];
                
                appDel.CurrentCustomerDetails.user_password = appDel.CurrentCustomerDetails.user_password;
                
                
                [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
                
                CurrentUserProfile = [appDel.objDBClass GetUserProfileDetails];
                
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:dict12];
                Favarr =[[[result  valueForKey:@"favorites"] valueForKey:@"dish_id"] mutableCopy];
                Favarr =[[result  valueForKey:@"favorites"] mutableCopy];
                
                for(id favDetails in Favarr)
                {
                    NSMutableDictionary *favs=[[NSMutableDictionary alloc]initWithDictionary:favDetails];
                    [self InsertUserFavorites:favs];
                }
                
                appDel.orderHistroy_count=[[result  valueForKey:@"ordeHistory"] count];
                [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[Favarr count]] forKey:@"FAVCount"];
                
                 //[[NSUserDefaults standardUserDefaults] setObject:dict12 forKey:@"UserProfile"];
                //                [[NSUserDefaults standardUserDefaults] setObject:Favarr forKey:@"FAVCount"];
                //[[NSUserDefaults standardUserDefaults ] synchronize];
                
                [self performSelector:@selector(getDishes) withObject:nil afterDelay:.1f];
            }
            
        }
            break;
        case 11:
        {
            if (errMsg)
            {
                NSLog(@"Dish Listing Result: %@", result);
                if (!([[result valueForKey:@"message"]isEqualToString:@"There were no restaurants"] ||
                      [[result valueForKey:@"message"]isEqualToString:@"There were no dishes available"] ||
                      [[result valueForKey:@"message"]isEqualToString:@"There are no restaurants nearby"] ||
                      [[result valueForKey:@"message"]isEqualToString:@"There are no nearby restaurants"] ||
                      [[result valueForKey:@"message"]isEqualToString:@"There are no dishes available nearby your location"] ||
                      [[result valueForKey:@"message"]isEqualToString:@"There are no restaurants in your zipcode. Please try a different zipcode or try switching on GPS from your device Settings"] ||
                      [[result valueForKey:@"message"]isEqualToString:@"Your location was out of USA"]||[[result valueForKey:@"message"]isEqualToString:@"No dishes."]))
                    
                {
                    [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
                    
                    [hud hide:YES];
                    [hud removeFromSuperview];
                    hud=nil;
                    return;
                    
                }
                else{
                    [GlobalMethods showAlertwithString:@"Sorry,there are no dishes available in your area."];
                    
                    
                    [hud hide:YES];
                    [hud removeFromSuperview];
                    hud=nil;
                    return;
                }
            }
            else
            {
                withRatingCount=0;
                withoutRatingCount=0;
                datesArray=nil;
                datesArray=[[NSMutableArray alloc]init];
                dishesArr =[result valueForKey:@"message"];
                //                NSPredicate *pred=[NSPredicate predicateWithFormat:@"available = '1' && order_by_date <= avail_by_date && qty != '0'"];
                //                dishesArr=[dishesArr filteredArrayUsingPredicate:pred];
                dishesCopyArr=dishesArr;
                dishesCopyArr=[result valueForKey:@"message"];
                //NSLog(@"Dishes Details: %@",  dishesArr);
                [ offeringTypeArr addObjectsFromArray:(NSMutableArray *)[dishesArr valueForKey:@"offering_types"]];
                //[offeringTypeArr removeObjectIdenticalTo:[NSNull null]];
                NSSet *catSet1 = [NSSet setWithArray:offeringTypeArr];
                [offeringTypeArr removeAllObjects];
                
                [offeringTypeArr addObjectsFromArray:[catSet1 allObjects]];
                NSArray *arr1=[NSArray array];
                [offeringTypeArr removeObject:arr1];
                
                //////////////////////////////
                
                [categoryArr addObjectsFromArray:[dishesArr valueForKey:@"category"]];
                [categoryArr removeObjectIdenticalTo:[NSNull null]];
                
                datesArray=[result valueForKey:@"future_available_dates_of_all_dishes"];
                
                NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"All",@"title",@"0",@"type_id",nil];
                [categoryArr addObject:dict];
                NSSet *catSet = [NSSet setWithArray:categoryArr];
                [categoryArr removeAllObjects];
                dict=nil;
                [categoryArr addObjectsFromArray:[catSet allObjects]];
                NSArray *arr=[NSArray array];
                [categoryArr removeObject:arr];
                [dishes_Tbl reloadData];
                if (![dishesArr count]) {
                    [hud hide:YES];
                    [hud removeFromSuperview];
                    hud=nil;
                }
                arr=nil;
                
                    [dishes_Tbl setFrame:CGRectMake(0,89, 320,(Cell_height*withRatingCount+390*withoutRatingCount))];
                    [self.scrollView setContentSize:CGSizeMake(320,(Cell_height*withRatingCount+390*withoutRatingCount)+80)];
                
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
                
                categoryArr=[[categoryArr sortedArrayUsingDescriptors:@[sort]] mutableCopy];
                [categoryArr addObjectsFromArray:offeringTypeArr];
            }
        }
            break;
        case 2:
        {
            [self.refreshControl endRefreshing];
            if (errMsg)
            {
                NSLog(@"Dish Listing Result: %@", result);
                if (!([[result valueForKey:@"message"]isEqualToString:@"There were no restaurants"] ||
                      [[result valueForKey:@"message"]isEqualToString:@"There were no dishes available"] ||
                      [[result valueForKey:@"message"]isEqualToString:@"There are no restaurants nearby"] ||
                      [[result valueForKey:@"message"]isEqualToString:@"There are no nearby restaurants"] ||
                      [[result valueForKey:@"message"]isEqualToString:@"There are no dishes available nearby your location"] ||
                      [[result valueForKey:@"message"]isEqualToString:@"There are no restaurants in your zipcode. Please try a different zipcode or try switching on GPS from your device Settings"] ||
                      [[result valueForKey:@"message"]isEqualToString:@"Your location was out of USA"]||[[result valueForKey:@"message"]isEqualToString:@"No dishes."]))
                    
                {
                    [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
                    
                    
                    [hud hide:YES];
                    [hud removeFromSuperview];
                    hud=nil;
                    return;
                    
                }
                else
                {
                    [self getdefaultDishesforZip];
                }
                
            }
            else
            {
                withRatingCount=0;
                withoutRatingCount=0;
                dishesArr =[result valueForKey:@"message"];
//                NSPredicate *pred=[NSPredicate predicateWithFormat:@"available = '1' && order_by_date <= avail_by_date && qty != '0'"];
//                dishesArr=[dishesArr filteredArrayUsingPredicate:pred];
                dishesCopyArr=dishesArr;
                dishesCopyArr=[result valueForKey:@"message"];
                //NSLog(@"Dishes Details: %@",  dishesArr);
                [ offeringTypeArr addObjectsFromArray:(NSMutableArray *)[dishesArr valueForKey:@"offering_types"]];
                //[offeringTypeArr removeObjectIdenticalTo:[NSNull null]];
                NSSet *catSet1 = [NSSet setWithArray:offeringTypeArr];
                [offeringTypeArr removeAllObjects];

                [offeringTypeArr addObjectsFromArray:[catSet1 allObjects]];
                NSArray *arr1=[NSArray array];
                [offeringTypeArr removeObject:arr1];
                
                //////////////////////////////
                
                [categoryArr addObjectsFromArray:[dishesArr valueForKey:@"category"]];
                [categoryArr removeObjectIdenticalTo:[NSNull null]];
                
                datesArray=[result valueForKey:@"future_available_dates_of_all_dishes"];

                NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"All",@"title",@"0",@"type_id",nil];
                [categoryArr addObject:dict];
                NSSet *catSet = [NSSet setWithArray:categoryArr];
                [categoryArr removeAllObjects];
                dict=nil;
                [categoryArr addObjectsFromArray:[catSet allObjects]];
                NSArray *arr=[NSArray array];
                [categoryArr removeObject:arr];
                [dishes_Tbl reloadData];
                if (![dishesArr count]) {
                    [hud hide:YES];
                    [hud removeFromSuperview];
                    hud=nil;
                }
                
                    if (appDel.pushFlag == YES) {
                        [self performSegueWithIdentifier:@"NotificationSegue" sender:self];
                        appDel.pushFlag=NO;
                    }
                arr=nil;
                if (switchTag) {
                    [dishes_Tbl setFrame:CGRectMake(0,250, 320,(Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
                    [self.scrollView setContentSize:CGSizeMake(320,(Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
                    
                }
                else{
                   [dishes_Tbl setFrame:CGRectMake(0,89, 320,(Cell_height*withRatingCount+390*withoutRatingCount))];
                   [self.scrollView setContentSize:CGSizeMake(320,(Cell_height*withRatingCount+390*withoutRatingCount)+80)];
                }
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
                
                categoryArr=[[categoryArr sortedArrayUsingDescriptors:@[sort]] mutableCopy];
                [categoryArr addObjectsFromArray:offeringTypeArr];
                search_bar.text=nil;
            }
            //Hide searchbar
            self.isNOTFirstLunch=NO;

        }
            break;
        case 3:
        {
            NSLog(@"Dish Listing Result: %@", result);
            if (errMsg) {
                [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
                [hud hide:YES];
                [hud removeFromSuperview];
                hud=nil;
            }
            else
            {
                
                dishesArr =[result valueForKey:@"dishes"];
                NSPredicate *pred=[NSPredicate predicateWithFormat:@"available = '1' && order_by_date < avail_by_date && qty != '0'"];
                dishesArr=[dishesArr filteredArrayUsingPredicate:pred];
                dishesCopyArr=dishesArr;
                
                [categoryArr removeAllObjects];
                [categoryArr addObjectsFromArray:[dishesArr valueForKey:@"category"]];
                [categoryArr removeObjectIdenticalTo:[NSNull null]];
                
                
                NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"All",@"title",@"0",@"type_id",nil];
                [categoryArr addObject:dict];
                NSSet *catSet = [NSSet setWithArray:categoryArr];
                [categoryArr removeAllObjects];
                dict=nil;
                [categoryArr addObjectsFromArray:[catSet allObjects]];
                
                
                NSPredicate *prediate2=[NSPredicate predicateWithFormat:@"category.title == %@",selCat];
                NSPredicate *prediate3=[NSPredicate predicateWithFormat:@"restaurant_location.distance >= %f && restaurant_location.distance <= %f",[lowerLabel.text floatValue],[upperLabel.text floatValue]];
                
                NSPredicate *prediate1,*compoundPredicate;
                
                if([dietryStr length])
                {
                    prediate1=[NSPredicate predicateWithFormat:@"ANY dietary IN (%@)",dietryStr];
                    compoundPredicate= [NSCompoundPredicate andPredicateWithSubpredicates:@[prediate1,prediate2,prediate3]];
                }
                else
                    compoundPredicate= [NSCompoundPredicate andPredicateWithSubpredicates:@[prediate2,prediate3]];
                dishesArr=[dishesCopyArr filteredArrayUsingPredicate:compoundPredicate];
                [dishes_Tbl reloadData];
                if (![dishesArr count])
                {
                    [hud hide:YES];
                    [hud removeFromSuperview];
                    hud=nil;
                }
                
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
                
                categoryArr=[[categoryArr sortedArrayUsingDescriptors:@[sort]] mutableCopy];
            }
        }
            break;
        case 4:
        {
            NSLog(@"Dish Listing Result: %@", result);
            if (errMsg) {
                [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
                [hud hide:YES];
                [hud removeFromSuperview];
                hud=nil;
            }
            else
            {
                
                UIButton *bnt=(UIButton*)[self.view viewWithTag:tagint];
                
                if ([bnt.backgroundColor isEqual:unfavcolor]) {
                    bnt.backgroundColor=favcolor;
                }else{
                    bnt.backgroundColor=unfavcolor;
                    
                }
                
                if ([[result valueForKey:@"message"] isEqualToString:@"Dish marked as a favorite"] ||
                    [[result valueForKey:@"message"] isEqualToString:@"Dish marked as favorite"])
                {
                    [GlobalMethods showAlertwithString: @"Restaurant marked as favorite."];
                    bnt.backgroundColor=favcolor;
                    //[Favarr addObject:[[dishesArr objectAtIndex:tagint-111]valueForKey:@"dish_id"]];
                    
                    [appDel.objDBClass UpdateRestaurantFavorite:appDel.CurrentRestaurantID : @"Y"];
                    
                    //                    [Favarr removeAllObjects];
                    //                    [Favarr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"FAVCount"]];
                    [dishes_Tbl reloadData];
                    
                }else
                {
                    [GlobalMethods showAlertwithString: @"Restaurant unmarked as favorite."];
                    //                    [Favarr removeObject:[[dishesArr objectAtIndex:tagint-111]valueForKey:@"dish_id"]];
                    bnt.backgroundColor=unfavcolor;
                    
                    [appDel.objDBClass UpdateRestaurantFavorite:appDel.CurrentRestaurantID : @"N"];
                    
                    //                    [Favarr removeAllObjects];
                    //                    [Favarr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"FAVCount"]];
                    [dishes_Tbl reloadData];
                }
                [[NSUserDefaults standardUserDefaults] setObject:Favarr forKey:@"FAVCount"];
                [[NSUserDefaults standardUserDefaults ] synchronize];
            }
        }
            break;
        case 5:///////if paypal payment is successful this will call
        {
            NSLog(@"Dish Listing Result: %@", result);
            if (errMsg) {
                [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
                
                [hud hide:YES];
                [hud removeFromSuperview];
                hud=nil;
            }
            else
            {
               //[GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
                //[self getOrderView:result];
                
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[result valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    alert.tag=99;
                    [alert show];
                    NSDictionary *profileDict=[result valueForKey:@"userDetails"];
                    
                    NSDictionary *user;
                    
                    dict=[[NSMutableDictionary alloc]init];
                    user=[[[NSUserDefaults standardUserDefaults ] valueForKey:@"UserProfile"] mutableCopy];
                    
                    dict=[user mutableCopy];
                    [dict setValue:[profileDict valueForKey:@"is_discount_applied"] forKey:@"is_discount_applied"];
                    [dict setValue:[profileDict valueForKey:@"ref_promo_count"] forKey:@"ref_promo_count"];
                    
                    NSDictionary *address=appDel.deliveryAddr;
                    if (([address valueForKey:@"address_id"] == nil||[[address valueForKey:@"address_id"] isEqualToString:@""]) && [[address valueForKey:@"delivery_type"] integerValue] ==2) {
                        NSMutableArray *add=[[NSMutableArray alloc]init];
                        
                        if([dict valueForKey:@"deliveryAddresses"] != nil){
                            add= [[dict valueForKey:@"deliveryAddresses"]mutableCopy];
                        }
                        NSMutableDictionary *addr=[[result valueForKey:@"deliveryAddress"] mutableCopy];
                        [add addObject:addr];
                        [dict setObject:add forKey:@"deliveryAddresses"];
                    }
                    appDel.IsProcessComplete = YES;
                    
                    
                    // count = [[dict valueForKey:@"ref_promo_count"] integerValue];
                    @try {
                    [[NSUserDefaults standardUserDefaults ] setObject:dict forKey:@"UserProfile"];
                    [[NSUserDefaults standardUserDefaults ] synchronize];
                }
                @catch (NSException *exception) {
                    NSLog(@"paypal exception:%@",exception );
                }

                [hud hide:YES];
                [hud removeFromSuperview];
                hud=nil;
            }
        }
            break;
            
        case 10:
        {
            if ([[result valueForKey:@"message"] isEqualToString:@"Dish marked as a favorite"]  ||
                [[result valueForKey:@"message"] isEqualToString:@"Dish marked as favorite"])
            {
                
                BOOL isThere=NO;
                [favarr addObject:[currentFavdict valueForKey:@"restaurant_id"]];
                favFlag=1;
                NSArray * favsArray = [appDel.objDBClass GetAllUserFavorites];
                NSLog(@"%@",favsArray);
                
                for (FavoritesClass *dish in favsArray) {
                    if ([[currentFavdict valueForKey:@"restaurant_id"] isEqualToString: dish.restaurant_id] && [dish.restaurant_is_favorite isEqualToString:@"N"]) {
                        isThere=YES;
                    }
                }
                if (!isThere) {
                    UserFavorites = [[FavoritesClass alloc] init];
                    
                    NSMutableArray *ImagesStringArray = [[currentFavdict valueForKey:@"restaurant_details"] valueForKey:@"images"];
                    
                    if(ImagesStringArray.count > 0)
                    {
                        NSMutableDictionary *ThumbNailImage = ImagesStringArray[0];
                        UserFavorites.restaurant_image_thumbnail = [ThumbNailImage objectForKey:@"path_th"];
                    }
                    
                   else{
                       UserFavorites.restaurant_image_thumbnail=[[currentFavdict valueForKey:@"restaurant_details"] valueForKey:@"logo"];
                    }
                   
                    UserFavorites.restaurant_id = [NSString stringWithFormat:@"%@", [currentFavdict valueForKey:@"restaurant_id"]];
                    UserFavorites.restaurant_city = [NSString stringWithFormat:@"%@",[[currentFavdict valueForKey:@"restaurant_details"] valueForKey:@"restaurant_city"]];
                    UserFavorites.restaurant_title = [NSString stringWithFormat:@"%@",[[currentFavdict valueForKey:@"restaurant_details"]valueForKey:@"restaurant_title"]];
                    UserFavorites.restaurant_is_favorite = @"Y";
                    
                    [appDel.objDBClass AddUserFavorite: UserFavorites];
                }
                
                
                [GlobalMethods showAlertwithString: @"Restaurant marked as favorite"];
                [appDel.objDBClass UpdateRestaurantFavorite:appDel.CurrentRestaurantID : @"Y"];
            }
            else{
                favFlag=0;
                [favarr removeObject:[currentFavdict valueForKey:@"restaurant_id"]];
                
                [GlobalMethods showAlertwithString: @"Restaurant unmarked as favorite"];
                [appDel.objDBClass UpdateRestaurantFavorite:appDel.CurrentRestaurantID : @"N"];
                
            }
            [[NSUserDefaults standardUserDefaults] setObject:favarr forKey:@"FAVCount"];
            [[NSUserDefaults standardUserDefaults ] synchronize];
            parseInt=NULL;
          [dishes_Tbl reloadData];
        }
            break;
        default:
            break;
    }
    
    if([appDel.orderClickedBeforeLogin isEqualToString:@"Y"] && dishesArr != nil)
    {
        [self performSegueWithIdentifier:@"DishDetailSegue" sender:self];
       // sleep(5);

    }
    if([appDel.favClickedBeforeLogin isEqualToString:@"Y"] && dishesArr != nil)
    {
        [self performSegueWithIdentifier:@"DishDetailSegue" sender:self];
      //  sleep(5);

    }
    if([appDel.resFavClickedBeforeLogin isEqualToString:@"Y"] && dishesArr != nil)
    {
        [self performSegueWithIdentifier:@"RPPSegue" sender:self];
       // sleep(5);

    }
    
        
}
-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    [self.refreshControl endRefreshing];
    [hud hide:YES];
    [hud removeFromSuperview];
    hud=nil;
    [GlobalMethods showAlertwithString:err];
}

#pragma mark -
#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        return [dishesArr count];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20-09-2012"];
    
//    NSDate *date=[self.dateFormatter dateFromString:[[dishesArr objectAtIndex:indexPath.row] valueForKey:@"avail_by_date"]];
//    if (date !=nil ) {

    //    }
    NSString *rating =[NSString stringWithFormat:@"%@",[[dishesArr objectAtIndex:indexPath.row] valueForKey:@"dish_rating"]];
    if ([rating isEqual:@"0"] || [rating isEqual:@""] || [rating isEqual:@" "]) {
        withoutRatingCount++;
        return 390;
    }
    else{
        withRatingCount++;
        return 430;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    DIshesCustomCell *cell = (DIshesCustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
            //cell = [[DIshesCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    NSDictionary *dict=[dishesArr objectAtIndex:indexPath.row];
    [cell.contentView.superview setClipsToBounds:YES];

    
    float price=[[dict valueForKey:@"price"] floatValue];
    if (price*0.20 >5) {
        price=price+5;
    }
    else{
     price=(price*0.20)+price;
    }
    cell.priceLbl.text=[NSString stringWithFormat:@"$ %.2f",price];

    if([[dict valueForKey:@"soldout"] integerValue] == 1)
    {
        cell.lblDate.hidden=YES;
        cell.drpImage.hidden=YES;
        cell.btnDropDown.hidden=YES;
        cell.btnSoldout.hidden=NO;
    }
   else{
       cell.lblDate.hidden=NO;
       cell.btnSoldout.hidden=YES;
       cell.drpImage.hidden=NO;
       cell.btnDropDown.hidden=NO;
    }
    
    cell.restaurantLbl.text=[NSString stringWithFormat:@"%@",[[dict valueForKey:@"restaurant_details"]valueForKey:@"restaurant_title"]];
    cell.dishNmeLbl.text=[dict valueForKey:@"dish_title"];
    cell.despLbl.text=[dict valueForKey:@"description"];
    
    NSString *rating =[NSString stringWithFormat:@"%@",[dict valueForKey:@"dish_rating"]];
    NSArray *ratings=[dict valueForKey:@"reviews"];
    cell.rateCount.text=[NSString stringWithFormat:@"(%lu)",(unsigned long)[ratings count]];
    cell.lblDishRating1.textColor=[UIColor lightGrayColor];
    cell.dishRating.textColor=[UIColor colorWithRed:239/255.0f green:194/255.0f blue:74/255.0f alpha:1.0f];
    if ([rating isEqual:@"0"] || [rating isEqual:@""] || [rating isEqual:@" "]) {
        [cell.dishRating setHidden:YES];
        [cell.lblDishRating1 setHidden:NO];
        // cell.btnRate.hidden=YES;
        cell.lblDishRating1.text=[stars substringToIndex:5-[rating integerValue]];
        cell.starsView.hidden=YES;
        cell.favView.frame=CGRectMake(0, 256, 306, 136);
        cell.backGroundView.frame=CGRectMake(8, 0, 306, 375);
        cell.share2.hidden=NO;
        [cell.dishNmeLbl setFrame:CGRectMake(8, 210,231,37)];

        // [self.scrollView setContentSize:CGSizeMake(320, self.scrollView.frame.size.height-40)];
    }
    else{
        cell.starsView.hidden=NO;
        [cell.dishRating setHidden:NO];
        [cell.lblDishRating1 setHidden:NO];
        cell.dishRating.text=[stars substringToIndex:[rating integerValue]];
        cell.lblDishRating1.text=[stars substringToIndex:5-[rating integerValue]];
        [cell.dishNmeLbl setFrame:CGRectMake(8, 210,281,37)];
        cell.favView.frame=CGRectMake(0, 296, 306, 136);
        cell.backGroundView.frame=CGRectMake(8, 0, 306, Cell_height);
        cell.share2.hidden=YES;
        
    }

    
    id img=[dict valueForKey:@"images"];
    NSDictionary *locDict;
    if ([img isKindOfClass:[NSArray class]])
    {
        NSArray *art=[dict valueForKey:@"images"];
        if ([art count]) {
            for (NSDictionary *dic in art) {
                if ([[dic valueForKey:@"default"] integerValue]==1){
                    locDict=dic;

                }
            }
        }
    }
    else
    {
        locDict=[dict valueForKey:@"images"];
    }
    cell.dishsImg.image=[UIImage imageNamed:@"Dish_Placeholder"];

    if([ locDict count]!=0)
    {
        
        NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLImage,[locDict valueForKey:@"path_lg"]];
        
        NSLog(@"Dish Image: %@", disturlStr);
        
        [cell.dishsImg sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"Dish_Placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if(image==nil)
                 cell.dishsImg.image=[UIImage imageNamed:@"Dish_Placeholder"];
             else
                 cell.dishsImg.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(320,200) source:image];
         }];
    }
    cell.restaurantImg.image=[UIImage imageNamed:@"nf_placeholder_restaurant"];
    
    NSArray *locDictrest=[[dict valueForKey:@"restaurant_details"] valueForKey:@"images"];

        NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLRestaurant,[[dict valueForKey:@"restaurant_details"] valueForKey:@"logo"]];
        
        NSLog(@"Restaurant Image: %@", disturlStr);
        
        [cell.restaurantImg sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"nf_placeholder_restaurant"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image==nil)
                cell.restaurantImg.image=[UIImage imageNamed:@"nf_placeholder_restaurant"];
            else
                cell.restaurantImg.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(60,60) source:image];
        }];
    
    cell.lblStateCity.text=[NSString stringWithFormat:@"%@,%@",[[dict valueForKey:@"restaurant_details"] valueForKey:@"restaurant_city"],[[dict valueForKey:@"restaurant_details"] valueForKey:@"restaurant_state"]];
   [cell.share2 addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnShare addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[self performSelector:@selector(shareClicked:) withObject:nil afterDelay:5];
    cell.btnShare.tag=indexPath.row;
    cell.share2.tag=indexPath.row;
    
    [cell.addOrderBtn setTag:indexPath.row+222];
    [cell.segueButton setTag:indexPath.row+222];
    [cell.segueButton2 setTag:indexPath.row+222];
    [cell.btnRate setTag:indexPath.row+222];
    [cell.btnRPP setTag:indexPath.row+222];
    [cell.btnDropDown setTag:indexPath.row+222];
    [cell.segueButton2 addTarget:self action:@selector(addToOrderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    [cell.addOrderBtn addTarget:self action:@selector(addToOrderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.segueButton addTarget:self action:@selector(addToOrderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRPP addTarget:self action:@selector(performRPPSegue:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRate addTarget:self action:@selector(addToOrderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDropDown addTarget:self action:@selector(showDates:) forControlEvents:UIControlEventTouchUpInside];

    
    [cell.btnLike addTarget:self action:@selector(favouriteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLike setTag:indexPath.row];
    
    cell.dishNmeLbl.lineBreakMode=NSLineBreakByClipping;
    cell.restaurantLbl.lineBreakMode=NSLineBreakByClipping;
    
    NSString *restaurantID = [NSString stringWithFormat:@"%@", [dict valueForKey:@"restaurant_id"] ];
    NSString *favStatus = [appDel.objDBClass GetFavoriteStatusForRestaurant: restaurantID];
    
    if([favStatus isEqualToString:@"Y"])
    {
        [cell.btnLike setImage:[UIImage imageNamed:@"favoritered.png"] forState:UIControlStateNormal];
        //Dish_like_btn2.backgroundColor=favcolor;
         favFlag=1;
    }
    else
    {
        [cell.btnLike setImage:[UIImage imageNamed:@"favoritebl.png"] forState:UIControlStateNormal];
        //Dish_like_btn2.backgroundColor=unfavcolor;
         favFlag=0;
    }


//    dishes_Tbl.separatorColor = [UIColor colorWithRed:68/255. green:59/255. blue:60/255. alpha:1.0f];
//    UIView *ColorView = [[UIView alloc] init];
//    [ColorView setBackgroundColor:[UIColor clearColor]];
//    [cell setBackgroundView:ColorView];
    NSArray*date;
    NSArray*dateOrder=[[dict valueForKey:@"order_by_date"] componentsSeparatedByString:@"-"];
    
    //cell.ordeByLbl.text=[NSString stringWithFormat:@"ORDER BY : %@/%@ %2ld:%.2ld %@",[dateOrder objectAtIndex:1],[dateOrder objectAtIndex:2],(long)[[dict valueForKey:@"order_by_hr"] integerValue],(long)[[dict valueForKey:@"order_by_min"] integerValue],[dict valueForKey:@"order_by_ampm"]];
   
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date1;
    
    if (selectedDate==nil) {
        date=[[dict valueForKey:@"avail_by_date"] componentsSeparatedByString:@"-"];
        date1=[format dateFromString:[dict valueForKey:@"avail_by_date"]];
    }
    else{
        NSPredicate *pred=[NSPredicate predicateWithFormat:@"avail_by_date==%@",selectedDate];
        NSArray *arr=[dict valueForKey:@"future_available_dates"];
        
        NSArray *dic=[arr filteredArrayUsingPredicate:pred];
        date=[[[dic objectAtIndex:0] valueForKey:@"avail_by_date"] componentsSeparatedByString:@"-"];
        date1=[format dateFromString:[[dic objectAtIndex:0] valueForKey:@"avail_by_date"]];

    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:date1];
   
    NSDateFormatter *weekDay = [[NSDateFormatter alloc] init];
    [weekDay setDateFormat:@"EEE"];
    
    NSDateFormatter *calMonth = [[NSDateFormatter alloc] init];
    [calMonth setDateFormat:@"MMM"];
    
    if ([[dict valueForKey:@"future_available_dates"] count]==1) {
        cell.btnDropDown.hidden=YES;
        cell.drpImage.hidden=YES;
    }
    
    cell.lblDate.text=[NSString stringWithFormat:@"%@ %@,%@ @ %.2ld:%.2ld %@ - %.2ld:%.2ld %@",[weekDay stringFromDate:date1],[calMonth stringFromDate:date1],[date objectAtIndex:2],(long)[[dict valueForKey:@"avail_by_hr"] integerValue],(long)[[dict valueForKey:@"avail_by_min"] integerValue],[dict valueForKey:@"avail_by_ampm"],(long)[[dict valueForKey:@"avail_by_hr_till"] integerValue],(long)[[dict valueForKey:@"avail_by_min_till"] integerValue],[dict valueForKey:@"avail_by_ampm_till"]];
    
    [cell layoutIfNeeded]; // <- added

    return cell;
}
#pragma mark -
#pragma mark - Tableview Delgates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
   //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    Dish_DetailViewViewController *details=[[Dish_DetailViewViewController alloc]initWithNibName:@"Dish_DetailViewViewController" bundle:nil];
//    details.Dish_Details_dic=[dishesArr objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:details animated:YES];
    
    //    if(drp!=nil)
    //    {
    //        [drp.view removeFromSuperview];
    //        drp=nil;
    //    }
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(void) SetDefaultOptionColors
{
    [catBtn setTintColor: [UIColor blackColor]];
    [dietaryBtn setTintColor: [UIColor blackColor]];
    [locBtn setTintColor: [UIColor blackColor]];
    [dateBtn setTintColor: [UIColor blackColor]];
    [btnUnderScore setHidden: YES];
    [btnDietaryUnderScore setHidden: YES];
    [btnLocUnderScore setHidden: YES];
    [btnDateUnderScore setHidden: YES];
    
    
}

//- (void) SetUnderScore : (UIButton *) CurrentButton
//{
//    
//    btnUnderScore.backgroundColor = [UIColor colorWithRed:139/255.0f green:139/255.0f  blue:139/255.0f  alpha:1.0];
//    [CurrentButton setTitleColor: unfavcolor forState: UIControlStateNormal];
//    
//    float underScoreWidth = CurrentButton.frame.size.width * 0.5f;
//    btnUnderScore.frame = CGRectMake(
//                                     CurrentButton.frame.origin.x + (CurrentButton.frame.size.width - underScoreWidth)/2,
//                                     CurrentButton.frame.origin.y + CurrentButton.frame.size.height + 1.5,
//                                     underScoreWidth, 2);
//    
//    
//    [btnUnderScore setHidden: NO];
//    //    [dishes_Tbl addSubview:btnUnderScore];
//}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 0;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
        // This is the last cell
    }
    [hud hide:YES];
    [hud removeFromSuperview];
    hud=nil;
    
    
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
#pragma mark
#pragma mark - ScrollView Delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(!IS_IPHONE5){
//        [dishes_Tbl setFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64)];
//    }
    [self HideShareView];
    UISearchBar *searchBar = search_bar;
    CGRect rect = searchBar.frame;
    rect.origin.y = MIN(0, self.scrollView.contentOffset.y);
    searchBar.frame = rect;
    
    CGPoint currentOffset = scrollView.contentOffset;
    if (currentOffset.y > self.lastContentOffset.y && currentOffset.y>10)
    {
        // Upward
        [self hideSearchBar];
        self.isNOTFirstLunch=YES;

    }
    else if((currentOffset.y ==-10 && self.isNOTFirstLunch==NO)||self.isNOTFirstLunch==NO)
    {
        // Upward
        [self hideSearchBar];
        
    }else{
        
        [self showSearchBar];
        self.isNOTFirstLunch=YES;
                // Downward

    }
    self.lastContentOffset = currentOffset;

}

#pragma mark
#pragma mark - Button Actions
- (void)shareClicked:(id)sender
{
    //[self shareText: currentDishTitle andImage:currentDishImage andUrl:nil];
    shareIndex=(int)[sender tag];
    
    _shareViewIsHidden = !_shareViewIsHidden;
    
    if(_shareViewIsHidden)
    {
        [self ShowShareView];
    }
    else
    {
        [self HideShareView];
    }
    
    //[self per]
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        NSDictionary *dict=[dishesArr objectAtIndex:shareIndex];
        currentDishName = [[NSMutableString alloc] init];
        currentDishName1 = [[NSMutableString alloc] init];

        _currentDishTitle = [[NSMutableString alloc] init];
        _currentDishTweet = [[NSMutableString alloc] init];
        _currentTweeturl=[[NSMutableString alloc] init];
        
       // currentDishName =[dict valueForKey:@"dish_title"];
        [currentDishName1 appendString: [dict valueForKey:@"dish_title"]];

        [currentDishName appendString: [dict valueForKey:@"dish_title"]];
        _currentDishDescription =[dict valueForKey:@"description"];

        [_currentDishTitle appendString: [dict valueForKey:@"dish_title"]];
        
        [_currentDishTweet appendString:[NSString stringWithFormat:@"Yumm! craving this '%@' on @Enjoy_fresh\n",[dict valueForKey:@"dish_title"]]];
        [_currentTweeturl appendString: [dict valueForKey:@"dish_profile_url"]];
        
        
        [_currentDishTitle appendString: @"\n\n"];
        [_currentDishTitle appendString:[dict valueForKey:@"description"]];
        [_currentDishTitle appendString: @"\n"];
        
        NSDictionary *locDict=[dict valueForKey:@"images"];
        NSData *imageData;
        if ([locDict count]!=0) {
            imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURLImage,[[[dict valueForKey:@"images"] objectAtIndex:0] valueForKey:@"path_lg"] ]]];
            
            if(imageData == NULL || imageData == nil){
                _currentDishImage=[UIImage imageNamed:@"Dish_Placeholder.png"];
                
            }
            else{
                UIImage *image=[UIImage imageWithData:imageData];
                _currentDishImage=image;
            }
            
        }
        else{
            _currentDishImage=[UIImage imageNamed:@"Dish_Placeholder.png"];
            
        }
        _currentDishRestaurant = [dict valueForKey:@"restaurant_title"];
        });

  
}
- (void) ShowShareView
{
   // shareButton.alpha = 0.35f;
    [self.view addSubview: self.shareView];
    [self.view bringSubviewToFront: self.shareView];
    
    self.shareView.frame
    = CGRectMake(0, [UIScreen mainScreen].bounds.size.height,
                 self.shareView.frame.size.width, self.shareView.frame.size.height);
    
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
     {
         self.shareView.frame
         = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.shareView.frame.size.height,
                      self.shareView.frame.size.width, self.shareView.frame.size.height);
     }
                     completion:^(BOOL finished)
     {
         
         
     }];
}
- (IBAction)refineSearchMethod:(id)sender {
    [self.view endEditing:YES];
    [self showHUD];
    withRatingCount=0;
    withoutRatingCount=0;
    UIButton *curButton=(UIButton *)[self.scrollView viewWithTag:[sender tag]];
    [self SetUnderScore:curButton];
    [curButton setAlpha:0.60f];
    [curButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    curButton.titleLabel.font=[UIFont fontWithName:Bold size:11];
    dispatch_async( dispatch_get_main_queue(), ^{
        // Add code here to update the UI/send notifications based on the
        // results of the background processing
        if ([sender tag] == 11) {
            
            [dishes_Tbl reloadData];
            
            [dishes_Tbl setFrame:CGRectMake(0,250, 320, (Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
            [self.scrollView setContentSize:CGSizeMake(320,(Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
            switchTag=(int)[sender tag];
            [self cusineArray];
            
            [self.btnDistance setAlpha:1.0f];
            [self.btnOffering setAlpha:1.0f];
            [self.btnDietary setAlpha:1.0f];
            [self.btnDate setAlpha:1.0f];
            
            self.btnDistance.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnOffering.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnDietary.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnDate.titleLabel.font=[UIFont fontWithName:Medium size:11];
            
            [self.btnDistance setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnOffering setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnDietary setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        else if([sender tag] == 22){
            [dishes_Tbl reloadData];
            
            [dishes_Tbl setFrame:CGRectMake(0,250, 320, (Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
            [self.scrollView setContentSize:CGSizeMake(320,(Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
            // [self resetOfferings]
            // [self setImages];
            self.cuisineDietaryView.hidden=YES;
            self.sliderOfferingView.hidden=NO;
            self.offeringView.hidden=NO;
            self.calendarView.hidden=YES;
            switchTag=(int)[sender tag];
            
            [self.btnCategory setAlpha:1.0f];
            [self.btnDate setAlpha:1.0f];
            [self.btnDistance setAlpha:1.0f];
            [self.btnDietary setAlpha:1.0f];
            
            self.btnCategory.titleLabel.font=[UIFont fontWithName:Medium size:11];
            self.btnDistance.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnDietary.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnDate.titleLabel.font=[UIFont fontWithName:Medium size:11];
            
            [self.btnCategory setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnDistance setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnDietary setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
        }
        else if ([sender tag] == 33){
            [dishes_Tbl reloadData];
            
            [dishes_Tbl setFrame:CGRectMake(0,250, 320, (Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
            [self.scrollView setContentSize:CGSizeMake(320,(Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
            self.cuisineDietaryView.hidden=NO;
            self.sliderOfferingView.hidden=YES;
            self.calendarView.hidden=YES;
            
            switchTag=(int)[sender tag];
            
            [self.refineScroll.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
            [self dietaryArray];
            [self.refineScroll setContentSize:CGSizeMake(self.refineScroll.frame.size.width,116)];
            [self.btnDate setAlpha:1.0f];
            [self.btnDistance setAlpha:1.0f];
            [self.btnCategory setAlpha:1.0f];
            [self.btnOffering setAlpha:1.0f];
            
            [self.btnDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnDistance setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnCategory setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnOffering setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            self.btnCategory.titleLabel.font=[UIFont fontWithName:Medium size:11];
            self.btnDistance.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnOffering.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnDate.titleLabel.font=[UIFont fontWithName:Medium size:11];
        }
        else if ([sender tag] == 44){
            [dishes_Tbl reloadData];
            
            [dishes_Tbl setFrame:CGRectMake(0,250, 320, (Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
            [self.scrollView setContentSize:CGSizeMake(320,(Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
            [self configureLabelSlider ];
            [self updateSliderLabels];
            self.cuisineDietaryView.hidden=YES;
            self.sliderOfferingView.hidden=NO;
            self.offeringView.hidden=YES;
            self.calendarView.hidden=YES;
            
            if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
            {
                self.txtfindZip.text=[addrFromLocation valueForKey:@"ZIP"];
            }
            else{
                NSString *zipCd=[[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"]valueForKey:@"zipcode"];
                
                //zipCd = appDel.CurrentCustomerDetails.user_zipcode;
                self.txtfindZip.text=zipCd;
            }
            
            switchTag=(int)[sender tag];
            
            [self.btnDate setAlpha:1.0f];
            [self.btnOffering setAlpha:1.0f];
            [self.btnDietary setAlpha:1.0f];
            [self.btnCategory setAlpha:1.0f];
            
            [self.btnDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnOffering setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnDietary setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnCategory setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            self.btnCategory.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnOffering.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnDietary.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnDate.titleLabel.font=[UIFont fontWithName:Medium size:11];
        }
        else{
            self.cuisineDietaryView.hidden=YES;
            self.sliderOfferingView.hidden=YES;
            self.offeringView.hidden=YES;
            self.calendarView.hidden=NO;
            switchTag=(int)[sender tag];
            [self.calendar removeFromSuperview];
            CKCalendarView *calendar =nil;
            [calendar removeFromSuperview];
            calendar=[[CKCalendarView alloc] initWithStartDay:startSunday];
            self.calendar = calendar;
            
            
            calendar.onlyShowCurrentMonth = NO;
            calendar.adaptHeightToNumberOfWeeksInMonth = YES;
            calendar.backgroundColor=[UIColor colorWithRed:(147/255.0) green:(189/255.0) blue:(119/255.0) alpha:1];
            calendar.frame = CGRectMake(10,5,280, 260);
            calendar.delegate = self;
            [self.calendarView addSubview:calendar];
            //        [self.calendarView bringSubviewToFront:self.tempView];
            [self.calendarView sendSubviewToBack:calendar];
            [dishes_Tbl setFrame:CGRectMake(0,295+146, 320, Cell_height*[dishesArr count]+ 289)];
            [self.scrollView setContentSize:CGSizeMake(320,Cell_height*[dishesArr count]+ 289+146)];
            
            
            [self.btnDistance setAlpha:1.0f];
            [self.btnOffering setAlpha:1.0f];
            [self.btnDietary setAlpha:1.0f];
            [self.btnCategory setAlpha:1.0f];
            
            [self.btnDistance setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnOffering setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnDietary setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnCategory setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            self.btnCategory.titleLabel.font=[UIFont fontWithName:Medium size:11];
            self.btnDistance.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnOffering.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnDietary.titleLabel.font=[UIFont fontWithName:Medium size:11];
        }

        
        
        [self performSelector:@selector(hudWasHidden:) withObject:nil afterDelay:4];
    });

}
-(void)resetDeit:(id)sender{
    withRatingCount=0;
    withoutRatingCount=0;
    dishesArr=[dishesCopyArr copy];
    [dishes_Tbl reloadData];
    
    [dishes_Tbl setFrame:CGRectMake(0,250, 320, (Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
    [self.scrollView setContentSize:CGSizeMake(320,(Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
    [self dietaryArray];
}

- (IBAction)resetDistance:(id)sender {
    [self configureLabelSlider ];
    [self setImages];
    //[self updateSliderLabels];
    self.labelSlider.lowerValue = 0;
    self.labelSlider.upperValue=25;
    self.lowerLabel.text=@"0";
    self.upperLabel.text=@"25";
    //sliderFirst=NO;
    self.lowerLabel.center=CGPointMake(22.0f, 54.0f);
    self.upperLabel.center=CGPointMake(110.0f, 54.0f);
    self.lowerMiles.center=CGPointMake(22.0f, 66.0f);
    self.uppermiles.center=CGPointMake(110.0f,66.0f);

    //[self updateSliderLabels];
    parseInt=2;
    [self getDishes];

}

- (IBAction)distaneSearch:(id)sender {
//    [self setImages];
//    parseInt=2;
//    [self getDishes];
    selectedDate=nil;

    if (hud==nil)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.delegate = self;
        [self.view addSubview:hud];
        [hud show:YES];
        
    }
    [self updateCurrentLocation:^(NSDictionary *result) {
        
        
        [self.view endEditing:YES];
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache clearMemory];
        [imageCache clearDisk];
        
        
        NSString *zipCd=[[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"]valueForKey:@"zipcode"];
        
        zipCd = appDel.CurrentCustomerDetails.user_zipcode;
        NSString *locationZIp=[addrFromLocation valueForKey:@"ZIP"];
        
        NSString *urlquerystring;
        
        if([CLLocationManager locationServicesEnabled] &&
           [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied && locationZIp!=nil)
        {
            parseInt=11;
            
            
            urlquerystring=[NSString stringWithFormat:@"getZipDishInfo?zip=%@&min=0&max=75&findNearMe=1",locationZIp];
            [parser parseAndGetDataForGetMethod:urlquerystring];
            urlquerystring=nil;
            
        }
        else{
            
            [hud hide:YES];
            [hud removeFromSuperview];
            hud=nil;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EnjoyFresh"
                                                            message:@"Location service is not enabled"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
            alert.tag=88;
            [alert show];
        }

    }];
    
}

-(void)dietaryArray{
    int x=10,y=10;
    int rem;
    
    for (int i=0; i<arr1.count; i++) {
        NSString *myString=[arr1 objectAtIndex:i];
        CGSize stringsize = [myString sizeWithFont:[UIFont fontWithName:Regular size:13]];
        //or whatever font you're using
        UIButton *button=[[UIButton alloc]init];
        rem=self.refineScroll.frame.size.width-x;
        if (rem <= stringsize.width+25 ) {
            y=y+35;
            x=10;
        }
        [button setTitle:myString forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:(239/255.0) green:(239/255.0) blue:(239/255.0) alpha:1]];
        button.layer.cornerRadius=10.0f;
        button.layer.borderColor=([UIColor colorWithRed:(235/255.0) green:(235/255.0) blue:(235/255.0) alpha:1]).CGColor;
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.layer.borderWidth=1.0f;
        
        [button.titleLabel setFont:[UIFont fontWithName:Regular size:13]];
        [button addTarget:self action:@selector(refineSelector:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setFrame:CGRectMake(x,y,stringsize.width+25,20)];
        x=x+button.frame.size.width+15;
        
        [button setTag:i];
        [self.refineScroll addSubview:button];
        //[self.refineScroll setContentSize:CGSizeMake(self.refineScroll.frame.size.width,y)];

        
    }
    UIButton *resetBtn=[[UIButton alloc]initWithFrame:CGRectMake(240, 80, 50, 30)];
    [resetBtn setTitle:@"RESET" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    resetBtn.titleLabel.font=[UIFont fontWithName:SemiBold size:12];
    resetBtn.tag=222;
    [resetBtn setBackgroundColor:[UIColor whiteColor]];
    [self.refineScroll bringSubviewToFront:resetBtn];
    [resetBtn addTarget:self action:@selector(resetDeit:) forControlEvents:UIControlEventTouchUpInside];
    [self.refineScroll addSubview:resetBtn];
    //[self.refineScroll setContentSize:CGSizeMake(320,50)];
}

-(void)cusineArray{
    
    self.cuisineDietaryView.hidden=NO;
    self.sliderOfferingView.hidden=YES;
    self.calendarView.hidden=YES;
    
    int x=10,y=13;
    [self.refineScroll.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    NSMutableArray *catArr=[[NSMutableArray alloc]init];
    for (int i=0; i<categoryArr.count; i++) {
        [catArr addObject:[[categoryArr objectAtIndex:i]valueForKey:@"title"]];
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    [catArr sortUsingDescriptors:sortDescriptors];
    int rem;
    
    NSMutableArray *buttons=[[NSMutableArray alloc]init];
        for (int i=0; i<catArr.count; i++) {
        NSString *myString=[catArr objectAtIndex:i];
        CGSize stringsize = [myString sizeWithFont:[UIFont fontWithName:Regular size:13]];
        //or whatever font you're using
        UIButton *button=[[UIButton alloc]init];
        rem=self.refineScroll.frame.size.width-x;
        if (rem <= stringsize.width+25 ) {
            y=y+35;
            x=10;
        }
        [button setTitle:myString forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1]];
        button.layer.cornerRadius=10.0f;
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.layer.borderWidth=1.0f;
        button.layer.borderColor=([UIColor colorWithRed:(235/255.0) green:(235/255.0) blue:(235/255.0) alpha:1]).CGColor;
        //[button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [button.titleLabel setFont:[UIFont fontWithName:Regular size:13]];
        [button addTarget:self action:@selector(refineSelector:) forControlEvents:UIControlEventTouchUpInside];
        //+10 for left right padding
        [button setFrame:CGRectMake(x,y,stringsize.width+25,20)];
        x=x+button.frame.size.width+15;
        if (allflag==NO ) {
            button.layer.borderColor=[UIColor colorWithRed:(147/255.0) green:(186/255.0) blue:(119/255.0) alpha:1].CGColor;
            [button setBackgroundColor:[UIColor colorWithRed:(147/255.0) green:(186/255.0) blue:(119/255.0) alpha:1]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            allflag=YES;
            clearClick=NO;
        }
        
        [button setTag:i];
        [self.refineScroll addSubview:button];
        
    }
   
    [self.refineScroll setContentSize:CGSizeMake(self.refineScroll.frame.size.width,y+50)];
}
- (void) SetUnderScore : (UIButton *) CurrentButton
{
    self.btnUnderscore.backgroundColor = [UIColor colorWithRed:144/255.0f green:186/255.0f blue:119/255.0f alpha:1.0f];
    
    float underScoreWidth = CurrentButton.frame.size.width;
    _btnUnderscore.frame = CGRectMake(
                                     (CurrentButton.frame.origin.x) + (CurrentButton.frame.size.width - underScoreWidth)/2,
                                     CurrentButton.frame.origin.y + CurrentButton.frame.size.height,
                                     underScoreWidth, btnUnderScore.frame.size.height);
}

-(void)changeForButton:(UIButton *)btn{
    for (UIButton *but in [self.refineScroll subviews]) {
        if (but.tag != btn.tag ) {
            if (but.tag==222) {
                
            }
            else{
                but.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
                //[btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                but.titleLabel.textColor=[UIColor darkGrayColor];
                but.layer.borderColor=([UIColor colorWithRed:(235/255.0) green:(235/255.0) blue:(235/255.0) alpha:1]).CGColor;
            }
        }
        
    }
    btn.backgroundColor=[UIColor colorWithRed:(147/255.0) green:(189/255.0) blue:(119/255.0) alpha:1];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.borderColor=[UIColor colorWithRed:(147/255.0) green:(189/255.0) blue:(119/255.0) alpha:1].CGColor;
    
 
}
-(void)refineSelector:(id)sender{
    
    [self showHUD];
    UIButton *btnTemp = (UIButton *)sender;
    int bTag = (int)btnTemp.tag;
    NSString *str=btnTemp.titleLabel.text;
    
  
    
       NSLog(@"string:%@",str);
    
    //refine array
    selCat=str;
    [self SetDefaultOptionColors];
    
    NSPredicate *veganPredict = nil;
    NSPredicate *vegetarianPredict = nil;
    NSPredicate *glutenPredict = nil;
    NSPredicate *organicPredict = nil;
    NSPredicate *localPredict = nil;
    NSString *predictString = @"";
    
    
    
    dispatch_async( dispatch_get_main_queue(), ^{
        
        [self setImages];
        [self resetImagesDel];
        NSArray *temparray=nil;
        NSMutableArray *compArr;
        NSMutableArray *arr=[NSMutableArray new];
        [dishes_Tbl reloadData];

        switch (switchTag) {
            case 11:
                
            {
                if([selCat isEqualToString:@"All"])
                {
                    if([dietryStr length])
                    {
                        NSPredicate *prediate1=[NSPredicate predicateWithFormat:@"ANY dietary IN (%@)",dietryStr];
                        NSPredicate *prediate2=[NSPredicate predicateWithFormat:@"restaurant_location.distance >= %f && restaurant_location.distance <= %f",[lowerLabel.text floatValue],[upperLabel.text floatValue]];
                        
                        compArr = [[NSMutableArray alloc] init];
                        
                        if(veganPredict)
                        {
                            [compArr addObject:veganPredict];
                        }
                        
                        if(vegetarianPredict)
                        {
                            [compArr addObject:vegetarianPredict];
                        }
                        
                        if(localPredict)
                        {
                            [compArr addObject:localPredict];
                        }
                        
                        if(glutenPredict)
                        {
                            [compArr addObject:glutenPredict];
                        }
                        
                        if(organicPredict)
                        {
                            [compArr addObject:organicPredict];
                        }
                        
                        [compArr addObject:prediate2];
                        
                        NSPredicate *compoundPredicate =
                        [NSCompoundPredicate andPredicateWithSubpredicates:@[prediate1,prediate2]];
                        
                        compoundPredicate= [NSCompoundPredicate andPredicateWithSubpredicates:compArr];
                        
                        dishesArr=[dishesCopyArr filteredArrayUsingPredicate:compoundPredicate];
                    }
                    else
                        dishesArr=dishesCopyArr;
                    [self changeForButton:btnTemp];
                    
                }
                else
                {
                    
                    NSPredicate *pred=[NSPredicate predicateWithFormat:@"category.title == %@",selCat];
                    
                    NSArray *array=[[NSArray alloc]init];
                    
                    array=[dishesCopyArr filteredArrayUsingPredicate:pred];
                    
                    if ([array count]==0) {
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppTitle message:@"There are no dishes available for your specification" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
                        [alert show];
                    }
                    else{
                        if([dietryStr length]){
                            dishesArr=[dishesArr filteredArrayUsingPredicate:pred];
                        }else{
                            dishesArr=[dishesCopyArr filteredArrayUsingPredicate:pred];
                        }
                        [self changeForButton:btnTemp];
                        NSPredicate *pred1=[NSPredicate predicateWithFormat:@"ANY future_available_dates.avail_by_date == %@",selectedDate];
                        
                    }
                    
                }
                withRatingCount=0;
                withoutRatingCount=0;
                
                [dishes_Tbl reloadData];
                
                [dishes_Tbl setFrame:CGRectMake(0,250, 320, (Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
                [self.scrollView setContentSize:CGSizeMake(320,(Cell_height*withRatingCount+390*withoutRatingCount)+ 289)];
            }
                [self.duplicateDatesArray removeAllObjects];
                temparray=[dishesArr valueForKey:@"future_available_dates"];
                
                [self.availableDatesArray removeAllObjects];
                [self.availableDatesArray addObjectsFromArray:[dishesArr valueForKey:@"order_by_date"]];
                
                [self.duplicateDatesArray addObjectsFromArray:temparray];
                [self filteruniqueAvailabledate];
                break;
                
            case 33:
            {
                dietryStr=str;
                array=[[NSMutableArray alloc]init];
                [array addObject:str];
                if ([array count])
                {
                    
                    //  NSPredicate *pred2=[NSPredicate predicateWithFormat:@"restaurant_location.distance >= %f && restaurant_location.distance <= %f",[lowerLabel.text floatValue],[upperLabel.text floatValue]];
                    NSPredicate * predict =
                    [NSPredicate predicateWithFormat:@"dietary contains[c] %@",dietryStr];
                    compArr = [[NSMutableArray alloc] init];
                    [compArr addObject:predict];
                    NSArray *array=[[NSArray alloc]init];
                    
                    array=[dishesCopyArr filteredArrayUsingPredicate:predict];
                    
                    arr=nil;
                    if ([array count]==0) {
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppTitle message:@"There are no dishes available for your specification" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
                        [alert show];
                    }
                    else{
                        [self changeForButton:btnTemp];
                        
                        NSPredicate *compoundPredicate= [NSCompoundPredicate andPredicateWithSubpredicates:compArr];
                        dishesArr=[dishesCopyArr filteredArrayUsingPredicate:compoundPredicate];
                        
                        [dishes_Tbl reloadData];
                        [dishes_Tbl setFrame:CGRectMake(0,250, 320, Cell_height*[dishesArr count]+ 289)];
                        [self.scrollView setContentSize:CGSizeMake(320,Cell_height*[dishesArr count]+ 289)];
                    }
                    
                }
                else
                {
                    dishesArr=[dishesCopyArr copy];
                    dietryStr=@"";
                    [dishes_Tbl setFrame:CGRectMake(0,250, 320, Cell_height*[dishesArr count]+ 289)];
                    [self.scrollView setContentSize:CGSizeMake(320,Cell_height*[dishesArr count]+ 289)];
                }
                array=nil;
                dietryStr=nil;
                [dishes_Tbl reloadData];
                [dishes_Tbl setFrame:CGRectMake(0,250, 320, Cell_height*[dishesArr count]+ 289)];
                [self.scrollView setContentSize:CGSizeMake(320,Cell_height*[dishesArr count]+ 289)];
            }
                [self.duplicateDatesArray removeAllObjects];
                
                temparray=[dishesArr valueForKey:@"future_available_dates"];
                
                [self.availableDatesArray removeAllObjects];
                [self.availableDatesArray addObjectsFromArray:[dishesArr valueForKey:@"order_by_date"]];
                
                [self.duplicateDatesArray addObjectsFromArray:temparray];
                [self filteruniqueAvailabledate];
                
                break;
            case 44:
            {
                parseInt=2;
                [self getDishes];
            }
                break;
                
            default:
                break;
        }

        [self performSelector:@selector(hudWasHidden:) withObject:nil afterDelay:4];
    });
   
}


- (IBAction)resetOfferings:(id)sender {
    withRatingCount=0;
    withoutRatingCount=0;
    
    dishesArr=[dishesCopyArr copy];
    [dishes_Tbl reloadData];
    
    [dishes_Tbl setFrame:CGRectMake(0,250, 320, (Cell_height*withRatingCount+390*withoutRatingCount))];
    [self.scrollView setContentSize:CGSizeMake(320,(Cell_height*withRatingCount+390*withoutRatingCount)+289)];

    [self setImages];
    
}

-(void)setImages{
    [self.btnDatenight setBackgroundImage:[UIImage imageNamed:@"offering-btn-1.png"] forState:UIControlStateNormal];
    [self.btnFoodCases setBackgroundImage:[UIImage imageNamed:@"offering-btn-4.png"] forState:UIControlStateNormal];
    [self.btnPopUp setBackgroundImage:[UIImage imageNamed:@"offering-btn-3.png"] forState:UIControlStateNormal];
    [self.btnCommunal setBackgroundImage:[UIImage imageNamed:@"offering-btn-2.png"] forState:UIControlStateNormal];
}

-(void)resetImagesDel{
    [self.btnDelivery setBackgroundImage:[UIImage imageNamed:@"delivery.png"] forState:UIControlStateNormal];
    [self.btnPickup setBackgroundImage:[UIImage imageNamed:@"pickup.png"] forState:UIControlStateNormal];
    [self.btnDinein setBackgroundImage:[UIImage imageNamed:@"dine.png"] forState:UIControlStateNormal];
    [self.btnAll setBackgroundImage:[UIImage imageNamed:@"all.png"] forState:UIControlStateNormal];
    
}
- (IBAction)deliveryOptions:(id)sender {
    
    NSPredicate * predict1=[[NSPredicate alloc]init] ;
    NSArray *array=[[NSArray alloc]init];
    
    [self setImages];
    if ([sender tag]==25 ) {
        predict1=[NSPredicate predicateWithFormat:@"is_delivery == %@",@"1"];
        
    }
    else if ([sender tag]==26){
       predict1=[NSPredicate predicateWithFormat:@"is_pickup == %@",@"1"];

    }
    else if ([sender tag]==27){
      predict1=[NSPredicate predicateWithFormat:@"is_dinein == %@",@"1"];

    }
    else{
        [self.btnDelivery setBackgroundImage:[UIImage imageNamed:@"delivery.png"] forState:UIControlStateNormal];
        [self.btnPickup setBackgroundImage:[UIImage imageNamed:@"pickup.png"] forState:UIControlStateNormal];
        [self.btnDinein setBackgroundImage:[UIImage imageNamed:@"dine.png"] forState:UIControlStateNormal];
        [self.btnAll setBackgroundImage:[UIImage imageNamed:@"all_hover.png"] forState:UIControlStateNormal];
        
        [self resetOfferings:self];
        return;
    }
    
    array=[dishesCopyArr filteredArrayUsingPredicate:predict1];
    
    if ([array count]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppTitle message:@"There are no dishes available for your specification" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
    }
    else{
        dishesArr=[dishesCopyArr filteredArrayUsingPredicate:predict1];

        if ([sender tag]==25 ) {
            [self.btnDelivery setBackgroundImage:[UIImage imageNamed:@"delivery_hover.png"] forState:UIControlStateNormal];
            [self.btnPickup setBackgroundImage:[UIImage imageNamed:@"pickup.png"] forState:UIControlStateNormal];
            [self.btnDinein setBackgroundImage:[UIImage imageNamed:@"dine.png"] forState:UIControlStateNormal];
            [self.btnAll setBackgroundImage:[UIImage imageNamed:@"all.png"] forState:UIControlStateNormal];
            
        }
        else if ([sender tag]==26){
            [self.btnDelivery setBackgroundImage:[UIImage imageNamed:@"delivery.png"] forState:UIControlStateNormal];
            [self.btnPickup setBackgroundImage:[UIImage imageNamed:@"pickup_hover.png"] forState:UIControlStateNormal];
            [self.btnDinein setBackgroundImage:[UIImage imageNamed:@"dine.png"] forState:UIControlStateNormal];
            [self.btnAll setBackgroundImage:[UIImage imageNamed:@"all.png"] forState:UIControlStateNormal];
            
        }
        else if ([sender tag]==27){
            [self.btnDelivery setBackgroundImage:[UIImage imageNamed:@"delivery.png"] forState:UIControlStateNormal];
            [self.btnPickup setBackgroundImage:[UIImage imageNamed:@"pickup.png"] forState:UIControlStateNormal];
            [self.btnDinein setBackgroundImage:[UIImage imageNamed:@"dine_hover.png"] forState:UIControlStateNormal];
            [self.btnAll setBackgroundImage:[UIImage imageNamed:@"all.png"] forState:UIControlStateNormal];
            
        }
        else{
            [self.btnDelivery setBackgroundImage:[UIImage imageNamed:@"delivery.png"] forState:UIControlStateNormal];
            [self.btnPickup setBackgroundImage:[UIImage imageNamed:@"pickup.png"] forState:UIControlStateNormal];
            [self.btnDinein setBackgroundImage:[UIImage imageNamed:@"dine.png"] forState:UIControlStateNormal];
            [self.btnAll setBackgroundImage:[UIImage imageNamed:@"all_hover.png"] forState:UIControlStateNormal];
            
        }

        [dishes_Tbl reloadData];
        [dishes_Tbl setFrame:CGRectMake(0,250, 320, Cell_height*[dishesArr count]+ 289)];
        [self.scrollView setContentSize:CGSizeMake(320,Cell_height*[dishesArr count]+ 289)];

    }
    
    //Filtering future dates based on Order type
    [self.duplicateDatesArray removeAllObjects];
    [self.availableDatesArray removeAllObjects];
    NSArray *temparray=[dishesArr valueForKey:@"future_available_dates"];
    [self.duplicateDatesArray addObjectsFromArray:temparray];
    [self.availableDatesArray addObjectsFromArray:[dishesArr valueForKey:@"order_by_date"]];
    [self filteruniqueAvailabledate];
}

- (IBAction)fbShareClicked:(id)sender
{
    _shareViewIsHidden = NO;
    [self HideShareView];
    

    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [fbSheetOBJ setInitialText: _currentDishTitle];
        [fbSheetOBJ addImage: _currentDishImage];
        [fbSheetOBJ addURL: [NSURL URLWithString:_currentTweeturl]];
        
        [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
        
    }
    else
    {
        [GlobalMethods showAlertwithString:@"You're not logged in to Facebook. Go to Device Settings > Facebook > Sign In"];
    }
}

- (IBAction)twitterShareClicked:(id)sender
{
    //TEST
    // [self TweetTweet : @"Tweet Tweet, WTF!"];
    
    _shareViewIsHidden = NO;
    [self HideShareView];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheetOBJ setInitialText: _currentDishTweet];
        [tweetSheetOBJ addImage: _currentDishImage];
        [tweetSheetOBJ addURL:[NSURL URLWithString:_currentTweeturl]];
        
        [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
    }
    else
    {
        [GlobalMethods showAlertwithString:
         @"You're not logged in to Twitter. Go to Device Settings > Twitter > Sign In"];
    }
}


- (IBAction)emailShareClicked:(id)sender
{
    _shareViewIsHidden = NO;
    [self HideShareView];
    
    MFMailComposeViewController *comp=[[MFMailComposeViewController alloc]init];
    [comp setMailComposeDelegate:self];
    if([MFMailComposeViewController canSendMail])
    {
        //[comp setToRecipients:nil];
        [comp setSubject:AppTitle];
        
        
        [comp setMessageBody:_currentDishTitle isHTML:NO];
        
        
        //        [currentDishTitle appendString: @"Hey there! Check out this dish - "];
        //        [currentDishTitle appendString: Dish_Header_Entree.text];
        //        [currentDishTitle appendString: @", available at "];
        //        [currentDishTitle appendString: [restaur valueForKey:@"restaurant_title"]];
        
        NSMutableString *htmlMsg = [NSMutableString string];
        [htmlMsg appendString:@"<html><body><p>"];
        [htmlMsg appendString: @"Hey there! Check out this dish - "];
        [htmlMsg appendString: currentDishName];
        [htmlMsg appendString: @", available at "];
        [htmlMsg appendString: _currentDishRestaurant];
        [htmlMsg appendString: @"</p> <p>"];
        [htmlMsg appendString: @"About the dish: "];
        [htmlMsg appendString: _currentDishDescription];
        [htmlMsg appendString:[NSString stringWithFormat:@"\n%@",_currentTweeturl]];
        [htmlMsg appendString:@" </p></body></html>"];
        
        NSData *jpegData = UIImageJPEGRepresentation(_currentDishImage, 1);
        
        NSString *fileName = @"EnjoyFreshDish";
        fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
        [comp addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];
        
        [comp setSubject:@"Download the awesome EnjoyFresh app from AppStore!"];
        [comp setMessageBody:htmlMsg isHTML:YES];
        
        [comp setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:comp animated:YES completion:nil];
    }
    else{
        [GlobalMethods showAlertwithString:@"Cannot send mail now"];
    }
}



- (IBAction)msgShareClicked:(id)sender
{
    _shareViewIsHidden = NO;
    [self HideShareView];
    
    if(![MFMessageComposeViewController canSendText])
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
   // NSString *url=_currentTweeturl;
    [currentDishName1 appendString:[NSString stringWithFormat:@" %@",_currentTweeturl]];
    [messageController setBody:currentDishName1];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
    
}
BOOL refineflag=NO;
BOOL allflag=NO;
BOOL clearClick=NO;

- (IBAction)showRefineFilters:(id)sender {
    [self.view endEditing:YES];

    [self showHUD];
    selectedDate=nil;
    withRatingCount=0;
    withoutRatingCount=0;
    if (!refineflag) {
        refineflag=YES;
        dispatch_async( dispatch_get_main_queue(), ^{

            
            [self setImages];

            //[self.scrollView setContentSize:CGSizeMake(320,dishes_Tbl.frame.size.height+190)];
            dishesArr=dishesCopyArr;
            [self.duplicateDatesArray removeAllObjects];
            [self.availableDatesArray removeAllObjects];
            NSArray *temparray=[dishesArr valueForKey:@"future_available_dates"];
            [self.duplicateDatesArray addObjectsFromArray:temparray];
            [self.availableDatesArray addObjectsFromArray:[dishesArr valueForKey:@"order_by_date"]];
            [self filteruniqueAvailabledate];
            [dishes_Tbl reloadData];
            [self cusineArray];
            [self SetUnderScore:self.btnCategory];
            self.btnClearAll.hidden=NO;
            self.btnSearchNear.hidden=YES;
            
            [UIView animateWithDuration:0.0f
                                  delay:0.0f
                                options:UIViewAnimationOptionTransitionCurlDown
                             animations:^{
                                 [dishes_Tbl setFrame:CGRectMake(0,250, 320,(Cell_height*withRatingCount+390*withoutRatingCount))];
                                 [self.scrollView setContentSize:CGSizeMake(320,Cell_height*withRatingCount+390*withoutRatingCount+220)];
                                 [self performSelector:@selector(hudWasHidden:) withObject:nil afterDelay:4];

                             }
                             completion:nil];
            
            [self.btnDistance setAlpha:1.0f];
            [self.btnOffering setAlpha:1.0f];
            [self.btnDietary setAlpha:1.0f];
            [self.btnDate setAlpha:1.0f];
            [self.btnCategory setAlpha:0.6f];
            
            self.btnDistance.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnOffering.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnDietary.titleLabel.font=[UIFont fontWithName:Medium size:11];
            _btnDate.titleLabel.font=[UIFont fontWithName:Medium size:11];
            
            [self.btnDistance setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnOffering setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnDietary setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.btnCategory.titleLabel.font=[UIFont fontWithName:Bold size:11];
            [self.btnCategory setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            switchTag=11;

         });
        
    }
    else{
        
        dispatch_async( dispatch_get_main_queue(), ^{

            [self setImages];

            [dishes_Tbl reloadData];
            
            refineflag=NO;
            allflag=NO;
            [dishes_Tbl setFrame:CGRectMake(0,89, 320, (Cell_height*withRatingCount+390*withoutRatingCount))];
            [self.scrollView setContentSize:CGSizeMake(320,(Cell_height*withRatingCount+390*withoutRatingCount)+70)];
            self.btnClearAll.hidden=YES;
            self.btnSearchNear.hidden=NO;
            
            [self performSelector:@selector(hudWasHidden:) withObject:nil afterDelay:4];

        });
        

    }
    
    
}
-(void)setInitail{
    
}
- (IBAction)clearRefineFilters:(id)sender {
    [self.view endEditing:YES];
    selectedDate=nil;

    withRatingCount=0;
    withoutRatingCount=0;
    refineflag=NO;
    allflag=NO;
    clearClick=YES;
    [self showHUD];
    dispatch_async( dispatch_get_main_queue(), ^{

        
        dishesArr=dishesCopyArr;
        [dishes_Tbl reloadData];
        self.btnSearchNear.hidden=NO;
        //[self cusineArray];
        [self SetUnderScore:self.btnCategory];
        self.btnClearAll.hidden=YES;
        [ UIView animateWithDuration:0.3f
                               delay:0.0f
                             options:UIViewAnimationOptionTransitionCurlUp
                          animations:^{
                              [dishes_Tbl setFrame:CGRectMake(0.0f, 89.0f, 320.0f,Cell_height*withRatingCount+390*withoutRatingCount)];
                              [self.scrollView setContentSize:CGSizeMake(320,Cell_height*withRatingCount+390*withoutRatingCount+90)];
                              [self performSelector:@selector(hudWasHidden:) withObject:nil afterDelay:4];

                          }
                          completion:nil];
    });
    
}

- (IBAction)offeringTypeSelectedAction:(id)sender {
    [self resetImagesDel];

    NSString *offStr;
    if ([sender tag]==55) {
       offStr=@"Date Night";}
    else if ([sender tag]==66) {
        offStr=@"Popups/Food Trucks";}
    else if ([sender tag]==77) {
        offStr=@"Communal Tables";
        }
    else {
        offStr=@"Food & Cocktail Classes";
        }
    NSPredicate * predict =
    [NSPredicate predicateWithFormat:@"offering_types contains[c] %@",offStr];
    NSArray *array=[[NSArray alloc]init];
    
    array=[dishesCopyArr filteredArrayUsingPredicate:predict];
    
    if ([array count]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppTitle message:@"There are no dishes available for your specification" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
    }
    else{
        dishesArr=[dishesCopyArr filteredArrayUsingPredicate:predict];
        if ([sender tag]==55) {
            [self.btnDatenight setBackgroundImage:[UIImage imageNamed:@"active_DateNight.png"] forState:UIControlStateNormal];
            [self.btnFoodCases setBackgroundImage:[UIImage imageNamed:@"offering-btn-4.png"] forState:UIControlStateNormal];
            [self.btnPopUp setBackgroundImage:[UIImage imageNamed:@"offering-btn-3.png"] forState:UIControlStateNormal];
            [self.btnCommunal setBackgroundImage:[UIImage imageNamed:@"offering-btn-2.png"] forState:UIControlStateNormal];
            
        }
        else if ([sender tag]==66) {
            [self.btnDatenight setBackgroundImage:[UIImage imageNamed:@"offering-btn-1.png"] forState:UIControlStateNormal];
            [self.btnFoodCases setBackgroundImage:[UIImage imageNamed:@"offering-btn-4.png"] forState:UIControlStateNormal];
            [self.btnPopUp setBackgroundImage:[UIImage imageNamed:@"offering-btn-3_Popups.png"] forState:UIControlStateNormal];
            [self.btnCommunal setBackgroundImage:[UIImage imageNamed:@"offering-btn-2.png"] forState:UIControlStateNormal];
        }
        else if ([sender tag]==77) {
            [self.btnDatenight setBackgroundImage:[UIImage imageNamed:@"offering-btn-1.png"] forState:UIControlStateNormal];
            [self.btnFoodCases setBackgroundImage:[UIImage imageNamed:@"offering-btn-4.png"] forState:UIControlStateNormal];
            [self.btnPopUp setBackgroundImage:[UIImage imageNamed:@"offering-btn-3.png"] forState:UIControlStateNormal];
            [self.btnCommunal setBackgroundImage:[UIImage imageNamed:@"offering-btn-2_CommunalTables.png"] forState:UIControlStateNormal];
        }
        else {
            [self.btnDatenight setBackgroundImage:[UIImage imageNamed:@"offering-btn-1.png"] forState:UIControlStateNormal];
            [self.btnFoodCases setBackgroundImage:[UIImage imageNamed:@"offering-btn-4_FoodClasses.png"] forState:UIControlStateNormal];
            [self.btnPopUp setBackgroundImage:[UIImage imageNamed:@"offering-btn-3.png"] forState:UIControlStateNormal];
            [self.btnCommunal setBackgroundImage:[UIImage imageNamed:@"offering-btn-2.png"] forState:UIControlStateNormal];
        }
        [dishes_Tbl reloadData];
        [dishes_Tbl setFrame:CGRectMake(0,250, 320, Cell_height*[dishesArr count]+ 289)];
        [self.scrollView setContentSize:CGSizeMake(320,Cell_height*[dishesArr count]+ 289)];
        
    }
   
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) HideShareView
{
    //shareButton.alpha = 1.0f;
    _shareViewIsHidden = _shareViewIsHidden;

    [UIView animateWithDuration:.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
     {
         self.shareView.frame
         = CGRectMake(0, [UIScreen mainScreen].bounds.size.height,
                      self.shareView.frame.size.width, self.shareView.frame.size.height);
     }
                     completion:^(BOOL finished)
     {
         [self.shareView removeFromSuperview];
         
     }];
}

- (IBAction)menuBtnClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;

    if(drp==nil)
    {
        
        [btn setImage:[UIImage imageNamed:@"close_icon_03.png"] forState:UIControlStateNormal];
        drp = [[DropDown alloc] initWithStyle:UITableViewStylePlain];
        imgView=[[UIView alloc ]initWithFrame:CGRectMake(0, 64,320, self.view.frame.size.height)];

        imgView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
        [imgView addSubview:drp.view];
        [drp.view setFrame:CGRectMake(100, 0, 220, 0)];
        drp.delegate = self;
        [self.view addSubview:imgView];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [drp.view setFrame:[drp dropDownViewFrame]];
        
        [UIView commitAnimations];
    }
    else
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             [drp.view setFrame:CGRectMake(100, 0, 220, 0)];
                         }
                         completion:^(BOOL finished){
                             [imgView removeFromSuperview];
                             [drp.view removeFromSuperview];
                             drp=nil;
                             [btn setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
                             
                         }
         ];
    }

}



- (void) ShowOrderDetails
{
    
    if ([appDel.accessToken isEqualToString:@""])
    {
        appDel.orderClickedBeforeLogin = @"N";
        //        [[[UIAlertView alloc]initWithTitle:AppTitle message:@"Login to Order your dish" delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES", nil]show]        ;
        return;
    }
    
    addTOBag=nil;
    
    addTOBag=[[AddedToBag alloc]init];
   // addTOBag.Item_details=[dishesArr objectAtIndex: [appDel.currentTagID intValue] ];
    
    CGRect rec=addTOBag.view.frame;
    rec.origin.y=-600;
    addTOBag.view.frame=rec;
    [self.view addSubview:addTOBag.view];
    rec.origin.y=0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    addTOBag.view.frame=rec;
    [UIView commitAnimations];
    
    appDel.orderClickedBeforeLogin = @"N";
    appDel.currentTagID = @"";
}
-(void)showDates:(id)sender{
    
    int tagVal=(int)[sender tag]-222;
    appDel.currentTagID = [NSString stringWithFormat:@"%li", (long) tagVal];

    NSDictionary *dic=[dishesArr objectAtIndex:tagVal];
   // NSArray *date=[[dic valueForKey:@"avail_by_date"] componentsSeparatedByString:@"-"];
    NSIndexPath *Indexp = [NSIndexPath indexPathForRow:tagVal inSection:0];

    cellToChange=[dishes_Tbl cellForRowAtIndexPath:Indexp];
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date1=[format dateFromString:[dic valueForKey:@"avail_by_date"]];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:date1];
    
    NSDateFormatter *weekDay = [[NSDateFormatter alloc] init];
    [weekDay setDateFormat:@"EEE"];
    
    NSDateFormatter *calMonth = [[NSDateFormatter alloc] init];
    [calMonth setDateFormat:@"MMM"];
    NSMutableArray *ftdates=[[NSMutableArray alloc]init];
    
   arrayDates=[dic valueForKey:@"future_available_dates"];
    for (NSDictionary *dic in arrayDates) {
        NSDate *date=[format dateFromString:[dic valueForKey:@"avail_by_date"]];
        NSArray*date1=[[dic valueForKey:@"avail_by_date"] componentsSeparatedByString:@"-"];
        
        NSString *futureDateString;
        futureDateString=[NSString stringWithFormat:@"%@ %@,%@ @ %.2ld:%.2ld %@ - %.2ld:%.2ld %@",[weekDay stringFromDate:date],[calMonth stringFromDate:date],[date1 objectAtIndex:2],(long)[[dic valueForKey:@"avail_by_hr"] integerValue],(long)[[dic valueForKey:@"avail_by_min"] integerValue],[dic valueForKey:@"avail_by_ampm"],(long)[[dic valueForKey:@"avail_till_hr"] integerValue],(long)[[dic valueForKey:@"avail_till_min"] integerValue],[dic valueForKey:@"avail_till_ampm"]];
        [ftdates addObject:futureDateString];
    }
    uniqueDatesArray=ftdates;
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    UIButton *barDoneBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [barDoneBut setTitle:@"Done" forState:UIControlStateNormal];
    barDoneBut.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
    barDoneBut.frame=CGRectMake(245, 7, 70, 30);
    [barDoneBut addTarget:self action:@selector(pickerDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [barDoneBut setTag:[sender tag]];
    [pickerToolbar addSubview:barDoneBut];
    
    UIButton *barCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    barCancel.frame=CGRectMake(5, 7, 70, 30);
    barCancel.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
    [barCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [barCancel addTarget:self action:@selector(pickercancel:) forControlEvents:UIControlEventTouchUpInside];
    [barCancel setTag:[sender tag]];
    [pickerToolbar addSubview:barCancel];
    
    layerView = [[UIView alloc] initWithFrame:CGRectMake(-7, 0, 320, 300)];
    layerView.backgroundColor = [UIColor whiteColor];
    
    action=[[UIActionSheet alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    [action addSubview:pickerToolbar];
    [layerView addSubview:pickerToolbar];
    location_view.frame=CGRectMake(0, 44, 320, 300);
    pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    pickerview.tag=11;
    pickerview.dataSource = self;
    pickerview.delegate = self;
    
    pickerview.showsSelectionIndicator = YES;
    [action addSubview:pickerview];
    [layerView addSubview:pickerview];
    [pickerview selectRow:pickerSelIndex inComponent:0 animated:YES];
    
    searchActionSheet=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n" message:@"\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    searchActionSheet.view.backgroundColor = [UIColor blueColor];
    [searchActionSheet.view addSubview:layerView];
    
    [self presentViewController:searchActionSheet animated:YES completion:nil];
   
}
-(void)addToOrderBtnClicked:(id)sender
{
    senderFlag=NO;
    
    int tagVal=(int)[sender tag]-222;
   
    NSDictionary *dic=[dishesArr objectAtIndex:tagVal];
    
    appDel.currentDishId=[dic valueForKey:@"dish_id"];
    
    UIButton *btn=(UIButton*)[self.view viewWithTag:tagVal];
    
    
    appDel.currentTagID = [NSString stringWithFormat:@"%li", (long) tagVal];
    
    btn.enabled = false;
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        // code to execute
        dispatch_async(dispatch_get_main_queue(),^(void){
            [self performSegueWithIdentifier:@"DishDetailSegue" sender:sender];
        });
    }
                     completion:^(BOOL finished){
                         // code to execute
                         btn.enabled = true; //This is correct.
                     }];
    
    
}

/*-(void)favouriteBtnClicked:(id)sender
{
    if ([appDel.accessToken isEqualToString:@""])
    {
        [[[UIAlertView alloc]initWithTitle:AppTitle message:@"Login to Favourite" delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES", nil]show]        ;
        return;
    }
    UIButton *bnt=(UIButton*)SetUnderScore
    if ([bnt.backgroundColor isEqual:unfavcolor]) {
        bnt.backgroundColor=favcolor;
    }else{
        bnt.backgroundColor=unfavcolor;
        
    }
    tagint=[sender tag];
    
    NSString *dishId=[[dishesArr objectAtIndex:[sender tag]-111]valueForKey:@"dish_id"];
    NSString *restaurantID =[[
                              [dishesArr objectAtIndex:[sender tag]-111]
                              valueForKey:@"restaurant_details"]
                             valueForKey:@"restaurant_id"];
    
    appDel.CurrentRestaurantID = restaurantID;
    
    NSString *restaurantCity =[[
                                [dishesArr objectAtIndex:[sender tag]-111]
                                valueForKey:@"restaurant_details"]
                               valueForKey:@"restaurant_city"];
    
    appDel.CurrentRestaurantCity = restaurantCity;
    
    NSString *restaurantOwner =[[
                                 [dishesArr objectAtIndex:[sender tag]-111]
                                 valueForKey:@"restaurant_details"]
                                valueForKey:@"restaurant_title"];
    
    appDel.CurrentRestaurantOwner = restaurantOwner;
    
    
    UserFavorites = [[FavoritesClass alloc] init];
    UserFavorites.restaurant_id = restaurantID;
    UserFavorites.restaurant_city = restaurantCity;
    UserFavorites.restaurant_title = restaurantOwner;
    
    NSMutableDictionary *FavarDict =[[[dishesArr objectAtIndex:[sender tag]-111]
                                      valueForKey:@"restaurant_details"] mutableCopy];
    NSMutableArray *ImagesStringArray = [FavarDict
                                         valueForKey:@"images"];
    
    
    if(ImagesStringArray.count > 0)
    {
        NSMutableDictionary *ThumbNailImage = ImagesStringArray[0];
        UserFavorites.restaurant_image_thumbnail = [ThumbNailImage objectForKey:@"path_th"];
    }
    
    appDel.objDBClass.FavoritesClassObj = UserFavorites;
    
    parseInt=4;
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken, @"accessToken",restaurantID,@"dishId",nil];
    
    [parser parseAndGetDataForPostMethod:params withUlr:@"markFavoriteDish"];
}*/
-(void)headersBtnClicked:(id)sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
        pickerToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerToolbar sizeToFit];
        
        UIButton *barDoneBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [barDoneBut setTitle:@"Done" forState:UIControlStateNormal];
        barDoneBut.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
        barDoneBut.frame=CGRectMake(245, 7, 70, 30);
        [barDoneBut addTarget:self action:@selector(pickerDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
        [barDoneBut setTag:[sender tag]];
        [pickerToolbar addSubview:barDoneBut];
        
        UIButton *barCancel=[UIButton buttonWithType:UIButtonTypeCustom];
        barCancel.frame=CGRectMake(5, 7, 70, 30);
        barCancel.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
        [barCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [barCancel addTarget:self action:@selector(pickercancel:) forControlEvents:UIControlEventTouchUpInside];
        [barCancel setTag:[sender tag]];
        [pickerToolbar addSubview:barCancel];
        
        UIButton *currentButton = (UIButton *) sender;
        
        [self SetDefaultOptionColors];
        
        switch ([sender tag]) {
            case 10:
            {
                CurrentButtonTag = 10;
                catStr=@"CUISINE";
                ditStr=@"DIETARY";
                locStr=@"DELIVERY";
                dateStr=@"DATE";
                
                
                [btnUnderScore setHidden: NO];
                [catBtn setTitleColor: unfavcolor forState: UIControlStateNormal];
                
                
                action=[[UIActionSheet alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
                [action addSubview:pickerToolbar];
                pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
                pickerview.dataSource = self;
                pickerview.delegate = self;
                [dishes_Tbl reloadData];
                
                pickerview.showsSelectionIndicator = YES;
                [action addSubview:pickerview];
                [pickerview selectRow:pickerSelIndex inComponent:0 animated:YES];
                
            }
                break;
            case 20:
            {
                CurrentButtonTag = 20;
                catStr=@"CUISINE";
                ditStr=@"DIETARY";
                locStr=@"DELIVERY";
                dateStr=@"DATE";
                
                NSLog(@"Button Text %@", currentButton.titleLabel.text);
                
                
                
                [dishes_Tbl reloadData];
                action=[[UIActionSheet alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
                [action addSubview:pickerToolbar];
                
                dietaryVw.frame=CGRectMake(0, 44, 320, 300);
                [action addSubview:dietaryVw];
                
                [btnDietaryUnderScore setHidden: NO];
                UIButton *dietBtn = (UIButton *) [viewheader viewWithTag: 20];
                
                [dietBtn setHidden: YES];
                [dietBtn setTitle:@"test" forState: UIControlStateNormal];
                NSLog(@"Button Text %@", dietBtn.titleLabel.text);
            }
                break;
            case 30:
            {
                CurrentButtonTag = 30;
                catStr=@"CUISINE";
                ditStr=@"DIETARY";
                locStr=@"DELIVERY";
                dateStr=@"DATE";
                
                [btnLocUnderScore setHidden: NO];
                [locBtn setTitleColor: unfavcolor forState: UIControlStateNormal];
                
                [dishes_Tbl reloadData];
                [self configureLabelSlider ];
                [self updateSliderLabels];
                
                
                action=[[UIActionSheet alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
                [action addSubview:pickerToolbar];
                location_view.frame=CGRectMake(0, 44, 320, 300);
                [action addSubview:location_view];
                
            }
                break;
            case 50:
            {
                CurrentButtonTag = 50;
                catStr=@"CUISINE";
                ditStr=@"DIETARY";
                locStr=@"DELIVERY";
                dateStr=@"DATE";
                
                [btnDateUnderScore setHidden: NO];
                [dateBtn setTitleColor: unfavcolor forState: UIControlStateNormal];
                
                [dishes_Tbl reloadData];
                //            [self configureLabelSlider ];
                //            [self updateSliderLabels];
                NSLog(@"dates array:%@",datesArray);
                
                action=[[UIActionSheet alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
                [action addSubview:pickerToolbar];
                [layerView addSubview:pickerToolbar];
                date_view.frame=CGRectMake(0, 44, 320, 300);
                [action addSubview:date_view];
                [layerView addSubview:date_view];
                
            }
                break;
            default:
                break;
        }
        
        [action showInView:self.view];
        [action setBounds:CGRectMake(0, 0, 320,568)];
        
        return;
    }
    else{
        
        if ([sender tag] == 50) {
            
            CurrentButtonTag = 50;
            dishes_Tbl.userInteractionEnabled=NO;
            UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
            pickerToolbar.barStyle = UIBarStyleBlackOpaque;
            [pickerToolbar sizeToFit];
            
            UIButton *barDoneBut=[UIButton buttonWithType:UIButtonTypeCustom];
            [barDoneBut setTitle:@"Done" forState:UIControlStateNormal];
            barDoneBut.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
            barDoneBut.frame=CGRectMake(245, 7, 70, 30);
            [barDoneBut addTarget:self action:@selector(pickerDoneClicked1:) forControlEvents:UIControlEventTouchUpInside];
            [barDoneBut setTag:[sender tag]];
            [pickerToolbar addSubview:barDoneBut];
            
            UIButton *barCancel=[UIButton buttonWithType:UIButtonTypeCustom];
            barCancel.frame=CGRectMake(5, 7, 70, 30);
            barCancel.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
            [barCancel setTitle:@"Cancel" forState:UIControlStateNormal];
            [barCancel addTarget:self action:@selector(pickercancel1:) forControlEvents:UIControlEventTouchUpInside];
            [barCancel setTag:[sender tag]];
            [pickerToolbar addSubview:barCancel];
            
            
            CurrentButtonTag = 50;
            
            catStr=@"CUISINE";
            ditStr=@"DIETARY";
            locStr=@"DELIVERY";
            dateStr=@"DATE";
            [self.calendar removeFromSuperview];
            CKCalendarView *calendar=nil;
            [btnDateUnderScore setHidden: NO];
            [dateBtn setTitleColor: unfavcolor forState: UIControlStateNormal];
            
            layerView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-380, 320,340)];
            layerView.backgroundColor = [UIColor whiteColor];
            calendar = [[CKCalendarView alloc] initWithStartDay:startSunday];
            self.calendar = calendar;
            calendar.delegate = self;
            
            
            calendar.onlyShowCurrentMonth = NO;
            calendar.adaptHeightToNumberOfWeeksInMonth = YES;
            self.calendar.backgroundColor=[UIColor colorWithRed:(139/255.0) green:(186/255.0) blue:(106/255.0) alpha:1];
            calendar.frame = CGRectMake(0,0, 320, 300);
            
            date_view.frame=CGRectMake(0,44, 320, 340);
            [date_view addSubview:calendar];
            [layerView addSubview:date_view];
            [layerView addSubview:pickerToolbar];
            CGRect rec=layerView.frame;
            rec.origin.y=600;
            layerView.frame=rec;
            [self.view addSubview:layerView];
            rec.origin.y=self.view.frame.size.height-380;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            layerView.frame=rec;
            [UIView commitAnimations];
            
            [self.view bringSubviewToFront:layerView];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
            
        }
        
        else{
            UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
            pickerToolbar.barStyle = UIBarStyleBlackOpaque;
            [pickerToolbar sizeToFit];
            
            UIButton *barDoneBut=[UIButton buttonWithType:UIButtonTypeCustom];
            [barDoneBut setTitle:@"Done" forState:UIControlStateNormal];
            barDoneBut.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
            barDoneBut.frame=CGRectMake(245, 7, 70, 30);
            [barDoneBut addTarget:self action:@selector(pickerDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
            [barDoneBut setTag:[sender tag]];
            [pickerToolbar addSubview:barDoneBut];
            
            UIButton *barCancel=[UIButton buttonWithType:UIButtonTypeCustom];
            barCancel.frame=CGRectMake(5, 7, 70, 30);
            barCancel.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
            [barCancel setTitle:@"Cancel" forState:UIControlStateNormal];
            [barCancel addTarget:self action:@selector(pickercancel:) forControlEvents:UIControlEventTouchUpInside];
            [barCancel setTag:[sender tag]];
            [pickerToolbar addSubview:barCancel];
            
            layerView = [[UIView alloc] initWithFrame:CGRectMake(-7, 0, 320, 300)];
            layerView.backgroundColor = [UIColor whiteColor];
            
            
            
            switch ([sender tag]) {
                case 10:
                {
                    CurrentButtonTag = 10;
                    
                    catStr=@"CUISINE";
                    ditStr=@"DIETARY";
                    locStr=@"DELIVERY";
                    dateStr=@"DATE";
                    
                    [btnUnderScore setHidden: NO];
                    [catBtn setTitleColor: unfavcolor forState: UIControlStateNormal];
                    
                    action=[[UIActionSheet alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
                    [action addSubview:pickerToolbar];
                    [layerView addSubview:pickerToolbar];
                    pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
                    pickerview.dataSource = self;
                    pickerview.delegate = self;
                    [dishes_Tbl reloadData];
                    
                    pickerview.showsSelectionIndicator = YES;
                    [action addSubview:pickerview];
                    [layerView addSubview:pickerview];
                    [pickerview selectRow:pickerSelIndex inComponent:0 animated:YES];
                    
                }
                    break;
                case 20:
                {
                    CurrentButtonTag = 20;
                    
                    catStr=@"CUISINE";
                    ditStr=@"DIETARY";
                    locStr=@"DELIVERY";
                    dateStr=@"DATE";
                    
                    [btnDietaryUnderScore setHidden: NO];
                    [dietaryBtn setTitleColor: unfavcolor forState: UIControlStateNormal];
                    
                    [dishes_Tbl reloadData];
                    action=[[UIActionSheet alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
                    [action addSubview:pickerToolbar];
                    
                    [layerView addSubview:pickerToolbar];
                    
                    dietaryVw.frame=CGRectMake(0, 44, 320, 300);
                    [action addSubview:dietaryVw];
                    
                    [layerView addSubview:dietaryVw];
                }
                    break;
                case 30:
                {
                    CurrentButtonTag = 30;
                    
                    catStr=@"CUISINE";
                    ditStr=@"DIETARY";
                    locStr=@"DELIVERY";
                    dateStr=@"DATE";
                    
                    [btnLocUnderScore setHidden: NO];
                    [locBtn setTitleColor: unfavcolor forState: UIControlStateNormal];
                    
                    [dishes_Tbl reloadData];
                    [self configureLabelSlider ];
                    [self updateSliderLabels];
                    
                    
                    action=[[UIActionSheet alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
                    [action addSubview:pickerToolbar];
                    [layerView addSubview:pickerToolbar];
                    location_view.frame=CGRectMake(0, 44, 320, 300);
                    [action addSubview:location_view];
                    [layerView addSubview:location_view];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
            searchActionSheet=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n" message:@"\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
            searchActionSheet.view.backgroundColor = [UIColor blueColor];
            // [searchActionSheet.view setBounds:CGRectMake(7, 180, self.view.frame.size.width, 470)];
            //[layerView setBounds:searchActionSheet.view.bounds];
            [searchActionSheet.view addSubview:layerView];
            
            [self presentViewController:searchActionSheet animated:YES completion:nil];
        }
        
    }
}


- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}
-(void)performRPPSegue:(id)sender{
    
    int tagVal=[sender tag]-222;
    UIButton *btn=(UIButton*)[self.view viewWithTag:tagVal];

    appDel.currentTagID = [NSString stringWithFormat:@"%li", (long) tagVal];
    btn.enabled = false;
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        // code to execute
        dispatch_async(dispatch_get_main_queue(),^(void){
            [self performSegueWithIdentifier:@"RPPSegue" sender:sender];
        });
    }
                     completion:^(BOOL finished){
                         // code to execute
                         btn.enabled = true; //This is correct.
                     }];

    
}
-(void)filteruniqueAvailabledate{
    
    NSMutableArray *uniquearray=[NSMutableArray new];
    for (NSArray *array1 in self.duplicateDatesArray) {
        if (![array1 isKindOfClass:[NSNull class]]&& array1.count>0) {
            
            [uniquearray addObjectsFromArray:array1];
        }
    }
    NSArray *uniqueStates;
    uniquearray = [uniquearray valueForKeyPath:@"@distinctUnionOfObjects.avail_by_date"];
    //uniquearray=[uniqueStates valueForKey:@"avail_by_date"];
    datesArray=uniquearray;
    
    NSArray *uniqueArray = [[NSSet setWithArray:self.availableDatesArray] allObjects];

    [self.availableDatesArray removeAllObjects];

    [self.availableDatesArray addObjectsFromArray: uniqueArray];
    uniquearray=nil;

}
#pragma mark
#pragma mark - HUD Delegtes
- (void)hudWasHidden:(MBProgressHUD *)huda {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    hud = nil;
    
}
-(void)showHUD{
    
    if (hud==nil)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.delegate = self;
        [self.view addSubview:hud];
        [hud show:YES];
        
    }


    //[self performSelector:@selector(hudWasHidden:) withObject:nil afterDelay:5];

}
-(void)hideSearchBar{
    
    search_bar.hidden=YES;
         search_bar.frame
         = CGRectMake(0, -200,
                      search_bar.frame.size.width, search_bar.frame.size.height);
}
-(void)showSearchBar{
    search_bar.hidden=NO;
    search_bar.frame
         = CGRectMake(0, 65,
                      search_bar.frame.size.width, search_bar.frame.size.height);
    

}
#pragma mark
#pragma mark - TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  //  [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
  //  [self animateTextField: textField up: NO];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField==self.txtfindZip)
    {
        if (textField.text.length >= 5 && range.length == 0)
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
    return YES;
}
#pragma mark -
#pragma mark - PickerView DataSOurces
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag==11) {
        return [uniqueDatesArray count];
    }
    else{
        return [categoryArr count];
    }
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag==11) {
        
        return [uniqueDatesArray objectAtIndex:row];
    }
    else{
        return [[categoryArr objectAtIndex:row]valueForKey:@"title"];
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:Regular size:18]];
        [tView setTextAlignment:NSTextAlignmentCenter];
    }
    
    if (pickerView.tag==11) {
        
        NSString *abc = [uniqueDatesArray objectAtIndex:row];
        tView.text =abc;
        return tView;
    }
    else{
        
        // Fill the label text here
        
        NSString *abc = [[categoryArr objectAtIndex:row]valueForKey:@"title"];
        tView.text = [NSString stringWithFormat:@"%@%@",[[abc substringToIndex:1] uppercaseString],[abc substringFromIndex:1] ];
        return tView;
    }
}
#pragma mark -
#pragma mark - PickerView Delegates
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag==11) {
        
        drpSelectedDate=[[arrayDates objectAtIndex:row] valueForKey:@"avail_by_date"];
        drpSelDate=[uniqueDatesArray objectAtIndex:row];
        datePickerSelIndex=(int)row;
    }
    else {
        selCat=[[categoryArr objectAtIndex:row]valueForKey:@"title"];
        pickerSelIndex=(int)row;
    }
}
#pragma mark -
#pragma mark - ToolBar Buttons
-(void)pickercancel1:(id)sender
{
    CurrentButtonTag = 0;
    [self SetDefaultOptionColors];

    dishes_Tbl.userInteractionEnabled=YES;

   // [dishes_Tbl reloadData];

    [layerView removeFromSuperview];
    
}

-(void)pickerDoneClicked1:(id)sender
{
    
    dishes_Tbl.userInteractionEnabled=YES;

    if (selectedDate) {
//        NSString *expression=[NSString stringWithFormat:@"SELF contains '%@'",selectedDate];
//        NSString *expression1=[NSString stringWithFormat:@"SELF contains soldout = '%@'",@"0"];
        
        
        NSPredicate *pred1=[NSPredicate predicateWithFormat:@"ANY future_available_dates.avail_by_date == %@",selectedDate];

       // NSPredicate *pred1=[NSPredicate predicateWithFormat:@"avail_by_date == %@",selectedDate];
        NSPredicate *pred2=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"soldout = %@",@"0"]];      //  NSPredicate *compoundPredicate= [NSPredicate predicateWithFormat:expression,expression1];
        
        NSMutableArray *com=[[NSMutableArray alloc]initWithObjects:pred1,pred2,nil];
        NSCompoundPredicate *compoundPredicate=[NSCompoundPredicate andPredicateWithSubpredicates:com];
        dishesArr=[dishesCopyArr filteredArrayUsingPredicate:compoundPredicate];

    }
    [dishes_Tbl reloadData];
    
   refineflag=NO;
    allflag=NO;
    [dishes_Tbl setFrame:CGRectMake(0,89, 320, Cell_height*[dishesArr count]+ 289)];
    [self.scrollView setContentSize:CGSizeMake(320,Cell_height*[dishesArr count]+ 289)];
}
-(void)pickercancel:(id)sender
{
    CurrentButtonTag = 0;
    
    [action dismissWithClickedButtonIndex:0 animated:YES];
    action=nil;
    pickerview=nil;
    pickerview.delegate=nil;
    pickerview.dataSource=nil;
    
    [self SetDefaultOptionColors];
    

    //[dishes_Tbl reloadData];
    [searchActionSheet dismissViewControllerAnimated: YES completion:nil];
}
-(void)pickerDoneClicked:(id)sender
{
    
    CurrentButtonTag = 0;
    
    [self SetDefaultOptionColors];
    
    cellToChange.lblDate.text=drpSelDate;

    
    [action dismissWithClickedButtonIndex:0 animated:YES];
    action=nil;
    pickerview=nil;
    pickerview.delegate=nil;
    pickerview.dataSource=nil;
    
    [searchActionSheet dismissViewControllerAnimated: YES completion:nil];
}
#pragma mark -
#pragma mark - Slider Delegates
- (void) configureLabelSlider
{
    self.labelSlider.minimumValue = 0;
    self.labelSlider.maximumValue = 75;
    
    self.labelSlider.lowerValue = [lowerLabel.text intValue];
    self.labelSlider.upperValue = [upperLabel.text intValue];
    
    self.labelSlider.minimumRange = 0;
}
- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    if(sliderFirst)
    {
        
        CGPoint lowerCenter;
        lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x);
        lowerCenter.y = (self.labelSlider.center.y+20);
        self.lowerLabel.center = lowerCenter;
        self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.lowerValue];
        
        CGPoint lowerCenter1;
        lowerCenter1.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x);
        lowerCenter1.y = (self.labelSlider.center.y+33);
        self.lowerMiles.center = lowerCenter1;

        CGPoint upperCenter;
        upperCenter.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x);
        upperCenter.y = (self.labelSlider.center.y+20);
        self.upperLabel.center = upperCenter;
        self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.upperValue];
        
        CGPoint upperCenter1;
        upperCenter1.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x);
        upperCenter1.y = (self.labelSlider.center.y+33);
        self.uppermiles.center = upperCenter1;
    }
    else
    {
        sliderFirst=YES;
    }
}
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self updateSliderLabels];
//    parseInt=2;
//    [self getDishes];

}


#pragma mark - Search Bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    dishes_Tbl.scrollEnabled = NO;
    searchLayer.hidden = NO;
    UIImage *blurImage = [[self ChangeViewToImage:self.view] stackBlur:3];
    UIImage *newBlurImage = [self cropRect:CGRectMake(0,120, blurImage.size.width, blurImage.size.height) source:blurImage];
    blurView = [[UIImageView alloc] initWithFrame:CGRectMake(0,78, newBlurImage.size.width, newBlurImage.size.height)];
    //
    //
    [blurView setImage:newBlurImage];
    //[searchLayer addSubview:blurView];
    
    searchLayer.userInteractionEnabled = YES;
    searchLayer.multipleTouchEnabled = YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchLayer.hidden = YES;
    dishes_Tbl.scrollEnabled = YES;
    [blurView removeFromSuperview];
    searchLayer.userInteractionEnabled = NO;
    searchLayer.multipleTouchEnabled = NO;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSPredicate *pred1=[NSPredicate predicateWithFormat:@"dish_title CONTAINS[c] %@ || category.title CONTAINS[c] %@ ||dietary CONTAINS[c] %@ || restaurant_details.restaurant_title CONTAINS[c] %@",searchBar.text,searchBar.text,searchBar.text,searchBar.text];
    
    NSPredicate *pred2=[NSPredicate predicateWithFormat:@"category.title == %@",selCat];
   // NSPredicate *pred3=[NSPredicate predicateWithFormat:@"(restaurant_location.distance >= %f && restaurant_location.distance <= %f)|| restaurant_location.distance == %f || restaurant_location.distance == %f",[lowerLabel.text floatValue],[upperLabel.text floatValue],[lowerLabel.text floatValue],[upperLabel.text floatValue]];
    
    NSPredicate *pred4,*compoundPredicate;
    
    
    NSMutableArray *arr=[[NSMutableArray alloc]initWithObjects:pred1,pred2,pred4, nil];
    if([selCat isEqualToString:@"All"])
        [arr removeObject:pred2];
    if([dietryStr length])
        pred4=[NSPredicate predicateWithFormat:@"ANY dietary IN (%@)",dietryStr];
    else
        [arr removeObject:pred4];
    
    
    NSArray *array=[[NSArray alloc]init];
    
    compoundPredicate= [NSCompoundPredicate andPredicateWithSubpredicates:arr];
    array=[dishesCopyArr filteredArrayUsingPredicate:compoundPredicate];
    
    arr=nil;
    if ([array count]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppTitle message:@"There are no dishes available for your specification" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
    }
    else{
        
        dishesArr=[dishesCopyArr filteredArrayUsingPredicate:compoundPredicate];
        
        [self viewWillAppear:YES];
        [dishes_Tbl reloadData];
        search_bar.text=searchBar.text;
        [dishes_Tbl setFrame:CGRectMake(0,89, 320, Cell_height*[dishesArr count])];
        [self.scrollView setContentSize:CGSizeMake(320,Cell_height*[dishesArr count]+140)];
    }
    [self dismissKeyboard:self];
}
#pragma mark-
#pragma mark- TableView Blur Effect
-(UIImage *) ChangeViewToImage : (UIView *) view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
-(UIImage*)cropRect:(CGRect)targetSize source:(UIImage*)sourceImages{
    // Create a new UIImage
    CGImageRef imageRef = CGImageCreateWithImageInRect(sourceImages.CGImage, targetSize);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}
#pragma mark


-(void)checkaddtoBagDishID:(NSString*)dishId Quantity:(NSString*)quantity paytype:(NSString*)paytpe product:(NSDictionary*)proctdict
{
    if ([paytpe isEqualToString:@"authNet"])
    {
        self.dishstrId=[NSString stringWithFormat:@"%@",dishId];
        self.quantityStr=[NSString stringWithFormat:@"%@",quantity];
        self.prodDic=proctdict;
        NSArray *ar=  [[NSUserDefaults standardUserDefaults] valueForKey:@"ListOfCards"];
//        if ([ar count]) {
//            [self performSegueWithIdentifier:@"PaymentSegue" sender:self];
//        }
//        else{
            [self performSegueWithIdentifier:@"PaymentSegue" sender:self];
 
     //   }
    }
    else
    {
        productDict=proctdict;
        qtyStr=quantity;
        // Remove our last completed payment, just for demo purposes.
        // Note: For purposes of illustration, this example shows a payment that includes
        // both payment details (subtotal, shipping, tax) and multiple items.
        // You would only specify these if appropriate to your situation.
        // Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
        // and simply set payment.amount to your total charge.
        // Optional: include multiple items
        
        float price=[[proctdict valueForKey:@"price_with_tax"] floatValue];
        //price=(price*0.20)+price;
        NSString *STRPRI=[NSString stringWithFormat:@"%.2f",price];
        PayPalItem *item3 = [PayPalItem itemWithName:[proctdict valueForKey:@"title"]
                                        withQuantity:1
                                           withPrice:[NSDecimalNumber decimalNumberWithString:STRPRI]
                                        withCurrency:@"USD"
                                             withSku:dishId];
        NSArray *items = @[item3];
        NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
        
        // Optional: include payment details
        NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
        NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:[proctdict valueForKey:@"tax_total"]];
        tax = [[NSDecimalNumber alloc] initWithString: @"0"];
        //  NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
        PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                                   withShipping:shipping
                                                                                        withTax:tax];
        
        NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
        
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        payment.amount = total;
        //        payment.amount = [NSDecimalNumber decimalNumberWithString:STRPRI];
        payment.currencyCode = @"USD";
        payment.shortDescription = [proctdict valueForKey:@"title"];
        payment.items = items;  // if not including multiple items, then leave payment.items as nil
        payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
        payment.shippingAddress=NO;
        
        if (!payment.processable) {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            [GlobalMethods showAlertwithString:@" Failed to process please Try again ! "];
            
        }
        
        // Update payPalConfig re accepting credit cards.
        self.payPalConfig.acceptCreditCards = YES;
        
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                    configuration:self.payPalConfig
                                                                                                         delegate:self];
        
        NSLog(@"self.payPalConfig %@", self.payPalConfig);
        
        [self presentViewController:paymentViewController animated:YES completion:nil];
    }
    
    
}



#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    [self dismissViewControllerAnimated:YES completion:nil];

    [self sendCompletedPaymentToServer:completedPayment];
// Payment was processed successfully; send to server for verification and fulfillment
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation
- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    //    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment);
    
    NSDictionary *dict=[completedPayment.confirmation valueForKey:@"response"];
    NSString *stat=[dict valueForKey:@"state"];
    NSDictionary *address=appDel.deliveryAddr;
    
    if ([stat isEqualToString:@"approved"])
    {
        NSString *pyId=[dict valueForKey:@"id"];
        NSString *userID=[[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"]valueForKey:@"user_id"];
        float price=[[productDict valueForKey:@"price"] floatValue];
        price=(price*0.20)+price;
        
        float tipPrice=0;
        float tipvalue=(float)appDel.tipPercent;

        tipPrice = (tipvalue/100)*price;

        NSString *STRPRI=[NSString stringWithFormat:@"%.2f",price];
        if (hud==nil)
        {
            hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            hud.delegate = self;
            [hud show:YES];
            [self.view addSubview:hud];
            [self.view bringSubviewToFront:hud];
        }
        NSString *isShopping=@"0";
        NSString *promoType;
        if ([[productDict allKeys] containsObject:@"discount_type"] ) {
            
            if ([[productDict allKeys] containsObject:@"isShoppingPromo"] ){
                NSDictionary *shopDic=[prodDic valueForKey:@"isShoppingPromo"];
                if ([[shopDic valueForKey:@"error"] integerValue] == 0) {
                    isShopping=@"1";
                }
            }
            
            promoType=[productDict valueForKey:@"discount_type"];
            
        }
        
        NSString *ordertype=[address valueForKey:@"delivery_type"];
        parseInt=5;
        NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:userID,@"userId",[productDict valueForKey:@"restaurant_id"],@"restaurantId",[productDict valueForKey:@"dish_id"],@"dishId",STRPRI,@"dishPrice",[productDict valueForKey:@"price_with_tax"],@"amountPaid",qtyStr,@"qty",[productDict valueForKey:@"order_by_date"],@"orderByDate",[productDict valueForKey:@"tax_total"],@"salesTax",pyId,@"transactionId",[NSString stringWithFormat:@"%@",appDel.dateSelectedId],@"availabilityId",[address valueForKey:@"delivery_address"],@"delivery_address",[address valueForKey:@"delivery_city"],@"delivery_city",[address valueForKey:@"delivery_state"],@"delivery_state",[address valueForKey:@"delivery_zip"],@"delivery_zip",[address valueForKey:@"delivery_phone"],@"delivery_phone",[address valueForKey:@"address_id"],@"delivery_address_id",[address valueForKey:@"delivery_suiteNo"],@"delivery_suite",[address valueForKey:@"delivery_instructions"],@"delivery_instructions",[NSString stringWithFormat:@"%@",ordertype],@"order_type",isShopping,@"isShoppingPromo",[NSString stringWithFormat:@"%@",promoType],@"promoType",tipvalue,@"tip", nil];
        [parser parseAndGetDataForPostMethod:params withUlr:@"paypalPayment"];
        
    }
    
    //   [GlobalMethods showAlertwithString:[NSString stringWithFormat:@"%@",completedPayment.confirmation]];
    
    
}

#pragma mark - DropDown Delegtes


-(void)removeDropdown
{
    [imgView removeFromSuperview];

    [drp.view removeFromSuperview];
    drp=nil;
    
    [dropDwnBtn setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
}

-(void)didSelectRowInDropdownTableString:(NSString *)myString atIndexPath:(NSIndexPath *)myIndexPath{
    
    if ([appDel.accessToken length])
    {
        if (myIndexPath.row == 0) {
            [self performSegueWithIdentifier:@"ProfileSegue" sender:self];
        }else if(myIndexPath.row == 1){
            fromDropDown=YES;
            [self performSegueWithIdentifier:@"PaymentSegue" sender:self];
        }else if (myIndexPath.row == 2){
            [self performSegueWithIdentifier:@"NotificationSegue" sender:self];
        }else if (myIndexPath.row == 3){
            [self performSegueWithIdentifier:@"ShareSegue" sender:self];
        }else if (myIndexPath.row == 4){
            [self performSegueWithIdentifier:@"OrderHistorySegue" sender:self];
        }else if (myIndexPath.row == 5) {
            [self performSegueWithIdentifier:@"favoriteSegue" sender:self];
        }else if (myIndexPath.row == 6) {
            [self composeMail];
        }else if (myIndexPath.row == 7) {
            [self performSegueWithIdentifier:@"HowItWorks" sender:self];
        }
        else if (myIndexPath.row == 8) {
            [self performSegueWithIdentifier:@"FAQSegue" sender:self];
        }
        else if (myIndexPath.row == 9) {
            [self performSegueWithIdentifier:@"aboutSegue" sender:self];
        }
        else if (myIndexPath.row == 10) {
            [self goToSignInViewLogout];
            
        }
        [self removeDropdown];

    }
    else{
        
        if(myIndexPath.row==0||myIndexPath.row==2||myIndexPath.row==4||myIndexPath.row==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppTitle message:@"Please login to continue" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO" ,nil];
            alert.tag=10;
            [alert show];
            switchTag = nil;
            return;
            
        }
        
        switch ( myIndexPath.row) {
            case 1:
            {
              
            }
                break;
            case 3:
            {
//                UIViewController  *ve=[GlobalMethods checkNavigationexits:[ShareViewController class] navigation:appDel.nav];
//                if (ve==nil)
//                {
//                    ShareViewController *shareCont=[[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
//                    [appDel.nav pushViewController:shareCont animated:YES];
//                }
//                else
//                {
//                    [appDel.nav popToViewController:ve animated:YES];
//                }
                [self performSegueWithIdentifier:@"ShareSegue" sender:self];

            }
                break;
            case 6:
            {
                [self composeMail];
                
            }
                break;
            case 10:
            {
                [self performSegueWithIdentifier:@"LoginSegue" sender:self];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserProfile"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                [appDel.objDBClass ClearUserFavoritesTable];
                [appDel.objDBClass ClearUserProfileDetails];
                [appDel.objDBClass ClearCardDetails];
                switchTag = nil;
            }
                break;
            case 9:
            {
                [self performSegueWithIdentifier:@"aboutSegue" sender:self];
                
            }
                break;
            case 7:
            {
                [self performSegueWithIdentifier:@"HowItWorks" sender:self];
 
            }
                break;
            case 8:
            {
                [self performSegueWithIdentifier:@"FAQSegue" sender:self];
                
            }
                break;
            default:
                break;
        }
        if(!(myIndexPath.row==0||myIndexPath.row==3||myIndexPath.row==4||myIndexPath.row==1))
            [self removeDropdown];
         switchTag = nil;
    }
   
    [self removeDropdown];

}

-(void)goToSignInViewLogout{
    
    [appDel.nav popToRootViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserProfile"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [appDel.objDBClass ClearUserFavoritesTable];
    [appDel.objDBClass ClearUserProfileDetails];
    [appDel.objDBClass ClearCardDetails];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    switchTag = nil;
    
}

-(void)composeMail{
    MFMailComposeViewController *comp=[[MFMailComposeViewController alloc]init];
    [comp setMailComposeDelegate:self];
    if([MFMailComposeViewController canSendMail])
    {
        [comp setToRecipients:[NSArray arrayWithObjects:gmail, nil]];
        [comp setSubject:AppTitle];
        //[comp setMessageBody:@"" isHTML:NO];
        [comp setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:comp animated:YES completion:nil];
        
    }
    else{
        [GlobalMethods showAlertwithString:@"Cannot send mail now"];
    }

}

#pragma mark -
#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10) {
        if(buttonIndex==0)
        {
            [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        }else{
            [self removeDropdown];
            
        }
    }
    else if (alertView.tag==99){
//        if (appDel.IsProcessComplete == YES) {
            [self.navigationController popToViewController:appDel.dishesVC animated:YES];
        //}
    }
    else if (alertView.tag==88){
        if (buttonIndex==1) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
        }
    }
    else {
        if (buttonIndex==1) {
            [self performSegueWithIdentifier:@"LoginSegue" sender:self];
            
        }
    }
    
}


#pragma mark -
#pragma mark - Mail Composer Delegate


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self removeDropdown];
}
/////////////////////////////////////

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

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSString *disabledDate in datesArray) {
        NSDate *dt=[self.dateFormatter dateFromString:disabledDate];
        
        if ([dt  isEqualToDate:date]) {
            NSDate *today = [NSDate date];
            NSComparisonResult result;
            
            NSDate *startOfToday=nil;
            [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&startOfToday interval:NULL forDate:today];
            result = [startOfToday compare:dt];
            if (result==NSOrderedSame || result==NSOrderedAscending) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)dateIsDisabledDot:(NSDate *)date {
    for (NSString *disabledDate in self.availableDatesArray) {
        NSDate *dt=[self.dateFormatter dateFromString:disabledDate];
        
        if ([dt  isEqualToDate:date]) {
           /* NSDate *today = [NSDate date];
            NSComparisonResult result;
            
            NSDate *startOfToday=nil;
            [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&startOfToday interval:NULL forDate:today];
            result = [startOfToday compare:dt];
            if (result==NSOrderedSame || result==NSOrderedDescending) {
                return NO;
            }*/
            return NO;
        }
    }
    return YES;
}
- (BOOL)isdateToday:(NSDate *)date {

    NSDate *dt=[NSDate date];
    
    if ([[NSCalendar currentCalendar] isDate:dt inSameDayAsDate:date]) {
        return YES;
    }
    return NO;
}
-(BOOL)isDateFallsinThisMonth:(NSDate *)date{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];

    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    if(dateComponents.year == components.year && dateComponents.month == components.month){
        
        return YES;
    }
    
    return NO;
    
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    
    
    if ([self dateIsDisabled:date] && ![self isDateFallsinThisMonth:date]) {
        
        dateItem.backgroundColor = [UIColor whiteColor];
        dateItem.textColor = [UIColor lightGrayColor];

    }
    else if(![self dateIsDisabled:date]) {
        //dateItem.layer.borderColor=[UIColor colorWithRed:(147/255.0) green:(189/255.0) blue:(119/255.0) alpha:1];
        //dateItem.borderColor=[UIColor colorWithRed:(147/255.0) green:(189/255.0) blue:(119/255.0) alpha:1] ;
        dateItem.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar_02"]];
        dateItem.textColor = [UIColor whiteColor];
    }
    if ([self isDateFallsinThisMonth:date]) {
        dateItem.textColor = [UIColor blackColor];
        
    }else{
        dateItem.textColor = [UIColor lightGrayColor];
        
    }
      //dateItem.borderColor=[UIColor colorWithRed:(221/255.0) green:(221/255.0) blue:(221/255.0) alpha:0.6] ;

     if ([self isdateToday:date] && [self dateIsDisabled:date]) {
         dateItem.borderColor=[UIColor colorWithRed:(147/255.0) green:(189/255.0) blue:(119/255.0) alpha:0.6] ;

     }else{
         dateItem.borderColor=[UIColor clearColor];
     }
    
    
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    [self setImages];
    selectedDate = [self.dateFormatter stringFromDate:date];
    [self pickerDoneClicked1:self];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {

        return YES;
}




#pragma mark -
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RPPSegue"]) {
        RestaurantDetailViewController *controller = ([segue.destinationViewController isKindOfClass:[RestaurantDetailViewController class]]) ? segue.destinationViewController : nil;
        if ([appDel.resFavClickedBeforeLogin isEqual:@"Y"]){
            appDel.resFavClickedBeforeLogin=@"N";
            controller.restaurantArray=[[dishesArr objectAtIndex:[appDel.currentTagID integerValue]] valueForKey:@"restaurant_details"];
        }
            else{
                controller.restaurantArray=[[dishesArr objectAtIndex:[sender tag]-222] valueForKey:@"restaurant_details"];
            }
    }
    if ([segue.identifier isEqualToString:@"DishDetailSegue"]) {
        Dish_DetailViewViewController *controller = ([segue.destinationViewController isKindOfClass:[Dish_DetailViewViewController class]]) ? segue.destinationViewController : nil;
       
        if ([appDel.orderClickedBeforeLogin isEqual:@"Y"] || [appDel.favClickedBeforeLogin isEqual:@"Y"]) {
            
            appDel.orderClickedBeforeLogin=@"N";
            appDel.favClickedBeforeLogin=@"N";
            NSString *str=appDel.currentDishId;
            
            if (str==nil) {
                controller.Dish_Details_dic=[dishesArr objectAtIndex:[appDel.currentTagID integerValue]];
            }
            else{
               NSPredicate *pred=[NSPredicate predicateWithFormat:@"dish_id == %@",appDel.currentDishId];
                NSArray *req=[dishesArr filteredArrayUsingPredicate:pred];
                NSMutableDictionary *required=[req objectAtIndex:0];
                controller.Dish_Details_dic=required;
                
                if (datePickerSelIndex) {
                    controller.selectedDateInExplore=drpSelectedDate;


                    datePickerSelIndex=nil;

                }else{
                    if (appDel.dateSelected!=nil) {

                        controller.selectedDateInExplore=appDel.dateStringForGuest;

                    }else
                    controller.selectedDateInExplore=selectedDate;

                }
                appDel.currentDishId=nil;
                appDel.dateStringForGuest=nil;

            }

        }
        else{
            NSPredicate *pred=[NSPredicate predicateWithFormat:@"dish_id == %@",appDel.currentDishId];
            NSArray *req=[dishesArr filteredArrayUsingPredicate:pred];
            NSMutableDictionary *required=[req objectAtIndex:0];
            controller.Dish_Details_dic=required;
            if (datePickerSelIndex) {
                controller.selectedDateInExplore=drpSelectedDate;
                appDel.dateStringForGuest=drpSelectedDate;

                datePickerSelIndex=nil;
                
            }else{
                controller.selectedDateInExplore=selectedDate;
                appDel.dateStringForGuest=selectedDate;

            }
        }
        
    }
    if ([segue.identifier isEqualToString:@"AddCardSegue"]) {
    }
    if ([segue.identifier isEqualToString:@"PaymentSegue"]) {
        PaymentViewController *payment=([segue.destinationViewController isKindOfClass:[PaymentViewController class]]) ? segue.destinationViewController : nil;
        if (fromDropDown) {
            payment.fromCheckOut = NO;
            fromDropDown=NO;
        }
        else{
            payment.fromCheckOut = YES;
            
            payment.dishId=dishstrId;
            
            payment.quantity=quantityStr;
            payment.proDict=self.prodDic;
            payment.isShopping=@"0";
            if ([[prodDic allKeys] containsObject:@"discount_type"] ) {
                
                if ([[prodDic allKeys] containsObject:@"isShoppingPromo"] ){
                    NSDictionary *shopDic=[prodDic valueForKey:@"isShoppingPromo"];
                    if ([[shopDic valueForKey:@"error"] integerValue] == 0) {
                        payment.isShopping=@"1";
                    }
                }
                
                payment.promoType=[prodDic valueForKey:@"discount_type"];
                
            }
            else{
                payment.promoType=@"";
            }
            
        }
    }
}
- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 3, 3);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -
#pragma mark -
- (IBAction)searchNearMe:(id)sender {
    [self distaneSearch:self];
}

- (IBAction)showNotifications:(id)sender {
    
    if ([appDel.accessToken length] || [appDel.accessToken isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"NotificationSegue" sender:self];
    }

}
@end