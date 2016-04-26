//
//  PaymentViewController.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 10/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "PaymentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "OrderConfirmationView.h"

int cvv1=3;
int zipp1=5;

@interface PaymentViewController ()

@end

OrderConfirmationView *ordCnfView;
NSMutableDictionary *dict;

@implementation PaymentViewController
@synthesize dishId,quantity,isShopping,proDict,selectedCardDetails;
@synthesize CurrenCardDetails, CurrentUserProfile,customerProfileID;
@synthesize currentCardNumber, isLoadAction;
#pragma mark -
#pragma mark - ViewcontrollerLifeCycleMethods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    
    isLoadAction = YES;
    
    profileImg.layer.cornerRadius=36.0f;
    profileImg.layer.borderWidth=1.0f;
    profileImg.layer.masksToBounds=YES;
    profileImg.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
   // dropDwnBtn.imageEdgeInsets = UIEdgeInsetsMake(17, 0, 0, 0);
    
    Proceed_btn.layer.cornerRadius=3.0f;
    self.btnDelete.layer.cornerRadius=3.0f;
    self.btnUpdate.layer.cornerRadius=3.0f;
    
    
    self.lbltitle.font=[UIFont fontWithName:Regular size:17.0f];
    self.lblSaveCard.font=[UIFont fontWithName:SemiBold size:15.0f];
    self.lblCardNumber.font=[UIFont fontWithName:Regular size:16.0f];
    
    self.btnAddNewCard.titleLabel.font=[UIFont fontWithName:Bold size:14];
    self.btnDelete.titleLabel.font=[UIFont fontWithName:Bold size:16.0f];
    self.btnUpdate.titleLabel.font=[UIFont fontWithName:Bold size:16.0f];
    Proceed_btn.titleLabel.font=[UIFont fontWithName:Bold size:16.0f];

    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);

    
    selectdCard=0;
    listofcards=[[NSMutableArray alloc]init];
    
