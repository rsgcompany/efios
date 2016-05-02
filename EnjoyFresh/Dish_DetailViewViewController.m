//
//  Dish_DetailViewController.m
//  EnjoyFresh
//  
//  Created by Mohnish vardhan on 12/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "Dish_DetailViewViewController.h"
#import "UIImageView+WebCache.h"
#import "Global.h"
#import "GlobalMethods.h"
#import "NotificationViewController.h"
#import "FavouriteViewController.h"
#import "SettingViewController.h"
#import "RestaurantDetailViewController.h"


#define stars @"★★★★★"

int pos=0;
int selectedIndex=0;

@interface Dish_DetailViewViewController ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@end
UIColor *favcolor;
UIColor*unfavcolor;
NSMutableString *des;
static NSString *apiKey=@"TJqDoM0AJyeLnZYCQQJIfuyNm";
static NSString *consumerKey=@"yIPITPHBFJ7CuwN857MvtGwflwF0ViZa7D3YEa78VjW9z98tx4";


@implementation Dish_DetailViewViewController
@synthesize restLocation, distanceValue, restaurantAddress,selectedFutureDate,arrayDates,datesTable,selectedDateInExplore;
@synthesize UserFavorites, restaur, locationManager,restArray,pageFlag;
@synthesize currentDishImage, currentDishTitle, shareViewIsHidden,
currentDishTweet, currentDishRestaurant, currentDishDescription, currentDishName;

#pragma mark
#pragma mark - ViewController Life Cycle Methods
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {
        //return;
    }
    
    Detail_scroll_view.delegate=self;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:(id)self];
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        
    }
    else
    {
        [locationManager requestWhenInUseAuthorization];
        [locationManager startMonitoringSignificantLocationChanges];
    }
    
    [locationManager startUpdatingLocation];
    
    
    [self SetMapHidden : YES];
    
    [self.RestaurantMap setDelegate:self];
    //[self.RestaurantMap setShowsUserLocation: YES];
    
    CALayer * l = [Restaurant_img layer];
    
    [l setMasksToBounds:YES];
    [l setCornerRadius:Restaurant_img.frame.size.width/2];
    CALayer * l1 = [restaurant_img2 layer];
    
    [l1 setMasksToBounds:YES];
    [l1 setCornerRadius:restaurant_img2.frame.size.width/2];

    //[[UILabel appearance] setFont:[UIFont fontWithName:Regular size:14]];
    
   // dropDwnBtn.imageEdgeInsets = UIEdgeInsetsMake(17, 0, 0, 0);
