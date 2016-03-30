//
//  TableViewNotificationCell.h
//  EnjoyFresh
//
//  Created by Siva  on 14/12/15.
//  Copyright (c) 2015 RSG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewNotificationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgNotification;
@property (strong, nonatomic) IBOutlet UILabel *lblText;
@end
