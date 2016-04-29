//
//  RestaurantDetailViewController.m
//  EnjoyFresh
//
//  Created by Siva  on 11/06/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "RPPTableViewCell.h"
#import "RPPDishTableViewCell.h"
#import "RPPReviewTableViewCell.h"
#import "Global.h"
#import "LoginViewController.h"
#import "Registration.h"
#import "SettingViewController.h"
#import "GlobalMethods.h"
#import "DIshesCustomCell.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "Dish_DetailViewViewController.h"
#import "NotificationViewController.h"
#import "FavouriteViewController.h"

#define  FONT_SIZE 12;
#define stars @"★★★★★"
int shareIndex;
int scrollHeight;
BOOL viewMoreFlag=NO;

//int pos=0;
#define SYSTEM_VERSION_LESS_THAN(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface RestaurantDetailViewController ()

@end

int parseInt;
int favFlag;

@implementation RestaurantDetailViewController{
    
    NSString *description;
}
@synthesize restaurantArray,shareViewIsHidden;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    if(!IS_IPHONE5)
    {
        [self.tableView setFrame:CGRectMake(0, 65, 320, 415)];
    }
    
    //map location setting
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:(id)self];
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        
    }
    else
    {
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startMonitoringSignificantLocationChanges];
    }
    
    [_locationManager startUpdatingLocation];
    
    
    [self.mapview setDelegate:self];
    
    NSString *restaurantLatitude = [NSString stringWithFormat:@"%@", [self.restaurantArray valueForKey:@"restaurant_lat"]]  ;
    NSString *restaurantLongitude = [NSString stringWithFormat:@"%@", [self.restaurantArray valueForKey:@"restaurant_lon"]]  ;
    
    CLLocationCoordinate2D RestaurantLocation;
    RestaurantLocation.latitude = [restaurantLatitude floatValue];
    RestaurantLocation.longitude= [restaurantLongitude floatValue];
    
    _restLocation = RestaurantLocation;
    
    CLLocationCoordinate2D UserLocation;
    UserLocation.latitude = self.mapview.userLocation.coordinate.latitude;
    UserLocation.longitude = self.mapview.userLocation.coordinate.longitude;
    
    _distanceValue = [NSString stringWithFormat:@"%@",
                     [[self.restaurantArray valueForKey:@"restaurant_location"]
                      valueForKey:@"distance"]]  ;
    
    [self setMapLocation : UserLocation : RestaurantLocation: [self.restaurantArray valueForKey:@"restaurant_title"] : [self.restaurantArray valueForKey:@"restaurant_owner_name"]];
    
   // [self setMapLocation:UserLocation :RestaurantLocation :[self.restaurantArray valueForKey:@"restaurant_title"] :[self.restaurantArray valueForKey:@"restaurant_owner_name"] forView:self.mapLView];

    
    favarr =[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"FAVCount"]];

    detailsDict=[[NSDictionary alloc]init];
    dishes=[[NSArray alloc]init];
    reviewsArray=[[NSMutableArray alloc]init];
    refinedArray=[[NSMutableArray alloc]init];
    userNamesArr=[[NSMutableArray alloc]init];
    dateaAddedArr=[[NSMutableArray alloc]init];
    dishTitles=[[NSMutableArray alloc]init];
    self.lblTitle.font=[UIFont fontWithName:Regular size:16];
    
    appDel.CurrentRestaurantID = [self.restaurantArray valueForKey:@"restaurant_id"];
    appDel.CurrentRestaurantOwner = [self.restaurantArray valueForKey:@"restaurant_title"];
    appDel.CurrentRestaurantCity = [self.restaurantArray valueForKey:@"restaurant_city"];
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    
    
    description=[[NSString alloc]initWithString:[self.restaurantArray valueForKey:@"restaurant_description"]];
    
    [self getDetails];
    
    //getting map
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:(id)self];
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        
    }
    else
    {
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startMonitoringSignificantLocationChanges];
    }
    
    [_locationManager startUpdatingLocation];
   
    shareViewIsHidden = NO;
    [self HideShareView];
    self.lblestName.lineBreakMode=NSLineBreakByClipping;

    
//    self.tableView.delegate=self;
//    self.tableView.dataSource=self;


    ////////////////////////////////
    
    
    //    UIFont *labelFont = [UIFont fontWithName:@"Noteworthy-Bold" size:12];
    //    NSDictionary *arialdict = [NSDictionary dictionaryWithObject:labelFont forKey:NSFontAttributeName];
    //
    //    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"this is just the sample example of how to calculate the dynamic height for tableview cell which is of around 7 to 8 lines. you will need to set the height of this string first, not seems to be calculated in cellForRowAtIndexPath method." attributes:arialdict];
    //
    //    array = [NSMutableArray arrayWithObjects:message, nil];
    //    NSMutableAttributedString *message_1 = [[NSMutableAttributedString alloc] initWithString:@"you will need to set the height of this string first, not seems to be calculated in cellForRowAtIndexPath method." attributes:arialdict];
    //    NSMutableAttributedString *message_2 = [[NSMutableAttributedString alloc] initWithString:@"you will need ." attributes:arialdict];
    //
    //    NSMutableAttributedString *message_3 = [[NSMutableAttributedString alloc] initWithString:@"this is just the sample example of how to calculate the dynamic height for tableview cell which is of around 7 to 8 lines. you will need to set the height of this string first, not seems to be calculated in cellForRowAtIndexPath method.to set the height of this string first, not seems to be calculated in cellForRowAtIndexPath method." attributes:arialdict];
    //    [array addObject:message_1];
    //    [array addObject:message_2];
    //    [array addObject:message_3];
    
    [self SetFavStatus:self.btnFav];

    self.btnLocation.titleLabel.font=[UIFont fontWithName:SemiBold size:12];
    self.btnReviews.titleLabel.font=[UIFont fontWithName:SemiBold size:12];
    self.btnDishes.titleLabel.font=[UIFont fontWithName:SemiBold size:12];
    [self.btnLocation setAlpha:0.7f];
    //[self.btnLocation setBackgroundColor:[UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f]];
    [self.btnLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    self.lblestName.font=[UIFont fontWithName:Bold size:14.0f];
    self.lblResAddress.font=[UIFont fontWithName:SemiBold size:13.0f];
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);

    self.lblResAddress.text=[NSString stringWithFormat:@"%@, %@, %@, %@ \n%@",[self.restaurantArray valueForKey:@"restaurant_address"],[self.restaurantArray valueForKey:@"restaurant_city"],[self.restaurantArray valueForKey:@"restaurant_state"],[self.restaurantArray valueForKey:@"restaurant_zip"],[self.restaurantArray valueForKey:@"restaurant_phone"]];

    self.lblestName.text=[self.restaurantArray valueForKey:@"restaurant_title"];
    [self.scrollView setContentSize:CGSizeMake(320, 890)];
