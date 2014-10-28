//
//  YoutubeCell.h
//  Zoella
//
//  Created by George on 2014-09-28.
//  Copyright (c) 2014 GM. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BlogCell : UITableViewCell
@property (nonatomic, strong) UIImageView *thumbnail;
@property (nonatomic, strong) UITextView *title;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) NSString *getHeight;
@end