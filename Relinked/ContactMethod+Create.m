//
//  ContactMethod+Create.m
//  Relinked
//
//  Created by Jessica Tai on 12/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "ContactMethod+Create.h"
#import "User+LinkedIn.h"

@implementation ContactMethod (Create)

+ (ContactMethod *)contactMethod:(NSString *)method
                         forUserID:(NSString *)userID
          inManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ContactMethod"];
    request.predicate = [NSPredicate predicateWithFormat:@"user.userID = %@", userID];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    ContactMethod *contactMethod;
    
    if (!matches || error || ([matches count] > 1)) {
        NSLog(@"Error getting contact method %@ for userID %@", method, userID);
    } else if ([matches count])  {
        contactMethod = [matches firstObject];
    } else {
        contactMethod = [NSEntityDescription insertNewObjectForEntityForName:@"ContactMethod"
                                                      inManagedObjectContext:context];
        contactMethod.method = method;
        contactMethod.user = [User getUserWithID:userID inManagedObjectContext:context];
    }
    [context save:&error];
    return contactMethod;
}

+(void) loadContactMethodArray:(NSArray *) methods
                     forUserID:(NSString *)userID
        inManagedObjectContext:(NSManagedObjectContext *)context {
    for (NSString *method in methods) {
        [self contactMethod:method forUserID:userID inManagedObjectContext:context];
    }
}

@end
