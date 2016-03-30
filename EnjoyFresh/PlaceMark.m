//
//  PlaceMark.m
//  YogMap1
//
//  Created by Yogendra Rawat on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceMark.h"


@implementation PlaceMark

@synthesize coordinate;
@synthesize place;
@synthesize pinColor;

-(id) initWithPlace: (Place*) p
{
	self = [super init];
	if (self != nil) {
		coordinate.latitude = p.latitude;
		coordinate.longitude = p.longitude;
		self.place = p;
        pinColor = MKPinAnnotationColorGreen;
	}
	return self;
}

- (NSString *)subtitle
{
	return self.place.description;
}
- (NSString *)title
{
	return self.place.name;
}



@end
