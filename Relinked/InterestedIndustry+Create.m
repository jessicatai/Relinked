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

@end
