//
//  HowItWorksViewController.h
//  EnjoyFresh
//
//  Created by Siva  on 02/10/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDown.h"
#import <MessageUI/MessageUI.h>

@interface HowItWorksViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIScrollViewDelegate,DropDownDelegate>{
    NSArray *imgsArr;
    int _contentWidth;
    DropDown *drp;
    IBOutlet UIButton *dropDownBtn;
    UIView *imgView;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIPageControl *pageCtrl;
- (IBAction)backAction:(id)sender;
-(IBAction)dropDownBtnClicked:(id)sender;
@end
