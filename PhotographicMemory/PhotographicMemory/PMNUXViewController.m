//
//  PMNUXViewController2.m
//  PhotographicMemory
//
//  Created by Chris Moghbel on 3/5/15.
//  Copyright (c) 2015 Chris Moghbel. All rights reserved.
//

#import "PMNUXViewController.h"

@interface PMNUXViewController ()

@end

int kSpaceBetweenLines = 10;

@implementation PMNUXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.index == 0) {
        self.view.backgroundColor = [UIColor whiteColor];
        CGSize totalSize = self.view.frame.size;
        
        // Construct Views
        UILabel *firstLine = [[UILabel alloc] init];
        firstLine.text = @"Photographic Memory";
        firstLine.textColor = [UIColor blackColor];
        firstLine.font = [UIFont fontWithName:@"HelveticaNeue" size:36.0];
        [firstLine sizeToFit];
        CGSize firstLineSize = firstLine.frame.size;
        
        UILabel *secondLine = [[UILabel alloc] init];
        secondLine.text = @"Never forget anything again.";
        secondLine.textColor = [UIColor blackColor];
        [secondLine sizeToFit];
        CGSize secondLineSize = secondLine.frame.size;
        
        UIImage *icon = [UIImage imageNamed:@"camera200.png"];
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:icon];
        CGSize imageSize = iconImageView.frame.size;
        
        // Layout Views
        int totalHeight = firstLineSize.height + secondLineSize.height + imageSize.height;
        int currentY = (totalSize.height / 2) - (totalHeight / 2);
        
        iconImageView.frame = CGRectMake((totalSize.width - imageSize.width) / 2, currentY, imageSize.width, imageSize.height);
        [self.view addSubview:iconImageView];
        currentY += imageSize.height;
        
        firstLine.frame = CGRectMake((totalSize.width - firstLineSize.width) / 2, currentY, firstLineSize.width, firstLineSize.height);
        [self.view addSubview:firstLine];
        currentY += firstLineSize.height;
        
        secondLine.frame = CGRectMake((totalSize.width - secondLineSize.width) / 2, currentY, secondLineSize.width, secondLineSize.height);
        [self.view addSubview:secondLine];
        currentY += secondLineSize.height;
        
        
    }
    else {
        self.view.backgroundColor = [UIColor whiteColor];
        CGSize totalSize = self.view.frame.size;
        
        NSString *firstLineString = @"Take a photo with HDR On to save it.";
        NSString *secondLineString = @"Screenshots will show up here as well.";
        NSString *thidLineString = @"Share information with your friends.";
        
        UIImage *firstIcon = [UIImage imageNamed:@"camera200.png"];
        UIImage *secondIcon = [UIImage imageNamed:@"screenshot200.png"];
        UIImage *thirdIcon = [UIImage imageNamed:@"share200.png"];
        
        if (self.index == 2) {
            firstLineString = @"Add a description to search for photos later.";
            secondLineString = @"Favorite extra important photos.";
            
            firstIcon = [UIImage imageNamed:@"search200.png"];
            secondIcon = [UIImage imageNamed:@"star200.png"];
        }
        
        // First Third
        
        // Construct Views
        UIImageView *firstImageView = [[UIImageView alloc] initWithImage:firstIcon];
        CGSize firstImageSize = firstImageView.frame.size;
        
        UILabel *firstLine = [[UILabel alloc] init];
        firstLine.text = firstLineString;
        firstLine.textColor = [UIColor blackColor];
        [firstLine sizeToFit];
        CGSize firstLineSize= firstLine.frame.size;
        
        // Layout Views
        int totalHeight = firstImageSize.height + firstLineSize.height;
        int currentY = (totalSize.height / 6) - (totalHeight / 2);
        
        firstImageView.frame = CGRectMake((totalSize.width - firstImageSize.width) / 2, currentY, firstImageSize.width, firstImageSize.height);
        [self.view addSubview:firstImageView];
        currentY += firstImageSize.height;
        
        firstLine.frame = CGRectMake((totalSize.width - firstLineSize.width) / 2, currentY, firstLineSize.width, firstLineSize.height);
        [self.view addSubview:firstLine];
        
        // Second Third
        
        // Constuct Views
        UIImageView *secondImageView = [[UIImageView alloc] initWithImage:secondIcon];
        CGSize secondImageSize = secondImageView.frame.size;
        
        UILabel *secondLine = [[UILabel alloc] init];
        secondLine.text = secondLineString;
        secondLine.textColor = [UIColor blackColor];
        [secondLine sizeToFit];
        CGSize secondLineSize = secondLine.frame.size;
        
        // Layout Views
        totalHeight = secondImageSize.height + secondLineSize.height;
        currentY = 3 * (totalSize.height / 6) - (totalHeight / 2);
        
        secondImageView.frame = CGRectMake((totalSize.width - secondImageSize.width) / 2, currentY, secondImageSize.width, secondImageSize.height);
        [self.view addSubview:secondImageView];
        currentY += secondImageSize.height;
        
        secondLine.frame = CGRectMake((totalSize.width - secondLineSize.width) / 2, currentY, secondLineSize.width, secondLineSize.height);
        [self.view addSubview:secondLine];
        
        // Third third
        if (self.index == 2) {
        
            UIButton *gotItButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [gotItButton setTitle:@"Got It!" forState:UIControlStateNormal];
            [gotItButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:36]];
            [gotItButton addTarget:self action:@selector(dismissNux) forControlEvents:UIControlEventTouchUpInside];
            [gotItButton sizeToFit];
            [gotItButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            CGSize buttonSize = gotItButton.frame.size;
            gotItButton.layer.cornerRadius = 10;//half of the width
            gotItButton.layer.borderColor = [UIColor blackColor].CGColor;
            gotItButton.layer.borderWidth = 3.0f;
        
            totalHeight = buttonSize.height;
            int totalWidth = buttonSize.width + 20 + 10;
            currentY = 5 * (totalSize.height / 6) - (totalHeight / 2);
        
            gotItButton.frame = CGRectMake((totalSize.width - totalWidth) / 2, currentY, buttonSize.width + 20, buttonSize.height + 10);
            [self.view addSubview:gotItButton];
        }
        else {
            
            // Constuct Views
            UIImageView *favoriteImageView = [[UIImageView alloc] initWithImage:thirdIcon];
            CGSize thirdImageSize = favoriteImageView.frame.size;
            
            UILabel *thirdLine = [[UILabel alloc] init];
            thirdLine.text = thidLineString;
            thirdLine.textColor = [UIColor blackColor];
            [thirdLine sizeToFit];
            CGSize thirdLineSize = thirdLine.frame.size;
            
            // Layout Views
            totalHeight = thirdImageSize.height + thirdLineSize.height;
            currentY = 5 * (totalSize.height / 6) - (totalHeight / 2);
            
            favoriteImageView.frame = CGRectMake((totalSize.width - thirdImageSize.width) / 2, currentY, thirdImageSize.width, thirdImageSize.height);
            [self.view addSubview:favoriteImageView];
            currentY += thirdImageSize.height;
            
            thirdLine.frame = CGRectMake((totalSize.width - thirdLineSize.width) / 2, currentY, thirdLineSize.width, thirdLineSize.height);
            [self.view addSubview:thirdLine];
        }
    }
}

- (void) dismissNux {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasCompletedNUX"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
