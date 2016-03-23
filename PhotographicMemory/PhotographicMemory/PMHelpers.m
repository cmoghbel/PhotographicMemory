//
//  PMHelpers.m
//  PhotographicMemory
//
//  Created by Chris Moghbel on 2/18/15.
//  Copyright (c) 2015 Chris Moghbel. All rights reserved.
//

#import "PMHelpers.h"
#import "PMPhotoMetadata.h"
@import UIKit;
@import Photos;
#import <DropboxSDK/DBRestClient.h>

@implementation PMHelpers

+ (BOOL) string:(NSString *)string
      hasPrefix:(NSString *)prefix
caseInsensitive:(BOOL)caseInsensitive {
    
    if (!caseInsensitive)
        return [string hasPrefix:prefix];
    
    const NSStringCompareOptions options = NSAnchoredSearch|NSCaseInsensitiveSearch;
    NSRange prefixRange = [string rangeOfString:prefix
                                        options:options];
    return prefixRange.location == 0 && prefixRange.length > 0;
}

+ (void) loadNewPictures {
    NSLog(@"Loading data!");
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.sortDescriptors = @[
                                     [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES],
                                     ];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *photosImmutable = [defaults objectForKey:@"photos"];
    NSMutableArray *photos;
    if (photosImmutable == nil) {
        photos = [NSMutableArray arrayWithObjects:nil];
    }
    else {
        photos = [NSMutableArray arrayWithArray:photosImmutable];
    }
    
    // This is an array of photos we've already looked at previously that didn't match our criteria. This is important
    // so we can skip processing the entire camera roll every time.
    NSArray *photosToIgnoreImmutable = [defaults objectForKey:@"photosToIgnore"];
    NSMutableArray *photosToIgnore;
    if (photosToIgnoreImmutable == nil) {
        photosToIgnore = [NSMutableArray arrayWithObjects:nil];
    }
    else {
        photosToIgnore = [NSMutableArray arrayWithArray:photosToIgnoreImmutable];
    }
    
    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    [allPhotosResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        // If this is a new photo we haven't seen before
        if (![photos containsObject:asset.localIdentifier] && ![photosToIgnore containsObject:asset.localIdentifier]) {
            // If the photo is an HDR photo
            if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoHDR) {
                NSLog(@"Adding new metadata object for HDR photo: %@", asset.localIdentifier);
                [photos insertObject:asset.localIdentifier atIndex:0];
                PMPhotoMetadata *photoMetadata = [[PMPhotoMetadata alloc] initWithKey:asset.localIdentifier];
                [photoMetadata save];
            }
            else {
                PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
                imageOptions.synchronous = YES;
                imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:imageOptions resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                    // If the photo is a screenshot, add it, else log to ignore for next time so we don't have to process
                    // the entire camera roll each time
                    if ([@"public.png" isEqualToString:dataUTI]) {
                        NSLog(@"Adding new metadata object for screenshot: %@", asset.localIdentifier);
                        [photos insertObject:asset.localIdentifier atIndex:0];
                        NSString *filePath = [info objectForKey:@"PHImageFileURLKey"];
                        [PMHelpers uploadPhotoToDropbox:filePath];
                        PMPhotoMetadata *photoMetadata = [[PMPhotoMetadata alloc] initWithKey:asset.localIdentifier];
                        [photoMetadata save];
                    }
                    else {
                        NSLog(@"Adding photo to ignore list: %@", asset.localIdentifier);
                        [photosToIgnore addObject:asset.localIdentifier];
                    }
                }];
            }
        }
    }];
    
    [defaults setObject:photosToIgnore forKey:@"photosToIgnore"];
    [defaults setObject:photos forKey:@"photos"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PMDataLoaded" object:nil];

}

+ (void) uploadPhotoToDropbox:(NSString *)fileURL {
    
    NSString *filename = @"lalala";
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    NSString *localPath = [mainBundle pathForResource: asset.localIdentifier ofType: @"png"];
    NSString *destDir = @"/";
    
    DBSession *dbSession = [DBSession sharedSession];
    
    if (dbSession == nil) {
        NSLog(@"Trying to upload file with nil session!");
        return;
    }
    else if (![dbSession isLinked]) {
        NSLog(@"Trying to upload file without linked session!");
        return;
    }
    
    DBRestClient *restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
//    self.restClient.delegate = self;
    
    NSLog(@"Uploading file to dropbox?");
    [restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:fileURL];
    
}

@end
