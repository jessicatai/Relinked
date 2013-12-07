//
//  Request+Relinked.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "Request+Relinked.h"
#import "LinkedInFetcher.h"
#import "RelinkedStanfordServerRequest.h"

@implementation Request (Relinked)

+ (void) addAllRequestsInvolvingUser:(User *) currentUser {
    // first delete existing requests as this gets a clean fetch from stanford server
    [self deleteAllRequestsInContext:currentUser.managedObjectContext];
    
    
    NSLog(@"adding all requests for user");
    // call Stanford server for involved current user's requests
    // example url: http://www.stanford.edu/~jmtai/cgi-bin/cs193p/quickndirtySelectAll.php?tableName=Request&userID=0
    NSString *url = [NSString stringWithFormat:@"%@?tableName=Request&userID=%@", QUICKNDIRTY_SELECT_URL_BEGINNING, currentUser.userID];
    
    NSDictionary *results = [RelinkedStanfordServerRequest jsonResponseForURL:url];
    NSArray *requests = [results valueForKey:QUICKNDIRTY_RETURNED_DATA_KEY];
    
    for (NSDictionary *requestInfo in requests) {
        [self requestWithInfo:requestInfo inManagedObjectContext:currentUser.managedObjectContext];
    }
    NSLog(@"added %d requests", [requests count]);
}

+ (Request *)requestWithInfo:(NSDictionary *)requestInfo
  inManagedObjectContext:(NSManagedObjectContext *)context {
    Request *requestEntity = nil;

    // primary key for request is fromID, toID, sentDate
    NSString *fromID = requestInfo[QUICKNDIRTY_REQUEST_FROMID_KEY];
    NSString *toID = requestInfo[QUICKNDIRTY_REQUEST_TOID_KEY];
    NSDate *sentDate = [RelinkedStanfordServerRequest convertStringToDate:requestInfo[QUICKNDIRTY_REQUEST_SENT_DATE_KEY]];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Request"];
    request.predicate = [NSPredicate predicateWithFormat:@"fromID = %@ and toID = %@ and sentDate = %@", fromID, toID, sentDate];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        // handle error
        NSLog(@"Error in creating/accessing request; context %@", context);
        // delete any currently stored users
        for (NSManagedObject *user in matches) {
            [context deleteObject:user];
        }
        // TODO: try again for userinfo? (bad to have recursion?)
        
    } else {
        if ([matches count]) {
            requestEntity = [matches firstObject];
        } else {
            requestEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Request"
                                                          inManagedObjectContext:context];
        }
        // overwrite request bc may be inconsistent with Stanford server
        requestEntity.fromID = fromID;
        requestEntity.fromUser = [User getUserWithID:fromID inManagedObjectContext:context];
        requestEntity.toID = toID;
        requestEntity.toUser = [User getUserWithID:toID inManagedObjectContext:context];
        requestEntity.sentDate = sentDate;
        requestEntity.status = requestInfo[QUICKNDIRTY_REQUEST_STATUS_KEY];
    }
    [context save:&error];
    return requestEntity;
}

+ (NSArray *) allRequestsInvolvingUser:(User *) user withStatus:(NSString *)status {
   
    NSString *unique = user.userID;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Request"];
    request.predicate = [NSPredicate predicateWithFormat:@"(fromID = %@ or toID=%@) and status=%@", unique, unique, status];
    
    NSError *error;
    NSArray *matches = [user.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!matches || error) {
        // handle error
        NSLog(@"Error in creating/accessing request; context %@", user.managedObjectContext);
        // delete any currently stored users
        for (NSManagedObject *user in matches) {
            [user.managedObjectContext deleteObject:user];
        }
        
    } else if ([matches count] > 0) {
        return matches;
    }
    return nil;
}

+ (void) deleteRequest:(Request *)request {
    // remove from Stanford server
    NSString *tableName = @"Request";
    
    NSString *url= [NSString stringWithFormat:@"%@?tableName=%@&fromID=%@&toID=%@&sentDate=%@&action=delete", QUICKNDIRTY_REQUEST_URL_BEGINNING, tableName, request.fromUser.userID, request.toUser.userID, [RelinkedStanfordServerRequest convertDateToString:request.sentDate]];
    [RelinkedStanfordServerRequest executeQuickNDirtyQuery:url];
    
    [request.managedObjectContext deleteObject:request]; // remove from core data
}


+ (void) deleteAllRequestsInContext:(NSManagedObjectContext *) context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Request"];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error) {
        // error handling
        NSLog(@"ERROR: could not delete all requests");
    } else if (matches) {
        for (Request *req in matches) {
            [context deleteObject:req];
        }
    }
    // save this until user logs out
    [context save:&error];
}

// example: http://www.stanford.edu/~jmtai/cgi-bin/cs193p/quickndirtyRequestDB.php?tableName=Request&fromID=1&toID=2&sentDate=2013-09-09&action=insert
+ (void)addNewRequestFromUserID:(NSString *)fromID
                       toUserID:(NSString *)toID
                     withAction:(NSString *) action
                     withStatus:(NSString *)status
                       withDate:(NSString *)date
         inManagedObjectContext:(NSManagedObjectContext *)context {
    NSString *tableName = @"Request";
    
    NSString *url= [NSString stringWithFormat:@"%@?tableName=%@&fromID=%@&toID=%@&sentDate=%@&action=%@&status=%@", QUICKNDIRTY_REQUEST_URL_BEGINNING, tableName, fromID, toID, date, action, status];
    [RelinkedStanfordServerRequest executeQuickNDirtyQuery:url];
    
    // also add this Core Data
    NSDictionary *requestInfo = @{
                                  @"fromID" : fromID,
                                  @"toID": toID,
                                  @"sentDate": date,
                                  @"status" : status,
                                  };
    [self requestWithInfo:requestInfo inManagedObjectContext:context];
}

@end
