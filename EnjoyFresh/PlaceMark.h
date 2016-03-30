//
//  PlaceMark.h
//  YogMap1
//
//  Created by Yogendra Rawat on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Place.h"

@interface PlaceMark : NSObject <MKAnnotation> {
	
	CLLocationCoordinate2D coordinate;
	Place* place;
    MKPinAnnotationColor pinColor;

}
@property (nonatomic, assign)MKPinAnnotationColor pinColor;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) Place* place;

-(id) initWithPlace: (Place*) p;

@end