//    NSString *distitle;
//    NSString *resName;
     self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);
    self.btnDropDown.layer.cornerRadius=2.0f;
    selectedIndex=0;
    currentDishName=[[NSMutableString alloc]init];
    if ([pageFlag isEqual:@"yes"]) {
        
        Dish_Header_Entree.text=[_Dish_Details_dic valueForKey:@"title"];
        currentDishName =[_Dish_Details_dic valueForKey:@"title"];
        self.rpp_btn.userInteractionEnabled=NO;
        restaur=restArray;
        }
    else {
        self.rpp_btn.userInteractionEnabled=YES;

        Dish_Header_Entree.text=[_Dish_Details_dic valueForKey:@"dish_title"];
        currentDishName =[_Dish_Details_dic valueForKey:@"dish_title"];
        restaur=[_Dish_Details_dic valueForKey:@"restaurant_details"];
    }
    dishiesReview=[[_Dish_Details_dic valueForKey:@"reviews"] mutableCopy];

    appDel.CurrentRestaurantID = [restaur valueForKey:@"restaurant_id"];
    appDel.CurrentRestaurantOwner = [restaur valueForKey:@"restaurant_title"];
    appDel.CurrentRestaurantCity = [restaur valueForKey:@"restaurant_city"];
    
    titleLbl.lineBreakMode=NSLineBreakByClipping;
    titleLbl.text=[_Dish_Details_dic valueForKey:@"dish_title"];
    Restaurant_Nme.lineBreakMode=NSLineBreakByClipping;

    [restaurant_desclbl2 setUserInteractionEnabled:YES];
    Restaurant_Nme.text=[restaur valueForKey:@"restaurant_title"];
    self.lblRestName.text=[restaur valueForKey:@"restaurant_title"];
    self.lblCityState.text=[NSString stringWithFormat:@"%@,%@",[restaur valueForKey:@"restaurant_city"],[restaur valueForKey:@"restaurant_state"]];
    Restaurant_name_Lbl2.text=Restaurant_Nme.text;
    currentDishRestaurant = [restaur valueForKey:@"restaurant_title"];
    Restaurant_desc.text=[restaur valueForKey:@"restaurant_description"];
    restaurant_desclbl2.text=Restaurant_desc.text;
    
    restaurantAddress = [restaur valueForKey:@"restaurant_description"];
    self.lblRestName.lineBreakMode=NSLineBreakByClipping;

    
    NSString *restaurantLatitude = [NSString stringWithFormat:@"%@", [restaur valueForKey:@"restaurant_lat"]]  ;
    NSString *restaurantLongitude = [NSString stringWithFormat:@"%@", [restaur valueForKey:@"restaurant_lon"]]  ;
    
    CLLocationCoordinate2D RestaurantLocation;
    RestaurantLocation.latitude = [restaurantLatitude floatValue];
    RestaurantLocation.longitude= [restaurantLongitude floatValue];

    restLocation = RestaurantLocation;
    
    CLLocationCoordinate2D UserLocation;
    UserLocation.latitude = self.RestaurantMap.userLocation.coordinate.latitude;
    UserLocation.longitude = self.RestaurantMap.userLocation.coordinate.longitude;
    
    distanceValue = [NSString stringWithFormat:@"%@",
                     [[_Dish_Details_dic valueForKey:@"restaurant_location"]
                      valueForKey:@"distance"]]  ;
    
    [self setMapLocation : UserLocation : RestaurantLocation
                         : [restaur valueForKey:@"restaurant_title"] : [restaur valueForKey:@"restaurant_owner_name"]];
    
    
    ratingONIMage.text=[NSString stringWithFormat:@"%@★",[_Dish_Details_dic valueForKey:@"dish_rating"]];
    NSString *rateStr=[NSString stringWithFormat:@"%@",[_Dish_Details_dic valueForKey:@"dish_rating"]];
    
    if ([rateStr isEqualToString:@""] || [rateStr isEqualToString:@"0"]) {
        [ratingONIMage setHidden:YES];
        
    }
    
    self.dishDesTxtView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    Selected_Btn_Display_lbl.textContainer.lineBreakMode = NSLineBreakByCharWrapping;

    [Main_Dish_img setImage:[UIImage imageNamed:@"Dish_Placeholder@2x.png"]];
    
    [Selected_Btn_Display_lbl  setTextContainerInset:UIEdgeInsetsMake(8,8, 0, 0)];

   // [Selected_Btn_Display_lbl setContentInset:UIEdgeInsetsMake(0,0, 0,-8)];
    Selected_Btn_Display_lbl.text=[_Dish_Details_dic valueForKey:@"experience_description"];
    //Selected_Btn_Display_lbl.contentInset = UIEdgeInsetsMake(20,0,0,0);
  //  yourString = [yourString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]

    des=(NSMutableString *)[[_Dish_Details_dic valueForKey:@"description"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //des=(NSMutableString *)[[_Dish_Details_dic valueForKey:@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    self.dishDesTxtView.text= des;
    currentDishDescription =des;//[_Dish_Details_dic valueForKey:@"description"];
   
    currentDishTitle = [[NSMutableString alloc] init];
    currentDishTweet = [[NSMutableString alloc] init];
    _currentTweeturl=[[NSMutableString alloc]init];

    _currentDishName1=[[NSMutableString alloc]init];
    [_currentDishName1 appendString:currentDishName];
    [currentDishTitle appendString: currentDishName];
    
    [currentDishTweet appendString:[NSString stringWithFormat:@"Yumm! craving this '%@' on @Enjoy_fresh\n",currentDishName]];
    [_currentTweeturl appendString:[_Dish_Details_dic valueForKey:@"dish_profile_url"]];
    
    
    [currentDishTitle appendString: @"\n\n"];
    [currentDishTitle appendString: currentDishDescription];
    [currentDishTitle appendString: @"\n"];

    lblF.font=[UIFont fontWithName:SemiBold size:10];
    lblT.font=[UIFont fontWithName:SemiBold size:10];
    lblM.font=[UIFont fontWithName:SemiBold size:10];
    lblE.font=[UIFont fontWithName:SemiBold size:10];
    
    shareViewIsHidden = NO;
    [self HideShareView];
    
    self.btnReadMore.titleLabel.font=[UIFont fontWithName:SemiBold size:10];
    Dish_price_lbl.font=[UIFont fontWithName:SemiBold size:16];
    price_lbl2.font=[UIFont fontWithName:SemiBold size:18];
    
    float price=[[_Dish_Details_dic valueForKey:@"price"] floatValue];
    if (price*0.20 >5) {
        price=price+5;
    }
    else{
        price=(price*0.20)+price;
    }
    
    Dish_price_lbl.text=[NSString stringWithFormat:@"$ %.2f",price];
    order_by_lbl.font=[UIFont fontWithName:Bold size:10.0f];
   // avail_by_lbl.font=[UIFont fontWithName:Bold size:12.0f];
    self.availLbl.font=[UIFont fontWithName:Bold size:10.0f];

    self.rateCount.font=[UIFont fontWithName:Regular size:13.0f];
   
    self.rateCount.text=[NSString stringWithFormat:@"(%lu)",(unsigned long)[dishiesReview count]];
    NSString *rating =[NSString stringWithFormat:@"%@",[_Dish_Details_dic valueForKey:@"dish_rating"]];
    
    self.lblRating.textColor=[UIColor colorWithRed:239/255.0f green:194/255.0f blue:74/255.0f alpha:1.0f];
    if ([rating isEqual:@"0"] || [rating isEqual:@""]) {
        [self.lblRating setHidden:YES];
        [self.lblStar setHidden:NO];
        self.lblStar.text=[stars substringToIndex:5-[rating integerValue]];
    }
    else{
        self.lblRating.text=[stars substringToIndex:[rating integerValue]];
        self.lblStar.text=[stars substringToIndex:5-[rating integerValue]];
    }

    //NSString *dateString=[NSString stringWithFormat:@"%@/%@ @ %.2ld:%.2ld %@ - %.2ld:%.2ld %@",[date objectAtIndex:1],[date objectAtIndex:2],(long)[[_Dish_Details_dic valueForKey:@"avail_by_hr"] integerValue],(long)[[_Dish_Details_dic valueForKey:@"avail_by_min"] integerValue],[_Dish_Details_dic valueForKey:@"avail_by_ampm"],(long)[[_Dish_Details_dic valueForKey:@"avail_by_hr_till"] integerValue],(long)[[_Dish_Details_dic valueForKey:@"avail_by_min_till"] integerValue],[_Dish_Details_dic valueForKey:@"avail_by_ampm_till"]];
    
    price_lbl2.text=Dish_price_lbl.text;
    
    self.btnSoldout.titleLabel.font=[UIFont fontWithName:SemiBold size:10.0f];
    self.btnSoldout.layer.cornerRadius=12.0f;
    self.btnSoldout.layer.borderWidth=1.0;
    self.btnSoldout.layer.borderColor=[UIColor colorWithRed:(211/255.0) green:(118/255.0) blue:(100/255.0) alpha:1].CGColor;
    
    
    if ([[_Dish_Details_dic valueForKey:@"soldout"] integerValue]==0) {
        //[Dish_Availble_Btn setUserInteractionEnabled:NO];
        //[Dish_Availble_Btn setAlpha:0.7f];
        [Dish_Order_Btn setUserInteractionEnabled:YES];
        [Dish_Order_Btn setAlpha:1.0f];
        avail_by_lbl.hidden=NO;
        self.btnSoldout.hidden=YES;
        
        NSArray*dateOrder=[[_Dish_Details_dic valueForKey:@"order_by_date"] componentsSeparatedByString:@"-"];
        
        
        NSArray*date=[[_Dish_Details_dic valueForKey:@"avail_by_date"] componentsSeparatedByString:@"-"];
        
        
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *date1=[format dateFromString:[_Dish_Details_dic valueForKey:@"avail_by_date"]];
        
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
        
        NSString *dateString;
        if ([pageFlag isEqual:@"yes"]) {
            dateString =[NSString stringWithFormat:@"%@ %@,%@ @ %.2ld:%.2ld %@ - %.2ld:%.2ld %@",[weekDay stringFromDate:date1],[calMonth stringFromDate:date1],[date objectAtIndex:2],(long)[[_Dish_Details_dic valueForKey:@"avail_by_hr"] integerValue],(long)[[_Dish_Details_dic valueForKey:@"avail_by_min"] integerValue],[_Dish_Details_dic valueForKey:@"avail_by_ampm"],(long)[[_Dish_Details_dic valueForKey:@"avail_until_hr"] integerValue],(long)[[_Dish_Details_dic valueForKey:@"avail_until_min"] integerValue],[_Dish_Details_dic valueForKey:@"avail_until_ampm"]];
        }
        else{
            dateString =[NSString stringWithFormat:@"%@ %@,%@ @ %.2ld:%.2ld %@ - %.2ld:%.2ld %@",[weekDay stringFromDate:date1],[calMonth stringFromDate:date1],[date objectAtIndex:2],(long)[[_Dish_Details_dic valueForKey:@"avail_by_hr"] integerValue],(long)[[_Dish_Details_dic valueForKey:@"avail_by_min"] integerValue],[_Dish_Details_dic valueForKey:@"avail_by_ampm"],(long)[[_Dish_Details_dic valueForKey:@"avail_by_hr_till"] integerValue],(long)[[_Dish_Details_dic valueForKey:@"avail_by_min_till"] integerValue],[_Dish_Details_dic valueForKey:@"avail_by_ampm_till"]];
        }
        
        avail_by_lbl.text=dateString;
        
        datesArray=[[NSMutableArray alloc]init];
        arrayDates=[_Dish_Details_dic valueForKey:@"future_available_dates"];
       
        if (selectedDateInExplore!=nil) {
            NSLog(@"%@",selectedDateInExplore);
            NSPredicate *pred1=[NSPredicate predicateWithFormat:@"avail_by_date == %@",selectedDateInExplore];
            NSArray *arr=[arrayDates filteredArrayUsingPredicate:pred1];
            NSDictionary *dateDict=[arr objectAtIndex:0];
            NSDate *date=[format dateFromString:selectedDateInExplore];
            NSArray*date1=[selectedDateInExplore componentsSeparatedByString:@"-"];
            NSString *DateString;
            DateString=[NSString stringWithFormat:@"%@ %@,%@ @ %.2ld:%.2ld %@ - %.2ld:%.2ld %@",[weekDay stringFromDate:date],[calMonth stringFromDate:date],[date1 objectAtIndex:2],(long)[[dateDict valueForKey:@"avail_by_hr"] integerValue],(long)[[dateDict valueForKey:@"avail_by_min"] integerValue],[dateDict valueForKey:@"avail_by_ampm"],(long)[[dateDict valueForKey:@"avail_till_hr"] integerValue],(long)[[dateDict valueForKey:@"avail_till_min"] integerValue],[dateDict valueForKey:@"avail_till_ampm"]];
            appDel.dateSelected=DateString;
            appDel.dateSelectedId=[dateDict valueForKey:@"availability_id"];
            avail_by_lbl.text=DateString;
            NSUInteger originalIndex = [arrayDates indexOfObject:dateDict];
            selectedIndex=(int)originalIndex;

        }
        for (NSDictionary *dic in arrayDates) {
            NSDate *date=[format dateFromString:[dic valueForKey:@"avail_by_date"]];
            NSArray*date1=[[dic valueForKey:@"avail_by_date"] componentsSeparatedByString:@"-"];

            NSString *futureDateString;
            futureDateString=[NSString stringWithFormat:@"%@ %@,%@ @ %.2ld:%.2ld %@ - %.2ld:%.2ld %@",[weekDay stringFromDate:date],[calMonth stringFromDate:date],[date1 objectAtIndex:2],(long)[[dic valueForKey:@"avail_by_hr"] integerValue],(long)[[dic valueForKey:@"avail_by_min"] integerValue],[dic valueForKey:@"avail_by_ampm"],(long)[[dic valueForKey:@"avail_till_hr"] integerValue],(long)[[dic valueForKey:@"avail_till_min"] integerValue],[dic valueForKey:@"avail_till_ampm"]];
            [datesArray addObject:futureDateString];
        }
    }else{
        self.btnDropDown.hidden=YES;
        avail_by_lbl.hidden=YES;
        self.drpImage.hidden=YES;
        self.btnSoldout.hidden=NO;
        [Dish_Order_Btn setAlpha:1.0f];
        [Dish_Order_Btn setBackgroundColor:[UIColor colorWithRed:211/255.0f green:118/255.0f blue:100/255.0f alpha:1.0f]];
        [Dish_Order_Btn setTitle:@"SOLD OUT - NOTIFY ME" forState:UIControlStateNormal];
        Dish_Order_Btn.titleLabel.font=[UIFont fontWithName:SemiBold size:13.0f];

    }
    if ([[_Dish_Details_dic valueForKey:@"future_available_dates"] count]==1) {
        self.btnDropDown.hidden=YES;
        self.drpImage.hidden=YES;
    }
    currentDishImage=[UIImage imageNamed:@"Dish_Placeholder.png"];
    
    if (![dishiesReview count]) {
        [reviewTbl setHidden:YES];
        [Detail_scroll_view setContentSize:CGSizeMake(0, 665)];

        
    }else{
        [Noreview_Lbl setHidden:YES];
        [Detail_scroll_view setContentSize:CGSizeMake(0, 665)];

        if ([dishiesReview count]==1) {
        review_lbl.text=[NSString stringWithFormat:@"( %.2lu )",(unsigned long)[dishiesReview count]  ];
        }else
        review_lbl.text=[NSString stringWithFormat:@"( %.2lu )",(unsigned long)[dishiesReview count]  ];
        
    }

    [self performSelectorInBackground:@selector(getResImage) withObject:nil];
    [self performSelectorInBackground:@selector(getImages) withObject:nil];


    Dish_Header_Entree.font=[UIFont fontWithName:Regular size:16];
    
    Restaurant_Nme.font=[UIFont fontWithName:Bold size:14.0f];
    avail_by_lbl.font=[UIFont fontWithName:SemiBold size:11.50f];
    self.lblCityState.font=[UIFont fontWithName:SemiBold size:12];

    Restaurant_name_Lbl2.font=[UIFont fontWithName:SemiBold size:15];
    Selected_Btn_Display_lbl.font=[UIFont fontWithName:Regular size:13];
    self.dishDesTxtView.font=[UIFont fontWithName:Regular size:13];
    Restaurant_desc.font=[UIFont fontWithName:Regular size:16];
    restaurant_desclbl2.font=[UIFont fontWithName:Regular size:16];
    ratingONIMage.font=[UIFont fontWithName:SemiBold size:20];
    
    Dish_Order_Btn.titleLabel.font=[UIFont fontWithName:Bold size:14.0f];
    
    Dish_Desc_Btn.titleLabel.font=[UIFont fontWithName:SemiBold size:11];
    Dish_ingrident_Btn.titleLabel.font=[UIFont fontWithName:SemiBold size:11];
    Dish_Availble_Btn.titleLabel.font=[UIFont fontWithName:SemiBold size:11];
    self.dish_reviews_btn.titleLabel.font=[UIFont fontWithName:SemiBold size:11];

    self.lblRestName.font=[UIFont fontWithName:Bold size:15];
    self.lblAddress.font=[UIFont fontWithName:Regular size:14];
    
    review_lbl.font=[UIFont fontWithName:Regular size:12];
    Rate_lbl.font=[UIFont fontWithName:SemiBold size:14];
    Noreview_Lbl.font=[UIFont fontWithName:Regular size:15];
    
    // Do any additional setup after loading the view from its nib.
    if (self.dropDownClick == YES) {
        [self selectDateClicked:self];
    }
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;

    favarr =[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"FAVCount"]];
    
    unfavcolor=[UIColor lightGrayColor];
    favcolor= [UIColor colorWithRed:52/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];

    [self SetFavStatus];
    
    NSMutableAttributedString *DescriptionText =
    [[NSMutableAttributedString alloc] initWithString: @"DESCRIPTION"];
    
    [DescriptionText addAttribute:NSForegroundColorAttributeName
                             value:favcolor
                            range:NSMakeRange(0, [DescriptionText length])];
    
    [Dish_Desc_Btn setAttributedTitle: DescriptionText
                             forState:UIControlStateNormal];
    
    [self SetUnderScore : Dish_ingrident_Btn];
    [Dish_ingrident_Btn setAlpha:0.7f];
    [Dish_ingrident_Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    CGSize size=[self calculateHeightForString:des];
    
    if (size.height>75) {
        self.btnReadMore.hidden=NO;
    }
    else{
      self.btnReadMore.hidden=YES;
        [self.dishDesTxtView setFrame:CGRectMake(self.dishDesTxtView.frame.origin.x, self.dishDesTxtView.frame.origin.y, self.dishDesTxtView.frame.size.width, size.height)];
        [self.descriptinView setFrame:CGRectMake(self.descriptinView.frame.origin.x, self.descriptinView.frame.origin.y, self.descriptinView.frame.size.width, size.height+self.dishDesTxtView.frame.origin.y+20)];
        [self.dishDetailsView setFrame:CGRectMake(self.dishDetailsView.frame.origin.x, self.descriptinView.frame.origin.y+self.descriptinView.frame.size.height+15,self.dishDetailsView.frame.size.width,self.dishDetailsView.frame.size.height)];

    }
    
    //[Dish_ingrident_Btn setTitleColor:[UIColor colorWithRed:52/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f] forState:UIControlStateNormal];
   // Dish_ingrident_Btn.titleLabel.textColor=[UIColor colorWithRed:52/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
//    int delivery=(int)[[_Dish_Details_dic valueForKey:@"is_delivery"] integerValue];
//    int pickUp=(int)[[_Dish_Details_dic valueForKey:@"is_pickup"] integerValue];
    int dinein=(int)[[_Dish_Details_dic valueForKey:@"is_dinein"] integerValue];
    if ([[_Dish_Details_dic valueForKey:@"soldout"] integerValue]==0) {
        if (dinein == 1) {
            [Dish_Order_Btn setTitle:@"BOOK NOW" forState:UIControlStateNormal]; // To set the title
        }
        else{
            [Dish_Order_Btn setTitle:@"ORDER NOW" forState:UIControlStateNormal]; // To set the title
        }
    }

   
}

-(void)getResImage{
    
        NSDictionary *locDict1=[restaur valueForKey:@"images"];
    
            //NSDictionary *locDict1=[[restaur valueForKey:@"images"] objectAtIndex:0];
            NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLRestaurant,[restaur valueForKey:@"logo"]];
            [Restaurant_img sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"nf_placeholder_restaurant"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (image==nil) {
                    
                }else{
                    Restaurant_img.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(72,72) source:image];
                    restaurant_img2.image=Restaurant_img.image;
                    
                }
                
                //TEST
                
            }];
    
   

}
-(void)getImages{
    NSDictionary *locDict=[_Dish_Details_dic valueForKey:@"images"];
    
    
    
    id img=[_Dish_Details_dic valueForKey:@"images"];
    if ([img isKindOfClass:[NSArray class]])
    {
        NSArray *art=[_Dish_Details_dic valueForKey:@"images"];
        if ([art count]) {
            locDict=[art objectAtIndex:0];
        }
    }
    else
    {
        locDict=[_Dish_Details_dic valueForKey:@"images"];
    }
    
    NSArray *imgs=[_Dish_Details_dic valueForKey:@"images"];
    
    NSSortDescriptor *hopProfileDescriptor =[[NSSortDescriptor alloc] initWithKey:@"default"
                                ascending:NO];
    
    NSArray *descriptors = [NSArray arrayWithObjects:hopProfileDescriptor, nil];
    NSArray *sortedArrayOfDictionaries = [imgs
                                          sortedArrayUsingDescriptors:descriptors];
    if([ imgs count]<=1){
        self.rightArr.hidden=YES;
        self.leftArr.hidden=YES;
    }
    if([ locDict count]!=0)
    {
        NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURLImage,[[sortedArrayOfDictionaries objectAtIndex:0] valueForKey:@"path_lg"] ]]];
        
        UIImage *image=[UIImage imageWithData:imageData];
        currentDishImage=image;
        
        for (int i=0; i<[sortedArrayOfDictionaries count]; i++)
        {
            UIImageView *v = [[UIImageView alloc] init];
            // v.image=[UIImage imageNamed:[locDict1 objectAtIndex:i]];
            
            NSDictionary *locDict1=[sortedArrayOfDictionaries objectAtIndex:i];
            NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLImage,[locDict1 valueForKey:@"path_lg"]];
            [v sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"Dish_Placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (image==nil) {
                    
                }else{
                    v.image =[GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(304,153) source:image];
                    
                }
                
            }];
            
            CGRect rect=v.frame;
            rect.origin.x=304*i;
            rect.origin.y=0;
            
            rect.size.width = 304;
            rect.size.height = 153;
            
            v.frame=rect;
            v.tag=i;
            // _contentWidth = v.frame.size.height;
            [self.scrollImg addSubview:v];
            [self.scrollImg sendSubviewToBack:v];
            
        }
        self.scrollImg.contentSize = CGSizeMake([sortedArrayOfDictionaries count]*304, 0);
        
        self.scrollImg.delegate=self;
        self.scrollImg.pagingEnabled = YES;
        
        self.pagectrl.numberOfPages=[[_Dish_Details_dic valueForKey:@"images"] count];
    }
    else{
        self.pagectrl.numberOfPages=0;
    }
    
    [self.scrollImg setPagingEnabled:YES];

}
- (void) SetUnderScore : (UIButton *) CurrentButton
{
    btnUnderScore.backgroundColor = [UIColor colorWithRed:144/255.0f green:186/255.0f blue:119/255.0f alpha:1.0f];
    
    float underScoreWidth = CurrentButton.frame.size.width;
    btnUnderScore.frame = CGRectMake(
                                     (CurrentButton.frame.origin.x) + (CurrentButton.frame.size.width - underScoreWidth)/2,
                                     CurrentButton.frame.origin.y + CurrentButton.frame.size.height-1,
                                     underScoreWidth, btnUnderScore.frame.size.height);
}

