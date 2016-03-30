//
//  DropDown.h
//  EnjoyFresh
//
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DBClass.h"
//#define x = 23;
@protocol DropDownDelegate <NSObject>
-(void)removeDropdown;
-(void)didSelectRowInDropdownTableString:(NSString *)myString atIndexPath:(NSIndexPath *)myIndexPath;
@end

@interface DropDown : UITableViewController<UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
{
    NSArray *dropDownArr;
    NSArray *selectedArr;
    int indexpth;
    UIView *blurView;
}
-(CGRect)dropDownViewFrame;
@property(strong,nonatomic)id <DropDownDelegate> delegate;

@end
