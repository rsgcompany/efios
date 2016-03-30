//
//  FavouriteViewController.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "FavouriteViewController.h"
#import "GlobalMethods.h"
#import "Global.h"
#import "NotificationsCell.h"
#import "Dish_DetailViewViewController.h"
@interface FavouriteViewController ()

@end
static UIColor *favcolor, *unfavcolor;
@implementation FavouriteViewController
#pragma mark -
#pragma mark - ViewcontrollerLifeCycleMethods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if(!IS_IPHONE5)
    {
        [favrtTbl setFrame:CGRectMake(0, 65, 320, 415)];
    }
    
    required=[[NSMutableDictionary alloc]init];
    titleLbl.font=[UIFont fontWithName:Regular size:18.0f];
   // dropDwnBtn.imageEdgeInsets = UIEdgeInsetsMake(17, 0, 0, 0);
    
//    favcolor=[UIColor colorWithRed:194/255.0f green:194/255.0f blue:194/255.0f alpha:1.0f];
    
//    unfavcolor=[UIColor colorWithRed:194/255.0f green:194/255.0f blue:194/255.0f alpha:1.0f];
//    favcolor=[UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    
//    parser=[[ParseAndGetData alloc]init];
//    parser.delegate=self;
        favsArray = [appDel.objDBClass GetAllUserFavorites];
    
    //favsArray=[[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"];
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);

    [favrtTbl reloadData];
    
    [favrtTbl setSeparatorInset:UIEdgeInsetsZero];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSString *urlquerystring=[NSString stringWithFormat:@"getCustomerProfile?accessToken=%@",appDel.accessToken];
    [parser parseAndGetDataForGetMethod:urlquerystring];
    urlquerystring=nil;
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    if ([favrtTbl respondsToSelector:@selector(setSeparatorInset:)]) {
        [favrtTbl setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([favrtTbl respondsToSelector:@selector(setLayoutMargins:)]) {
        [favrtTbl setLayoutMargins:UIEdgeInsetsZero];
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
    return [favsArray count];
}

@synthesize UserFavorites;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"favoriteTableCell";
    
    NotificationsCell *cell = (NotificationsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    
    UserFavorites = [[FavoritesClass alloc] init];
    UserFavorites = (FavoritesClass *) favsArray [indexPath.row];
    
//    NSString *RestaurantTitle = [[favoritsArr objectAtIndex:indexPath.row] valueForKey:@"restaurant_title"];
//    
//    NSString *RestaurantLocation = [[favoritsArr objectAtIndex:indexPath.row] valueForKey:@"restaurant_city"];
    
//    cell.titleLbl.text=[[favoritsArr objectAtIndex:indexPath.row]valueForKey:@"dish_title"];
//    cell.detailLbl.text=[[[favoritsArr objectAtIndex:indexPath.row]valueForKey:@"restaurant_details"] valueForKey:@"restaurant_title"];
//    cell.location.text=[[[favoritsArr objectAtIndex:indexPath.row]valueForKey:@"restaurant_details"] valueForKey:@"restaurant_city"];
    
    cell.titleLbl.text= UserFavorites.restaurant_title;
    cell.detailLbl.text= UserFavorites.restaurant_city;
    cell.location.text= @"";

    
    [cell.favBtn setTag:indexPath.row];
    [cell.favBtn setImage:[UIImage imageNamed:@"favoritered.png"] forState:UIControlStateNormal];

    //cell.favBtn.backgroundColor=favcolor;
    [cell.favBtn addTarget:self action:@selector(favouriteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    NSDictionary *locDict=[[favoritsArr objectAtIndex:indexPath.row] valueForKey:@"images"];
//    
//    id img=[[favoritsArr objectAtIndex:indexPath.row] valueForKey:@"images"];
//    if ([img isKindOfClass:[NSArray class]])
//    {
//        NSArray *art=[[favoritsArr objectAtIndex:indexPath.row] valueForKey:@"images"];
//        if ([art count]) {
//            locDict=[art objectAtIndex:0];
//        }
//    }
//    else
//    {
//        locDict=[[favoritsArr objectAtIndex:indexPath.row] valueForKey:@"images"];
//    }
//    if([ locDict count]!=0)
//    {
//        NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLImage,[locDict valueForKey:@"path_lg"]];
//        [cell.roundImg sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"dish_Pic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if(image==nil)
//                cell.roundImg.image=[UIImage imageNamed:@"dish_Pic"];
//            else
//                cell.roundImg.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(80,80) source:image];
//        }];
//    }
    
    [cell.rppBtn setTag:indexPath.row];

    [cell.rppBtn addTarget:self action:@selector(rppBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.roundImg.image=[UIImage imageNamed:@"dish_Pic"];
    
    NSString *disturlStr=[NSString stringWithFormat:@"%@%@",BaseURLRestaurant, UserFavorites.restaurant_image_thumbnail];
    NSLog(@"Fav Image URL: %@",  disturlStr);
        [cell.roundImg sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"nf_placeholder_restaurant"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
       {
           NSLog(@"imageURL: %@",  imageURL);
            if(image==nil)
            {
                cell.roundImg.image=[UIImage imageNamed:@"nf_placeholder_restaurant"];
            }
            else
            {
                cell.roundImg.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(80,80) source:image];
            }
           
        }];

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
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    Dish_DetailViewViewController *details=[[Dish_DetailViewViewController alloc]initWithNibName:@"Dish_DetailViewViewController" bundle:nil];
//    details.Dish_Details_dic=[favoritsArr objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:details animated:YES];
}
#pragma mark
#pragma mark - Button Actions

-(void)rppBtnClicked:(id)sender{
    UserFavorites = (FavoritesClass *) favsArray [[sender tag]];

    NSPredicate *pred=[NSPredicate predicateWithFormat:@"restaurant_id == %@",UserFavorites.restaurant_id];
    NSArray *req=[appDel.dishesVC.dishesCopyArr filteredArrayUsingPredicate:pred];
    if ([req count] != 0) {
        required=[req objectAtIndex:0];

        [self performSegueWithIdentifier:@"RPPSegue" sender:self];
    }

}
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

-(void)favouriteBtnClicked:(id)sender
{
    if ([appDel.accessToken isEqualToString:@""])
    {
        [[[UIAlertView alloc]initWithTitle:AppTitle message:@"Login to Favourite" delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES", nil]show]        ;
        return;
    }
    UIButton *bnt=(UIButton*)[self.view viewWithTag:[sender tag]];

    
    int tagint=[sender tag];
    
    UserFavorites = [favsArray objectAtIndex: tagint];
    
    appDel.objDBClass.FavoritesClassObj = UserFavorites;
    
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken, @"accessToken",UserFavorites.restaurant_id,@"dishId",nil];
    
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    [parser parseAndGetDataForPostMethod:params withUlr:@"markFavoriteDish"];
}

#pragma mark
#pragma mark - ParseAndGetData Delegates
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    BOOL errMsg=[[result valueForKey:@"error"]boolValue];
    if(errMsg)
        [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
    else
    {
        if ([[result valueForKey:@"message"] isEqualToString:@"Dish marked as a favorite"])
        {
            [GlobalMethods showAlertwithString: @"Restaurant marked as favorite."];
            [appDel.objDBClass UpdateRestaurantFavorite:appDel.objDBClass.FavoritesClassObj.restaurant_id : @"Y"];
            
        }
        else
        {
            [GlobalMethods showAlertwithString: @"Restaurant unmarked as favorite."];
            [appDel.objDBClass UpdateRestaurantFavorite:appDel.objDBClass.FavoritesClassObj.restaurant_id : @"N"];
        }
        
//        favoritsArr=[result valueForKey:@"favorites"];
//        NSMutableArray *a=[[NSMutableArray alloc]init];
//        a=[[favoritsArr valueForKey:@"dish_id"] mutableCopy];
//        a=[favoritsArr mutableCopy];
//       // [[NSUserDefaults standardUserDefaults]setObject:a forKey:@"FAVCount"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
        
        favsArray = [appDel.objDBClass GetAllUserFavorites];
        [favrtTbl reloadData];
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
            [self performSegueWithIdentifier:@"OrderHistorySegue" sender:self];
        }else if (myIndexPath.row == 5) {
            //[self performSegueWithIdentifier:@"FavoriteSegue" sender:self];
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
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RPPSegue"]) {
        RestaurantDetailViewController *controller = ([segue.destinationViewController isKindOfClass:[RestaurantDetailViewController class]]) ? segue.destinationViewController : nil;
        controller.restaurantArray=[required valueForKey:@"restaurant_details"];
    }
}
@end