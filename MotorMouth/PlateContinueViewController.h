//
//  PlateContinueViewController.h
//  MotorMouth
//
//  Created by John Tubert on 3/17/13.
//  Copyright (c) 2013 John Tubert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlateContinueViewController : UIViewController <UIScrollViewDelegate>{
    float oldY;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;


@end
