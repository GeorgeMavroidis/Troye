//
//  YoutubeTableView.h
//  Zoella
//
//  Created by George on 2014-09-28.
//  Copyright (c) 2014 GM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterTableView : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *main_tableView;
-(void)fetchFeeds;
-(void)fetchFeedsFor:(NSString *)page;
-(void)loadFeedFor:(NSString *)page;

@property (nonatomic, strong) NSString *user;
@end
