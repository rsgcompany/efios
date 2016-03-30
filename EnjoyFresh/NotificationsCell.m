//
//  NotificationsCell.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 10/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "NotificationsCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
@implementation NotificationsCell
@synthesize roundImg,titleLbl,dateLbl,detailLbl,location, favBtn;
- (void)awakeFromNib
{
    // Initialization code
    roundImg.layer.cornerRadius=40.0f;
//    roundImg.layer.borderWidth=1.0f;
//    roundImg.layer.borderColor=[UIColor lightGrayColor].CGColor;
    roundImg.layer.masksToBounds=YES;
    
    [titleLbl setFont:[UIFont fontWithName:Bold size:14.0f]];
    [detailLbl setFont:[UIFont fontWithName:Regular size:12.0f]];
    [location setFont:[UIFont fontWithName:Regular size:10.0f]];
    [dateLbl setFont:[UIFont fontWithName:Regular size:12.0f]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
