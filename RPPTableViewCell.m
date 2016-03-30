//
//  RPPTableViewCell.m
//  EnjoyFresh
//
//  Created by Siva  on 19/06/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import "RPPTableViewCell.h"
#import "Global.h"

@implementation RPPTableViewCell
@synthesize locatinMap,location;

- (void)awakeFromNib {
    // Initialization code
    self.restuaranrDes.font=[UIFont fontWithName:Regular size:14];
    self.restName.font=[UIFont fontWithName:Bold size:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
