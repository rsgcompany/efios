//
//  ProfileViewController.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 10/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "ProfileViewController.h"
#import "GlobalMethods.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingViewController.h"
#import  "FavouriteViewController.h"
#import "NotificationViewController.h"
#import "JSON.h"
//#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "UIImageView+WebCache.h"

#define FIELDS_COUNT  7

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize imgData, dict;
#pragma mark -
#pragma mark - ViewcontrollerLifeCycleMethods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [imgLoadActivity startAnimating];
    
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
   // dropDwnBtn.imageEdgeInsets = UIEdgeInsetsMake(17, 0, 0, 0);
    
    
    parseInt=1;
    NSString *urlquerystring=[NSString stringWithFormat:@"getCustomerProfile?accessToken=%@",appDel.accessToken];
    [parser parseAndGetDataForGetMethod:urlquerystring];
    //
   // urlquerystring=nil;
    
    updateBtn.titleLabel.font=[UIFont fontWithName:ExtraLight size:Buttonfont];
    updateBtn.layer.cornerRadius=3.0f;
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);

    profileImg.layer.cornerRadius=36.0f;
    profileImg.layer.borderWidth=1.0f;
    profileImg.layer.masksToBounds=YES;
    profileImg.layer.borderColor=[UIColor clearColor].CGColor;
    
    
//    firstNameFld=[GlobalMethods setPlaceholdText:@"Your first name" forTxtFld:firstNameFld];
//    mobileFld=[GlobalMethods setPlaceholdText:@"Your mobile" forTxtFld:mobileFld];
//    emailFld=[GlobalMethods setPlaceholdText:@"Your email" forTxtFld:emailFld];
//    lastNameFld=[GlobalMethods setPlaceholdText:@"Your last name" forTxtFld:lastNameFld];
//    zipFLd=[GlobalMethods setPlaceholdText:@"Your zipcode" forTxtFld:zipFLd];
    
    firstNameFld.font=[UIFont fontWithName:Regular size:14];
    mobileFld.font=[UIFont fontWithName:Regular size:14];
    emailFld.font=[UIFont fontWithName:Regular size:14];
    lastNameFld.font=[UIFont fontWithName:Regular size:14];
    zipFLd.font=[UIFont fontWithName:Regular size:14];

    titleLbl.font=[UIFont fontWithName:Regular size:18.0f];
    userNmeLbl.font=[UIFont fontWithName:Bold size:14.0f];
    emailLbl.font=[UIFont fontWithName:Regular size:13.0f];
    
    NSDictionary*profileDict=[[NSUserDefaults standardUserDefaults ]valueForKey:@"UserProfile"];
    
    if ([profileDict isKindOfClass:[NSDictionary class]])
    {
        //NSLog(@"profile info: %@", profileDict);
//        appDel.CurrentCustomerDetails.user_email = [profileDict valueForKey:@"email"];
//        appDel.CurrentCustomerDetails.user_email user_pic [profileDict valueForKey:@"email"];
//        appDel.CurrentCustomerDetails.user_first_name = [profileDict valueForKey:@"first_name"];
//        appDel.CurrentCustomerDetails.user_last_name =[profileDict valueForKey:@"last_name"];
//        appDel.CurrentCustomerDetails.user_mobile = [profileDict valueForKey:@"mobile"];
//        appDel.CurrentCustomerDetails.user_password = [profileDict valueForKey:@"password"];
//        appDel.CurrentCustomerDetails.user_zipcode = [profileDict valueForKey:@"zipcode"];
        
        txtPassword.text=[profileDict valueForKey:@"password"];
        userNmeLbl.text=[NSString stringWithFormat:@"%@ %@",
                         [profileDict valueForKey:@"first_name"],[profileDict valueForKey:@"last_name"]];
        zipFLd.text=[profileDict valueForKey:@"zipcode"];
        
        //NSLog(@"Zip Code : %@", appDel.CurrentCustomerDetails.user_image);
        
        emailFld.text = appDel.CurrentCustomerDetails.user_email;
        emailLbl.text = appDel.CurrentCustomerDetails.user_email;
        firstNameFld.text = appDel.CurrentCustomerDetails.user_first_name;
        lastNameFld.text = appDel.CurrentCustomerDetails.user_last_name;
        mobileFld.text = [profileDict valueForKey:@"mobile"];
        
        if(appDel.CurrentCustomerDetails.user_password.length > 1)
        {
            txtPassword.text = appDel.CurrentCustomerDetails.user_password;
        }
        else
        {
            
        }
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        //id img=[profileDict valueForKey:@"image"];
        if (appDel.CurrentCustomerDetails.user_image.length > 1)
        {
            NSString *disturlStr=[NSString stringWithFormat:@"%@%@",UserURlImge,
                                  appDel.CurrentCustomerDetails.user_image];
            
            [profileImg sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:
             [UIImage imageNamed:@"user_pic.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
               
                 profileImg.image = nil;
                 NSLog(@"Profile Image URL: %@", imageURL);
                 CGSize size = CGSizeMake(72, 72);
                 if (image==nil) {
                     profileImg.image = [UIImage imageNamed:@"user_pic.png"];
                     [imgLoadActivity stopAnimating];
                     [imgLoadActivity hidesWhenStopped];

                 }else{
                     UIImage *croppedImage = [GlobalMethods imageByScalingAndCroppingForSize:size source:image];
                     profileImg.image = croppedImage;
                     [imgLoadActivity stopAnimating];
                 }
             }];
        }
        else{
            [imgLoadActivity stopAnimating];
            [imgLoadActivity hidesWhenStopped];
        }
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//            {
//                
//                NSURL *photoURL = [NSURL URLWithString:disturlStr];
//                NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
//                UIImage *image = [UIImage imageWithData:photoData];
//                CGSize size = CGSizeMake(72, 72);
//                
//                if (image==nil) {
//                    profileImg.image = [UIImage imageNamed:@"Dish_Placeholder"];
//                    
//                }else{
//                    UIImage *croppedImage = [GlobalMethods imageByScalingAndCroppingForSize:size source:image];
//                    profileImg.image = croppedImage;
//                }
//                
//            });
//            
//        }

        NSLog(@"User Image %@", appDel.CurrentCustomerDetails.user_image);
        
        userNmeLbl.text = [NSString stringWithFormat:@"%@ %@",
                         appDel.CurrentCustomerDetails.user_first_name,
                         appDel.CurrentCustomerDetails.user_last_name];
        zipFLd.text = appDel.CurrentCustomerDetails.user_zipcode;
    }
    else
    {
        if(hud==nil)
        {
            hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            hud.delegate = self;
            [hud show:YES];
            [self.view addSubview:hud];
        }

        [parser parseAndGetDataForGetMethod:urlquerystring];
    }
    
    profileImg.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *profilePic =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePicTapAction:)];
    [profilePic setNumberOfTapsRequired:1];
    
    [profileImg addGestureRecognizer:profilePic];
    
