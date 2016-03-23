//
//  PMPhotosMetadataManager.m
//  PhotographicMemory
//
//  Created by Chris Moghbel on 2/13/15.
//  Copyright (c) 2015 Chris Moghbel. All rights reserved.
//

#import "PMPhotosMetadataManager.h"
#import "PMHelpers.h"

@implementation PMPhotosMetadataManager

+ (NSArray*) getFavorites {
    NSMutableArray *favorites = [NSMutableArray array];
    [[self getAll] enumerateObjectsUsingBlock:^(PMPhotoMetadata *photoMetadata, NSUInteger idx, BOOL *stop) {
        if (photoMetadata.favorite) {
            [favorites addObject:photoMetadata];
        }
    }];
   return favorites;
}

+ (NSArray*) getFavoritesKeys {
    NSMutableArray *favorites = [NSMutableArray array];
    [[self getAllKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        PMPhotoMetadata *photoMetadata = [[PMPhotoMetadata alloc] initWithKey:key];
        if (photoMetadata.favorite) {
            [favorites addObject:key];
        }
    }];
    return [NSArray arrayWithArray:favorites];
}

+ (NSArray*) getRecents {
    // TODO: Fix this
    return [self getAll];
}

+ (NSArray*) getRecentsKeys {
    // TODO: Fix this
    return [self getAllKeys];
}

+ (NSArray*) getAll {
    NSMutableArray *all = [NSMutableArray array];
    [[[NSUserDefaults standardUserDefaults] objectForKey:@"photos"] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        PMPhotoMetadata *photoMetadata = [[PMPhotoMetadata alloc] initWithKey:key];
        [all addObject:photoMetadata];
    }];
    return all;
}

+ (NSArray*) getAllKeys {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"photos"];
}

+ (PHAsset*) getAssetForMetadata:(PMPhotoMetadata*)metadata {
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[metadata.key] options:nil];
    if ([fetchResult count] > 0) {
        return [fetchResult objectAtIndex:0];
    }
    return nil;
}

+ (NSArray*) searchMetadata:(NSArray*)metadataArray ForSearchQuery:(NSString*)query {
    NSMutableArray *searchResults = [NSMutableArray array];
    [metadataArray enumerateObjectsUsingBlock:^(PMPhotoMetadata *metadata, NSUInteger idx, BOOL *stop) {
        if ([PMHelpers string:metadata.title hasPrefix:query caseInsensitive:YES]) {
//        if ([metadata.title hasPrefix:query]) {
            NSLog(@"Query Result Found: %@", metadata.title);
            [searchResults addObject:metadata];
        }
    }];
    return searchResults;
}

@end
