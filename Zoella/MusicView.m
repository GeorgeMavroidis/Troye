//
//  YoutubeTableView.m
//  Zoella
//
//  Created by George on 2014-09-28.
//  Copyright (c) 2014 GM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MusicView.h"
#import "AsyncImageView.h"
#import "YoutubeCell.h"
#import <AVFoundation/AVAudioSession.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AFNetworking.h>
#import <AFURLSessionManager.h>

@interface MusicView(){
    NSString *cellIdentifier;
    NSMutableArray *tableData;
    NSArray *json;
    NSMutableDictionary *json_dic;
    NSMutableArray *items;
    UIRefreshControl * refresh;
    NSString *nextPageToken;
    BOOL fetching;
    
    NSString *user;
    UIScrollView *mainScrollView;
    UICollectionView *collectionView;
    NSMutableArray *titles;
    
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *guid;
    NSMutableString *duration;
    NSString *element;
    
    BOOL loading;
    UITapGestureRecognizer *tgr;
    int lastplayed;
    int numberOfEpisode;
    CGRect screenRect;
    UIView *playlistV;
    UIImageView *artwork;
    
    UISlider *podcastSlider;
    NSString *type;
    
    UIView *musicPlayerV;
    
    CGFloat screenWidth;
    CGFloat screenHeight;
}
@end

@implementation MusicView
@synthesize playlist, main_tableView, username, myAudioPlayer, currentTimeSlider, playButton, timeElapsed, durationL;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    user = @"music-data";
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    json = [[NSArray alloc] init];
    json_dic = [[NSMutableDictionary alloc] init];
    items = [[NSMutableArray alloc] init];
    feeds = [[NSMutableArray alloc] init];
    
    type = @"album";
