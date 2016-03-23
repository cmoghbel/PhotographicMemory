//
//  PMPhotosMetadataManager.h
//  PhotographicMemory
//
//  Created by Chris Moghbel on 2/13/15.
//  Copyright (c) 2015 Chris Moghbel. All rights reserved.
//

#import "PMPhotoMetadata.h"
#import <Foundation/Foundation.h>
@import Photos;

@interface PMPhotosMetadataManager : NSObject

+ (NSArray*) getFavorites;
+ (NSArray*) getRecents;
+ (NSArray*) getAll;

+ (NSArray*) getFavoritesKeys;
+ (NSArray*) getRecentsKeys;
+ (NSArray*) getAllKeys;

+ (PHAsset*) getAssetForMetadata:(PMPhotoMetadata*)metadata;

+ (NSArray*) searchMetadata:(NSArray*)metadata ForSearchQuery:(NSString*)query;

@end
