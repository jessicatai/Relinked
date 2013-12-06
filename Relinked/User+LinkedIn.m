//
//  User+Create.m
//  Relinked
//
//  Created by Jessica Tai on 12/3/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "User+LinkedIn.h"
#import "Request+Relinked.h"
#import "LinkedInFetcher.h"

@implementation User (LinkedIn)
+ (User *)userWithInfo:(NSDictionary *)userDictionary
                    forCurrentUser:(User *)currentUser  // if nil, creating current user
            inManagedObjectContext:(NSManagedObjectContext *)context {
    User *user = nil;
    
    NSString *unique = [LinkedInFetcher parseIDFromProfileURL:[userDictionary valueForKeyPath:LINKEDIN_PROFILE_URL]];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userID = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        // handle error
        NSLog(@"Error in creating/accessing user; context %@", context);
        // delete any currently stored users
        for (NSManagedObject *user in matches) {
            [context deleteObject:user];
        }
        // TODO: try again for userinfo? (bad to have recursion?)
        
    } else if ([matches count]) {
        user = [matches firstObject];
        NSLog(@"found the user %@ %@!", user.firstName, user.lastName);
    } else {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                            inManagedObjectContext:context];
        user.firstName = userDictionary[LINKEDIN_FIRST_NAME];
        user.headline = userDictionary[LINKEDIN_HEADLINE];
        user.industry = userDictionary[LINKEDIN_INDUSTRY];
        user.lastName = userDictionary[LINKEDIN_LAST_NAME];
        user.profileURL = [userDictionary valueForKeyPath:LINKEDIN_PROFILE_URL];
        user.thumbnailURL = userDictionary[LINKEDIN_THUMBNAIL];
        user.userID = unique;
        
        // only set current user for connection users, not the just authenticated current user
        if (currentUser != nil) {
            // all connections are related to current user
            user.currentUser = currentUser;
        }
    }
    
    // save this until user logs out
    [context save:&error];
    return user;
}

+ (void)loadUsersArray:(NSArray *)connections // of LinkedIn User NSDictionary
              forCurrentUser:(User *)currentUser
    intoManagedObjectContext:(NSManagedObjectContext *)context {
    NSLog(@"in load users array for user id %@", currentUser.userID);
    for (NSDictionary *connection in connections) {
        [self userWithInfo:connection forCurrentUser:currentUser inManagedObjectContext:context];
    }
}

+ (void) deleteAllUsersInContext:(NSManagedObjectContext *) context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error) {
        // error handling
        NSLog(@"ERROR: could not delete all users");
    } else if (matches) {
        for (User *user in matches) {
            [context deleteObject:user];
        }
    }
    // save this until user logs out
    [context save:&error];
}

#pragma mark URL requests to Stanford server

+ (void) addPreferencesForUser:(User *) currentUser
            withContactMethods:(NSArray *)contactMethods
                withIndustries:(NSArray *) industries{
    // save to core data
    
    currentUser.contactMethods = [contactMethods componentsJoinedByString:RELINKED_DELIMITER];
    currentUser.interestedIndustries = [industries componentsJoinedByString:RELINKED_DELIMITER];
    NSError *error;
    [currentUser.managedObjectContext save:&error];
    
    // also save to the Stanford server
    [self addPreferencesArray:contactMethods forUser:currentUser forTableName:@"ContactMethod" forAction:@"insert"];
    [self addPreferencesArray:industries forUser:currentUser forTableName:@"InterestedIndustry" forAction:@"insert"];
    
    
}

+ (void) addPreferencesArray:(NSArray *) preferences
                     forUser:(User *) currentUser
                forTableName:(NSString *)tableName
                   forAction:(NSString *)action {
    // first delete all of user's old preferences
    [self deleteAllPreferencesForTableName:tableName withUserId:currentUser.userID];
    
    // insert new preferences
    for (NSString *pref in preferences) {
        [self prefRequestForTableName:tableName withUserID:currentUser.userID withPreference:pref withAction:action];
    }
}

+ (void) deleteAllPreferencesForTableName:(NSString *) tableName
                               withUserId:(NSString *) userID {
    NSString *url = [NSString stringWithFormat:@"%@?tableName=%@&userID=%@&action=delete", QUICKNDIRTY_PREFERENCE_URL_BEGINNING, tableName, [LinkedInFetcher urlEncodeString:userID]];
    [RelinkedStanfordServerRequest executeQuickNDirtyQuery:url];
}

/*
 construct a url with following these arguments:
 http://www.stanford.edu/~jmtai/cgi-bin/cs193p/quickndirtyPreferencesDB.php?tableName=InterestedIndustry&userID=1&preference=cs&action=insert
 */
+ (void)prefRequestForTableName:(NSString*) tableName
                     withUserID:(NSString *)userID
                 withPreference:(NSString *)preference
                     withAction:(NSString *) action{
    NSString *url= [NSString stringWithFormat:@"%@?tableName=%@&userID=%@&preference=%@&action=%@", QUICKNDIRTY_PREFERENCE_URL_BEGINNING, tableName, [LinkedInFetcher urlEncodeString:userID], [LinkedInFetcher urlEncodeString:preference], [LinkedInFetcher urlEncodeString:action]];
    NSLog(@"url: %@", url);
    [RelinkedStanfordServerRequest executeQuickNDirtyQuery:url];
}

// example: http://www.stanford.edu/~jmtai/cgi-bin/cs193p/quickndirtySelectAll.php?tableName=ContactMethod&preferences[email]=email&userID=36982350
// preferences = nil : gets either preferences of current user
// otherwise, gets users with same preferences as current user
+ (NSDictionary *) prefArrayRequestForTableName: (NSString *) tableName
                     forCurrentUserID:(NSString *) userID
                      withPreferences:(NSArray *)preferences {
    NSString *paramsArrayAsStr = @"";
    for (NSString *pref in preferences) {
        paramsArrayAsStr = [NSString stringWithFormat:@"%@&preferences[%@]=%@", paramsArrayAsStr, pref, pref];
    }
    
    NSString *url = preferences ?
    [NSString stringWithFormat:@"%@?tableName=%@&userID=%@%@", QUICKNDIRTY_SELECT_URL_BEGINNING, tableName, userID, paramsArrayAsStr] :
    [NSString stringWithFormat:@"%@?tableName=%@&userID=%@", QUICKNDIRTY_SELECT_URL_BEGINNING, tableName, userID];
    ;
    
    return [RelinkedStanfordServerRequest jsonResponseForURL:url];

}

+ (User *) getUserWithID:(NSString *) userID inManagedObjectContext:(NSManagedObjectContext *)context{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userID = %@", userID];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || error || ([matches count] > 1)) {
    } else if ([matches count]) {
        return [matches firstObject];
    }
    return nil; // did not find user with given id
}





@end
