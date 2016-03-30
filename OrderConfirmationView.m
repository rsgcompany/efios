//
//  OrderConfirmationView.m
//  EnjoyFresh
//
//  Created by Siva  on 18/08/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import "OrderConfirmationView.h"
#import "DishesViewController.h"
#import "PaymentViewController.h"

DishesViewController *dishesVc;

@interface OrderConfirmationView ()

@end

PaymentViewController *payView;
@implementation OrderConfirmationView

@synthesize orderDetails,disDetails;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        
//    }
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
     self.lblOrderNo.text=[NSString stringWithFormat:@"%@",[[orderDetails valueForKey:@"details"]valueForKey:@"order_id"]];
    self.lblPrice.text=[NSString stringWithFormat:@"$%@",[[orderDetails valueForKey:@"details"]valueForKey:@"amount"]];
    
    self.view.autoresizesSubviews = NO;

    shareUrl=[[NSString alloc]init];
    
   shareUrl= [orderDetails valueForKey:@"dish_profile_url"];
    
    self.okayBtn.layer.cornerRadius=4.0f;
    NSArray*date=[[[orderDetails valueForKey:@"details"] valueForKey:@"avail_by_date"] componentsSeparatedByString:@"-"];
    
    self.lblHeader.font=[UIFont fontWithName:Regular size:16.0f];
    self.lblSubHead.font=[UIFont fontWithName:SemiBold size:14.0f];
    self.lblOrderText.font=[UIFont fontWithName:Regular size:13.0f];
    
    self.lblOrderText.font=[UIFont fontWithName:Regular size:14.0f];
    self.lblPriceText.font=[UIFont fontWithName:Regular size:14.0f];

    self.lblOrderNo.font=[UIFont fontWithName:Bold size:14.0f];
    self.lblPrice.font=[UIFont fontWithName:Bold size:14.0f];

    self.lblMailText.font=[UIFont fontWithName:Regular size:13.0f];
    appDel.rememberDateFlag=NO;

    NSLog(@"appdel:%@",appDel.dateSelected);
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date1=[format dateFromString:[[orderDetails valueForKey:@"details"] valueForKey:@"avail_by_date"]];
    
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
    
  //  NSString *dateString=[NSString stringWithFormat:@"%@ %@,%@ between %.2ld:%.2ld %@ and %.2ld:%.2ld %@",[weekDay stringFromDate:date1],[calMonth stringFromDate:date1],[date objectAtIndex:2],(long)[[[orderDetails valueForKey:@"details"] valueForKey:@"avail_by_hr"] integerValue],(long)[[[orderDetails valueForKey:@"details"] valueForKey:@"avail_by_min"] integerValue],[[orderDetails valueForKey:@"details"] valueForKey:@"avail_by_ampm"],(long)[[[orderDetails valueForKey:@"details"] valueForKey:@"avail_until_hr"] integerValue],(long)[[[orderDetails valueForKey:@"details"] valueForKey:@"avail_until_min"] integerValue],[[orderDetails valueForKey:@"details"] valueForKey:@"avail_until_ampm"]];
    
    if ([orderDetails valueForKey:@"deliveryAddress"] == nil) {
        self.lblDelTime.hidden=YES;
//        self.lblSubHead.center=CGPointMake(self.lblSubHead.frame.origin.x, self.lblSubHead.frame.origin.y+20);
//        self.lblSubHead.frame=CGRectMake(self.lblSubHead.frame.origin.x, self.lblSubHead.frame.origin.y+20, self.lblSubHead.frame.size.width,self.lblSubHead.frame.size.height);
//        self.lblOrederText.frame=CGRectMake(self.lblOrederText.frame.origin.x, self.lblOrederText.frame.origin.y-20, self.lblOrederText.frame.size.width,self.lblOrederText.frame.size.height);
        
    }
    self.lblOrederText.text=[NSString stringWithFormat:@"Check your email for a confirmation receipt."];
    
    NSDictionary *locDict=[disDetails valueForKey:@"images"];
    id img=[disDetails valueForKey:@"images"];
    if ([img isKindOfClass:[NSArray class]])
    {
        NSArray *art=[disDetails valueForKey:@"images"];
        NSSortDescriptor *hopProfileDescriptor =[[NSSortDescriptor alloc] initWithKey:@"default" ascending:NO];
        
        NSArray *descriptors = [NSArray arrayWithObjects:hopProfileDescriptor, nil];
        NSArray *sortedArrayOfDictionaries = [art
                                              sortedArrayUsingDescriptors:descriptors];
        if ([sortedArrayOfDictionaries count]) {
            locDict=[sortedArrayOfDictionaries objectAtIndex:0];
        }
       
    }
    else
    {
        locDict=[disDetails valueForKey:@"images"];
    }
    
    
    if([ locDict count]!=0)
    {
        NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLImage,[locDict valueForKey:@"path_lg"]];
        [self.dishImage sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"Dish_Placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image==nil){
                self.dishImage.image=[UIImage imageNamed:@"Dish_Placeholder.png"];
            }
            
            else{
                self.dishImage.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(75,75) source:image];
            }
            
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewDidLayoutSubviews{
    
    if ([orderDetails valueForKey:@"deliveryAddress"] == nil) {
        self.lblDelTime.hidden=YES;
        self.lblSubHead.frame=CGRectMake(self.lblSubHead.frame.origin.x, self.lblSubHead.frame.origin.y+5, self.lblSubHead.frame.size.width,self.lblSubHead.frame.size.height);
        self.lblOrederText.frame=CGRectMake(self.lblOrederText.frame.origin.x, self.lblOrederText.frame.origin.y, self.lblOrederText.frame.size.width,self.lblOrederText.frame.size.height);
        
    }
    
}
- (IBAction)orderComplete:(id)sender {
    [self.view removeFromSuperview];
    [appDel.nav popToViewController:appDel.dishesVC animated:YES];}

