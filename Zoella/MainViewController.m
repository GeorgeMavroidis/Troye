//
//  MainViewController.m
//  Zoella
//
//  Created by George on 2014-09-27.
//  Copyright (c) 2014 GM. All rights reserved.
//

#import "MainViewController.h"
#import "YTPlayerView.h"
#import "YoutubeTableView.h"
#import "UIImageView+WebCache.h"
#import "TwitterTableView.h"
#import "CreationFunctions.h"
#import "InstagramTableView.h"
#import "TumblrTableView.h"
#import "BlogTableView.h"
#import "AsyncImageView.h"
#import "MusicView.h"
#import "Constants.h"

@interface MainViewController (){
    NSString *user;
    CGRect screenRect;
    UIScrollView *multiple;
    UIImageView *header, *profile, *secondP, *thirdP, *fourthP, *fifthP, *sixthP;
    UIImageView   *header2, *header3, *header4, *header5;
    UIPanGestureRecognizer *tableViewPan, *playerPan;
    YTPlayerView *player;
    YoutubeTableView *main, *second;
    UIScrollView *profileScrollView;
    TwitterTableView *third;
    InstagramTableView *fourth;
    TumblrTableView *fifth;
    MusicView *sixth;
    NSDictionary *user_dict;
    NSArray *y;
    UITapGestureRecognizer *playerPanTap;
    UIView *expand;
    double aspectH;
}
@end

