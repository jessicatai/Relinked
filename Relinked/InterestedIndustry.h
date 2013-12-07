//
//  InterestedIndustry.h
//  Relinked
//
//  Created by Jessica Tai on 12/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface InterestedIndustry : NSManagedObject

@property (nonatomic, retain) NSString * industry;
@property (nonatomic, retain) User *user;

@end
