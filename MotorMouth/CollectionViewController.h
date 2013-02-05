//
//  ViewController.h
//  Test2
//
//  Created by John Tubert on 1/14/13.
//  Copyright (c) 2013 John Tubert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    IBOutlet UICollectionView* colView;
}

@property (nonatomic, retain) IBOutlet UICollectionView* colView;


@end
