//
//  DropTableViewCell.m
//  EnjoyFresh
//
//  Created by Siva  on 13/10/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import "DropTableViewCell.h"

@implementation DropTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,20,20);
}

@end
