//
//  ViewController.m
//  PhotographicMemory
//
//  Created by Chris Moghbel on 1/19/15.
//  Copyright (c) 2015 Chris Moghbel. All rights reserved.
//

#import "ViewController.h"
#import "PMPhotoMetadata.h"
#import "PMPhotosTableViewController.h"
#import "PMFavoritePhotosTableViewController.h"
#import "PMRecentPhotosTableViewController.h"
#import "PMNUXViewController.h"
#import "PMConstants.h"
#import <objc/runtime.h>
#import <DropboxSDK/DropboxSDK.h>
@import Photos;

@interface ViewController ()

@end

BOOL kForceNUXOn = NO;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    PMRecentPhotosTableViewController *recentTableViewController = [[PMRecentPhotosTableViewController alloc] init];
//    recentTableViewController.title = @"Recents";
    PMFavoritePhotosTableViewController *favoritesTableViewController = [[PMFavoritePhotosTableViewController alloc] init];
    favoritesTableViewController.title = @"Favorites";
    UINavigationController *favoritesNavController = [[UINavigationController alloc] initWithRootViewController:favoritesTableViewController];
    favoritesNavController.tabBarItem.image = [UIImage imageNamed:@"star60.png"];
    PMPhotosTableViewController *allTableViewController = [[PMPhotosTableViewController alloc] init];
    allTableViewController.title = @"All";
    UINavigationController *allNavController = [[UINavigationController alloc] initWithRootViewController:allTableViewController];
    UITabBarItem *allTabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0];
    allNavController.tabBarItem = allTabBarItem;
    
    [self setViewControllers:@[favoritesNavController, allNavController]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    // NUX Stuff
    
    BOOL hasCompletedNUX = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasCompletedNUX"];
    
    if (!hasCompletedNUX || kForceNUXOn) {
        
        // TODO: May need to change this later if we have more page view controllers.
        UIPageControl *pageControl = [UIPageControl appearance];
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        pageControl.backgroundColor = [UIColor whiteColor];
        
        UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        pageViewController.dataSource = self;
        [[pageViewController view] setFrame:[[self view] bounds]];
        pageViewController.view.backgroundColor = [UIColor whiteColor];
    
        PMNUXViewController *initialViewController = [self viewControllerAtIndex:0];
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
        [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
        [self presentViewController:pageViewController animated:YES completion:nil];
    }
    
    // Set these variables before launching the app
//    NSString* appKey = @"66k3zhiaftuql71";
//    NSString* appSecret = @"ctes8nvfjvl3g0w";
//    NSString *root = kDBRootDropbox; // Should be set to either kDBRootAppFolder or kDBRootDropbox
//    // You can determine if you have App folder access or Full Dropbox along with your consumer key/secret
    // from https://dropbox.com/developers/apps
    
    // Look below where the DBSession is created to understand how to use DBSession in your app
    
//    NSString* errorMsg = nil;
//    if ([kDropBoxAppKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
//        errorMsg = @"Make sure you set the app key correctly";
//    } else if ([kDropboxAppSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
//        errorMsg = @"Make sure you set the app secret correctly";
//    } else {
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
//        NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
//        NSDictionary *loadedPlist =
//        [NSPropertyListSerialization
//         propertyListFromData:plistData mutabilityOption:0 format:NULL errorDescription:NULL];
//        NSString *scheme = [[[[loadedPlist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
//        if ([scheme isEqual:@"db-APP_KEY"]) {
//            errorMsg = @"Set your URL scheme correctly in PhotographicMemory-Info.plist";
//        }
//    }
    
//    DBSession* session =
//    [[DBSession alloc] initWithAppKey:kDropBoxAppKey appSecret:kDropboxAppSecret root:kDBRootDropbox];
//    session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
//    [DBSession setSharedSession:session];
//    
//    [DBRequest setNetworkRequestDelegate:self];
//    
//    if (errorMsg != nil) {
//        [[[UIAlertView alloc]
//          initWithTitle:@"Error Configuring Session" message:errorMsg
//          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
//         show];
//    }
    
    if ([[DBSession sharedSession] isLinked]) {
        // Do something here?
        NSLog(@"[ViewController] DROPBOX: Session already linked!");
    }
    else {
        NSLog(@"[ViewController] DROPBOX: Session not yet linked - linking now!");
        [[DBSession sharedSession] linkFromController:self];
        NSLog(@"[ViewController] DROPBOX: Session successfully linked?");
    }
}

- (PMNUXViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    PMNUXViewController *vc = [[PMNUXViewController alloc] init];
    vc.index = index;
    
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(PMNUXViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(PMNUXViewController *)viewController index];
    
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

# pragma mark - Bullshit iOS Stuff I don't need

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
