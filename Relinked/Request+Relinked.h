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
+ (void)addNewRequestFromUserID:(NSString *)fromID
                       toUserID:(NSString *)toID
                     withAction:(NSString *) action
         inManagedObjectContext:(NSManagedObjectContext *)context;
@end
