//
//  PhotoAlbum.m
//  MotorMouth
//
//  Created by John Tubert on 1/1/13.
//  Copyright (c) 2013 John Tubert. All rights reserved.
//

#import "PhotoAlbum.h"

@implementation PhotoAlbum

@synthesize library;

- (PhotoAlbum*) initWithAlbumName:(NSString*) albumName{
    
    self.library = [[ALAssetsLibrary alloc] init];
    
    [self createAlbum:albumName];
    
    
    return self;
}

- (void) createAlbum: (NSString*) albumName{
    [self.library addAssetsGroupAlbumWithName:albumName
                                  resultBlock:^(ALAssetsGroup *group) {
                                      NSLog(@"added album:%@", albumName);
                                  }
                                 failureBlock:^(NSError *error) {
                                     NSLog(@"error adding album");
                                 }];
}


- (void) saveImage: (UIImage*) image andAlbumName:(NSString*) albumName{
    
    
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
                                        NSLog(@"found album %@", albumName);
                                        groupToAddTo = group;
                                    }
                                }
                              failureBlock:^(NSError* error) {
                                  NSLog(@"failed to enumerate albums:\nError: %@", [error localizedDescription]);
                              }];

    
    
    
    
    CGImageRef img = [image CGImage];
    [self.library writeImageToSavedPhotosAlbum:img
                                      metadata:nil
                               completionBlock:^(NSURL* assetURL, NSError* error) {
                                   if (error.code == 0) {
                                       NSLog(@"saved image completed:\nurl: %@", assetURL);
                                       
                                       // try to get the asset
                                       [self.library assetForURL:assetURL
                                                     resultBlock:^(ALAsset *asset) {
                                                         // assign the photo to the album
                                                         [groupToAddTo addAsset:asset];
                                                         NSLog(@"Added %@ to %@", [[asset defaultRepresentation] filename], albumName);
                                                     }
                                                    failureBlock:^(NSError* error) {
                                                        NSLog(@"failed to retrieve image asset:\nError: %@ ", [error localizedDescription]);
                                                    }];
                                   }
                                   else {
                                       NSLog(@"saved image failed.\nerror code %i\n%@", error.code, [error localizedDescription]);
                                   }
                               }];
}

@end
