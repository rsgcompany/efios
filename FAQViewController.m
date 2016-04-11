//
//  FAQViewController.m
//  EnjoyFresh
//
//  Created by Siva  on 05/10/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import "FAQViewController.h"
#import "Global.h"
@interface FAQViewController ()
@property(nonatomic)NSIndexPath *lastSelectedIndex;

@end
BOOL cellFlag=NO;
@implementation FAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FAQFile" ofType:@"plist"];
    
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithContentsOfFile:path];
    NSDictionary *names = [dict objectForKey:@"Questions"];
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);

    self.FAQTable.delegate=self;
    self.FAQTable.dataSource=self;
    
    [self.FAQTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    questionsArray=[[NSArray alloc]init];
    questionsArray=[dict objectForKey:@"Questions"];//@[@"What is EnjoyFresh?",@"Why EnjoyFresh?",@"Is EnjoyFresh FREE?",@"How do I create an account?",@"How do I search for a dish?",@"How do I make a purchase?",@"I don’t see anything in the marketplace?",@"How do I pay after I select my order?",@"How secure is the payment gateway?",@"Is It possible to reserve the dish and pay at the restaurant?",@"What do I do if the dish is not I ordered?",@"If I do not use one of my orders, can I get refunded?",@"How does the restaurant know who has placed an order and when we will come in?",@"Is it possible to do pick-up orders?",@"How do I know what is in each dish?",@"Do you offer delivery?",@"Is there a limit to the number of orders I can make?",@"Can I change or substitute once I am at the restaurant?",@"Can I change or modify my order?",@"Do you offer rewards points for regular customers?",@"How do I opt out of newsletters, updates and offers from EnjoyFresh?",@"What do I do if I suspect a fraudulent seller?"];
    answersArray=[[NSArray alloc]init];

    answersArray=[dict objectForKey:@"Answers"];//@[@"EnjoyFresh is a marketplace to connect local chefs and their unique with food lovers. We hand-pick chefs and local restaurants to provide members with exclusive, chef-curated in-restaurant dining and delivery experiences (where available).",@"You’re a food lover and appreciate new culinary experiences.  EnjoyFresh finds exclusive chef-curated dining experiences and food offerings near you and gives you an opportunity to book your seat at the chef’s table, or have it delivered.  Personalize your preferences on EnjoyFresh and you’ll be notified when new events or menu items are available to match your interests, such as favorite restaurants, dietary choices, and lunch delivery options.",@"Yes. Becoming an EnjoyFresh member is free. Users pay for the experiences they purchase on the marketplace. Ordering is seamless, you can reserve through your phone and we will send you a confirmation with all the details.",@"You can sign up through our website or mobile app. EnjoyFresh also lets you sign up through Facebook and Twitter. Enter your details and start enjoying mouthwatering made-to-order delicacies.",@"EnjoyFresh uses location based settings to show you dishes that are in your area. You can refine your search in terms of type of cuisine, distance and dietary options",@"By entering your information into EnjoyFresh you can order instantly through the app. If you don’t wish to enter your information you can choose your payment type, quantity and enter your information in the order form.",@"Our site is made for local restaurants. If we do not have any restaurants in your zip code, you might not see anything in the search. If you are unable to view any results as soon as you log in, click on “change location” and try a different zip code.",@"You can pay online via your PayPal, credit or debit card.",@"The payment gateway we use is very secure. Payment gateways protect credit card details by encrypting sensitive information, such as credit card numbers, to ensure that information is passed securely between the customer, the merchant and the payment processor.",@"Experiences must be purchased through EnjoyFresh at this time.",@"The order you placed through EnjoyFresh will be the meal prepared by the restaurant. If there is any mismatch, this can be adjusted by the restaurant at their sole discretion. You can always call customer service and discuss any issue in regards to this.",@"We cannot refund you, but you can use the total amount of your order as a credit towards future visits to the restaurant. All you have to do is show the credit information to restaurant and the amount will be credited in the bill",@"Once an order is placed, an order summary is sent to the user and restaurant owner. If there is not a specified time, you can reserve through the restaurant",@"EnjoyFresh is for in restaurant dining experiences, we do not currently offer this feature.",@"Ingredient information is displayed just below the dish picture on the search page, some restaurants may omit certain ingredients.",@"We do not currently offer delivery.",@"There is no limit to the orders you can make.",@"This is left to restaurant’s sole discretion.",@"You can not change or modify your order through EnjoyFresh; however, this can be discussed with the restaurant.",@"We do not currently offer this feature.",@"After you log in, click on your username on the top right hand corner. From there, select “settings” from the drop down menu, scroll to the bottom of the page and unselect the “offers” option under notification tab.",@"We thoroughly verify all of the restaurants that advertise with us, so you should not come across such a situation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    //if (section>0) return YES;
    
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return questionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section])
        {
            return 2; // return rows when expanded
        }
        
        return 1; // only top row showing
    }
    
    // Return the number of rows in the section.
    return 1;
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //cell.contentView.superview.backgroundColor=[UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    [cell.layer setCornerRadius:5.0f];
    [cell.layer setMasksToBounds:YES];

    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;

    UIFont *myFont = [ UIFont fontWithName:SemiBold size: 14.0 ];
    cell.textLabel.font  = myFont;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    // Configure the cell...
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            // first row
            cell.textLabel.text = [questionsArray objectAtIndex:indexPath.section]; // only top row showing
 
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(0.0f, 0.0f,30.0f,30.0f);
           // button.tintColor=[UIColor whiteColor];
          // [button addTarget:self action:@selector(onCustomAccessoryTapped:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=indexPath.row;
            button.tintColor=[UIColor lightGrayColor];
            [button setImage:[UIImage imageNamed:@"arrow-2.png"] forState:UIControlStateNormal];
            cell.accessoryView=button;
            cell.accessoryView.userInteractionEnabled=NO;
            //cell.accessoryView.backgroundColor=[UIColor lightGrayColor];
            cell.contentView.superview.backgroundColor=[UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1.0f];

        }
        else
        {
            // all other rows
            cell.textLabel.text = [answersArray objectAtIndex:indexPath.section];
            UIFont *myFont = [ UIFont fontWithName:Regular size: 14.0 ];
            cell.textLabel.font  = myFont;
            cell.contentView.superview.backgroundColor=[UIColor whiteColor];
            cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);

        }
    }
    else
    {
        cell.accessoryView = nil;
        cell.textLabel.text = @"Normal Cell";
        
    }
    
    return cell;
}
-(void)onCustomAccessoryTapped:(id)sender{
    UITableViewCell *cell = (UITableViewCell *)[sender superview];
    NSIndexPath *indexPath = [self.FAQTable indexPathForCell:cell];
    
    // Now you can do the following
    [self tableView:self.FAQTable didDeselectRowAtIndexPath:indexPath];

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,0)];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (self.lastSelectedIndex.section!=indexPath.section) {
            
            [self resetTable:indexPath];
        }

        if (!indexPath.row)
        {
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
           // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                cellFlag=YES;
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
                 cellFlag=NO;
            }
            
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
            }
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        [self changeImageForCell:cell];
        }

    }
    self.lastSelectedIndex=indexPath;

}

