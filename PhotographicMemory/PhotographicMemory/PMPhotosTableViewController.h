//
//  PMPhotosTableViewController.h
//  PhotographicMemory
//
//  Created by Chris Moghbel on 2/9/15.
//  Copyright (c) 2015 Chris Moghbel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
@import Photos;

@interface PMPhotosTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, IDMPhotoBrowserDelegate> {
    
    NSArray *_photos;
    
    NSString *_lastTitleInput;
    NSIndexPath *_lastTitleIndexPath;
    NSString *_searchQuery;
    
    UITextView *_blankState;
}

- (void) refreshData;
- (void) showBlankStateOrPhotos;

@end
