//
//  ShareViewController.h
//  EnjoyFresh
//
//  Created by S Murali Krishna on 29/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DropDown.h"
@interface ShareViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,DropDownDelegate>
{
    IBOutlet UILabel *Share,*Tweet_Lbl,*Text_Lbl,*Email_lbl,*offterLbl,*titlelbl,*helpUsLbl;
    IBOutlet UIButton *dropDownBtn;

    DropDown *drp;
    UIView *imgView;
    IBOutlet UITextField *shareURLTextField;
    IBOutlet UIScrollView *scrollview;
}
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
-(IBAction)shareBtnsClicked:(id)sender;
-(IBAction)dropDownBtnClicked:(id)sender;
-(IBAction)backBtnClicked:(id)sender;
@end
