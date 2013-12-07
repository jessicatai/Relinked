//
//  InterestedIndustry+Create.h
//  Relinked
//
//  Created by Jessica Tai on 12/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "InterestedIndustry.h"

@interface InterestedIndustry (Create)

+ (InterestedIndustry *)interestedIndustry:(NSString *)industry
                                 forUserID:(NSString *)userID
                    inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void) deleteIndustry:(NSString *)industry forUser:(User *)user;
+ (InterestedIndustry *) getIndustry:(NSString *)industry forUser:(User *)user;
@end
