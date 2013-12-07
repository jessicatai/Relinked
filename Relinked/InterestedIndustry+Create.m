//
//  InterestedIndustry+Create.m
//  Relinked
//
//  Created by Jessica Tai on 12/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "InterestedIndustry+Create.h"
#import "User+LinkedIn.h"

@implementation InterestedIndustry (Create)

+ (InterestedIndustry *)interestedIndustry:(NSString *)industry
                                 forUserID:(NSString *)userID
                    inManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"InterestedIndustry"];
    request.predicate = [NSPredicate predicateWithFormat:@"user.userID = %@ and industry = %@", userID, industry];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    InterestedIndustry *interestedIndustry;
    
    if (!matches || error || ([matches count] > 1)) {
        NSLog(@"Error getting interested industry %@ for userID %@", industry, userID);
    } else if ([matches count])  {
        interestedIndustry = [matches firstObject];
    } else {
        interestedIndustry = [NSEntityDescription insertNewObjectForEntityForName:@"InterestedIndustry"
                                                      inManagedObjectContext:context];
        interestedIndustry.industry = industry;
        interestedIndustry.user = [User getUserWithID:userID inManagedObjectContext:context];
    }
    [context save:&error];
    return interestedIndustry;
}

+ (void) deleteIndustry:(NSString *)industry forUser:(User *)user {
    NSError *error;
    InterestedIndustry *ind = [self interestedIndustry:industry forUserID:user.userID inManagedObjectContext:user.managedObjectContext];
    [user.managedObjectContext deleteObject:ind];
    [user.managedObjectContext save:&error];
}

+ (InterestedIndustry *) getIndustry:(NSString *)industry forUser:(User *)user {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"InterestedIndustry"];
    request.predicate = [NSPredicate predicateWithFormat:@"user.userID = %@ and industry = %@", user.userID, industry];
    
    NSError *error;
    NSArray *matches = [user.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] < 1 )) {
        NSLog(@"No interested industry %@ for userID %@", industry, user.userID);
    } else if ([matches count])  {
        return [matches firstObject];
    }
    return nil;
}

@end