//    [self.scrollView setPagingEnabled:YES];
    scrollHeight=self.scrollView.contentSize.height;
}



-(void)setimagesAndRatng{
    self.restImage.image=[UIImage imageNamed:@"Dish_Placeholder.png"];
    self.lblRestName.text=[self.restaurantArray valueForKey:@"restaurant_title"];
    self.lblRestName.font=[UIFont fontWithName:Bold size:12.0f];
     self.txtResDes.font=[UIFont fontWithName:Regular size:13.0f];
    
    NSDictionary *locDict1=[self.restaurantArray valueForKey:@"images"];
    if([ locDict1 count]<=1){
        self.btnleft.hidden=YES;
        self.btnRight.hidden=YES;
    }
    if([ locDict1 count]!=0)
    {
        
        for (int i=0; i<[locDict1 count]; i++)
        {
            UIImageView *v = [[UIImageView alloc] init];
            
            NSDictionary *locDict1=[[self.restaurantArray valueForKey:@"images"] objectAtIndex:i];
            NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLRestaurant,[locDict1 valueForKey:@"path_lg"]];
            [v sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"Dish_Placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (image==nil) {
                    
                }else{
                    v.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(305,200) source:image];
                    v.image=image;
                }
                
            }];
            
            CGRect rect=v.frame;
            rect.origin.x=304*i;
            rect.origin.y=0;
            
            rect.size.width = 304;
            rect.size.height = 200;
            
            v.frame=rect;
            v.tag=i;
            // _contentWidth = v.frame.size.height;
            [self.imgScroll addSubview:v];
            [self.imgScroll sendSubviewToBack:v];
            
        }
        self.imgScroll.contentSize = CGSizeMake(locDict1.count*304, 0);
        
    }
    self.txtResDes.text=[self.restaurantArray valueForKey:@"restaurant_description"];
    self.imgScroll.delegate=self;
    self.imgScroll.pagingEnabled = YES;
    
    
    [self.btnleft addTarget:self action:@selector(scrollLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRight addTarget:self action:@selector(scrollRight:) forControlEvents:UIControlEventTouchUpInside];
    
//    cell.pageCtrl.numberOfPages=[locDict1 count];
    
    NSString *rate=  [[detailsDict valueForKey:@"profile"] valueForKey:@"avg_rating"];
    
    self.lblStar.textColor=[UIColor colorWithRed:239/255.0f green:194/255.0f blue:74/255.0f alpha:1.0f];
    if ([rate integerValue]==0 || [rate isEqual:@""]) {
        [self.lblStar setHidden:YES];
        [self.lblRemStar setHidden:YES];
        
    }
    else{
        [self.lblStar setHidden:NO];
        [self.lblRemStar setHidden:NO];
        
        self.lblStar.text=[stars substringToIndex:[rate integerValue]];
        self.lblRemStar.text=[stars substringToIndex:5-[rate integerValue]];
        
    }
    
    CGSize size= [self calculateHeightForString:[self.restaurantArray valueForKey:@"restaurant_description"]];
    
    if (size.height>75) {
        self.btnReadMore.hidden=NO;
    }
    else{
        self.btnReadMore.hidden=YES;
        [self.txtResDes setFrame:CGRectMake(self.txtResDes.frame.origin.x, self.txtResDes.frame.origin.y, self.txtResDes.frame.size.width, size.height+10)];
        [self.descriptionView setFrame:CGRectMake(self.descriptionView.frame.origin.x, self.descriptionView.frame.origin.y, self.descriptionView.frame.size.width, size.height+self.txtResDes.frame.origin.y+10)];
        [self.detailsView setFrame:CGRectMake(self.detailsView.frame.origin.x, self.descriptionView.frame.origin.y+self.descriptionView.frame.size.height+15,self.detailsView.frame.size.width,self.detailsView.frame.size.height)];
        
    }

}
- (void) viewDidAppear:(BOOL)animated
{
    if (detailsDict==nil) {
        [self getDetails];
    }
}
- (void) HideShareView
{
   // shareButton.alpha = 1.0f;
    
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
- (void) ShowShareView
{
   // shareButton.alpha = 0.35f;
    [self.view addSubview: shareOptionsView];
    [self.view bringSubviewToFront: shareOptionsView];
    
    shareOptionsView.frame
    = CGRectMake(0, [UIScreen mainScreen].bounds.size.height,
                 shareOptionsView.frame.size.width, shareOptionsView.frame.size.height);
    
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
     {
         shareOptionsView.frame
         = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - shareOptionsView.frame.size.height,
                      shareOptionsView.frame.size.width, shareOptionsView.frame.size.height);
     }
                     completion:^(BOOL finished)
     {
         
     }];
}
- (CGSize)calculateHeightForString:(NSString *)str
{
    CGSize size = CGSizeZero;
    
    UIFont *labelFont = [UIFont fontWithName:Regular size:13.5f];
    NSDictionary *systemFontAttrDict = [NSDictionary dictionaryWithObject:labelFont forKey:NSFontAttributeName];
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:str attributes:systemFontAttrDict];
    CGRect rect = [message boundingRectWithSize:(CGSize){self.txtResDes.frame.size.width, MAXFLOAT}
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                        context:nil];//you need to specify the some width, height will be calculated
    
    size = CGSizeMake(rect.size.width, rect.size.height+10); //padding
    
    return size;
    
    
}
-(void)getDetails{
    
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
    NSDictionary *params= [NSDictionary dictionaryWithObjectsAndKeys:
                           [self.restaurantArray valueForKey:@"restaurant_id"], @"restaurantId",nil];
    [parser parseAndGetDataForPostMethod:params withUlr:@"getRestaurantDetails"];
    
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

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)menu_btn:(id)sender {
    
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

-(void)addToOrderBtnClicked:(id)sender
{
    
       
    int tagVal=[sender tag]-222;
    NSDictionary *dic=[dishes objectAtIndex:tagVal];
    
    appDel.currentDishId=[dic valueForKey:@"dish_id"];
    
    appDel.currentTagID = [NSString stringWithFormat:@"%li", (long) tagVal];
    
    
//    if ([appDel.accessToken isEqualToString:@""])
//    {
//       // appDel.orderClickedBeforeLogin = @"Y";
//        [[[UIAlertView alloc]initWithTitle:AppTitle message:@"Login to Order your dish" delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES", nil]show]        ;
//        return;
//    }
    
    [self performSegueWithIdentifier:@"DishDetailSegue" sender:sender];
    
}


#pragma mark -
#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.tableView) {
        return 1;
    }
    else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.tableView) {
        if (section==0) {
            return 1;
            
        }
        else {
            
            return 0;
            
        }

    }
    else if (tableView==self.dishesTable){
        return dishes.count;
    }
    else{
        return refinedArray.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView) {
        if (indexPath.section==0) {
           // NSString *rate=  [[detailsDict valueForKey:@"profile"] valueForKey:@"avg_rating"];
            
//            if ([rate integerValue]==0 || [rate isEqual:@""]) {
//                
//                return 320;
//            }
//            else
               return 358;
        }
        else  {

                return 0;
        }
    }
    else if (tableView==self.dishesTable) {
        NSString *rating =[NSString stringWithFormat:@"%@",[[dishes objectAtIndex:indexPath.row] valueForKey:@"dish_rating"]];
        if ([rating isEqual:@"0"] || [rating isEqual:@""] || [rating isEqual:@" "]) {
            return 400;
        }
        else
            return 445;
    }
    else{
        return 95;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView) {
        if (indexPath.section==0) {
            static NSString *CellIdentifier = @"RPPCell1";
            
            RPPTableViewCell *cell = (RPPTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.restaurantImg.image=[UIImage imageNamed:@"Dish_Placeholder.png"];
            cell.restName.text=[self.restaurantArray valueForKey:@"restaurant_title"];
            self.restName.font=[UIFont fontWithName:Bold size:12.0f];
            
            
            NSDictionary *locDict1=[self.restaurantArray valueForKey:@"images"];
            if([ locDict1 count]<=1){
                cell.btnLeftArr.hidden=YES;
                cell.btnRightArr.hidden=YES;
            }
            if([ locDict1 count]!=0)
            {
                
                for (int i=0; i<[locDict1 count]; i++)
                {
                    UIImageView *v = [[UIImageView alloc] init];
                    
                    NSDictionary *locDict1=[[self.restaurantArray valueForKey:@"images"] objectAtIndex:i];
                    NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLRestaurant,[locDict1 valueForKey:@"path_lg"]];
                    [v sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"Dish_Placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        if (image==nil) {
                            
                        }else{
                            v.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(305,200) source:image];
                            v.image=image;
                        }
                        
                    }];
                    
                    CGRect rect=v.frame;
                    rect.origin.x=304*i;
                    rect.origin.y=0;
                    
                    rect.size.width = 304;
                    rect.size.height = 200;
                    
                    v.frame=rect;
                    v.tag=i;
                    // _contentWidth = v.frame.size.height;
                    [cell.scroll addSubview:v];
                    [cell.scroll sendSubviewToBack:v];
                    
                }
                cell.scroll.contentSize = CGSizeMake(locDict1.count*304, 0);
                
            }
            cell.restuaranrDes.text=[self.restaurantArray valueForKey:@"restaurant_description"];
            cell.scroll.delegate=self;
            cell.scroll.pagingEnabled = YES;
            
            [cell.btnLeftArr addTarget:self action:@selector(scrollLeft:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnRightArr addTarget:self action:@selector(scrollRight:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.pageCtrl.numberOfPages=[locDict1 count];
            [cell.btnFav addTarget:self action:@selector(favClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            
            NSString *rate=  [[detailsDict valueForKey:@"profile"] valueForKey:@"avg_rating"];
            
            cell.lblRating.textColor=[UIColor colorWithRed:239/255.0f green:194/255.0f blue:74/255.0f alpha:1.0f];
            if ([rate integerValue]==0 || [rate isEqual:@""]) {
                [cell.lblRating setHidden:YES];
                [cell.lblRatingFade setHidden:YES];

            }
            else{
                [cell.lblRating setHidden:NO];
                [cell.lblRatingFade setHidden:NO];
                
                cell.lblRating.text=[stars substringToIndex:[rate integerValue]];
                cell.lblRatingFade.text=[stars substringToIndex:5-[rate integerValue]];

            }

            
            return cell;
        }
    }
        //for dishes custom cell
        
        else if (tableView==self.dishesTable) {
            static NSString *CellIdentifier = @"DishCell";
            
            RPPDishTableViewCell *cell = (RPPDishTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell.contentView.superview setClipsToBounds:YES];

            NSDictionary *dish=[dishes objectAtIndex:indexPath.row];
            cell.dishName.lineBreakMode=NSLineBreakByClipping;

            cell.dishName.text=[dish valueForKey:@"title"];
            cell.chefName.text=[[detailsDict valueForKey:@"profile"] valueForKey:@"title"];
            
            cell.chefName.lineBreakMode=NSLineBreakByClipping;

            
            [cell.orderDish setTag:indexPath.row+222];
            [cell.btnDropDown setTag:indexPath.row+222];

            [cell.orderDish addTarget:self action:@selector(addToOrderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.dishDetail addTarget:self action:@selector(addToOrderBtnClicked:)forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDropDown addTarget:self action:@selector(addToOrderBtnClicked:)forControlEvents:UIControlEventTouchUpInside];

            [cell.dishDetail setTag:indexPath.row+222];

            float price=[[dish valueForKey:@"price"] floatValue];
            if (price*0.20 >5) {
                price=price+5;
            }
            else{
                price=(price*0.20)+price;
            }
            
            cell.priceLabel.text=[NSString stringWithFormat:@"$ %.2f",price];
            if([[dish valueForKey:@"soldout"] integerValue] == 1)
            {
                cell.lblDate.hidden=YES;
                cell.btnSoldout.hidden=NO;
                cell.btnDropDown.hidden=YES;
                cell.drpImage.hidden=YES;
            }
            else{
                
                cell.lblDate.hidden=NO;
                cell.btnSoldout.hidden=YES;
                cell.btnDropDown.hidden=NO;
                cell.drpImage.hidden=NO;
                
                NSArray  *date=[[dish valueForKey:@"avail_by_date"] componentsSeparatedByString:@"-"];
                
                
                
                NSDateFormatter *format=[[NSDateFormatter alloc]init];
                [format setDateFormat:@"yyyy-MM-dd"];
                
                NSDate *date1=[format dateFromString:[dish valueForKey:@"avail_by_date"]];
                
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
                
                NSString *dateString=[NSString stringWithFormat:@"%@ %@,%@ @ %.2ld:%.2ld %@ - %.2ld:%.2ld %@",[weekDay stringFromDate:date1],[calMonth stringFromDate:date1],[date objectAtIndex:2],(long)[[dish valueForKey:@"avail_by_hr"] integerValue],(long)[[dish valueForKey:@"avail_by_min"] integerValue],[dish valueForKey:@"avail_by_ampm"],(long)[[dish valueForKey:@"avail_until_hr"] integerValue],(long)[[dish valueForKey:@"avail_until_min"] integerValue],[dish valueForKey:@"avail_until_ampm"]];
                
                cell.lblDate.text=dateString;
            }
            
            if ([[dish valueForKey:@"future_available_dates"] count]==1) {
                cell.btnDropDown.hidden=YES;
                cell.drpImage.hidden=YES;
            }
            id img=[dish valueForKey:@"images"];
            
            NSDictionary *locDict;
            if ([img isKindOfClass:[NSArray class]])
            {
                NSArray *art=[dish valueForKey:@"images"];
                if ([art count]) {
                    for (NSDictionary *dic in art) {
                        if ([[dic valueForKey:@"default"] integerValue]==1){
                            locDict=dic;
                            
                        }
                    }
                }
            }
            else
            {
                locDict=[dish valueForKey:@"images"];
            }
            cell.dishImage.image=[UIImage imageNamed:@"Dish_Placeholder"];
            
            if([ locDict count]!=0)
            {
                
                NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLImage,[locDict valueForKey:@"path_lg"]];
                
                
                [cell.dishImage sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"Dish_Placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                 {
                     if(image==nil)
                         cell.dishImage.image=[UIImage imageNamed:@"Dish_Placeholder"];
                     else
                         cell.dishImage.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(320,200) source:image];
                 }];
            }
            
            cell.resImage.image=[UIImage imageNamed:@"nf_placeholder_restaurant"];
            
           
                //NSDictionary *locDict1=[self.restaurantArray valueForKey:@"logo"];
                NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLRestaurant,[self.restaurantArray valueForKey:@"logo"]];
                [cell.resImage sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"nf_placeholder_restaurant"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (image==nil) {
                        
                    }else{
                        cell.resImage.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(72,72) source:image];
                        cell.resImage.image=image;
                    }
                    
                }];
            NSArray *ratings=[dish valueForKey:@"reviews"];
            cell.rateCount.text=[NSString stringWithFormat:@"(%lu)",(unsigned long)[ratings count]];
            [cell.share2 addTarget:self action:@selector(socailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShare addTarget:self action:@selector(socailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnShare.tag=indexPath.row;
            cell.share2.tag=indexPath.row;
            NSString *rating =[NSString stringWithFormat:@"%@",[dish valueForKey:@"dish_rating"]];
            
            cell.lblStar.textColor=[UIColor colorWithRed:239/255.0f green:194/255.0f blue:74/255.0f alpha:1.0f];
            if ([rating isEqual:@"0"] || [rating isEqual:@""]) {
               [cell.lblStar setHidden:YES];
//                [cell.lblRating setHidden:YES];
                cell.lblRating.text=[stars substringToIndex:5-[rating integerValue]];
                cell.starView.hidden=YES;
                cell.soldOutView.frame=CGRectMake(0, 256, 306, 151);
                cell.backGroundView.frame=CGRectMake(0, 0, 304, 400);
                cell.share2.hidden=NO;
                [cell.dishName setFrame:CGRectMake(8,207,230,37)];

            }
            else{
                [cell.lblRating setHidden:NO];
                [cell.lblStar setHidden:NO];
                cell.share2.hidden=YES;

                cell.lblStar.text=[stars substringToIndex:[rating integerValue]];
                cell.lblRating.text=[stars substringToIndex:5-[rating integerValue]];
                cell.starView.hidden=NO;
                [cell.dishName setFrame:CGRectMake(8,207,280,37)];

                cell.soldOutView.frame=CGRectMake(0, 296, 306, 151);
                cell.backGroundView.frame=CGRectMake(0, 0, 304,445);
            }
            //  NSArray *dateOrder=[[dish valueForKey:@"order_by_date"] componentsSeparatedByString:@"-"];
            cell.lblCityState.text=[NSString stringWithFormat:@"%@,%@",[dish  valueForKey:@"restaurant_city"],[dish valueForKey:@"restaurant_state"]];
            
            [cell setNeedsLayout];

            
            return cell;
        }

    // reviews customcell
    else{
        static NSString *CellIdentifier = @"ReviewCell";
        
        RPPReviewTableViewCell *cell = (RPPReviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.dishName_lbl.text=[dishTitles objectAtIndex:indexPath.row];
        cell.userName.text=[NSString stringWithFormat:@"%@ %@",
                            [[refinedArray objectAtIndex:indexPath.row] valueForKey:@"first_name"],[[refinedArray objectAtIndex:indexPath.row] valueForKey:@"last_name"]];
        
        NSArray  *date=[[[refinedArray objectAtIndex:indexPath.row] valueForKey:@"date_added"] componentsSeparatedByString:@" "];

        cell.commentsDate.text=[date objectAtIndex:0];
        cell.review.text=[[refinedArray objectAtIndex:indexPath.row] valueForKey:@"review"];
        cell.review.numberOfLines=0;
        
        NSString *rating =[NSString stringWithFormat:@"%@",[[refinedArray objectAtIndex: indexPath.row]valueForKey:@"rating"]];
        
        cell.review_str.textColor=[UIColor colorWithRed:239/255.0f green:194/255.0f blue:74/255.0f alpha:1.0f];
        if ([rating isEqual:@"0"]) {
            [cell.review_str setHidden:YES];
        }else
            cell.review_str.text=[stars substringToIndex:[rating integerValue]];
        
        NSString *disturlStr=[NSString stringWithFormat:@"%@%@",UserURlImge,[[refinedArray objectAtIndex:indexPath.row ] valueForKey:@"image"]];
        [cell.userProfileImage sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"user_pic.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image==nil) {
                
            }else{
                cell.userProfileImage.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(72,72) source:image];
                cell.userProfileImage.image=image;
            }
            
        }];
        
        
        return cell;
        
    }
    return nil;
}
int posit=0;

