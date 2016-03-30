//
//  ReviewViewController.h
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 08/09/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *review_Table;
    IBOutlet UILabel *hearder_lbl;
}
@property(nonatomic,retain)NSArray *review;

- (IBAction)Back_btn:(id)sender;

@end
