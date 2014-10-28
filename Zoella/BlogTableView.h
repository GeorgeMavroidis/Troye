//
//  YoutubeTableView.h
//  Zoella
//
//  Created by George on 2014-09-28.
//  Copyright (c) 2014 GM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlogCell.h"


@interface BlogTableView : UIViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>


@property (nonatomic, strong) UITableView *main_tableView;
-(void)fetchFeeds;
-(void)fetchFeedsFor:(NSString *)page;
-(void)loadFeedFor:(NSString *)page;

@property (nonatomic, strong) NSString *user;
- (BlogCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