-(void)scrollRight:(id)sender{

    
    NSArray *arr=[self.restaurantArray valueForKey:@"images"];
    int count=(int)arr.count;
    if(posit<count-1){posit +=1;
        [self.imgScroll setContentOffset:CGPointMake(posit*self.imgScroll.frame.size.width,0) animated:YES];
    }
}
-(void)scrollLeft:(id)sender{

    if(posit>0){posit -=1;
        [self.imgScroll setContentOffset:CGPointMake(posit*self.imgScroll.frame.size.width,0) animated:YES];
    }
}
-(void)setAnnotaionForView:(MKMapView *)view{
   
    
   // _restaurantAddress = [self.restaurantArray valueForKey:@"restaurant_description"];
    
    
    CLLocationCoordinate2D UserLocation;
    UserLocation.latitude =  view.userLocation.coordinate.latitude;
    UserLocation.longitude =  view.userLocation.coordinate.longitude;
    
    _distanceValue = [NSString stringWithFormat:@"%@",
                      [[self.restaurantArray valueForKey:@"restaurant_location"]
                       valueForKey:@"distance"]]  ;

    NSString *restaurantLatitude = [NSString stringWithFormat:@"%@", [self.restaurantArray valueForKey:@"restaurant_lat"]]  ;
    NSString *restaurantLongitude = [NSString stringWithFormat:@"%@", [self.restaurantArray valueForKey:@"restaurant_lon"]]  ;
    
    _restaurantAddress=[NSString stringWithFormat:@"%@ %@ %@",[self.restaurantArray valueForKey:@"restaurant_title"],[self.restaurantArray valueForKey:@"restaurant_address"],[self.restaurantArray valueForKey:@"restaurant_city"]];
    
    CLLocationCoordinate2D RestaurantLocation;
    RestaurantLocation.latitude = [restaurantLatitude floatValue];
    RestaurantLocation.longitude= [restaurantLongitude floatValue];
    
    
    
    _restLocation = RestaurantLocation;
    
//    [self setMapLocation : UserLocation : RestaurantLocation
//                         : [self.restaurantArray valueForKey:@"restaurant_title"] : [self.restaurantArray valueForKey:@"restaurant_owner_name"] forView:view];

//    MapViewAnnotation *mapAnnotationView = [[MapViewAnnotation alloc] initWithTitle:address AndCoordinate:_restLocation];
//    
//    [view  addAnnotation:mapAnnotationView];
//    
//        
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(RestaurantLocation, 1000, 1000);
//    [view  setRegion:region animated:YES];
}

