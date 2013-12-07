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
#import "InterestedIndustry+Create.h"
#import "ContactMethod+Create.h"

@interface IndustryTVC ()

@property (strong, nonatomic) NSMutableDictionary *industryFirstLetters;
@property (strong, nonatomic) NSMutableArray *checkedIndexPaths;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation IndustryTVC

static NSString *CellIdentifier = @"Industry Cell";



- (IBAction)clickDoneButton:(UIBarButtonItem *)sender {
    // save the email, phone, other info
    self.currentUser.email = self.email;
    self.currentUser.phone = self.phone;
    self.currentUser.other = self.other;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self.view addSubview:spinner];
    spinner.center = self.parentViewController.view.center;
    // TODO: add popover segue for error message (see url in demo code)
    dispatch_queue_t fetchQ = dispatch_queue_create("relinked fetch suggestions", NULL);
    dispatch_async(fetchQ, ^{
        [spinner startAnimating];
        [User addPreferencesForUser:self.currentUser withContactMethods:self.contactMethods withIndustries:[self selectedIndustries]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"dispatching back to main queue");
            [spinner stopAnimating];
            [self prepareAndPresentViewController];
        });
    });
    
}

- (NSArray *) industries {
// used TVC just for more breadth... would instead use CDTVC
// TODO change this to CDTVC and populate industries based on actual contact (so all industries have at least one contact)
    return @[@"Accounting", @"Banking", @"Biotechnology", @"Computer Hardware", @"Computer Software", @"Consumer Services", @"Electrical/Electronic Manufacturing", @"Design", @"Financial Services", @"Fine Art", @"Human Resources", @"Investment Banking", @"Management Consulting", @"Pharmaceuticals", @"Staffing and Recruiting", @"Telecommunications", @"Wholesale"];
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
    if (!_industryFirstLetters) {
        _industryFirstLetters = [[NSMutableDictionary alloc] init];
        for (NSString *industry in [self industries]) {
            NSMutableArray *getIndustries = [[NSMutableArray alloc] initWithArray:[_industryFirstLetters valueForKey:[industry substringToIndex:1]]];
            [getIndustries addObject:industry];
            [_industryFirstLetters setObject:getIndustries forKey:[industry substringToIndex:1]];
        }
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

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[self.industryFirstLetters allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString* industry = [[self.industryFirstLetters valueForKey:[[[self.industryFirstLetters allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = industry;
    cell.selectionStyle = [self.checkedIndexPaths containsObject:indexPath] ? UITableViewCellAccessoryCheckmark :  UITableViewCellSelectionStyleNone;
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

#pragma mark - SearchDisplayController
// TODO implement search bar
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
//shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self.view filterContentForSearchText:searchString
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:[self.searchDisplayController.searchBar
//                                                     selectedScopeButtonIndex]]];
//    
//    return YES;
//}


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
