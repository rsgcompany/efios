//
//  OderHistoryDetail.m
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 26/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "OderHistoryDetail.h"
#import "Global.h"
@interface OderHistoryDetail ()

@end
UIColor *Star_selected,*Star_Unselected;

@implementation OderHistoryDetail
@synthesize Orderdetails_dict;
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
    
    Star_selected=[UIColor colorWithRed:239/255.f green:194/255.f blue:74/255.f alpha:1.0];
    Star_Unselected=[UIColor lightGrayColor];
   // drop_downBtn.imageEdgeInsets = UIEdgeInsetsMake(17, 0, 0, 0);
    scroll.delegate=self;
    if(!IS_IPHONE5)
    {
        [scroll setFrame:CGRectMake(0, 150, 320, 415)];
    }
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);

    [Star1 setTitleColor:Star_Unselected forState:UIControlStateNormal];
    [star2 setTitleColor:Star_Unselected forState:UIControlStateNormal];
    [Star3 setTitleColor:Star_Unselected forState:UIControlStateNormal];
    [Star4 setTitleColor:Star_Unselected forState:UIControlStateNormal];
    [Star5 setTitleColor:Star_Unselected forState:UIControlStateNormal];
    Hearder.font=[UIFont fontWithName:Regular size:16];
    
    UIFont *regular=[UIFont fontWithName:SemiBold size:12];
    dish_name.font=[UIFont fontWithName:Bold size:12];
    total_paid.font=[UIFont fontWithName:Bold size:22];
    UIFont *bold=[UIFont fontWithName:Bold size:13];
    self.lblAvlDate.font=[UIFont fontWithName:Regular size:12];
    Oder_quantity.font=regular;
    dish_restaurent.font=regular;
    Location.font=regular;
    Order_id.font=regular;
    Dish_amount.font=regular;
    dish_discount_applied.font=regular;
    dish_discount_amount.font=regular;
    payment_mode_label.font=bold;
    payment_mode_value.font=regular;
    Actual_amount_paid.font=regular;
    Review_text.font=regular;
    Location.font=regular;
    
    discount_amt_left.font=bold;
    quantity_left.font=bold;
    amount_paid_left.font=bold;
    Actaul_dish_amt_left.font=bold;
    OrderId_left.font=bold;
    discount_applied_left.font=bold;
    tax_amount.font=regular;
    tax_left.font=bold;
    order_date_label.font=bold;
    order_date_value.font=regular;
    
    User_rating.font=[UIFont fontWithName:SemiBold size:14];
    RateANDReview_left.font=[UIFont fontWithName:Bold size:14];

    
    order_again_btn.layer.cornerRadius=3.0f;
    Submit_Btn.layer.cornerRadius=3.0f;
    order_again_btn.titleLabel.font=[UIFont fontWithName:Regular size:12];
    Submit_Btn.titleLabel.font=[UIFont fontWithName:Regular size:12];
    Delete_ReviewBtn.titleLabel.font=[UIFont fontWithName:Regular size:12];
    seeMoreReviewsBtn.titleLabel.font=[UIFont fontWithName:Regular size:12];

    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard:)];
    [scroll addGestureRecognizer:letterTapRecognizer];
    letterTapRecognizer.delegate=self;
    
    NSArray  *date=[[Orderdetails_dict valueForKey:@"avail_by_date"] componentsSeparatedByString:@"-"];
    
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date1=[format dateFromString:[Orderdetails_dict valueForKey:@"avail_by_date"]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:date1];
    NSInteger year = [components year];
    NSInteger month=[components month];       // if necessary
    NSInteger day = [components day];
    NSInteger weekday = [components weekday]; // if necessary
    
    NSDateFormatter *weekDay = [[NSDateFormatter alloc] init];
    [weekDay setDateFormat:@"EEEE"];
    
    NSDateFormatter *calMonth = [[NSDateFormatter alloc] init];
    [calMonth setDateFormat:@"MMM"];
    
    NSString *dateString1=[NSString stringWithFormat:@"%@ %@,%@ @ %.2ld:%.2ld %@ - %.2ld:%.2ld %@",[weekDay stringFromDate:date1],[calMonth stringFromDate:date1],[date objectAtIndex:2],(long)[[Orderdetails_dict valueForKey:@"avail_by_hr"] integerValue],(long)[[Orderdetails_dict valueForKey:@"avail_by_min"] integerValue],[Orderdetails_dict valueForKey:@"avail_by_ampm"],(long)[[Orderdetails_dict valueForKey:@"avail_till_hr"] integerValue],(long)[[Orderdetails_dict valueForKey:@"avail_till_min"] integerValue],[Orderdetails_dict valueForKey:@"avail_till_ampm"]];
    

    self.lblAvlDate.text=dateString1;
  //  NSLog(@"-------\n%@",Orderdetails_dict);
    
    float price=[[Orderdetails_dict valueForKey:@"unit_price"] floatValue];
    //price=(price*0.20)+price;
    
    Dish_amount.text=[NSString stringWithFormat:@"$ %.2f",price];

    NSArray *dateTime = [[NSString stringWithFormat:@"%@",
                          [Orderdetails_dict valueForKey:@"date_added"]]
                         componentsSeparatedByString:@" "];

    NSString *dateString = @"";
   
 
        dateString = [NSString stringWithFormat:@"%@", dateTime[0]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dt = [formatter dateFromString:dateString];
        
        [formatter setDateFormat:@"MM/dd/yyyy"];
        dateString = [formatter stringFromDate:dt];
   
    
    
    order_date_value.text= dateString;
    dish_name.text=[NSString stringWithFormat:@"%@",[Orderdetails_dict valueForKey:@"dish_title"]];
    dish_restaurent.text=[NSString stringWithFormat:@"%@",[Orderdetails_dict valueForKey:@"restaurant_name"]];
    Location.text=[NSString stringWithFormat:@"%@,%@,%@",[Orderdetails_dict valueForKey:@"restaurant_address"],[Orderdetails_dict valueForKey:@"restaurant_city"],[Orderdetails_dict valueForKey:@"restaurant_state"]];
    total_paid.text=[NSString stringWithFormat:@"$ %@",[Orderdetails_dict valueForKey:@"amoutn_paid"]];
    Actual_amount_paid.text=[NSString stringWithFormat:@"$ %@",[Orderdetails_dict valueForKey:@"amoutn_paid"]];
    Order_id.text=[NSString stringWithFormat:@"%@",[Orderdetails_dict valueForKey:@"order_id"]];

    NSString *payMode = [NSString stringWithFormat:@"%@", [Orderdetails_dict valueForKey:@"payment_method"]];
    
    if([payMode isEqualToString:@"cc"])
    {
        payment_mode_value.text = @"Credit Card";
        
        [payment_mode_label setHidden: NO];
        [payment_mode_value setHidden: NO];
    }
    else if([payMode isEqualToString:@"express_checkout"])
    {
        payment_mode_value.text = @"PayPal";
        
        [payment_mode_label setHidden: NO];
        [payment_mode_value setHidden: NO];
    }
    else
    {
        [payment_mode_label setHidden: YES];
        [payment_mode_value setHidden: YES];
    }

    if ([[Orderdetails_dict valueForKey:@"soldout"] integerValue] == 1) {
        
        [order_again_btn setTitle:@"SOLD OUT" forState:UIControlStateNormal];
        order_again_btn.backgroundColor=[UIColor colorWithRed:(211/255.0) green:(118/255.0) blue:(100/255.0) alpha:1];
        order_again_btn.userInteractionEnabled=NO;
    }
    
    if ([[Orderdetails_dict valueForKey:@"can_review"] integerValue] == 0) {
        
        Review_text.userInteractionEnabled=NO;
        Submit_Btn.userInteractionEnabled=NO;
        Submit_Btn.hidden=YES;
        Review_text.hidden=YES;
        Star1.hidden=YES;
        star2.hidden=YES;
        Star3.hidden=YES;
        Star4.hidden=YES;
        Star5.hidden=YES;
        RateANDReview_left.hidden=YES;
    }
    else{
        Review_text.userInteractionEnabled=YES;
        Submit_Btn.userInteractionEnabled=YES;
        RateANDReview_left.hidden=NO;

    }
    
    NSDictionary *profile=[[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfile"];
    
    _userid=[profile valueForKey:@"user_id"];
    
    Oder_quantity.text=[NSString stringWithFormat:@"%@",[Orderdetails_dict valueForKey:@"qty"]];
    dish_discount_amount.text=[NSString stringWithFormat:@"%@",[Orderdetails_dict valueForKey:@"discount-paid"]];
    
    tax_amount.text=[NSString stringWithFormat:@"%@",[Orderdetails_dict valueForKey:@"sales_tax"]];
    if ([dish_discount_amount.text isEqualToString:@"0"]
        || ![dish_discount_amount.text length]
        || [dish_discount_amount.text floatValue] == 0)
    {
        //dish_discount_amount.text=@"0.0";
        [dish_discount_amount setHidden: YES];
        [discount_amt_left setHidden: YES];
    }
    id objRev=[Orderdetails_dict valueForKey:@"reviews"];

    if ([objRev isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:[Orderdetails_dict valueForKey:@"reviews"]];
        [dict removeObjectForKey:@"dish_rating"];
        
        NSPredicate *pred=[NSPredicate predicateWithFormat:@"user_id = %d ",_userid.integerValue];
        all_review=[dict allValues];
       // [RateANDReview_left setHidden:NO];
        NSArray *ar=[all_review filteredArrayUsingPredicate:pred];
        
        if ([ar count]) {
            Review_text.text=[[ar objectAtIndex:0] valueForKey:@"review"];
            self.reviewid=[[ar objectAtIndex:0] valueForKey:@"review_id"];
            
            Review_text.editable=YES;
//            [RateANDReview_left setHidden:YES];
           // [User_rating setHidden:NO];
            [Delete_ReviewBtn setHidden:NO];
            [self setRating:self rate:[[ar objectAtIndex:0] valueForKey:@"rating"]];
           // User_rating.text=[NSString stringWithFormat:@"Rated : %@/5 ",[[Orderdetails_dict valueForKey:@"reviews"] valueForKey:@"dish_rating"]];
            
        }
    }
    
   // Do any additional setup after loading the view from its nib.
    
    dish_img.layer.cornerRadius=35.0f;
    dish_img.layer.masksToBounds=YES;
    id obj = [Orderdetails_dict valueForKey:@"images"];
    
    id img=[Orderdetails_dict valueForKey:@"images"];
    NSDictionary *locDict;
    if ([img isKindOfClass:[NSArray class]])
    {
//        NSArray *art=[Orderdetails_dict valueForKey:@"images"];
//        if ([art count]) {
//            locDict=[art objectAtIndex:0];
//        }
        
        NSArray *art=[Orderdetails_dict valueForKey:@"images"];
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
        locDict=[Orderdetails_dict valueForKey:@"images"];
    }
    
    if (obj != [NSNull null]) {
        
        NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLImage,[locDict valueForKey:@"path_lg"]];
        [dish_img sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"Dish_Placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image==nil) {
                dish_img.image=[UIImage imageNamed:@"Dish_Placeholder.png"];
            }else
                dish_img.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(80,80) source:image];
            
        }];
    }

    
  [scroll setContentSize:CGSizeMake(0, 568)];
    
 //   [self.view sendSubviewToBack:scroll];
    if ([UIDevice currentDevice ].systemVersion.floatValue<7.0) {
        CGRect frame=scroll.frame;
        frame.size.height=self.view.frame.size.height-144;
        frame.origin.y=144;
        
        scroll.frame=frame;
    }
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    
//    NSString *dishId=[NSString stringWithFormat:@"%@",[Orderdetails_dict valueForKey:@"dish_id"]];
//    if([[NSUserDefaults standardUserDefaults] valueForKey:dishId] != nil){
//       Review_text.text=[[NSUserDefaults standardUserDefaults] valueForKey:dishId];
//    }
   //
   // NSArray *arr=appDel.dishesVC.dishesCopyArr;
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"dish_id = %@",[NSString stringWithFormat:@"%@",[Orderdetails_dict valueForKey:@"dish_id"]]];
     dishAvailble=[appDel.dishesVC.dishesCopyArr filteredArrayUsingPredicate:pred];
    
    [Star1 setTitleColor:Star_selected forState:UIControlStateNormal];
    [star2 setTitleColor:Star_selected forState:UIControlStateNormal];
    [Star3 setTitleColor:Star_selected forState:UIControlStateNormal];
    [Star4 setTitleColor:Star_selected forState:UIControlStateNormal];
    [Star5 setTitleColor:Star_selected forState:UIControlStateNormal];

    if (![dishAvailble count]) {
//        NSLog(@" no availble");
        
    }
    
    //Setting default rating to 5
    dish_Rating = 5;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)didReceiveMemoryWarning
{
   // [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

-(void)resignKeyboard:(id)sender{
    [Review_text resignFirstResponder];
}
#pragma mark Button Actions

- (IBAction)Back_btn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)Star_btn_clicked:(id)sender
{
    [self.view endEditing:YES];
    if ([[Orderdetails_dict valueForKey:@"can_review"] integerValue] == 0) {
        
    }
    else{
        UIButton *btn=(UIButton*)[self.view viewWithTag:[sender tag]];
        for (int i=0; i < 5; i++)
        {
            UIButton *btn12=(UIButton*)[self.view viewWithTag:i+1];
            if (i<btn.tag)
            {
                [btn12 setTitleColor:Star_selected forState:UIControlStateNormal];
                dish_Rating=i+1;
            }
            else
            {
                [btn12 setTitleColor:Star_Unselected forState:UIControlStateNormal];
            }
        }
    }
}