- (void) SetUnderScore : (UIButton *) CurrentButton
{
    _btnUnderScore.backgroundColor = [UIColor colorWithRed:144/255.0f green:186/255.0f blue:118/255.0f alpha:1.0f];
    
    float underScoreWidth = CurrentButton.frame.size.width;
    _btnUnderScore.frame = CGRectMake(
                                     (CurrentButton.frame.origin.x) + (CurrentButton.frame.size.width - underScoreWidth)/2,
                                     CurrentButton.frame.origin.y + CurrentButton.frame.size.height,
                                     underScoreWidth, _btnUnderScore.frame.size.height);
}
-(void)favClicked:(id)sender{
    
    
    
}
- (void) SetFavStatus:(UIButton *)button
{
    NSString *restaurantID = [NSString stringWithFormat:@"%@", [self.restaurantArray valueForKey:@"restaurant_id"] ];
    NSString *favStatus = [appDel.objDBClass GetFavoriteStatusForRestaurant: restaurantID];
    
    if([favStatus isEqualToString:@"Y"])
    {
        [button setImage:[UIImage imageNamed:@"favoritered.png"] forState:UIControlStateNormal];
        //Dish_like_btn2.backgroundColor=favcolor;
        favFlag=1;
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"favoritebl.png"] forState:UIControlStateNormal];
        //Dish_like_btn2.backgroundColor=unfavcolor;
        favFlag=0;
    }
}
-(void)socailBtnClicked:(id)sender{
    
    shareViewIsHidden = !shareViewIsHidden;
    
    shareIndex=(int)[sender tag];
    
    
    if(shareViewIsHidden)
    {
        [self ShowShareView];
    }
    else
    {        
        [self HideShareView];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        NSDictionary *dict=[dishes objectAtIndex:shareIndex];
        _currentDishDescription =[dict valueForKey:@"description"];
        _currentDishName =[dict valueForKey:@"dish_title"];
        
        _currentDishTitle = [[NSMutableString alloc] init];
        _currentDishTweet = [[NSMutableString alloc] init];
        _currentTweeturl=[[NSMutableString alloc] init];

        [_currentDishTitle appendString: [dict valueForKey:@"dish_title"]];
        
        [_currentDishTweet appendString:[NSString stringWithFormat:@"Yumm! craving this '%@' on @Enjoy_fresh\n",[dict valueForKey:@"dish_title"]]];
        [_currentTweeturl appendString: [dict valueForKey:@"dish_profile_url"]];
        
        
        [_currentDishTitle appendString: @"\n\n"];
        [_currentDishTitle appendString:[dict valueForKey:@"description"]];
        [_currentDishTitle appendString: @"\n"];

        NSDictionary *locDict=[dict valueForKey:@"images"];
        NSData *imageData;
        if ([locDict count]!=0) {
            imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURLImage,[[[dict valueForKey:@"images"] objectAtIndex:0] valueForKey:@"path_lg"] ]]];
            
            if(imageData == NULL || imageData == nil){
                _currentDishImage=[UIImage imageNamed:@"Dish_Placeholder.png"];
                
            }
            else{
                UIImage *image=[UIImage imageWithData:imageData];
                _currentDishImage=image;
            }
            
        }
        else{
            _currentDishImage=[UIImage imageNamed:@"Dish_Placeholder.png"];
            
        }
        _currentDishRestaurant = [dict valueForKey:@"restaurant_title"];
        });
   

}

