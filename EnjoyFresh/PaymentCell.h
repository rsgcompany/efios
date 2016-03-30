//
//  PaymentCell.h
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 16/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
@interface PaymentCell : UITableViewCell
{
    
}
@property (retain, nonatomic) IBOutlet UILabel *Name_lbl;
@property (strong, nonatomic) IBOutlet UIButton *selection_Btn;

@property (strong, nonatomic) IBOutlet UIImageView *card_img,*backGrnImg;
@end
