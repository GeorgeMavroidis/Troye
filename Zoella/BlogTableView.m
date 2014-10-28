//
//  YoutubeTableView.m
//  Zoella
//
//  Created by George on 2014-09-28.
//  Copyright (c) 2014 GM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BlogTableView.h"
#import "AsyncImageView.h"
//
#import "SDWebImage/UIImageView+WebCache.h"
#import "BlogCell.h"
#import "CreationFunctions.h"

@interface BlogTableView(){
    NSString *cellIdentifier;
    NSMutableArray *tableData;
    NSArray *json;
    NSMutableDictionary *json_dic;
    NSMutableArray *items;
    UIRefreshControl * refresh;
    NSString *nextPageToken;
    BOOL fetching;
    NSMutableDictionary *height;
    
}
@end

@implementation BlogTableView
@synthesize main_tableView, user;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
//    [self fetchFeeds];
    if([d objectForKey:user] == nil){
        [self fetchFeeds];
    }else{
        [self loadFeedFor:user];
    }
    
    height = [[NSMutableDictionary alloc] init];
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
    
    NSString *posts_url = [NSString stringWithFormat:@"http://thewotimes.com/Y/current.php?user=%@&type=blog&get=true", user];
    NSURL *url = [NSURL URLWithString:posts_url];
    NSError* error;
    NSString *t = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    NSData *tdata = [t dataUsingEncoding:NSUTF8StringEncoding];
    json_dic= [NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];
//    nextPageToken = [[[items objectAtIndex:[items count]-1] objectForKey:@"entry"] objectForKey:@"id"];
//    NSLog(@"%@", json_dic);
    items = [json_dic objectForKey:@"items"];
    
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setObject:items forKey:@"blog"];
//    [d setObject:nextPageToken forKey:[NSString stringWithFormat:@"next-%@", user]];
    
    [main_tableView reloadData];
    [main_tableView setNeedsDisplay];
}
-(void)ajaxFeeds{
    
    fetching = YES;
    NSString *posts_url = [NSString stringWithFormat:@"http://thewotimes.com/Y/user.php?user=%@&type=instagram&next=%@",  user, nextPageToken];
    NSURL *url = [NSURL URLWithString:posts_url];
    NSError* error;
    NSString *t = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    NSData *tdata = [t dataUsingEncoding:NSUTF8StringEncoding];
//    json_dic = [NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];
    
    NSArray *temp =  [NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];
    NSMutableArray *localList = [[NSMutableArray alloc] init];
    [localList addObjectsFromArray:items];
    [localList addObjectsFromArray:temp];
    items = localList;
    
    nextPageToken = [[[items objectAtIndex:[items count]-1] objectForKey:@"entry"] objectForKey:@"id"];

}
-(void)loadFeedFor:(NSString *)page{
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    items = [d objectForKey:@"blog"];
//    nextPageToken = [d objectForKey:[NSString stringWithFormat:@"next-%@", user]];
//    NSLog(@"%@", items);
    
    [main_tableView reloadData];
    [main_tableView setNeedsDisplay];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    return [items count];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
    
    
    if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
        if(!fetching){
            NSLog(@"bottom!");
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                [self ajaxFeeds];
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [main_tableView reloadData];
//                    [main_tableView setNeedsDisplay];
//                    fetching = NO;
//                });
//            });
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

    return screenHeight;
    NSString *t = [height objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    CGFloat a = [t floatValue];
    return a;
//
//    NSLog(cell.getHeight);
//
//    [CreationFunctions tableView:tableView heightForBlog:indexPath singleton:items];
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    int heightr = [result integerValue];
    NSLog(@"%d", heightr);

//    //    NSLog(@"height: %@", output);
//    BlogCell *test = [((BlogCell *) webView) superview];
//    test.getHeight = [NSString stringWithFormat:@"%d", heightr];
//    
//    [height setObject:test.getHeight forKey:[NSString stringWithFormat:@"%d",test.tag]];
//    
//    
//    CGRect frame = webView.frame;
//    
//    frame.size.height = heightr;
//    webView.frame = frame;
//    
//    [main_tableView beginUpdates];
//    [main_tableView endUpdates];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView registerClass:[YoutubeCell class] forCellReuseIdentifier:cellIdentifier];
    
    BlogCell *cell = (BlogCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[BlogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell = [CreationFunctions createBlogCell:tableView cellForRowAtIndexPath:indexPath singleton:items];
    cell.tag = indexPath.row;
    cell.webview.delegate = self;
    [height setObject:cell.getHeight forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    NSLog(cell.getHeight);
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