#pragma mark -
#pragma mark - Tableview Delgates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.reviewTable){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
//        CommentsViewController*comments=
//        [[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
//        comments.review_comments=[refinedArray objectAtIndex:indexPath.row];

        [self performSegueWithIdentifier:@"commentsSegue" sender:indexPath];

    }
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==self.dishesTable){
    if (section==0) {
        self.headerForDishes.frame=CGRectMake(0, 0, 320, 45);
        self.restName.font=[UIFont fontWithName:Bold size:12.0f];
        
        self.restName.text=[NSString stringWithFormat:@"Dishes at %@",[self.restaurantArray valueForKey:@"restaurant_title"]];
        return self.headerForDishes;
        
    }
    
    }
    else if (tableView==self.reviewTable){
        self.headerForReviews.frame=CGRectMake(0,0,320,55);
        self.restName1.font=[UIFont fontWithName:Bold size:12.0f];
        
        self.restName1.text=[NSString stringWithFormat:@"%@ Reviews",[self.restaurantArray valueForKey:@"restaurant_title"]];
        //avg_rating
        int rate;
        NSString *rating=[[detailsDict valueForKey:@"profile"] valueForKey:@"avg_rating"];
        if (rating==NULL) {
            rate=0;
        }
        else{
           rate =  (int)[[[detailsDict valueForKey:@"profile"] valueForKey:@"avg_rating"] integerValue ];
        }
        self.rCount.text=[NSString stringWithFormat:@"(%lu)",(unsigned long)refinedArray.count] ;
        self.rCount.font=[UIFont fontWithName:Regular size:12];
        for (int i=0 ; i<rate; i++) {
            UIButton *btn=(UIButton*)[self.headerForReviews viewWithTag:i+1];
            [btn setTitleColor:[UIColor colorWithRed:239/255.0f green:194/255.f blue:74/255.0f alpha:1.0] forState:UIControlStateNormal];
        }
        
        return self.headerForReviews;
 
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==self.dishesTable){
        if (section==0) {
            
            return self.headerForDishes.frame.size.height;
        }
        
    }
    else if (tableView==self.reviewTable){
        return self.headerForReviews.frame.size.height;
    }
    return 0;
}

