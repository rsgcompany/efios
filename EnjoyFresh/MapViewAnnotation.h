//
//  MapViewAnnotation.h
//  EnjoyFresh
//
//  Created by Tesla on 01/10/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic,copy) NSString *title;
@property (nonatomic, retain) UIButton *annotationButton;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate;
- (MKAnnotationView *) annotatioView;

- (void) SetDistanceAndAddress : (MKAnnotationView *) currentView : (NSString *) strAddress : (NSString *) strDistance;

@end
