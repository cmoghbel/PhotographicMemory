//
//  PMPhotosTableViewController.m
//  PhotographicMemory
//
//  Created by Chris Moghbel on 2/9/15.
//  Copyright (c) 2015 Chris Moghbel. All rights reserved.
//

#import "PMPhotosTableViewController.h"
#import "PMPhotoMetadata.h"
#import "PMPhotosMetadataManager.h"
#import <objc/runtime.h>
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import <IDMPhotoBrowser/IDMPhoto.h>
@import Photos;

@interface PMPhotosTableViewController ()

@end

int kBlankStateHorizontalPadding = 10;
int kCellHeight = 80;

@implementation PMPhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCellIdentifier1"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    CGSize tableViewDimensions = self.tableView.frame.size;
    _blankState = [[UITextView alloc] initWithFrame:CGRectMake(kBlankStateHorizontalPadding, tableViewDimensions.height / 2, tableViewDimensions.width - kBlankStateHorizontalPadding * 2, tableViewDimensions.height)];
    _blankState.text = @"No photos yet. Take an HDR photo in order to mark photos as informational.";
    [_blankState setEditable:NO];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                                                     style:UIBarButtonItemStyleDone target:self action:@selector(showSearch)];
    self.navigationItem.rightBarButtonItem = searchButton;

    [self refreshData];
    [self showBlankStateOrPhotos];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"PMDataLoaded" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshData];
    [self.tableView reloadData];
}

- (void) refreshData
{

    [self getPhotos];
    if (_searchQuery != nil && ![@"" isEqualToString:_searchQuery]) {
        [self conductSearch];
    }
    [self.tableView reloadData];
    
    [self showBlankStateOrPhotos];
}

- (void) getPhotos
{
     _photos = [PMPhotosMetadataManager getAll];
}

- (void) conductSearch
{
    _photos = [PMPhotosMetadataManager searchMetadata:_photos ForSearchQuery:_searchQuery];
}

- (void) showBlankStateOrPhotos
{
    if ([_photos count] == 0) {
        // Show blank state if there's no photos to display.
        self.tableView.scrollEnabled = NO;
        [self.tableView addSubview:_blankState];
    }
    else {
        self.tableView.scrollEnabled = YES;
        [_blankState removeFromSuperview];
    }
}

- (void) showSearch {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Search" message:nil delegate:self cancelButtonTitle:@"Search" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

# pragma mark - Basic TableView Stuff

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCellIdentifier1" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"tableCellIdentifier1"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PMPhotoMetadata *photoMetadata = [_photos objectAtIndex:indexPath.row];
    PHAsset *asset = [PMPhotosMetadataManager getAssetForMetadata:photoMetadata];
    cell.textLabel.text = photoMetadata.title;
    cell.detailTextLabel.text = @"Details";
    
//    NSInteger retinaMultiplier = [UIScreen mainScreen].scale;
//    CGSize retinaSquare = CGSizeMake(cell.imageView.bounds.size.width * retinaMultiplier, cell.imageView.bounds.size.height * retinaMultiplier);
    cell.imageView.contentMode=UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds=YES;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    // No, really, we want this exact size
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    [[PHImageManager defaultManager]
     requestImageForAsset:asset
     targetSize:CGSizeMake(120, 120)
     contentMode:PHImageContentModeAspectFit
     options:options
     resultHandler:^(UIImage *result, NSDictionary *info) {
         [cell.imageView setImage:result];
         [cell setNeedsLayout];
     }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    PMPhotoMetadata *photoMetadata = [_photos objectAtIndex:indexPath.row];
    PHAsset *asset = [PMPhotosMetadataManager getAssetForMetadata:photoMetadata];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        UIImageView* ivExpand = [[UIImageView alloc] initWithImage: result];
        ivExpand.contentMode = cell.imageView.contentMode;
        ivExpand.frame = [self.tableView convertRect: cell.imageView.frame fromView: cell.imageView.superview];
        ivExpand.userInteractionEnabled = YES;
        ivExpand.clipsToBounds = YES;
        
        IDMPhoto *idmPhoto = [IDMPhoto photoWithImage:result];
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:@[idmPhoto] animatedFromView:cell.imageView];
        browser.delegate = self;
        browser.usePopAnimation = YES;
        browser.scaleImage = cell.imageView.image;
        browser.forceHideStatusBar = YES;
        browser.modalPresentationCapturesStatusBarAppearance = YES;

        [self presentViewController:browser animated:YES completion:nil];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

#pragma mark - IDMPhotoBrowser Delegate

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)pageIndex
{
//    id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
//    NSLog(@"Did show photoBrowser with photo index: %lu, photo caption: %@", (unsigned long)pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)pageIndex
{
//    id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
//    NSLog(@"Did dismiss photoBrowser with photo index: %lu, photo caption: %@", (unsigned long)pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex
{
//    id <IDMPhoto> photo = [photoBrowser photoAtIndex:photoIndex];
//    NSLog(@"Did dismiss actionSheet with photo index: %lu, photo caption: %@", (unsigned long)photoIndex, photo.caption);
}

# pragma mark - Edit Actions

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *titleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Set Title" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Set Title" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set", nil];
        _lastTitleIndexPath = indexPath;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }];
    titleAction.backgroundColor = [UIColor greenColor];
    
    UITableViewRowAction *favoriteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Favorite" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        _lastTitleIndexPath = indexPath;
        PMPhotoMetadata *photoMetadata = [_photos objectAtIndex:indexPath.row];
        [photoMetadata setIsFavorite:YES];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Added to Favorites" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }];
    favoriteAction.backgroundColor = [UIColor blueColor];
    
    PMPhotoMetadata *photoMetadata = [_photos objectAtIndex:indexPath.row];
    if (photoMetadata.favorite) {
        return @[titleAction];
    }
    return @[titleAction, favoriteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // No statement or algorithm is needed in here. Just the implementation.
}

# pragma mark - Add Title

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([@"Set Title" isEqualToString:alertView.title] && buttonIndex == 1) {
        _lastTitleInput = [[alertView textFieldAtIndex:0] text];
        PMPhotoMetadata *photoMetadata = [_photos objectAtIndex:_lastTitleIndexPath.row];
        [photoMetadata setTitle:_lastTitleInput];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_lastTitleIndexPath];
        cell.textLabel.text = _lastTitleInput;
    }
    else if ([@"Search" isEqualToString:alertView.title]) {
        _searchQuery = [[alertView textFieldAtIndex:0] text];
        [self refreshData];
    }
    else {
        [self.tableView reloadRowsAtIndexPaths:@[_lastTitleIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

# pragma mark - Bullshit iOS Stuff I don't need

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