- (IBAction)sendEmail:(id)sender {
}

- (IBAction)shareOnFB:(id)sender {
}

- (IBAction)shareOnTwitter:(id)sender {
}


-(IBAction)shareBtnsClicked:(id)sender
{    
    switch ([sender tag])
    {
        case 10:
        {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                
                SLComposeViewController *fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                [fbSheetOBJ setInitialText: [disDetails valueForKey:@"title"]];
                [fbSheetOBJ addImage: self.dishImage.image];
                [fbSheetOBJ addURL: [NSURL URLWithString:shareUrl]];

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
                
                [tweetSheetOBJ setInitialText: [disDetails valueForKey:@"title"]];
                [tweetSheetOBJ addImage: self.dishImage.image];
                [tweetSheetOBJ addURL: [NSURL URLWithString:shareUrl]];
                
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
            MFMailComposeViewController *comp=[[MFMailComposeViewController alloc]init];
            [comp setMailComposeDelegate:self];
            if([MFMailComposeViewController canSendMail])
            {
                [comp setSubject:AppTitle];
                NSMutableString *htmlMsg = [NSMutableString string];
                [htmlMsg appendString:@"<html><body><p>"];
                [htmlMsg appendString: @"Hey there! Check out this dish - "];
                [htmlMsg appendString: [disDetails valueForKey:@"title"]];
                [htmlMsg appendString: @", available at "];
                [htmlMsg appendString: [disDetails valueForKey:@"restaurant_title"]];
                [htmlMsg appendString: @"</p> <p>"];
                [htmlMsg appendString: @"About the dish: "];
                [htmlMsg appendString: [disDetails valueForKey:@"description"]];
                [htmlMsg appendString:[NSString stringWithFormat:@"\n%@",shareUrl]];
                [htmlMsg appendString:@" </p></body></html>"];
                
                NSData *jpegData = UIImageJPEGRepresentation(self.dishImage.image, 1);
                
                NSString *fileName = @"EnjoyFreshDish";
                fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
                [comp addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];
                
                [comp setSubject:@"Download the awesome EnjoyFresh app from AppStore!"];
                [comp setMessageBody:htmlMsg isHTML:YES];

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
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result == MFMailComposeResultSent)
    {
        NSLog(@"\n\n Email Sent");
        
    }
    if([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self dismissModalViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