#pragma mark
#pragma mark - parse Delegtes
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    BOOL errMsg=[[result valueForKey:@"error"]boolValue];
    
    //NSString *strErrorMessage = [result valueForKey:@"message"];
    if (errMsg) {
        [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
        [hud hide:YES];
        [hud removeFromSuperview];
        hud=nil;
    }
    else if (parseInt==1){
        if ([[result valueForKey:@"message"] isEqualToString:@"Dish marked as a favorite"]  ||
            [[result valueForKey:@"message"] isEqualToString:@"Dish marked as favorite"])
        {
        
        BOOL isThere=NO;
        [favarr addObject:[self.restaurantArray valueForKey:@"restaurant_id"]];
            favFlag=1;
        NSArray * favsArray = [appDel.objDBClass GetAllUserFavorites];
        
        for (FavoritesClass *dish in favsArray) {
            if ([[self.restaurantArray valueForKey:@"restaurant_id"] isEqualToString: dish.restaurant_id] && [dish.restaurant_is_favorite isEqualToString:@"N"]) {
                isThere=YES;
            }
        }
        if (!isThere) {
            _UserFavorites = [[FavoritesClass alloc] init];
            
            NSMutableArray *ImagesStringArray = [[self.restaurantArray valueForKey:@"restaurant_details"] valueForKey:@"images"];
            
            if(ImagesStringArray.count > 0)
            {
                NSMutableDictionary *ThumbNailImage = ImagesStringArray[0];
                _UserFavorites.restaurant_image_thumbnail = [ThumbNailImage objectForKey:@"path_th"];
            }
            
            _UserFavorites.restaurant_id = [NSString stringWithFormat:@"%@", [self.restaurantArray valueForKey:@"restaurant_id"]];
            _UserFavorites.restaurant_city = [NSString stringWithFormat:@"%@",[[self.restaurantArray valueForKey:@"restaurant_details"] valueForKey:@"restaurant_city"]];
            _UserFavorites.restaurant_title = [NSString stringWithFormat:@"%@",[[self.restaurantArray valueForKey:@"restaurant_details"]valueForKey:@"restaurant_title"]];
            _UserFavorites.restaurant_is_favorite = @"Y";
            
            [appDel.objDBClass AddUserFavorite: _UserFavorites];
        }
        
        
        [GlobalMethods showAlertwithString: @"Restaurant marked as favorite"];
        [appDel.objDBClass UpdateRestaurantFavorite:appDel.CurrentRestaurantID : @"Y"];
            [self.btnFav setImage:[UIImage imageNamed:@"favoritered.png"] forState:UIControlStateNormal];
        }
        else{
            favFlag=0;
            [favarr removeObject:[self.restaurantArray valueForKey:@"restaurant_id"]];
            
            [GlobalMethods showAlertwithString: @"Restaurant unmarked as favorite"];
            [appDel.objDBClass UpdateRestaurantFavorite:appDel.CurrentRestaurantID : @"N"];
            [self.btnFav setImage:[UIImage imageNamed:@"favoritebl.png"] forState:UIControlStateNormal];

        }
        [[NSUserDefaults standardUserDefaults] setObject:favarr forKey:@"FAVCount"];
        [[NSUserDefaults standardUserDefaults ] synchronize];
        parseInt=0;
    }
    else {
        detailsDict=result;
        [hud hide:YES];
        [hud removeFromSuperview];
        hud=nil;
        
        dishes=[[detailsDict valueForKey:@"dishes"] valueForKey:@"data"];
        
        for(int k=0;k<dishes.count;k++) {
            NSMutableArray *rvw=[[dishes objectAtIndex:k ] valueForKey:@"reviews"];
            
            int cnt=(unsigned long)rvw.count;
            for(int j=0;j<cnt;j++) {
                [dishTitles addObject:[[dishes objectAtIndex:k ] valueForKey:@"dish_title"]];
                [refinedArray addObject:[rvw objectAtIndex:j]];
            }
        }
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        
        [self.tableView reloadData];
    }
    self.reviewTable.delegate=self;
    self.reviewTable.dataSource=self;
    [self.reviewTable reloadData];
    self.detailsView.hidden=NO;
    self.descriptionView.hidden=NO;

    self.dishesTable.delegate=self;
    self.dishesTable.dataSource=self;
    [self.dishesTable reloadData];
    [self setimagesAndRatng];
}



-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    [hud hide:YES];
    [hud removeFromSuperview];
    hud=nil;
    [GlobalMethods showAlertwithString:err];
}

#pragma mark
#pragma mark - mapView Delegates


-(float)kilometersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to  {
    
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    CLLocationDistance dist = [userloc distanceFromLocation:dest]/1000/1.5;
    
    
    
    NSString *distance = [NSString stringWithFormat:@"%.02f", (float) dist];
    
    return [distance floatValue];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        userLoc = currentLocation.coordinate;
    }
    
    [_locationManager stopUpdatingLocation];
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
    MKMapRect unionRectThatFits = [self.mapview mapRectThatFits:unionRect];
    //[self.RestaurantMap setVisibleMapRect:unionRectThatFits animated:YES];
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
    myAnnotation.coordinate = RestaurantLocation;
    //myAnnotation.title = RestaurantTitle;
    //myAnnotation.subtitle = MealTitle;
    
    //[self.RestaurantMap addAnnotation:myAnnotation];
    
    MapViewAnnotation *mapAnnotationView = [[MapViewAnnotation alloc] initWithTitle:RestaurantTitle
                                                                      AndCoordinate:_restLocation];
    
    [self.mapview addAnnotation:mapAnnotationView];
    
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(RestaurantLocation, 1000, 1000);
    [self.mapview setRegion:region animated:YES];
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
        
        
        
        MKAnnotationView *annoView = [self.mapview dequeueReusableAnnotationViewWithIdentifier:@"MapViewAnnotation"];
        
        if(!annoView)
        {
            annoView = mapViewAnno.annotatioView;
        }
        else
        {
            annoView.annotation = annotation;
        }
        
        [mapViewAnno.annotationButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [mapViewAnno SetDistanceAndAddress : annoView : _restaurantAddress : _distanceValue];
        
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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_restLocation, 1000, 1000);
    [self.mapview setRegion:region];
}