@implementation MainViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [self.navigationController setToolbarHidden:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    
    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:item1, flexiableItem, item2, nil];
    self.toolbarItems = items;
    
    self.screenName = [NSString stringWithFormat:@"Main Screen For %@", USER ];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    }

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = multiple.frame.size.width;
    screenRect = self.view.bounds;
    int page = floor((multiple.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSURL *url;    NSError *error;
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    user = USER;
    
    screenRect = self.view.bounds;
    multiple = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    multiple.contentSize = CGSizeMake(screenRect.size.width*PAGES, screenRect.size.height);
    multiple.pagingEnabled = YES;
    multiple.bounces = NO;
    [multiple setBackgroundColor:[UIColor blackColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    multiple.delegate = self;
    [self.view addSubview:multiple];
    
    profileScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, screenRect.size.height- 50, screenRect.size.width, 50)];
    profileScrollView.contentSize = CGSizeMake(screenRect.size.width+50, 40);
    profileScrollView.showsHorizontalScrollIndicator = NO;
    [profileScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:profileScrollView];

    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    
    YTPlayerView *t = [[YTPlayerView alloc] initWithFrame:CGRectMake(0, 100, screenRect.size.width, 200)];
    //    [t loadWithVideoId:@"M7lc1UVf-VE"];
    //    [self.view addSubview:t];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    
    
    NSString *usernames_json = [NSString stringWithFormat:@"http://www.thewotimes.com/Y/fetch.php?user=%@", user];
    NSURL *url = [NSURL URLWithString:usernames_json];
    NSError *error;
    
    if([d objectForKey:@"user_dict"] == nil){
        
        NSString *tad = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
        NSData *tdata = [tad dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *json_usernames = [NSJSONSerialization JSONObjectWithData:tdata
                                                                  options:kNilOptions
                                                                    error:&error];
        user_dict = [json_usernames objectAtIndex:0];
        [d setObject:user_dict forKey:@"user_dict"];
    }else{
        user_dict = [d objectForKey:@"user_dict"];
    }
    
    [self drawToolbar];
    
    
    [self drawTwitterOnHeader];
    
    main = [[YoutubeTableView alloc] init];
    main.username = y[0];
    main.view.layer.cornerRadius = 10;
    [self addChildViewController:main];
    [multiple addSubview:main.view];
    main.view.frame = CGRectMake(0, 100, screenRect.size.width, screenRect.size.height-150+50+50+10);
    main.view.layer.cornerRadius = 10;
    
    second = [[YoutubeTableView alloc] init];
    second.username = y[1];
    [self addChildViewController:second];
    [multiple addSubview:second.view];
    second.view.frame = CGRectMake(screenRect.size.width, 100, screenRect.size.width, screenRect.size.height-150+50+50+10);
    second.view.layer.cornerRadius = 10;
    //
    third = [[TwitterTableView alloc] init];
    [self addChildViewController:third];
    third.user = user;
    [multiple addSubview:third.view];
    third.view.frame = CGRectMake(screenRect.size.width*2, 100, screenRect.size.width, screenRect.size.height-150+50+50+10);
    third.view.layer.cornerRadius = 10;
    //    //
    fourth = [[InstagramTableView alloc] init];
    [self addChildViewController:fourth];
    fourth.user = user;
    [multiple addSubview:fourth.view];
    fourth.view.frame = CGRectMake(screenRect.size.width*3, 100, screenRect.size.width, screenRect.size.height-150+50+50+10);
    fourth.view.layer.cornerRadius = 10;
    //    //
    fifth = [[TumblrTableView alloc] init];
    fifth.user = user;
    [self addChildViewController:fifth];
    [multiple addSubview:fifth.view];
    fifth.view.frame = CGRectMake(screenRect.size.width*4, 100, screenRect.size.width, screenRect.size.height-150+50+50+10);
    fifth.view.layer.cornerRadius = 10;
    //
    sixth = [[MusicView alloc] init];
    [self addChildViewController:sixth];
    [multiple addSubview:sixth.view];
    sixth.view.frame = CGRectMake(screenRect.size.width*5, 0, screenRect.size.width, screenRect.size.height-50);
    
    
    UITapGestureRecognizer *changePage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePage:)];
    UITapGestureRecognizer *changePageTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePageTwo:)];
    UITapGestureRecognizer *changePageThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePageThree:)];
    UITapGestureRecognizer *changePageFour = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePageFour:)];
    UITapGestureRecognizer *changePageFive = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePageFive:)];
    UITapGestureRecognizer *changePageSix = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePageSix:)];
    [profile addGestureRecognizer:changePage];
    [secondP addGestureRecognizer:changePageTwo];
    [thirdP addGestureRecognizer:changePageThree];
    [fourthP addGestureRecognizer:changePageFour];
    [fifthP addGestureRecognizer:changePageFive];
    [sixthP addGestureRecognizer:changePageSix];
    [profile setUserInteractionEnabled:YES];
    [secondP setUserInteractionEnabled:YES];
    [thirdP setUserInteractionEnabled:YES];
    [fourthP setUserInteractionEnabled:YES];
    [fifthP setUserInteractionEnabled:YES];
    [sixthP setUserInteractionEnabled:YES];
    
    //    tableViewPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTableView:)];
    //    [main.view addGestureRecognizer:tableViewPan];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    double aspectRatio = 16.00/9.00;
    double aspectW = screenWidth;
    aspectH = aspectW / aspectRatio;
    
    player = [[YTPlayerView alloc] init];
    player.frame = CGRectMake(0, -aspectH, screenRect.size.width, aspectH);
    [self.view addSubview:player];
    player.delegate = self;
    [player setHidden:YES];
    
    playerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPlayer:)];
    [player addGestureRecognizer:playerPan];
    
    playerPanTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panPlayerTap:)];
    //    playerPanTap.numberOfTapsRequired = 2;
    [player addGestureRecognizer:playerPanTap];
    [player setUserInteractionEnabled:YES];
    expand = [[UIView alloc] initWithFrame:CGRectMake(screenWidth-50, player.frame.size.height+player.frame.origin.y-50, 50, 50)];
    [self.view addSubview:expand];
    [expand setBackgroundColor:[UIColor clearColor]];
    //    [expand addGestureRecognizer:playerPan];
    [expand addGestureRecognizer:playerPanTap];

