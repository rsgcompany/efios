//
//  DIshesCustomCell.h
//  EnjoyFresh
//
//  Created by S Murali Krishna on 12/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIshesCustomCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UIImageView *dishsImg,*ingred1Img,*ingred2Img,*ingred3Img,*ingred4Img,*restaurantImg;
@property(nonatomic,retain)IBOutlet UILabel *dishNmeLbl,*restaurantLbl,*priceLbl,*despLbl,*ordeByLbl,*availBylbl;
@property(nonatomic,retain)IBOutlet UIButton *addOrderBtn;
@property (strong, nonatomic) IBOutlet UILabel *dishRating;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblStateCity;
@property (strong, nonatomic) IBOutlet UIButton *btnRPP;
@property (strong, nonatomic) IBOutlet UILabel *lblDishRating1;
@property (strong, nonatomic) IBOutlet UIButton *btnRate;

@property (strong, nonatomic) IBOutlet UIButton *segueButton;
@property (strong, nonatomic) IBOutlet UIButton *btnLike;
@property (strong, nonatomic) IBOutlet UIButton *segueButton2;
@property (strong, nonatomic) IBOutlet UILabel *rateCount;
@property (strong, nonatomic) IBOutlet UIView *favView;
@property (strong, nonatomic) IBOutlet UIView *backGroundView;
@property (strong, nonatomic) IBOutlet UIButton *share2;
@property (strong, nonatomic) IBOutlet UIButton *btnDropDown;
@property (strong, nonatomic) IBOutlet UIImageView *drpImage;

@property (strong, nonatomic) IBOutlet UIView *starsView;
@property (strong, nonatomic) IBOutlet UIButton *btnSoldout;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@end
