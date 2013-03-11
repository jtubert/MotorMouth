//
//  DefaultPhotoDataObject.h
//  Puzzle
//
//  Created by John Tubert on 12/21/09.
//  Copyright 2009 jtubert.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DefaultPhotoDataObject : NSObject {
	NSString *thumbImagePath;	
	NSString *largeImagePath;
	NSString *photoID;
	NSString *imageType;
}

@property (nonatomic)  NSString *thumbImagePath;
@property (nonatomic)  NSString *largeImagePath;
@property (nonatomic)  NSString *photoID;
@property (nonatomic)  NSString *imageType;

@end
