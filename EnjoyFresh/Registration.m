//
//  Registration.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "Registration.h"
#import "Global.h"
#import "GlobalMethods.h"
#import "LoginViewController.h"


#define FIELDS_COUNT  5
int parseInt;
NSMutableString *email;
static NSString *apiKey=@"TJqDoM0AJyeLnZYCQQJIfuyNm";
static NSString *consumerKey=@"yIPITPHBFJ7CuwN857MvtGwflwF0ViZa7D3YEa78VjW9z98tx4";

@interface Registration ()
@property (nonatomic, strong) STTwitterAPI *twitter;

@end

@implementation Registration
@synthesize fromLogin,socialDict,loginType,zipString,passwdFld,zipCode,phoneNumber,emailFld;
@synthesize CurrentUserDetails;
#pragma mark -
#pragma mark - ViewcontrollerLifeCycle Methods

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    
    //getting location latitude and longitude
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;

    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self updateCurrentLocation];
    
    email=[[NSMutableString alloc]init];
     [[UIBarButtonItem appearance] setTitleTextAttributes: [GlobalMethods barbuttonFont] forState:UIControlStateNormal];
    
    NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc] initWithString:@"By clicking on sign up.I agree to enjoyfresh terms."];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,str1.length)];
    [str1 addAttribute: NSLinkAttributeName value: @"By clicking on sign up.I agree to enjoyfresh terms." range: NSMakeRange(str1.length-6, 6)];
    self.btnTerms.titleLabel.attributedText = str1;
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);
    self.btnback2.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);

    self.lblLastStep.font=[UIFont fontWithName:Regular size:14];
    NSAttributedString * email1 = [[NSAttributedString alloc] initWithString:@"Your email" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    emailFld.attributedPlaceholder = email1;
    
    NSAttributedString * firstN = [[NSAttributedString alloc] initWithString:@"First name" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    firstNameFld.attributedPlaceholder = firstN;
    
    NSAttributedString * lastN = [[NSAttributedString alloc] initWithString:@"Last name" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    lastNameFld.attributedPlaceholder = lastN;
    
    NSAttributedString * PW = [[NSAttributedString alloc] initWithString:@"Your password" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    passwdFld.attributedPlaceholder = PW;
    
    NSAttributedString * zip = [[NSAttributedString alloc] initWithString:@"Zip" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    zipCode.attributedPlaceholder = zip;
    
    NSAttributedString * promo = [[NSAttributedString alloc] initWithString:@"Enter promo code" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    promoFld.attributedPlaceholder = promo;
    
    NSAttributedString * phno = [[NSAttributedString alloc] initWithString:@"Phone number" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    phoneNumber.attributedPlaceholder = phno;
    
    titleLbl.font=[UIFont fontWithName:Regular size:18.0f];
    
    CALayer *layer = [self.btnSignUp layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    CALayer *layer1 = [_FBloginButton layer];
    [layer1 setMasksToBounds:YES];
    [layer1 setCornerRadius:3.0];
    CALayer *layer2 = [self.btnTwitter layer];
    [layer2 setMasksToBounds:YES];
    [layer2 setCornerRadius:3.0];
    CALayer *layer3 = [self.btnFB layer];
    [layer3 setMasksToBounds:YES];
    [layer3 setCornerRadius:3.0];
    
    self.btnSignUp.titleLabel.font=[UIFont fontWithName:Bold size:15];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClicked:)];
    barButtonPrev = [[UIBarButtonItem alloc] initWithTitle:@"Prev"  style:UIBarButtonItemStyleDone target:self action:@selector(previousButtonClicked:)];
    barButtonNext = [[UIBarButtonItem alloc] initWithTitle:@"Next"  style:UIBarButtonItemStyleDone target:self action:@selector(nextButtonClicked:)];
    
    
    NSArray *itemsArray = @[barButtonPrev,barButtonNext,flexableItem,doneButton];
    [toolbar setItems:itemsArray];
    
    [firstNameFld setInputAccessoryView:toolbar];
    [phoneNumber setInputAccessoryView:toolbar];
    [emailFld setInputAccessoryView:toolbar];
    [passwdFld setInputAccessoryView:toolbar];
    [zipCode setInputAccessoryView:toolbar];
    [lastNameFld setInputAccessoryView:toolbar];
    [promoFld setInputAccessoryView:toolbar];
    
    
    if(fromLogin)
    {
        firstNameFld.text=[socialDict valueForKey:@"FirstName"];
        lastNameFld.text=[socialDict valueForKey:@"LastName"];
        emailFld.text=[socialDict valueForKey:@"Email"];
    }
    else
    {
        loginType=@"default";
    }
    
    self.FBloginButton.backgroundColor=[UIColor clearColor];
    self.FBloginButton.readPermissions=@[@"public_profile", @"email", @"user_friends",@"user_birthday"];
    
    _FBloginButton.frame=CGRectMake(13, 17, 145, 27);
    for (id loginObject in _FBloginButton.subviews)
    {
        if ([loginObject isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton1 =  loginObject;
            [loginButton1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [loginButton1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
            [loginButton1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
            
            loginButton1.titleLabel.font=[UIFont fontWithName:Regular size:16.0f];
            
            [loginButton1 setTitle:@"" forState:UIControlStateSelected];
            loginButton1.layer.cornerRadius=4.0f;
            loginButton1.backgroundColor=[UIColor colorWithRed:59.0f/255.0f green:89.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            loginButton1.backgroundColor=[UIColor clearColor];
            
            [loginButton1 addTarget:self action:@selector(facebookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([loginObject isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel = loginObject;
            loginLabel.font=[UIFont systemFontOfSize:12.0f];
            loginLabel.text = @"";
            loginLabel.frame = CGRectMake(-40, 0, 300, 30);
            loginLabel.alpha=0.0f;
        }
    }
    self.verificationPopupView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.ahshucksPopup.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];


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
                               
                               zipCode.text=self.zipString;
                               self.socialZip.text=self.zipString;
                           }
                           
                       });
                       
                   }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //getting location latitude and longitude
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//For ScrollView
- (void)viewDidLayoutSubviews
{
    if(!IS_IPHONE5)
        [scroll setContentSize:CGSizeMake(0, 800)];
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
-(void)doneButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)checkBarButton:(NSUInteger)tag
{
    [barButtonPrev setEnabled:tag == 1 ? NO : YES];
    [barButtonNext setEnabled:tag == FIELDS_COUNT ? NO : YES];
}
- (void)animateView:(NSUInteger)tag
{
    if(IS_IPHONE5)
    {
        if (tag >2){
            [scroll setContentOffset:CGPointMake(0, 45.0f * (tag - 1)) animated:YES];
            [socialScroll setContentOffset:CGPointMake(0, 45.0f * (tag - 1)) animated:YES];
        }

        else{
            [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
            [socialScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        }

    }
    else
    {
        if (tag > 0){
            [scroll setContentOffset:CGPointMake(0, 65.0f * (tag - 1)) animated:YES];
            [socialScroll setContentOffset:CGPointMake(0, 65.0f * (tag - 1)) animated:YES];

        }
        else{
            [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
            [socialScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        }

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

-(IBAction)socailBackBtnClicked:(id)sender
{
    [socialView removeFromSuperview];
    [self.verificationPopupView removeFromSuperview];
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [socialScroll setContentOffset:CGPointMake(0, 0) animated:YES];

}

-(IBAction)socailLoginBtnClicked:(id)sender
{
    
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
            //if([OffersBtn currentImage]==[UIImage imageNamed:@"checked_checkbox"])
            //ofer=1;
            
            parseInt=4;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.socialZip.text,@"zipcode",
                                    devicetoken,@"devicetoken",[socialDict valueForKey:@"FirstName"],@"firstname",[socialDict valueForKey:@"LastName"],@"lastname",[promoFld.text length]?promoFld.text:@"",@"promoId",[socialDict valueForKey:@"Email"],@"email",[socialDict valueForKey:@"FBUserId"],@"facebookId",[NSNumber numberWithInt:ofer],@"offers",self.socialPhone.text,@"mobile",[appDel.token length]?appDel.token:@"",@"apn_device_token",nil];
            
            appDel.CurrentCustomerDetails.user_devicetoken = devicetoken;
            appDel.CurrentCustomerDetails.user_zipcode = self.zipString;
            
            [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
            
            [parser parseAndGetDataForPostMethod:params withUlr:@"facebookRegister"];
        }
        
        email=[socialDict valueForKey:@"Email"];
        
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
            
            parseInt=4;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.socialZip.text,@"zipcode",
                                    devicetoken,@"devicetoken",[socialDict valueForKey:@"FirstName"],@"firstname",[socialDict valueForKey:@"LastName"],@"lastname",[promoFld.text length]?promoFld.text:@"",@"promoId",socialEmailFld.text,@"email",self.socialPhone.text,@"mobile",[socialDict valueForKey:@"FBUserId"],@"twitterId",[NSNumber numberWithInt:ofer],@"offers",[appDel.token length]?appDel.token:@"",@"apn_device_token",nil];
            
            appDel.CurrentCustomerDetails.user_devicetoken = devicetoken;
            appDel.CurrentCustomerDetails.user_zipcode = self.zipString;
            
            [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
            
            [parser parseAndGetDataForPostMethod:params withUlr:@"twitterRegister"];
            email=socialEmailFld.text;
//            parser.delegate=self;
        }
        
    }
}

#pragma mark -
#pragma mark -  Button Actions


- (IBAction)facebookButtonClicked:(id)sender {
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
}

- (IBAction)twitterLogin:(id)sender {
    ////////login with IOSActions
    [self.view endEditing:YES];
    appDel.isFB=NO;
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        twitterScrenNme =username;
        [self getInfo];
    } errorBlock:^(NSError *error)
     {
         [self loginInSafariAction:nil];
         
     }];

}

-(IBAction)BackBtnClicked:(id)sender
{
    [self.verificationPopupView removeFromSuperview];
    if(fromLogin)
        [self dismissViewControllerAnimated:YES completion:NULL];
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)registrtionBtnClicked:(id)sender
{
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];
    if(![firstNameFld.text length])
    {
        [GlobalMethods showAlertwithString:@"Please enter your name"];
        return;
    }
    if ([firstNameFld.text length]<2) {
        [GlobalMethods showAlertwithString:@"The name should contain at least 2 characters."];
        return;
    }
    if(![lastNameFld.text length])
    {
        [GlobalMethods showAlertwithString:@"Please enter your last name"];
        return;
    }
    if (![emailFld.text length] || [GlobalMethods checkWhiteSpace:emailFld.text]) {
        [GlobalMethods showAlertwithString:@"Please enter your Email"];
        return;
    }
    if(![GlobalMethods isItValidEmail:emailFld.text])
    {
        [GlobalMethods showAlertwithString:@"The user's email should be a valid email address."];
        return;
    }
    if(![passwdFld.text length]||[GlobalMethods checkWhiteSpace:passwdFld.text])
    {
        [GlobalMethods showAlertwithString:@"Please enter your password"];
        return;
    }
    if([passwdFld.text length]<8)
    {
        [GlobalMethods showAlertwithString:@"The password should be at least 8 characters."];
        return;
    }
    if(![zipCode.text length]||[GlobalMethods checkWhiteSpace:zipCode.text])
    {
        [GlobalMethods showAlertwithString:@"Please enter zip code"];
        return;
    }
    if(![phoneNumber.text length]||[GlobalMethods checkWhiteSpace:phoneNumber.text])
    {
        [GlobalMethods showAlertwithString:@"Please enter phone number."];
        return;
    }
    if([phoneNumber.text length]<10)
    {
        [GlobalMethods showAlertwithString:@"Please enter Valid phone number."];
        return;
    }
    
    if(hud==nil)
    {
        hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    NSString *devicetoken=[GlobalMethods getUDIDOfdevice];
    
    int offer=0;
    //if([offersBtn currentImage]==[UIImage imageNamed:@"checked_checkbox"])
    //ofer=1;
    parseInt=1;
    email=emailFld.text;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:emailFld.text,@"email",passwdFld.text,@"password",devicetoken,@"devicetoken",zipCode.text,@"zipcode",firstNameFld.text,@"firstname",lastNameFld.text,@"lastname",[NSNumber numberWithInt:offer],@"offers",loginType,@"loginType",phoneNumber.text,@"mobile",[promoFld.text length]?promoFld.text:@"",@"promoId",[appDel.token length]?appDel.token:@"",@"apn_device_token",nil];
    [parser parseAndGetDataForPostMethod:params withUlr:@"customerRegister"];

   /* [parser parseAndGetDataForPostMethod:params withUlr:@"customerRegister"];
    if([firstNameFld.text length])
    {
        if([firstNameFld.text length]>=2)
        {
            if([lastNameFld.text length])
            {
                if([emailFld.text length] !=0 || [GlobalMethods checkWhiteSpace:emailFld.text])
                {
                    if([passwdFld.text length]||[GlobalMethods checkWhiteSpace:passwdFld.text])
                    {
                        if([passwdFld.text length]>=8)
                        {
                            if([zipCode.text length]||[GlobalMethods checkWhiteSpace:zipCode.text])
                            {
                                if([GlobalMethods isItValidEmail:emailFld.text])
                                {
                                    if([phoneNumber.text length]||[GlobalMethods checkWhiteSpace:phoneNumber.text])
                                    {
                                        if([phoneNumber.text length]==10)
                                        {
                                            if(hud==nil)
                                            {
                                                hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
                                                hud.delegate = self;
                                                [hud show:YES];
                                                [self.view addSubview:hud];
                                            }
                                            NSString *devicetoken=[GlobalMethods getUDIDOfdevice];
                                            
                                            int offer=0;
                                            //if([offersBtn currentImage]==[UIImage imageNamed:@"checked_checkbox"])
                                            //ofer=1;
                                            parseInt=1;
                                            email=emailFld.text;
                                            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:emailFld.text,@"email",passwdFld.text,@"password",devicetoken,@"devicetoken",zipCode.text,@"zipcode",firstNameFld.text,@"firstname",lastNameFld.text,@"lastname",[NSNumber numberWithInt:offer],@"offers",loginType,@"loginType",phoneNumber.text,@"mobile",[promoFld.text length]?promoFld.text:@"",@"promoId",[appDel.token length]?appDel.token:@"",@"apn_device_token",nil];
                                            
                                            [parser parseAndGetDataForPostMethod:params withUlr:@"customerRegister"];
                                        }
                                        else
                                            [GlobalMethods showAlertwithString:@"Please enter  Valid phone number."];
                                    }
                                    else
                                        [GlobalMethods showAlertwithString:@"Please enter phone number."];
                                }
                                else
                                    [GlobalMethods showAlertwithString:@"The user's email should be a valid email address."];
                            }
                            else
                                [GlobalMethods showAlertwithString:@"Please enter zip code"];
                        }
                        else
                            [GlobalMethods showAlertwithString:@"The password should be at least 8 characters."];
                    }
                    else
                        [GlobalMethods showAlertwithString:@"Please enter your password"];
                }
                else
                    [GlobalMethods showAlertwithString:@"Please enter your Email"];
            }
            else
                [GlobalMethods showAlertwithString:@"Please enter your last name"];
        }
        else
            [GlobalMethods showAlertwithString:@"The name should contain at least 2 characters."];
    }
    else
        [GlobalMethods showAlertwithString:@"Please enter your name"];*/
}


- (IBAction)heperLinkClicked:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [sender setAlpha:0];
    } completion:^(BOOL finished) {
        [sender setAlpha:1.0];
    }];
    if ([sender tag]==100) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.enjoyfresh.com/terms"]];
    }
    else
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.enjoyfresh.com/sweepstakes-rules"]];
    
    NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc] initWithString:@"Agree to terms"];
    [str1 addAttribute:NSForegroundColorAttributeName value:red_Color range:NSMakeRange(0,str1.length)];
    [str1 addAttribute: NSLinkAttributeName value: @"Agree to terms" range: NSMakeRange(8, 6)];
    hyperLnkBtn.titleLabel.attributedText = str1;
    hyperLnkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"Participate in sweepstakes"];
    [str addAttribute:NSForegroundColorAttributeName value:red_Color range:NSMakeRange(0,str.length)];
    [str addAttribute: NSLinkAttributeName value: @"Participate in sweepstakes" range: NSMakeRange(15, 11)];
    sweepsLink.titleLabel.attributedText = str;
    sweepsLink.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}
#pragma mark
#pragma mark - TextField Delgates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSUInteger tag = [textField tag];
    [self animateView:tag];
    [self checkBarButton:tag];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [socialScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];

    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
    if([string isEqualToString:@" "]){
        // Returning no here to restrict whitespace
        return NO;
    }
    if (textField == firstNameFld ||  textField == lastNameFld) {
        return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
    }
    if(textField==phoneNumber || textField== self.socialPhone)
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
    if(textField==zipCode || textField==_socialZip)
    {
        if (textField.text.length >= 5 && range.length == 0)
            return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == passwdFld) {
        NSUInteger newLength = [textField.text length];
        if (newLength<8) {
            [GlobalMethods showAlertwithString:@"Password must be atleast 8 characters"];
        }
    }
}
#pragma mark
#pragma mark - ParseAndGetData Delegates
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
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
            parseInt=7;
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
        else if ([strErrorMessage isEqualToString:@"User is not verified"]){
            self.ahshucksPopup.frame=CGRectMake(0, 64, 320, 504);
            [self.view addSubview:self.ahshucksPopup];
            [self.view bringSubviewToFront:self.ahshucksPopup];
            if (appDel.isFB) {
                
            }
            else{
                email=[result valueForKey:@"email"];
              }
        }
        else
        {
            [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
        }
        
    }
    else
    {
        if (parseInt==1) {
        
            // [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
            self.verificationPopupView.frame=CGRectMake(0, 64, 320, 504);
            [self.view addSubview:self.verificationPopupView];
            [self.view bringSubviewToFront:self.verificationPopupView];

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
            
            [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[favcount count]] forKey:@"FAVCount"];
            [dict setObject:(NSMutableArray *)[[result  valueForKey:@"deliveryAddresses"] mutableCopy] forKey:@"deliveryAddresses"];
            
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
            
            [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
            
            
        }
        else if(parseInt==4)
        {
            NSLog(@"Login View Result: %@", result);
            
           /* */
            self.verificationPopupView.frame=CGRectMake(0, 64, 320, 504);
            [self.view addSubview:self.verificationPopupView];
            [self.view bringSubviewToFront:self.verificationPopupView];
            
        }
        else if(parseInt==5)
        {
            CurrentUserDetails = [appDel.objDBClass GetUserProfileDetails];
            
            if(CurrentUserDetails == nil)
            {
                CurrentUserDetails = [[ProfileClass alloc] init];
            }
            
            CurrentUserDetails.user_id = [[result valueForKey:@"profile"] valueForKey:@"user_id"];
            CurrentUserDetails.user_first_name = [[result valueForKey:@"profile"] valueForKey:@"first_name"];
            CurrentUserDetails.user_last_name = [[result valueForKey:@"profile"] valueForKey:@"last_name"];
            // CurrentUserDetails.user_mobile = [[result valueForKey:@"profile"] valueForKey:@"mobile"];
            CurrentUserDetails.user_email = [[result valueForKey:@"profile"] valueForKey:@"email"];
            CurrentUserDetails.user_devicetoken =
            [[result valueForKey:@"profile"] valueForKey:@"devicetoken"];
            CurrentUserDetails.user_image = [[result valueForKey:@"profile"] valueForKey:@"image"];
            CurrentUserDetails.user_is_discount_applied = [[result valueForKey:@"profile"] valueForKey:@"is_discount_applied"];
            CurrentUserDetails.user_is_sweep = [[result valueForKey:@"profile"] valueForKey:@"is_sweep"];
            CurrentUserDetails.user_ref_promo = [[result valueForKey:@"profile"] valueForKey:@"ref_promo"];
            CurrentUserDetails.user_ref_promo_count = [[result valueForKey:@"profile"] valueForKey:@"ref_promo_count"];
            CurrentUserDetails.user_zipcode = [[result valueForKey:@"profile"] valueForKey:@"zipcode"];
            CurrentUserDetails.user_password = passwdFld.text;
            // CurrentUserDetails.user_auth_id = [[result valueForKey:@"profile"] valueForKey:@"customerProfileId"];
            
            appDel.CurrentCustomerDetails = CurrentUserDetails;
            [appDel.objDBClass InserUserProfileDetails:  CurrentUserDetails];
            
            [GlobalMethods showAlertwithString:@"Thank You for signing up! You're on your way to enjoying exclusive culinary offerings."];
            
            NSDictionary *loginDict=[[NSDictionary alloc]initWithObjectsAndKeys:emailFld.text,@"Email",passwdFld.text,@"Password", nil];
            [[NSUserDefaults standardUserDefaults] setObject:loginDict forKey:@"credentials"];
            [[NSUserDefaults standardUserDefaults ] synchronize];
            loginDict=nil;
            
            //        LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            //        [self.navigationController pushViewController:login animated:YES];
            
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"Succesfull Signup_iOSMobile" properties:@{
                                                                        @"First Name":[[result valueForKey:@"profile"] valueForKey:@"first_name"],
                                                                        @"Last Name":[[result valueForKey:@"profile"] valueForKey:@"last_name"],
                                                                        @"Email":[[result valueForKey:@"profile"] valueForKey:@"email"],
                                                                        @"Zip":[[result valueForKey:@"profile"] valueForKey:@"zipcode"]
                                                                        }];
            
            appDel.accessToken=[result valueForKey:@"accessToken"];
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:[result valueForKey:@"profile"]];
            [dict setObject:passwdFld.text forKey:@"password"];
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
            //[appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
            
            //CurrentUserProfile = [appDel.objDBClass GetUserProfileDetails];
            
            [self InsertUserProfileDetails:dict];
            [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
        }
        else if(parseInt==6)
        {
            [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
 
        }
        else if(parseInt==7){
            
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
            [dict setObject:(NSMutableArray*)[result  valueForKey:@"deliveryAddresses"] forKey:@"deliveryAddresses"];
            
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
            [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
        }
        else
        {
            //[self.view addSubview:InitialRegistration];
        }

    }
    [hud hide:YES];
}
-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    [hud hide:YES];
    [GlobalMethods showAlertwithString:err];
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
        
    } oauthCallback:@"com.enjoyfresh.EnjoyFresh://572122021-2VXAVL5uISZbcpZq80UF52S1AbLWmneKDDjtkCpR/&force_login=1"
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
                            NSString *lastaName;
                            if (nmesArr.count>1) {
                                lastaName=[nmesArr objectAtIndex:1];
                            }
                            else{
                                lastaName=@" ";
                            }
                            twitterId=[TWData valueForKey:@"id_str"];
                            _CurrentTwitterID = twitterId;
                            socialDict=[[NSDictionary alloc]initWithObjectsAndKeys:[nmesArr objectAtIndex:0],@"FirstName",lastaName,@"LastName",@"",@"Email",twitterId,@"FBUserId", nil];
                            
                            if(appDel.CurrentCustomerDetails == nil)
                            {
                                appDel.CurrentCustomerDetails = [[ProfileClass alloc] init];
                            }
                            
                            appDel.CurrentCustomerDetails.user_first_name = [nmesArr objectAtIndex:0];
                            appDel.CurrentCustomerDetails.user_last_name = lastaName;
                            appDel.CurrentCustomerDetails.user_email = @"";
                            appDel.CurrentCustomerDetails.user_twitter = twitterId;
                            
                            [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
                            
                            
                            if(hud==nil)
                            {
                                hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
                                [hud show:YES];
                                [self.view addSubview:hud];
                                hud.delegate = (id)self;
                                
                            }
                            [socialEmailFld setHidden:NO];
                        
                            parseInt=3;
                           // NSString *urlquerystring=[NSString stringWithFormat:@"checkTWUser?twitterId=%@",twitterId];
                            NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:twitterId,@"twitterId", nil];
                            [parser parseAndGetDataForPostMethod:params withUlr:@"checkTWUser"];
                            //[parser parseAndGetDataForGetMethod:urlquerystring];
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
    
//    [emailImg setHidden:YES];
//    [socialEmailFld setHidden:YES];
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
        hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    
    parseInt=3;
    NSString *urlquerystring=[NSString stringWithFormat:@"checkFBUser?facebookId=%@&email=%@",
                              [user objectForKey:@"id"], [user objectForKey:@"email"]];
    email=[user objectForKey:@"email"];
    [parser parseAndGetDataForGetMethod:urlquerystring];
    
}
-(void)cleardata
{
    _FBloginButton.delegate=nil;
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession setActiveSession:nil];
    
}
//-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
//{
//    NSLog(@"You are logged out.");
//}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}