//    [self drawToolbar];
    

}
-(void)panPlayerTap:(UITapGestureRecognizer *)recognize{
    player.pauseVideo;
    
    if(player.frame.size.height != aspectH){
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
            CGAffineTransform rotationTransform = CGAffineTransformIdentity;
            rotationTransform = CGAffineTransformRotate(rotationTransform, 0);
            player.transform = rotationTransform;
            
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
            CGRect frame = player.frame;
            frame.origin.y = 0;
            frame.origin.x = 0;
            frame.size.width = screenRect.size.width;
            frame.size.height  = aspectH;
            player.frame = frame;
            
            
            expand.frame = CGRectMake(screenRect.size.width-50, player.frame.size.height+player.frame.origin.y-50, 50, 50);
            
        } completion:^(BOOL finished) {
            [player addGestureRecognizer:playerPan];
            //            player.playVideo;
        }];
    }else{
        
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
            CGAffineTransform rotationTransform = CGAffineTransformIdentity;
            rotationTransform = CGAffineTransformRotate(rotationTransform, 1.57079633);
            player.transform = rotationTransform;
            
        } completion:^(BOOL finished) {
            
        }];
        
        
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
            CGRect frame = player.frame;
            frame.origin.y = 0;
            frame.origin.x = 0;
            frame.size.width = screenRect.size.width;
            frame.size.height  = screenRect.size.height;
            player.frame = frame;
            
            
            expand.frame = CGRectMake(0, player.frame.size.height+player.frame.origin.y-70, 70, 50);
            
        } completion:^(BOOL finished) {
            [player removeGestureRecognizer:playerPan];
            //            player.playVideo;
        }];
    }
}
-(void)panPlayer:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x+translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    
    CGRect frame = expand.frame;
    frame.origin.y = recognizer.view.frame.origin.y+recognizer.view.frame.size.height-50;
    frame.origin.x = recognizer.view.frame.origin.x+recognizer.view.frame.size.width-50;
    expand.frame  = frame;
    
    //    CGPoint velo = [recognizer velocityInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 2;
        //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        if(velocity.x > 1000 || velocity.y > 1000 || velocity.x < -1000 || velocity.y < -1000 ){
            float slideFactor =  0.003*slideMult; // Increase for more of a slide
            CGPoint finalPoint = CGPointMake(recognizer.view.center.x+ velocity.x,
                                             recognizer.view.center.y + velocity.y);
            
            
            //finalPoint.x = MIN(MAX(finalPoint.x, 205), self.view.bounds.size.width+95);
            //            finalPoint.y = velocity.y;
            //            finalPoint.x = velocity.x;
            player.pauseVideo;
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
                recognizer.view.center = finalPoint;
                expand.center = finalPoint;
            } completion:^(BOOL finished){
                //            [self checkTouchStop];
            }];
        }
    }
    
}
-(void)changePlayer:(NSString *)videoID{
    NSDictionary *playerVars = @{
                                 @"controls" : @1,
                                 @"playsinline" : @1,
                                 @"autohide" : @1,
                                 @"showinfo" : @0,
                                 @"autoplay": @1,
                                 @"modestbranding" : @1
                                 };
    [player loadWithVideoId:videoID playerVars:playerVars];
    //    [player cueVideoById:videoID startSeconds:0 suggestedQuality:@"hd720"];
    [player playVideo];
    [player setHidden:NO];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
        CGRect frame = player.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        player.frame = frame;
        
        frame = expand.frame;
        frame.origin.y = player.frame.origin.y+player.frame.size.height-50;
        frame.origin.x = screenRect.size.width-50;
        expand.frame  = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    //    [UIView animateWithDuration:0.6 delay:0.3 options:UIViewAnimationCurveEaseIn animations:^{
    ////        CGRect frame = main.view.frame;
    ////        frame.origin.y = player.frame.size.height;
    ////        frame.size.height = screenRect.size.height-150-40;
    ////        main.view.frame = frame;
    ////        frame.origin.x = second.view.frame.origin.x;
    ////        second.view.frame = frame;
    //    }completion:^(BOOL finished) {
    //    }];
}

