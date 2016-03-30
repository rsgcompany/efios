//
//  NotifyMeView.h
//  EnjoyFresh
//
//  Created by Siva  on 12/11/15.
//  Copyright (c) 2015 RSG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseAndGetData.h"

@interface NotifyMeView : UIViewController{
    ParseAndGetData *parser;
}
@property (strong, nonatomic) IBOutlet UILabel *lblHead;
@property (strong, nonatomic) IBOutlet UILabel *lblText;

@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnNotify;
- (IBAction)removeNotificstion:(id)sender;
@property (strong, nonatomic) NSString *dishID;
- (IBAction)notifyMe:(id)sender;
@end
