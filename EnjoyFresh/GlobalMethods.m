//
//  GlobalMethods.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "GlobalMethods.h"
#import "Global.h"

@implementation GlobalMethods

+(UIViewController*)checkNavigationexits:(Class )viewcontroller navigation:(UINavigationController*)navigation;
{
    NSArray *arrayOfControllers=navigation.viewControllers;
    
    for (UIViewController *vc in arrayOfControllers) {
        
        if ([vc isKindOfClass:viewcontroller]) {
            return vc;
            break;
        }
    }
    return nil;
}
+(NSString*)getNibname:(NSString*)nibStr
{
    if (!IS_IPHONE5)
        nibStr=[NSString stringWithFormat:@"%@_iPhone4",nibStr];
    return nibStr;
}
+(BOOL)isItValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
+(void)showAlertwithString:(NSString*)msg
{
    [[[UIAlertView alloc]initWithTitle:AppTitle message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil]show];
}
+(NSString*)getUDIDOfdevice
{
    NSString * devicetok = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return [devicetok stringByReplacingOccurrencesOfString:@"-" withString:@""];
#if TARGET_IPHONE_SIMULATOR
    NSString * devicetoken = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return [devicetoken stringByReplacingOccurrencesOfString:@"-" withString:@""];
#else
    // Device
    if([appDel.parse_ObjectId length])
    {
        NSString * devicetoken = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        return [devicetoken stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    return appDel.parse_ObjectId;
#endif
}
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize source:(UIImage*)sourceImages
{
	UIImage *sourceImage = sourceImages;
	UIImage *newImage = nil;
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO)
	{
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor > heightFactor)
			scaleFactor = widthFactor; // scale to fit height
        else
			scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
        if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		}
        else
			if (widthFactor < heightFactor)
			{
				thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
	}
	
	UIGraphicsBeginImageContext(targetSize); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil)
        NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}
+(UITextField*)setPlaceholdText:(NSString*)str forTxtFld:(UITextField*)txtFld
{
    if ([txtFld respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:212/255.0f green:56/255.0f blue:49/255.0f alpha:1.0f];
        txtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    [txtFld setFont:[UIFont fontWithName:Regular size:16.0f]];
    
    txtFld.clearButtonMode = UITextFieldViewModeWhileEditing;
    return txtFld;
}
#pragma mark -
#pragma mark - Base64Conversion
+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
+(BOOL)checkWhiteSpace:(NSString *)myString{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [myString stringByTrimmingCharactersInSet:charSet];
    if ([trimmedString isEqualToString:@""]) {
        // it's empty or contains only white spaces
        return YES;
    }
    else{
        return NO;
    }
}

+(NSDictionary*)barbuttonFont
{
return  @{NSFontAttributeName:[UIFont fontWithName:Regular size:16.0f]};
}
@end
