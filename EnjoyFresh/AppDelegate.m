 //
//  AppDelegate.m
//  EnjoyFreshasdasd
// 
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//
#import "AppDelegate.h"
#import "Registration.h"
#import "LoginViewController.h"
#import "PayPalMobile.h"
#import "NotificationViewController.h"
//#import <Parse/Parse.h>

@implementation AppDelegate
@synthesize homeContrller,accessToken,isFB,nav,orderHistroy_count,latStr,longStr,dishesVC,parse_ObjectId,paymentVC,deliveryAddr,currentDishId,reviewSubmit,addrFromLocation,token,pushFlag;
@synthesize objDBClass;
@synthesize CurrentCustomerDetails,DeviceToken,dateSelected,dateSelectedId,rememberDateFlag;
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //On application relaunch, all database tables are cleared, except User Profile details table.
    objDBClass = [[DBClass alloc] init];
    [objDBClass DropRestaurantDetailsTable];
    [objDBClass DropUserFavoritesTable];
    [objDBClass DropCardDetailsTable];
    [objDBClass CreateDB];
    
    //Clearing all cached data
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    //Clearing Image cache
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    
    /////////////INITILIZATION FOR PAYPAL
#warning "Enter your credentials"
    [PayPalMobile initializeWithClientIdsForEnvironments:
     @{PayPalEnvironmentProduction : payPal_clientIdForProduction,
                                                           PayPalEnvironmentSandbox :payPal_clientIdForSandBox}];
    

    [self.window makeKeyAndVisible];
        [FBLoginView class];
    addrFromLocation=[[NSDictionary alloc]init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
/////////////INTEGRATING PUSH USING PARSE
   // [Parse setApplicationId:parse_AppId clientKey:parse_clientId];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge |
          UIUserNotificationTypeSound |
          UIUserNotificationTypeAlert)];
    }

    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
    [Stripe setDefaultPublishableKey:StripePublishableKey];
    [self updateCurrentLocation];

    nav=(UINavigationController *)self.window.rootViewController;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSDictionary *tmpDic = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (tmpDic != nil) {

        appDel.pushFlag=YES;
    }
    else{
        appDel.pushFlag=NO;
    }
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    
    NSLog(@"Device Token %@", deviceToken);
    token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"user info:%@",userInfo);
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
    {
        //opened from a push notification when the app was on background
        NSDictionary *dict=[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"];
        if(dict !=nil && !appDel.profileUpdated)
        {
            nav=(UINavigationController *)self.window.rootViewController;
            NSArray *ar=nav.viewControllers;
            UIViewController *vc=[ar lastObject];
            if ([vc isKindOfClass:[NotificationViewController class]]) {
                
            }
            else{
                [vc performSegueWithIdentifier:@"NotificationSegue" sender:nil];
  
            }
        }
    }
    

}

#pragma mark - Remote notifications handling

-(void)handleRemoteNotifications:(NSDictionary *)userInfo
{
    NSLog(@"Remote: %@", userInfo);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Push error %@",error);
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* currentLocation = [locationManager location];
    
    self.latStr=[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    self.longStr=[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//    NSLog(@"location OFF");
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];

    [self updateCurrentLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppEvents activateApp];
    nav=(UINavigationController *)self.window.rootViewController;

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - 
#pragma mark - Twitter Methods
- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
//    NSLog(@"%@",[url scheme]);
    
    if (isFB==YES) {
        nav=(UINavigationController *)self.window.rootViewController;

        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
        
    }else
    {
        
        if ([[url scheme] isEqualToString:@"com.enjoyfresh.enjoyfresh"] == NO)
        {
            return NO;
            
        }
        NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
        
        token = d[@"oauth_token"];
        verifier = d[@"oauth_verifier"];
        
        nav=(UINavigationController *)self.window.rootViewController;
        NSArray *ar=nav.viewControllers;
        UIViewController *vc=[ar lastObject];

        if ([vc isKindOfClass:[Registration class]]) {
            Registration *vc1 = (Registration *)[ar lastObject];
            [vc1 setOAuthToken:token oauthVerifier:verifier];

        }
        else{
            LoginViewController *vc1=(LoginViewController *)[ar lastObject];
            [vc1 setOAuthToken:token oauthVerifier:verifier];
        }
        return YES;
    }
}

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
    [nav dismissViewControllerAnimated:YES completion:nil];
    //[delegate removeDropdown];
}

- (void)updateCurrentLocation {
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:locationManager.location // You can pass aLocation here instead
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
//                       dispatch_async(dispatch_get_main_queue(),^ {
//                           // do stuff with placemarks on the main thread
                       
                           if (placemarks.count == 1) {
                               
                               CLPlacemark *place = [placemarks objectAtIndex:0];
                               
                               addrFromLocation=place.addressDictionary;
                               
                           }
                           
                       }];
    
    sleep(3);
                  // }];
}
@end