//    if(!IS_IPHONE5)
//    {
//        [Card_tbl setFrame:CGRectMake(20,190, 280, 210)];
//    }
    
    if(!IS_IPHONE5)
    {
        [self.scroll setContentSize:CGSizeMake(320, 415)];
    }
    
    compo=[[NSCalendar currentCalendar] components:(NSYearCalendarUnit|NSMonthCalendarUnit) fromDate:[NSDate date]];

    monthsArray=[[NSArray alloc]init];
    monthsArray=@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    
    yearsArray=[[NSMutableArray alloc]init];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    int year=(int)[components year];
    NSLog(@"%d",year%100);
    
    for (int i=0; i<=20; i++) {
        int j=year+i;
        [yearsArray addObject:[NSString stringWithFormat:@"%d",j]];
    }
    
    
    NSDictionary *dic=[[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfile"];
    UserName.font=[UIFont fontWithName:Bold size:15];
    
    NSMutableString *FullName = [[NSMutableString alloc] init];
    [FullName appendString: [dic valueForKey:@"first_name"]];
    [FullName appendString: @" "];
    [FullName appendString: [dic valueForKey:@"last_name"]];
    
    UserName.text= FullName;
    UserEmail.text=[dic valueForKey:@"email"];
    UserEmail.font=[UIFont fontWithName:SemiBold size:15];
    
    NSLog(@"is shoping:%@",isShopping);
    doublletap_lbl.font=[UIFont fontWithName:Medium size:12];
    
    id img=[dic valueForKey:@"image"];
    if ([img length]) {
        NSString *disturlStr=[NSString stringWithFormat:@"%@%@",UserURlImge,[dic valueForKey:@"image"]];
        
        [profileImg sd_setImageWithURL:[NSURL URLWithString:disturlStr] placeholderImage:[UIImage imageNamed:@"Dish_Placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             
             CGSize size = CGSizeMake(72, 72);
             if (image==nil) {
                 profileImg.image = [UIImage imageNamed:@"Dish_Placeholder"];
                 
             }else{
                 UIImage *croppedImage = [GlobalMethods imageByScalingAndCroppingForSize:size source:image];
                 profileImg.image = croppedImage;
             }
         }];
        
    }
    
    if (!_fromCheckOut)
    {
        [Proceed_btn setHidden:YES];
        [self.btnDelete setHidden:NO];
        self.btnMonth.userInteractionEnabled=YES;
        self.btnState.userInteractionEnabled=YES;
        self.btnYear.userInteractionEnabled=YES;
        self.txtAddress.userInteractionEnabled=YES;
        self.txtCity.userInteractionEnabled=YES;
        //self.txtCvv.userInteractionEnabled=YES;
        self.txtNameOnCard.userInteractionEnabled=YES;
        self.txtZip.userInteractionEnabled=YES;

    }
    else
    {        
        [Proceed_btn setHidden:NO];
        [self.btnDelete setHidden:YES];
        [self.btnUpdate setHidden:YES];
        [self.btnMonth setUserInteractionEnabled:NO];
        [self.btnState setUserInteractionEnabled:NO];
        [self.btnYear setUserInteractionEnabled:NO];
        
        for (UITextField *TF in [self.scroll subviews]) {
            if ([TF isKindOfClass:[UITextField class]]) {
                TF.userInteractionEnabled=NO;
            }
        }
    }
    [self getAuthnetCard:nil];
    self.txtCvv.text=@"XX";

    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClicked:)];
    
    
    NSArray *itemsArray = @[flexableItem,doneButton];
    [toolbar setItems:itemsArray];
    
    [self.txtZip setInputAccessoryView:toolbar];
    
    NSArray *ar=  [[NSUserDefaults standardUserDefaults] valueForKey:@"ListOfCards"];
    localCardsCount=[ar count];
    [self GetStatesList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
BOOL cardFlag=YES;

-(void) viewDidAppear:(BOOL)animated
{
    if(!isLoadAction && appDel.backButtonClick==NO)
    {
        [self ReloadCompleteData];
    }
    
    if(isLoadAction)
    {
        isLoadAction = !isLoadAction;
    }
    
}
- (NSArray *) GetStatesList
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"States"
                                                     ofType:@"plist"];
    
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithContentsOfFile:path];
    NSDictionary *names = [dict objectForKey:@"StatesList"];
    
    NSArray *array = [[names allKeys] sortedArrayUsingSelector:
                      @selector(compare:)];
    keys = array;
    
    return  keys;
}
- (void) ReloadCompleteData
{
    parseInt = 10;
    
    [self loginInBackGrounForAccessToken: nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSArray *ar=  [[NSUserDefaults standardUserDefaults] valueForKey:@"ListOfCards"];
    int ct=(int)[ar count];
    BOOL ssjj=appDel.backButtonClick;
    if (ct !=localCardsCount && appDel.backButtonClick==NO)
    {
        [self getAuthnetCard:nil];

        localCardsCount=ct;
        appDel.backButtonClick=NO;
    }


    tapint=0;
}

-(void)payMentDone{
    
    if (appDel.IsProcessComplete == YES) {
        [self.navigationController popToViewController:appDel.dishesVC animated:YES];
    }
    
}


#pragma mark
#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return [listofcards count];
    else
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PaymentCell";
    PaymentCell *cell = (PaymentCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        if(indexPath.section==0)
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if(indexPath.section== 0)
    {
        NSDictionary *dict=[listofcards objectAtIndex:indexPath.row];
        
//        if ([[dict allKeys]containsObject:@"customerPaymentProfileId"])
//        {
            cell.Name_lbl.text=[NSString stringWithFormat:@"XXXX %@",[dict valueForKey:@"last4"]];
        //}
//        else
//        {
//            NSString*card=[dict valueForKey:@"display"];
//            ////////////Replacing card number with X except last four numbers
//            //            NSError *error;
//            //            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d" options:NSRegularExpressionCaseInsensitive error:&error];
//            //            NSString *newString = [regex stringByReplacingMatchesInString:card options:0 range:NSMakeRange(0, [card length]-4) withTemplate:@"X"];
//            //
//            cell.Name_lbl.text=card;
//        }
        
    }
    
    return cell;
}
-(void)cardCheckdBtnClicked:(id)sender
{
    selectdCard=[sender tag]-111;
    [Card_tbl reloadData];
    
}
#pragma mark
#pragma mark - TableView Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 15;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    currentCardNumber = [self GetCardNumberForIndex : indexPath.row];
    
    NSDictionary *dict=[listofcards objectAtIndex:indexPath.row];
    selectedCardDetails=dict;
    
    self.lblCardNumber.text=[NSString stringWithFormat:@"XXXX %@", [dict valueForKey:@"last4"]];
    
    self.txtNameOnCard.text=[dict valueForKey:@"name"];
    
    if (_fromCheckOut){
        
        self.txtMonth.text=@"XX";
        self.txtYear.text=@"XX";
        self.txtCvv.text=@"XX";
    }
    else{
        NSMutableString *MonthString = [[NSMutableString alloc] init];
    
        
        if([[dict valueForKey:@"exp_month"] integerValue] < 10 && [[[dict valueForKey:@"exp_month"] stringValue] length] == 1)
        {
            [MonthString appendString: @"0"];
            [MonthString appendString: [[dict valueForKey:@"exp_month"] stringValue]];
        }
        else
        {
            [MonthString appendString: [[dict valueForKey:@"exp_month"] stringValue]];
        }
        self.txtMonth.text=MonthString;
        self.txtYear.text=[NSString stringWithFormat:@"%ld",[[dict valueForKey:@"exp_year"] integerValue]%100 ];
    }
    self.txtAddress.text=[dict valueForKey:@"address_line1"];
    self.txtCity.text=[dict valueForKey:@"address_city"] ;
    self.txtState.text=[dict valueForKey:@"address_state"] ;
    self.txtZip.text=[dict valueForKey:@"address_zip"];

    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [Card_tbl setFrame:CGRectMake(18,139,280,0)];
                     }
                     completion:^(BOOL finished){
                         [Card_tbl removeFromSuperview];
                         Card_tbl=nil;
                     }
     ];
    
    selectdCard=(int)indexPath.row;
    
//    if (indexPath.section==[listofcards count])
//    {
//        
//    }else
//    {
//        [[NSUserDefaults standardUserDefaults ]setObject:[listofcards objectAtIndex:indexPath.section] forKey:@"PrimaryCard"];
//    }
    
    [tableView reloadData];
    
}
#pragma mark
#pragma mark - Button Actions
- (IBAction)addNewCard:(id)sender {
    [self performSegueWithIdentifier:@"AddCardSegue" sender:self];
    
}

