//
//  EFHTTPSessionManager.h
//  EnjoyFresh
//
//  Created by kalyan chakravarthy on 16/05/16.
//  Copyright © 2016 RSG. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface EFHTTPSessionManager : AFHTTPSessionManager
+ (EFHTTPSessionManager *) getHttpSessionMgr;

@end
