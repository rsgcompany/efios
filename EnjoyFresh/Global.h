//
//  Global.h
//  EnjoyFresh
//   
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#ifndef EnjoyFresh_Global_h
#define EnjoyFresh_Global_h

#import "AppDelegate.h"
#define appDel ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height==568)
#define AppTitle @"Enjoy Fresh"



////// server to   www.enjoyfresh.com
//
// #define BaseURL @"http://www.enjoyfresh.com/mobile/api_march/v1/"
// #define BaseURLImage @"http://www.enjoyfresh.com/public/upload/restaurant/dish/"
// #define UserURlImge @"http://www.enjoyfresh.com/public/upload/user/"
// #define BaseURLRestaurant @"http://www.enjoyfresh.com/public/upload/restaurant/"
//
////// server to   qa.enjoyfresh.com

#define BaseURL @"http://qa.enjoyfresh.com/mobile/api/v1/"
//#define BaseURL @"http://www.qa.enjoyfresh.com/mobile/api/v1/"
#define BaseURLImage @"http://qa.enjoyfresh.com/public/upload/restaurant/dish/"
#define UserURlImge @"http://qa.enjoyfresh.com/public/upload/user/"
#define BaseURLRestaurant @"http://qa.enjoyfresh.com/public/upload/restaurant/"

//#define BaseURL @"http://enjoyfresh.rightsource-global.com/mobile/api/v1/"
//#define BaseURLImage @"http:/enjoyfresh.rightsource-global.com/public/upload/restaurant/dish/"
//#define UserURlImge @"http://enjoyfresh.rightsource-global.com/public/upload/user/"
//#define BaseURLRestaurant @"http://enjoyfresh.rightsource-global.com/public/upload/restaurant/"


#define gmail @"outbox@enjoyfresh.com"

#define Bold @"Raleway-Bold"
#define ExtraBold @"Raleway-ExtraBold"
#define ExtraLight @"Raleway-ExtraLight"
#define Light @"Raleway-Light"
#define Medium @"Raleway-Medium"
#define Regular @"Raleway-Regular"
#define SemiBold @"Raleway-SemiBold"

#define FontColor [UIColor colorWithRed:212/255.0f green:56/255.0f blue:49/255.0f alpha:1.0f]

#define green_Color [UIColor colorWithRed:138.0f/255.0f green:188.0f/255.0f blue:105.0f/255.0f alpha:1.0f]
#define red_Color [UIColor colorWithRed:212.0f/255.0f green:56.0f/255.0f blue:49.0f/255.0f alpha:1.0f]

#define Buttonfont 13.0f


//stripe
#define stripeSecretKey @"sk_test_EzC0PEJh58N2KBwMGYA0aSP9"
#define StripePublishableKey @"pk_test_4Xd5w93LQ7du0QhJtUYUbWjL"

//#define stripeSecretKey @"sk_live_NOrokMFEUVjzi97EFhf0gIK0"
//#define StripePublishableKey @"pk_live_2LfWTbUpd3JkRbwofqrSyyrf"

///////////

#define parse_clientId @"CjD8YJ45cBfj62zxnPKUzxF2y4OwE46OFI9PvfAa"
#define parse_AppId @"9LMz0HaEt90V0gLhxjRWow0vSkQid72kKJ70Cb78"
//AZ0VKxBmSM_lhTe2n4UpTAMRhSllw1Vwi51e5ga467YTtmuU3j_NjY7ghUSd

//#define payPal_clientIdForProduction @"AFcWxV21C7fd0v3bYYYRCpSSRl31AtUwmwseqRttHzcKw7txU9F4yf7m"
//#define payPal_clientIdForSandBox @"An5ns1Kso7MWUdW4ErQKJJJ4qi4-A2T0-PDAugz8wcHIUtbFUi6OHw-v"

#define payPal_clientIdForProduction @"AWXVWxB0Pe2k2ClnYPFaL8AFUXoFDtJ8QaQ3melbHa1o6oUxBaK1eSvDbdEi"
#define payPal_clientIdForSandBox @"AdF_rxABX1y6jv17Alpb2zjlYoTbYIc4KHM-cg-VKKfZmWJn23o-kC2xG_pl"

#define dropdownCount 10

#define  homeStr1 @"Connecting food lovers to inspired chefs\n"
#define  homeStr2 @"Explore off-menu items\n"
#define  homeStr3 @"Rethink dining out\n"
#define  homeStr4 @"BECOME AN ENJOY FRESH MEMBER \n"

#endif
