//
//  DefaultPhotoController.m
//  Puzzle
//
//  Created by John Tubert on 12/20/09.
//  Copyright 2009 jtubert.com. All rights reserved.
//

#import "SearchViewController.h"
#import "Consts.h"
#import "Reachability.h"
#import "mmObject.h"
#import "DefaultPhotoCell.h"

#define DEFAULTKEYS [self.itemsDic.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
#define FILTEREDKEYS [self.filteredArrayKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]


@implementation SearchViewController


@synthesize lastRefresh;
@synthesize filteredArray;
@synthesize filteredArrayKeys;
@synthesize searchBar;
@synthesize searchDC;
@synthesize itemsDic;
@synthesize itemsArr;
@synthesize objArr;
@synthesize showAllEntries;
@synthesize selectedSearchFilter;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // The className to query on
        self.className = @"mmObject";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 1000;
        
        //self.isLoading = YES;
        
        
    }
    return self;
}


- (void) displayMyEntriesOnly{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle: @"All entries"
                                             style: UIBarButtonItemStyleBordered
                                             target: self
                                             action: @selector(displayAllEntries)];
    
    showAllEntries = TRUE;
    
    [self loadObjects];
    
    

}

- (void) displayAllEntries{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle: @"My entries"
                                             style: UIBarButtonItemStyleBordered
                                             target: self
                                             action: @selector(displayMyEntriesOnly)];
    
    showAllEntries = FALSE;
    
    
    [self loadObjects];
    
}

- (void)viewWillAppeared:(BOOL)animated
{
    [self hidesSearchBar];
    [super viewWillAppear:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//NSLog(@"ListViewController viewDidLoad");
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [super viewDidLoad];
    [Flurry logEvent:@"SEARCH_VIEW"];
    [TestFlight passCheckpoint:@"SEARCH_VIEW"];
    
    showAllEntries = FALSE;
    
    self.title = NSLocalizedString(@"Search", @"Search");
    self.tabBarItem.image = [UIImage imageNamed:@"second"];
    self.tabBarItem.title = @"Search";
    
            
    
    lastRefresh = [[NSUserDefaults standardUserDefaults] objectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    
    
    self.itemsDic = [NSMutableDictionary dictionary];
    
    self.selectedSearchFilter = 4;   
    
    // Create a search bar
	self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
	self.tableView.tableHeaderView = self.searchBar;
    self.searchBar.delegate = self;
    
    NSArray* titles = [[NSArray alloc] initWithObjects:@"Plate",@"City",@"State",@"Zip",@"All", nil];
    
    self.searchBar.scopeButtonTitles = titles;
    self.searchBar.selectedScopeButtonIndex = 4;
	
	// Create the search display controller
	self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
	self.searchDC.searchResultsDataSource = self;
	self.searchDC.searchResultsDelegate = self;
    
    

    
    //UIBarButtonItem *suggestButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(openPrompt)];
    //self.navigationItem.leftBarButtonItem = suggestButton;
    
    //self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[[[UIView alloc] init] autorelease]];
     
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithTitle: @"My entries"
                                               style: UIBarButtonItemStyleBordered
                                               target: self
                                               action: @selector(displayMyEntriesOnly)];
    
    [self hidesSearchBar];

	
}

#pragma mark - searchBar

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    //[self.tableView reloadData];
    [self hidesSearchBar];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    //@"Plate",@"City",@"State",@"Zip",@"All"
    self.selectedSearchFilter = selectedScope;
}

//USE THIS FOR SERVERSIDE SEARCH (if necessary)
/////////////
/////////////
/////////////
/*
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //NSLog(@"%@",searchText);
    
    if (searchText.length > 2) {
        PFQuery *query = [PFQuery queryWithClassName:@"mmObject"];
        //[query setLimit:1000];
        
        switch (self.selectedSearchFilter) {
            case 0:
                [query whereKey:@"licensePlateNumber" containsString:searchText];
                break;
            case 1:                
                [query whereKey:@"subLocality" containsString:searchText];
                break;
            case 2:                
                [query whereKey:@"administrativeArea" containsString:searchText];
                break;
            case 3:                
                [query whereKey:@"postalCode" containsString:searchText];
                break;
            case 4:                                
                [query whereKey:@"licensePlateNumber" containsString:searchText];
                [query whereKey:@"subLocality" containsString:searchText];
                [query whereKey:@"administrativeArea" containsString:searchText];
                [query whereKey:@"postalCode" containsString:searchText];
                break;
                
            default:
                
                break;
        }

        
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                [self clear];
                
                NSMutableArray* tempArr = [[NSMutableArray alloc] init];
                
                NSLog(@"findObjectsInBackgroundWithBlock: %u", objects.count);
                
                for (int i=0; i < objects.count; i++) {
                    PFObject *item = [objects objectAtIndex:i];
                    mmObject *obj = [[mmObject alloc] initWithObject:item];                                       
                    [tempArr addObject:obj];
                }

                
                self.filteredArray = [NSArray arrayWithArray:tempArr];
                self.filteredArrayKeys = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < self.filteredArray.count; i++) {
                    mmObject *item = [self.filteredArray objectAtIndex:i];
                    [self.filteredArrayKeys addObject:item.object.objectId];
                }
                
                NSLog(@"self.filteredArray: %u", self.filteredArray.count);
                NSLog(@"filteredArrayKeys: %u", self.filteredArrayKeys.count);

                
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];

    }
    
}
*/
/////////////
/////////////
/////////////


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{    
    //NSLog(@"searchBarCancelButtonClicked");    
	[self.searchBar setText:@""];
    [Flurry logEvent:@"SEARCH_CANCEL_BUTTON_PRESSED"];
}




