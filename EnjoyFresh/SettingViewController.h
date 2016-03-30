//
//  SettingViewController.h
//  EnjoyFresh
//
//  Created by S Murali Krishna on 10/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DropDown.h"

@interface SettingViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,DropDownDelegate>
{
    IBOutlet UIButton *dropDownBtn;
    IBOutlet UILabel *ProFile_Lbl;
    IBOutlet UILabel *Order_history_lbl;
    IBOutlet UILabel *Payment_lbl;
    IBOutlet UILabel *Notification_lbl;
    IBOutlet UILabel *Favourite_Lbl;
    IBOutlet UILabel *Contact_lbl;
    IBOutlet UILabel *Find_me_Lbl;
    IBOutlet UILabel *Share;
    IBOutlet UILabel *Tweet_Lbl;
    IBOutlet UILabel *Text_Lbl;
    IBOutlet UILabel *Email_lbl;
    IBOutlet UILabel *Header_Lbl,*spreadLbl;
    
    
    DropDown *drp;

}
-(IBAction)backBtnClicked:(id)sender;
-(IBAction)dropDownBtnClicked:(id)sender;
-(IBAction)profileBtnClicked:(id)sender;
-(IBAction)orderHisotyrBtnClicked:(id)sender;
-(IBAction)paymentBtnClicked:(id)sender;
-(IBAction)notificationsBtnClicked:(id)sender;
-(IBAction)favsBtnClicked:(id)sender;
-(IBAction)contactsUsBtnClicked:(id)sender;
-(IBAction)findMeBtnClicked:(id)sender;
-(IBAction)facebookBtnClicked:(id)sender;
-(IBAction)twitterBtnClicked:(id)sender;
-(IBAction)smsBtnClicked:(id)sender;
-(IBAction)mailBtnClicked:(id)sender;

@end
