//
//  Find_me_custom.m
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 16/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "Find_me_custom.h"
#import "Global.h"
@implementation Find_me_custom
@synthesize Restaraunt_desc,restaurant_name,Chef_restaurant,Star1,Star2,Star3,Star4,Star5;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        [[UILabel appearance ]setFont:[UIFont fontWithName:Regular size:14]];
        
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
