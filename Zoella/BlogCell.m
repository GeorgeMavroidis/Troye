//
//  YoutubeCell.m
//  Zoella
//
//  Created by George on 2014-09-28.
//  Copyright (c) 2014 GM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BlogCell.h"
#import <QuartzCore/QuartzCore.h>

@interface BlogCell (){
    
}
@end

@implementation BlogCell
@synthesize thumbnail, title, webview, getHeight;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
        double aspectRatio = 16.00/9.00;
        double aspectW = screenWidth-20;
        double aspectH = aspectW / aspectRatio;
        
        thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, aspectW, aspectH)];
        thumbnail.contentMode = UIViewContentModeScaleAspectFill;
        thumbnail.clipsToBounds = YES;
        [self addSubview:thumbnail];
        
        title = [[UITextView alloc] initWithFrame:CGRectMake(10, thumbnail.frame.size.height+thumbnail.frame.origin.y, screenWidth-20, 50)];
        title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        title.userInteractionEnabled = NO;
        [self addSubview:title];
        
        webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenHeight-50)];
        getHeight = @"400";
        [self addSubview:webview];
        
    }
    return self;
}


@end
