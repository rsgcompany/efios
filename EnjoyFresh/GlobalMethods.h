//
//  GlobalMethods.h
//  EnjoyFresh
//
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalMethods : NSObject
+(NSString*)getNibname:(NSString*)nibStr;
+(BOOL)isItValidEmail:(NSString *)checkString;
+(void)showAlertwithString:(NSString*)msg;
+(NSString*)getUDIDOfdevice;
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize source:(UIImage*)sourceImages;
+(UITextField*)setPlaceholdText:(NSString*)str forTxtFld:(UITextField*)txtFld;
+(UIViewController*)checkNavigationexits:(Class )viewcontroller navigation:(UINavigationController*)navigation;
+ (NSString*)base64forData:(NSData*)theData;
+(NSDictionary*)barbuttonFont;
+(BOOL)checkWhiteSpace:(NSString *)myString;

@end