//    self.imgData=[[NSUserDefaults standardUserDefaults]valueForKey:@"ImageData"];
//    if (self.imgData==nil)
//    {
//        self.imgData=[[NSData alloc]init];
//    }
  //////////////key next prev and done Buttons
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
    [mobileFld setInputAccessoryView:toolbar];
    [emailFld setInputAccessoryView:toolbar];
    [zipFLd setInputAccessoryView:toolbar];
    [txtPassword setInputAccessoryView:toolbar];
    [lastNameFld setInputAccessoryView:toolbar];
    
//    [imgLoadActivity stopAnimating];
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)profilePicTapAction:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:AppTitle
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Take Photo", @"Use Gallery", nil];
    [actionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if  (buttonIndex == 0) {
        
    }
    else if(buttonIndex == 1)
    {
        if([UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
    else
    {
        if([UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary])
        {
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
        
    }
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    CGSize size = CGSizeMake(500, 500);
    UIImage *croppedImage = [GlobalMethods imageByScalingAndCroppingForSize:size source:image];
    self.imgData= UIImageJPEGRepresentation(croppedImage, 0.5);
    profileImg.image = croppedImage;
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)getCustomerProfile
{
    
   parseInt=3;
   NSString *urlquerystring=[NSString stringWithFormat:@"getCustomerProfile?accessToken=%@",appDel.accessToken];
   [parser parseAndGetDataForGetMethod:urlquerystring];
    urlquerystring=nil;
}
#pragma mark
#pragma mark - TextField Delgates
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSUInteger tag = [textField tag];
    [self animateView:tag];
    [self checkBarButton:tag];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
    if([string isEqualToString:@" "]){
        // Returning no here to restrict whitespace
        return NO;
    }
    if (textField == firstNameFld || textField == lastNameFld) {
        return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
    }
    if(textField==mobileFld)
    {
        if (textField.text.length >= 10 && range.length == 0)
            return NO;
    }
    else if(textField==zipFLd)
    {
        if (textField.text.length >= 5 && range.length == 0)
            return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark
#pragma mark - Button Actions
-(IBAction)dropDownBtnClicked:(id)sender
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
-(IBAction)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)updateBtnclicked:(id)sender
{
    if([firstNameFld.text length])
    {
        if([lastNameFld.text length])
        {
            if([emailFld.text length])
            {
                if(![txtPassword.text length])
                {
                    [GlobalMethods showAlertwithString:@"Please enter your Password"];
                    return;
                }
                if ([txtPassword.text length]>=8) {
                    
                    if([mobileFld.text length])
                    {
                        if([mobileFld.text length]<10)
                        {
                            [GlobalMethods showAlertwithString:@"Please enter valid phone number"];
                            return;
                        }
                        if([zipFLd.text length])
                        {
                            if([zipFLd.text length]==5)
                            {
                                if([GlobalMethods isItValidEmail:emailFld.text])
                                {
                                    if(hud==nil)
                                    {
                                        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                                        hud.delegate = self;
                                        [hud show:YES];
                                        [self.view addSubview:hud];
                                    }
                                    parseInt=2;
                                    
                                    NSLog(@"Password: %@", txtPassword.text);
                                    
                                    NSString *Str=[self.imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                                    NSDictionary *parameters=
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     appDel.accessToken,@"accessToken",
                                     firstNameFld.text,@"firstname",
                                     lastNameFld.text,@"lastname",
                                     emailFld.text,@"email",
                                     txtPassword.text, @"password",
                                     mobileFld.text,@"mobile",
                                     zipFLd.text,@"zipcode",
                                     @".jpeg",@"imageExt",
                                     Str,@"profileImage", nil];
                                    
                                    dict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfile"] mutableCopy];
                                    
                                    
                                    [dict setValue:firstNameFld.text forKey:@"first_name"];
                                    [dict setValue:lastNameFld.text forKey:@"last_name"];
                                    [dict setValue:emailFld.text forKey:@"email"];
                                    [dict setValue:txtPassword.text forKey:@"password"];
                                    [dict setValue:zipFLd.text forKey:@"zipcode"];
                                    [dict setValue:mobileFld.text forKey:@"mobile"];
                                    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserProfile"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    NSLog(@"Parameters: %@", parameters);
                                    [parser parseAndGetDataForPostMethod:parameters withUlr:@"editCustomerProfile"];
                                }
                                else
                                    [GlobalMethods showAlertwithString:@"Please enter a valid Email"];
                            }
                            else
                                [GlobalMethods showAlertwithString:@"Please enter a valid Zipcode"];
                        }
                        else
                            [GlobalMethods showAlertwithString:@"Please enter your Zipcode"];
                    }
                    else
                        [GlobalMethods showAlertwithString:@"Please enter mobile number"];

                }
                else
                    [GlobalMethods showAlertwithString:@"The password should be at least 8 characters."];

            }
            else
                [GlobalMethods showAlertwithString:@"Please enter your Email"];
        }
        else
            [GlobalMethods showAlertwithString:@"Please enter your Last name"];
    }
    else
        [GlobalMethods showAlertwithString:@"Please enter your First name"];
}
#pragma mark
#pragma mark - ParseAndGetData Delegates
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    NSLog(@"Profile View Result: %@", result);
    
    BOOL errMsg=[[result valueForKey:@"error"]boolValue];
    if(errMsg)
    {
        [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
        [hud hide:YES];
        [hud removeFromSuperview];
        hud=nil;
    }
    else
    {
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache clearMemory];
        [imageCache clearDisk];
        
        appDel.IsProcessComplete = YES;
        
        
     if(parseInt==1)
     {
        NSMutableDictionary *profileDict=[[NSMutableDictionary alloc]initWithDictionary:[result valueForKey:@"profile"]];
         
         //NSArray * favcount=[[result  valueForKey:@"favorites"] valueForKey:@"dish_id"];
        
         NSDictionary *dict=[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"];
         [profileDict setObject:[dict valueForKey:@"password"] forKey:@"password"];
         for (NSString * key in [dict allKeys])
         {
             if ([[profileDict objectForKey:key] isKindOfClass:[NSNull class]])
                 [profileDict setObject:@"" forKey:key];
         }
         appDel.orderHistroy_count=[[result  valueForKey:@"ordeHistory"] count];

         id obj = [profileDict objectForKey:@"image"];
         if (obj == [NSNull null]) {
             [profileDict setObject:@"" forKey:@"image"];
         }
         
        [[NSUserDefaults standardUserDefaults] setObject:profileDict forKey:@"UserProfile"];
        // [[NSUserDefaults standardUserDefaults] setObject:favcount forKey:@"FAVCount"];

        [[NSUserDefaults standardUserDefaults ] synchronize];
         

         if([[profileDict valueForKey:@"image"] length])
         {
             appDel.CurrentCustomerDetails.user_image = [profileDict valueForKey:@"image"] ;
             NSString *disturlStr=[NSString stringWithFormat:@"%@%@",UserURlImge,[profileDict valueForKey:@"image"]];
             [[SDImageCache sharedImageCache] removeImageForKey:disturlStr fromDisk:YES];

             [profileImg sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"user_pic.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
              {
                 
                 CGSize size = CGSizeMake(500, 500);
                 UIImage *croppedImage = [GlobalMethods imageByScalingAndCroppingForSize:size source:image];
                 self.imgData= UIImageJPEGRepresentation(croppedImage, 0.5);
                 profileImg.image = croppedImage;
                  [imgLoadActivity startAnimating];
                  [imgLoadActivity hidesWhenStopped];
                  imgLoadActivity.hidden=YES;
             }];
         }

        
        emailFld.text=[profileDict valueForKey:@"email"];
        emailLbl.text=[profileDict valueForKey:@"email"];
        firstNameFld.text=[profileDict valueForKey:@"first_name"];
        lastNameFld.text=[profileDict valueForKey:@"last_name"];
        mobileFld.text=[profileDict valueForKey:@"mobile"];
        userNmeLbl.text=[NSString stringWithFormat:@"%@ %@",[profileDict valueForKey:@"first_name"],[profileDict valueForKey:@"last_name"]];
         zipFLd.text=[profileDict valueForKey:@"zipcode"];
         
         appDel.CurrentCustomerDetails.user_zipcode = zipFLd.text;
         appDel.CurrentCustomerDetails.user_password = txtPassword.text;
         appDel.CurrentCustomerDetails.user_email = emailFld.text;
         appDel.CurrentCustomerDetails.user_first_name = firstNameFld.text;
         appDel.CurrentCustomerDetails.user_last_name = lastNameFld.text;
         appDel.CurrentCustomerDetails.user_mobile = mobileFld.text;
         
         userNmeLbl.text = [NSString stringWithFormat:@"%@ %@",
                            appDel.CurrentCustomerDetails.user_first_name,
                            appDel.CurrentCustomerDetails.user_last_name];

        [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
        
        profileDict=nil;
         [hud hide:YES];
         [hud removeFromSuperview];
         hud=nil;
     }
    else if(parseInt==2)
    {
        appDel.profileUpdated = YES;
        
        dict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfile"] mutableCopy];
        
        
        [dict setValue:firstNameFld.text forKey:@"first_name"];
        [dict setValue:lastNameFld.text forKey:@"last_name"];
        [dict setValue:emailFld.text forKey:@"email"];
        [dict setValue:txtPassword.text forKey:@"password"];
        [dict setValue:zipFLd.text forKey:@"zipcode"];
        
        
        appDel.CurrentCustomerDetails.user_zipcode = zipFLd.text;
        appDel.CurrentCustomerDetails.user_password = txtPassword.text;
        appDel.CurrentCustomerDetails.user_email = emailFld.text;
        appDel.CurrentCustomerDetails.user_first_name = firstNameFld.text;
        appDel.CurrentCustomerDetails.user_last_name = lastNameFld.text;
        
        userNmeLbl.text = [NSString stringWithFormat:@"%@ %@",
                           appDel.CurrentCustomerDetails.user_first_name,
                           appDel.CurrentCustomerDetails.user_last_name];
        
        [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
        
        NSUserDefaults *tUD = [NSUserDefaults standardUserDefaults];
        [tUD setObject:dict forKey:@"UserProfile"];
        [tUD synchronize];
        
//        NSDictionary *Credict=[[NSUserDefaults standardUserDefaults]valueForKey:@"credentials"];
//        [Credict setValue:emailFld.text forKey:@"Email"];
//        [Credict setValue:txtPassword.text forKey:@"Password"];
        
        [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
        imgLoadActivity.hidden=YES;
        
        [hud hide:YES];
        [hud removeFromSuperview];
        hud=nil;
        
        //[self getCustomerProfile];
    }
        else if(parseInt==3)
        {
            NSMutableDictionary *profileDict=[[NSMutableDictionary alloc]initWithDictionary:[result valueForKey:@"profile"]];
            
            //NSArray * favcount=[[result  valueForKey:@"favorites"] valueForKey:@"dish_id"];
            NSDictionary *dict=[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"];
            
            NSString *NewZip=[NSString stringWithFormat:@"%@",[profileDict valueForKey:@"zipcode"]];
            NSString *OLDZip=[NSString stringWithFormat:@"%@",[dict valueForKey:@"zipcode"]];

            [profileDict setObject:[dict valueForKey:@"password"] forKey:@"password"];
            if (![NewZip isEqualToString:OLDZip]) {
                appDel.profileChanged=YES;
            }
            
            
            for (NSString * key in [dict allKeys])
            {
                if ([[profileDict objectForKey:key] isKindOfClass:[NSNull class]])
                    [profileDict setObject:@"" forKey:key];
            }
            appDel.orderHistroy_count=[[result  valueForKey:@"ordeHistory"] count];
            
            id obj = [profileDict objectForKey:@"image"];
            if (obj == [NSNull null]) {
                [profileDict setObject:@"" forKey:@"image"];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:profileDict forKey:@"UserProfile"];
            //[[NSUserDefaults standardUserDefaults] setObject:favcount forKey:@"FAVCount"];
            
            appDel.CurrentCustomerDetails.user_zipcode = zipFLd.text;
            appDel.CurrentCustomerDetails.user_password = txtPassword.text;
            appDel.CurrentCustomerDetails.user_email = emailFld.text;
            appDel.CurrentCustomerDetails.user_first_name = firstNameFld.text;
            appDel.CurrentCustomerDetails.user_last_name = lastNameFld.text;
            appDel.CurrentCustomerDetails.user_mobile=mobileFld.text;
            userNmeLbl.text = [NSString stringWithFormat:@"%@ %@",
                               appDel.CurrentCustomerDetails.user_first_name,
                               appDel.CurrentCustomerDetails.user_last_name];
            
            [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
            
            [[NSUserDefaults standardUserDefaults ] synchronize];
            profileDict=nil;
            
            
            [hud hide:YES];
            [hud removeFromSuperview];
            hud=nil;
        }
        
    }
    
}
-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    [GlobalMethods showAlertwithString:err];
    [hud hide:YES];
    [hud removeFromSuperview];
    hud=nil;
}

#pragma mark
#pragma mark - HUD Delegtes
- (void)hudWasHidden:(MBProgressHUD *)huda {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	hud = nil;
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
        if (tag > 3)
            [scroll setContentOffset:CGPointMake(0, 47.0f * (tag - 3)) animated:YES];
        else
            [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
        if (tag > 0)
            [scroll setContentOffset:CGPointMake(0, 55.0f * (tag - 0)) animated:YES];
        else
            [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
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
           // [self performSegueWithIdentifier:@"ProfileSegue" sender:self];
        }else if(myIndexPath.row == 1){
            [self performSegueWithIdentifier:@"PaymentSegue" sender:self];
        }else if(myIndexPath.row == 2){
            [self performSegueWithIdentifier:@"NotificationSegue" sender:self];
        }else if (myIndexPath.row == 3){
            [self performSegueWithIdentifier:@"ShareSegue" sender:self];
        }else if (myIndexPath.row == 4){
            [self performSegueWithIdentifier:@"OrderHistorySegue" sender:self];
        }else if (myIndexPath.row == 5) {
            [self performSegueWithIdentifier:@"FavoriteSegue" sender:self];
        }else if (myIndexPath.row == 6) {
            [self composeMail];
        }else if (myIndexPath.row == 7) {
            [self performSegueWithIdentifier:@"HowItWorks" sender:self];
        }else if (myIndexPath.row == 8) {
            [self performSegueWithIdentifier:@"FAQSegue" sender:self];
        }else if (myIndexPath.row == 9) {
            [self performSegueWithIdentifier:@"AboutSegue" sender:self];
        }
        else if (myIndexPath.row == 10) {
            [self goToSignInViewLogout];
        }
        [self removeDropdown];
        
    }
}

-(void)goToSignInViewLogout{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserProfile"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [appDel.objDBClass ClearUserFavoritesTable];
    [appDel.objDBClass ClearUserProfileDetails];
    [appDel.objDBClass ClearCardDetails];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
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
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self removeDropdown];
            
        }
    }
    else {
        if (buttonIndex==1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
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

@end