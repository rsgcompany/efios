//
//  RPPTableViewCell.h
//  EnjoyFresh
//
//  Created by Siva  on 19/06/15.
//  Copyright (c) 2015 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface RPPTableViewCell : UITableViewCell{
    CLLocationCoordinate2D location;
    MKMapView *locatinMap;
}
@property (assign) CLLocationCoordinate2D location;

@property (strong, nonatomic) IBOutlet UIImageView *restaurantImg;
@property (strong, nonatomic) IBOutlet UITextView *restuaranrDes;
@property (strong, nonatomic) IBOutlet MKMapView *locatinMap;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIPageControl *pageCtrl;
@property (strong, nonatomic) IBOutlet UIButton *socialShare;
@property (strong, nonatomic) IBOutlet UILabel *restName;
@property (strong, nonatomic) IBOutlet UILabel *lblRating;
@property (strong, nonatomic) IBOutlet UIButton *btnFav;
@property (strong, nonatomic) IBOutlet UIButton *btnRightArr;
@property (strong, nonatomic) IBOutlet UIButton *btnLeftArr;
@property (strong, nonatomic) IBOutlet UILabel *lblRatingFade;

@end
