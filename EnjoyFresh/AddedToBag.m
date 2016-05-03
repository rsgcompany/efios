//
//  AddedToBag.m
//  EnjoyFresh
// sdkfjlksjdfl;ksdajfl sdklskdjf;lsdkjfl;sdkjflksdf
//  Created by Mohnish vardhan on 19/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "AddedToBag.h"
#import "Global.h"
#import "GlobalMethods.h"

BOOL promoFlag=NO;
long qty=1;
long percent;
NSString *promotype;
float dollars;
long count=nil;
int height;
@interface AddedToBag ()
@property(nonatomic)NSArray *tipsArray;
@end

@implementation AddedToBag

NSMutableDictionary *dict=nil;

@synthesize Item_details,addressView,addrssArray,deliveryAdd,addressDict,datesTable,addressId,selectedState,arrayDate,selectedIndx;

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
    promotype=[[NSString alloc]init];
    promoFlag=NO;
    UIFont *sub=[UIFont fontWithName:Regular size:13];
    Hearder_lbl.font=[UIFont fontWithName:Regular size:18.0f];
    Dish_Type.font=sub;
    Ingredient.font=sub;
    Chef_Name.font=sub;
    Availability.font=sub;
    Price_lbl.font=[UIFont fontWithName:Bold size:17.0f];
    AvileOfferPromo.font=[UIFont fontWithName:SemiBold size:15.0f];
    
    self.lbldate1.font=[UIFont fontWithName:SemiBold size:11.50f];
    self.lblDate.font=[UIFont fontWithName:SemiBold size:12.0f];

    Quantity.font=[UIFont fontWithName:Regular size:15.0f];
    
    datesArray=[[NSMutableArray alloc] init];

    AddToBag_Btn.layer.cornerRadius=3.f;
    Cancel_Btn.layer.cornerRadius=3.0f;
    OrderNowBtn.layer.cornerRadius=3.0f;
    self.cancelBtn.layer.cornerRadius=3.0f;
    
    Dish_Name.font=[UIFont fontWithName:Bold size:16.0f];
    //getting location latitude and longitude
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self updateCurrentLocation];

    //    Quantity.layer.borderWidth=1.0f;
    //    Quantity.layer.masksToBounds=YES;
    //    Quantity.layer.cornerRadius=40;
    //    Quantity.layer.borderColor=[UIColor grayColor].CGColor;
    //
    //    Quantity_Minus_Btn.layer.cornerRadius=15;
    //    Quantity_Plus_Btn.layer.cornerRadius=15;
    
    Dishimage.layer.cornerRadius=75/2;
    Dishimage.layer.masksToBounds=YES;
    dishImage2.layer.cornerRadius=75/2;
    dishImage2.layer.masksToBounds=YES;
    
    AddToBag_Btn.titleLabel.font=[UIFont fontWithName:Bold size:15.0f];
    self.apply_btn.titleLabel.font=[UIFont fontWithName:Bold size:13.0f];
    self.cancelBtn.titleLabel.font=[UIFont fontWithName:Bold size:15.0f];
    self.btnTips.titleLabel.font=[UIFont fontWithName:Bold size:13.0f];

    
    Refer_Btn.titleLabel.font=[UIFont fontWithName:Medium size:12];
    First_Btn.titleLabel.font=[UIFont fontWithName:Medium size:12];
    none_btn.titleLabel.font=[UIFont fontWithName:Medium size:12];
    self.promoCodeBtn.titleLabel.font=[UIFont fontWithName:Medium size:12];
    self.remainLbl.font=[UIFont fontWithName:Medium size:12];
    AvileOfferPromo.font=[UIFont fontWithName:Bold size:16.0f];
    self.btnAddnewAddr.titleLabel.font=[UIFont fontWithName:SemiBold size:10];
    tipLabel.font=[UIFont fontWithName:Bold size:15.0f];

    splPromo_btn.titleLabel.font=[UIFont fontWithName:Medium size:12];
    credit_btn.titleLabel.font=[UIFont fontWithName:Medium size:12];
    
    self.txtAddrs.font=[UIFont fontWithName:SemiBold size:11];

    authNet_btn.titleLabel.font=[UIFont fontWithName:Medium size:14];
    payPal_btn.titleLabel.font=[UIFont fontWithName:Medium size:14];
    
    
    qty_available=[(NSString*)Item_details valueForKey:@"qty"];

    
    Chef_Name.text=[NSString stringWithFormat:@"%@",[[Item_details valueForKey:@"restaurant_details"]valueForKey:@"restaurant_title"]];
    price=[[Item_details valueForKey:@"price"] floatValue];
    if (price*0.20 > 5) {
        price=price+5;
    }
    else{
     price=(price*0.20)+price;
    }
    
    Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",price];
    Dish_Name.text=[NSString stringWithFormat:@"%@",[Item_details valueForKey:@"dish_title"]];
    
    Quantity.text=@"01";//[NSString stringWithFormat:@"01/%@",qty_available];
    
    NSArray*date=[[Item_details valueForKey:@"avail_by_date"] componentsSeparatedByString:@"-"];
    
    dishLocation_Order.text=[NSString stringWithFormat:@"%@, %@,\n%@  %@",[[Item_details valueForKey:@"restaurant_details"] valueForKey:@"restaurant_address"],[[Item_details valueForKey:@"restaurant_details"] valueForKey:@"restaurant_city"],[[Item_details valueForKey:@"restaurant_details"] valueForKey:@"restaurant_state"],[[Item_details valueForKey:@"restaurant_details"] valueForKey:@"restaurant_zip"]];
    self.lblbAddress.text=[NSString stringWithFormat:@"%@, %@,\n%@  %@",[[Item_details valueForKey:@"restaurant_details"] valueForKey:@"restaurant_address"],[[Item_details valueForKey:@"restaurant_details"] valueForKey:@"restaurant_city"],[[Item_details valueForKey:@"restaurant_details"] valueForKey:@"restaurant_state"],[[Item_details valueForKey:@"restaurant_details"] valueForKey:@"restaurant_zip"]];

    
    self.zipcodePopupView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.btnPopCancel.layer.borderWidth=1.0f;
    self.btnPopCancel.layer.borderColor=[UIColor colorWithRed:211/255.0f green:118/255.0f blue:100/255 alpha:1].CGColor;
    self.btnPopCancel.layer.cornerRadius=2.f;
     self.btnPopSubmit.layer.cornerRadius=2.f;


   // NSArray*date=[[Item_details valueForKey:@"avail_by_date"] componentsSeparatedByString:@"-"];
    
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date1=[format dateFromString:[Item_details valueForKey:@"avail_by_date"]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:date1];
    
    NSInteger year = [components year];
    NSInteger month=[components month];       // if necessary
    NSInteger day = [components day];
    NSInteger weekday = [components weekday]; // if necessary
    
    NSDateFormatter *weekDay = [[NSDateFormatter alloc] init];
    [weekDay setDateFormat:@"EEE"];
    
    NSDateFormatter *calMonth = [[NSDateFormatter alloc] init];
    [calMonth setDateFormat:@"MMM"];
   
    arrayDate=[Item_details valueForKey:@"future_available_dates"];
 
    NSString *dateString;
    if ([self.pageFlag  isEqual: @"yes"]) {
        dateString =[NSString stringWithFormat:@"%@ %@,%@ @ %.2ld:%.2ld %@ - %.2ld:%.2ld %@",[weekDay stringFromDate:date1],[calMonth stringFromDate:date1],[date objectAtIndex:2],(long)[[Item_details valueForKey:@"avail_by_hr"] integerValue],(long)[[Item_details valueForKey:@"avail_by_min"] integerValue],[Item_details valueForKey:@"avail_by_ampm"],(long)[[Item_details valueForKey:@"avail_until_hr"] integerValue],(long)[[Item_details valueForKey:@"avail_until_min"] integerValue],[Item_details valueForKey:@"avail_until_ampm"]];
    }
    else{
     dateString =[NSString stringWithFormat:@"%@ %@,%@ @ %.2ld:%.2ld %@ - %.2ld:%.2ld %@",[weekDay stringFromDate:date1],[calMonth stringFromDate:date1],[date objectAtIndex:2],(long)[[Item_details valueForKey:@"avail_by_hr"] integerValue],(long)[[Item_details valueForKey:@"avail_by_min"] integerValue],[Item_details valueForKey:@"avail_by_ampm"],(long)[[Item_details valueForKey:@"avail_by_hr_till"] integerValue],(long)[[Item_details valueForKey:@"avail_by_min_till"] integerValue],[Item_details valueForKey:@"avail_by_ampm_till"]];
    }
    
    
    
    for (NSDictionary *dic in arrayDate) {
        NSDate *date=[format dateFromString:[dic valueForKey:@"avail_by_date"]];
        NSArray*date1=[[dic valueForKey:@"avail_by_date"] componentsSeparatedByString:@"-"];
        
        NSString *futureDateString;
        futureDateString=[NSString stringWithFormat:@"%@ %@,%@ @ %.2ld:%.2ld %@ - %.2ld:%.2ld %@",[weekDay stringFromDate:date],[calMonth stringFromDate:date],[date1 objectAtIndex:2],(long)[[dic valueForKey:@"avail_by_hr"] integerValue],(long)[[dic valueForKey:@"avail_by_min"] integerValue],[dic valueForKey:@"avail_by_ampm"],[[dic valueForKey:@"avail_till_hr"] integerValue],(long)[[dic valueForKey:@"avail_till_min"] integerValue],[dic valueForKey:@"avail_till_ampm"]];
        [datesArray addObject:futureDateString];
    }
    if ([[Item_details valueForKey:@"future_available_dates"] count]==1) {
        self.btndropDown.hidden=YES;
        self.drpImage.hidden=YES;
    }
    //[NSString stringWithFormat:@"%@/%@  %.2ld:%.2ld %@" ,[date objectAtIndex:1],[date objectAtIndex:2],(long)[[Item_details valueForKey:@"avail_by_hr"] integerValue],(long)[[Item_details valueForKey:@"avail_by_min"] integerValue],[Item_details valueForKey:@"avail_by_ampm"]];
    Availability.text=[NSString stringWithFormat:@"%@" ,[[dateString componentsSeparatedByString:@"@"] objectAtIndex:0]];
   // Availability.text=[NSString stringWithFormat:@"%@/%@/%ld",[date objectAtIndex:1],[date objectAtIndex:2],[[date objectAtIndex:0] integerValue]%100];
 
    if (appDel.rememberDateFlag!=YES) {
        self.lbldate1.text=dateString;
        self.lblDate.text=dateString;
        appDel.dateSelectedId=[Item_details valueForKey:@"availability_id"];

    }
    else{
        self.lbldate1.text=appDel.dateSelected;
        self.lblDate.text=appDel.dateSelected;
        
        NSArray *arr=[appDel.dateSelected componentsSeparatedByString:@"@"];
        Availability.text=[arr objectAtIndex:0];
        
        NSArray *arry=[Item_details valueForKey:@"future_available_dates"];
        
        qty_available=[(NSString*)[arry objectAtIndex:selectedIndx] valueForKey:@"qty"];

       // appDel.rememberDateFlag=NO;
    }
    NSString * result = [[Item_details valueForKey:@"ingrediants"] description];
    result=[result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    result=[result stringByReplacingOccurrencesOfString:@"(" withString:@""];
    result=[result stringByReplacingOccurrencesOfString:@")" withString:@""];
    result=[result stringByReplacingOccurrencesOfString:@" " withString:@""];
    result=[result stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    Ingredient.text=[NSString stringWithFormat:@"Ingredient : %@",result];
    
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    
    
    ////
    
    ///
    Hearder_checkout.font=[UIFont fontWithName:Regular size:18.0f];
    // right
    dishLocation_Order.font=sub;
    DishName_Order.font=[UIFont fontWithName:Bold size:16.0f];
    DishRestaurant_order.font=sub;
    Qty_Order.font=sub;
    ActualDishAmt_Order.font=sub;
    discountAmt_Order.font=sub;
    TaxAmt_Order.font=sub;
    TotalAmt_Order.font=sub;
    /// left
    Qty_order_left.font=[UIFont fontWithName:Bold size:15.0f];
    actualDishAmt_Order_Left.font=[UIFont fontWithName:Bold size:15.0f];
    discountamt_order_Left.font=[UIFont fontWithName:Bold size:15.0f];
    Totalamt_Order_left.font=[UIFont fontWithName:Bold size:15.0f];
    Tax_Order_left.font=[UIFont fontWithName:Bold size:15.0f];
    promoType_order.font=[UIFont fontWithName:Bold size:15.0f];
    PromoTypeValue.font=sub;
    
    OrderNowBtn.titleLabel.font=[UIFont fontWithName:Bold size:15.0f];
    CGRect frme=checkOutVw.frame;
    frme.origin.x=320;
    checkOutVw.frame=frme;
    self.btnAddnewAddr.hidden=YES;

    NSDictionary *locDict=[Item_details valueForKey:@"images"];
    id img=[Item_details valueForKey:@"images"];
    if ([img isKindOfClass:[NSArray class]])
    {
        NSArray *art=[Item_details valueForKey:@"images"];
        NSSortDescriptor *hopProfileDescriptor =[[NSSortDescriptor alloc] initWithKey:@"default"
                                                                            ascending:NO];
        
        NSArray *descriptors = [NSArray arrayWithObjects:hopProfileDescriptor, nil];
        NSArray *sortedArrayOfDictionaries = [art
                                              sortedArrayUsingDescriptors:descriptors];
        if ([sortedArrayOfDictionaries count]) {
            locDict=[sortedArrayOfDictionaries objectAtIndex:0];
        }
    }
    else
    {
        locDict=[Item_details valueForKey:@"images"];
    }
    
    
    if([ locDict count]!=0)
    {
        NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLImage,[locDict valueForKey:@"path_lg"]];
        [Dishimage sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"Dish_Placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image==nil){
                Dishimage.image=[UIImage imageNamed:@"Dish_Placeholder.png"];
                dishImage2.image=[UIImage imageNamed:@"Dish_Placeholder.png"];
            }
            
            else{
                Dishimage.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(75,75) source:image];
                dishImage2.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(75,75) source:image];
            }
            
        }];
    }
    addrssArray=[[NSMutableArray alloc]init];
    dict=[[NSMutableDictionary alloc]init];
    dict=(NSMutableDictionary *)[[NSUserDefaults standardUserDefaults ] valueForKey:@"UserProfile"];
     count = [[dict valueForKey:@"ref_promo_count"] integerValue];
    addrssArray=[dict valueForKey:@"deliveryAddresses"];
    
    if (count >0 || [[dict valueForKey:@"is_discount_applied"] integerValue] == 0 ) {
        First_Btn.userInteractionEnabled=YES;
        [First_Btn setHidden:NO];
        [self.remainLbl setHidden:NO];
        [self.remainLbl setText:[NSString stringWithFormat:@"(you have %ld remaining)",count]];
        
    }
    else{
        First_Btn.userInteractionEnabled=NO;
        [First_Btn setHidden:YES];
        [self.remainLbl setHidden:YES];
        self.promoCodeBtn.center=CGPointMake(self.promoCodeBtn.center.x, self.promoCodeBtn.center.y-25);
        self.promoTxt.center=CGPointMake(self.promoTxt.center.x, self.promoTxt.center.y-25);
        self.apply_btn.center=CGPointMake(self.apply_btn.center.x, self.apply_btn.center.y-25);

    }
    
    if ([[[dict valueForKey:@"isShoppingPromo"] valueForKey:@"error"] integerValue] ==0) {
        [self.promoTxt setHidden:NO];
        [self.apply_btn setHidden:NO];
        [self.promoCodeBtn setHidden:NO];
    }
    else{
        [self.promoTxt setHidden:YES];
        [self.apply_btn setHidden:YES];
        [self.promoCodeBtn setHidden:YES];
    }
    [authNet_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    
    self.promoTxt.userInteractionEnabled=NO;
    self.promoTxt.alpha=0.25f;
    self.apply_btn.alpha=0.25f;
    
    if ([self.promoCodeBtn isHidden]== YES && [First_Btn isHidden] == YES) {
        [none_btn setHidden:YES];
        [AvileOfferPromo setHidden:YES];
        self.totalView.frame=CGRectMake(0,AvileOfferPromo.center.y+30, 320, 150);
    }
    if ([[Item_details valueForKey:@"is_pickup"] integerValue]==1 ) {
        
    }
    
    if ([addrssArray count]==0) {
        self.txtAddrs.hidden=YES;
        self.btnAddress.hidden=YES;
        _dropDown.hidden=YES;
        
    self.addressView.frame=CGRectMake(self.addressView.frame.origin.x, self.addressView.frame.origin.y-self.btnAddress.frame.size.height/2, self.addressView.frame.size.width, self.addressView.frame.size.height);
    }
    if(!IS_IPHONE5){
        
        self.scrollView.frame=CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, 560);
    }
    height= self.scrollView.frame.size.height;
    self.addressId=@"";
    self.states=[self GetStatesList];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];

    self.txtCity.leftView = paddingView1;
    self.txtState.leftView = paddingView3;
    self.txtZip.leftView = paddingView2;
    self.txtPhoneNum.leftView=paddingView4;

    self.txtAdrs.leftView = paddingView;
    self.txtAdrs.leftViewMode = UITextFieldViewModeAlways;
    self.txtState.leftViewMode = UITextFieldViewModeAlways;
    self.txtCity.leftViewMode = UITextFieldViewModeAlways;
    self.txtZip.leftViewMode = UITextFieldViewModeAlways;
    self.txtPhoneNum.leftViewMode = UITextFieldViewModeAlways;

    self.tipsArray=[[NSArray alloc]initWithObjects:@"0%",@"10%",@"15%",@"18%",@"25%", nil];
    
    [self  showDineOpts:nil];
    
    if ([[Item_details valueForKey:@"is_pickup"] integerValue]==1) {

        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=33;
        choseOfferBtn.selected=NO;

        [self buttonAction:btn];

    }
    if ([[Item_details valueForKey:@"is_dinein"]integerValue] ==1) {
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=22;
        choseOfferBtn.selected=NO;

        [self buttonAction:btn];
    }
    if ([[Item_details valueForKey:@"is_delivery"] integerValue] ==1){
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=11;
        choseOfferBtn.selected=NO;
        [self buttonAction:btn];
        [self expandPromoView:choseOfferBtn];
        
    }

    if ((([[Item_details valueForKey:@"is_delivery"] integerValue]==1 &&[[Item_details valueForKey:@"is_dinein"]integerValue] ==0 &&[[Item_details valueForKey:@"is_pickup"] integerValue]==0)||([[Item_details valueForKey:@"is_delivery"] integerValue]==0 &&[[Item_details valueForKey:@"is_dinein"]integerValue] ==1 &&[[Item_details valueForKey:@"is_pickup"] integerValue]==0)||([[Item_details valueForKey:@"is_delivery"] integerValue]==0 &&[[Item_details valueForKey:@"is_dinein"]integerValue] ==0 &&[[Item_details valueForKey:@"is_pickup"] integerValue]==1))) {
        
        deliveryImage.hidden=YES;
    }
}
- (void)updateCurrentLocation {
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:locationManager.location // You can pass aLocation here instead
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       dispatch_async(dispatch_get_main_queue(),^ {
                           // do stuff with placemarks on the main thread
                           
                           if (placemarks.count == 1) {
                               
                               CLPlacemark *place = [placemarks objectAtIndex:0];
                               
                               addrFromLocation=[[NSDictionary alloc]init];
                               
                               addrFromLocation=place.addressDictionary;
                               
                           }
                           
                       });
                       
                   }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)select_payment:(id)sender {
    
    switch ([sender tag]) {
        case 1000:
        {
            [payPal_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            [authNet_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            
        }
            break;
        case 2000:
        {
            [authNet_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            [payPal_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            
        }
            break;
            
        default:
            break;
    }
    
}

- (IBAction)Promo_offerBtn_Clicked:(id)sender {
    
    switch ([sender tag]) {
            
        case 20:
        {
            self.promoTxt.userInteractionEnabled=NO;
            self.apply_btn.userInteractionEnabled=NO;
            self.promoTxt.alpha=0.25f;
            self.apply_btn.alpha=0.25f;
            
            float result=price*qty-5;
            if (result<0) {
                Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",0.0];
            }
            else{
                Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",result];
              }
            self.promoTxt.text=nil;
            [self.apply_btn setTitle:@"APPLY" forState:UIControlStateNormal];
            promoFlag=NO;

            [First_Btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            [self.promoCodeBtn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [none_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        }
            break;
        case 30:
        {    self.promoTxt.userInteractionEnabled=YES;
            self.apply_btn.userInteractionEnabled=YES;
            self.promoTxt.alpha=0.25f;
            
            self.apply_btn.alpha=1;
            Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",price*qty];
            [self.promoCodeBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            [First_Btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [none_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        }
            break;
        case 40:
        {
            self.promoTxt.userInteractionEnabled=NO;
            self.apply_btn.userInteractionEnabled=NO;
            self.promoTxt.alpha=0.25f;
            self.apply_btn.alpha=0.25f;
            Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",price*qty];
            self.promoTxt.text=nil;
            [self.apply_btn setTitle:@"APPLY" forState:UIControlStateNormal];
            promoFlag=NO;
            [First_Btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [self.promoCodeBtn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [none_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            
        }
            break;
            
        default:
            break;
    }
}
-(void)selectNone{
    self.promoTxt.userInteractionEnabled=NO;
    self.apply_btn.userInteractionEnabled=NO;
    self.promoTxt.alpha=0.25f;
    self.apply_btn.alpha=0.25f;
    Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",price*qty];
    self.promoTxt.text=nil;
    [self.apply_btn setTitle:@"APPLY" forState:UIControlStateNormal];
    promoFlag=NO;
    [First_Btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [self.promoCodeBtn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [none_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
}
- (IBAction)Qty_Plus_Minus:(id)sender {
    [self selectNone];
    
    qty=[Quantity.text integerValue];
    
    if ([sender tag] ==10) {
        qty=qty-1;
        if (qty<=0) {
            qty=1;
        }
        
    }else if ([sender tag]==20)
    {
        qty=qty+1;
        
        if (qty >=[qty_available integerValue]) {
            qty=[qty_available integerValue];
            
        }
        
    }
    if (promoFlag) {
        if ([promotype isEqualToString:@"Percentage Promo"]) {
            float pr=price*qty-(price*qty*percent/100);
            Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",pr];
        }
        else{
            float result=price*qty-dollars;
            if (result < 0) {
                Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",0.0];
            }
            else{
                Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",result];
            }

        }
    }
    else{
     Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",price*qty];
    }
    
    Quantity.text=[NSString stringWithFormat:@"%.2ld",qty];
    
}
- (IBAction)addToBagBtnClicked:(id)sender
{
    NSString *promo=@"";
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]init];
    [self.promoTxt resignFirstResponder];
    addressDict=[[NSMutableDictionary alloc]init];
    
    if (![self.btnDineOpt.titleLabel.text length] || [self.btnDineOpt.titleLabel.text isEqualToString:@"Select"]) {
        [GlobalMethods showAlertwithString:@"Please select dine option"];

    }
    else{
    //   [Sweep_Btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    if ([self.btnDineOpt.titleLabel.text isEqualToString:@"Delivery"]) {
        if (![self.txtAdrs.text length] || [GlobalMethods checkWhiteSpace:self.txtAdrs.text]) {
            [GlobalMethods showAlertwithString:@"Please enter Address"];
            return;
        }
        if (![self.txtPhoneNum.text length]||[GlobalMethods checkWhiteSpace:self.txtPhoneNum.text]) {
            if (self.txtPhoneNum.userInteractionEnabled == YES) {
                [GlobalMethods showAlertwithString:@"Please enter Phone Number"];
                return;
            }
            
        }
        if ([self.txtPhoneNum.text length]<10) {
            if (self.txtPhoneNum.userInteractionEnabled == YES) {
                [GlobalMethods showAlertwithString:@"Please enter valid Phone Number"];
                return;
            }
        }
        if (![self.txtCity.text length]||[GlobalMethods checkWhiteSpace:self.txtCity.text]) {
            [GlobalMethods showAlertwithString:@"Please enter city"];
            return;
        }
        if (![self.txtState.text length]&&[GlobalMethods checkWhiteSpace:self.txtState.text]) {
            [GlobalMethods showAlertwithString:@"Please enter state"];
            return;
        }
        if (![self.txtZip.text length]||[GlobalMethods checkWhiteSpace:self.txtZip.text]) {
            [GlobalMethods showAlertwithString:@"Please enter zip"];
            return;
        }
        if ([self.txtZip.text length] <5){
            [GlobalMethods showAlertwithString:@"Zip code must be 5 numbers"];
            return;
        }
        [addressDict setValue:self.txtAdrs.text forKey:@"delivery_address"];
        [addressDict setValue:self.txtCity.text forKey:@"delivery_city"];
        [addressDict setValue:self.txtState.text forKey:@"delivery_state"];
        [addressDict setValue:self.txtZip.text forKey:@"delivery_zip"];
        [addressDict setValue:self.txtSuiteNo.text forKey:@"delivery_suiteNo"];
        [addressDict setValue:self.txtInstructions.text forKey:@"delivery_instructions"];
        [addressDict setValue:self.addressId forKey:@"address_id"];
        [addressDict setValue:self.txtPhoneNum.text forKey:@"delivery_phone"];
        [addressDict setValue:@"2" forKey:@"delivery_type"];
    }
    else{
        [addressDict setValue:@"" forKey:@"delivery_address"];
        [addressDict setValue:@"" forKey:@"delivery_city"];
        [addressDict setValue:@"" forKey:@"delivery_state"];
        [addressDict setValue:@"" forKey:@"delivery_zip"];
        [addressDict setValue:@"" forKey:@"delivery_suiteNo"];
        [addressDict setValue:@"" forKey:@"delivery_instructions"];
        
        [addressDict setValue:self.txtPhoneNum.text forKey:@"delivery_phone"];
        [addressDict setValue:self.addressId forKey:@"address_id"];
        if ([self.btnDineOpt.titleLabel.text isEqualToString:@"Dine In"]) {
            [addressDict setValue:@"0" forKey:@"delivery_type"];

        }
        else{
            [addressDict setValue:@"1" forKey:@"delivery_type"];
        }
    }
    appDel.deliveryAddr=addressDict;
    if ([[First_Btn currentImage] isEqual:[UIImage imageNamed:@"checked"]])
    {
        if ([[dict valueForKey:@"is_discount_applied"] integerValue]==0) {
            promo=@"first";
            
        }else{
            promo=@"refer";
            count=count-1;
        }
        [paramDict setObject:@"0" forKey:@"isShoppingPromo"];

    }
    else if ([[self.promoCodeBtn currentImage] isEqual:[UIImage imageNamed:@"checked"]]){
        if (promoFlag) {
            promo=self.promoTxt.text;
            [paramDict setObject:@"1" forKey:@"isShoppingPromo"];
        }
        else{
            promo=@"";;
            [paramDict setObject:@"0" forKey:@"isShoppingPromo"];
        }
        
    }
    else{
        //tipLabel.frame=CGRectMake(tipLabel.frame.origin.x, promoType_order.frame.origin.y+30, tipLabel.frame.size.width, tipLabel.frame.size.height);
        //self.btnTips.frame=CGRectMake(self.btnTips.frame.origin.x, tipLabel.frame.origin.y+30, self.btnTips.frame.size.width, self.btnTips.frame.size.height);

        [discountAmt_Order setHidden:YES];
        [discountamt_order_Left setHidden:YES];
        [promoType_order setHidden:YES];
        [PromoTypeValue setHidden:YES];
        Tax_Order_left.center=discountamt_order_Left.center;
        TaxAmt_Order.center=discountAmt_Order.center;
        
        tipSubView.frame=CGRectMake(tipSubView.frame.origin.x, Tax_Order_left.frame.origin.y+Tax_Order_left.frame.size.height, tipSubView.frame.size.width, tipSubView.frame.size.height);

        promoType_order.frame=CGRectMake(promoType_order.frame.origin.x, tipLabel.frame.origin.y+tipLabel.frame.size.height+20, promoType_order.frame.size.width, promoType_order.frame.size.height);
        PromoTypeValue.frame=CGRectMake(PromoTypeValue.frame.origin.x, self.btnTips.frame.origin.y+self.btnTips.frame.size.height+20, PromoTypeValue.frame.size.width, PromoTypeValue.frame.size.height);
        self.payselView.frame=CGRectMake(0,tipSubView.center.y+50, 320, 165);
    }
    NSString *subString = Quantity.text;//[Quantity.text substringWithRange: NSMakeRange(0, [Quantity.text rangeOfString: @"/"].location)];
    parseInt=2;
    
    //    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Item_details valueForKey:@"dish_id"], @"dishId",
    //                            subString, @"quantity",appDel.accessToken,@"accessToken",nil];
    //
    
    
    [paramDict setObject:[Item_details valueForKey:@"dish_id"] forKey:@"dishId"];
    [paramDict setObject:subString forKey:@"quantity"];
    [paramDict setObject:appDel.accessToken forKey:@"accessToken"];
    [paramDict setObject:appDel.dateSelectedId forKey:@"availability_id"];
        
        if ([self.btnDineOpt.titleLabel.text isEqualToString:@"Delivery"]) {
            [paramDict setObject:self.txtZip.text forKey:@"zip_code"];
            
        }
   
        
    if ([promo length]) {
        [paramDict setObject:promo forKey:@"promoType"];
        
    }
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Click Checkout Button_iOSMobile" properties:nil];
    
    [parser parseAndGetDataForPostMethod:paramDict withUlr:@"checkDishAvailability"];
    }
}

- (IBAction)applyPromo:(id)sender {
    [self.promoTxt resignFirstResponder];
    
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [self.promoTxt.text stringByTrimmingCharactersInSet:charSet];
    if (![trimmedString isEqualToString:@""]) {
        if ([self.apply_btn.titleLabel.text isEqualToString:@"CANCEL"]) {
            
            Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",price*qty];
            self.promoTxt.text=nil;
            [self.apply_btn setTitle:@"APPLY" forState:UIControlStateNormal];
            promoFlag=NO;
        }
        else{
            parseInt=1;
            NSDictionary *dic=[[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfile"];

            NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]init];
            
            [paramDict setObject:self.promoTxt.text forKey:@"promo_code"];
            [paramDict setObject:appDel.accessToken forKey:@"accessToken"];
            [paramDict setObject:[dic valueForKey:@"email"]forKey:@"userEmail"];

            
            [parser parseAndGetDataForPostMethod:paramDict withUlr:@"customShoppingPromo"];
        }
        
    }
}

- (IBAction)showDates:(id)sender {
    
    NSLog(@"select date clicked");
    if (datesView==nil) {
        long height=0;
        if ([datesArray count] >3) {
            height=93;
        }
        else{
            height=height+[datesArray count]*31;
        }
        datesView=[[UIView alloc]initWithFrame:CGRectMake(self.btndropDown.frame.origin.x, self.btndropDown.frame.origin.y+25, self.btndropDown.frame.size.width, height)];
        datesTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, datesView.frame.size.width, height)];
        datesTable.backgroundColor= [UIColor whiteColor];
        datesView.backgroundColor= [UIColor whiteColor];

        datesTable.separatorColor = [UIColor clearColor];
        datesView.layer.borderWidth=1.0f;
        datesView.layer.borderColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f].CGColor;
        [datesView addSubview:datesTable];
        [self.scrollView addSubview:datesView];
        [datesTable sendSubviewToBack:datesTable];
        self.drpImage.image=[UIImage imageNamed:@"Dropdownup.png"];

        datesTable.delegate=(id)self;
        datesTable.dataSource=(id)self;
    }
    else{
        self.drpImage.image=[UIImage imageNamed:@"Dropdown.png"];

        [datesView removeFromSuperview];
        datesView=nil;
    }
    
    [self removeAllpopView:datesView];

}

- (IBAction)showDineOpts:(id)sender {
    
    if (optsView == nil) {
        //Disabling button action when there is single item
        if ((([[Item_details valueForKey:@"is_delivery"] integerValue]==1 &&[[Item_details valueForKey:@"is_dinein"]integerValue] ==0 &&[[Item_details valueForKey:@"is_pickup"] integerValue]==0)||([[Item_details valueForKey:@"is_delivery"] integerValue]==0 &&[[Item_details valueForKey:@"is_dinein"]integerValue] ==1 &&[[Item_details valueForKey:@"is_pickup"] integerValue]==0)||([[Item_details valueForKey:@"is_delivery"] integerValue]==0 &&[[Item_details valueForKey:@"is_dinein"]integerValue] ==0 &&[[Item_details valueForKey:@"is_pickup"] integerValue]==1))) {
            
            return;
        }
        optsView=[[UIView alloc]initWithFrame:CGRectMake(self.btnDineOpt.frame.origin.x, self.btnDineOpt.frame.origin.y+24, self.btnDineOpt.frame.size.width, 64)];
        optsView.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
        [self.scrollView addSubview:optsView];
        
        if ([[Item_details valueForKey:@"is_delivery"] integerValue] ==1) {
            
            UIButton *bt1=[[UIButton alloc]initWithFrame:CGRectMake(1, 1, self.btnDineOpt.frame.size.width-2, 20)];
            [bt1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            bt1.tag=11;
            [bt1 setTitle:@"Delivery" forState:UIControlStateNormal];
            bt1.titleLabel.font=[UIFont systemFontOfSize:11];
            [bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt1.backgroundColor=[UIColor whiteColor];
            [optsView addSubview:bt1];
            [optsView setFrame:CGRectMake(self.btnDineOpt.frame.origin.x, self.btnDineOpt.frame.origin.y+23, self.btnDineOpt.frame.size.width, 22)];
        }
        if ([[Item_details valueForKey:@"is_dinein"]integerValue] ==1) {
            
            int y=0;
            int height=0;
            if ([[optsView subviews] count]) {
                y=22;
                height=43;
            }
            else{
                y=1;
                height=22;
            }
            UIButton *bt2=[[UIButton alloc]initWithFrame:CGRectMake(1,y, self.btnDineOpt.frame.size.width-2, 20)];
            [bt2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [bt2 setTitle:@"Dine In" forState:UIControlStateNormal];
            [bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt2.tag=22;
            bt2.titleLabel.font=[UIFont systemFontOfSize:11];
            bt2.backgroundColor=[UIColor whiteColor];
            [optsView addSubview:bt2];
            [optsView setFrame:CGRectMake(self.btnDineOpt.frame.origin.x, self.btnDineOpt.frame.origin.y+23, self.btnDineOpt.frame.size.width, height)];
//            self.btnAddnewAddr.hidden=YES;
        }
        if ([[Item_details valueForKey:@"is_pickup"] integerValue]==1) {
            int y=0;
            int height=0;

            if ([[optsView subviews] count]) {
                if ([[optsView subviews] count ]==1) {
                    y=22;
                    height=43;

                }
                else if ([[optsView subviews] count ]==2){
                    y=43;
                    height=64;
                }
                else{
                    y=1;
                    height=22;
                }
            }
            else{
                y=1;
                height=22;
            }
            UIButton *bt3=[[UIButton alloc]initWithFrame:CGRectMake(1,y, self.btnDineOpt.frame.size.width-2, 20)];
            [bt3 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [bt3 setTitle:@"Pick Up" forState:UIControlStateNormal];
            [bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt3.tag=33;
            bt3.titleLabel.font=[UIFont systemFontOfSize:11];
            bt3.backgroundColor=[UIColor whiteColor];
            [optsView addSubview:bt3];
            [optsView setFrame:CGRectMake(self.btnDineOpt.frame.origin.x, self.btnDineOpt.frame.origin.y+23, self.btnDineOpt.frame.size.width, height)];

        }
    }
    else{
        [optsView removeFromSuperview];
        optsView=nil;
    }
    
    [self removeAllpopView:optsView];

}

-(void)buttonAction:(id)sender{
    
    //[self removeAllpopView];
    if ([sender tag] == 11) {
        [self.btnDineOpt setTitle:@"Delivery" forState:UIControlStateNormal];
        
        
        NSLog(@"addrss :%@",addrFromLocation);
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGRect frame = self.offerView.frame;
             frame.origin.y = self.addressView.frame.origin.y+self.addressView.frame.size.height/2+70;
             frame.origin.x = 0;
             self.offerView.frame = frame;
             if (IS_IPHONE5) {
                 [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, height+self.offerView.frame.size.height/2)];

             }else{
                 [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 820)];

             }

         }
                         completion:^(BOOL finished)
         {
             self.txtZip.text=[addrFromLocation valueForKey:@"ZIP"];
             self.txtState.text=[addrFromLocation valueForKey:@"State"];
             self.txtCity.text=[addrFromLocation valueForKey:@"City"];
             self.txtPhoneNum.text=[dict valueForKey:@"mobile"];
         }];
    }
    else if ([sender tag] == 22){
        self.addressId=@"";
        [self.view endEditing:YES];
        [self.btnDineOpt setTitle:@"Dine In" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGRect frame = self.offerView.frame;
             frame.origin.y = Quantity.frame.origin.y+25;
             frame.origin.x = 0;
             self.offerView.frame = frame;
             if (IS_IPHONE5) {
                 [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,height)];
                 
             }else{
                 [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 630)];
                 
             }
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
        [self newAddress:self];

    }
    else {
        self.addressId=@"";
        [self.view endEditing:YES];

        [self.btnDineOpt setTitle:@"Pick Up" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGRect frame = self.offerView.frame;
             frame.origin.y = Quantity.frame.origin.y+25;
             frame.origin.x = 0;
             self.offerView.frame = frame;
             if (IS_IPHONE5) {
                 [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,height)];
                 
             }else{
                 [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 630)];
                 
             }
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
        [self newAddress:self];

    }
    [optsView removeFromSuperview];
    optsView=nil;
}
- (IBAction)showAddress:(id)sender {
    
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    [dict setValue:@"Add new" forKey:@"address"];
    if (addressView1==nil) {
        long height=0;
        if ([addrssArray count] >3) {
            height=64;
        }
        else{
            height=height+[addrssArray count]*31;
        }
        addressView1=[[UIView alloc]initWithFrame:CGRectMake(self.btnAddress.frame.origin.x, self.btnAddress.frame.origin.y+25, self.btnAddress.frame.size.width, height)];
        addressTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, addressView1.frame.size.width, height)];
        addressTable.backgroundColor= [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
        addressTable.separatorColor = [UIColor clearColor];
        
        addressView1.layer.borderWidth=1.0f;
        addressView1.layer.borderColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f].CGColor;
        
        [addressView1 addSubview:addressTable];
        [self.scrollView addSubview:addressView1];
        [addressView1 sendSubviewToBack:addressTable];

        addressTable.delegate=(id)self;
        addressTable.dataSource=(id)self;
        [addressTable performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:1];

    }
    else{
        [addressView1 removeFromSuperview];
        addressView1=nil;
    }
    [self removeAllpopView:addressView1];

}

- (IBAction)showBillingAddr:(id)sender {
}

- (IBAction)Cancel_Btn_Clicked:(id)sender {
    CGRect rec=self.view.frame;
    qty=1;
    rec.origin.y=-600;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.view.frame=rec;
                     }
                     completion:^(BOOL finished){
                         Item_details=nil;
                         
                         [self.view removeFromSuperview];
                         
                     }
     ];
    
}
- (IBAction)Cancel_Btn_ClickedCheckoutAcreen:(id)sender {
    CGRect rec=self.view.frame;

    rec.origin.y=-600;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         checkOutVw.frame=rec;
                     }
                     completion:^(BOOL finished){
                         
                         [checkOutVw removeFromSuperview];
                         
                     }
     ];
    
}

- (IBAction)closeZippopup:(id)sender {
    [self.zipcodePopupView removeFromSuperview];
}

-(IBAction)checkoutClicked:(id)sender
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Order Button Clicked_iOSMobile" properties:@ {
        @"Product Name":Dish_Name.text,
        @"Price":Price_lbl.text,
        @"Quantity":Quantity.text
        
    }];
    
    if ([authNet_btn.currentImage isEqual:[UIImage imageNamed:@"checked"]])
    {
        [appDel.dishesVC checkaddtoBagDishID:[Item_details valueForKey:@"dish_id"] Quantity:[checkOutArr valueForKey:@"order_quantity"] paytype:@"authNet" product:checkOutArr] ;
    }
    else if ([payPal_btn.currentImage isEqual:[UIImage imageNamed:@"checked"]])
    {
        [appDel.dishesVC checkaddtoBagDishID:[Item_details valueForKey:@"dish_id"] Quantity:[checkOutArr valueForKey:@"order_quantity"] paytype:@"payPal" product:checkOutArr];
    }
    else
    {
        [GlobalMethods showAlertwithString:@"Please select payment type to checkout"];
        return;
    }
    
    [self performSelector:@selector(Cancel_Btn_Clicked:) withObject:self afterDelay:0.5f];
}
-(IBAction)showTipsView{
    
    if (tipsView == nil) {
        tipsView=[[UIScrollView alloc]initWithFrame:CGRectMake(self.btnTips.frame.origin.x+tipSubView.frame.origin.x,tipSubView.frame.origin.y+self.btnTips.frame.origin.y+24, self.btnTips.frame.size.width, 100)];
        tipsView.backgroundColor=[UIColor whiteColor];
        [checkOutVw addSubview:tipsView];
        float Yaxis=1;
        
        for (int i=0; i<5; i++) {
            
            
            UIButton *bt1=[[UIButton alloc]initWithFrame:CGRectMake(1, Yaxis, self.btnTips.frame.size.width-2, 20)];
            [bt1 addTarget:self action:@selector(tipbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
            bt1.tag=i;
            [bt1 setTitle:[self.tipsArray objectAtIndex:i] forState:UIControlStateNormal];
            bt1.titleLabel.font=[UIFont systemFontOfSize:11];
            bt1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
            [bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt1.backgroundColor=[UIColor whiteColor];
            [tipsView addSubview:bt1];
            Yaxis+=21;

        }
        
    }
    else{
        [tipsView removeFromSuperview];
        tipsView=nil;
    }
}
-(void)tipbuttonAction:(UIButton*)sender{
        
    [self.btnTips setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    appDel.tipPercent=[[self.tipsArray objectAtIndex:sender.tag] integerValue];
    float tipPrice=0;
    float tipvalue=(float)appDel.tipPercent;
    float price1=[[checkOutArr valueForKey:@"price"] floatValue];
    if (price1*0.20 > 5) {
        price1=price1+5;
    }
    else{
        price1=(price1*0.20)+price1;
    }

    tipPrice = (tipvalue/100)*price1;
    price1=[[checkOutArr valueForKey:@"price_with_tax"] floatValue];
    TotalAmt_Order.text=[NSString stringWithFormat:@"$ %.2f",price1+tipPrice];

    if (tipsView!=nil) {
        
        [tipsView removeFromSuperview];
        tipsView=nil;

    }
}
-(IBAction)expandPromoView:(UIButton*)sender{

    [self removeAllpopView:nil];

    if (sender.selected) {
        promoView.frame=CGRectMake(promoView.frame.origin.x, promoView.frame.origin.y, promoView.frame.size.width, 150);
        self.totalView.frame=CGRectMake(0,promoView.frame.origin.y+promoView.frame.size.height+10, 320, self.totalView.frame.size.height);

        sender.selected=NO;
    }else{
        sender.selected=YES;
        promoView.frame=CGRectMake(promoView.frame.origin.x, promoView.frame.origin.y, promoView.frame.size.width, 35);
        self.totalView.frame=CGRectMake(0,promoView.frame.origin.y+promoView.frame.size.height+10, 320, self.totalView.frame.size.height);

    }
    
    
}
-(void)removeAllpopView:(UIView*)sender{
    
    if (sender == optsView) {
       
        if (datesView!=nil) {
            
            [datesView removeFromSuperview];
            datesView=nil;
            
        }
        if (addressView1!=nil) {
            
            [addressView1 removeFromSuperview];
            addressView1=nil;
        }

    }else if (sender==datesView){
        if (optsView!=nil) {
            
            [optsView removeFromSuperview];
            optsView=nil;
        }
        
        if (addressView1!=nil) {
            
            [addressView1 removeFromSuperview];
            addressView1=nil;
        }

    }else if (sender==addressView1){
        
        if (optsView!=nil) {
            
            [optsView removeFromSuperview];
            optsView=nil;
        }
        if (datesView!=nil) {
            
            [datesView removeFromSuperview];
            datesView=nil;
            
        }
        
    }else{
        
        if (optsView!=nil) {
            
            [optsView removeFromSuperview];
            optsView=nil;
        }
        if (datesView!=nil) {
            
            [datesView removeFromSuperview];
            datesView=nil;
            
        }
        if (addressView1!=nil) {
            
            [addressView1 removeFromSuperview];
            addressView1=nil;
        }
    }
    
}
#pragma mark -
#pragma mark - datasource
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==datesTable) {
      return  datesArray.count;
    }
    else{
      return addrssArray.count;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (tableView==datesTable) {
        cell.textLabel.text=[datesArray objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont fontWithName:SemiBold size:11];

        if (selectedIndx==(int)indexPath.row) {
            cell.backgroundColor=[UIColor colorWithRed:(148/255.0) green:(187/255.0) blue:(118/255.0) alpha:1];
            cell.textLabel.textColor=[UIColor whiteColor];
        }
        else {
            cell.backgroundColor=[UIColor whiteColor];
            cell.textLabel.textColor=[UIColor blackColor];
        }
    }
    else{
        cell.contentView.backgroundColor=[UIColor whiteColor];//[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    cell.textLabel.font=[UIFont fontWithName:Regular size:12];
    cell.textLabel.text=[[addrssArray objectAtIndex:indexPath.row] valueForKey:@"address"];
    }
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(148/255.0) green:(187/255.0) blue:(118/255.0) alpha:1];
    cell.selectedBackgroundView = selectionColor;
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];

    return cell;
}


-(void)viewDidLayoutSubviews
{
    if ([addressTable  respondsToSelector:@selector(setSeparatorInset:)]) {
        [addressTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([addressTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [addressTable setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([datesTable  respondsToSelector:@selector(setSeparatorInset:)]) {
        [datesTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([datesTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [datesTable setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark -
#pragma mark - Tableview Delgates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==datesTable) {
        
        selectedIndx=(int)indexPath.row;
        self.lbldate1.text=[datesArray objectAtIndex:indexPath.row];
        self.lblDate.text=[datesArray objectAtIndex:indexPath.row];
        self.drpImage.image=[UIImage imageNamed:@"Dropdown.png"];
        
        appDel.dateSelected=[datesArray objectAtIndex:indexPath.row];
        appDel.dateSelectedId=[[arrayDate objectAtIndex:indexPath.row] valueForKey:@"availability_id"];
        NSArray *arr=[[datesArray objectAtIndex:indexPath.row] componentsSeparatedByString:@"@"];
        Availability.text=[arr objectAtIndex:0];
        qty_available=[(NSString*)[arrayDate objectAtIndex:indexPath.row] valueForKey:@"qty"];
        Quantity.text=@"01";
        Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",price];

        [datesView removeFromSuperview];
        datesView=nil;
    }
    else{
    self.txtAddrs.text=[[addrssArray objectAtIndex:indexPath.row] valueForKey:@"address"];
    self.txtAdrs.text=[[addrssArray objectAtIndex:indexPath.row] valueForKey:@"address"];
    self.txtCity.text=[[addrssArray objectAtIndex:indexPath.row] valueForKey:@"city"];
    self.txtState.text=[[addrssArray objectAtIndex:indexPath.row] valueForKey:@"state"];
    self.txtZip.text=[[addrssArray objectAtIndex:indexPath.row] valueForKey:@"zip"];
    self.txtPhoneNum.text=[[addrssArray objectAtIndex:indexPath.row] valueForKey:@"phone"];
    self.txtSuiteNo.text=[[addrssArray objectAtIndex:indexPath.row] valueForKey:@"suite"];
    self.txtInstructions.text=[[addrssArray objectAtIndex:indexPath.row] valueForKey:@"delivary_instructions"];
        
        for (UIView *i in self.addressView.subviews) {
            if([i isKindOfClass:[UITextField class]]){
                UITextField *newtxt = (UITextField *)i;
                newtxt.textColor=[UIColor lightGrayColor];
            }
            
        }
    
    self.txtAdrs.userInteractionEnabled=NO;
    self.txtCity.userInteractionEnabled=NO;
    self.txtZip.userInteractionEnabled=NO;
    self.txtState.userInteractionEnabled=NO;
    self.btnStates.userInteractionEnabled=NO;
        self.txtPhoneNum.userInteractionEnabled=NO;
        self.txtInstructions.userInteractionEnabled=YES;
        self.txtSuiteNo.userInteractionEnabled=NO;
    self.btnAddnewAddr.hidden=NO;

        self.txtAdrs.textColor=[UIColor blackColor];
        self.txtCity.textColor=[UIColor blackColor];
        self.txtZip.textColor=[UIColor blackColor];
        self.txtPhoneNum.textColor=[UIColor blackColor];
        self.txtSuiteNo.textColor=[UIColor blackColor];
        self.txtInstructions.textColor=[UIColor blackColor];
        self.txtState.textColor=[UIColor blackColor];

        self.addressId=[[addrssArray objectAtIndex:indexPath.row] valueForKey:@"address_id"];
    [addressView1 removeFromSuperview];
    addressView1=nil;
    }
}

#pragma mark
#pragma mark - TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   // [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //[self animateTextField: textField up: NO];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 50; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField==self.txtZip || textField==self.zipText)
    {
        if (textField.text.length >= 5 && range.length == 0)
            return NO;
    }
    if(textField==self.txtPhoneNum || textField==self.phoneText)
    {
        if (textField.text.length >= 10 && range.length == 0)
            return NO;
    }
    if (textField.keyboardType == UIKeyboardTypeNumbersAndPunctuation)
    {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            // BasicAlert(@"", @"This field accepts only numeric entries.");
            return NO;
        }
    }
    return YES;
}
#pragma mark
#pragma mark - Location manager delegate

// this delegate is called when the app successfully finds your current location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // this creates a MKReverseGeocoder to find a placemark using the found coordinates
    
}

// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}

#pragma mark -
#pragma mark - PickerView DataSOurces
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
        return [self.states count];
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

        return [NSString stringWithFormat:@"%@",  self.states[row]]; //[[keys objectAtIndex:row]valueForKey:@"title"];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:Regular size:18]];
        [tView setTextAlignment:NSTextAlignmentCenter];
    }
    // Fill the label text here
    
    
        NSString *state =  [NSString stringWithFormat:@"%@",  self.states[row]]; //[[keys objectAtIndex:row]valueForKey:@"title"];
        tView.text = state;
    
    return tView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
        selectedState = [NSString stringWithFormat:@"%@",  self.states[row]];
}

#pragma mark
#pragma mark - ParseAndGetData Delegates
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    BOOL errMsg=[[result valueForKey:@"error"]boolValue];
    if(errMsg){
        if (parseInt==1) {
            [GlobalMethods showAlertwithString:[result valueForKey:@"reason"]];
            promoFlag=NO;

        }
        else{
            if ([[result valueForKey:@"code"] integerValue]==151) {
                [self.view addSubview:self.zipcodePopupView];
                self.phoneText.text=self.txtPhoneNum.text;
                self.zipText.text=self.txtZip.text;
                self.emailText.text=[dict valueForKey:@"email"];

            }
            else
            [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
        }
    }
    else
    {
        if(parseInt==1)
        {
            if ([[result valueForKey:@"promo_type"] isEqualToString:@"Percentage Promo"]) {
                promotype=@"Percentage Promo";
                percent=(int)[[result valueForKey:@"promo_value"] integerValue];
                Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",price*qty-(price*qty*percent/100)];
            }
            else{
                promotype=@"Dollar Promo";
                dollars=[[result valueForKey:@"promo_value"] floatValue];
                float result=price*qty-dollars;
                if (result <= 0) {
                    Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",0.0];
                }
                else{
                Price_lbl.text=[NSString stringWithFormat:@"$ %.2f",result];
                }
            }
            [self.apply_btn setTitle:@"CANCEL" forState:UIControlStateNormal];
            promoFlag=YES;
        }
        else if(parseInt==2)
        {
            
            checkOutArr=[result valueForKey:@"details"];
            CGRect check=checkOutVw.frame;
            check.origin.x=0;
            CGRect first=firstScren.frame;
            //first.origin.x=320;
            
            [UIView animateWithDuration:0.5
                             animations:^{
                                 checkOutVw.frame=check;
                             }
                             completion:^(BOOL finished){
                                 firstScren.frame=first;
                                 
                                 
                             }
             ];
            
            [self checoutScreen ];
        }
        else if(parseInt==3)
        {
            [self.zipcodePopupView removeFromSuperview];
            appDel.IsProcessComplete = YES;
            [appDel.nav popToViewController:appDel.dishesVC animated:YES];


        }
    }
    [hud hide:YES];
    [hud removeFromSuperview];
    hud=nil;
}


-(void)checoutScreen
{
    DishName_Order.text=Dish_Name.text;
    DishRestaurant_order.text=Chef_Name.text;
    
    float price1=[[checkOutArr valueForKey:@"price"] floatValue];
    if (price1*0.20 > 5) {
        price1=price1+5;
    }
    else{
    price1=(price1*0.20)+price1;
    }
    
    ActualDishAmt_Order.text=[NSString stringWithFormat:@"$ %.2f",price1];
    Qty_Order.text=[NSString stringWithFormat:@"%ld",(long)[[checkOutArr valueForKey:@"order_quantity"] integerValue]];
    discountAmt_Order.text=[NSString stringWithFormat:@"%@",[checkOutArr valueForKey:@"discount_amount"]];
    
    if (![[checkOutArr allKeys]containsObject:@"discount_amount"]) {
        discountAmt_Order.text=@"-";
    }
    
    
    TotalAmt_Order.text=[NSString stringWithFormat:@"$ %@",[checkOutArr valueForKey:@"price_with_tax"]];
    TotalAmt_Order.font=[UIFont fontWithName:SemiBold size:20];
    TaxAmt_Order.text=[NSString stringWithFormat:@"$ %@",[checkOutArr valueForKey:@"tax_total"]];
    if ([[checkOutArr valueForKey:@"discount_type"] isEqualToString:@"first"])
    {
        PromoTypeValue.text=@"First time";
        
    }
    else if ([[checkOutArr valueForKey:@"discount_type"] isEqualToString:@"refer"])
    {
        PromoTypeValue.text=@"Referred";
    }
    else{
        if (![[checkOutArr allKeys]containsObject:@"discount_type"]){
            PromoTypeValue.text=@"-";
        }
        else{
            PromoTypeValue.text=[checkOutArr valueForKey:@"discount_type"];

        }

    }
    
    
}
-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    [hud hide:YES];

    [GlobalMethods showAlertwithString:err];
}
#pragma mark
#pragma mark - HUD Delegtes
- (void)hudWasHidden:(MBProgressHUD *)huda {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    hud = nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    hud=nil;
    parser=nil;
}
- (NSArray *) GetStatesList
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"States" ofType:@"plist"];
    
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithContentsOfFile:path];
    NSDictionary *names = [dict objectForKey:@"StatesList"];
    
    NSArray *array = [[names allKeys] sortedArrayUsingSelector:
                      @selector(compare:)];
    _states = array;
    
    return  _states;
}
- (IBAction)newAddress:(id)sender {
    
    if (addressView1!=nil) {
        [addressView1 removeFromSuperview];
        addressView1=nil;
    }
    
    self.txtAddrs.text=nil;
    self.txtAdrs.text=nil;
    self.txtCity.text=nil;
    self.txtState.text=nil;
    self.txtZip.text=nil;
    self.txtPhoneNum.text=nil;
    self.txtSuiteNo.text=nil;
    self.txtInstructions.text=nil;

    self.txtAddrs.text=@"Select Saved Address";
    self.txtAdrs.userInteractionEnabled=YES;
    self.txtCity.userInteractionEnabled=YES;
    self.txtZip.userInteractionEnabled=YES;
    self.btnStates.userInteractionEnabled=YES;
    self.txtPhoneNum.userInteractionEnabled=YES;
    self.txtSuiteNo.userInteractionEnabled=YES;
    self.txtInstructions.userInteractionEnabled=YES;

    
    self.txtAdrs.textColor=[UIColor blackColor];
    self.txtCity.textColor=[UIColor blackColor];
    self.txtZip.textColor=[UIColor blackColor];
    self.txtPhoneNum.textColor=[UIColor blackColor];
    self.txtSuiteNo.textColor=[UIColor blackColor];
    self.txtInstructions.textColor=[UIColor blackColor];
    self.txtState.textColor=[UIColor blackColor];

    self.btnAddnewAddr.hidden=YES;
    
    self.addressId=@"";
}

- (IBAction)showStates:(id)sender {
            selectedState = @"AK";
        
    [self.view endEditing:YES];
        if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
        {
            UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
            pickerToolbar.barStyle = UIBarStyleBlackOpaque;
            [pickerToolbar sizeToFit];
            
            UIButton *barDoneBut=[UIButton buttonWithType:UIButtonTypeCustom];
            [barDoneBut setTitle:@"Done" forState:UIControlStateNormal];
            barDoneBut.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
            barDoneBut.frame=CGRectMake(245, 7, 70, 30);
            [barDoneBut addTarget:self action:@selector(pickerDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
            [barDoneBut setTag: 10];
            [pickerToolbar addSubview:barDoneBut];
            
            UIButton *barCancel=[UIButton buttonWithType:UIButtonTypeCustom];
            barCancel.frame=CGRectMake(5, 7, 70, 30);
            barCancel.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
            [barCancel setTitle:@"Cancel" forState:UIControlStateNormal];
            [barCancel addTarget:self action:@selector(pickercancel:) forControlEvents:UIControlEventTouchUpInside];
            [barCancel setTag: 20];
            [pickerToolbar addSubview:barCancel];
            
            pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
            pickerView.dataSource = self;
            pickerView.delegate = self;
            pickerView.showsSelectionIndicator = YES;
            
            pickerView.showsSelectionIndicator = YES;
            
            action=[[UIActionSheet alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
            [action addSubview:pickerToolbar];
            [pickerView selectRow:0 inComponent:0 animated:YES];
            [action addSubview:pickerToolbar];
            [action addSubview:pickerView];
            
            [action showInView:self.view];
            [action setBounds:CGRectMake(0, 0, 320,568)];
            return;
        }
        
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
        pickerToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerToolbar sizeToFit];
        
        UIButton *barDoneBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [barDoneBut setTitle:@"Done" forState:UIControlStateNormal];
        barDoneBut.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
        barDoneBut.frame=CGRectMake(245, 7, 70, 30);
        [barDoneBut addTarget:self action:@selector(pickerDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
        [barDoneBut setTag: 10];
        [pickerToolbar addSubview:barDoneBut];
        
        UIButton *barCancel=[UIButton buttonWithType:UIButtonTypeCustom];
        barCancel.frame=CGRectMake(5, 7, 70, 30);
        barCancel.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
        [barCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [barCancel addTarget:self action:@selector(pickercancel:) forControlEvents:UIControlEventTouchUpInside];
        [barCancel setTag: 20];
        [pickerToolbar addSubview:barCancel];
        
        UIView * layerView = [[UIView alloc] initWithFrame:CGRectMake(-7, 0, 320, 300)];
        layerView.backgroundColor = [UIColor whiteColor];
        
        [layerView addSubview:pickerToolbar];
        
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator = YES;
        
        pickerView.showsSelectionIndicator = YES;
        
        [layerView addSubview:pickerView];
        
        stateActionSheet=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n" message:@"\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        stateActionSheet.view.backgroundColor = [UIColor blueColor];
        [stateActionSheet.view addSubview:layerView];
        [self presentViewController:stateActionSheet animated:YES completion:nil];


}
-(void)pickercancel:(id)sender
{
    [self DismissStatePickerView];
}

-(void)pickerDoneClicked:(id)sender
{
    self.txtState.text=selectedState;
    [self DismissStatePickerView];

}
- (void) DismissStatePickerView
{
    if(action)
    {
        [action dismissWithClickedButtonIndex:0 animated:YES];
        action=nil;
        pickerView=nil;
        pickerView.delegate=nil;
        pickerView.dataSource=nil;
    }
    
    [stateActionSheet dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submitForNotification:(id)sender {
//    if (![self.emailText.text length]||[GlobalMethods checkWhiteSpace:self.emailText.text]) {
//        [GlobalMethods showAlertwithString:@"Please enter email"];
//        return;
//    }
//    if(![GlobalMethods isItValidEmail:_emailText.text])
//    {
//        [GlobalMethods showAlertwithString:@"Please enter valid email"];
//        return;
//    }
//    if (![self.phoneText.text length]||[GlobalMethods checkWhiteSpace:self.phoneText.text]) {
//        [GlobalMethods showAlertwithString:@"Please enter Phone Number"];
//        return;
//    }
//    if ([self.phoneText.text length]<10) {
//        [GlobalMethods showAlertwithString:@"Please enter valid Phone Number"];
//        return;
//    }
//    
//    if (![self.zipText.text length]||[GlobalMethods checkWhiteSpace:self.zipText.text]) {
//        [GlobalMethods showAlertwithString:@"Please enter zip"];
//        return;
//    }
//    if ([self.zipText.text length] <5){
//        [GlobalMethods showAlertwithString:@"Zip code must be 5 numbers"];
//        return;
//    }
    
    if (hud==nil) {
        hud = [[MBProgressHUD alloc] initWithView:appDel.nav.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    parseInt=3;
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]init];
    
    [paramDict setObject:self.txtPhoneNum.text forKey:@"phone"];
    [paramDict setObject:self.txtZip.text forKey:@"zip"];
    [paramDict setObject:[dict valueForKey:@"email"] forKey:@"email"];
    
    
    [parser parseAndGetDataForPostMethod:paramDict withUlr:@"postDeliveryRequestZip"];
    
}

- (IBAction)removeZipPopup:(id)sender {
    [self.zipcodePopupView removeFromSuperview];
}
@end
