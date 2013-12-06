//
//  CurrentUserNavigationController.m
//  Relinked
//
//  Created by Jessica Tai on 12/4/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CurrentUserNavigationController.h"
#import "CurrentUserCDTVC.h"

@interface CurrentUserNavigationController ()

@end

@implementation CurrentUserNavigationController

- (void) viewDidLoad {
    NSLog(@"navi controller view did load");
}

- (void) setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    for (id vc in self.viewControllers) {
        if ([vc isKindOfClass:[CurrentUserCDTVC class]]) {
            CurrentUserCDTVC *cdtvc = (CurrentUserCDTVC *) vc;
            cdtvc.currentUser = self.currentUser;
                                       
        }
        
    }
    
}

@end
