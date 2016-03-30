//
//  FAQViewController.h
//  EnjoyFresh
//
//  Created by Siva  on 05/10/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDown.h"
#import <MessageUI/MessageUI.h>

@interface FAQViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSMutableIndexSet *expandedSections;
    NSArray *questionsArray;
    NSArray *answersArray;
    DropDown *drp;
    IBOutlet UIButton *dropDownBtn;
    UIView *imgView;
}
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITableView *FAQTable;
- (IBAction)BackAction:(id)sender;
-(IBAction)dropDownBtnClicked:(id)sender;
@end
