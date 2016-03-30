//
//  RPPDishTableViewCell.h
//  EnjoyFresh
//
//  Created by Siva  on 19/06/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPPDishTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dishName;
@property (strong, nonatomic) IBOutlet UILabel *chefName;
@property (strong, nonatomic) IBOutlet UIImageView *dishImage;
@property (strong, nonatomic) IBOutlet UIImageView *resImage;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *orderDish;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *rateCount;
@property (strong, nonatomic) IBOutlet UIButton *btnSoldout;
@property (strong, nonatomic) IBOutlet UILabel *lblCityState;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) IBOutlet UIButton *dishDetail;
@property (strong, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) IBOutlet UIView *backGroundView;
@property (strong, nonatomic) IBOutlet UIButton *share2;
@property (strong, nonatomic) IBOutlet UIImageView *drpImage;
@property (strong, nonatomic) IBOutlet UIButton *btnDropDown;

@property (strong, nonatomic) IBOutlet UIView *soldOutView;
@property (strong, nonatomic) IBOutlet UILabel *lblRating;
@property (strong, nonatomic) IBOutlet UILabel *lblStar;
@end
