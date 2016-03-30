//
//  PaymentCell.m
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 16/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "PaymentCell.h"

@implementation PaymentCell
@synthesize selection_Btn,card_img,Name_lbl,backGrnImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        Name_lbl.font=[UIFont fontWithName:Regular size:14];
        [selection_Btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