//    [self fetchFeeds];
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    //    [self fetchFeeds];
    if([d objectForKey:user] == nil){
        [self fetchFeeds];
    }else{
        [self loadFeedFor];
    }
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    lastplayed = 1000000;
    nextPageToken = @"none";
    fetching = NO;
    loading = NO;
    podcastSlider = [[UISlider alloc] init];
    
    
    
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 130, screenWidth, screenHeight)];
    mainScrollView.layer.cornerRadius = 10;
    [mainScrollView setShowsVerticalScrollIndicator:NO];
    int numberOfAlbums = 1;
    
    
    
    if(numberOfAlbums == 1){
        artwork = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth)];
        [artwork setImageWithURL:[NSURL URLWithString:@"https://georgem.s3.amazonaws.com/Y/artists/troyesivan/trxye.jpg"]];
        [self.view addSubview:artwork];
        titles = [[NSMutableArray alloc] init];
        
        if([type isEqualToString:@"podcast"]){
            for(NSDictionary *title in feeds){
                [titles addObject:[title objectForKey:@"title"]];
            }
            
            numberOfEpisode = [feeds count];
        }else{
            for(NSDictionary *title in feeds){
                [titles addObject:[[title allKeys] objectAtIndex:0]];
                
            }
            
            numberOfEpisode = [feeds count];
            //            NSLog(@"%@", titles);
            
        }
        playlistV = [[UIView alloc] initWithFrame:CGRectMake(0, screenWidth-130, screenWidth, 50*numberOfEpisode)];
        playlistV.layer.cornerRadius = 10;
        [playlistV setBackgroundColor:[UIColor whiteColor]];
        [mainScrollView addSubview:playlistV];
        
        
        [self drawPlayIconsOnAlLViews];
        
        for(int i = 0; i < numberOfEpisode; i++){
            
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 50*i, screenWidth, 50)];
            v.tag = i;
            if(i == 0){
                v.layer.cornerRadius = 10;
                UIView *a = [[UIView alloc] initWithFrame:CGRectMake(0, 50*i+20, screenWidth, 50)];
                [a setBackgroundColor:[UIColor clearColor]];
                [playlistV addSubview:a];
            }
            
            [v setBackgroundColor:[UIColor clearColor]];
            [playlistV addSubview:v];
            
            UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, screenWidth-80, 50)];
            t.text = [titles objectAtIndex:i];
            t.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
            [v addSubview:t];
            
            UILabel *m = [[UILabel alloc] initWithFrame:CGRectMake(10,  0, 40-10, 50)];
            
            if([type isEqualToString:@"podcast"]){
                m.text = [NSString stringWithFormat:@"%d.", numberOfEpisode-i];
            }else{
                m.text = [NSString stringWithFormat:@"%d.", i+1];
            }
            m.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
            [v addSubview:m];
            
            if(i < numberOfEpisode && i > 0){
                UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(20, 0, screenWidth-40, 1)];
                separator.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.7];
                [v addSubview:separator];
            }
            UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playMusic:)];
            [v addGestureRecognizer:tg];
            
        }
        
        
        
        
        [self.view addSubview:mainScrollView];
        
    }
    mainScrollView.contentSize = CGSizeMake(screenWidth, screenWidth+50*[titles count]+20+70);
    
    
    [self drawMusicPlayer];

}
-(void)loadFeedFor{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    feeds = [d objectForKey:user];
    
}
-(void)fetchFeeds{
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    NSString *urlstring = [NSString stringWithFormat:@"http://thewotimes.com/Y/user.php?user=%@&type=%@", USER, type];
    if([type isEqualToString:@"podcast"]){
        parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlstring]];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
        
        
    }else{
        NSURL *url = [NSURL URLWithString:urlstring];
        NSError* error;
        //    NSLog(posts_url);
        NSString *t = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
        
        NSData *tdata = [t dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *both =[[NSJSONSerialization JSONObjectWithData:tdata options:NSJSONReadingMutableContainers  error:nil] objectAtIndex:0];
        NSArray *tr = [NSJSONSerialization JSONObjectWithData:tdata options:NSJSONReadingMutableContainers  error:nil];
        //        NSLog(@"%@", tr);
        
        numberOfEpisode = [tr count];
        
        feeds = tr;
        
        [d setObject:feeds forKey:user];
        
        
    }
    
}
-(NSString *)downloadFile:(NSString *)fetch{
    NSString  *filePath = @"";
    NSArray *a = [fetch componentsSeparatedByString:@"/"];
    NSString *f = [a objectAtIndex:[a count] -1];
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:f];
    filePath = foofile;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    
    if(!fileExists){
        NSString *stringURL = fetch;
        NSURL  *url = [NSURL URLWithString:stringURL];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            NSArray    *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,f];
            [urlData writeToFile:filePath atomically:YES];
            NSLog(@"Written to %@", filePath);
        }
    }
    NSLog(filePath);
    return filePath;
    
    
}
-(void)drawMusicPlayer{
    musicPlayerV = [[UIView alloc] initWithFrame:CGRectMake(0, screenRect.size.height-100, screenRect.size.width, 65)];
    [musicPlayerV setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:musicPlayerV];
    
    currentTimeSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 0, screenRect.size.width-100, 50)];
    [currentTimeSlider setUserInteractionEnabled:YES];
    [currentTimeSlider addTarget:self action:@selector(setCurrentTimeSlider:) forControlEvents:UIControlEventValueChanged];
    [currentTimeSlider addTarget:self action:@selector(userIsScrubbing:) forControlEvents:UIControlEventValueChanged];
    //    playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 50, 50)];
    durationL = [[UILabel alloc] initWithFrame:CGRectMake(screenRect.size.width-50, 0, 200, 50)];
    [durationL setFont:[UIFont fontWithName:@"CourierNewPSMT" size:15]];
    
    timeElapsed = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 50)];
    [timeElapsed setFont:[UIFont fontWithName:@"CourierNewPSMT" size:15]];
    
    [musicPlayerV addSubview:currentTimeSlider];
    [musicPlayerV addSubview:playButton];
    [musicPlayerV addSubview:durationL];
    [musicPlayerV addSubview:timeElapsed];
    
    musicPlayerV.layer.masksToBounds = NO;
