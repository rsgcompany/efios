//
//  EFHTTPSessionManager.m
//  EnjoyFresh
//
//  Created by kalyan chakravarthy on 16/05/16.
//  Copyright © 2016 RSG. All rights reserved.
//

#import "EFHTTPSessionManager.h"

@implementation EFHTTPSessionManager
#pragma mark FTSBHTTPSessionManager Public API

+ (EFHTTPSessionManager *) getHttpSessionMgr {
    static EFHTTPSessionManager *HttpSessionMgr = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        HttpSessionMgr = [self alloc];
    });
    
    return HttpSessionMgr;
}



@end
