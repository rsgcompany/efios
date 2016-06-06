//
//  ShareViewController.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 29/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "ShareViewController.h"
#import "Global.h"
#import "GlobalMethods.h"
#import <Social/Social.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    Share.font=[UIFont fontWithName:Regular size:10];
    Tweet_Lbl.font=[UIFont fontWithName:Regular size:10];
    Text_Lbl.font=[UIFont fontWithName:Regular size:10];
    Email_lbl.font=[UIFont fontWithName:Regular size:10];
    
    titlelbl.font=[UIFont fontWithName:Regular size:16];
    offterLbl.font=[UIFont fontWithName:Regular size:15];
    helpUsLbl.font=[UIFont fontWithName:SemiBold size:15];
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);

    //dropDownBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);

    if(!IS_IPHONE5){
        
        [scrollview setContentSize:CGSizeMake(scrollview.frame.size.width, 560)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)shareBtnsClicked:(id)sender
{
    NSString *promoCode=[[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"]valueForKey:@"ref_promo"];
    NSURL *url;
    if (promoCode==NULL) {
        promoCode=@"";
        url=[NSURL URLWithString:@"http://www.enjoyfresh.com"];
    }
    else{
        url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.enjoyfresh.com/signup/%@",promoCode]];
    }

    switch ([sender tag])
    {
        case 10:
        {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                SLComposeViewController *fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                //[fbSheetOBJ setInitialText:[NSString stringWithFormat:@"Explore a marketplace of culinary experiences. Get access to exclusive foodie events and personalized restaurant dining. $5 off your first order.\n"]];
                [fbSheetOBJ setInitialText:[NSString stringWithFormat:@"Enjoy fresh, amazing and unique food prepared to order by the best local chefs.  $5 off your first order.  Delivery available.\n"]];

                [fbSheetOBJ addURL:url];
                [fbSheetOBJ addImage:[UIImage imageNamed:@"ef-logo.png"]];
                [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
            }
            else
            {
                [GlobalMethods showAlertwithString:@"You're not logged in to Facebook. Go to Device Settings > Facebook > Sign In"];
            }
        }
            break;
        case 20:
        {
                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
                {
                    SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                              composeViewControllerForServiceType:SLServiceTypeTwitter];
                   // [tweetSheetOBJ setInitialText:[NSString stringWithFormat:@"Having a blast exploring off menu dishes with EnjoyFresh! Signup & get $5 off on first order."]];
                    [tweetSheetOBJ setInitialText:[NSString stringWithFormat:@"I just discovered @Enjoy_Fresh! Amazing freshly prepared #food by local chefs with $5 off your first order."]];

                    
                    [tweetSheetOBJ addURL:url];

                    [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
                }
                else
                {
                    [GlobalMethods showAlertwithString:
                     @"You're not logged in to Twitter. Go to Device Settings > Twitter > Sign In"];
                }                
        }
            break;
        case 30:
        {
            if(![MFMessageComposeViewController canSendText])
            {
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [warningAlert show];
                return;
            }
            
            NSArray *recipents = @[];
            @try {
                NSString *message =[[NSString alloc] init]; //[NSString stringWithFormat:@"Hi there! \n I’ve been having a blast, exploring off menu dishes and culinary events with EnjoyFresh! \n EnjoyFresh connects you to inspired chefs and restaurants in your area. From dive bars to Michelin Stars, you can find amazing meals prepared just for you. Order ahead of time and enjoy at the restaurant, it’s time to go off-menu! \n If you become a member and use this promo code, EnjoyFresh will give you $5 off your first order! \n My invite code: %@ \n\n Happy Dining! http://www.enjoyfresh.com/share/signup/%@",promoCode];
                
                message = [NSString stringWithFormat:@"Having a blast exploring off menu dishes with EnjoyFresh! Signup & get $5 off on first order. %@", url];
                //message = [NSString stringWithFormat:@"Give EnjoyFresh a try and get $5 off your first order!. %@", url];

                
                MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
                messageController.messageComposeDelegate = self;
                [messageController setRecipients:recipents];
                [messageController setBody:message];
                [self presentViewController:messageController animated:YES completion:nil];

            }
            @catch (NSException *exception) {
                NSLog(@"exception:%@",exception);
            }
            
            
            
            // Present message view controller on screen
        }
            break;
        case 40:
        {
            MFMailComposeViewController *comp=[[MFMailComposeViewController alloc]init];
            [comp setMailComposeDelegate:self];
            if([MFMailComposeViewController canSendMail])
            {
                //[comp setToRecipients:nil];
                [comp setSubject:AppTitle];
                NSString *message = [NSString stringWithFormat:@"Hi there! \n\n I’ve been having a blast, exploring off menu dishes and culinary events with EnjoyFresh! \n\n EnjoyFresh connects you to inspired chefs and restaurants in your area. From dive bars to Michelin Stars, you can find amazing meals prepared just for you. Order ahead of time and enjoy at the restaurant, it’s time to go off-menu! \n\n If you become a member and use this promo code, EnjoyFresh will give you $5 off your first order! \n\n My invite code: %@ \n\n Happy Dining! ",promoCode];
                
                
               // message = [NSString stringWithFormat:@"Have you tried EnjoyFresh? From dive bars to Michelin Stars, you can find exclusive off-menu dishes at your favorite places.\n\n Become a member and use this promo code to get $5 off your first order! %@", url];
                message = [NSString stringWithFormat:@"Give EnjoyFresh a try and get $5 off your first order! %@", url];


                [comp setMessageBody:message isHTML:NO];
                [comp setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                [self presentViewController:comp animated:YES completion:nil];
            }
            else{
                [GlobalMethods showAlertwithString:@"Cannot send mail now"];
            }
        }
            break;
        default:
            break;
    }
}
    
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

-(IBAction)copyShareURL:(id)sender{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = shareURLTextField.text;
}
#pragma mark -
#pragma mark - Message Composer Delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
        {
            [GlobalMethods showAlertwithString:@"Text Cancelled"];
            break;
        }
        case MessageComposeResultFailed:
        {
            [GlobalMethods showAlertwithString:@"Failed to send sms"];
            break;
        }
        case MessageComposeResultSent:
        {
            [GlobalMethods showAlertwithString:@"Text Sent"];
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark
#pragma mark - DropDown Delegtes
-(void)removeDropdown
{
    [imgView removeFromSuperview];

    [drp.view removeFromSuperview];
    drp=nil;
    [dropDownBtn setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
}

-(void)didSelectRowInDropdownTableString:(NSString *)myString atIndexPath:(NSIndexPath *)myIndexPath{
    
    if ([appDel.accessToken length])
    {
        
        if (myIndexPath.row == 0) {
            [self performSegueWithIdentifier:@"ProfileSegue" sender:self];
        }else if(myIndexPath.row == 1){
            [self performSegueWithIdentifier:@"PaymentSegue" sender:self];
        }else if(myIndexPath.row == 2){
            [self performSegueWithIdentifier:@"NotificationSegue" sender:self];
        }else if (myIndexPath.row == 3){
           // [self performSegueWithIdentifier:@"ShareSegue" sender:self];
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
        }else if (myIndexPath.row == 10) {
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
                //[self performSegueWithIdentifier:@"ShareSegue" sender:self];
                
            }
                break;
            case 6:
            {
                [self composeMail];
                
            }
                break;
            case 9:
            {
                [self performSegueWithIdentifier:@"AboutSegue" sender:self];
                
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
            case 10:
            {
                //[self.navigationController popToRootViewControllerAnimated:YES];
                [self performSegueWithIdentifier:@"LoginSegue" sender:self];

                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserProfile"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                [appDel.objDBClass ClearUserFavoritesTable];
                [appDel.objDBClass ClearUserProfileDetails];
                [appDel.objDBClass ClearCardDetails];
                
            }
                break;
                
            default:
                break;
        }
        if(!(myIndexPath.row==0||myIndexPath.row==3||myIndexPath.row==4||myIndexPath.row==1))
            [self removeDropdown];
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
           // [self.navigationController popToRootViewControllerAnimated:YES];
            [self performSegueWithIdentifier:@"LoginSegue" sender:self];

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
