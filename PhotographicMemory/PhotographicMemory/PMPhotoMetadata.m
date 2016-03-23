//
//  PhotosHelper.m
//  PhotographicMemory
//
//  Created by Chris Moghbel on 2/7/15.
//  Copyright (c) 2015 Chris Moghbel. All rights reserved.
//

#import "PMPhotoMetadata.h"

NSMutableDictionary *_metadata;

@implementation PMPhotoMetadata

- (id)initWithKey:(NSString *)key {
    if (self = [super init])
    {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if (dict != nil) {
            _key = [dict valueForKey:@"key"];
            _title = [dict valueForKey:@"title"];
            _favorite = [@"YES" isEqualToString:[dict valueForKey:@"favorite"]];
        }
        else {
            _key = key;
            _title = @"Swipe to modify.";
            _favorite = NO;
        }
    }
    return self;
}

- (void) setTitle:(NSString *)title {
    _title = title;
    [self save];
}

- (void) setIsFavorite:(BOOL)favorite {
    _favorite = favorite;
    [self save];
}

- (void) save {
    NSMutableDictionary *photoMetadata = [NSMutableDictionary dictionaryWithObject:_key forKey:@"key"];
    [photoMetadata setValue:_title forKey:@"title"];
    if (_favorite) {
        [photoMetadata setValue:@"YES" forKey:@"favorite"];
    }
    else {
        [photoMetadata setValue:@"NO" forKey:@"favorite"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:photoMetadata forKey:_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
