//
//  MainViewController.h
//  Zoella
//
//  Created by George on 2014-09-27.
//  Copyright (c) 2014 GM. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "YTPlayerView.h"
#import "GAITrackedViewController.h"

@interface MainViewController : GAITrackedViewController <UIImagePickerControllerDelegate, UIScrollViewDelegate, YTPlayerViewDelegate>

-(void)changePlayer:(NSString *)videoID;
-(void)fetchAllFeeds;
-(void)updateTableViews;
@end