#pragma mark - PFQueryTableViewController


- (PFTableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath{
    PFTableViewCell *cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"Load more +";
    return cell;
}


- (PFQuery *)queryForTable {
    
    NSLog(@"reloaddata");
    
    /*
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:@"mmObject"];
        [query setLimit:0];
        return query;
    }*/
    
    PFQuery *queryMMObject = [PFQuery queryWithClassName:@"mmObject"];
    
    NSLog(@"showAllEntries: %u",showAllEntries);
    
    
    if(showAllEntries){
        [queryMMObject whereKey:kPAPPhotoUserKey equalTo:[PFUser currentUser]];
    }
    
    [queryMMObject orderByDescending:@"createdAt"];
    
    
    //[queryMMObject setCachePolicy:kPFCachePolicyCacheThenNetwork];
    
    
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        NSLog(@"Loading from cache");
        [queryMMObject setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    
    return queryMMObject;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    NSLog(@"objectsDidLoad");
    
    lastRefresh = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:lastRefresh forKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    self.itemsArr = [NSArray arrayWithArray:self.objects];
    self.objArr = [[NSMutableArray alloc] init];
    
    NSLog(@"count:  :::::::%u",self.itemsArr.count);
    
    for (int i=0; i < self.itemsArr.count; i++) {
        PFObject *item = [self.itemsArr objectAtIndex:i];
        mmObject *obj = [[mmObject alloc] initWithObject:item];
        //NSString *str = [item objectForKey:@"licensePlateNumber"];
        NSString *str = [item objectId];
        [self.itemsDic setObject:obj forKey:str];
        
        [self.objArr addObject:obj];
    }
    
    [self.tableView reloadData];
    
    //NSLog(@"%@",self.licenseArr);
    
    //[self loadNextPage];
}


#pragma mark UITableViewDataSource Methods

// Only one section in this table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}



// Return how many rows in the table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.tableView){
        float f = (CGFloat)self.itemsArr.count;
        return (int)ceil(f);
    }
    
    //@"Plate",@"City",@"State",@"Zip",@"All"
    
    NSPredicate *predicate;
    
    
    switch (self.selectedSearchFilter) {
        case 0:
            predicate = [NSPredicate predicateWithFormat:@"licensePlateNumber contains[cd] %@", self.searchBar.text]; 
            break;
        case 1:
            predicate = [NSPredicate predicateWithFormat:@"subLocality contains[cd] %@", self.searchBar.text];
            break;
        case 2:
            predicate = [NSPredicate predicateWithFormat:@"administrativeArea contains[cd] %@", self.searchBar.text];
            break;
        case 3:
            predicate = [NSPredicate predicateWithFormat:@"postalCode contains[cd] %@", self.searchBar.text];
            break;
        case 4:
            predicate = [NSPredicate predicateWithFormat:@"licensePlateNumber contains[cd] %@ OR subLocality contains[cd] %@ OR postalCode contains[cd] %@ OR administrativeArea contains[cd] %@", self.searchBar.text, self.searchBar.text, self.searchBar.text, self.searchBar.text];
            break;
            
        default:
            
            break;
    }
    
    

    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY @allValues contains[cd] %@", self.searchBar.text];
    self.filteredArray = [self.objArr filteredArrayUsingPredicate:predicate];
    self.filteredArrayKeys = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.filteredArray.count; i++) {
        mmObject *item = [self.filteredArray objectAtIndex:i];
        [self.filteredArrayKeys addObject:item.object.objectId];
    }
    
    
    //NSLog(@"%u",self.filteredArray.count);
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", self.searchBar.text];
    //self.filteredArray = [self.itemsDic.allKeys filteredArrayUsingPredicate:predicate];
    
    
    
    
    
	return self.filteredArray.count;
}

- (void)hidesSearchBar
{
    CGSize searchSize = self.searchDC.searchBar.bounds.size;
    //not complete
    [self.tableView setContentOffset:CGPointMake(0, searchSize.height)];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 94;
}

// Return a cell for the ith row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
   
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    mmObject *item;
    
    
    if(tableView == self.tableView){
        item = [self.objArr objectAtIndex:indexPath.row];
    }else{
        NSString *key = [FILTEREDKEYS objectAtIndex:indexPath.row];
        item = [self.itemsDic objectForKey:key];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSDate* d = [item.object updatedAt];
    NSString* date = [dateFormatter stringFromDate:d];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Plate#: %@, (%@)",item.licensePlateNumber, date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@",item.subLocality, item.locality, item.postalCode];
    PFFile *file = item.thumbnail;
    
    
    //cell.textLabel.text = [item objectForKey:@"licensePlateNumber"];
    //cell.detailTextLabel.text = [item objectForKey:@"subLocality"];
    //PFFile *file = [item objectForKey:kPAPPhotoThumbnailKey];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.imageView.image =image;
        } else {
            NSLog(@"Error on fetching file");
        }
    }];
    

    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [Flurry logEvent:@"SEARCH_ITEM_SELECTED"];
    
    if (!mapViewController) {
        mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    }
    
    
    mmObject *item;
    
    if(tableView == self.tableView){
        item = [self.objArr objectAtIndex:indexPath.row];
    }else{
        NSString *key = [FILTEREDKEYS objectAtIndex:indexPath.row];
        
        
        item = [self.itemsDic objectForKey:key];
        
        
    }

    
    
    
    mapViewController.detailItem = item.object;
    [self.navigationController pushViewController:mapViewController animated:YES];
    
}




/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}




@end
