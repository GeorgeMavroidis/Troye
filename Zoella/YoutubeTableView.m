//
//  YoutubeTableView.m
//  Zoella
//
//  Created by George on 2014-09-28.
//  Copyright (c) 2014 GM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YoutubeTableView.h"
#import "AsyncImageView.h"
#import "YoutubeCell.h"

#import "SDWebImage/UIImageView+WebCache.h"
//#import <UIImageView+WebCache.h>
#import "YTPlayerView.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface YoutubeTableView(){
    NSString *cellIdentifier;
    NSMutableArray *tableData;
    NSArray *json;
    NSMutableDictionary *json_dic;
    NSMutableArray *items;
    UIRefreshControl * refresh;
    NSString *nextPageToken;
    BOOL fetching;
    YTPlayerView *player;
    NSString *user;
    
}
@end

@implementation YoutubeTableView
@synthesize playlist, main_tableView, username;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    user = USER;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    cellIdentifier = @"cellIdentifier";
    json = [[NSArray alloc] init];
    json_dic = [[NSMutableDictionary alloc] init];
    items = [[NSMutableArray alloc] init];
    main_tableView = [[UITableView alloc] init];
//    main_tableView.backgroundColor =[UIColor colorWithRed: 210/255.0 green: 210/255.0 blue:210/255.0 alpha: 0.4];
    main_tableView.delegate = self;
    main_tableView.dataSource = self;
    
    self.view = main_tableView;
    main_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [main_tableView registerClass:[YoutubeCell class] forCellReuseIdentifier:cellIdentifier];
    main_tableView.showsVerticalScrollIndicator = NO;
    
    nextPageToken = @"none";
    fetching = NO;
    
    
   
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    
    if([d objectForKey:[NSString stringWithFormat:@"playlist-%@", username]] != nil){
        playlist = [d objectForKey:[NSString stringWithFormat:@"playlist-%@", username]];
        
        if([d objectForKey:playlist] == nil){
            [self fetchFeeds];
        }else{
            playlist = [d objectForKey:@"playlist"];
            [self loadFeedFor:playlist];
        }
    }else{
        
        [self fetchFeeds];
    }
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [main_tableView addSubview:refresh];
    
    
}
-(void)handleRefresh:(id)sender{
    [refresh beginRefreshing];
    [self fetchFeeds];
    [main_tableView reloadData];
    [refresh endRefreshing];
}


