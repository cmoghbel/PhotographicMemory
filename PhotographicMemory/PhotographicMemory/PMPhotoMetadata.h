//
//  PhotosHelper.h
//  PhotographicMemory
//
//  Created by Chris Moghbel on 2/7/15.
//  Copyright (c) 2015 Chris Moghbel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMPhotoMetadata : NSObject

@property (readonly) NSString *key;
@property (readonly) NSString *title;
@property (readonly) BOOL favorite;

- (id) initWithKey:(NSString *)key;

- (void) setTitle:(NSString *)title;
- (void) setIsFavorite:(BOOL)favorite;

- (void) save;

@end
