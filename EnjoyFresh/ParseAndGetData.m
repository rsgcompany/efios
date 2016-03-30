//
//  ParseAndGetData.m
//  EnjoyFresh
//
//  Created by S Murali Krishna on 04/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "ParseAndGetData.h"
#import "AFNetworking.h"
#import "Global.h"
#import "Reachability.h"
#import "AFHTTPClient.h"
#import "JSON.h"

@implementation ParseAndGetData
@synthesize delegate;
-(void)parseAndGetDataForGetMethod:(NSString*)gerUrlStr
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        //my web-dependent code
        NSString *urlstr=[NSString stringWithFormat:@"%@%@",BaseURL,gerUrlStr];
        NSURL *url=[NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        NSLog(@"parseAndGetDataForGetMethod %@", gerUrlStr);
        NSURLRequest *request=nil;
        request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                            NSDictionary *dict  = (NSDictionary *)JSON;
                                                            [delegate dataDidFinishLoadingwithResult:dict];
                                                        }
                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                            [delegate dataDidFailedLoadingWithError:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                                                        }];
        [operation start];
    }
    else {
        [delegate dataDidFailedLoadingWithError:@"Please check your Network Connection."];
    }
}
-(void)parseAndGetDataForPostMethod:(NSDictionary*)paramters withUlr:(NSString*)ulris
{
    NSURL *url = [NSURL URLWithString:BaseURL];
    
    NSLog(@"parseAndGetDataForPostMethod %@", ulris);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient postPath:ulris parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dict=[responseStr JSONValue];
        [delegate dataDidFinishLoadingwithResult:dict];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate dataDidFailedLoadingWithError:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
        
    }];
}
@end

