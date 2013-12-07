//
//  RelinkedUserDefaults.h
//  Relinked
//
//  Created by Jessica Tai on 12/4/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelinkedUserDefaults : NSObject

+ (void) loginCurrentUser:(NSDictionary *) userInfo;
+ (BOOL) isUserLoggedIn;
+ (NSDictionary *) getCurrentUserInfo;
+ (void) logoutCurrentUser;
+ (void) saveAccessToken:(NSString *)token;
+ (NSString *) getSavedAccessToken;
+ (void) deleteSavedAccessToken;
@end
