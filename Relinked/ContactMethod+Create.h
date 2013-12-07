//
//  ContactMethod+Create.h
//  Relinked
//
//  Created by Jessica Tai on 12/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "ContactMethod.h"

@interface ContactMethod (Create)

+ (ContactMethod *)contactMethod:(NSString *)method
                       forUserID:(NSString *)userID
          inManagedObjectContext:(NSManagedObjectContext *)context;
+(void) loadContactMethodArray:(NSArray *) methods
                     forUserID:(NSString *)userID
        inManagedObjectContext:(NSManagedObjectContext *)context;
@end