-(void)buttonTouched:sender{
    
    
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
        
        NSURL *directionsURL = [NSURL URLWithString:URLString];
        [[UIApplication sharedApplication] openURL:directionsURL];
    }
    else
    {
        NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
    }

}

#pragma mark - DropDown Delegtes


-(void)removeDropdown
{
    [imgView removeFromSuperview];

    [drp.view removeFromSuperview];
    drp=nil;
    
    [_dropDownBtn setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
    
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
        }else if (myIndexPath.row == 7) {
            [self performSegueWithIdentifier:@"HowItWorks" sender:self];
        }else if (myIndexPath.row == 6) {
            [self composeMail];
        }else if (myIndexPath.row == 8) {
            [self performSegueWithIdentifier:@"FAQSegue" sender:self];
        }else if (myIndexPath.row == 9) {
            [self performSegueWithIdentifier:@"aboutSegue" sender:self];
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
//                [self.navigationController popToRootViewControllerAnimated:YES];
                [self performSegueWithIdentifier:@"LoginSegue" sender:self];

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
        if(!(myIndexPath.row==0||myIndexPath.row==3||myIndexPath.row==4||myIndexPath.row==1))
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
            //[self.navigationController popToRootViewControllerAnimated:YES];

            [self performSegueWithIdentifier:@"LoginSegue" sender:self];

        }else{
            [self removeDropdown];
            
        }
    }
    else if (alertView.tag==20) {
        if(buttonIndex==1)
        {
            appDel.resFavClickedBeforeLogin=@"Y";
            //[self.navigationController popToRootViewControllerAnimated:YES];
            [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        }
    }
    else {
        if (buttonIndex==1) {
            //[self.navigationController popToRootViewControllerAnimated:YES];
            appDel.resFavClickedBeforeLogin=@"Y";

            [self performSegueWithIdentifier:@"LoginSegue" sender:self];

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
#pragma mark - ScrollView Delegate Methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat pageWidth = scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
//    float fractionalPage = scrollView.contentOffset.x / pageWidth;
//    //[scrollView setContentOffset:CGPointMake(pageWidth, 0)];
//    NSInteger page = lround(fractionalPage);
//    RPPTableViewCell * cell = (RPPTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//
//   cell.pageCtrl.currentPage = page; // you need to have a **iVar** with getter for pageControl
    [self HideShareView];
}


#pragma mark -
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DishDetailSegue"]) {
        Dish_DetailViewViewController *controller = ([segue.destinationViewController isKindOfClass:[Dish_DetailViewViewController class]]) ? segue.destinationViewController : nil;
            
        controller.Dish_Details_dic=[dishes objectAtIndex:[sender tag]-222];
    
        controller.restArray=self.restaurantArray;
        controller.pageFlag=@"yes";

    }
    if([segue.identifier isEqualToString:@"commentsSegue"]){
        CommentsViewController*comments=([segue.destinationViewController isKindOfClass:[CommentsViewController class]]) ? segue.destinationViewController : nil;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        
        comments.review_comments=[refinedArray objectAtIndex:indexPath.row];
        
    }
}


///////////////

- (IBAction)fbShaeClicked:(id)sender {
    shareViewIsHidden = NO;
    [self HideShareView];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [fbSheetOBJ setInitialText: _currentDishTitle];
        [fbSheetOBJ addImage: _currentDishImage];
        [fbSheetOBJ addURL: [NSURL URLWithString:_currentTweeturl]];
        
        [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
    }
    else
    {
        [GlobalMethods showAlertwithString:@"You're not logged in to Facebook. Go to Device Settings > Facebook > Sign In"];
    }

}

- (IBAction)twitterShareClicked:(id)sender {
    shareViewIsHidden = NO;
    [self HideShareView];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheetOBJ setInitialText: _currentDishTweet];
        [tweetSheetOBJ addImage: _currentDishImage];
        [tweetSheetOBJ addURL: [NSURL URLWithString:_currentTweeturl]];
        
        [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
    }
    else
    {
        [GlobalMethods showAlertwithString:
         @"You're not logged in to Twitter. Go to Device Settings > Twitter > Sign In"];
    }

}

