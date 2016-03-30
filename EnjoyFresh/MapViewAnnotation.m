//
//  MapViewAnnotation.m
//  EnjoyFresh
//
//  Created by Tesla on 01/10/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//



#import "MapViewAnnotation.h"
#import "Global.h"
@implementation MapViewAnnotation

@synthesize coordinate=_coordinate;
@synthesize title=_title;
@synthesize annotationButton;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    _title = title;
    _coordinate = coordinate;
    return self;
}

- (MKAnnotationView *) annotatioView;
{
    MKAnnotationView *annotationView  = [[MKAnnotationView alloc] initWithAnnotation:self
                                                                     reuseIdentifier:@"MapViewAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"LocationIcon"];
    
    //annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    annotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    annotationButton.frame = CGRectMake(10,10,50,50);
    [annotationButton setBackgroundColor:[UIColor colorWithRed:(99/255.0) green:(158/255.0) blue:(93/255.0) alpha:1]];
    [annotationButton.titleLabel setFont:[UIFont fontWithName:Regular size:13.0f]];
    [annotationButton.titleLabel setTextColor:[UIColor whiteColor]];
    annotationButton.tag = 1;
    //[annotationButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
   
    annotationView.rightCalloutAccessoryView = annotationButton;
    
    return annotationView;
}

- (void) SetDistanceAndAddress : (MKAnnotationView *) currentView : (NSString *) strAddress : (NSString *) strDistance
{
    NSMutableString *strDistanceText = [[NSMutableString alloc] init];
    [strDistanceText appendString:strDistance];
    [strDistanceText appendString:@" m"];
    [annotationButton setTitle:strDistanceText forState:UIControlStateNormal];
    
    annotationButton.accessibilityHint = strAddress;
}

-(IBAction)buttonTouched:(id)sender
{
    
}

@end
