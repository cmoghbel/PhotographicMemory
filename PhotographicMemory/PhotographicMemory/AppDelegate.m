//
//  AppDelegate.m
//  PhotographicMemory
//
//  Created by Chris Moghbel on 1/19/15.
//  Copyright (c) 2015 Chris Moghbel. All rights reserved.
//

#import "AppDelegate.h"
#import "PMPhotoMetadata.h"
#import "PMHelpers.h"
#import "PMConstants.h"
#import <DropboxSDK/DropboxSDK.h>
@import Photos;
@import CoreLocation;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)loadData {
    [PMHelpers loadNewPictures];
//    NSLog(@"Loading data!");
//    PHFetchOptions *fetchOptions = [PHFetchOptions new];
//    fetchOptions.sortDescriptors = @[
//                                     [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES],
//                                     ];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSArray *photosImmutable = [defaults objectForKey:@"photos"];
//    NSMutableArray *photos;
//    if (photosImmutable == nil) {
//        photos = [NSMutableArray arrayWithObjects:nil];
//    }
//    else {
//        photos = [NSMutableArray arrayWithArray:photosImmutable];
//    }
//    
//    NSArray *photosToIgnoreImmutable = [defaults objectForKey:@"photosToIgnore"];
//    NSMutableArray *photosToIgnore;
//    if (photosToIgnoreImmutable == nil) {
//        photosToIgnore = [NSMutableArray arrayWithObjects:nil];
//    }
//    else {
//        photosToIgnore = [NSMutableArray arrayWithArray:photosToIgnoreImmutable];
//    }
//    
//    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
//    [allPhotosResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
//        if (![photos containsObject:asset.localIdentifier] && ![photosToIgnore containsObject:asset.localIdentifier]) {
//            if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoHDR) {
//                NSLog(@"Adding new metadata object for HDR photo: %@", asset.localIdentifier);
//                [photos insertObject:asset.localIdentifier atIndex:0];
//                PMPhotoMetadata *photoMetadata = [[PMPhotoMetadata alloc] initWithKey:asset.localIdentifier];
//                [photoMetadata save];
//            }
//            else {
//                PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
//                imageOptions.synchronous = YES;
//                imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
//                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:imageOptions resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
//                    if ([@"public.png" isEqualToString:dataUTI]) {
//                        NSLog(@"Adding new metadata object for screenshot: %@", asset.localIdentifier);
//                        [photos insertObject:asset.localIdentifier atIndex:0];
//                        PMPhotoMetadata *photoMetadata = [[PMPhotoMetadata alloc] initWithKey:asset.localIdentifier];
//                        [photoMetadata save];
//                    }
//                    else {
//                        NSLog(@"Adding photo to ignore list: %@", asset.localIdentifier);
//                        [photosToIgnore addObject:asset.localIdentifier];
//                    }
//                }];
//            }
//        }
//    }];
//    
//    [defaults setObject:photosToIgnore forKey:@"photosToIgnore"];
//    [defaults setObject:photos forKey:@"photos"];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"PMDataLoaded" object:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString* errorMsg = nil;
    if ([kDropBoxAppKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
        errorMsg = @"Make sure you set the app key correctly";
    } else if ([kDropboxAppSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
        errorMsg = @"Make sure you set the app secret correctly";
    } else {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
        NSDictionary *loadedPlist =
        [NSPropertyListSerialization
         propertyListFromData:plistData mutabilityOption:0 format:NULL errorDescription:NULL];
        NSString *scheme = [[[[loadedPlist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
        if ([scheme isEqual:@"db-APP_KEY"]) {
            errorMsg = @"Set your URL scheme correctly in PhotographicMemory-Info.plist";
        }
    }
    
    DBSession* session =
    [[DBSession alloc] initWithAppKey:kDropBoxAppKey appSecret:kDropboxAppSecret root:kDBRootDropbox];
    session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
    [DBSession setSharedSession:session];
    
    [DBRequest setNetworkRequestDelegate:self];
    
    if (errorMsg != nil) {
        [[[UIAlertView alloc]
          initWithTitle:@"Error Configuring Session" message:errorMsg
          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
         show];
    }

    
    [self loadData];
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
                                                      object:nil
                                                       queue:mainQueue
                                                  usingBlock:^(NSNotification *note) {
                                                      // executes after screenshot
                                                      NSLog(@"Screenshot taken!");
                                                      sleep(1);
                                                      [self loadData];
                                                  }];
    
//    PHFetchOptions *fetchOptions = [PHFetchOptions new];
////    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"(mediaSubtype & %d) != 0", PHAssetMediaSubtypePhotoHDR];
//    fetchOptions.sortDescriptors = @[
//        [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES],
//    ];
////    PHFetchResult *hdrPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSArray *photosImmutable = [defaults objectForKey:@"photos"];
//    NSMutableArray *photos;
//    if (photosImmutable == nil) {
//        photos = [NSMutableArray arrayWithObjects:nil];
//    }
//    else {
//        photos = [NSMutableArray arrayWithArray:photosImmutable];
//    }
//    
////    [hdrPhotosResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
//////        NSLog(@"hdr asset %@", asset.localIdentifier);
////        NSUInteger height = [asset pixelHeight];
////        NSUInteger width = [asset pixelWidth];
//////        NSLog(@"Creation date: %@", asset.creationDate.description);
////        if (![photos containsObject:asset.localIdentifier]) {
////            NSLog(@"Adding new metadata object for HDR photo: %@", asset.localIdentifier);
////            [photos addObject:asset.localIdentifier];
////            PMPhotoMetadata *photoMetadata = [[PMPhotoMetadata alloc] initWithKey:asset.localIdentifier];
////            [photoMetadata save];
////        }
////    }];
//    
//    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
//    [allPhotosResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
//        if (![photos containsObject:asset.localIdentifier]) {
//            if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoHDR) {
//                NSLog(@"Adding new metadata object for HDR photo: %@", asset.localIdentifier);
////                [photos addObject:asset.localIdentifier];
//                [photos insertObject:asset.localIdentifier atIndex:0];
//                PMPhotoMetadata *photoMetadata = [[PMPhotoMetadata alloc] initWithKey:asset.localIdentifier];
//                [photoMetadata save];
//            }
//            else {
//                PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
//                imageOptions.synchronous = YES;
//                imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
//                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:imageOptions resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
//                    if ([@"public.png" isEqualToString:dataUTI]) {
//                        NSLog(@"Adding new metadata object for screenshot:%@", asset.localIdentifier);
////                        [photos addObject:asset.localIdentifier];
//                        [photos insertObject:asset.localIdentifier atIndex:0];
//                        PMPhotoMetadata *photoMetadata = [[PMPhotoMetadata alloc] initWithKey:asset.localIdentifier];
//                        [photoMetadata save];
//                    }
//                }];
//            }
//        }
//    }];
//    
//    [defaults setObject:photos forKey:@"photos"];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self loadData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cmoghbel.PhotographicMemory" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PhotographicMemory" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PhotographicMemory.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Dropbox

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

@end
