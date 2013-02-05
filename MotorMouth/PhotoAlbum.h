//
//  PhotoAlbum.h
//  MotorMouth
//
//  Created by John Tubert on 1/1/13.
//  Copyright (c) 2013 John Tubert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface PhotoAlbum : NSObject{
    __block ALAssetsGroup* groupToAddTo;
}

@property (strong, atomic) ALAssetsLibrary* library;

- (PhotoAlbum*) initWithAlbumName:(NSString*) albumName;

- (void) saveImage: (UIImage*) image andAlbumName:(NSString*) albumName;


@end
