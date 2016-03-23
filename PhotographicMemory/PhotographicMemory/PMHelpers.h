//
//  PMHelpers.h
//  PhotographicMemory
//
//  Created by Chris Moghbel on 2/18/15.
//  Copyright (c) 2015 Chris Moghbel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMHelpers : NSObject

+ (BOOL) string:(NSString *)string
      hasPrefix:(NSString *)prefix
caseInsensitive:(BOOL)caseInsensitive;

+ (void) loadNewPictures;

@end
