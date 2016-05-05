//
//  addNewCard.m
//  EnjoyFresh
// initial commit afffafdsfdsfds
//  Created by Mohnish vardhan on 30/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "addNewCard.h"
#import "GlobalMethods.h"
#import "Global.h"
#define FIELDS_COUNT  9

@interface addNewCard ()
@end
int cvv=3;
int cardno=16;
int zipp=5;


@implementation addNewCard
@synthesize cardDetails, CurrenCardDetails;

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
    //dropDownBtn.imageEdgeInsets = UIEdgeInsetsMake(17, 0, 0, 0);
    
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=(id)self;
    
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);

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

    done_Btn_full.layer.cornerRadius=3.0f;
    btnStates.titleLabel.font=[UIFont fontWithName:Regular size:16.0f];
    [btnStates setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view from its nib.
//    nameOnCard=[GlobalMethods setPlaceholdText:@"Name on Card" forTxtFld:nameOnCard];
//    cardNumber=[GlobalMethods setPlaceholdText:@"Card Number" forTxtFld:cardNumber];
//    //experationDate=[GlobalMethods setPlaceholdText:@"Experation Date" forTxtFld:experationDate];
//    year_lbl=[GlobalMethods setPlaceholdText:@"YYYY" forTxtFld:year_lbl];
//    month_lbl=[GlobalMethods setPlaceholdText:@"MM" forTxtFld:month_lbl];
//
//    cVV=[GlobalMethods setPlaceholdText:@"CVV" forTxtFld:cVV];
//    cardAddress=[GlobalMethods setPlaceholdText:@"Address" forTxtFld:cardAddress];
//    cardCity=[GlobalMethods setPlaceholdText:@"City" forTxtFld:cardCity];
//    cardZipCode=[GlobalMethods setPlaceholdText:@"ZipCode" forTxtFld:cardZipCode];
//    cardState=[GlobalMethods setPlaceholdText:@"State" forTxtFld:cardState];
    headerLbl.font=[UIFont fontWithName:Regular size:14];
    
    
    master_card_btn.titleLabel.font=[UIFont fontWithName:Regular size:15];
    visa_Card_btn.titleLabel.font=[UIFont fontWithName:Regular size:15];
    Discover_card_btn.titleLabel.font=[UIFont fontWithName:Regular size:15];
    master_card_btn.titleLabel.font=[UIFont fontWithName:Regular size:15];

    CGRect pickerFrame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height-182,320,0);
    datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    datePicker.datePickerMode=UIDatePickerModeDate;

    datePicker.minimumDate=[NSDate date];
    
    compo=[[NSCalendar currentCalendar] components:(NSYearCalendarUnit|NSMonthCalendarUnit) fromDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(valueChanged)forControlEvents:UIControlEventValueChanged];
   /// [self.view addSubview:datePicker];
    //[self.view bringSubviewToFront:datePicker];
    
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClicked:)];
    barButtonPrev = [[UIBarButtonItem alloc] initWithTitle:@"Prev"  style:UIBarButtonItemStyleDone target:self action:@selector(previousButtonClicked:)];
    barButtonNext = [[UIBarButtonItem alloc] initWithTitle:@"Next"  style:UIBarButtonItemStyleDone target:self action:@selector(nextButtonClicked:)];
    
    
    
    NSArray *itemsArray = @[barButtonPrev,barButtonNext,flexableItem,doneButton];
    [toolbar setItems:itemsArray];
    
    [nameOnCard setInputAccessoryView:toolbar];
    [cardNumber setInputAccessoryView:toolbar];
    [experationDate setInputAccessoryView:toolbar];
    [cardState setInputAccessoryView:toolbar];
    
    [month_lbl setInputAccessoryView:toolbar];
    [cVV setInputAccessoryView:toolbar];
    [year_lbl setInputAccessoryView:toolbar];
    
    [cardAddress setInputAccessoryView:toolbar];
    [cardCity setInputAccessoryView:toolbar];
    [cardZipCode setInputAccessoryView:toolbar];
    
  //  [datePicker addSubview:toolbar];
    
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    
    [datePicker setHidden:YES];
    
    
    [master_card_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    [visa_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [Discover_card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [Amex_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];

    [scroll setBounces:YES];
    scroll.scrollEnabled=YES;
    scroll.showsVerticalScrollIndicator=YES;
    
    
    if ([cardDetails count]) {
        
        [done_Btn_full setHidden:YES];
        [done_btn_half setHidden:NO];
        [delete_card_btn setHidden:NO];
        
        nameOnCard.text=[cardDetails valueForKey:@"NameOnCard"];
        cardNumber.text=[cardDetails valueForKey:@"CardNumber"];
        month_lbl.text=[cardDetails valueForKey:@"MonthOfExpire"];
        year_lbl.text=[cardDetails valueForKey:@"YearOfExpire"];
        cVV.text=[cardDetails valueForKey:@"CVV"];
        
        
        cardAddress.text=[cardDetails valueForKey:@"address"];
        cardCity.text=[cardDetails valueForKey:@"city"];
        cardState.text =[cardDetails valueForKey:@"state"];
        selectedState =[cardDetails valueForKey:@"state"];
        cardZipCode.text=[cardDetails valueForKey:@"zipcode"];
        if ([[cardDetails valueForKey:@"cardType"] isEqualToString:@"Mastercard"]) {
            cardno=16;
            
            [master_card_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            [visa_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [Discover_card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [Amex_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];

        }else if ([[cardDetails valueForKey:@"cardType"] isEqualToString:@"Visa"]){
            cardno=16;

            [master_card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [visa_Card_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            [Discover_card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [Amex_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        }
        else if ([[cardDetails valueForKey:@"cardType"] isEqualToString:@"Amex"]){
            cardno=15;

            [master_card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [visa_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [Discover_card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [Amex_Card_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        }
        else if ([[cardDetails valueForKey:@"cardType"] isEqualToString:@"Discover"]){
            cardno=16;

            [master_card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [visa_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [Discover_card_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            [Amex_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        }

    }
    
    [self GetStatesList];
        
}

- (IBAction)getStatesPop:(id)sender;
{
    [self ShowStatesPicker];
}

- (IBAction)showDates:(id)sender {
    if ([sender tag]==10) {
        selectedMonth=@"01";
        selectedYear=NULL;
    }
    else{
       selectedYear=[yearsArray objectAtIndex:0];
        selectedMonth=NULL;
    }
    
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
        
        pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
        if ([sender tag]==10) {
            pickerview.tag=10;
        }
        else {
            pickerview.tag=20;
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
    }
    else {
        pickerview.tag=20;
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
- (void)viewDidLayoutSubviews
{
        [scroll setContentSize:CGSizeMake(0, 568)];
}

#pragma mark -
#pragma mark - UIPickerView Delegate
- (IBAction)valueChanged
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MMMM dd, yyyy";
    NSString *selectdate=  [df stringFromDate:datePicker.date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"]; // changed line in your code
    NSDate *date = [dateFormatter dateFromString:selectdate];
    NSString *dateText = [dateFormatter stringFromDate:date];
    experationDate.text=dateText;
    
}

-(void)previousButtonClicked:(id)sender
{
    id firstResponder = [self getFirstResponder];
    UITextField *fr=firstResponder;
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = fr.tag;
        NSUInteger previousTag = tag == 1 ? 1 : tag - 1;
        [self checkBarButton:previousTag];
        
        [self animateView:previousTag];
        UITextField *previousField = (UITextField *)[self.view viewWithTag:previousTag];
        if(previousField == experationDate)
        {
            [self.view endEditing:YES];

            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateFormat = @"MMMM dd, yyyy";
            NSString *selectdate=  [df stringFromDate:datePicker.date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMMM dd, yyyy"]; // changed line in your code
            NSDate *date = [dateFormatter dateFromString:selectdate];
            NSString *dateText = [dateFormatter stringFromDate:date];
            experationDate.text=dateText;
            
            [datePicker setHidden:NO];
            [self.view bringSubviewToFront:datePicker];
            
        }
        else{
            [datePicker setHidden:YES];
            [previousField becomeFirstResponder];
        }

    }
}
-(void)nextButtonClicked:(id)sender
{
    id firstResponder = [self getFirstResponder];
    
    UITextField *fr=firstResponder;
    
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = fr.tag;
        NSUInteger nextTag = tag == FIELDS_COUNT ? FIELDS_COUNT : tag + 1;
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        if(nextField == experationDate)
        {
            [self.view endEditing:YES];

            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateFormat = @"MMMM dd, yyyy";
            NSString *selectdate=  [df stringFromDate:datePicker.date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMMM dd, yyyy"]; // changed line in your code
            NSDate *date = [dateFormatter dateFromString:selectdate];
            NSString *dateText = [dateFormatter stringFromDate:date];
            experationDate.text=dateText;
            
            [datePicker setHidden:NO];
            [self.view bringSubviewToFront:datePicker];
            
        }
        else{
            
            [datePicker setHidden:YES];
            [nextField becomeFirstResponder];
        }
    }
}
- (id)getFirstResponder
{
    NSUInteger index = 0;
    while (index <= FIELDS_COUNT) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return NO;
}
- (void)checkBarButton:(NSUInteger)tag
{
    [barButtonPrev setEnabled:tag == 1 ? NO : YES];
    [barButtonNext setEnabled:tag == FIELDS_COUNT ? NO : YES];
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
            [scroll setContentOffset:CGPointMake(0, 65.0f * (2)) animated:YES];
        else if (tag ==1 || tag==2)
            [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
        else if (tag == 7 || tag == 8)
           [scroll setContentOffset:CGPointMake(0, 65.0f * (3)) animated:YES];
        else if (tag == 9)
            [scroll setContentOffset:CGPointMake(0, 65.0f * (4)) animated:YES];
        else
            [scroll setContentOffset:CGPointMake(0, 44.0f * 2) animated:YES];
    }
    else
    {
        if (tag > 8)
            [scroll setContentOffset:CGPointMake(0, 55.0f * (tag - 8)) animated:YES];
        else
            [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
-(void)doneButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark -
#pragma mark - UITextField Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     if (textField == cardNumber) {
        
        [cardNumber resignFirstResponder];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSUInteger tag = [textField tag];
    [self animateView:tag];
    [self checkBarButton:tag];
    
    if(textField == experationDate)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"MMMM dd, yyyy";
        NSString *selectdate=  [df stringFromDate:datePicker.date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy"]; // changed line in your code
        NSDate *date = [dateFormatter dateFromString:selectdate];
        NSString *dateText = [dateFormatter stringFromDate:date];
        experationDate.text=dateText;
        
        [datePicker setHidden:NO];
        [self.view bringSubviewToFront:datePicker];
        
    }
    else
        [datePicker setHidden:YES];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    NSCharacterSet *blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
    
    if (textField == nameOnCard ) {
        return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
    }
    
    if (textField.tag==2) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > cardno) ? NO : YES;

    }
    else if(textField.tag==5)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > cvv) ? NO : YES;

    }else if (textField.tag==3 || textField.tag==4)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 2) ? NO : YES;

    }
    else if (textField.tag==9)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > zipp) ? NO : YES;

    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==2) {
        NSUInteger newLength = [textField.text length];
        if (newLength<12) {
            [GlobalMethods showAlertwithString:@"please enter valid credit card number"];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.12
}
#pragma mark -
#pragma mark UIButton  Actions


- (IBAction)Edit_DoneClicked:(id)sender {
    
    [self deletecard];
    [self performSelector:@selector(doneBtnClicked:) withObject:nil afterDelay:0.3];
    
}

- (IBAction)Select_card_type:(id)sender {
    
    switch ([sender tag]) {
        case 10:
        {
            cardno=16;
            
            [master_card_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            [visa_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [Discover_card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [Amex_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            
            cvv =3;
        }
            break;
        case 11:
        {
            cardno=16;

            [master_card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [visa_Card_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            [Discover_card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [Amex_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];

            cvv =3;
        }
            break;
        case 12:
        {
            cardno=16;
            [master_card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [visa_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [Discover_card_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            [Amex_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];

            cvv =3;
        }
            break;
        case 13:
        {
            cardno=15;
            [master_card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [visa_Card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [Discover_card_btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [Amex_Card_btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            
            cvv =4;
        }
            break;

        default:
            break;
    }
    cardNumber.text=@"";
    
}

- (IBAction)dropDownBtnClicked:(id)sender {
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

- (IBAction)doneBtnClicked:(id)sender
{
    NSString *yearstr=[NSString stringWithFormat:@"%ld",(long)compo.year];
    yearstr =[yearstr substringFromIndex:2];
     if (![nameOnCard.text length] || [GlobalMethods checkWhiteSpace:nameOnCard.text] )
    {
        nameOnCard.text=nil;
        [GlobalMethods showAlertwithString:@"Please enter name on card"];
        return;
    }
    else if (![cardNumber.text length] || [GlobalMethods checkWhiteSpace:cardNumber.text])
    {
        cardNumber.text=nil;
        [GlobalMethods showAlertwithString:@"Please enter card number"];
        return;
    }
    else if (![cVV.text length]||[GlobalMethods checkWhiteSpace:cVV.text])
    {
        cVV.text=nil;
        [GlobalMethods showAlertwithString:@"Please enter cvv"];
                return;
    }
//    else if (![cardZipCode.text length]||[GlobalMethods checkWhiteSpace:cardZipCode.text])
//    {
//        cardZipCode.text=nil;
//        [GlobalMethods showAlertwithString:@"Please enter Zipcode"];
//                return;
//    }
   
    else if (![month_lbl.text length] || [GlobalMethods checkWhiteSpace:month_lbl.text])
    {
        [GlobalMethods showAlertwithString:@"Please enter month of card expiry"];
        return;
    }
    else  if ([month_lbl.text integerValue] > 12
              || ([month_lbl.text integerValue] <compo.month
                  && [year_lbl.text integerValue]==[yearstr integerValue]))
    {
        [GlobalMethods showAlertwithString:@"Please enter valid month of card expiry"];
        return;
    }
    else if (![year_lbl.text length]||[GlobalMethods checkWhiteSpace:year_lbl.text]){
        
        [GlobalMethods showAlertwithString:@"Please enter year of card expiry"];
        return;
    }

    else  if ([year_lbl.text integerValue] < [yearstr integerValue]) {
        [GlobalMethods showAlertwithString:@"Please enter valid year of card expiry"];
        return;
    }

//    else if (![cardAddress.text length]||[GlobalMethods checkWhiteSpace:cardAddress.text]){
//        cardAddress.text=nil;
//        [GlobalMethods showAlertwithString:@"Please enter address"];
//                return;
//    }else if (![selectedState length] || selectedState.length < 1)
//    {
//        [GlobalMethods showAlertwithString:@"Please enter State"];
//        return;
//    }
//    else if (![cardCity.text length]||[GlobalMethods checkWhiteSpace:cardCity.text]){
//        cardCity.text=nil;
//        [GlobalMethods showAlertwithString:@"Please enter city"];
//                return;
//    }
else if ([cardNumber.text length]<cardno){
        [GlobalMethods showAlertwithString:@"Please enter valid card number"];
                return;
    }
    else if ([[Amex_Card_btn currentImage] isEqual:[UIImage imageNamed:@"checked"]] && [cVV.text length]<4)
    {
        [GlobalMethods showAlertwithString:@"Please enter valid cvv"];
                return;
    }
    else if (![[Amex_Card_btn currentImage] isEqual:[UIImage imageNamed:@"checked"]] && [cVV.text length]<3)
    {
        [GlobalMethods showAlertwithString:@"Please enter valid cvv"];
        return;
    }
//    else if ([cardZipCode.text length]<5)
//    {
//        [GlobalMethods showAlertwithString:@"Please enter valid zipcode"];
//                return;
//    }
    
    NSMutableString *MonthString = [[NSMutableString alloc] init];
    
    if([month_lbl.text integerValue] < 10 && month_lbl.text.length == 1)
    {
        [MonthString appendString: @"0"];
        [MonthString appendString: month_lbl.text];
    }
    else
    {
        [MonthString appendString: month_lbl.text];
    }
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:nameOnCard.text forKey:@"NameOnCard"];
    [dict setObject:cardNumber.text forKey:@"CardNumber"];
    [dict setObject:[NSString stringWithFormat:@"20%@",year_lbl.text] forKey:@"YearOfExpire"];
    [dict setObject:MonthString forKey:@"MonthOfExpire"];
    [dict setObject:cVV.text forKey:@"CVV"];
    //[dict setObject:cardAddress.text forKey:@"address"];
    //[dict setObject:cardCity.text forKey:@"city"];
    //[dict setObject:selectedState forKey:@"state"];
 //   cardType(Visa, Mastercard, Amex, Discover)
    if ([[master_card_btn currentImage] isEqual:[UIImage imageNamed:@"checked"]])
    {
        [dict setObject:@"Mastercard" forKey:@"cardType"];

    }else if ([[visa_Card_btn currentImage] isEqual:[UIImage imageNamed:@"checked"]]){
        
        [dict setObject:@"Visa" forKey:@"cardType"];
    }
    else if ([[Amex_Card_btn currentImage] isEqual:[UIImage imageNamed:@"checked"]])
    {
        [dict setObject:@"Amex" forKey:@"cardType"];

    }
    else if ([[Discover_card_btn currentImage] isEqual:[UIImage imageNamed:@"checked"]]){
        [dict setObject:@"Discover" forKey:@"cardType"];
    }

    [dict setObject:cardZipCode.text forKey:@"zipcode"];
    NSString *displayName=[NSString stringWithFormat:@"xxxx%@",[cardNumber.text  substringFromIndex:12]];
    [dict setObject:displayName  forKey:@"display"];

    NSMutableArray *arrcard=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"ListOfCards"]];
    
    
    CurrenCardDetails = [[CardDetails alloc] init];
    CurrenCardDetails.card_type = [dict objectForKey:@"cardType"];
    CurrenCardDetails.card_name = [dict objectForKey:@"NameOnCard"];
    CurrenCardDetails.card_number = [dict objectForKey:@"CardNumber"];
    CurrenCardDetails.card_month = [dict objectForKey:@"MonthOfExpire"];
    CurrenCardDetails.card_year = [dict objectForKey:@"YearOfExpire"];
    CurrenCardDetails.card_cvv = [dict objectForKey:@"CVV"];
    //CurrenCardDetails.card_address = [dict objectForKey:@"address"];
    //CurrenCardDetails.card_city = [dict objectForKey:@"city"];
    //CurrenCardDetails.card_state = [dict objectForKey:@"state"];
    //CurrenCardDetails.card_zip = [dict objectForKey:@"zipcode"];
    CurrenCardDetails.card_display = [dict objectForKey:@"display"];

    [self addNewCardDetails: CurrenCardDetails];
}

- (IBAction)expiration_Clicked:(id)sender
{
    
    [self.view endEditing:YES];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MMMM dd, yyyy";
    NSString *selectdate=  [df stringFromDate:datePicker.date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"]; // changed line in your code
    NSDate *date = [dateFormatter dateFromString:selectdate];
    NSString *dateText = [dateFormatter stringFromDate:date];
    experationDate.text=dateText;
    
    [datePicker setHidden:NO];
    [self.view bringSubviewToFront:datePicker];
    
}

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
    
    if([appDel.objDBClass CheckIfCardsExists:CurrenCardDetails.card_number])
    {
        [GlobalMethods showAlertwithString:@"This card is already added to your list."];
        
        [self DismissStatePickerView];
        
        [hud hide:YES];
        [hud removeFromSuperview];
        hud=nil;
    }
    else
    {
        // [parser parseAndGetDataForPostMethod:params withUlr:@"addauthcard"];
        [self save:params];
    }
    
   
}

- (IBAction)save:(id)sender {
    NSDictionary *cardDeatails=sender;
    STPCard *card = [[STPCard alloc] init];
    card.number = [cardDeatails valueForKey:@"cardNumber"];
    card.expMonth = [[cardDeatails valueForKey:@"cardExpMonth"] integerValue];
    card.expYear = [[cardDeatails valueForKey:@"cardExpYear"] integerValue];
    card.cvc = [cardDeatails valueForKey:@"cardCVV"];
    NSMutableString *name=[NSMutableString stringWithFormat:@"%@",[cardDeatails valueForKey:@"firstName"]];
    card.name=name;
    //card.addressLine1=[cardDeatails valueForKey:@"address"];
    //card.addressCity=[cardDeatails valueForKey:@"city"];
    //card.addressState=[cardDeatails valueForKey:@"state"];
    //card.addressZip=[cardDeatails valueForKey:@"zipcode"];
    card.addressCountry=@"US";
    
    [[STPAPIClient sharedClient] createTokenWithCard:card
                                          completion:^(STPToken *token, NSError *error) {
                                              if (error) {
                                                  [self handleError:error];
                                              } else {
                                                  [self createBackendWithToken:token.tokenId andData:cardDeatails];
                                              }
                                          }];
}

-(void)createBackendWithToken:(id)token andData:(NSDictionary *)data {
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    
    [params setValue:[data valueForKey:@"accessToken"] forKey:@"accessToken"];
    [params setValue:token forKey:@"stripeToken"];
    [params setValue:[data valueForKey:@"firstName"] forKey:@"firstName"];
   // [params setValue:[data valueForKey:@"lastName"] forKey:@"lastName"];

    [parser parseAndGetDataForPostMethod:params withUlr:@"addStripeCard"];

}
-(void)handleError:(id)error{
    
    [GlobalMethods showAlertwithString:[error localizedDescription]];
    
    [hud hide:YES];
    [hud removeFromSuperview];
    hud=nil;
}
- (IBAction)backBtnClicked:(id)sender {
    appDel.backButtonClick=YES;
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
            //[self performSegueWithIdentifier:@"PaymentSegue" sender:self];
            [self.navigationController popViewControllerAnimated:YES];
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
        }
        else if (myIndexPath.row == 10) {
            [self goToSignInViewLogout];
        }        [self removeDropdown];
        
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

///////////////////////////////

-(void)deletecard
{
    NSArray*arrcard=[[NSUserDefaults standardUserDefaults]valueForKey:@"ListOfCards"];
    NSMutableArray *arcard=[[NSMutableArray alloc]init];
    [arcard addObjectsFromArray:arrcard];
    [arcard removeObject:cardDetails];
    NSDictionary *di=[[NSUserDefaults standardUserDefaults]valueForKey:@"PrimaryCard"];
    if ([di isEqualToDictionary:cardDetails]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary new] forKey:@"PrimaryCard"];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:arcard forKey:@"ListOfCards"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

-(void) ShowStatesPicker
{
    selectedState = @"AK";
    
    
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
    layerView.backgroundColor = [UIColor whiteColor];
    
    [layerView addSubview:pickerToolbar];
    
    pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
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
    NSLog(@"Selected State: %@", selectedState);
    if (selectedState!=NULL) {
        self.txtState.text=selectedState;
       // [btnStates setTitle:selectedState forState:UIControlStateNormal];

    }
    if (selectedMonth!=NULL) {
        month_lbl.text=selectedMonth;
  
    }
    if (selectedYear!=NULL) {
        year_lbl.text=[NSString stringWithFormat:@"%ld", [selectedYear integerValue] %100];
    }
    [self DismissStatePickerView];

    [self.view endEditing:YES];
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (NSArray *) GetStatesList
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"States" ofType:@"plist"];
    
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithContentsOfFile:path];
    NSDictionary *names = [dict objectForKey:@"StatesList"];

    NSArray *array = [[names allKeys] sortedArrayUsingSelector:
                      @selector(compare:)];
    keys = array;
    
    return  keys;
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
        selectedMonth=[NSString stringWithFormat:@"%@",  monthsArray[row]];
        month_lbl.text=[NSString stringWithFormat:@"%@",  monthsArray[row]];
    }
    else if (pickerview.tag == 20) {
        selectedYear=[NSString stringWithFormat:@"%ld", [yearsArray[row] integerValue] %100];
        year_lbl.text=[NSString stringWithFormat:@"%ld", [yearsArray[row] integerValue] %100];
    }
    else
    selectedState = [NSString stringWithFormat:@"%@",  keys[row]];
}

- (IBAction)Delete_btn_clicked:(id)sender {
    
    [self deletecard];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - ParseAndGetData Delegates

-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    [self DismissStatePickerView];
    
    [hud hide:YES];
    [hud removeFromSuperview];
    hud=nil;
    
    NSLog(@"Add New Card Result: %@", result);
    
    appDel.CurrentCustomerDetails = [appDel.objDBClass GetUserProfileDetails];
    NSLog(@"user_auth_id: %@", appDel.CurrentCustomerDetails.user_auth_id);
    
    NSString *Error = [NSString stringWithFormat:@"%@", [result valueForKey:@"error"]];
    NSString *ErrorText = [NSString stringWithFormat:@"%@", [result valueForKey:@"message"]];
    if(![Error isEqualToString:@"1"])
    {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSString *CustomerProfileID = [NSString stringWithFormat:@"%@", [result valueForKey:@"customerProfileId"]];
        if([result valueForKey:@"customerProfileId"] && CustomerProfileID.length > 1)
        {
            appDel.CurrentCustomerDetails.user_auth_id = CustomerProfileID;
            [appDel.objDBClass UpdateUserProfileDetails: appDel.CurrentCustomerDetails];
            NSLog(@"user_auth_id: %@", appDel.CurrentCustomerDetails.user_auth_id);
        }
        
        [appDel.objDBClass InsertCardDetails:CurrenCardDetails];
        
        
        [GlobalMethods showAlertwithString:@"Card successfully added to list."];
        appDel.backButtonClick=NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [GlobalMethods showAlertwithString: ErrorText];
        
        
    }
//    if([appDel.objDBClass CheckIfCardsExists: CurrenCardDetails.card_number])
//    {
//        [GlobalMethods showAlertwithString:@"This card is already added to your list."];
//    }
//    else
//    {
//        [appDel.objDBClass InsertCardDetails:CurrenCardDetails];        
//
////        [[NSUserDefaults standardUserDefaults ]setObject:dict forKey:@"PrimaryCard"];
////        [arrcard addObject:dict];
////        [[NSUserDefaults standardUserDefaults] setObject:arrcard forKey:@"ListOfCards"];
////        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
    
   
    

}

-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    [hud hide:YES];
    [GlobalMethods showAlertwithString:err];
}


@end