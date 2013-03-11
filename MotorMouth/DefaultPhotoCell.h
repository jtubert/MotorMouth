//
//  DefaultPhotoCell.h
//  Puzzle
//
//  Created by John Tubert on 12/21/09.
//  Copyright 2009 jtubert.com. All rights reserved.
//

#import "ABTableViewCell.h"
#import "mmObject.h"


@interface DefaultPhotoCell : ABTableViewCell {
	UIImage *image1;
	UIImage *image2;
	UIImage *image3;
	mmObject *dataObject1;
	mmObject *dataObject2;
	mmObject *dataObject3;
}

@property (nonatomic, copy) UIImage *image1;
@property (nonatomic, copy) UIImage *image2;
@property (nonatomic, copy) UIImage *image3;
@property (nonatomic) mmObject *dataObject1;
@property (nonatomic) mmObject *dataObject2;
@property (nonatomic) mmObject *dataObject3;

@end
