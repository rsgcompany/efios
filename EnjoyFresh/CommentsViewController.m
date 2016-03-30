//
//  CommentsViewController.m
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 08/09/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//
#import "CommentsViewController.h"
#import "Global.h"
@interface CommentsViewController ()

@end

@implementation CommentsViewController
@synthesize review_comments;

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
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    
    if(!IS_IPHONE5)
    {
        [comments setFrame:CGRectMake(0, 65, 320, 415)];
    }
    review_Name.text=[NSString stringWithFormat:@"%@ %@",[review_comments valueForKey:@"first_name"],[review_comments valueForKey:@"last_name"]];
    review_lbl.text=[NSString stringWithFormat:@"%@",[review_comments valueForKey:@"review"]];
    review_Name.font=[UIFont fontWithName:SemiBold size:11];
    self.lblDishName.font=[UIFont fontWithName:SemiBold size:11];
    self.lblDate.font=[UIFont fontWithName:SemiBold size:10];
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);

    review_lbl.font=[UIFont fontWithName:Regular size:12];
    comments_arr=[[review_comments valueForKey:@"review_comments"] mutableCopy];
    self.lblDishName.text=self.dishName;
    comments.delegate=self;
    comments.dataSource=self;
    header_lbl.font=[UIFont fontWithName:SemiBold size:16];
    nocomments_lbl.font=[UIFont fontWithName:Regular size:15];
    if (![comments_arr count]) {
        [comments setHidden:YES];
        
    }else{
        [nocomments_lbl setHidden:YES];
    }
    self.userImage.layer.cornerRadius=16.0f;
    // self.userProfileImage.layer.borderWidth=1.0f;
    self.userImage.layer.masksToBounds=YES;
    
    NSString *strindate=[NSString stringWithFormat:@"%@",[review_comments valueForKey:@"date_added"]];
    
    NSArray*sa=[strindate componentsSeparatedByString:@" "];
    if ([sa count]==2) {
        
        NSArray *date=[[sa objectAtIndex:0] componentsSeparatedByString:@"-"];
        // NSArray *time=[[sa objectAtIndex:1] componentsSeparatedByString:@":"];
        self.lblDate.text=[NSString stringWithFormat:@"%@-%@-%@",[date objectAtIndex:0],[date objectAtIndex:1],[date objectAtIndex:2]];
    }
    
    
    NSString *rating =[NSString stringWithFormat:@"%@",[review_comments valueForKey:@"rating"]];
    
    self.lblRating.textColor=[UIColor colorWithRed:239/255.0f green:194/255.0f blue:74/255.0f alpha:1.0f];
    if ([rating isEqual:@"0"]) {
        [self.lblRating setHidden:YES];
        [self.lblStar setHidden:YES];
    }
    else{
        [self.lblRating setHidden:NO];
        [self.lblStar setHidden:NO];

        self.lblRating.text=[stars substringToIndex:[rating integerValue]];
        self.lblStar.text=[stars substringToIndex:5-[rating integerValue]];
    }
    
    
    NSString *disturlStr=[NSString stringWithFormat:@"%@%@",UserURlImge,[review_comments valueForKey:@"image"]];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"user_pic.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image==nil) {
            
        }else{
            self.userImage.image = [GlobalMethods imageByScalingAndCroppingForSize:CGSizeMake(72,72) source:image];
            self.userImage.image=image;
        }
        
    }];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    CGSize textSize = [review_lbl.text sizeWithFont:[UIFont fontWithName:Regular size:12] constrainedToSize:CGSizeMake(review_lbl.frame.size.width - 10*3, 1000.0f)];
    
    CGRect rect=review_lbl.frame;
    rect.size.height=textSize.height+20;
    
    if (rect.size.height>210) {
        rect.size.height=210;

    }
    review_lbl.frame = rect;
    if ([comments_arr count]==0) {
        self.replies.hidden=YES;
    }
    else{
    [self.replies setFrame:CGRectMake(238, review_lbl.frame.origin.y+review_lbl.frame.size.height,70, 20)];
    self.replies.font=[UIFont fontWithName:Regular size:10];
     self.replies.text=[NSString stringWithFormat:@"%lu replies",(unsigned long)[comments_arr count]];
    }   ///------------------------
    T_view.frame=CGRectMake(0, review_lbl.frame.origin.y+review_lbl.frame.size.height+30, 320, self.view.frame.size.height-(10+review_lbl.frame.origin.y+review_lbl.frame.size.height));
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(4,review_lbl.frame.origin.y+review_lbl.frame.size.height+94, 312, 1)];
    lab.backgroundColor=[UIColor colorWithRed:(230/255.0) green:(230/255.0) blue:(230/255.0) alpha:1];
    [self.view addSubview:lab];

//    scroll.contentSize=CGSizeMake(0, self.view.frame.size.height-(10+review_lbl.frame.origin.y+review_lbl.frame.size.height));
    
}
#pragma mark -
#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [comments_arr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict =[comments_arr objectAtIndex:indexPath.row];
    NSString *text = [dict valueForKey:@"comment"];
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:Regular size:12] constrainedToSize:CGSizeMake(comments.frame.size.width- 10 * 3, 1000.0f)];
    
    return textSize.height +20 +100;
    return 240;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"reviewCell";
    
    ReviewCustomCell *cell = (ReviewCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    /*if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }*/
    cell.Name.text=[NSString stringWithFormat:@"%@ %@",[[comments_arr objectAtIndex:indexPath.row] valueForKey:@"first_name"],[[comments_arr objectAtIndex:indexPath.row] valueForKey:@"last_name"]];
    NSString *strindate=[NSString stringWithFormat:@"%@",[[comments_arr objectAtIndex:indexPath.row] valueForKey:@"date_added"]];

    NSArray*sa=[strindate componentsSeparatedByString:@" "];
    if ([sa count]==2) {
        NSArray *date=[[sa objectAtIndex:0] componentsSeparatedByString:@"-"];
        // NSArray *time=[[sa objectAtIndex:1] componentsSeparatedByString:@":"];
        cell.review_date.text=[NSString stringWithFormat:@"%@",[sa objectAtIndex:0]];
        cell.review_date.textColor=[UIColor grayColor];
    }else{
    cell.review_date.text=[NSString stringWithFormat:@"%@",[[comments_arr objectAtIndex:indexPath.row] valueForKey:@"date_added"]];
    }
    

    cell.User_review.text=[NSString stringWithFormat:@"%@",[[comments_arr objectAtIndex:indexPath.row] valueForKey:@"comment"]];
    cell.review_rgt.text=[NSString stringWithFormat:@"Rated -%@",[[comments_arr objectAtIndex: indexPath.row]valueForKey:@"rating"]];
    
    
    CGSize textSize = [cell.User_review.text sizeWithFont:[UIFont fontWithName:Regular size:15] constrainedToSize:CGSizeMake(comments.frame.size.width - 10*3, 1000.0f)];
    
    CGRect rect=cell.User_review.frame;
    rect.size.height=textSize.height+20;
    
    cell.User_review.frame = rect;
    
   
    [cell.review_rgt setHidden:YES];
     
    return cell;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back_Btn_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
