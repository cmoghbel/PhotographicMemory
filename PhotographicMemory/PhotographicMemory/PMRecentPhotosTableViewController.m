//
//  PMRecentPhotosTableViewController.m
//  PhotographicMemory
//
//  Created by Chris Moghbel on 2/12/15.
//  Copyright (c) 2015 Chris Moghbel. All rights reserved.
//

#import "PMRecentPhotosTableViewController.h"

@interface PMRecentPhotosTableViewController ()

@end

@implementation PMRecentPhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) refreshData
{
    _photos = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"recents"]];
    [self showBlankStateOrPhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
