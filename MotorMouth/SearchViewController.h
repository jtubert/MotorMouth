//
//  SecondViewController.h
//  MotorMouth
//
//  Created by John Tubert on 12/17/12.
//  Copyright (c) 2012 John Tubert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface SearchViewController : PFQueryTableViewController <UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>{
    NSArray *itemsArr;
    NSMutableArray *objArr;
    
    NSInteger selectedSearchFilter;
    
    NSMutableDictionary *itemsDic;
    MapViewController* mapViewController;
    UISearchBar *searchBar;
	UISearchDisplayController *searchDC;
    NSArray *filteredArray;
    
    NSMutableArray *filteredArrayKeys;
    BOOL showAllEntries;
}

@property (nonatomic, strong) NSDate *lastRefresh;

@property (nonatomic) BOOL showAllEntries;

@property (nonatomic) NSInteger selectedSearchFilter;

@property (retain) NSArray *filteredArray;
@property (retain) NSMutableArray *filteredArrayKeys;

@property (retain) NSArray *itemsArr;

@property (retain) NSMutableArray *objArr;

@property (retain) NSMutableDictionary *itemsDic;
@property (retain) UISearchBar *searchBar;
@property (retain) UISearchDisplayController *searchDC;

@end
