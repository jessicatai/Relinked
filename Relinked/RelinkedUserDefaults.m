//
//  RelinkedUserDefaults.m
//  Relinked
//
//  Created by Jessica Tai on 12/4/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "RelinkedUserDefaults.h"
#import "User+LinkedIn.h"
#import "Request+Relinked.h"

@implementation RelinkedUserDefaults

#define RELINKED_USER_INFO @"relinkedUserInfo"
#define RELINKED_ACCESS_TOKEN @"relinkedAccessToken"

+ (void) loginCurrentUser:(NSDictionary *) userInfo {
    if (userInfo) {
        NSLog(@"adding user to NSDefaults");
        // overwrite any existing (should not be) value
        // only one user can be currently logged in at a time per phone
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:RELINKED_USER_INFO];
    }
    
}

+ (BOOL) isUserLoggedIn {
    return [[NSUserDefaults standardUserDefaults] objectForKey:RELINKED_USER_INFO] != nil;
}

+ (void) logoutCurrentUser {
    if ([self isUserLoggedIn]) {
        NSLog(@"logging user out");
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:RELINKED_USER_INFO];
        
        // wipe out core data for logging out user
        
        
    }
}

+ (NSDictionary *) getCurrentUserInfo {
    NSData *dataForCurrentUserInfo = [[NSUserDefaults standardUserDefaults] objectForKey:RELINKED_USER_INFO];
    if (dataForCurrentUserInfo != nil)
    {
        NSDictionary *oldSavedDict = [NSKeyedUnarchiver unarchiveObjectWithData:dataForCurrentUserInfo];
        if (oldSavedDict != nil)
            return [[NSDictionary alloc] initWithDictionary:oldSavedDict];
        else
            return nil;
    }
    return nil;
}

+ (void) saveAccessToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:RELINKED_ACCESS_TOKEN];
    
}

+ (NSString *) getSavedAccessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:RELINKED_ACCESS_TOKEN];
}



@end