- (IBAction)showPicker:(id)sender {
    
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
        
        pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
        if ([sender tag]==10) {
            pickerview.tag=10;
            selectedMonth=@"01";
            selectedYear=NULL;
            selectedState=NULL;
            
        }
        else if ([sender tag]==20){
            pickerview.tag=20;
            selectedYear=[yearsArray objectAtIndex:0];
            selectedMonth=NULL;
            selectedState=NULL;
        }
        else{
            pickerview.tag=30;
            selectedState=@"AK";
            selectedYear=NULL;
            selectedMonth=NULL;
        }
        
        pickerview.dataSource = self;
        pickerview.delegate = self;
        pickerview.showsSelectionIndicator = YES;
        
        pickerview.showsSelectionIndicator = YES;
        
        action=[[UIActionSheet alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
        [action addSubview:pickerToolbar];
        [pickerview selectRow:0 inComponent:0 animated:YES];
        [action addSubview:pickerToolbar];
        [action addSubview:pickerview];
        
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
    pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    
    if ([sender tag]==10) {
        pickerview.tag=10;
        selectedMonth=@"01";
        selectedYear=NULL;
        selectedState=NULL;

    }
    else if ([sender tag]==20){
        pickerview.tag=20;
        selectedYear=[yearsArray objectAtIndex:0];
        selectedMonth=NULL;
        selectedState=NULL;
    }
    else{
        pickerview.tag=30;
        selectedState=@"AK";
        selectedYear=NULL;
        selectedMonth=NULL;
    }
    
    layerView.backgroundColor = [UIColor whiteColor];
    
    [layerView addSubview:pickerToolbar];
    
    pickerview.dataSource = self;
    pickerview.delegate = self;
    pickerview.showsSelectionIndicator = YES;
    
    pickerview.showsSelectionIndicator = YES;
    
    [layerView addSubview:pickerview];
    
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
    //NSLog(@"Selected State: %@", selectedState);
    if (selectedState!=NULL) {
        self.txtState.text=selectedState;
        // [btnStates setTitle:selectedState forState:UIControlStateNormal];
        
    }
    if (selectedMonth!=NULL) {
        self.txtMonth.text=selectedMonth;
        
    }
    if (selectedYear!=NULL) {
        self.txtYear.text=[NSString stringWithFormat:@"%ld", [selectedYear integerValue] %100];
    }
    [self DismissStatePickerView];
    
    [self.view endEditing:YES];
    //[scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void) DismissStatePickerView
{
    if(action)
    {
        [action dismissWithClickedButtonIndex:0 animated:YES];
        action=nil;
        pickerview=nil;
        pickerview.delegate=nil;
        pickerview.dataSource=nil;
    }
    
    [stateActionSheet dismissViewControllerAnimated:YES completion:nil];
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


#pragma mark -
#pragma mark - PickerView DataSOurces
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerview.tag == 10) {
        return monthsArray.count;
    }
    else if (pickerview.tag==20) {
        return yearsArray.count;
    }
    else
        return [keys count];
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerview.tag == 10) {
        return [NSString stringWithFormat:@"%@",  monthsArray[row]];
    }
    else if (pickerview.tag==20) {
        return [NSString stringWithFormat:@"%@",  yearsArray[row]];
    }
    else        
        return [NSString stringWithFormat:@"%@",  keys[row]]; //[[keys objectAtIndex:row]valueForKey:@"title"];
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
    
    if (pickerview.tag == 10) {
        tView.text= [NSString stringWithFormat:@"%@",  monthsArray[row]];
    }
    else if (pickerview.tag==20) {
        tView.text= [NSString stringWithFormat:@"%@",  yearsArray[row]];
    }
    else{
        NSString *state =  [NSString stringWithFormat:@"%@",  keys[row]]; //[[keys objectAtIndex:row]valueForKey:@"title"];
        tView.text = state;
    }
    
    return tView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerview.tag == 10) {
        self.txtMonth.text=[NSString stringWithFormat:@"%@",  monthsArray[row]];
        selectedMonth=[NSString stringWithFormat:@"%@",  monthsArray[row]];

    }
    else if (pickerview.tag == 20) {
        self.txtYear.text=[NSString stringWithFormat:@"%li", [ yearsArray[row] integerValue]%100];
        selectedYear=[NSString stringWithFormat:@"%li", [yearsArray[row] integerValue]%100];

    }
    else{
        self.txtState.text = [NSString stringWithFormat:@"%@",  keys[row]];
        selectedState=[NSString stringWithFormat:@"%@",  keys[row]];
    }
}
#pragma mark -
#pragma mark - UITextField Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];

    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSUInteger tag = [textField tag];
    [self animateView:tag];
   
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSCharacterSet *blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
    
    if (textField == self.txtNameOnCard ) {
        return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
    }
    if(textField.tag==5)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > cvv1) ? NO : YES;
        
    }else if (textField.tag==3 || textField.tag==4)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 2) ? NO : YES;
        
    }
    else if (textField.tag==9)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > zipp1) ? NO : YES;
        
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (void)animateView:(NSUInteger)tag
{
    if(IS_IPHONE5)
    {
        //        if (tag > 7)
        //            [scroll setContentOffset:CGPointMake(0, 65.0f * (tag - 7)) animated:YES];
        //        else if (tag ==1 || tag==2)
        //            [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
        //        else
        //    [scroll setContentOffset:CGPointMake(0, 44.0f * 2) animated:YES];
        
        if (tag > 5 & tag < 7)
            [_scroll setContentOffset:CGPointMake(0, 65.0f * (2)) animated:YES];
        else if (tag ==1 || tag==2)
            [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
        else if (tag == 7 || tag == 8)
            [_scroll setContentOffset:CGPointMake(0, 65.0f * (3)) animated:YES];
        else if (tag == 9)
            [_scroll setContentOffset:CGPointMake(0, 65.0f * (4)) animated:YES];
        else
            [_scroll setContentOffset:CGPointMake(0, 44.0f * 2) animated:YES];
    }
    else
    {
        if (tag > 8)
            [_scroll setContentOffset:CGPointMake(0, 55.0f * (tag - 8)) animated:YES];
        else
            [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
-(void)doneButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
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
            //[self performSegueWithIdentifier:@"PaymentSegue" sender:self];
        }else if (myIndexPath.row == 2){
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
/////////////////////////////////


- (void) addNewCardDetails: (CardDetails *) CurrentCard;
{
    if (hud==nil)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    
    NSLog(@"Access Token: %@", appDel.accessToken);
    
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     //appDel.CurrentCustomerDetails.user_auth_id, @"customerProfileId",
     appDel.accessToken, @"accessToken",
     //appDel.accessToken, @"customerProfileId",
     CurrentCard.card_name,@"firstName",
     CurrentCard.card_name,@"lastName",
     CurrentCard.card_address,@"address",
     CurrentCard.card_city,@"city",
     CurrentCard.card_state,@"state",
     CurrentCard.card_zip,@"zipcode",
     CurrentCard.card_type,@"cardType",
     CurrentCard.card_number,@"cardNumber",
     CurrentCard.card_month,@"cardExpMonth",
     CurrentCard.card_year,@"cardExpYear",
     CurrentCard.card_cvv,@"cardCVV",
     nil];
    
    [parser parseAndGetDataForPostMethod:params withUlr:@"addauthcard"];
}

- (NSString *) GetCardNumberForIndex : (NSInteger) CardIndexInt
{
    if(listofcards.count < 1)
    {
        return @"";
    }
    
    NSDictionary *cardDetails = [listofcards objectAtIndex:CardIndexInt];
    
//    if ([[cardDetails allKeys]containsObject:@"customerPaymentProfileId"])
//    {
        return  [NSString stringWithFormat:@"%@", [cardDetails valueForKey:@"id"]];
   // }
    
}

- (void) GetCardDetailsFromAPI : (NSMutableArray *) ListOfCards
{
    [appDel.objDBClass ClearCardDetails];
    NSDictionary *params;
    for(NSDictionary *cardDetails in ListOfCards)
    {
        if ([[cardDetails allKeys]containsObject:@"customerPaymentProfileId"])
        {
            if ([_promoType  isEqualToString:@""])
            {
                params = [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken,@"accessToken",[[cardDetails valueForKey:@"billTo"] valueForKey:@"firstName"],@"firstname",[[cardDetails valueForKey:@"billTo"] valueForKey:@"lastName"],@"lastname",[[cardDetails valueForKey:@"billTo"] valueForKey:@"zip"],@"zip",[[cardDetails valueForKey:@"billTo"] valueForKey:@"address"],@"address",[[cardDetails valueForKey:@"billTo"] valueForKey:@"city"],@"city",[[cardDetails valueForKey:@"billTo"] valueForKey:@"state"],@"state",[cardDetails valueForKey:@"customerPaymentProfileId"],@"cardNumber",dishId,@"dishId",quantity,@"quantity",@"0",@"newCardPayment",nil];
            }
            else
            {
                params = [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken,@"accessToken",[[cardDetails valueForKey:@"billTo"] valueForKey:@"firstName"],@"firstname",[[cardDetails valueForKey:@"billTo"] valueForKey:@"lastName"],@"lastname",[[cardDetails valueForKey:@"billTo"] valueForKey:@"zip"],@"zip",[[cardDetails valueForKey:@"billTo"] valueForKey:@"address"],@"address",[[cardDetails valueForKey:@"billTo"] valueForKey:@"city"],@"city",[[cardDetails valueForKey:@"billTo"] valueForKey:@"state"],@"state",[cardDetails valueForKey:@"customerPaymentProfileId"],@"cardNumber",dishId,@"dishId",quantity,@"quantity",@"0",@"newCardPayment",_promoType,@"promoType",nil];
            }
        }
        else
        {
            NSDictionary *profileDict=[[NSUserDefaults standardUserDefaults ]valueForKey:@"UserProfile"];
            
            if ([_promoType  isEqualToString:@""])
            {
                params = [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken,@"accessToken",[profileDict valueForKey:@"first_name"],@"firstname",[profileDict valueForKey:@"last_name"],@"lastname",[profileDict valueForKey:@"zipcode"],@"zip",[cardDetails valueForKey:@"address"],@"address",[cardDetails valueForKey:@"city"],@"city",[cardDetails valueForKey:@"state"],@"state",[cardDetails valueForKey:@"CardNumber"],@"cardNumber",[cardDetails valueForKey:@"CVV"],@"cardCVV",[cardDetails valueForKey:@"YearOfExpire"],@"cardExpYear",[cardDetails valueForKey:@"MonthOfExpire"],@"cardExpMonth",[cardDetails valueForKey:@"cardType"],@"cardType",dishId,@"dishId",quantity,@"quantity",@"1",@"newCardPayment",nil];
            }
            else
            {
                params = [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken,@"accessToken",[profileDict valueForKey:@"first_name"],@"firstname",[profileDict valueForKey:@"last_name"],@"lastname",[profileDict valueForKey:@"zipcode"],@"zip",[cardDetails valueForKey:@"address"],@"address",[cardDetails valueForKey:@"city"],@"city",[cardDetails valueForKey:@"state"],@"state",[cardDetails valueForKey:@"CardNumber"],@"cardNumber",[cardDetails valueForKey:@"CVV"],@"cardCVV",[cardDetails valueForKey:@"YearOfExpire"],@"cardExpYear",[cardDetails valueForKey:@"MonthOfExpire"],@"cardExpMonth",[cardDetails valueForKey:@"cardType"],@"cardType",dishId,@"dishId",quantity,@"quantity",@"1",@"newCardPayment",_promoType,@"promoType",nil];
            }
        }
    }
    
    //ADD CARD DETAILS
    
    
    CurrenCardDetails = [[CardDetails alloc] init];
    CurrenCardDetails.card_type = [params objectForKey:@"cardType"];
    CurrenCardDetails.card_name = [params objectForKey:@"NameOnCard"];
    CurrenCardDetails.card_number = [params objectForKey:@"cardNumber"];
    CurrenCardDetails.card_month = [params objectForKey:@"MonthOfExpire"];
    CurrenCardDetails.card_year = [params objectForKey:@"YearOfExpire"];
    CurrenCardDetails.card_cvv = [params objectForKey:@"CVV"];
    CurrenCardDetails.card_address = [params objectForKey:@"address"];
    CurrenCardDetails.card_city = [params objectForKey:@"city"];
    CurrenCardDetails.card_state = [params objectForKey:@"state"];
    CurrenCardDetails.card_zip = [params objectForKey:@"zipcode"];
    CurrenCardDetails.card_display = [params objectForKey:@"display"];
    
    
    [appDel.objDBClass InsertCardDetails:CurrenCardDetails];
}
-(void)setdataForInitialCard:(NSDictionary *)card{
    self.lblCardNumber.text=[NSString stringWithFormat:@"XXXX %@", [card valueForKey:@"last4"]];
    [self.lblCardNumber setTextColor:[UIColor blackColor]];
    
    self.txtNameOnCard.text=[card valueForKey:@"name"];
    self.dopDownImg.hidden=NO;
    self.lblSaveCard.hidden=NO;
    self.lblOr.hidden=NO;
    if (_fromCheckOut){
        
        self.txtMonth.text=@"XX";
        self.txtYear.text=@"XX";
        self.txtCvv.text=@"XX";
    }
    else{
        NSMutableString *MonthString = [[NSMutableString alloc] init];
        
        
        if([[card valueForKey:@"exp_month"] integerValue] < 10 && [[[card valueForKey:@"exp_month"] stringValue] length] == 1)
        {
            [MonthString appendString: @"0"];
            [MonthString appendString: [[card valueForKey:@"exp_month"] stringValue]];
        }
        else
        {
            [MonthString appendString: [[card valueForKey:@"exp_month"]stringValue]];
        }
        self.txtMonth.text=MonthString;
        self.txtYear.text=[NSString stringWithFormat:@"%ld",[[card valueForKey:@"exp_year"] integerValue]%100 ];
    }
    self.txtAddress.text=[card valueForKey:@"address_line1"];
    self.txtCity.text=[card valueForKey:@"address_city"] ;
    self.txtState.text=[card valueForKey:@"address_state"] ;
    self.txtZip.text=[card valueForKey:@"address_zip"];
    currentCardNumber=[card valueForKey:@"id"];
}
#pragma mark
#pragma mark - HUD Delegtes
- (void)hudWasHidden:(MBProgressHUD *)huda {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    hud = nil;
}

#pragma mark
#pragma mark - ParseAndGetData Delegates

-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    NSLog(@"Payment View Result: %@", result);
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
//    BOOL errMsg=[[result valueForKey:@"error"]boolValue];
//    
//    if (errMsg) {
//        [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
//        
//    }
//    else{
    
        
        if (parseInt==1 || parseInt==4)
        {
            id res =result;
            if([res isKindOfClass:[NSArray class]])
            {
                
                [listofcards removeAllObjects];
                [listofcards addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"ListOfCards"]];
                [Card_tbl reloadData];
            }
            else
            {
                [listofcards removeAllObjects];
                
               // customerProfileID=[[result valueForKey:@"paymentDetails"] valueForKey:@"customerProfileId"];
                
                id res =[[[result valueForKey:@"customerStripeData"] valueForKey:@"sources"] valueForKey:@"data"] ;
                if([res isKindOfClass:[NSArray class]])
                {
                    NSArray *locArr=[[[result valueForKey:@"customerStripeData"] valueForKey:@"sources"] valueForKey:@"data"];
                    [listofcards addObjectsFromArray:locArr];
                }
                else
                {
                    id paymentProfileDetails =
                    [[[result valueForKey:@"customerStripeData"] valueForKey:@"sources"] valueForKey:@"data"];
                    
                    if(paymentProfileDetails)
                    {
                        [listofcards addObject: [[[result valueForKey:@"customerStripeData"] valueForKey:@"sources"] valueForKey:@"data"]];
                    }
                    
                }
                [listofcards addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"ListOfCards"]];
                
                if(parseInt != 4)
                {
                    [self GetCardDetailsFromAPI: listofcards];
                }
                
                [Card_tbl reloadData];
                if (listofcards.count) {
                    [self setdataForInitialCard:[listofcards objectAtIndex:0]];
                    selectedCardDetails=[listofcards objectAtIndex:0];
                    self.cardDetailView.hidden=NO;
                }
                else{
                    
                    if (_fromCheckOut && localCardsCount==0) {
                      // [self performSegueWithIdentifier:@"AddCardSegue" sender:self];

                    }
                    else{
                        self.lblCardNumber.text=@"No cards saved as of now";
                        [self.lblCardNumber setTextColor:[UIColor lightGrayColor]];
                        self.dopDownImg.hidden=YES;
                        self.cardDetailView.hidden=YES;
                        self.lblSaveCard.hidden=YES;
                        self.lblOr.hidden=YES;
                    }
                }
            }
            
            if (listofcards.count==0) {
                
                [self addNewCard:nil];
            }
        }
        else if (parseInt==3)
        {
            if (hud==nil)
            {
                hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                hud.delegate = self;
                [hud show:YES];
                [self.view addSubview:hud];
            }
            
            parseInt = 10;
            [appDel.objDBClass DeleteCardDetails: currentCardNumber];
            //[self ReloadCompleteData];
            [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
            
            self.lblCardNumber.text=nil;
            self.txtNameOnCard.text=nil;
            if (_fromCheckOut){
                self.txtMonth.text=@"XX";
                self.txtYear.text=@"XX";
                self.txtCvv.text=@"XX";
            }
            
            self.txtAddress.text=nil;
            self.txtCity.text=nil;
            self.txtState.text=nil;
            self.txtZip.text=nil;
            
            [self loginInBackGrounForAccessToken: nil];
        }
        else if (parseInt == 10)
        {
            if (hud==nil)
            {
                hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                hud.delegate = self;
                [hud show:YES];
                [self.view addSubview:hud];
            }
            
            appDel.accessToken = [result valueForKey:@"accessToken"];
            parseInt = 4;
            [self getAuthnetCard:nil];
        }
        else if (parseInt == 12)
        {
            BOOL errMsg=[[result valueForKey:@"error"]boolValue];
            if(errMsg)
            {
                [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
            }
            else
            {
                [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
                parseInt = 4;
                [self getAuthnetCard:nil];
            }
        }
        else
        {
            BOOL errMsg=[[result valueForKey:@"error"]boolValue];
            if(errMsg)
            {
                [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
            }
            else
            {
                
            [self getOrderView:result];
                
              appDel.IsProcessComplete = YES;
                
                NSDictionary *profileDict=[result valueForKey:@"userDetails"];
                
                NSDictionary *user;
            
                dict=[[NSMutableDictionary alloc]init];
                user=[[[NSUserDefaults standardUserDefaults ] valueForKey:@"UserProfile"] mutableCopy];
                
                dict=[user mutableCopy];
                NSMutableArray *add=[[NSMutableArray alloc]init];

                NSDictionary *address=appDel.deliveryAddr;
                if (([address valueForKey:@"address_id"] == nil||[[address valueForKey:@"address_id"] isEqualToString:@""]) && [[address valueForKey:@"delivery_type"] integerValue] ==2) {
                   
                    if([dict valueForKey:@"deliveryAddresses"] != nil){
                        add= [[dict valueForKey:@"deliveryAddresses"]mutableCopy];
                    }
                    //[add addObject:[[dict valueForKey:@"deliveryAddresses"]mutableCopy]];
                    NSMutableDictionary *addr=(NSMutableDictionary*)[[result valueForKey:@"deliveryAddress"] mutableCopy];
                    [add addObject:addr];
                    [dict setObject:add forKey:@"deliveryAddresses"];
                }

              
                [dict setValue:[profileDict valueForKey:@"is_discount_applied"] forKey:@"is_discount_applied"];
                [dict setValue:[profileDict valueForKey:@"ref_promo_count"] forKey:@"ref_promo_count"];

                // count = [[dict valueForKey:@"ref_promo_count"] integerValue];
                
                
                [[NSUserDefaults standardUserDefaults ] setObject:dict forKey:@"UserProfile"];
                [[NSUserDefaults standardUserDefaults ] synchronize];

                //mixpanel api call
                
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                
                [mixpanel track:@"Succesfull Order_iOSMobile" properties:nil];
                
            }
        }
    
    [hud hide:YES];
    [hud removeFromSuperview];
    hud=nil;
}
-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    [hud hide:YES];
    [GlobalMethods showAlertwithString:err];
}

-(void)getOrderView:(NSDictionary *)result{
    
    ordCnfView =[[OrderConfirmationView alloc]init];
    ordCnfView.orderDetails=result;
    ordCnfView.disDetails=proDict;
    
    CGRect rec=ordCnfView.view.frame;
    ordCnfView.view.frame=rec;
    [self.view addSubview:ordCnfView.view];
    [self.view bringSubviewToFront:ordCnfView.view];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:ordCnfView.view cache:YES];
    [UIView setAnimationDuration:1.0f];
    ordCnfView.view.frame=rec;
    [UIView commitAnimations];
}
-(void)getAuthnetCard:(id)sender
{
    if (hud==nil)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    parseInt=1;
    
    NSLog(@"Access Token: %@", appDel.accessToken);
    
    NSString *urlquerystring=[NSString stringWithFormat:@"getCards?accessToken=%@",appDel.accessToken];
    
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    [parser parseAndGetDataForGetMethod:urlquerystring];
    
}

- (IBAction)updateCardDetails:(id)sender {
    
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];

    NSString *yearstr=[NSString stringWithFormat:@"%ld",(long)compo.year];
    yearstr =[yearstr substringFromIndex:2];
    
//    if (![self.txtCvv.text length])
//    {
//        [GlobalMethods showAlertwithString:@"Please enter cvv"];
//        return;
//    }
     if (![self.txtZip.text length])
    {
        [GlobalMethods showAlertwithString:@"Please enter Zipcode"];
        return;
    }
    else if (![self.txtNameOnCard.text length])
    {
        [GlobalMethods showAlertwithString:@"Please enter name on card"];
        return;
    }
   /* else if (![self.txtMonth.text length])
    {
        [GlobalMethods showAlertwithString:@"Please enter month of card expiry"];
        return;
    }
    else  if ([self.txtMonth.text integerValue] > 12
              || ([self.txtMonth.text integerValue] <compo.month
                  && [self.txtYear.text integerValue]==[yearstr integerValue]))
    {
        [GlobalMethods showAlertwithString:@"Please enter valid month of card expiry"];
        return;
    }
    else if (![self.txtYear.text length]){
        
        [GlobalMethods showAlertwithString:@"Please enter year of card expiry"];
        return;
    }
    
    else  if ([self.txtYear.text integerValue] < [yearstr integerValue]) {
        [GlobalMethods showAlertwithString:@"Please enter valid year of card expiry"];
        return;
    }*/
    
    else if (![self.txtAddress.text length]){
        [GlobalMethods showAlertwithString:@"Please enter address"];
        return;
    }else if (![self.txtState.text length])
    {
        [GlobalMethods showAlertwithString:@"Please enter State"];
        return;
    }
    else if (![self.txtCity.text length]){
        [GlobalMethods showAlertwithString:@"Please enter city"];
        return;
    }
    else if ([self.txtZip.text length]<5)
    {
        [GlobalMethods showAlertwithString:@"Please enter valid zipcode"];
        return;
    }
    
    NSMutableString *MonthString = [[NSMutableString alloc] init];
    
    if([self.txtMonth.text integerValue] < 10 && self.txtMonth.text.length == 1)
    {
        [MonthString appendString: @"0"];
        [MonthString appendString: self.txtMonth.text];
    }
    else
    {
        [MonthString appendString: self.txtMonth.text];
    }
    if (hud==nil)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    parseInt=12;
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken,@"accessToken",[selectedCardDetails valueForKey:@"id"],@"cardId",self.txtNameOnCard.text,@"firstName",self.txtAddress.text,@"address",self.txtCity.text,@"city",self.txtState.text,@"state",self.txtZip.text,@"zip",MonthString,@"cardExpMonth",self.txtYear.text,@"cardExpYear", nil];
    
    [parser parseAndGetDataForPostMethod:params withUlr:@"updateStripeCard"];

}
-(IBAction)processdBtnClicked:(id)sender;

