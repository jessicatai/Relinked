//
//  AppDelegate.m
//  Relinked
//
//  Created by Jessica Tai on 12/2/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "AppDelegate.h"
#import "LinkedInDatabaseAvailability.h"
#import "LinkedInFetcher.h"

@interface AppDelegate() <NSURLSessionDownloadDelegate>

@property (copy, nonatomic) void (^linkedInDownloadBackgroundURLSessionCompletionHandler)();
@property (strong, nonatomic) NSTimer *linkedInForegroundFetchTimer;
@property (strong, nonatomic) NSManagedObjectContext *linkedInDatabaseContext;
@property (strong, nonatomic) NSURLSession *linkedInDownloadSession;

@end

// name of the Linkedin fetching background download session
#define LINKEDIN_FETCH @"LinkedIn fetch"

// how often (in seconds) we fetch new photos if we are in the foreground
#define FOREGROUND_LINKEDIN_FETCH_INTERVAL (20*60)

// how long we'll wait for a Flickr fetch to return when we're in the background
#define BACKGROUND_LINKEDIN_FETCH_TIMEOUT (10)


@implementation AppDelegate

#pragma mark Linkedin Client
- (LIALinkedInHttpClient *) client {
    if (!_client) {
        NSArray *grantedAccess = @[@"r_fullprofile", @"r_network"];
        
        //load the the secret data from an uncommitted LIALinkedInClientExampleCredentials.h file
        NSString *clientId = LINKEDIN_CLIENT_ID; //the client secret you get from the registered LinkedIn application
        NSString *clientSecret = LINKEDIN_CLIENT_SECRET; //the client secret you get from the registered LinkedIn application
        NSString *state = @"DCEEFWF45453sdffef424"; //A long unique string value of your choice that is hard to guess. Used to prevent CSRF
        LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://www.linkedin.com" clientId:clientId clientSecret:clientSecret state:state grantedAccess:grantedAccess];
        _client = [LIALinkedInHttpClient clientForApplication:application];
    }
    return _client;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"MyDocument";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    
    if (fileExists) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            if (success) [self documentIsReady];
            else NSLog(@"Could not open the existing document at %@", url);
        }];
    } else {
        [self.document saveToURL:url
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:^(BOOL success) {
                   if (success) [self documentIsReady];
                   else NSLog(@"Could not create document at %@", url);
               }];
    }
    
    return YES;

}

- (void) documentIsReady {
    if (self.document.documentState == UIDocumentStateNormal) {
        self.linkedInDatabaseContext = self.document.managedObjectContext;
        [self startConnectionsFetch];
    }
}

#pragma mark - Database Context

- (void)setLinkedInDatabaseContext:(NSManagedObjectContext *)linkedInDatabaseContext{
    _linkedInDatabaseContext = linkedInDatabaseContext;
    [self.linkedInForegroundFetchTimer invalidate];
    self.linkedInForegroundFetchTimer = nil;
    
    if (self.linkedInDatabaseContext)
    {
        // fetch every now and then in the foreground
        self.linkedInForegroundFetchTimer = [NSTimer scheduledTimerWithTimeInterval:FOREGROUND_LINKEDIN_FETCH_INTERVAL
                                                                           target:self
                                                                         selector:@selector(startConnectionsFetch:)
                                                                         userInfo:nil
                                                                          repeats:YES];
    }
    // alert that context is ready
    NSDictionary *userInfo = self.linkedInDatabaseContext ? @{ LinkedInDatabaseAvailabilityContext : self.linkedInDatabaseContext } : nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:LinkedInDatabaseAvailabilityNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void) startConnectionsFetch: (NSTimer *)timer {
    [self startConnectionsFetch];
}

- (void) startConnectionsFetch {
    NSLog(@"HI, fetching from app delegate");
//    [self.linkedInDownloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
//        if (![downloadTasks count]) {
//            NSURLSessionDownloadTask *task = [self.linkedInDownloadSession downloadTaskWithURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]];
//            task.taskDescription = FLICKR_FETCH;
//            [task resume];
//        } else {
//            for (NSURLSessionDownloadTask *task in downloadTasks) [task resume];
//        }
//    }];
}
/*
- (NSArray *)linkedInPhotosAtURL:(NSURL *)url
{
    NSDictionary *linkedInPropertyList;
    NSData *linkedInJSONData = [NSData dataWithContentsOfURL:url];
    if (linkedInJSONData) {
        linkedInPropertyList = [NSJSONSerialization JSONObjectWithData:linkedInJSONData
                                                             options:0
                                                               error:NULL];
    }
    return [linkedInPropertyList valueForKeyPath:FLICKR_RESULTS_PHOTOS];
}

- (void)loadLinkedInConnectionsFromLocalURL:(NSURL *)localFile
                         intoContext:(NSManagedObjectContext *)context
                 andThenExecuteBlock:(void(^)())whenDone
{
    if (context) {
        NSArray *photos = [self linkedInPhotosAtURL:localFile];
        [context performBlock:^{
            // TODO: load connections into db
            [Photo loadPhotosFromFlickrArray:photos intoManagedObjectContext:context];
            
            if (whenDone) whenDone();
        }];
    } else {
        if (whenDone) whenDone();
    }
}

#pragma mark - NSURLSessionDownloadDelegate

// required by the protocol
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)localFile
{
    if ([downloadTask.taskDescription isEqualToString:LINKEDIN_FETCH]) {
        [self loadLinkedInConnectionsFromLocalURL:localFile
                               intoContext:self.linkedInDatabaseContext
                       andThenExecuteBlock:^{
                           [self linkedInDownloadTasksMightBeComplete];
                       }
         ];
    } else {
        NSLog(@"task description %@", downloadTask.taskDescription);
    }
}

// required by the protocol
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    // not supported
}

// required by the protocol
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}


- (void)linkedInDownloadTasksMightBeComplete
{
    if (self.linkedInDownloadBackgroundURLSessionCompletionHandler) {
        [self.linkedInDownloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
            if (![downloadTasks count]) {
                void (^completionHandler)() = self.linkedInDownloadBackgroundURLSessionCompletionHandler;
                self.linkedInDownloadBackgroundURLSessionCompletionHandler = nil;
                if (completionHandler) {
                    completionHandler();
                }
            }
        }];
    }
}
*/

@end