//    musicPlayerV.layer.cornerRadius = 8; // if you like rounded corners
    musicPlayerV.layer.shadowOffset = CGSizeMake(0, -5);
    musicPlayerV.layer.shadowRadius = 10;
    musicPlayerV.layer.shadowOpacity = 0.2;
    
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
-(void)playMusic:(UITapGestureRecognizer *)sender{
    NSError *error;
    NSString *durat;
    NSString *guid;
    
    if([type isEqualToString:@"podcast"]){
        
        guid = [[feeds objectAtIndex:sender.view.tag] objectForKey:@"guid"];
        guid = [guid stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        guid = [guid stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *durat =[[feeds objectAtIndex:sender.view.tag] objectForKey:@"itunes:duration"];
        durat = [durat stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        durat = [durat stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"test %@",durat);

    }else{
        NSArray *t = feeds;
        
        NSDictionary *a = [t objectAtIndex:sender.view.tag];
        NSArray *k = [a allKeys];
        NSString *d = [a objectForKey:[k objectAtIndex:0]];
        guid = d;
        guid = [guid stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        guid = [guid stringByReplacingOccurrencesOfString:@" " withString:@""];
//        NSLog(guid);
        
        NSString *durat = @"10";
//        NSString *durat =[[feeds objectAtIndex:sender.view.tag] objectForKey:@"itunes:duration"];
//        durat = [durat stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        durat = [durat stringByReplacingOccurrencesOfString:@" " withString:@""];
        

    }
       //    NSLog(guid);
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    //    NSLog(@"above");
    tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseMusic:)];
    //    [sender.view addGestureRecognizer:tgr];
    
    if(!loading){
        if([myAudioPlayer isPlaying]){
            
            if(lastplayed == sender.view.tag){
                [self playAudioP];
//                [myAudioPlayer pause];
                
                UIImageView *play = [[UIImageView alloc] initWithFrame:CGRectMake(sender.view.frame.size.width-50, 10, 30, 30)];
                play.image = [UIImage imageNamed:@"play.png"];
                [play setBackgroundColor:[UIColor whiteColor]];
                [sender.view addSubview:play];
                
            }else{
                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator.frame = CGRectMake(screenWidth-50, 10, 30, 30);
                [activityIndicator setBackgroundColor:[UIColor whiteColor]];
                [sender.view addSubview: activityIndicator];
                [playlistV bringSubviewToFront:sender.view];
                [activityIndicator startAnimating];
                loading = YES;
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    NSData *soundData = [NSData dataWithContentsOfFile:[self downloadFile:guid]];
                    
                    myAudioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:nil];
                    myAudioPlayer.numberOfLoops = 0;
                    myAudioPlayer.delegate = self;
                    
                    AVAudioSession *session = [AVAudioSession sharedInstance];
                    
                    
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc]
                                                        initWithImage:artwork.image];
                        [self setupAudioPlayer:@"test"];
                        
                        NSDictionary *info = @{ MPMediaItemPropertyArtist: @"Troye Sivan",
                                                MPMediaItemPropertyAlbumTitle: @"TRXYE",
                                                MPMediaItemPropertyTitle: [titles objectAtIndex:sender.view.tag],
                                                MPMediaItemPropertyArtwork: albumArt,
                                                MPMediaItemPropertyPlaybackDuration: [NSNumber numberWithInt:(int)myAudioPlayer.duration],
                                                };
                        
                        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
                        
                        myAudioPlayer.delegate = self;
                        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

                        
                        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                        [[AVAudioSession sharedInstance] setActive: YES error: nil];
                        [[AVAudioSession sharedInstance ] setDelegate:self];
                        [[NSNotificationCenter defaultCenter] addObserver:self
                                                                 selector:@selector(handleAudioSessionInterruption:)
                                                                     name:AVAudioSessionInterruptionNotification
                                                                   object:session];
                        
                        
                        [self drawPlayIconsOnAlLViews];
                        
                        
                        UIImageView *pause = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-50, 10, 30, 30)];
                        pause.image = [UIImage imageNamed:@"pause.png"];
                        [pause setBackgroundColor:[UIColor whiteColor]];
                        pause.tag = sender.view.tag;
                        [sender.view addSubview:pause];
                        [playlistV bringSubviewToFront:sender.view];
                        
                        [pause addGestureRecognizer:tgr];
                        
                        
                        [self playAudioP];
                        
//                        [myAudioPlayer play];
                        lastplayed =sender.view.tag;
                        [activityIndicator stopAnimating];
                        loading = NO;
                        
                        
                    });
                });
                
            }
            
            
            
        }else{
            if(lastplayed == sender.view.tag){
                [myAudioPlayer play];
                lastplayed = sender.view.tag;
                UIImageView *pause = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-50, 10, 30, 30)];
                pause.image = [UIImage imageNamed:@"pause.png"];
                [pause setBackgroundColor:[UIColor whiteColor]];
                pause.tag = sender.view.tag;
                [sender.view addSubview:pause];
                
                //            [pause addGestureRecognizer:tgr];
                //            NSLog(@"lastplayed");
            }else{
                //            NSLog(@"none");
                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator.frame = CGRectMake(screenWidth-50, 10, 30, 30);
                [activityIndicator setBackgroundColor:[UIColor whiteColor]];
                [sender.view addSubview: activityIndicator];
                [playlistV bringSubviewToFront:sender.view];
                [activityIndicator startAnimating];
                loading = YES;
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    NSData *soundData = [NSData dataWithContentsOfFile:[self downloadFile:guid]];
                    
                    myAudioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:nil];
                    myAudioPlayer.numberOfLoops = 0;
                    myAudioPlayer.delegate = self;
                    
                    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                    [[AVAudioSession sharedInstance] setActive: YES error: nil];
                    [[AVAudioSession sharedInstance ] setDelegate:self];
                    AVAudioSession *session = [AVAudioSession sharedInstance];