{
    NSDictionary *address=appDel.deliveryAddr;
    if (![listofcards count])
    {
        [GlobalMethods showAlertwithString:@"Please add a Card to proceed"];
        return;
    }
    
    
    if (hud==nil)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];
    }
    NSDictionary *cardDetails=[listofcards objectAtIndex:selectdCard];
    
    parseInt=2;
    NSDictionary *params;
    /////check if card  stored in server
//    if ([[cardDetails allKeys]containsObject:@"default_source"])
//    {
    
    ////////////
    
    
        if ([_promoType  isEqualToString:@""])
        {
            params = [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken,@"accessToken",[cardDetails valueForKey:@"name"],@"firstname",[cardDetails valueForKey:@"address_zip"],@"zip",[cardDetails valueForKey:@"address_line1"],@"address",[cardDetails valueForKey:@"address_city"],@"city",[cardDetails  valueForKey:@"address_state"],@"state",[cardDetails valueForKey:@"id"],@"cardId",[NSString stringWithFormat:@"%@",dishId],@"dishId",[NSString stringWithFormat:@"%@",appDel.dateSelectedId],@"availability_id",[NSString stringWithFormat:@"%@",quantity],@"quantity",@"0",@"newCardPayment",[NSString stringWithFormat:@"%@",isShopping], @"isShoppingPromo",[address valueForKey:@"delivery_address"],@"delivery_address",[address valueForKey:@"delivery_city"],@"delivery_city",[address valueForKey:@"delivery_state"],@"delivery_state",[address valueForKey:@"delivery_zip"],@"delivery_zip",[address valueForKey:@"delivery_phone"],@"delivery_phone",[address valueForKey:@"address_id"],@"delivery_address_id",[address valueForKey:@"delivery_suiteNo"],@"delivery_suite",[address valueForKey:@"delivery_instructions"],@"delivery_instructions",[address valueForKey:@"delivery_type"],@"order_type",appDel.tipPercent,@"tip",nil];
        }
        else
        {
            params = [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken,@"accessToken",[cardDetails valueForKey:@"name"],@"firstname",[cardDetails  valueForKey:@"address_zip"],@"zip",[cardDetails  valueForKey:@"address_line1"],@"address",[cardDetails valueForKey:@"address_city"],@"city",[cardDetails  valueForKey:@"address_state"],@"state",[cardDetails valueForKey:@"id"],@"cardId",[NSString stringWithFormat:@"%@",dishId],@"dishId",[NSString stringWithFormat:@"%@",appDel.dateSelectedId],@"availability_id",[NSString stringWithFormat:@"%@",quantity],@"quantity",@"0",@"newCardPayment",[NSString stringWithFormat:@"%@",_promoType],@"promoType",[NSString stringWithFormat:@"%@",isShopping],@"isShoppingPromo",[address valueForKey:@"delivery_address"],@"delivery_address",[address valueForKey:@"delivery_city"],@"delivery_city",[address valueForKey:@"delivery_state"],@"delivery_state",[address valueForKey:@"delivery_zip"],@"delivery_zip",[address valueForKey:@"delivery_phone"],@"delivery_phone",[address valueForKey:@"address_id"],@"delivery_address_id",[address valueForKey:@"delivery_suiteNo"],@"delivery_suite",[address valueForKey:@"delivery_instructions"],@"delivery_instructions",[address valueForKey:@"delivery_type"],@"order_type",appDel.tipPercent,@"tip",nil];
        }
    
    
