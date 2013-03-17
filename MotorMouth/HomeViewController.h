//
//  MainViewController.h
//  MotorMouth
//
//  Created by John Tubert on 3/4/13.
//  Copyright (c) 2013 John Tubert. All rights reserved.
//


#import "CPFQueryCollectionViewController.h"
#import "Camera.h"
#import "PhotoAlbum.h"

@interface HomeViewController : CPFQueryCollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, PF_FBRequestDelegate, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    Camera* camera;
    PhotoAlbum* photoAlbum;
    
    NSArray *itemsArr;
    NSMutableArray *objArr;
    
    NSInteger selectedSearchFilter;
    
    NSMutableDictionary *itemsDic;    
    UISearchBar *searchBar;
	UISearchDisplayController *searchDC;
    NSArray *filteredArray;
    
    NSMutableArray *filteredArrayKeys;
    BOOL showAllEntries;
    
    UITableView *tableView;
    
    BOOL showGridView;

}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDate *lastRefresh;

@property (nonatomic) BOOL showAllEntries;

@property (nonatomic) BOOL showGridView;

@property (nonatomic) NSInteger selectedSearchFilter;

@property (retain) NSArray *filteredArray;
@property (retain) NSMutableArray *filteredArrayKeys;

@property (retain) NSArray *itemsArr;

@property (retain) NSMutableArray *objArr;

@property (retain) NSMutableDictionary *itemsDic;
@property (retain) UISearchBar *searchBar;
@property (retain) UISearchDisplayController *searchDC;

@end