-(void)changePage:(UITapGestureRecognizer *)recognizer{
    CGFloat pageWidth = multiple.frame.size.width;
    screenRect = self.view.bounds;
    int page = floor((multiple.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
        [multiple setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)changePageTwo:(UITapGestureRecognizer *)recognizer{
    CGFloat pageWidth = multiple.frame.size.width;
    screenRect = self.view.bounds;
    int page = floor((multiple.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
        [multiple setContentOffset:CGPointMake(screenRect.size.width, 0) animated:YES];
    
}
-(void)changePageThree:(UITapGestureRecognizer *)recognizer{
    CGFloat pageWidth = multiple.frame.size.width;
    screenRect = self.view.bounds;
    int page = floor((multiple.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
        [multiple setContentOffset:CGPointMake(screenRect.size.width*2, 0) animated:YES];
    
}
-(void)changePageFour:(UITapGestureRecognizer *)recognizer{
    CGFloat pageWidth = multiple.frame.size.width;
    screenRect = self.view.bounds;
    int page = floor((multiple.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [multiple setContentOffset:CGPointMake(screenRect.size.width*3, 0) animated:YES];
    
}
-(void)changePageFive:(UITapGestureRecognizer *)recognizer{
    CGFloat pageWidth = multiple.frame.size.width;
    screenRect = self.view.bounds;
    int page = floor((multiple.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [multiple setContentOffset:CGPointMake(screenRect.size.width*4, 0) animated:YES];
    
}
-(void)changePageSix:(UITapGestureRecognizer *)recognizer{
    CGFloat pageWidth = multiple.frame.size.width;
    screenRect = self.view.bounds;
    int page = floor((multiple.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [multiple setContentOffset:CGPointMake(screenRect.size.width*5, 0) animated:YES];
    
}
-(void)panTableView:(UIPanGestureRecognizer *)recognizer{
    if(recognizer.view.frame.origin.y > 40 && recognizer.view.frame.origin.y < 101){
        CGPoint translation = [recognizer translationInView:self.view];
        recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                         recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}
-(void)drawToolbar{
    NSString *youtubes = [user_dict objectForKey:@"youtube"];
    y = [youtubes componentsSeparatedByString:@","];
    for(int i = 0; i < [[user_dict allKeys] count]; i++){
//        NSLog(@"%@", [[user_dict allKeys] objectAtIndex:i]);
    }
    header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 110)];
    NSString *youtube_picture = [NSString stringWithFormat:@"http://www.thewotimes.com/Y/dig.php?user=%@&dig=header&type=youtube&username=%@", user, [y objectAtIndex:0]];
    NSURL *url = [NSURL URLWithString:youtube_picture];
    NSError *error;
    NSString *photo = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    [header setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@""]];
    header.contentMode = UIViewContentModeScaleAspectFill;
    [multiple addSubview:header];
    
    
    profile = [[UIImageView alloc] initWithFrame:CGRectMake(15,4, 45, 45)];
    youtube_picture = [NSString stringWithFormat:@"http://www.thewotimes.com/Y/dig.php?user=%@&dig=picture&type=youtube&username=%@", user, [y objectAtIndex:0]];
    url = [NSURL URLWithString:youtube_picture];
    photo = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    
    profile = [[UIImageView alloc] initWithFrame:CGRectMake(15,4, 45, 45)];
    //    profile.imageURL = [NSURL URLWithString:photo];
    [profile setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@""]];
    //    profile.image = [UIImage imageNamed:@"zoellaprofileb.jpg"];
    profile.contentMode = UIViewContentModeScaleAspectFill;
    profile.layer.cornerRadius = 45/2;
    profile.clipsToBounds = YES;
    [profileScrollView addSubview:profile];
    
    UIImageView *youtube_one = [[UIImageView alloc] initWithFrame:CGRectMake(profile.frame.origin.x+profile.frame.size.width-13, profile.frame.origin.y+profile.frame.size.height-13, 13, 13)];
    youtube_one.image = [UIImage imageNamed:@"youtube-play_bb0000_50.png"];
    [profileScrollView addSubview:youtube_one];
    
    header2 = [[UIImageView alloc] initWithFrame:CGRectMake(screenRect.size.width, 0, screenRect.size.width, 110)];
    NSString *_picture = [NSString stringWithFormat:@"http://www.thewotimes.com/Y/dig.php?user=%@&dig=header&type=youtube&username=%@", user, [y objectAtIndex:1]];
    url = [NSURL URLWithString:_picture];
    photo = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    [header2 setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@""]];
    header2.contentMode = UIViewContentModeScaleAspectFill;
    header2.clipsToBounds = YES;
    [multiple addSubview:header2];
    
    secondP = [[UIImageView alloc] initWithFrame:CGRectMake(70,4, 45, 45)];
    youtube_picture = [NSString stringWithFormat:@"http://www.thewotimes.com/Y/dig.php?user=%@&dig=picture&type=youtube&username=%@", user, [y objectAtIndex:1]];
    url = [NSURL URLWithString:youtube_picture];
    photo = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    [secondP setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@""]];
    secondP.contentMode = UIViewContentModeScaleAspectFill;
    secondP.layer.cornerRadius = 45/2;
    secondP.clipsToBounds = YES;
    [profileScrollView addSubview:secondP];
    UIImageView *youtube_two = [[UIImageView alloc] initWithFrame:CGRectMake(secondP.frame.origin.x+secondP.frame.size.width-13, secondP.frame.origin.y+secondP.frame.size.height-13, 13, 13)];
    youtube_two.image = [UIImage imageNamed:@"youtube-play_bb0000_50.png"];
    [profileScrollView addSubview:youtube_two];
    
    header3 = [[UIImageView alloc] initWithFrame:CGRectMake(screenRect.size.width*2, 0, screenRect.size.width, 110)];
    _picture = [NSString stringWithFormat:@"http://www.thewotimes.com/Y/dig.php?user=%@&dig=header&type=twitter", user];
    url = [NSURL URLWithString:_picture];
    photo = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    [header3 setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@""]];
    header3.contentMode = UIViewContentModeScaleAspectFill;
    header3.clipsToBounds = YES;
    [multiple addSubview:header3];
//    [header3 setAlpha:0.5];
    
    thirdP = [[UIImageView alloc] initWithFrame:CGRectMake(125,4, 45, 45)];
    NSString *twitter_picture = [NSString stringWithFormat:@"http://www.thewotimes.com/Y/dig.php?user=%@&dig=picture&type=twitter", user];
    url = [NSURL URLWithString:twitter_picture];
    photo = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    [thirdP setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@""]];
    thirdP.contentMode = UIViewContentModeScaleAspectFill;
    thirdP.layer.cornerRadius = 45/2;
    thirdP.clipsToBounds = YES;
    [profileScrollView addSubview:thirdP];
    
    
    UIImageView *twitter = [[UIImageView alloc] initWithFrame:CGRectMake(thirdP.frame.origin.x+thirdP.frame.size.width-13, thirdP.frame.origin.y+thirdP.frame.size.height-13, 13, 13)];
    twitter.image = [UIImage imageNamed:@"twitter_00aced_50.png"];
    [profileScrollView addSubview:twitter];
    
    
    header4 = [[UIImageView alloc] initWithFrame:CGRectMake(screenRect.size.width*3, 0, screenRect.size.width, 110)];
    _picture = [NSString stringWithFormat:@"http://www.thewotimes.com/Y/dig.php?user=%@&dig=header&type=instagram", user];
    url = [NSURL URLWithString:_picture];
    photo = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    [header4 setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@""]];
    header4.contentMode = UIViewContentModeScaleAspectFill;
    header4.clipsToBounds = YES;
    [multiple addSubview:header4];
    
    fourthP = [[UIImageView alloc] initWithFrame:CGRectMake(180,4, 45, 45)];
    NSString *insta_picture = [NSString stringWithFormat:@"http://www.thewotimes.com/Y/dig.php?user=%@&dig=picture&type=instagram", user];
    url = [NSURL URLWithString:insta_picture];
    photo = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    [fourthP setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@""]];
    fourthP.contentMode = UIViewContentModeScaleAspectFill;
    fourthP.layer.cornerRadius = 45/2;
    fourthP.clipsToBounds = YES;
    [profileScrollView addSubview:fourthP];
    
    
    UIImageView *instagram = [[UIImageView alloc] initWithFrame:CGRectMake(fourthP.frame.origin.x+fourthP.frame.size.width-13, fourthP.frame.origin.y+fourthP.frame.size.height-13, 13, 13)];
    instagram.image = [UIImage imageNamed:@"instagramicon.png"];
    [profileScrollView addSubview:instagram];
    
    header5 = [[UIImageView alloc] initWithFrame:CGRectMake(screenRect.size.width*4, 0, screenRect.size.width, 110)];
    _picture = [NSString stringWithFormat:@"http://www.thewotimes.com/Y/dig.php?user=%@&dig=header&type=tumblr", user];
    url = [NSURL URLWithString:_picture];
    photo = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    [header5 setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@""]];
    header5.contentMode = UIViewContentModeScaleAspectFill;
    header5.clipsToBounds = YES;
    [multiple addSubview:header5];
    
    
    fifthP = [[UIImageView alloc] initWithFrame:CGRectMake(235,4, 45, 45)];
    NSString *tumblr_picture = [NSString stringWithFormat:@"http://www.thewotimes.com/Y/dig.php?user=%@&dig=picture&type=tumblr", user];
    url = [NSURL URLWithString:tumblr_picture];
    photo = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    [fifthP setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@""]];
    fifthP.contentMode = UIViewContentModeScaleAspectFill;
    fifthP.layer.cornerRadius = 45/2;
    fifthP.clipsToBounds = YES;
    [profileScrollView addSubview:fifthP];
    
    UIImageView *tumblr = [[UIImageView alloc] initWithFrame:CGRectMake(fifthP.frame.origin.x+fifthP.frame.size.width-13, fifthP.frame.origin.y+fifthP.frame.size.height-13, 13, 13)];
    tumblr.image = [UIImage imageNamed:@"tumblr_32506d_50.png"];
    [profileScrollView addSubview:tumblr];
    
    sixthP = [[UIImageView alloc] initWithFrame:CGRectMake(290,4, 45, 45)];
    photo = @"http://ecx.images-amazon.com/images/I/71NeXtO31WL._SL1200_.jpg";
    [sixthP setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@""]];
    sixthP.contentMode = UIViewContentModeScaleAspectFill;
    sixthP.layer.cornerRadius = 45/2;
    sixthP.clipsToBounds = YES;
    [profileScrollView addSubview:sixthP];
    
    UIImageView *blog = [[UIImageView alloc] initWithFrame:CGRectMake(sixthP.frame.origin.x+sixthP.frame.size.width-13, sixthP.frame.origin.y+sixthP.frame.size.height-13, 13, 13)];
    blog.image = [UIImage imageNamed:@"newmusic.png"];
    [profileScrollView addSubview:blog];
    
    
}
-(void)drawTwitterOnHeader{
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(header3.frame.origin.x + 20,20, 70, 70)];
    NSString *twitter_picture = [NSString stringWithFormat:@"http://www.thewotimes.com/Y/dig.php?user=%@&dig=picture&type=twitter", user];
    NSURL *url = [NSURL URLWithString:twitter_picture];
    NSError *error;
    NSString *photo = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    photo= [photo stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    [pic setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@""]];
    pic.contentMode = UIViewContentModeScaleAspectFill;
    pic.layer.cornerRadius = 70/2;
    pic.clipsToBounds = YES;
    
//    [multiple addSubview:pic];
    
    UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(header3.frame.origin.x, 10, screenRect.size.width, 100)];
    username.text = [NSString stringWithFormat:@"@%@",[user_dict objectForKey:@"twitter"]];
    username.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:40];
//    username.textColor = [UIColor whiteColor];
    username.textAlignment = NSTextAlignmentCenter;
//    username.text = @"zozeebo";
//    [multiple addSubview:username];
    
}
-(void)fetchAllFeeds{
    [main fetchFeeds];
    [second fetchFeeds];
    [third fetchFeeds];
    [fourth fetchFeeds];
    [fifth fetchFeeds];
    [sixth fetchFeeds];
}
-(void)updateTableViews{
    [[main main_tableView] reloadData];
    [[second main_tableView] reloadData];
    [[third main_tableView] reloadData];
    [[fourth main_tableView] reloadData];
    [[fifth main_tableView] reloadData];
    [[sixth main_tableView] reloadData];
}
@end

