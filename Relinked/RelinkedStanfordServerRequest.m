//
//  RelinkedStanfordServerRequest.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "RelinkedStanfordServerRequest.h"

@implementation RelinkedStanfordServerRequest

+ (NSData *) executeQuickNDirtyQuery:(NSString *) url{
    NSLog(@"executing url %@ OFF main queue", url);
    
        
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    return response1;
}

+ (NSDictionary *) jsonResponseForURL:(NSString *)url {
    NSData *jsonData = [RelinkedStanfordServerRequest executeQuickNDirtyQuery:url];
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];

    NSLog(@"%@", jsonDict);
    return jsonDict;
}

+ (NSDate *) convertStringToDate:(NSString *) dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *) convertDateToString:(NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

@end