- (IBAction)messageShareClicked:(id)sender {
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
    [_currentDishName appendString:[NSString stringWithFormat:@" %@",_currentTweeturl]];
    [messageController setBody:_currentDishName];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (IBAction)emailShareClicked:(id)sender {
    shareViewIsHidden = NO;
    [self HideShareView];
    
    MFMailComposeViewController *comp=[[MFMailComposeViewController alloc]init];
    [comp setMailComposeDelegate:(id)self];
    if([MFMailComposeViewController canSendMail])
    {
        //[comp setToRecipients:nil];
        [comp setSubject:AppTitle];
        
        
        [comp setMessageBody:_currentDishTitle isHTML:NO];
        
        
        //        [currentDishTitle appendString: @"Hey there! Check out this dish - "];
        //        [currentDishTitle appendString: Dish_Header_Entree.text];
        //        [currentDishTitle appendString: @", available at "];
        //        [currentDishTitle appendString: [restaur valueForKey:@"restaurant_title"]];
        
        NSMutableString *htmlMsg = [NSMutableString string];
        [htmlMsg appendString:@"<html><body><p>"];
        [htmlMsg appendString: @"Hey there! Check out this dish - "];
        [htmlMsg appendString: _currentDishName];
        [htmlMsg appendString: @", available at "];
        [htmlMsg appendString: _currentDishRestaurant];
        [htmlMsg appendString: @"</p> <p>"];
        [htmlMsg appendString: @"About the dish: "];
        [htmlMsg appendString: _currentDishDescription];
        [htmlMsg appendString:[NSString stringWithFormat:@"\n%@",_currentTweeturl]];
        [htmlMsg appendString:@" </p></body></html>"];
        
        NSData *jpegData = UIImageJPEGRepresentation(_currentDishImage, 1);
        
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

- (IBAction)showReviews:(id)sender {
    self.reviewsView.hidden=NO;
    self.locationView.hidden=YES;
    self.dishesView.hidden=YES;

    [self SetUnderScore:self.btnReviews];
//    [self.btnReviews setBackgroundColor:[UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f]];
//    [self.btnDishes setBackgroundColor:[UIColor whiteColor]];
//    [self.btnLocation setBackgroundColor:[UIColor whiteColor]];
    
    [self.btnReviews setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnLocation setTitleColor:[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.btnDishes setTitleColor:[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f] forState:UIControlStateNormal];

    [self.btnLocation setAlpha:1.0f];
    [self.btnReviews setAlpha:0.7f];
    [self.btnDishes setAlpha:1.0f];
//    self.btnReviews.titleLabel.textColor=[UIColor blackColor];
//    self.btnLocation.titleLabel.textColor=[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f];

    if ([refinedArray count]==0) {
        self.lblNoReview.hidden=NO;
        self.reviewTable.hidden=YES;
    }
    else{
        self.lblNoReview.hidden=YES;
        self.reviewTable.hidden=NO;
    }
    }

- (IBAction)showLocation:(id)sender {
    self.reviewsView.hidden=YES;
    self.locationView.hidden=NO;
    self.dishesView.hidden=YES;

//    [self.btnLocation setBackgroundColor:[UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f]];
//    [self.btnDishes setBackgroundColor:[UIColor whiteColor]];
//    [self.btnReviews setBackgroundColor:[UIColor whiteColor]];

    [self.btnReviews setAlpha:1.0f];
    [self.btnDishes setAlpha:1.0f];
    [self.btnLocation setAlpha:0.7f];
    
    [self.btnDishes setTitleColor:[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.btnReviews setTitleColor:[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.btnLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self SetUnderScore:self.btnLocation];
//    self.btnReviews.titleLabel.textColor=[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f];
//    self.btnLocation.titleLabel.textColor=[UIColor blackColor];
}
- (IBAction)showDishes:(id)sender {
    self.reviewsView.hidden=YES;
    self.locationView.hidden=YES;
    self.dishesView.hidden=NO;
    
//    [self.btnDishes setBackgroundColor:[UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f]];
//    [self.btnDishes setBackgroundColor:[UIColor whiteColor]];
//    [self.btnLocation setBackgroundColor:[UIColor whiteColor]];
    [self.btnReviews setAlpha:1.0f];
    [self.btnDishes setAlpha:0.7f];
    [self.btnLocation setAlpha:1.0f];
    
    [self.btnLocation setTitleColor:[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.btnReviews setTitleColor:[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.btnDishes setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self SetUnderScore:self.btnDishes];

}
- (IBAction)setFav:(id)sender {
    if ([appDel.accessToken isEqualToString:@""])
    {
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:AppTitle message:@"Please Login to favorite " delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES", nil];
        alert.tag=20;
        [alert show];
        return;
    }
    
    UIButton *btnTemp = (UIButton *)sender;
    int iTag = btnTemp.tag;
    
    if (favFlag==1) {
        [self.btnFav setImage:[UIImage imageNamed:@"favoritebl.png"] forState:UIControlStateNormal];
    }
    else{
        [self.btnFav setImage:[UIImage imageNamed:@"favoritered.png"] forState:UIControlStateNormal];
        
    }
    // I want to change image of sender
    
//    if ([appDel.accessToken isEqualToString:@""])
//    {
//        [[[UIAlertView alloc]initWithTitle:AppTitle message:@"Please Login to favorite " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
//        return;
//    }
    parseInt=1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken, @"accessToken",
                            appDel.CurrentRestaurantID,@"dishId",nil];
    
    
    [parser parseAndGetDataForPostMethod:params withUlr:@"markFavoriteDish"];

}

- (IBAction)readMoreLess:(id)sender {
    if (viewMoreFlag==NO) {
        CGSize size=[self calculateHeightForString:[self.restaurantArray valueForKey:@"restaurant_description"]];
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self.txtResDes setFrame:CGRectMake(self.txtResDes.frame.origin.x, self.txtResDes.frame.origin.y, self.txtResDes.frame.size.width, size.height+5)];
                             [self.descriptionView setFrame:CGRectMake(self.descriptionView.frame.origin.x, self.descriptionView.frame.origin.y, self.descriptionView.frame.size.width, size.height+self.txtResDes.frame.origin.y+20)];
                             [self.detailsView setFrame:CGRectMake(self.detailsView.frame.origin.x, self.descriptionView.frame.origin.y+self.descriptionView.frame.size.height+15,self.detailsView.frame.size.width,self.detailsView.frame.size.height)];
                             [self.btnReadMore setFrame:CGRectMake(self.btnReadMore.frame.origin.x, self.descriptionView.frame.size.height-self.btnReadMore.frame.size.height, self.btnReadMore.frame.size.width, self.btnReadMore.frame.size.height)];
                             [self.scrollView setContentSize:CGSizeMake(320, scrollHeight+self.descriptionView.frame.size.height-110)];
                         }
                         completion:^(BOOL finished){
                             
                         }
         ];
        viewMoreFlag=YES;
        [self.btnReadMore setTitle:@"SHOW LESS" forState:UIControlStateNormal];
        
    }
    else{
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self.txtResDes setFrame:CGRectMake(self.txtResDes.frame.origin.x, self.txtResDes.frame.origin.y, self.txtResDes.frame.size.width, 85)];
                             [self.descriptionView setFrame:CGRectMake(self.descriptionView.frame.origin.x, self.descriptionView.frame.origin.y, self.descriptionView.frame.size.width, 110)];
                             [self.detailsView setFrame:CGRectMake(self.detailsView.frame.origin.x, self.descriptionView.frame.origin.y+self.descriptionView.frame.size.height+15,self.detailsView.frame.size.width,self.detailsView.frame.size.height)];
                             [self.btnReadMore setFrame:CGRectMake(self.btnReadMore.frame.origin.x, self.descriptionView.frame.size.height-self.btnReadMore.frame.size.height, self.btnReadMore.frame.size.width, self.btnReadMore.frame.size.height)];
                             [self.scrollView  setContentSize:CGSizeMake(320, scrollHeight-self.descriptionView.frame.size.height+110)];
                             
                         }
                         completion:^(BOOL finished){
                             
                         }
         ];
        viewMoreFlag=NO;
        [self.btnReadMore setTitle:@"READ MORE" forState:UIControlStateNormal];
        
    }

}
@end
