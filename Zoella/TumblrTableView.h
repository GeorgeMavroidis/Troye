//
//  YoutubeTableView.h
//  Zoella
//
//  Created by George on 2014-09-28.
//  Copyright (c) 2014 GM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TumblrTableView : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *main_tableView;
-(void)fetchFeeds;
-(void)loadFeedFor:(NSString *)user;
@property (nonatomic, strong) NSString *user;

@property (nonatomic, strong) NSString *loaded;
@end