- (void) SetFavStatus
{
    NSString *restaurantID = [NSString stringWithFormat:@"%@", [restaur valueForKey:@"restaurant_id"] ];
    NSString *favStatus = [appDel.objDBClass GetFavoriteStatusForRestaurant: restaurantID];
    
    if([favStatus isEqualToString:@"Y"])
    {
        [Dish_like_btn setImage:[UIImage imageNamed:@"favoritered.png"] forState:UIControlStateNormal];
        //Dish_like_btn2.backgroundColor=favcolor;
    }
    else
    {
        [Dish_like_btn setImage:[UIImage imageNamed:@"favoritebl.png"] forState:UIControlStateNormal];
        //Dish_like_btn2.backgroundColor=unfavcolor;
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    //[self SetFavStatus];
    [super viewDidAppear:animated];

    if ([appDel.orderClickedBeforeLogin1 isEqual:@"Y"]) {
        [self Order_Btn_Clicked:self];
        appDel.orderClickedBeforeLogin1 = @"N";
        appDel.currentTagID = @"";
        
    }
}

-(void)upper_button_view_tapped{
    [[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"About %@",[[_Dish_Details_dic valueForKey:@"restaurant_details"] valueForKey:@"restaurant_title"]] message:[[_Dish_Details_dic valueForKey:@"restaurant_details"] valueForKey:@"restaurant_description"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    int rate=  [[_Dish_Details_dic valueForKey:@"dish_rating"] integerValue];
    
    for (int i=0 ; i<rate; i++) {
        UIButton *btn=(UIButton*)[self.view viewWithTag:i+1];
        [btn setTitleColor:[UIColor colorWithRed:239/255.f green:194/255.f blue:74/255.f alpha:1.0] forState:UIControlStateNormal];
    }
    if(!IS_IPHONE5){
        [Detail_scroll_view setFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-110)];
    [Detail_scroll_view setPagingEnabled:NO];
    }
    
    if (appDel.reviewSubmit==YES) {
        parseInt=2;
        NSString *urlquerystring;
        
        urlquerystring=[NSString stringWithFormat:@"getDishReviews?accessToken=%@&dishId=%@",appDel.accessToken,[_Dish_Details_dic valueForKey:@"dish_id"]];
        [parser parseAndGetDataForGetMethod:urlquerystring];
        urlquerystring=nil;
        appDel.reviewSubmit=NO;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - ScrollView Delegate Methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
    [self HideShareView];

    //self.pagectrl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}

#pragma mark
#pragma mark - ParseAndGetData Delegates
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    NSLog(@"Dish Details Result: %@", result);
    
    BOOL errMsg=[[result valueForKey:@"error"]boolValue];
    if(!errMsg)
    {
        //  NSString *str=[_Dish_Details_dic valueForKey:@"dish_id"];
        if (parseInt==2) {
           // NSLog(@"%@",)
        }
        else{
            if ([[result valueForKey:@"message"] isEqualToString:@"Dish marked as a favorite"]  ||
                [[result valueForKey:@"message"] isEqualToString:@"Dish marked as favorite"])
            {
                BOOL isThere=NO;
                [favarr addObject:[_Dish_Details_dic valueForKey:@"restaurant_id"]];
                [Dish_like_btn setImage:[UIImage imageNamed:@"favoritered.png"] forState:UIControlStateNormal];
                NSArray * favsArray = [appDel.objDBClass GetAllUserFavorites];
                NSLog(@"%@",favsArray);
                
                for (FavoritesClass *dish in favsArray) {
                    if ([[_Dish_Details_dic valueForKey:@"restaurant_id"] isEqualToString: dish.restaurant_id] && [dish.restaurant_is_favorite isEqualToString:@"N"]) {
                        isThere=YES;
                    }
                }
                if (!isThere) {
                    UserFavorites = [[FavoritesClass alloc] init];
                    
                    NSMutableArray *ImagesStringArray = [[_Dish_Details_dic valueForKey:@"restaurant_details"] valueForKey:@"images"];
                    
                    if(ImagesStringArray.count > 0)
                    {
                        NSMutableDictionary *ThumbNailImage = ImagesStringArray[0];
                        UserFavorites.restaurant_image_thumbnail = [ThumbNailImage objectForKey:@"path_th"];
                    }
                    else{
                        UserFavorites.restaurant_image_thumbnail=[[_Dish_Details_dic valueForKey:@"restaurant_details"] valueForKey:@"logo"];
                    }
                    
                    UserFavorites.restaurant_id = [NSString stringWithFormat:@"%@", [_Dish_Details_dic valueForKey:@"restaurant_id"]];
                    UserFavorites.restaurant_city = [NSString stringWithFormat:@"%@",[ [_Dish_Details_dic valueForKey:@"restaurant_details"] valueForKey:@"restaurant_city"]];
                    UserFavorites.restaurant_title = [NSString stringWithFormat:@"%@", [[_Dish_Details_dic valueForKey:@"restaurant_details"]valueForKey:@"restaurant_title"]];
                    UserFavorites.restaurant_is_favorite = @"Y";
                    
                    [appDel.objDBClass AddUserFavorite: UserFavorites];
                }
                
                
                [GlobalMethods showAlertwithString: @"Restaurant marked as favorite"];
                [appDel.objDBClass UpdateRestaurantFavorite:appDel.CurrentRestaurantID : @"Y"];
                
            }
            else{
                
                [favarr removeObject:[_Dish_Details_dic valueForKey:@"restaurant_id"]];
                
                [Dish_like_btn setImage:[UIImage imageNamed:@"favoritebl.png"] forState:UIControlStateNormal];
                
                [GlobalMethods showAlertwithString: @"Restaurant unmarked as favorite"];
                [appDel.objDBClass UpdateRestaurantFavorite:appDel.CurrentRestaurantID : @"N"];
                
            }
            [[NSUserDefaults standardUserDefaults] setObject:favarr forKey:@"FAVCount"];
            [[NSUserDefaults standardUserDefaults ] synchronize];
            
        }
    }
    
}
-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    [GlobalMethods showAlertwithString:err];
}

- (void) SetDefaultTextColors
{
    NSMutableAttributedString *DescriptionText =
    [[NSMutableAttributedString alloc] initWithString: @"DESCRIPTION"];
    
    [DescriptionText addAttribute:NSUnderlineStyleAttributeName value:
     [NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0, [DescriptionText length])];
    
    [Dish_Desc_Btn setAttributedTitle: DescriptionText
    forState:UIControlStateNormal];
    
    NSMutableAttributedString *IngridientsText =
    [[NSMutableAttributedString alloc] initWithString: @"EXPERIENCE"];
    
    [IngridientsText addAttribute:NSUnderlineStyleAttributeName value:
     [NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0, [IngridientsText length])];
    
    [Dish_ingrident_Btn setAttributedTitle: IngridientsText
                   forState:UIControlStateNormal];
    
    NSMutableAttributedString *AvailableText =
    [[NSMutableAttributedString alloc] initWithString: @"LOCATION"];
    
    [AvailableText addAttribute:NSUnderlineStyleAttributeName value:
     [NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0, [AvailableText length])];
    
    [Dish_Availble_Btn setAttributedTitle: AvailableText
                        forState:UIControlStateNormal];
    
    NSMutableAttributedString *ReviewText =
    [[NSMutableAttributedString alloc] initWithString: @"DISH REVIEWS"];
    
    [ReviewText addAttribute:NSUnderlineStyleAttributeName value:
     [NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0, [ReviewText length])];
    
    [self.dish_reviews_btn setAttributedTitle: ReviewText
                                 forState:UIControlStateNormal];
    
}

#pragma mark
#pragma mark - Button Actions


- (IBAction)Restaurant_details_btn:(id)sender {
    
    [self performSegueWithIdentifier:@"RPPSegue" sender:self];

}

- (IBAction)scrRight:(id)sender {
    NSArray *art=[_Dish_Details_dic valueForKey:@"images"];
    int count=(int)art.count;
    if(pos<count-1){pos +=1;
        [self.scrollImg setContentOffset:CGPointMake(pos*self.scrollImg.frame.size.width,0) animated:YES];

        NSLog(@"Position: %i",pos);
    }
}

- (IBAction)scrLeft:(id)sender {
    if(pos>0){ pos -=1;
        [self.scrollImg setContentOffset:CGPointMake(pos*self.scrollImg.frame.size.width,0) animated:YES];
       
        NSLog(@"Position: %i",pos);
    }
}

- (IBAction)shareClicked:(id)sender
{
    //[self shareText: currentDishTitle andImage:currentDishImage andUrl:nil];

    shareViewIsHidden = !shareViewIsHidden;
    if(shareViewIsHidden)
    {
        
        [self ShowShareView];
    }
    else
    {
        
        [self HideShareView];
    }
    
}

- (IBAction)selected_btn_display:(id)sender{
    
    [self  SetMapHidden : YES];
    
    //NSArray *colorAttribute = @[[UIColor colorWithRed:194/255.0f green:194/255.0f blue:194/255.0f alpha:1.0f]];
    
    if ([sender tag]== 10)
    {
        
        
    }
    else if([sender tag]==20)
    {
        //[self SetDefaultTextColors];
        [self.viewForMap setHidden:YES];
        [self.viewForTable setHidden:YES];
        [Selected_Btn_Display_lbl setHidden:NO];
        if (self.descriptinView.frame.size.height>141) {
            [Detail_scroll_view setContentSize:CGSizeMake(0, 670+self.descriptinView.frame.size.height-141)];
        }
        else{
            [Detail_scroll_view setContentSize:CGSizeMake(0, 670)];
        }
        
        [Dish_ingrident_Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [Dish_Availble_Btn setTitleColor:[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.dish_reviews_btn setTitleColor:[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f] forState:UIControlStateNormal];

        [Dish_ingrident_Btn setAlpha:0.7f];
        [Dish_Availble_Btn setAlpha:1.0f];
        [self.dish_reviews_btn setAlpha:1.0f];

        
        [self SetUnderScore : Dish_ingrident_Btn];
        
        Selected_Btn_Display_lbl.text=[_Dish_Details_dic valueForKey:@"experience_description"];
        
        
        
    }else if([sender tag]==30)
    {
       // [self SetDefaultTextColors];
        
        [Dish_Availble_Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [Dish_ingrident_Btn setTitleColor:[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.dish_reviews_btn setTitleColor:[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        [Dish_ingrident_Btn setAlpha:1.0f];
        [Dish_Availble_Btn setAlpha:0.7f];
        [self.dish_reviews_btn setAlpha:1.0f];
        [self.viewForMap setHidden:NO];
        [Selected_Btn_Display_lbl setHidden:YES];
        [self.viewForTable setHidden:YES];
        if (self.descriptinView.frame.size.height>141) {
             [Detail_scroll_view setContentSize:CGSizeMake(0, 810+self.descriptinView.frame.size.height-141)];
        }
        else{
        [Detail_scroll_view setContentSize:CGSizeMake(0, 810)];
        }

        [self SetUnderScore : Dish_Availble_Btn];
        
        self.lblAddress.text=[NSString stringWithFormat:@"%@, %@, %@, %@ \n%@",[restaur valueForKey:@"restaurant_address"],[restaur valueForKey:@"restaurant_city"],[restaur valueForKey:@"restaurant_state"],[restaur valueForKey:@"restaurant_zip"],[restaur valueForKey:@"restaurant_phone"]];
        
         [self  SetMapHidden : NO];
    }
    else{
        //[self SetDefaultTextColors];
        [Selected_Btn_Display_lbl setHidden:YES];
        [self.viewForMap setHidden:YES];
        [self.viewForTable setHidden:NO];
        
        [self.dish_reviews_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [Dish_ingrident_Btn setTitleColor:[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [Dish_Availble_Btn setTitleColor:[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f] forState:UIControlStateNormal];
        

        [Dish_ingrident_Btn setAlpha:1.0f];
        [Dish_Availble_Btn setAlpha:1.0f];
        [self.dish_reviews_btn setAlpha:0.7f];

        if (![dishiesReview count]) {
            [reviewTbl setHidden:YES];
            
            if (self.descriptinView.frame.size.height>141) {
                [Detail_scroll_view setContentSize:CGSizeMake(0, 670+self.descriptinView.frame.size.height-141)];
            }
            else{
                [Detail_scroll_view setContentSize:CGSizeMake(0, 670)];
            }
        }
        else{
            double count=[dishiesReview count]*105;
            if (count>1000) {
                count=1000;
            }
            
            if (self.descriptinView.frame.size.height>141) {
                [Detail_scroll_view setContentSize:CGSizeMake(0, 670+self.descriptinView.frame.size.height-141+count)];
            }
            else{
                [Detail_scroll_view setContentSize:CGSizeMake(0, 652+count)];
            }
            
        }

        
        [self SetUnderScore:self.dish_reviews_btn ];
    }
}

- (IBAction)Like_Btn_Clicked:(id)sender
{
    
    if ([appDel.accessToken isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppTitle message:@"Please Login to favorite " delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES",nil];
        
        alert.tag=30;
        [alert show];
//        [[[UIAlertView alloc]initWithTitle:AppTitle message:@"Please Login to favorite " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        return;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken, @"accessToken",
                            appDel.CurrentRestaurantID,@"dishId",nil];
    
    
    NSLog(@"Rest: %@",  appDel.CurrentRestaurantID);
    [parser parseAndGetDataForPostMethod:params withUlr:@"markFavoriteDish"];
}

- (IBAction)Order_Btn_Clicked:(id)sender
{
   
    if ([[_Dish_Details_dic valueForKey:@"soldout"] integerValue]==1){
        notify =[[NotifyMeView alloc]init];
        notify.dishID=[_Dish_Details_dic valueForKey:@"dish_id"];
        
        CGRect rec=notify.view.frame;
        notify.view.frame=rec;
        [self.view addSubview:notify.view];
        [self.view bringSubviewToFront:notify.view];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:notify.view cache:YES];
        [UIView setAnimationDuration:3.0f];
        notify.view.frame=rec;
        [UIView commitAnimations];
    }
    else{
        if ([appDel.accessToken isEqualToString:@""])
        {
            
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:AppTitle message:@"Login to Order your dish" delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES", nil];
            alert.tag=20;
            [alert show];
            
            //[[[UIAlertView alloc]initWithTitle:AppTitle message:@"Login to Order your dish" delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES", nil]show]        ;
            return;
        }
        
    addTOBag=nil;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"order button clicked_iOSMobile" properties:nil];

    addTOBag=[[AddedToBag alloc]init];
    if ([pageFlag isEqual:@"yes"]) {
        [_Dish_Details_dic setValue:restArray forKey:@"restaurant_details"];
        addTOBag.Item_details=[_Dish_Details_dic copy];
        addTOBag.pageFlag=@"yes";
    }
    else {
        addTOBag.Item_details=[_Dish_Details_dic copy];
    }
        if (selectedDateInExplore==nil) {
            addTOBag.selectedFutureDate=selectedFutureDate;
        }
        else{
            addTOBag.selectedFutureDate=[datesArray objectAtIndex:selectedIndex];
            appDel.dateSelected=[datesArray objectAtIndex:selectedIndex];
            appDel.dateSelectedId=[[arrayDates objectAtIndex:selectedIndex] valueForKey:@"availability_id"];
            appDel.rememberDateFlag=YES;
        }
        addTOBag.selectedIndx=selectedIndex;

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
}
//our helper method
- (CGSize)calculateHeightForString:(NSString *)str
{
    CGSize size = CGSizeZero;
    
    UIFont *labelFont = [UIFont fontWithName:Regular size:13.5f];
    NSDictionary *systemFontAttrDict = [NSDictionary dictionaryWithObject:labelFont forKey:NSFontAttributeName];
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:str attributes:systemFontAttrDict];
    CGRect rect = [message boundingRectWithSize:(CGSize){self.dishDesTxtView.frame.size.width, MAXFLOAT}
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                        context:nil];//you need to specify the some width, height will be calculated
    
    size = CGSizeMake(rect.size.width, rect.size.height+15); //padding
    
    return size;
    
    
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    appDel.rememberDateFlag=NO;
    selectedIndex=0;
}
- (IBAction)menuBtnClicked:(id)sender
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

- (void) ShowShareView
{
    //shareButton.alpha = 0.35f;
    [self.view addSubview: shareOptionsView];
    [self.view bringSubviewToFront: shareOptionsView];
    
    shareOptionsView.frame
    = CGRectMake(0, [UIScreen mainScreen].bounds.size.height,
                 shareOptionsView.frame.size.width, shareOptionsView.frame.size.height);
    
    [UIView animateWithDuration:.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
    {
        shareOptionsView.frame
        = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - shareOptionsView.frame.size.height,
                     shareOptionsView.frame.size.width, shareOptionsView.frame.size.height);
    }
     completion:^(BOOL finished)
    {
        
         
     }];
}

- (void) HideShareView
{
    //shareButton.alpha = 1.0f;
    
    [UIView animateWithDuration:.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
     {
         shareOptionsView.frame
         = CGRectMake(0, [UIScreen mainScreen].bounds.size.height,
                      shareOptionsView.frame.size.width, shareOptionsView.frame.size.height);
     }
                     completion:^(BOOL finished)
     {
         [shareOptionsView removeFromSuperview];
         
     }];
}

- (IBAction)fbShareCiicked:(id)sender
{
    shareViewIsHidden = NO;
    [self HideShareView];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [fbSheetOBJ setInitialText: currentDishTitle];
        [fbSheetOBJ addImage: currentDishImage];
        [fbSheetOBJ addURL:[NSURL URLWithString:_currentTweeturl]];
    
        [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
    }
    else
    {
        [GlobalMethods showAlertwithString:@"You're not logged in to Facebook. Go to Device Settings > Facebook > Sign In"];
    }
}

- (IBAction)twitterShareClicked:(id)sender
{
    //TEST
   // [self TweetTweet : @"Tweet Tweet, WTF!"];
    
    shareViewIsHidden = NO;
    [self HideShareView];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheetOBJ setInitialText: currentDishTweet];
        [tweetSheetOBJ addImage: currentDishImage];
        [tweetSheetOBJ addURL: [NSURL URLWithString:_currentTweeturl]];
        
        [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
    }
    else
    {
        [GlobalMethods showAlertwithString:
         @"You're not logged in to Twitter. Go to Device Settings > Twitter > Sign In"];
    }
}


- (IBAction)emailShareClicked:(id)sender
{
    shareViewIsHidden = NO;
    [self HideShareView];
    
    MFMailComposeViewController *comp=[[MFMailComposeViewController alloc]init];
    [comp setMailComposeDelegate:self];
    if([MFMailComposeViewController canSendMail])
    {
        //[comp setToRecipients:nil];
        [comp setSubject:AppTitle];
        
        
        [comp setMessageBody:currentDishTitle isHTML:NO];
        
        
        NSMutableString *htmlMsg = [NSMutableString string];
        [htmlMsg appendString:@"<html><body><p>"];
        [htmlMsg appendString: @"Hey there! Check out this dish - "];
        [htmlMsg appendString: currentDishName];
        [htmlMsg appendString: @", available at "];
        [htmlMsg appendString: currentDishRestaurant];
        [htmlMsg appendString: @"</p> <p>"];
        [htmlMsg appendString: @"About the dish: "];
        [htmlMsg appendString: currentDishDescription];
        [htmlMsg appendString:[NSString stringWithFormat:@"\n%@",_currentTweeturl]];
        [htmlMsg appendString:@" </p></body></html>"];
        
        NSData *jpegData = UIImageJPEGRepresentation(currentDishImage, 1);
        
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



- (IBAction)msgShareClicked:(id)sender
{
    shareViewIsHidden = NO;
    [self HideShareView];
    
    if(![MFMessageComposeViewController canSendText])
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = (id)self;
    [messageController setRecipients:recipents];
    [_currentDishName1 appendString:[NSString stringWithFormat:@" %@",_currentTweeturl]];
    [messageController setBody:_currentDishName1];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectDateClicked:(id)sender {
    
    NSLog(@"select date clicked");
    if (datesView==nil) {
        long height=0;
        if ([datesArray count] >3) {
            height=93;
        }
        else{
            height=height+[datesArray count]*31;
        }
        datesView=[[UIView alloc]initWithFrame:CGRectMake(self.btnDropDown.frame.origin.x, self.btnDropDown.frame.origin.y+27, self.btnDropDown.frame.size.width, height)];
        datesTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, datesView.frame.size.width, height)];
        datesTable.backgroundColor= [UIColor whiteColor];
        datesView.backgroundColor= [UIColor whiteColor];        
        

        datesTable.separatorColor = [UIColor clearColor];
        datesView.layer.borderWidth=1.0f;
        datesView.layer.borderColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f].CGColor;
        [datesView addSubview:datesTable];
        [Detail_scroll_view addSubview:datesView];
        [datesTable sendSubviewToBack:datesTable];
        self.drpImage.image=[UIImage imageNamed:@"Dropdownup.png"];

        datesTable.delegate=(id)self;
        datesTable.dataSource=(id)self;
        [datesTable performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:1];

    }
    else{
        self.drpImage.image=[UIImage imageNamed:@"Dropdown.png"];

        [datesView removeFromSuperview];
        datesView=nil;
    }

    
  /*  if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
        pickerToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerToolbar sizeToFit];
        
        UIButton *barDoneBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [barDoneBut setTitle:@"Done" forState:UIControlStateNormal];
        barDoneBut.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
        barDoneBut.frame=CGRectMake(245, 7, 70, 30);
        [barDoneBut addTarget:self action:@selector(pickerDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
        [barDoneBut setTag:[sender tag]];
        [pickerToolbar addSubview:barDoneBut];
        
        UIButton *barCancel=[UIButton buttonWithType:UIButtonTypeCustom];
        barCancel.frame=CGRectMake(5, 7, 70, 30);
        barCancel.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
        [barCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [barCancel addTarget:self action:@selector(pickercancel:) forControlEvents:UIControlEventTouchUpInside];
        [barCancel setTag:[sender tag]];
        [pickerToolbar addSubview:barCancel];
        
        action=[[UIActionSheet alloc]initWithFrame:CGRectMake(0, 0, 320, 280)];
        [action addSubview:pickerToolbar];
        pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
        pickerview.dataSource = (id)self;
        pickerview.delegate = (id)self;
        pickerview.showsSelectionIndicator = YES;
        [action addSubview:pickerview];
        
        [action showInView:self.view];
        [action setBounds:CGRectMake(0, 0, 320,568)];
        
        return;

    }
    else
        {
            UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
            pickerToolbar.barStyle = UIBarStyleBlackOpaque;
            [pickerToolbar sizeToFit];
            
            UIButton *barDoneBut=[UIButton buttonWithType:UIButtonTypeCustom];
            [barDoneBut setTitle:@"Done" forState:UIControlStateNormal];
            barDoneBut.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
            barDoneBut.frame=CGRectMake(245, 7, 70, 30);
            [barDoneBut addTarget:self action:@selector(pickerDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
            [barDoneBut setTag:[sender tag]];
            [pickerToolbar addSubview:barDoneBut];
            
            UIButton *barCancel=[UIButton buttonWithType:UIButtonTypeCustom];
            barCancel.frame=CGRectMake(5, 7, 70, 30);
            barCancel.titleLabel.font=[UIFont fontWithName:SemiBold size:14.0f];
            [barCancel setTitle:@"Cancel" forState:UIControlStateNormal];
            [barCancel addTarget:self action:@selector(pickercancel:) forControlEvents:UIControlEventTouchUpInside];
            [barCancel setTag:[sender tag]];
            [pickerToolbar addSubview:barCancel];
            
            _layerView = [[UIView alloc] initWithFrame:CGRectMake(-7, 0, 320, 300)];
            _layerView.backgroundColor = [UIColor whiteColor];
            action=[[UIActionSheet alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
            [action addSubview:pickerToolbar];
            [_layerView addSubview:pickerToolbar];
            pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
            pickerview.dataSource = self;
            pickerview.delegate = self;
            pickerview.showsSelectionIndicator = YES;
            [action addSubview:pickerview];
            [_layerView addSubview:pickerview];
            
            _searchActionSheet=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n" message:@"\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
            _searchActionSheet.view.backgroundColor = [UIColor whiteColor];
            //[_searchActionSheet.view setBounds:CGRectMake(20, 180, self.view.frame.size.width, 470)];
            //[_layerView setBounds:_searchActionSheet.view.bounds];
            [_searchActionSheet.view addSubview:_layerView];
            
            [self presentViewController:_searchActionSheet animated:YES completion:nil];
        }*/
        
    

}
BOOL moreFlag=NO;

- (IBAction)readMore:(id)sender {
    if (moreFlag==NO) {
        CGSize size=[self calculateHeightForString:des];
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self.dishDesTxtView setFrame:CGRectMake(self.dishDesTxtView.frame.origin.x, self.dishDesTxtView.frame.origin.y, self.dishDesTxtView.frame.size.width, size.height)];
                             [self.descriptinView setFrame:CGRectMake(self.descriptinView.frame.origin.x, self.descriptinView.frame.origin.y, self.descriptinView.frame.size.width, size.height+self.dishDesTxtView.frame.origin.y+20)];
                             [self.dishDetailsView setFrame:CGRectMake(self.dishDetailsView.frame.origin.x, self.descriptinView.frame.origin.y+self.descriptinView.frame.size.height+15,self.dishDetailsView.frame.size.width,self.dishDetailsView.frame.size.height)];
                             [self.btnReadMore setFrame:CGRectMake(self.btnReadMore.frame.origin.x, self.descriptinView.frame.size.height-self.btnReadMore.frame.size.height, self.btnReadMore.frame.size.width, self.btnReadMore.frame.size.height)];
                             [Detail_scroll_view setContentSize:CGSizeMake(320, Detail_scroll_view.contentSize.height+self.descriptinView.frame.size.height)];
                         }
                         completion:^(BOOL finished){
                             
                         }
         ];
        moreFlag=YES;
        [self.btnReadMore setTitle:@"SHOW LESS" forState:UIControlStateNormal];

    }
    else{
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self.dishDesTxtView setFrame:CGRectMake(self.dishDesTxtView.frame.origin.x, self.dishDesTxtView.frame.origin.y, self.dishDesTxtView.frame.size.width, 80)];
                             [self.descriptinView setFrame:CGRectMake(self.descriptinView.frame.origin.x, self.descriptinView.frame.origin.y, self.descriptinView.frame.size.width, 140)];
                             [self.dishDetailsView setFrame:CGRectMake(self.dishDetailsView.frame.origin.x, self.descriptinView.frame.origin.y+self.descriptinView.frame.size.height+15,self.dishDetailsView.frame.size.width,self.dishDetailsView.frame.size.height)];
                             [self.btnReadMore setFrame:CGRectMake(self.btnReadMore.frame.origin.x, self.descriptinView.frame.size.height-self.btnReadMore.frame.size.height, self.btnReadMore.frame.size.width, self.btnReadMore.frame.size.height)];
                             [Detail_scroll_view setContentSize:CGSizeMake(320, Detail_scroll_view.contentSize.height-self.descriptinView.frame.size.height+141)];

                         }
                         completion:^(BOOL finished){
                             
                         }
         ];
        moreFlag=NO;
        [self.btnReadMore setTitle:@"READ MORE" forState:UIControlStateNormal];

    }
   
}

#pragma mark -
#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==datesTable) {
        return datesArray.count;
    }
    else{
        return [dishiesReview count];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==datesTable) {
        return 30;
    }
    else{
      NSDictionary *dict =[dishiesReview objectAtIndex:indexPath.row];
      return 105;
    }
}
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==datesTable) {
        static NSString *simpleTableIdentifier = @"SimpleTableCell";
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(147/255.0) green:(188/255.0) blue:(118/255.0) alpha:1];
        cell.selectedBackgroundView = selectionColor;
        if (selectedIndex==(int)indexPath.row) {
            cell.backgroundColor=[UIColor colorWithRed:(148/255.0) green:(187/255.0) blue:(118/255.0) alpha:1];
            cell.textLabel.textColor=[UIColor whiteColor];
        }
        else {
            cell.backgroundColor=[UIColor whiteColor];
            cell.textLabel.textColor=[UIColor blackColor];
        }
        cell.textLabel.text=[datesArray objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont fontWithName:SemiBold size:11];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];

        
        return cell;

    }
    else{
        
        static NSString *cellIdentifier = @"CellIdentifier";
        
        ReviewCustomCell *cell = (ReviewCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewCustomCell" owner:self options:nil];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.contentView.backgroundColor=[UIColor whiteColor];
        cell.Name.text=[NSString stringWithFormat:@"%@ %@",[[dishiesReview objectAtIndex:indexPath.row] valueForKey:@"first_name"],[[dishiesReview objectAtIndex:indexPath.row] valueForKey:@"last_name"]];
        
        NSString *strindate=[NSString stringWithFormat:@"%@",[[dishiesReview objectAtIndex:indexPath.row] valueForKey:@"date_added"]];
        
        NSArray*sa=[strindate componentsSeparatedByString:@" "];
        if ([sa count]==2) {
            
            // NSArray *date=[[sa objectAtIndex:0] componentsSeparatedByString:@"-"];
            // NSArray *time=[[sa objectAtIndex:1] componentsSeparatedByString:@":"];
            cell.review_date.text=[NSString stringWithFormat:@"%@",[sa objectAtIndex:0]];
        }
        cell.User_review.text=[NSString stringWithFormat:@"%@",[[dishiesReview objectAtIndex:indexPath.row] valueForKey:@"review"]];
        NSString *rating =[NSString stringWithFormat:@"%@",[[dishiesReview objectAtIndex: indexPath.row]valueForKey:@"rating"]];
        
        cell.review_rgt.textColor=[UIColor colorWithRed:239/255.0f green:194/255.0f blue:74/255.0f alpha:1.0f];
        if ([rating isEqual:@"0"]) {
            [cell.review_rgt setHidden:YES];
            [cell.lblStar setHidden:YES];
        }
        else
        {
            [cell.review_rgt setHidden:NO];
            [cell.lblStar setHidden:NO];
            cell.review_rgt.text=[stars substringToIndex:[rating integerValue]];
            cell.lblStar.text=[stars substringToIndex:5-[rating integerValue]];
        }
        
        
        
        NSString *disturlStr=[NSString stringWithFormat:@"%@%@",UserURlImge,[[dishiesReview objectAtIndex:indexPath.row ] valueForKey:@"image"]];
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"user_pic.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image==nil) {
                
            }else{
                cell.userImage.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(72,72) source:image];
                cell.userImage.image=image;
            }
            
        }];
        
        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (datesTable) {
        selectedIndex=(int)indexPath.row;
        selectedFutureDate=[datesArray objectAtIndex:indexPath.row];
        avail_by_lbl.text=[datesArray objectAtIndex:indexPath.row];
        self.drpImage.image=[UIImage imageNamed:@"Dropdown.png"];
        appDel.dateSelected=selectedFutureDate;
        appDel.dateSelectedId=[[arrayDates objectAtIndex:indexPath.row] valueForKey:@"availability_id"];
        appDel.rememberDateFlag=YES;
       [datesView removeFromSuperview];
        selectedDateInExplore=nil;
        datesView=nil;
    }
    else{
    [self performSegueWithIdentifier:@"commentsSegue" sender:indexPath];
    }

}
-(void)viewDidLayoutSubviews
{
    if ([datesTable  respondsToSelector:@selector(setSeparatorInset:)]) {
        [datesTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([datesTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [datesTable setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -
#pragma mark - PickerView DataSOurces
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return datesArray.count;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [datesArray objectAtIndex:row];
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
    
    
    tView.text=[datesArray objectAtIndex:row];
        // Fill the label text here
    
        return tView;
    
}
#pragma mark -
#pragma mark - PickerView Delegates
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    avail_by_lbl.text=[datesArray objectAtIndex:row];
}


-(void)pickercancel:(id)sender
{
   
    [_searchActionSheet dismissViewControllerAnimated: YES completion:nil];
}
-(void)pickerDoneClicked:(id)sender
{
    [_searchActionSheet dismissViewControllerAnimated: YES completion:nil];

}
#pragma mark
#pragma mark - DropDown Delegates
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
            [self performSegueWithIdentifier:@"OrderHistorySegue" sender:self];
        }else if (myIndexPath.row == 5) {
            [self performSegueWithIdentifier:@"favoriteSegue" sender:self];
        }else if (myIndexPath.row == 6) {
            [self composeMail];
        }else if (myIndexPath.row == 7) {
            [self performSegueWithIdentifier:@"HowItWorks" sender:self];
        }else if (myIndexPath.row == 8) {
            [self performSegueWithIdentifier:@"FAQSegue" sender:self];
        }else if (myIndexPath.row == 9) {
            [self performSegueWithIdentifier:@"aboutSegue" sender:self];
        }
        else if (myIndexPath.row == 10) {
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
                [self performSegueWithIdentifier:@"ShareSegue" sender:self];
                
            }
                break;
            case 6:
            {
                [self composeMail];
                
            }
                break;
            case 10:
            {
                [self performSegueWithIdentifier:@"LogInSegue" sender:self];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserProfile"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                [appDel.objDBClass ClearUserFavoritesTable];
                [appDel.objDBClass ClearUserProfileDetails];
                [appDel.objDBClass ClearCardDetails];
                
            }
                break;
            case 9:
            {
                [self performSegueWithIdentifier:@"aboutSegue" sender:self];
                
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
            default:
                break;
        }
        if(!(myIndexPath.row==0||myIndexPath.row==3||myIndexPath.row==4))
            [self removeDropdown];
    }
    [self removeDropdown];

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
             [self performSegueWithIdentifier:@"LogInSegue" sender:self];
            //[self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self removeDropdown];
            
        }
    }
    else if (alertView.tag==20) {
        if(buttonIndex==1)
        {
            if ([pageFlag isEqual:@"yes"]){
                appDel.orderClickedBeforeLogin = @"Y";
                appDel.orderClickedBeforeLogin1 = @"Y";
            }
            else{
                appDel.orderClickedBeforeLogin = @"Y";
                appDel.orderClickedBeforeLogin1 = @"Y";
            }
            
            [self performSegueWithIdentifier:@"LogInSegue" sender:self];

            //[self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag==30) {
        if(buttonIndex==1)
        {
            appDel.favClickedBeforeLogin = @"Y";
            [self performSegueWithIdentifier:@"LogInSegue" sender:self];

           // [self.navigationController popToRootViewControllerAnimated:YES];
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


#pragma mark
#pragma mark - mapView Delegates

- (void) SetMapHidden : (BOOL) IsHidden
{
    self.RestaurantMap.hidden = IsHidden;
}

-(float)kilometersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to  {
    
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    CLLocationDistance dist = [userloc distanceFromLocation:dest]/1000/1.5;
    
    
    
    //NSLog(@"%f",dist);
    NSString *distance = [NSString stringWithFormat:@"%.02f", (float) dist];
    
    return [distance floatValue];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        userLoc = currentLocation.coordinate;
    }
    
    [locationManager stopUpdatingLocation];
}

MKMapPoint userPoint;
MKMapPoint annotationPoint;
MKMapPoint samplePoint;

CLLocationCoordinate2D userLoc;
CLLocationCoordinate2D restLoc;
CLLocationCoordinate2D sampleLoc;

- (void) setMapLocation : (CLLocationCoordinate2D) UserLocation : (CLLocationCoordinate2D) RestaurantLocation : (NSString *) RestaurantTitle : (NSString *) MealTitle
{
    CLLocationDistance distance = [self kilometersfromPlace:UserLocation andToPlace:RestaurantLocation];
    //TEST
//    distance = [self kilometersfromPlace: CLLocationCoordinate2DMake(37.7, -122.4)
//                              andToPlace:RestaurantLocation];
    //distanceValue = [NSString stringWithFormat:@"%.01f", (float) distance];
    
    // Make map points
    //userLoc = UserLocation;
    restLoc = RestaurantLocation;
    
    userPoint = MKMapPointForCoordinate(UserLocation);
    annotationPoint = MKMapPointForCoordinate(RestaurantLocation);
    
    samplePoint = MKMapPointForCoordinate(CLLocationCoordinate2DMake(51.49795, -0.174056));
    sampleLoc = CLLocationCoordinate2DMake(37.1, -122.3);
    sampleLoc = userLoc;
    // Make map rects with 0 size
    MKMapRect userRect = MKMapRectMake(userPoint.x, userPoint.y, 0, 0);
    MKMapRect annotationRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
    MKMapRect sampleRect = MKMapRectMake(samplePoint.x, samplePoint.y, 0, 0);
    
    // Make union of those two rects
    MKMapRect unionRect = MKMapRectUnion(userRect, annotationRect);
    unionRect = MKMapRectUnion(userRect, sampleRect);
    // You have the smallest possible rect containing both locations
    MKMapRect unionRectThatFits = [self.RestaurantMap mapRectThatFits:unionRect];
    //[self.RestaurantMap setVisibleMapRect:unionRectThatFits animated:YES];

    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
    myAnnotation.coordinate = RestaurantLocation;
    //myAnnotation.title = RestaurantTitle;
    //myAnnotation.subtitle = MealTitle;
    
    //[self.RestaurantMap addAnnotation:myAnnotation];
    
    MapViewAnnotation *mapAnnotationView = [[MapViewAnnotation alloc] initWithTitle:RestaurantTitle
                                                                      AndCoordinate:restLocation];
    
    [self.RestaurantMap addAnnotation:mapAnnotationView];
    
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(RestaurantLocation, 1000, 1000);
    [self.RestaurantMap setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MapViewAnnotation class]])
    {
        MapViewAnnotation *mapViewAnno = (MapViewAnnotation *) annotation;
        
        
        
        MKAnnotationView *annoView = [self.RestaurantMap dequeueReusableAnnotationViewWithIdentifier:@"MapViewAnnotation"];
        
        if(!annoView)
        {
            annoView = mapViewAnno.annotatioView;
        }
        else
        {
            annoView.annotation = annotation;
        }
       
        [mapViewAnno.annotationButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [mapViewAnno SetDistanceAndAddress : annoView : restaurantAddress : distanceValue];
       
        return annoView;
        
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            //pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"vegan@2x.png"];
            pinView.calloutOffset = CGPointMake(0, 12);
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(restLocation, 1000, 1000);
    [self.RestaurantMap setRegion:region];
}

- (void) TweetTweet : (NSString *) Tweet
{
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:apiKey
                                                 consumerSecret:consumerKey
                                                oauthToken: @"237666806-1T5u3o1ABMYgqxTPubXerFvf3VCTclVcdqge841W"
                                               oauthTokenSecret: @"3CZtmJuJTsayNrWWbFPRP2J0Q6SAeHjdkCAp4zfFabtHZ"];
    
   

    [self.twitter postStatusUpdate: @"King of Kings!"
            inReplyToStatusID:nil
                     latitude:nil
                    longitude:nil
                      placeID:nil
           displayCoordinates:nil
                     trimUser:nil
    successBlock:^(NSDictionary *status)
    {
        NSLog(@"status %@", status);
    }
                    errorBlock:^(NSError *error)
    {
        NSLog(@"error %@", error);
    }];
}

-(IBAction)buttonTouched:(id)sender
{
    NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    if ([[UIApplication sharedApplication] canOpenURL:testURL])
    {
//        NSString *directionsRequest = @"comgooglemaps-x-callback://" +
//        @"?daddr=John+F.+Kennedy+International+Airport,+Van+Wyck+Expressway,+Jamaica,+New+York" +
//        @"&x-success=sourceapp://?resume=true&x-source=AirApp";
        
        NSMutableString *URLString = [[NSMutableString alloc] init];
        [URLString appendString:@"comgooglemaps-x-callback://?saddr="];
        [URLString appendString: [NSString stringWithFormat:@"%f", userLoc.latitude]];
        [URLString appendString:@","];
        [URLString appendString: [NSString stringWithFormat:@"%f", userLoc.longitude]];
        [URLString appendString:@"&daddr="];
        [URLString appendString: [NSString stringWithFormat:@"%f", restLoc.latitude]];
        [URLString appendString:@","];
        [URLString appendString: [NSString stringWithFormat:@"%f", restLoc.longitude]];
        [URLString appendString:@"&x-success=sourceapp://"];
        
        NSLog(@"%@", URLString);
        NSURL *directionsURL = [NSURL URLWithString:URLString];
        [[UIApplication sharedApplication] openURL:directionsURL];
    }
    else
    {
        NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
    }
    
//    UIWebView *webview=[[UIWebView alloc]initWithFrame:self.view.frame];
//    NSMutableString *URLString = [[NSMutableString alloc] init];
//    [URLString appendString:@"comgooglemaps-x-callback://?saddr="];
//    [URLString appendString: [NSString stringWithFormat:@"%f", samplePoint.x]];
//    [URLString appendString:@","];
//    [URLString appendString: [NSString stringWithFormat:@"%f", samplePoint.y]];
//    [URLString appendString:@"&daddr"];
//    [URLString appendString: [NSString stringWithFormat:@"%f", annotationPoint.x]];
//    [URLString appendString:@","];
//    [URLString appendString: [NSString stringWithFormat:@"%f", annotationPoint.y]];
//     [URLString appendString:@"&x-success=sourceapp://"];
//    
//    //NSURL *URL = [NSURL URLWithString:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f"];
//
//    NSURL *nsurl=[NSURL URLWithString:URLString];
//    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//    [webview loadRequest:nsrequest];
//    [webview setHidden:YES];
//    [self.view addSubview:webview];
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    

    url = [NSURL URLWithString:@"www.EnjoyFresh.com"];
    [sharingItems addObject:url];
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    
    activityController.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                                 UIActivityTypePrint,
                                                 UIActivityTypeAssignToContact,
                                                 UIActivityTypeAddToReadingList,
                                                 UIActivityTypePostToTencentWeibo,
                                                 UIActivityTypeAirDrop];
    
    
    [self presentViewController:activityController animated:YES completion:nil];
    
    [activityController setCompletionHandler:^(NSString *act, BOOL done)
     {
         NSString *ServiceMsg = nil;
         if ( [act isEqualToString:UIActivityTypeMail] )           ServiceMsg = @"Email Sent Successfully!";
         if ( [act isEqualToString:UIActivityTypePostToTwitter] )  ServiceMsg = @"Successfully Tweeted!";
         if ( [act isEqualToString:UIActivityTypePostToFacebook] ) ServiceMsg = @"Successfully Shared on Facebook!";
         if ( [act isEqualToString:UIActivityTypeMessage] )        ServiceMsg = @"SMS Sent Successfully!";
         if ( done )
         {
             [GlobalMethods showAlertwithString: ServiceMsg];
         }
     }];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController
         itemForActivityType:(NSString *)activityType
{
    if ([activityType isEqualToString:UIActivityTypePostToFacebook])
    {
        return @"Twitter";
    }
    else if ([activityType isEqualToString:UIActivityTypePostToTwitter])
    {
        return @"FB";
    }
    else
    {
        return nil;
    }
}


#pragma mark -
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RPPSegue"]) {
        RestaurantDetailViewController *controller = ([segue.destinationViewController isKindOfClass:[RestaurantDetailViewController class]]) ? segue.destinationViewController : nil;
        
        controller.restaurantArray=restaur;
    }
    if([segue.identifier isEqualToString:@"commentsSegue"]){
        CommentsViewController*comments=([segue.destinationViewController isKindOfClass:[CommentsViewController class]]) ? segue.destinationViewController : nil;
        NSIndexPath *indexPath = (NSIndexPath *)sender;

        comments.review_comments=[dishiesReview objectAtIndex: indexPath.row];
        comments.dishName=currentDishName;
        
    }
}

@end
