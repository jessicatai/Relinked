//
//  LinkedInFetcher.m
//  Relinked
//
//  Created by Jessica Tai on 12/3/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "LinkedInFetcher.h"

@implementation LinkedInFetcher

+(NSString *) urlEncodeString:(NSString *) unencodedUrl {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)unencodedUrl,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8 ));
}

+ (NSString *) parseIDFromProfileURL:(NSString *)url {
    if (url) {
        // example profile url: "http://www.linkedin.com/profile/view?id=36982350&authType=name&authToken=d_du&trk=api*a3491661*s3564391*"
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"id=([^&]+)" options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *matches = [regex matchesInString:url options:0 range:NSMakeRange(0, url.length)];
        
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        NSRange range = [match rangeAtIndex:1];
        
        return[url substringWithRange:range];
    }
    return nil;
    
}

@end
