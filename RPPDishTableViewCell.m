//
//  RPPDishTableViewCell.m
//  EnjoyFresh
//
//  Created by Siva  on 19/06/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import "RPPDishTableViewCell.h"
#import "Global.h"

@implementation RPPDishTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.resImage.layer.cornerRadius=25.0f;
   // self.resImage.layer.borderWidth=1.0f;
    self.resImage.layer.masksToBounds=YES;
    
  //  self.resImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.priceLabel.font=[UIFont fontWithName:SemiBold size:16.0f];

    self.dishName.font=[UIFont fontWithName:Bold size:14.0f];
    self.rateCount.font=[UIFont fontWithName:Regular size:13.0f];
    self.lblDate.font=[UIFont fontWithName:SemiBold size:12.0f];
    self.chefName.font=[UIFont fontWithName:Bold size:14.0f];
    self.orderDish.titleLabel.font=[UIFont fontWithName:SemiBold size:9.0f];
    
    self.btnSoldout.titleLabel.font=[UIFont fontWithName:SemiBold size:10.0f];
    self.btnSoldout.layer.borderWidth=1.0f;
    self.btnSoldout.layer.cornerRadius=12.0f;
    self.btnDropDown.layer.cornerRadius=2.0f;

    
    self.btnSoldout.layer.borderColor=[UIColor colorWithRed:(211/255.0) green:(118/255.0) blue:(100/255.0) alpha:1].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
