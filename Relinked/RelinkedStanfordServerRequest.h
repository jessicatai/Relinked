//
//  RelinkedStanfordServerRequest.h
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RELINKED_DELIMITER @"***"
#define QUICKNDIRTY_PREFERENCE_URL_BEGINNING @"http://www.stanford.edu/~jmtai/cgi-bin/cs193p/quickndirtyPreferencesDB.php"
#define QUICKNDIRTY_SELECT_URL_BEGINNING @"http://www.stanford.edu/~jmtai/cgi-bin/cs193p/quickndirtySelectAll.php"
#define QUICKNDIRTY_REQUEST_URL_BEGINNING @"http://www.stanford.edu/~jmtai/cgi-bin/cs193p/quickndirtyRequestDB.php"

// data key values
#define QUICKNDIRTY_RETURNED_DATA_KEY @"data"
#define QUICKNDIRTY_REQUEST_FROMID_KEY @"fromID"
#define QUICKNDIRTY_REQUEST_TOID_KEY @"toID"
#define QUICKNDIRTY_REQUEST_SENT_DATE_KEY @"sentDate"
#define QUICKNDIRTY_REQUEST_STATUS_KEY @"status"
#define QUICKNDIRTY_REQUEST_ACCEPT_DATE_KEY @"acceptDate"

#define OPEN_STATUS @"open"
#define IGNORE_STATUS @"ignore"
#define ACCEPT_STATUS @"accept"

@interface RelinkedStanfordServerRequest : NSObject

+ (NSData *) executeQuickNDirtyQuery:(NSString *) url;
+ (NSDictionary *) jsonResponseForURL:(NSString *)url;
+ (NSDate *) convertStringToDate:(NSString *) dateString;
+ (NSString *) convertDateToString:(NSDate *) date;
@end