//
//                    
//                    
                    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//                    [myAudioPlayer prepareToPlay];
//                    [self becomeFirstResponder];
                    
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        [self setupAudioPlayer:@"test"];
                        
                        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc]
                                                        initWithImage:artwork.image];
                        
                        
                        NSDictionary *info = @{ MPMediaItemPropertyArtist: @"Troye Sivan",
                                                MPMediaItemPropertyAlbumTitle: @"TRXYE",
                                                MPMediaItemPropertyTitle: [titles objectAtIndex:sender.view.tag],
                                                MPMediaItemPropertyArtwork: albumArt,
                                                MPMediaItemPropertyPlaybackDuration: [NSNumber numberWithInt:(int)myAudioPlayer.duration] };
                        
                        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
                        
                        myAudioPlayer.delegate = self;
                        
                        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                        [[AVAudioSession sharedInstance] setActive: YES error: nil];
                        [[AVAudioSession sharedInstance ] setDelegate:self];
                        
                        [[NSNotificationCenter defaultCenter] addObserver:self
                                                                 selector:@selector(handleAudioSessionInterruption:)
                                                                     name:AVAudioSessionInterruptionNotification
                                                                   object:session];
                        
                        [self drawPlayIconsOnAlLViews];
                        
                        UIImageView *pause = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-50, 10, 30, 30)];
                        pause.image = [UIImage imageNamed:@"pause.png"];
                        [pause setBackgroundColor:[UIColor whiteColor]];
                        pause.tag = sender.view.tag;
                        [sender.view addSubview:pause];
                        [playlistV bringSubviewToFront:sender.view];
                        
                        [pause addGestureRecognizer:tgr];
                        
                        [self playAudioP];
                        
//                        [myAudioPlayer play];
                        lastplayed =sender.view.tag;
                        [activityIndicator stopAnimating];
                        loading = NO;
                        
                        
                    });
                });
            }
        }
    }else{
        if(lastplayed == sender.view.tag){
            if([myAudioPlayer isPlaying]){
                [self playAudioP];
//                [myAudioPlayer pause];
                
                UIImageView *play = [[UIImageView alloc] initWithFrame:CGRectMake(sender.view.frame.size.width-50, 10, 30, 30)];
                play.image = [UIImage imageNamed:@"play.png"];
                [play setBackgroundColor:[UIColor whiteColor]];
                [sender.view addSubview:play];
            }else{
                [self playAudioP];
//                [myAudioPlayer play];
                
                UIImageView *play = [[UIImageView alloc] initWithFrame:CGRectMake(sender.view.frame.size.width-50, 10, 30, 30)];
                play.image = [UIImage imageNamed:@"pause.png"];
                [play setBackgroundColor:[UIColor whiteColor]];
                [sender.view addSubview:play];
            }
            
        }
    }
    
    
    //    [myAudioPlayer play];
    
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    
    
    NSLog(@"here");
    //    if([myAudioPlayer isPlaying]){
    //        [myAudioPlayer pause];
    //    }else{
    //        [myAudioPlayer play];
    //    }
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            if([myAudioPlayer rate] == 0){
                
                [self playAudioP];
//                [myAudioPlayer play];
            } else {
                [self playAudioP];
//                [myAudioPlayer pause];
            }
            break;
        case UIEventSubtypeRemoteControlPlay:
            
            [self playAudioP];
//            [myAudioPlayer play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self playAudioP];
//            [myAudioPlayer pause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            NSLog(@"here");
            break;
        default:
            break;
    }
}
- (void) audioPlayerBeginInterruption: (AVAudioPlayer *) player {
    [self playAudioP];
//    [myAudioPlayer pause];
}

- (void) audioPlayerEndInterruption: (AVAudioPlayer *) player {
    
    [self playAudioP];
//    [myAudioPlayer play];
}
-(void)drawPlayIconsOnAlLViews{
    
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    for(int i = 0 ; i < numberOfEpisode; i++){
        UIImageView *play = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-50, 10+50*i, 30, 30)];
        play.image = [UIImage imageNamed:@"play.png"];
        [play setBackgroundColor:[UIColor whiteColor]];
        [playlistV addSubview:play];
    }
}
-(void)pauseMusic:(UITapGestureRecognizer *)sender{
    
    if(lastplayed == sender.view.tag){
        [self playAudioP];
//        [myAudioPlayer play];
        
        lastplayed =sender.view.tag;
        
        UIImageView *play = [[UIImageView alloc] initWithFrame:CGRectMake(sender.view.frame.size.width-50, 10, 30, 30)];
        play.image = [UIImage imageNamed:@"pause.png"];
        [play setBackgroundColor:[UIColor whiteColor]];
        [sender.view addSubview:play];
        [sender.view removeGestureRecognizer:tgr];
    }else{
        
    }
    NSLog(@"here");
    
    //    [sender.view removeFromSuperview];
}
-(void)createMusicFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Music"];
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder if it doesn't already exist
    
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    //    NSLog(@"%@", element);
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        guid    = [[NSMutableString alloc] init];
        duration = [[NSMutableString alloc] init];
        
    }
    
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    }else if ([element isEqualToString:@"guid"]) {
        [guid appendString:string];
    }else if ([element isEqualToString:@"itunes:duration"]) {
        [duration appendString:string];
    }
    
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:guid forKey:@"guid"];
        [item setObject:duration forKey:@"itunes:duration"];
        
        [feeds addObject:[item copy]];
        
    }
    
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //    NSLog(@"repaint %@", feeds);
    //    [self.tableView reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor greenColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}
