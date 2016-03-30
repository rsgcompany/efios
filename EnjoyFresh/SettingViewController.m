//
//  SettingViewController.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 10/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "SettingViewController.h"
#import "NotificationViewController.h"
#import "OrderHistory.h"
#import "ProfileViewController.h"
#import "PaymentViewController.h"
#import <Social/Social.h>
#import "GlobalMethods.h"
#import "Global.h"
#import "FavouriteViewController.h"
#import "DishesViewController.h"
#import "FideMeViewController.h"


@interface SettingViewController ()

@end

@implementation SettingViewController

#pragma mark
#pragma mark - UIViewcontroller LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // dropDownBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10); //set as your reqirement
   // dropDownBtn.imageEdgeInsets = UIEdgeInsetsMake(17, 0, 0, 0);

    ProFile_Lbl.font=[UIFont fontWithName:Regular size:14];
    Order_history_lbl.font=[UIFont fontWithName:Regular size:14];
    Payment_lbl.font=[UIFont fontWithName:Regular size:14];
    Notification_lbl.font=[UIFont fontWithName:Regular size:14];
    Favourite_Lbl.font=[UIFont fontWithName:Regular size:14];
    Contact_lbl.font=[UIFont fontWithName:Regular size:14];
    Find_me_Lbl.font=[UIFont fontWithName:Regular size:14];
    Header_Lbl.font=[UIFont fontWithName:Regular size:14];

    spreadLbl.font=[UIFont fontWithName:Regular size:15];
    spreadLbl.text=@"Share EnjoyFresh with your friends and you will both get $5 off your next meal!";

    
    Share.font=[UIFont fontWithName:Regular size:10];
    Tweet_Lbl.font=[UIFont fontWithName:Regular size:10];
    Text_Lbl.font=[UIFont fontWithName:Regular size:10];
    Email_lbl.font=[UIFont fontWithName:Regular size:10];
    
    NSArray *Arr=[[self navigationController]viewControllers];
    if([Arr containsObject:[DishesViewController class]])
    {
//        NSLog(@"Contains Object");
    }
    else
    {
//        NSLog(@"Contains Object");
 
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark - Button Actions

-(IBAction)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)profileBtnClicked:(id)sender
{
//    ProfileViewController *profile=[[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
//    [self.navigationController pushViewController:profile animated:YES];
}
-(IBAction)orderHisotyrBtnClicked:(id)sender
{
//    OrderHistory *orderHtry=[[OrderHistory alloc]initWithNibName:@"OrderHistory" bundle:nil];
//    [self.navigationController pushViewController:orderHtry animated:YES];

}
-(IBAction)paymentBtnClicked:(id)sender
{
    PaymentViewController *paymnt=[[PaymentViewController alloc]initWithNibName:@"PaymentViewController" bundle:nil];
    paymnt.fromCheckOut=NO;
    
    //[self.navigationController pushViewController:paymnt animated:YES];
}
-(IBAction)notificationsBtnClicked:(id)sender
{
//    NotificationViewController *notif=[[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];
//    [self.navigationController pushViewController:notif animated:YES];
}
-(IBAction)favsBtnClicked:(id)sender
{
//    FavouriteViewController *fav=[[FavouriteViewController alloc]initWithNibName:@"FavouriteViewController" bundle:nil];
//    [self.navigationController pushViewController:fav animated:YES];
}
-(IBAction)contactsUsBtnClicked:(id)sender
{
    MFMailComposeViewController *comp=[[MFMailComposeViewController alloc]init];
    [comp setMailComposeDelegate:self];
    if([MFMailComposeViewController canSendMail])
    {
        [comp setToRecipients:[NSArray arrayWithObjects:gmail, nil]];
        [comp setSubject:AppTitle];
        [comp setMessageBody:@"Test Mail " isHTML:NO];
        [comp setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:comp animated:YES completion:nil];
    }
    else{
        [GlobalMethods showAlertwithString:@"Cannot send mail now"];
    }
    
}
-(IBAction)findMeBtnClicked:(id)sender
{
    FideMeViewController *find=[[FideMeViewController alloc]initWithNibName:@"FideMeViewController" bundle:nil];
    [self.navigationController pushViewController:find animated:YES];
    
}
-(IBAction)dropDownBtnClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    
    if(drp==nil)
    {
        [btn setImage:[UIImage imageNamed:@"close_icon_03.png"] forState:UIControlStateNormal];
        drp = [[DropDown alloc] initWithStyle:UITableViewStylePlain];
        [drp.view setFrame:CGRectMake(100, 63, 220, 0)];
        
        drp.delegate = self;
        [self.view addSubview:drp.view];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        
        [drp.view setFrame:[drp dropDownViewFrame]];
        [UIView commitAnimations];
    }
    else
    {
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             [drp.view setFrame:CGRectMake(100, 63, 220, 0)];
                         }
                         completion:^(BOOL finished){
                             [drp.view removeFromSuperview];
                             drp=nil;
                             [btn setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
                             
                         }
         ];
    }
    
}
#pragma mark
#pragma mark - Bottom Buttons
-(IBAction)facebookBtnClicked:(id)sender
{
    NSString *promoCode=[[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"]valueForKey:@"ref_promo"];

    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [fbSheetOBJ setInitialText:[NSString stringWithFormat:@"Explore a marketplace of culinary experiences. Get access to exclusive foodie events and personalized restaurant dining. $5 off your first order.\n"]];
        [fbSheetOBJ addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.enjoyfresh.com/share/signup/%@",promoCode]]];
        [fbSheetOBJ addImage:[UIImage imageNamed:@"ef-logo.png"]];

        [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
    }
    else
    {
        [GlobalMethods showAlertwithString:@"Please log into Facebook share"];
    }
}
-(IBAction)twitterBtnClicked:(id)sender
{
    NSString *promoCode=[[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"]valueForKey:@"ref_promo"];

    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheetOBJ setInitialText:[NSString stringWithFormat:@"Having a blast exploring off menu dishes with EnjoyFresh! Signup and get $5 off your first order.\n"]];
        [tweetSheetOBJ addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.enjoyfresh.com/share/signup/%@",promoCode]]];
        [tweetSheetOBJ addImage:[UIImage imageNamed:@"ef-logo.png"]];

        [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
    }
    else
    {
        [GlobalMethods showAlertwithString:@"Please log into twitter to tweet"];
    }                }
-(IBAction)smsBtnClicked:(id)sender
{
    NSString *promoCode=[[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"]valueForKey:@"ref_promo"];

    if(![MFMessageComposeViewController canSendText])
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[];
    NSString *message = [NSString stringWithFormat:@"Hi there! \n I’ve been having a blast, exploring off menu dishes and culinary events with EnjoyFresh! \n EnjoyFresh connects you to inspired chefs and restaurants in your area. From dive bars to Michelin Stars, you can find amazing meals prepared just for you. Order ahead of time and enjoy at the restaurant, it’s time to go off-menu! \n If you become a member and use this promo code, EnjoyFresh will give you $5 off your first order! \n My invite code: %@ \n\n Happy Dining! ",promoCode];
    
    
            message = [NSString stringWithFormat:@"Have you tried EnjoyFresh? From diver bars to Michelin Stars, you can find exclusive off-menu dishes at your favorite places.\n\n Become a member and use this promo code to get $5 off your first order! http://www.enjoyfresh.com/share/signup/%@", promoCode];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];

}
-(IBAction)mailBtnClicked:(id)sender
{
    NSString *promoCode=[[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"]valueForKey:@"ref_promo"];

    MFMailComposeViewController *comp=[[MFMailComposeViewController alloc]init];
    [comp setMailComposeDelegate:self];
    if([MFMailComposeViewController canSendMail])
    {
        //[comp setToRecipients:[NSArray arrayWithObjects:gmail, nil]];
         [comp setSubject:AppTitle];
        NSString *message = [NSString stringWithFormat:@"Hi there! \n\n I’ve been having a blast, exploring off menu dishes and culinary events with EnjoyFresh! \n\n EnjoyFresh connects you to inspired chefs and restaurants in your area. From dive bars to Michelin Stars, you can find amazing meals prepared just for you. Order ahead of time and enjoy at the restaurant, it’s time to go off-menu! \n\n If you become a member and use this promo code, EnjoyFresh will give you $5 off your first order! \n\n My invite code: %@ \n\n Happy Dining! http://www.enjoyfresh.com/share/signup/%@",promoCode];
        
        message = [NSString stringWithFormat:@"Have you tried EnjoyFresh? From diver bars to Michelin Stars, you can find exclusive off-menu dishes at your favorite places.\n\n Become a member and use this promo code to get $5 off your first order! http://www.enjoyfresh.com/share/signup/%@", promoCode];
        
        [comp setMessageBody:message isHTML:NO];
        [comp setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:comp animated:YES completion:nil];
    }
    else{
        [GlobalMethods showAlertwithString:@"Cannot send mail now"];
    }

 
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
            [GlobalMethods showAlertwithString:@"SMS Sent"];
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
    [drp.view removeFromSuperview];
     drp=nil;
    [dropDownBtn setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
}
-(void)didSelectRowInDropdownTableString:(NSString *)myString atIndexPath:(NSIndexPath *)myIndexPath{
    
    if ([appDel.accessToken length])
    {
        
        if (myIndexPath.row == 0) {
            [self viewDidLoad];
        }else if(myIndexPath.row == 1){
            ////
        }else if (myIndexPath.row == 2){
            [self performSegueWithIdentifier:@"shareSegue" sender:self];
        }else if (myIndexPath.row == 3){
            [self performSegueWithIdentifier:@"OrderHistorySegue" sender:self];
        }else if (myIndexPath.row == 4) {
            [self performSegueWithIdentifier:@"favoriteSegue" sender:self];
        }else if (myIndexPath.row == 5) {
            [self composeMail];
        }else if (myIndexPath.row == 6) {
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