-(void)resetTable:(NSIndexPath*)index{
    
    
    [expandedSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        
        BOOL currentlyExpanded = [expandedSections containsIndex:idx];
        NSInteger rows;
        
        // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        
        if (currentlyExpanded)
        {
            rows = [self tableView:self.FAQTable numberOfRowsInSection:idx];
            [expandedSections removeIndex:idx];
            cellFlag=YES;
        }
        NSIndexPath *tmpIndexPath=nil;
        for (int i=1; i<rows; i++)
        {
            tmpIndexPath = [NSIndexPath indexPathForRow:i
                                              inSection:idx];
            [tmpArray addObject:tmpIndexPath];
        }
        
        
        if (currentlyExpanded)
        {
            [self.FAQTable deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
            
            
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:idx];
        UITableViewCell *cell = [self.FAQTable cellForRowAtIndexPath:indexPath];
        
        [self changeImageForCell:cell];
        
    }];
    
    
    
}
-(void)changeImageForCell:(id)sender{
    UITableViewCell *cell=sender;
    if (cellFlag==YES) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0.0f, 0.0f,30.0f,30.0f);
        // button.tintColor=[UIColor whiteColor];
        button.tintColor=[UIColor lightGrayColor];
        [button setImage:[UIImage imageNamed:@"arrow-2.png"] forState:UIControlStateNormal];
        cell.accessoryView=button;
        cell.accessoryView.userInteractionEnabled=NO;

    }
    else{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0.0f, 0.0f,25.0f,30.0f);
        // button.tintColor=[UIColor whiteColor];
        button.tintColor=[UIColor lightGrayColor];
        [button setImage:[UIImage imageNamed:@"arrow-3.png"] forState:UIControlStateNormal];
        cell.accessoryView=button;
        cell.accessoryView.userInteractionEnabled=NO;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            if (indexPath.section==12) {
                return 74;
            }
//            NSString *cellText = [questionsArray objectAtIndex:indexPath.section];
//            UIFont *cellFont = [UIFont fontWithName:Regular size:15.0];
//            CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
//            CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
//            if (labelSize.height>=45) {
//               return labelSize.height+20;
//            }
            else if(indexPath.section==20){
              return 60;
            }
            else{
                NSString *cellText = [questionsArray objectAtIndex:indexPath.section];
            UIFont *cellFont = [UIFont fontWithName:Regular size:17.0];
            CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
            CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            
            return labelSize.height+20;
            }
        }
        else{
            NSString *cellText = [answersArray objectAtIndex:indexPath.section];
            UIFont *cellFont = [UIFont fontWithName:Regular size:15.5];
            CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
            CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            
            return labelSize.height;
        }
    }
    return 54;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
- (IBAction)BackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
            //[self performSegueWithIdentifier:@"FAQSegue" sender:self];
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
                [self performSegueWithIdentifier:@"ShareSegue" sender:self];
                
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
               // [self performSegueWithIdentifier:@"FAQSegue" sender:self];
                
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
        if(!(myIndexPath.row==0||myIndexPath.row==3||myIndexPath.row==4||myIndexPath.row==1||myIndexPath.row==2))
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