-(void)ajaxFeeds{
    
}
-(void)loadFeedFor:(NSString *)page{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [items count];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 * Simply fire the play Event
 */
- (void)playAudio {
    [myAudioPlayer play];
}

/*
 * Simply fire the pause Event
 */
- (void)pauseAudio {
    [myAudioPlayer pause];
}

/*
 * Format the float time values like duration
 * to format with minutes and seconds
 */
-(NSString*)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = lroundf(seconds);
    int roundedMinutes = lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%d:%02d",
                      roundedMinutes, roundedSeconds];
    return time;
}

/*
 * To set the current Position of the
 * playing audio File
 */
- (void)setCurrentAudioTime:(float)value {
    [myAudioPlayer setCurrentTime:value];
}

/*
 * Get the time where audio is playing right now
 */
- (NSTimeInterval)getCurrentAudioTime {
    return [myAudioPlayer currentTime];
}

/*
 * Get the whole length of the audio file
 */
- (float)getAudioDuration {
    return [myAudioPlayer duration];
}
/*
 * Setup the AudioPlayer with
 * Filename and FileExtension like mp3
 * Loading audioFile and sets the time Labels
 */
- (void)setupAudioPlayer:(NSString*)fileName
{
    //insert Filename & FileExtension
    NSString *fileExtension = @"mp3";
    
//    if(currentTimeSlider != nil) [self clearTime];
    
    self.currentTimeSlider.maximumValue = [self getAudioDuration];
    self.currentTimeSlider.value = 0;
    //init the current timedisplay and the labels. if a current time was stored
    //for this player then take it and update the time display
    self.timeElapsed.text = @"0:00";
    
    self.durationL.text = [NSString stringWithFormat:@"-%@",
                          [self timeFormat:[self getAudioDuration]]];
    
    
}
-(void)clearTime{
    [currentTimeSlider removeFromSuperview];
    [durationL removeFromSuperview];
    [timeElapsed removeFromSuperview];
}
/*
 * PlayButton is pressed
 * plays or pauses the audio and sets
 * the play/pause Text of the Button
 */

-(void)playAudioP{
        [self.timer invalidate];
        //play audio for the first time or if pause was pressed
        if (![myAudioPlayer isPlaying]) {
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_pause.png"]
                                       forState:UIControlStateNormal];
            
            //start a timer to update the time label display
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(updateTime:)
                                                        userInfo:nil
                                                         repeats:YES];
            
            [self playAudio];
            self.isPaused = TRUE;
            
        } else {
            //player is paused and Button is pressed again
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_play.png"]
                                       forState:UIControlStateNormal];
            
            [self pauseAudio];
            
            self.isPaused = FALSE;
        }
    
}
/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
 */
- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.scrubbing) {
        self.currentTimeSlider.value = [self getCurrentAudioTime];
    }
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [self timeFormat:[self getCurrentAudioTime]]];
    
    self.durationL.text = [NSString stringWithFormat:@"-%@",
                          [self timeFormat:[self getAudioDuration] - [self getCurrentAudioTime]]];
//    NSLog(@"update");
}

/*
 * Sets the current value of the slider/scrubber
 * to the audio file when slider/scrubber is used
 */
- (IBAction)setCurrentTime:(id)scrubber {    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    
    [self setCurrentAudioTime:self.currentTimeSlider.value];
    self.scrubbing = FALSE;
}
-(void)setCurrentTimeSlider:(UISlider *)currentTimeSlider{

    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    
    [self setCurrentAudioTime:self.currentTimeSlider.value];
    self.scrubbing = FALSE;
}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */
- (IBAction)userIsScrubbing:(id)sender {
    self.scrubbing = TRUE;
}


@end

