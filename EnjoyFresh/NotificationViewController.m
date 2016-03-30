//
//  NotificationViewController.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 10/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "NotificationViewController.h"
#import "GlobalMethods.h"
#import "Global.h"
#import "NotificationsCell.h"
#import "TableViewNotificationCell.h"
#import "Dish_DetailViewViewController.h"
@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize dishId;


#pragma mark -
#pragma mark - ViewcontrollerLifeCycleMethods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    
    titleLbl.font=[UIFont fontWithName:Regular size:18.0f];
   // dropDwnBtn.imageEdgeInsets = UIEdgeInsetsMake(17, 0, 0, 0);

    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);

   /*
    NSString *urlquerystring=[NSString stringWithFormat:@"getCustomerProfile?accessToken=%@",appDel.accessToken];
    [parser parseAndGetDataForGetMethod:urlquerystring];
    urlquerystring=nil;
    */
    if(!IS_IPHONE5)
    {
        [notificationsTbl setFrame:CGRectMake(0, 64, 320, 415)];
    }
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    
    [self getDetails];
    [notificationsTbl setSeparatorInset:UIEdgeInsetsZero];
}
-(void)getDetails{
    
    NSDictionary *dic=[[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfile"];

    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    
    
    if (hud==nil)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    NSDictionary *params= [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"user_id"],@"userId",appDel.accessToken,@"accessToken",nil];
    [parser parseAndGetDataForPostMethod:params withUlr:@"getAllNotifications"];
    parser.delegate=self;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark - TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notificationArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    TableViewNotificationCell *cell =[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[TableViewNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
     cell.lblText.numberOfLines=0;
    cell.lblTitle.font=[UIFont fontWithName:SemiBold size:15];
    cell.lblText.font=[UIFont fontWithName:Regular size:12];
    cell.lblDate.font=[UIFont fontWithName:SemiBold size:10];
    if ([[[notificationArr objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Review"]) {
        cell.imgNotification.image=[UIImage imageNamed:@"rate"];
    }
    else if([[[notificationArr objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Favorite"]){
        cell.imgNotification.image=[UIImage imageNamed:@"favorite"];

    }
    else if([[[notificationArr objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Promo"]){
        cell.imgNotification.image=[UIImage imageNamed:@"coupon"];
 
    }
    else{
        cell.imgNotification.image=[UIImage imageNamed:@"dish"];
     }
    
    cell.lblTitle.text=[[notificationArr objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.lblText.text=[[notificationArr objectAtIndex:indexPath.row] valueForKey:@"text"];
    NSString *date=[[notificationArr objectAtIndex:indexPath.row] valueForKey:@"created"];
    NSArray *arr=[date componentsSeparatedByString:@" "];
    
    NSString *dateString = @"";
    dateString = [NSString stringWithFormat:@"%@",[arr objectAtIndex:0]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt = [formatter dateFromString:dateString];
    
    [formatter setDateFormat:@"MM/dd/yy"];
    dateString = [formatter stringFromDate:dt];

    cell.lblDate.text=dateString;
    return cell;
}
#pragma mark
#pragma mark - TableView Delegates
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSError *e = nil;
    NSData *data=[[[notificationArr objectAtIndex:indexPath.row] valueForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &e];
    self.dishId=[json valueForKey:@"action"];
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"dish_id = %@",[NSString stringWithFormat:@"%@",self.dishId]];
    dishAvailble=[appDel.dishesVC.dishesCopyArr filteredArrayUsingPredicate:pred];

    if ([[[notificationArr objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Favorite"]) {
        if ([dishAvailble count]) {
            [self performSegueWithIdentifier:@"DishDetailsSegue" sender:self];
        }
        else{
            NSLog(@"Not in dish list.");
        }
    }
    else if([[[notificationArr objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Review"]){
        [self performSegueWithIdentifier:@"OrderHistorySegue" sender:self];
        self.dishId=[json valueForKey:@"action"];
    }
}
#pragma mark
#pragma mark - Button Actions
-(IBAction)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)dropDownBtnClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    
    if(drp==nil)
    {
        
        [btn setImage:[UIImage imageNamed:@"close_icon_03.png"] forState:UIControlStateNormal];
        drp = [[DropDown alloc] initWithStyle:UITableViewStylePlain];
        imgView=[[UIView alloc ]initWithFrame:CGRectMake(0, 63,320, self.view.frame.size.height)];
        
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

#pragma mark
#pragma mark - ParseAndGetData Delegates
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    BOOL errMsg=[[result valueForKey:@"error"]boolValue];
    if(errMsg){
        [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
        [hud hide:YES];
        [hud removeFromSuperview];
        hud=nil;
    }
    else
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

        notificationArr=[[NSArray alloc]init];
        notificationArr=[result valueForKey:@"notifications"];
        notificationsTbl.delegate=self;
        notificationsTbl.dataSource=self;
        
        [notificationsTbl reloadData];
        
        [hud hide:YES];
        [hud removeFromSuperview];
        hud=nil;
    }
}
-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    [hud hide:YES];
    [hud removeFromSuperview];
    hud=nil;
    [GlobalMethods showAlertwithString:err];
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
            [self performSegueWithIdentifier:@"ProfileSegue" sender:self];
        }else if(myIndexPath.row == 1){
            [self performSegueWithIdentifier:@"PaymentSegue" sender:self];
        }else if(myIndexPath.row == 2){
           // [self performSegueWithIdentifier:@"NotificationSegue" sender:self];
        }else if (myIndexPath.row == 3){
            [self performSegueWithIdentifier:@"ShareSegue" sender:self];
        }else if (myIndexPath.row == 4){
            [self performSegueWithIdentifier:@"orderHistorySegue1" sender:self];
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
    [comp setMailComposeDelegate:(id)self];
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
#pragma mark -
#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([segue.identifier isEqualToString:@"DishDetailsSegue"]) {
        Dish_DetailViewViewController *controller = ([segue.destinationViewController isKindOfClass:[Dish_DetailViewViewController class]]) ? segue.destinationViewController : nil;

        controller.Dish_Details_dic=[dishAvailble objectAtIndex:0];

    }if ([segue.identifier isEqualToString:@"OrderHistorySegue"]) {
            OrderHistory *controller = ([segue.destinationViewController isKindOfClass:[OrderHistory class]]) ? segue.destinationViewController : nil;
            controller.dishId=self.dishId;
            controller.fromNotif=YES;
        
    }
}

@end