-(void)setRating:(id)sender rate:(NSString *)rating{
    
    RateANDReview_left.text=@"Rated";
    int rate=(int)[rating integerValue];
    for (int i=0; i < 5; i++)
    {
        UIButton *btn12=(UIButton*)[self.view viewWithTag:i+1];
        if (i<rate)
        {
            [btn12 setTitleColor:Star_selected forState:UIControlStateNormal];
           // dish_Rating=i+1;
        }
        else
        {
            [btn12 setTitleColor:Star_Unselected forState:UIControlStateNormal];
        }
    }
 
}

- (IBAction)order_btn_clicked:(id)sender
{
    [self.view endEditing:YES];
    [Review_text resignFirstResponder];

//    if (![dishAvailble count]) {
//        [GlobalMethods showAlertwithString:@"Dish is not available"];
//        return;
//    }
    addTOBag=nil;
    
    addTOBag=[[AddedToBag alloc]init];
    addTOBag.Item_details=[[dishAvailble objectAtIndex:0] copy];
    
    CGRect rec=addTOBag.view.frame;
    rec.origin.y=-600;
    addTOBag.view.frame=rec;
    [self.view addSubview:addTOBag.view];
    
    
    rec.origin.y=0;
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    addTOBag.view.frame=rec;
    [UIView commitAnimations];
    
}

