//
//  OrderConfirmationView.h
//  EnjoyFresh
//
//  Created by Siva  on 18/08/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "GlobalMethods.h"


@interface OrderConfirmationView : UIViewController<UIApplicationDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>{
    NSDictionary *orderDetails;
    NSDictionary *disDetails;
    NSString *shareUrl;
}
@property (strong, nonatomic) IBOutlet UILabel *lblDelTime;

@property (nonatomic,strong) NSDictionary *orderDetails,*disDetails;
@property (strong, nonatomic) IBOutlet UILabel *lblOrederText;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblSubHead;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderText;
@property (strong, nonatomic) IBOutlet UILabel *lblPriceText;
@property (strong, nonatomic) IBOutlet UILabel *lblMailText;
@property (strong, nonatomic) IBOutlet UILabel *lblInvite;

@property (strong, nonatomic) IBOutlet UILabel *lblOrderNo;
@property (strong, nonatomic) IBOutlet UIImageView *dishImage;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UIButton *okayBtn;
@property (strong, nonatomic) IBOutlet UILabel *offerLbl;
- (IBAction)orderComplete:(id)sender;

-(IBAction)shareBtnsClicked:(id)sender;

- (IBAction)sendEmail:(id)sender;
- (IBAction)shareOnFB:(id)sender;
- (IBAction)shareOnTwitter:(id)sender;
@end
