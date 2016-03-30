//
//  ReviewViewController.m
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 08/09/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "ReviewViewController.h"
#import "Global.h"
#import "ReviewCustomCell.h"
#import "CommentsViewController.h"
#define stars @"★★★★★"

@interface ReviewViewController ()

@end

@implementation ReviewViewController

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
    hearder_lbl.font=[UIFont fontWithName:Regular size:18];
    //self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);

    // Do any additional setup after loading the view from its nib.
}
#pragma mark -
#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_review count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict =[_review objectAtIndex:indexPath.row];
    NSString *text = [dict valueForKey:@"review"];
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:Regular size:15] constrainedToSize:CGSizeMake(review_Table.frame.size.width- 10 * 3, 1000.0f)];
    
    return textSize.height +20 +100;
    return 240;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"CellIdentifier";
    
    ReviewCustomCell *cell = (ReviewCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewCustomCell" owner:self options:nil];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView=[UIView new];
        cell = [nib objectAtIndex:0];
    }
    cell.Name.text=[NSString stringWithFormat:@"%@ %@",[[_review objectAtIndex:indexPath.row] valueForKey:@"first_name"],[[_review objectAtIndex:indexPath.row] valueForKey:@"last_name"]];
    
    NSString *strindate=[NSString stringWithFormat:@"%@",[[_review objectAtIndex:indexPath.row] valueForKey:@"date_added"]];
    
    NSArray*sa=[strindate componentsSeparatedByString:@" "];
    if ([sa count]==2) {
        NSArray *date=[[sa objectAtIndex:0] componentsSeparatedByString:@"-"];
        // NSArray *time=[[sa objectAtIndex:1] componentsSeparatedByString:@":"];
        cell.review_date.text=[NSString stringWithFormat:@"%@/%@ ",[date objectAtIndex:1],[date objectAtIndex:2]];
    }else{
        cell.review_date.text=[NSString stringWithFormat:@"%@",[[_review objectAtIndex:indexPath.row] valueForKey:@"date_added"]];
    }

    
    
    cell.User_review.text=[NSString stringWithFormat:@"%@",[[_review objectAtIndex:indexPath.row] valueForKey:@"review"]];
    NSString *striRate=[NSString stringWithFormat:@"%@",[[_review objectAtIndex: indexPath.row]valueForKey:@"rating"]];
    if ([striRate isEqualToString:@"0"]) {
        [cell.review_rgt setHidden:YES];
        
    }else{
        [cell.review_rgt setHidden:NO];
        
    }
    cell.review_rgt.text=[NSString stringWithFormat:@"%@",[stars substringToIndex:[striRate integerValue]]];
    cell.review_rgt.textColor=[UIColor colorWithRed:0 green:138/255.f blue:0 alpha:1.0f];
    
    CGSize textSize = [cell.User_review.text sizeWithFont:[UIFont fontWithName:Regular size:15] constrainedToSize:CGSizeMake(review_Table.frame.size.width - 10*3, 1000.0f)];
    
    CGRect rect=cell.User_review.frame;
    rect.size.height=textSize.height+20;
    
    cell.User_review.frame = rect;
    
    
    CGRect review_d=cell.review_date.frame;
    review_d.origin.y=textSize.height+cell.User_review.frame.origin.y+20 ;
    
    cell.review_date.frame=review_d;
    
    
    CGRect rated=cell.review_rgt.frame;
    rated.origin.y =textSize.height+cell.User_review.frame.origin.y +20;
    cell.review_rgt.frame=rated;
    
    
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CommentsViewController*comments=[[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
    comments.review_comments=[_review objectAtIndex: indexPath.row];
    
    [self.navigationController pushViewController:comments animated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Back_btn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
