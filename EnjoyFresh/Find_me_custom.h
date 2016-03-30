//
//  Find_me_custom.h
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 16/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Find_me_custom : UITableViewCell
{
    IBOutlet UILabel *restaurant_name;
    
    IBOutlet UILabel *Restaraunt_desc;
    IBOutlet UILabel *Chef_restaurant;
    
    IBOutlet UIButton *Star5;
    IBOutlet UIButton *Star3;
    IBOutlet UIButton *Star4;
    IBOutlet UIButton *Star2;
    IBOutlet UIButton *Star1;
    
}


@property (nonatomic,retain)    IBOutlet UILabel *restaurant_name;

@property (nonatomic,retain)    IBOutlet UILabel *Restaraunt_desc;

@property (nonatomic,retain)    IBOutlet UILabel *Chef_restaurant;

@property (nonatomic,retain)    IBOutlet UIButton *Star5;

@property (nonatomic,retain)    IBOutlet UIButton *Star3;

@property (nonatomic,retain)    IBOutlet UIButton *Star4;

@property (nonatomic,retain)    IBOutlet UIButton *Star2;

@property (nonatomic,retain)    IBOutlet UIButton *Star1;

@end