-(void)fetchFeeds{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    
//    NSString *posts_url = [NSString stringWithFormat:@"http://thewotimes.com/Y/current.php?user=%@&type=youtube&get=true", user];
    NSString *posts_url_p = [NSString stringWithFormat:@"http://www.thewotimes.com/Y/dig.php?user=%@&dig=playlist&type=youtube&username=%@", user,username];
    NSURL *url_p = [NSURL URLWithString:posts_url_p];
    NSError* error_p;
    //    NSLog(posts_url);
    playlist = [NSString stringWithContentsOfURL:url_p usedEncoding:nil error:&error_p];
    
    
    
    NSString *posts_url = [NSString stringWithFormat:@"http://thewotimes.com/Y/current.php?user=%@&type=youtube&get=true", user];
    NSURL *url = [NSURL URLWithString:posts_url];
    NSError* error;
    //    NSLog(posts_url);
    NSString *t = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    NSData *tdata = [t dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *both =[NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];
//    json_dic= [NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];

    for(NSDictionary *playlist_dict in both){
        NSString *p =[[[[playlist_dict objectForKey:@"items"] objectAtIndex:0] objectForKey:@"snippet"] valueForKey:@"playlistId"];
        if([p isEqualToString:playlist]){
            json_dic = playlist_dict;
        }
    }
    
//    json_dic= [NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];
    nextPageToken = [json_dic objectForKey:@"nextPageToken"];
    items = [json_dic objectForKey:@"items"];
    
    
    [d setObject:items forKey:playlist];
    [d setObject:nextPageToken forKey:[NSString stringWithFormat:@"next-%@", playlist]];
    [d setObject:playlist  forKey:[NSString stringWithFormat:@"playlist-%@", username]];
    
    [main_tableView reloadData];
    [main_tableView setNeedsDisplay];
}

-(void)ajaxFeeds{
    
    fetching = YES;
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    if(nextPageToken == nil){
        nextPageToken = [d objectForKey:[NSString stringWithFormat:@"next-%@", playlist]];
    }
    NSString *posts_url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=10&playlistId=%@&key=AIzaSyDHOIJeg4dXJIBs2pu9aco3zF42ilgosxs&pageToken=%@", playlist, nextPageToken];
    
    NSURL *url = [NSURL URLWithString:posts_url];
    NSError* error;
    NSString *t = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    NSData *tdata = [t dataUsingEncoding:NSUTF8StringEncoding];
    if(tdata != nil){
        json_dic = [NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];
        nextPageToken = [json_dic objectForKey:@"nextPageToken"];
        NSArray *temp =[json_dic objectForKey:@"items"];
        NSMutableArray *localList = [[NSMutableArray alloc] init];
        [localList addObjectsFromArray:items];
        [localList addObjectsFromArray:temp];
        items = localList;
    }
    
}
-(void)loadFeedFor:(NSString *)page{
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    playlist = [d objectForKey:[NSString stringWithFormat:@"playlist-%@", username]];

    
    items = [d objectForKey:playlist];
    nextPageToken = [d objectForKey:[NSString stringWithFormat:@"next-%@", playlist]];
    
    [main_tableView reloadData];
    [main_tableView setNeedsDisplay];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *playerVars = @{@"playsinline" : @1,};
    [player setHidden:NO];
    NSString *yid = [[[[items objectAtIndex:indexPath.row] objectForKey:@"snippet"] objectForKey:@"resourceId"] objectForKey:@"videoId"];
    
    MainViewController *myRootViewController = (MainViewController *)[self.navigationController.viewControllers objectAtIndex: 0];
    [myRootViewController changePlayer:yid];
    
//    [player loadWithVideoId:yid];
//    [player playVideo];
    
//    [player cueVideoById:yid startSeconds:0 suggestedQuality:]
//    [temp.thumbnail setHidden:YES];
//    [self.view addSubview:t];

}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [items count];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"here");
    
//    static CGFloat previousOffset;
//    CGRect rect = self.view.frame;
//    rect.origin.y += previousOffset - scrollView.contentOffset.y;
//    previousOffset = scrollView.contentOffset.y;
//    self.view.frame = rect;
//    
//    NSLog(@"%f", previousOffset);

    if ([scrollView.panGestureRecognizer translationInView:self.view].y > 0) {
        
        
        if(scrollView.contentOffset.y < 40){
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
                CGRect frame = scrollView.frame;
                frame.origin.y = 100;
                scrollView.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
        }
        
        
    } else {
        //        NSLog(@"up");
        if(scrollView.contentOffset.y > 40){
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
                CGRect frame = scrollView.frame;
                frame.origin.y = 0;
                scrollView.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
            //        NSLog(@"%f", previousOffset);
        }
    }
    
    if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)-500) {
        if(!fetching){
            NSLog(@"bottom!");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self ajaxFeeds];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [main_tableView reloadData];
                    [main_tableView setNeedsDisplay];
                    fetching = NO;
                });
            });
        }
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    double aspectRatio = 16.00/9.00;
    double aspectW = screenWidth-20;
    double aspectH = aspectW / aspectRatio;
    
    return aspectH + 10 +50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView registerClass:[YoutubeCell class] forCellReuseIdentifier:cellIdentifier];
    
    YoutubeCell *cell = (YoutubeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[YoutubeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    NSDictionary *thumbnail_array = [[[items objectAtIndex:indexPath.row] objectForKey:@"snippet"] objectForKey:@"thumbnails"];
    
    //    cell.thumbnail.imageURL = [NSURL URLWithString:[[thumbnail_array objectForKey:@"maxres"] objectForKey:@"url"]];
    [cell.thumbnail setImageWithURL:[NSURL URLWithString:[[thumbnail_array objectForKey:@"standard"] objectForKey:@"url"]]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//    NSLog(@"%@", [items objectAtIndex:indexPath.row]);
    cell.title.text = [[[items objectAtIndex:indexPath.row] objectForKey:@"snippet"] objectForKey:@"title"];
    //    cell = [self createCustomCellFromData:indexPath];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

