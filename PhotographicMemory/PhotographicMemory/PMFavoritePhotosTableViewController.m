//
//  PMFavoritePhotosViewController.m
//  PhotographicMemory
//
//  Created by Chris Moghbel on 2/10/15.
//  Copyright (c) 2015 Chris Moghbel. All rights reserved.
//

#import "PMPhotoMetadata.h"
#import "PMPhotosMetadataManager.h"
#import "PMFavoritePhotosTableViewController.h"

@interface PMFavoritePhotosTableViewController ()

@end

@implementation PMFavoritePhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _blankState.text = @"You haven't added any favorites yet.";
    _blankState.textAlignment = NSTextAlignmentCenter;
}

- (void) getPhotos
{
    _photos = [PMPhotosMetadataManager getFavorites];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *titleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Set Title" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Set Title" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set", nil];
        _lastTitleIndexPath = indexPath;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }];
    titleAction.backgroundColor = [UIColor greenColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Remove" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        PMPhotoMetadata *photoMetadata = [_photos objectAtIndex:indexPath.row];
        [photoMetadata setIsFavorite:NO];
        [self refreshData];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[titleAction, deleteAction];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
