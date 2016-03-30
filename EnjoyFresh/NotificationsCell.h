//
//  NotificationsCell.h
//  ejoyfresh kakn  qdad
//sfsdfsdfsdfsasdasdas 
//  Created by S Murali Krishna on 10/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UIImageView *roundImg;

@property(nonatomic,retain)IBOutlet UILabel *titleLbl,*detailLbl,*dateLbl,*location;
@property (strong, nonatomic) IBOutlet UIButton *favBtn;
@property (strong, nonatomic) IBOutlet UILabel *arrows;
@property (strong, nonatomic) IBOutlet UILabel *lblLoc;
@property (strong, nonatomic) IBOutlet UIButton *rppBtn;

@end
