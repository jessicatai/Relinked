//
//  LinkedInFetcher.h
//  Relinked
//
//  Created by Jessica Tai on 12/3/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LINKEDIN_FIRST_NAME @"firstName"
#define LINKEDIN_LAST_NAME @"lastName"
#define LINKEDIN_HEADLINE @"headline"
#define LINKEDIN_USERID @"id"
#define LINKEDIN_INDUSTRY @"industry"
#define LINKEDIN_THUMBNAIL @"pictureUrl"
#define LINKEDIN_PROFILE_URL @"siteStandardProfileRequest.url"
#define LINKEDIN_CONNECTION_PROFILE_URL @"url"

#define LINKEDIN_CLIENT_ID @"75jzu4u0swu7pf"
#define LINKEDIN_CLIENT_SECRET @"b99lTlSFAWd8SbaN"


@interface LinkedInFetcher : NSObject
+(NSString *) urlEncodeString:(NSString *) unencodedUrl;
+ (NSString *) parseIDFromProfileURL:(NSString *)url;
@end
