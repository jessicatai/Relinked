//
//  IndustryTVC.m
//  Relinked
//
//  Created by Jessica Tai on 12/2/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

/*
TODO: dynamically populate industries based on cxn info
 store welcome preferences in user data both in core data and to cgi-bin
 */

#import "IndustryTVC.h"
#import "SuggestionsCDTVC.h"
#import "CurrentUserNavigationController.h"

#import "User+LinkedIn.h"

@interface IndustryTVC ()

@property (strong, nonatomic) NSMutableDictionary *industryFirstLetters;
@property (strong, nonatomic) NSMutableArray *checkedIndexPaths;

@end

@implementation IndustryTVC

static NSString *CellIdentifier = @"Industry Cell";



- (IBAction)clickDoneButton:(UIBarButtonItem *)sender {    
    // TODO: add popover segue for error message (see url in demo code)
    dispatch_queue_t fetchQ = dispatch_queue_create("relinked fetch suggestions", NULL);
    dispatch_async(fetchQ, ^{

        [User addPreferencesForUser:self.currentUser withContactMethods:self.contactMethods withIndustries:[self selectedIndustries]];
        NSLog(@"user contact methods %@", self.currentUser.contactMethods);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"dispatching back to main queue");
            [self prepareAndPresentViewController];
        });
    });
    
}

- (NSArray *) industries {
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.currentUser.managedObjectContext];
//    
//    // Required! Unless you set the resultType to NSDictionaryResultType, distinct can't work.
//    // All objects in the backing store are implicitly distinct, but two dictionaries can be duplicates.
//    // Since you only want distinct names, only ask for the 'name' property.
//    fetchRequest.resultType = NSDictionaryResultType;
//    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"industry"]];
//    fetchRequest.returnsDistinctResults = YES;
//    
//    // Now it should yield an NSArray of distinct values in dictionaries.
//    NSArray *dictionaries = [self.currentUser.managedObjectContext executeFetchRequest:fetchRequest error:nil];
//    NSLog (@"industries: %@",dictionaries);
//    return dictionaries;
    return @[@"Accounting", @"Banking", @"Biotechnology", @"Computer & Networking Security", @"Computer Hardware", @"Computer Software", @"Consumer Services", @"Electrical/Electronic Manufacturing", @"Design", @"Financial Services", @"Fine Art"];
}

- (NSArray *) selectedIndustries {
    NSMutableArray* selected = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in self.checkedIndexPaths) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [selected addObject:cell.textLabel.text];
    }
    return selected;
}

- (NSMutableDictionary *) industryFirstLetters {
    _industryFirstLetters = [[NSMutableDictionary alloc] init];
    for (NSString *industry in [self industries]) {
        NSMutableArray *getIndustries = [[NSMutableArray alloc] initWithArray:[_industryFirstLetters valueForKey:[industry substringToIndex:1]]];
        [getIndustries addObject:industry];
        [_industryFirstLetters setObject:getIndustries forKey:[industry substringToIndex:1]];
    }
    return _industryFirstLetters;
}

- (NSMutableArray *) checkedIndexPaths {
    if (!_checkedIndexPaths) {
        _checkedIndexPaths = [[NSMutableArray alloc] init];
    }
    return _checkedIndexPaths;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.industryFirstLetters count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.industryFirstLetters allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.industryFirstLetters valueForKey:[[[self.industryFirstLetters allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString* industry = [[self.industryFirstLetters valueForKey:[[[self.industryFirstLetters allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = industry;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
// (un)check industries of interest
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selected = NO;
    if ([self.checkedIndexPaths containsObject:indexPath]) { // clicking on a previously selected item
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.checkedIndexPaths removeObject:indexPath];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.checkedIndexPaths addObject:indexPath];
    }
    //cell.userInteractionEnabled = YES;
    [self.tableView reloadData];
}


#pragma mark - Navigation

- (void) prepareAndPresentViewController {
    NSString *storyboardName = [self.splitViewController.viewControllers lastObject] ? @"Main_iPad" : @"Main_iPhone";
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardName bundle:Nil];
    UITabBarController *viewController = (UITabBarController *)[storyBoard instantiateViewControllerWithIdentifier:@"mainTabBarController"];
    // pass current context
    NSLog(@"current user passing to suggestions %@", self.currentUser.firstName);
    //viewController.currentUser = self.currentUser;
    
    for (id vc in viewController.viewControllers) {
        if ([vc isKindOfClass:[CurrentUserNavigationController class]]) {
            CurrentUserNavigationController *scdtvc = (CurrentUserNavigationController *) vc;
            scdtvc.currentUser = self.currentUser;
        }
        
    }
    
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void) returnToLoginVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