- (IBAction)ropDownBtnClicked:(id)sender {
    [Review_text resignFirstResponder];
    
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

#pragma mark UITextView Delegates

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    
    CGRect frame=scroll.frame;
    frame.size.height=frame.size.height-200;
    scroll.frame=frame;
    CGPoint bottomOffset = CGPointMake(0, scroll.contentSize.height - scroll.bounds.size.height);
    [scroll setContentOffset:bottomOffset animated:YES];
    
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    CGRect frame=scroll.frame;
    frame.size.height=frame.size.height+200;
    scroll.frame=frame;

    return YES;
    
}

#pragma mark
#pragma mark - ParseAndGetData Delegates
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    if(result == nil)
    {
        [GlobalMethods showAlertwithString: @"Unable to add/delete review now. Please try again, later."];
    }
    
    BOOL errMsg=[[result valueForKey:@"error"]boolValue];
    if(errMsg)
        [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
    else
    {
        if(parseint==1)
        {
        [GlobalMethods showAlertwithString:[result valueForKey:@"reviews"]];
        }
        else
        {
        [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
        }
        appDel.reviewSubmit=YES;
        appDel.reviewSubmit1=YES;
        [self Back_btn:nil];
    }
	[hud hide:YES];
    [hud removeFromSuperview];
    hud=nil;
}
-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    [hud hide:YES];
    [hud removeFromSuperview];
    hud=nil;
    [GlobalMethods showAlertwithString:err];
}
#pragma mark - Rate & Review SubmitBtn
- (IBAction)Submit_Btn_Clicked:(id)sender
{
    [self.view endEditing:YES];
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.delegate = self;
    [hud show:YES];
    [self.view addSubview:hud];
    parseint=1;
    
    if(dish_Rating < 2)
    {
        dish_Rating = 2;
    }
    NSUserDefaults *dishReview=[NSUserDefaults standardUserDefaults];
    [dishReview setObject:Review_text.text forKey:[NSString stringWithFormat:@"%@",[Orderdetails_dict valueForKey:@"dish_id"]]];
    [dishReview synchronize];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken,@"accessToken",[Orderdetails_dict valueForKey:@"dish_id"],@"dishId",[NSString stringWithFormat:@"%d",dish_Rating],@"rating",[NSString stringWithFormat:@"%li",(long)self.reviewid.integerValue ],@"review_id",[NSString stringWithFormat:@"%@",Review_text.text],@"review",nil];
    [parser parseAndGetDataForPostMethod:params withUlr:@"submitReview"];
    params=nil;
}
- (IBAction)deleteBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.delegate = self;
    [hud show:YES];
    [self.view addSubview:hud];
    parseint=2;

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken,@"accessToken",[Orderdetails_dict valueForKey:@"dish_id"],@"dishId", nil];
    [parser parseAndGetDataForPostMethod:params withUlr:@"deleteReview"];
    params=nil;
}
#pragma mark
#pragma mark - DropDown Delegtes
-(void)removeDropdown
{
    [imgView removeFromSuperview];

    [self.view endEditing:YES];
    
    [drp.view removeFromSuperview];
    drp=nil;
    [drop_downBtn setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
    
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

#pragma mark
#pragma mark - HUD Delegtes
- (void)hudWasHidden:(MBProgressHUD *)huda {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	hud = nil;
}
@end