//    }
//    else
//    {
//        NSDictionary *profileDict=[[NSUserDefaults standardUserDefaults]valueForKey:@"UserProfile"];
//        
//        if ([_promoType  isEqualToString:@""])
//        {
//            params = [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken,@"accessToken",[profileDict valueForKey:@"first_name"],@"firstname",[profileDict valueForKey:@"last_name"],@"lastname",[profileDict valueForKey:@"zipcode"],@"zip",[cardDetails valueForKey:@"address"],@"address",[cardDetails valueForKey:@"city"],@"city",[cardDetails valueForKey:@"state"],@"state",[cardDetails valueForKey:@"CardNumber"],@"cardNumber",[cardDetails valueForKey:@"CVV"],@"cardCVV",[cardDetails valueForKey:@"YearOfExpire"],@"cardExpYear",[cardDetails valueForKey:@"MonthOfExpire"],@"cardExpMonth",[cardDetails valueForKey:@"cardType"],@"cardType",dishId,@"dishId",quantity,@"quantity",@"1",@"newCardPayment",isShopping,@"isShoppingPromo",nil];
//        }
//        else
//        {
//            params = [NSDictionary dictionaryWithObjectsAndKeys:appDel.accessToken,@"accessToken",[profileDict valueForKey:@"first_name"],@"firstname",[profileDict valueForKey:@"last_name"],@"lastname",[profileDict valueForKey:@"zipcode"],@"zip",[cardDetails valueForKey:@"address"],@"address",[cardDetails valueForKey:@"city"],@"city",[cardDetails valueForKey:@"state"],@"state",[cardDetails valueForKey:@"CardNumber"],@"cardNumber",[cardDetails valueForKey:@"CVV"],@"cardCVV",[cardDetails valueForKey:@"YearOfExpire"],@"cardExpYear",[cardDetails valueForKey:@"MonthOfExpire"],@"cardExpMonth",[cardDetails valueForKey:@"cardType"],@"cardType",dishId,@"dishId",quantity,@"quantity",@"1",@"newCardPayment",_promoType,@"promoType",isShopping,@"isShoppingPromo",nil];
//        }
//    }
    [parser parseAndGetDataForPostMethod:params withUlr:@"orderStripePayment"];
}

