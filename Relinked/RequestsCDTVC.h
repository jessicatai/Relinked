//
//  RequestsCDTVC.h
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CurrentUserCDTVC.h"
#import "Request+Relinked.h"
#import "RelinkedStanfordServerRequest.h"
#import <MessageUI/MessageUI.h>

@interface RequestsCDTVC : CurrentUserCDTVC
- (NSString *) getDetailedTextForRequest:(Request *)request; // abstract
-(void) updateRequestWithIndexPath:(NSIndexPath *)indexPath forAction:(NSString *) action forStatus:(NSString *)status;
-(void) deleteRequestWithIndexPath:(NSIndexPath *)indexPath;
-(Request *) requestForIndexPath:(NSIndexPath *) indexPath;
//- (void) prepForEmailForIndexPath:(NSIndexPath *)indexPath;
@end
