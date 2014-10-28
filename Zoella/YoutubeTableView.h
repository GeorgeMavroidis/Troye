//
//  YoutubeTableView.h
//  Zoella
//
//  Created by George on 2014-09-28.
//  Copyright (c) 2014 GM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoutubeTableView : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) NSString *playlist;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) UITableView *main_tableView;
-(void)fetchFeeds;
-(void)fetchFeedsFor:(NSString *)page;
-(void)loadFeedFor:(NSString *)page;
@end
