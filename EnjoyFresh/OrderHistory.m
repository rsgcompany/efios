//
//  OrderHistory.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 10/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "OrderHistory.h"
#import "GlobalMethods.h"
#import "Global.h"
#import "NotificationsCell.h"
#import "OderHistoryDetail.h"
@interface OrderHistory ()

@end

@implementation OrderHistory
#pragma mark -
#pragma mark - ViewcontrollerLifeCycleMethods
- (void)viewDidLoad
{
    [super viewDidLoad];
    viewDidLoad = YES;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // Do any additional setup after loading the view from its nib.
    pastOrdersArray=[[NSMutableArray alloc]init];
    latestOrdersArray=[[NSMutableArray alloc]init];

    titleLbl.font=[UIFont fontWithName:Regular size:18.0f];
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);

    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    //dropDwnBtn.imageEdgeInsets = UIEdgeInsetsMake(17, 0, 0, 0);

    [orderTbl setSeparatorInset:UIEdgeInsetsZero];
    
    //API call for order history
    //appDel.subm
    NSString *urlquerystring=[NSString stringWithFormat:@"getCustomerProfile?accessToken=%@",appDel.accessToken];
    [parser parseAndGetDataForGetMethod:urlquerystring];
    [self.activity startAnimating];
    urlquerystring=nil;

    
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [UIFont fontWithName:Regular size:13], NSFontAttributeName,
//                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
//    self.segmentCtrl.tintColor = [UIColor colorWithRed: 144/255.0 green:186/255.0 blue:118/255.0 alpha:1.0];
//    
//    [self.segmentCtrl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    if(!IS_IPHONE5)
    {
        [orderTbl setFrame:CGRectMake(0, 64, 320, 415)];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //API call for order history
    if (appDel.reviewSubmit==YES) {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];

        pastOrdersArray=nil;
        latestOrdersArray=nil;
        pastOrdersArray=[[NSMutableArray alloc]init];
        latestOrdersArray=[[NSMutableArray alloc]init];
        parser.delegate=self;

        NSString *urlquerystring=[NSString stringWithFormat:@"getCustomerProfile?accessToken=%@",appDel.accessToken];
        [parser parseAndGetDataForGetMethod:urlquerystring];
        self.activity.hidden=NO;
        [self.activity startAnimating];
        urlquerystring=nil;
        appDel.reviewSubmit=NO;
    }
   
   
}

