//
//  Request.h
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Request : NSManagedObject

@property (nonatomic, retain) NSDate * acceptDate;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * fromID;
@property (nonatomic, retain) NSDate * sentDate;
@property (nonatomic, retain) NSString * toID;
@property (nonatomic, retain) User *fromUser;
@property (nonatomic, retain) User *toUser;

@end