#pragma mark
#pragma mark - HUD Delegtes
- (void)hudWasHidden:(MBProgressHUD *)huda {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    hud = nil;
}
- (IBAction)showTermsConditions:(id)sender {
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.enjoyfresh.com/ef/tos"]];

}
- (IBAction)resendCode:(id)sender{
    if (hud==nil) {
        hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    parseInt=6;
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:email,@"email", nil];
    [parser parseAndGetDataForPostMethod:params withUlr:@"resendTwilioPin"];
}

- (IBAction)submitCodeFromAhshk:(id)sender {
    [self.view endEditing:YES];
    if ([self.ahsTxtcode.text length] && ![GlobalMethods checkWhiteSpace:self.ahsTxtcode.text]) {
        if (hud==nil) {
            hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
            hud.delegate = self;
            [hud show:YES];
            [self.view addSubview:hud];
        }
        if (parseInt!=7) {
            parseInt=5;
        }
        else{
            parseInt=7;
        }
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.ahsTxtcode.text,@"twilioPin",email,@"email", nil];
        [parser parseAndGetDataForPostMethod:params withUlr:@"verifyTwilioPin"];
    }
    
}
- (IBAction)submitCode:(id)sender {
    [self.view endEditing:YES];
    if ([self.txtCode.text length] && ![GlobalMethods checkWhiteSpace:self.txtCode.text]) {
        if (hud==nil) {
            hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
            hud.delegate = self;
            [hud show:YES];
            [self.view addSubview:hud];
        }
        if (parseInt!=7) {
            parseInt=5;
        }
        else{
            parseInt=7;
        }
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.txtCode.text,@"twilioPin",email,@"email", nil];
        [parser parseAndGetDataForPostMethod:params withUlr:@"verifyTwilioPin"];
    }
    

}
- (IBAction)resendCodeFromAhshk:(id)sender {
    if (hud==nil) {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    parseInt=6;
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:email,@"email", nil];
    [parser parseAndGetDataForPostMethod:params withUlr:@"resendTwilioPin"];
}

- (IBAction)removeAhshucks:(id)sender {
    [self.ahshucksPopup removeFromSuperview];
}

- (IBAction)removeVerfication:(id)sender {
    [socialView removeFromSuperview];
    [self.verificationPopupView removeFromSuperview];

}
@end