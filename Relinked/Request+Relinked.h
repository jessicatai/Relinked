//
//  Request+Relinked.h
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "Request.h"
#import "User+LinkedIn.h"
#import "RelinkedStanfordServerRequest.h"

@interface Request (Relinked)

+ (void) addAllRequestsInvolvingUser:(User *) currentUser;
+ (NSArray *) allRequestsInvolvingUser:(User *) currentUser withStatus:(NSString *)status;
+ (void) deleteAllRequestsInContext:(NSManagedObjectContext *) context;
+ (void) deleteRequest:(Request *)request;
+ (void)addNewRequestFromUserID:(NSString *)fromID
                       toUserID:(NSString *)toID
                     withAction:(NSString *) action
                     withStatus:(NSString *)status
                       withDate:(NSString *)date
         inManagedObjectContext:(NSManagedObjectContext *)context;
@end
