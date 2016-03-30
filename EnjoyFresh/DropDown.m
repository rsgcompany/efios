//
//  DropDown.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "DropDown.h"
#import "Global.h"
#import "GlobalMethods.h"
#import "SettingViewController.h"
#import "FideMeViewController.h"
#import "ShareViewController.h"

int rows;
@interface DropDown ()

@end

@implementation DropDown
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if ([appDel.accessToken length]==0) {
            rows=7;
        }
        else{
            rows=11;
        }
    }
    
    return self;
}
-(CGRect)dropDownViewFrame
{
    return CGRectMake(100, 0, 220, rows*40);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dropDownArr=@[@"User Name",@"Payment",@"Notifications",@"Share & Save",@"Order History",@"Favorites",@"Help/Contact",@"How it Works",@"FAQs",@"About Us",@"Logout"];
    
    selectedArr=@[@"active_user",@"active_Payment",@"active_notifications",@"active_Social Share",@"active_Order History",@"active_Favorites",@"active_Contact",@"active_How it Works",@"active_FAQs",@"active_About Us",@"active_Logout"];
    

    self.tableView.layer.borderWidth = 1;
	self.tableView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.tableView setScrollEnabled:NO];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row==1) {
//        /////hide cell for explore
//        return 0;
//    }
    if(![appDel.accessToken length]){
        if (indexPath.row==1||indexPath.row==2||indexPath.row==5||indexPath.row==4){
           return 0;
        }
    }

    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dropDownArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifer=@"Drop";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if(cell==nil)
    {
       // cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        //////TableView CellSelection color////////
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(144/255.0) green:(186/255.0) blue:(118/255.0) alpha:1];
        cell.selectedBackgroundView = selectionColor;
        

        
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 100, 40)];
        [lbl setFont:[UIFont fontWithName:Regular size:14.0f]];
        //[lbl setTextColor:[UIColor colorWithRed:212/255.0f green:56/255.0f blue:49/255.0f alpha:1.0f]];
        lbl.text=[NSString stringWithFormat:@"%@",[dropDownArr objectAtIndex:indexPath.row]];
        [cell.contentView addSubview:lbl];
        
        /////hide cell for explore
//        if (indexPath.row==1) {
//            lbl.text=@"";
//            return cell;
//        }
        if(![appDel.accessToken length])
        {
            if(indexPath.row==0)
            lbl.text=@"Guest User";
            else if(indexPath.row==10)
            lbl.text=@"Login";
            else if(indexPath.row==1||indexPath.row==2||indexPath.row==5||indexPath.row==4){
                cell.imageView.hidden=YES;
                lbl.text=@"";
            }
            
        }
        else
        {
            if(indexPath.row==0)
            {
                
            
            NSDictionary *dict=[[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfile"];
                
            NSString *abc = [NSString stringWithFormat:@"%@  %@",[dict valueForKey:@"first_name"],[dict valueForKey:@"last_name"]];
            lbl.text = [NSString stringWithFormat:@"%@%@",[[abc substringToIndex:1] uppercaseString],[abc substringFromIndex:1] ];
            }
 
        }
        UILabel *count_lbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 0, 30, 40)];
        count_lbl.highlightedTextColor = [UIColor whiteColor];

        [count_lbl setFont:[UIFont fontWithName:Regular size:14.0f]];
        //[count_lbl setTextColor:[UIColor colorWithRed:212/255.0f green:56/255.0f blue:49/255.0f alpha:1.0f]];
        if (indexPath.row==5)
        {
           if( [[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfile"]!=nil)
            {
                count_lbl.textColor=[UIColor lightGrayColor];
                count_lbl.text=[NSString stringWithFormat:@"[%.2lu]",(unsigned long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"FAVCount"] count]];
                
                NSMutableArray *retArray = [appDel.objDBClass GetAllUserFavorites];
                
                if(retArray.count > 0)
                {
                    [count_lbl setHidden:NO];
                    count_lbl.text = [NSString stringWithFormat:@"[%.2lu]",  (unsigned long)retArray.count];
                }
                else
                {
                    [count_lbl setHidden:YES];
                }
//                if ([count_lbl.text isEqualToString:@"0"])
//                {
//                    [count_lbl setHidden:YES];
//
//                }else
//                [count_lbl setHidden:NO];

            }else
                [count_lbl setHidden:YES];

        }else{
                        [count_lbl setHidden:YES];
        }
        [cell.contentView addSubview:count_lbl];
        lbl.highlightedTextColor = [UIColor whiteColor];


    }
   
    if(indexPath.row==0)
        cell.imageView.image=[UIImage imageNamed:@"user"];
    else if (indexPath.row==3)
        cell.imageView.image=[UIImage imageNamed:@"Social Share"];
    else if (indexPath.row==6)
        cell.imageView.image=[UIImage imageNamed:@"Contact"];
    else
        cell.imageView.image=[UIImage imageNamed:[dropDownArr objectAtIndex:indexPath.row]];
        cell.imageView.highlightedImage=[UIImage imageNamed:[selectedArr objectAtIndex:indexPath.row]];
    
    // Configure the cell...

   
    return cell;
}
#pragma mark - Table view delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
         NSLog(@"appDel.nav: %@", appDel.nav);
         
         
         NSString *stg = [dropDownArr objectAtIndex:indexPath.row];
         [delegate didSelectRowInDropdownTableString:stg atIndexPath:indexPath];
   
    
    
}
#pragma mark -
#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
       [appDel.nav popToRootViewControllerAnimated:YES];
    }else{
        [delegate removeDropdown];

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
    [appDel.nav dismissViewControllerAnimated:YES completion:nil];
    [delegate removeDropdown];
}
@end