#pragma mark -
#pragma mark - alertview
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        appDel.CurrentCustomerDetails = [appDel.objDBClass GetUserProfileDetails];
        
        NSLog(@"Profile : %@, %@", customerProfileID,
              appDel.CurrentCustomerDetails.user_first_name);
        
        parseInt = 3;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                appDel.accessToken,@"accessToken",
                                currentCardNumber, @"cardId",
                                nil];
        //
        [parser parseAndGetDataForPostMethod:params withUlr:@"deleteStripeCard"];
        if (hud==nil)
        {
            hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            hud.delegate = self;
            [hud show:YES];
            [self.view addSubview:hud];
        }
        [appDel.objDBClass DeleteCardDetails: currentCardNumber];
    }
}


#pragma mark
#pragma mark - User Defined methods
-(void)loginInBackGrounForAccessToken:(NSDictionary*)dict
{
    CurrentUserProfile = appDel.CurrentCustomerDetails;
    
    
    parseInt=10;
    if (hud==nil)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.delegate = self;
        [hud show:YES];
        [self.view addSubview:hud];

    }
    NSString *devicetoken=[GlobalMethods getUDIDOfdevice];
    CurrentUserProfile = [appDel.objDBClass GetUserProfileDetails];
    
    //    if([[dict allKeys]containsObject:@"twitter_id"])
    if(CurrentUserProfile.user_twitter != nil && CurrentUserProfile.user_twitter.length > 1)
    {
        //        NSString *urlquerystring=[NSString stringWithFormat:@"checkTWUser?twitterId=%@",[dict objectForKey:@"twitter_id"]];
        //        [parser parseAndGetDataForGetMethod:urlquerystring];
        
//        NSString *urlquerystring=
//        [NSString stringWithFormat:@"checkTWUser?twitterId=%@", CurrentUserProfile.user_twitter];
//        [parser parseAndGetDataForGetMethod:urlquerystring];
        NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:CurrentUserProfile.user_twitter,@"twitterId", nil];
        [parser parseAndGetDataForPostMethod:params withUlr:@"checkTWUser"];
    }
    
    //else if([[dict allKeys]containsObject:@"facebook_id"])
    else if(CurrentUserProfile.user_fb != nil && CurrentUserProfile.user_fb.length > 1)
    {
        //        NSString *urlquerystring=
        //        [NSString stringWithFormat:@"checkFBUser?facebookId=%@",[dict objectForKey:@"facebook_id"]];
        //        [parser parseAndGetDataForGetMethod:urlquerystring];
        
        NSString *urlquerystring=
        [NSString stringWithFormat:@"checkFBUser?facebookId=%@&email=%@",
         CurrentUserProfile.user_fb, CurrentUserProfile.user_email];
        [parser parseAndGetDataForGetMethod:urlquerystring];
        
        
    }
    else if (CurrentUserProfile!=nil)
    {
        //            emailFld.text=[dict valueForKey:@"Email"];
        //            passwdFld.text=[dict valueForKey:@"Password"];
        NSDictionary *dict=[[NSUserDefaults standardUserDefaults]valueForKey:@"credentials"];

        
        NSDictionary *params= [NSDictionary dictionaryWithObjectsAndKeys:
                               CurrentUserProfile.user_email, @"email",
                               [dict valueForKey:@"Password"], @"password",
                               CurrentUserProfile.user_devicetoken,@"devicetoken",nil];
        [parser parseAndGetDataForPostMethod:params withUlr:@"customerLogin"];
        
    }
    else
    {
        //[self getDishes];
    }
}

