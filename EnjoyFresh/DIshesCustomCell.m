//
//  DIshesCustomCell.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 12/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "DIshesCustomCell.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>


@implementation DIshesCustomCell
@synthesize dishsImg,ingred1Img,ingred2Img,ingred3Img,ingred4Img,restaurantImg
,dishNmeLbl,restaurantLbl,priceLbl,addOrderBtn,despLbl,ordeByLbl,availBylbl;


- (void)awakeFromNib
{
    // Initialization code
    
    restaurantImg.layer.cornerRadius=25.0f;
    //restaurantImg.layer.borderWidth=1.0f;
    restaurantImg.layer.masksToBounds=YES;
    
   // restaurantImg.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    ingred1Img.layer.cornerRadius=5.0f;
    ingred2Img.layer.cornerRadius=5.0f;
    ingred3Img.layer.cornerRadius=5.0f;
    ingred4Img.layer.cornerRadius=5.0f;
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTapped:)];
    singleTap1.numberOfTapsRequired = 1;
    singleTap1.numberOfTouchesRequired = 1;
    [ingred1Img addGestureRecognizer:singleTap1];
    [ingred1Img setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTapped:)];
    singleTap2.numberOfTapsRequired = 1;
    singleTap2.numberOfTouchesRequired = 1;
    [ingred2Img addGestureRecognizer:singleTap2];
    [ingred2Img setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTapped:)];
    singleTap3.numberOfTapsRequired = 1;
    singleTap3.numberOfTouchesRequired = 1;
    [ingred3Img addGestureRecognizer:singleTap3];
    [ingred3Img setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTapped:)];
    singleTap4.numberOfTapsRequired = 1;
    singleTap4.numberOfTouchesRequired = 1;
    [ingred4Img addGestureRecognizer:singleTap4];
    [ingred4Img setUserInteractionEnabled:YES];

    self.rateCount.font=[UIFont fontWithName:Regular size:13.0f];
    self.dishNmeLbl.font=[UIFont fontWithName:Bold size:14.0f];
    self.lblDate.font=[UIFont fontWithName:SemiBold size:11.0f];
    
    self.despLbl.font=[UIFont fontWithName:Regular size:13.0f];
    self.restaurantLbl.font=[UIFont fontWithName:Bold size:13.0f];
    self.lblStateCity.font=[UIFont fontWithName:Regular size:11.0f];
    
    self.priceLbl.font=[UIFont fontWithName:SemiBold size:18.0f];
    
    self.ordeByLbl.font=[UIFont fontWithName:Medium size:12.0f];
    self.availBylbl.font=[UIFont fontWithName:Bold size:12.0];
    
    self.btnSoldout.titleLabel.font=[UIFont fontWithName:SemiBold size:10.0f];
    self.btnSoldout.layer.borderWidth=1.0f;
    self.btnSoldout.layer.cornerRadius=12.0f;
    self.btnDropDown.layer.cornerRadius=2.0f;


    self.btnSoldout.layer.borderColor=[UIColor colorWithRed:(211/255.0) green:(118/255.0) blue:(100/255.0) alpha:1].CGColor;

}

- (void)bannerTapped:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%@", [gestureRecognizer view].accessibilityHint);
    
    if([gestureRecognizer view].accessibilityHint.length > 1)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@" Dietary Option"
                                                     message:[gestureRecognizer view].accessibilityHint delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
