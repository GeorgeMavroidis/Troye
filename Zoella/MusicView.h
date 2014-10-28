//
//  YoutubeTableView.h
//  Zoella
//
//  Created by George on 2014-09-28.
//  Copyright (c) 2014 GM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface MusicView : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, NSXMLParserDelegate, AVAudioPlayerDelegate>


@property (nonatomic, strong) NSString *playlist;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) UITableView *main_tableView;
@property (nonatomic, strong) AVAudioPlayer *myAudioPlayer;
-(void)fetchFeeds;
-(void)fetchFeedsFor:(NSString *)page;
-(void)loadFeedFor:(NSString *)page;

- (void)initPlayer:(NSString*) audioFile fileExtension:(NSString*)fileExtension;
- (void)playAudio;
- (void)pauseAudio;
- (void)setCurrentAudioTime:(float)value;
- (float)getAudioDuration;
- (NSString*)timeFormat:(float)value;
- (NSTimeInterval)getCurrentAudioTime;

@property (nonatomic, strong) IBOutlet UISlider *currentTimeSlider;
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UILabel *durationL;
@property (nonatomic, strong) IBOutlet UILabel *timeElapsed;

@property BOOL isPaused;
@property BOOL scrubbing;

@property NSTimer *timer;
@end