#pragma mark -
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //    if ([segue.identifier isEqualToString:@"AddCardSegue"]) {
    //        addNewCard *controller = ([segue.destinationViewController isKindOfClass:[addNewCard class]]) ? segue.destinationViewController : nil;
    //        NSIndexPath *indexPath =( NSIndexPath *)sender;
    //        if(indexPath.section==0){
    //            controller.cardDetails=[listofcards objectAtIndex:selectdCard];
    //
    //        }
    //    }
}
- (IBAction)showCards:(id)sender {
    
    if(Card_tbl==nil)
    {
        Card_tbl =[[UITableView alloc] init];
        [Card_tbl setFrame:CGRectMake(18,139,280,0)];
        Card_tbl.delegate=(id)self;
        Card_tbl.dataSource=(id)self;
        [self.view addSubview:Card_tbl];
        [self.view bringSubviewToFront:Card_tbl];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [Card_tbl setFrame:CGRectMake(18,139,280,listofcards.count*35)];
        [UIView commitAnimations];
        
    }
    else
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [Card_tbl setFrame:CGRectMake(18,139,280,0)];
                         }
                         completion:^(BOOL finished){
                             [Card_tbl removeFromSuperview];
                             Card_tbl=nil;
                         }
         ];
    }
}

- (IBAction)deleteCard:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppTitle message:@"Do you wish to delete this card?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Delete",@"Cancel" ,nil];
    [alert show];
    
}
@end