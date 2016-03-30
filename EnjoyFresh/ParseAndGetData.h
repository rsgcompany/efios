//
//  ParseAndGetData.h
//  EnjoyFresh
//
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol parseAndGetDataDelegate<NSObject>
-(void)dataDidFinishLoadingwithResult:(NSDictionary*)result;
-(void)dataDidFailedLoadingWithError:(NSString*)err;
@end
@interface ParseAndGetData : NSObject
@property(nonatomic,strong)id <parseAndGetDataDelegate> delegate;

-(void)parseAndGetDataForGetMethod:(NSString*)gerUrlStr;

-(void)parseAndGetDataForPostMethod:(NSDictionary*)paramters withUlr:(NSString*)ulris;
@end