- (void) viewDidAppear:(BOOL)animated
{
//    if(!viewDidLoad)
//    {
//        NSString *urlquerystring=[NSString stringWithFormat:@"getCustomerProfile?accessToken=%@",appDel.accessToken];
//        [parser parseAndGetDataForGetMethod:urlquerystring];
//        urlquerystring=nil;
//    }
//    
//    viewDidLoad = NO;
    
    //mixpanel api call
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"View My Orders Page_iOSMobile" properties:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidLayoutSubviews
{
    if ([orderTbl respondsToSelector:@selector(setSeparatorInset:)]) {
        [orderTbl setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([orderTbl respondsToSelector:@selector(setLayoutMargins:)]) {
        [orderTbl setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark
#pragma mark - TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ordersArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"OrderHistoryCell";
    
    NotificationsCell *cell = (NotificationsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    /*if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }*/
    cell.titleLbl.text=[NSString stringWithFormat:@"%@",[[ordersArr objectAtIndex:indexPath.row]valueForKey:@"dish_title"]];
    
    cell.lblLoc.text=[NSString stringWithFormat:@"%@",[[ordersArr objectAtIndex:indexPath.row]valueForKey:@"restaurant_city"]];
   
    
    NSString *dateString = @"";
            dateString = [NSString stringWithFormat:@"%@", [[ordersArr objectAtIndex:indexPath.row] valueForKey:@"date_added"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dt = [formatter dateFromString:dateString];
        
        [formatter setDateFormat:@"MM/dd/yy"];
        dateString = [formatter stringFromDate:dt];
   
    
    cell.location.text=  dateString;
    
    cell.detailLbl.text=[NSString stringWithFormat:@"%@",[[ordersArr objectAtIndex:indexPath.row]valueForKey:@"restaurant_name"]];
   //   NSString *str=[NSString stringWithFormat:@"%@",[[[ordersArr objectAtIndex:indexPath.row] valueForKey:@"date_added"] substringToIndex:10]];
    
    cell.dateLbl.text=dateString;
    cell.roundImg.layer.masksToBounds=YES;
    id obj = [[ordersArr objectAtIndex:indexPath.row] valueForKey:@"images"];
    
    id img=[[ordersArr objectAtIndex:indexPath.row] valueForKey:@"images"];
    NSDictionary *locDict;
    if ([img isKindOfClass:[NSArray class]])
    {
        NSArray *art=[[ordersArr objectAtIndex:indexPath.row] valueForKey:@"images"];
        NSSortDescriptor *hopProfileDescriptor =[[NSSortDescriptor alloc] initWithKey:@"default"
                                                                            ascending:NO];
        
        NSArray *descriptors = [NSArray arrayWithObjects:hopProfileDescriptor, nil];
        NSArray *sortedArrayOfDictionaries = [art sortedArrayUsingDescriptors:descriptors];
       
        if ([sortedArrayOfDictionaries count]) {
            locDict=[sortedArrayOfDictionaries objectAtIndex:0];
        }
        
    }
    else
    {
        locDict=[[ordersArr objectAtIndex:indexPath.row] valueForKey:@"images"];
    }
    

    if (obj != [NSNull null]) {

        NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLImage,[locDict valueForKey:@"path_lg"]];
        [cell.roundImg sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"nf_placeholder_restaurant"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image==nil) {
                cell.roundImg.image=[UIImage imageNamed:@"nf_placeholder_restaurant"];
            }else
            cell.roundImg.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(80,80) source:image];
        }];
    }

    [cell.favBtn setHidden:YES];
    [cell.arrows setHidden:NO];
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
    [self performSegueWithIdentifier:@"OrderDetailsSgegue" sender:indexPath];
    
  //  [self performSelector:@selector(reloaddata123) withObject:nil afterDelay:1.0f];
  
}

#pragma mark -
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OrderDetailsSgegue"]) {
        if (self.fromNotif) {
            OderHistoryDetail *controller = ([segue.destinationViewController isKindOfClass:[OderHistoryDetail class]]) ? segue.destinationViewController : nil;
            
            NSPredicate *pred=[NSPredicate predicateWithFormat:@"order_id = %@",[NSString stringWithFormat:@"%@",self.dishId]];
            NSArray *dishAvailble=[copyOrdersArr filteredArrayUsingPredicate:pred];
            controller.Orderdetails_dict=[dishAvailble objectAtIndex:0];
            self.fromNotif=NO;
        }
        else{
            OderHistoryDetail *controller = ([segue.destinationViewController isKindOfClass:[OderHistoryDetail class]]) ? segue.destinationViewController : nil;
            NSIndexPath *indexPath = (NSIndexPath *)sender;//[orderTbl indexPathForSelectedRow];
            
            controller.Orderdetails_dict=[ordersArr objectAtIndex:indexPath.row];
        }
        
    }
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
#pragma mark
#pragma mark - ParseAndGetData Delegates
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    NSLog(@"Order History Result: %@", result);
    //[self.activity stopAnimating];
    BOOL errMsg=[[result valueForKey:@"error"]boolValue];
    if(errMsg)
        [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
    else
    {
        copyOrdersArr=[[NSArray alloc]init];
        ordersArr=[result valueForKey:@"ordeHistory"];
         User_id=[NSString stringWithFormat:@"%@",[[result valueForKey:@"profile"] valueForKey:@"user_id"]];
        appDel.orderHistroy_count=[ordersArr count];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date_added" ascending:NO];
        ordersArr = [ordersArr sortedArrayUsingDescriptors:@[sortDescriptor]];
        copyOrdersArr=ordersArr;
        
        for (int i=0; i<ordersArr.count; i++) {
            if ([[[ordersArr objectAtIndex:i] valueForKey:@"past_order"] intValue] == 1) {
                [pastOrdersArray addObject:[ordersArr objectAtIndex:i]];
            }
            else{
                [latestOrdersArray addObject:[ordersArr objectAtIndex:i]];
            }
        }
        orderTbl.delegate=self;
        orderTbl.dataSource=self;
        ordersArr=latestOrdersArray;
        self.segmentCtrl.selectedSegmentIndex=0;
        [orderTbl reloadData];
        [self.activity stopAnimating];
        [self.activity setHidden:YES];
        if (self.fromNotif) {
            [self performSegueWithIdentifier:@"OrderDetailsSgegue" sender:self];
        }
    }
}
-(void)dataDidFailedLoadingWithError:(NSString *)err
{
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
            [self performSegueWithIdentifier:@"NotificationSegue" sender:self];
        }else if (myIndexPath.row == 3){
            [self performSegueWithIdentifier:@"ShareSegue" sender:self];
        }else if (myIndexPath.row == 4){
            //[self performSegueWithIdentifier:@"OrderHistorySegue" sender:self];
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
        }        [self removeDropdown];
        
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

- (IBAction)selectedActionSegment:(id)sender {
    
    if (self.segmentCtrl.selectedSegmentIndex==0) {
        ordersArr=latestOrdersArray;
        [orderTbl reloadData];
    }
    else{
        ordersArr=pastOrdersArray;
        [orderTbl reloadData];
    }
}
@end