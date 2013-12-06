//
//  User.h
//  Relinked
//
//  Created by Jessica Tai on 12/3/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Request, User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * contactMethods;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * hasSeenWelcome;
@property (nonatomic, retain) NSString * headline;
@property (nonatomic, retain) NSString * industry;
@property (nonatomic, retain) NSString * interestedIndustries;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * profileURL;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSSet *connections;
@property (nonatomic, retain) User *currentUser;
@property (nonatomic, retain) NSSet *receivedRequest;
@property (nonatomic, retain) NSSet *sentRequest;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addConnectionsObject:(User *)value;
- (void)removeConnectionsObject:(User *)value;
- (void)addConnections:(NSSet *)values;
- (void)removeConnections:(NSSet *)values;

- (void)addReceivedRequestObject:(Request *)value;
- (void)removeReceivedRequestObject:(Request *)value;
- (void)addReceivedRequest:(NSSet *)values;
- (void)removeReceivedRequest:(NSSet *)values;

- (void)addSentRequestObject:(Request *)value;
- (void)removeSentRequestObject:(Request *)value;
- (void)addSentRequest:(NSSet *)values;
- (void)removeSentRequest:(NSSet *)values;

@end
