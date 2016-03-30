//
//  NotifyMeView.m
//  EnjoyFresh
//
//  Created by Siva  on 12/11/15.
//  Copyright (c) 2015 RSG. All rights reserved.
//

#import "NotifyMeView.h"
#import "Global.h"
#import "ParseAndGetData.h"

@interface NotifyMeView ()

@end

@implementation NotifyMeView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lblHead.font=[UIFont fontWithName:Regular size:14];
    self.lblText.font=[UIFont fontWithName:Regular size:13];
    self.btnNotify.titleLabel.font=[UIFont fontWithName:Bold size:13];
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
   NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    dict=[[NSUserDefaults standardUserDefaults ] valueForKey:@"UserProfile"];
    if ([appDel.accessToken length]) {
        self.txtEmail.text=[dict valueForKey:@"email"];
        self.txtName.text=[NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"first_name"],[dict valueForKey:@"last_name"]];
    }

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

- (IBAction)notifyMe:(id)sender {
    parser=[[ParseAndGetData alloc]init];
    parser.delegate=self;
    
    if ([self.txtName.text length]) {
        if ([self.txtEmail.text length]) {
            
            if ([GlobalMethods isItValidEmail:self.txtEmail.text]) {
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.dishID,@"dishId",self.txtName.text, @"userName",self.txtEmail.text, @"userEmail",nil];
                
                [parser parseAndGetDataForPostMethod:params withUlr:@"notifyMe"];
                
            }
            else{
                [GlobalMethods showAlertwithString:@"Please enter valid Email"];
                
            }
        }
        else{
            [GlobalMethods showAlertwithString:@"Please enter Email"];
            
        }
    }
    else{
        [GlobalMethods showAlertwithString:@"Please enter name"];
    }
    
}

#pragma mark
#pragma mark - parse Delegtes
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    if ([[result valueForKey:@"error"] integerValue]!=0) {
        [GlobalMethods showAlertwithString:@"please try again"];
    }
    else{
        [self.view removeFromSuperview];

        [GlobalMethods showAlertwithString:@"Thank you ! We'll let you know as soon as this item is back on the menu !"];
    }
}

-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    
}

#pragma mark
#pragma mark - TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
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
- (IBAction)removeNotificstion:(id)sender {
    [self.view removeFromSuperview];
}
@end
