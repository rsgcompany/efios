//
//  PrivacyPolicyViewController.h
//  EnjoyFresh
//
//  Created by Siva  on 02/10/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDown.h"
#import <MessageUI/MessageUI.h>
#import "Global.h"

@interface PrivacyPolicyViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,DropDownDelegate>{
    DropDown *drp;
    IBOutlet UIButton *dropDownBtn;
    UIView *imgView;
}
- (IBAction)backAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITextView *textView;
-(IBAction)dropDownBtnClicked:(id)sender;
@end
