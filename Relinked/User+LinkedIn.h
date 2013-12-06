//
//  User+Create.h
//  Relinked
//
//  Created by Jessica Tai on 12/3/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "User.h"
#import "RelinkedStanfordServerRequest.h"

@interface User (LinkedIn)
+ (User *)userWithInfo:(NSDictionary *)userDictionary
        forCurrentUser:(User *)currentUser
inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)loadUsersArray:(NSArray *)connections // of LinkedIn User NSDictionary
        forCurrentUser:(User *)currentUser
intoManagedObjectContext:(NSManagedObjectContext *)context;

+ (void) addPreferencesForUser:(User *) currentUser
            withContactMethods:(NSArray *)contactMethods
                withIndustries:(NSArray *) industries;

+ (NSDictionary *) prefArrayRequestForTableName: (NSString *) tableName
                             forCurrentUserID:(NSString *) userID
                              withPreferences:(NSArray *)preferences;

+ (User *) getUserWithID:(NSString *) userID inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void) deleteAllUsersInContext:(NSManagedObjectContext *) context;

@end
