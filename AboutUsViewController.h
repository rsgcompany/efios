//
//  AboutUsViewController.h
//  EnjoyFresh
//
//  Created by Siva  on 02/10/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDown.h"
#import <MessageUI/MessageUI.h>
#import "Global.h"

@interface AboutUsViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,DropDownDelegate>{
    DropDown *drp;
    IBOutlet UIButton *dropDownBtn;
    UIView *imgView;
}
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *btnTerms;
@property (strong, nonatomic) IBOutlet UIButton *btnPrivacy;
- (IBAction)backAction:(id)sender;
-(IBAction)dropDownBtnClicked:(id)sender;
@end
