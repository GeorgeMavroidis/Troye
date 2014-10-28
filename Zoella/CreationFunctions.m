//
//  CreationFunctions.m
//  Feed
//
//  Created by George on 2014-03-17.
//  Copyright (c) 2014 George. All rights reserved.
//

#import "CreationFunctions.h"

#import "SDWebImage/UIImageView+WebCache.h"
#import "AsyncImageView.h"
#import "AppDelegate.h"

@implementation CreationFunctions

+(TwitterCell *)createTwitterCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath singleton:(NSMutableArray *)singleton_universal{
    
    // Similar to UITableViewCell, but
    TwitterCell *cell = [[TwitterCell alloc] init];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Just want to test, so I hardcode the data
    
    int path = indexPath.row;
    
    //    NSDictionary *temp_twitter = [singleton_universal.universal_feed_array objectAtIndex:path];
    NSDictionary *temp_twitter = [[singleton_universal objectAtIndex:path] objectForKey:@"entry"];
    
    // NSLog(@"%@", [temp_twitter objectAtIndex:path]);
    
    //NSLog(@"%@", [[[temp_instagram[(int)indexPath.row]objectForKey:@"caption"]objectForKey:@"from"]objectForKey:@"username"]);
    NSString *text = [temp_twitter objectForKey:@"text"];
    NSMutableAttributedString *temp = [[NSMutableAttributedString alloc] initWithString:text];
    cell.tweet.attributedText = [self returnTwitterAttributedText:temp];
    
    
    cell.tweet.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.5f];
    // NSString *user_id = [[temp_twitter[path]objectForKey:@"user"]objectForKey:@"id"];
    NSString *profile_picture = [[temp_twitter objectForKey:@"user"]objectForKey:@"profile_image_url_https"];
    profile_picture = [profile_picture stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"];
//    cell.profile_picture_image_view.imageURL =[NSURL URLWithString:profile_picture];
        [cell.profile_picture_image_view setImageWithURL:[NSURL URLWithString:profile_picture]
                                        placeholderImage:[UIImage imageNamed:@"insta_placeholder.png"]];
    NSString *full_name = [[temp_twitter objectForKey:@"user"]objectForKey:@"name"];
    NSString *username = [[temp_twitter objectForKey:@"user"]objectForKey:@"screen_name"];
    NSString *created_at = [temp_twitter objectForKey:@"created_at"];
    NSString *twit_id_temp = [temp_twitter objectForKey:@"id"];
    NSString *twit_id = [NSString stringWithFormat:@"%@", twit_id_temp];
    
    
    //    NSString *media_url = [[[temp_twitter objectForKey:@"entities"] objectForKey:@"media"]objectForKey:@"media_url"];
    
    //    NSLog(@"media_url = ", media_url);
    
    cell.twitter_media_id = twit_id;
    cell.original_twitter_media_id = cell.twitter_media_id;
    
    NSString *favorite_count = [temp_twitter objectForKey:@"favorite_count"];
    NSString *is_favorite = [temp_twitter objectForKey:@"favorited"];
    NSString *is_favorited = [NSString stringWithFormat:@"%@", is_favorite];
    cell.favorited = is_favorited;
    if([cell.favorited isEqualToString:@"0"]){
        cell.fav_image.image = [UIImage imageNamed:@"fav.png"];
    }else{
        cell.fav_image.image = [UIImage imageNamed:@"yellow_fav.png"];
    }
    
    NSString *is_retweet = [temp_twitter objectForKey:@"retweeted"];
    NSString *is_retweeted = [NSString stringWithFormat:@"%@", is_retweet];
    cell.retweeted = is_retweeted;
    if([cell.retweeted isEqualToString:@"0"]){
        cell.retweet_image.image = [UIImage imageNamed:@"reweet.png"];
    }else{
        cell.retweet_image.image = [UIImage imageNamed:@"green_reweet.png"];
    }
    
    NSString *temp_favs = [NSString stringWithFormat:@"%@", favorite_count];
    if(![temp_favs isEqualToString:@"0"]){
        cell.favorites.text = temp_favs;
    }else{
        
    }
    NSString *retweet_count = [temp_twitter objectForKey:@"retweet_count"];
    
    NSString *retweet_favs = [NSString stringWithFormat:@"%@", retweet_count];
    if(![retweet_favs isEqualToString:@"0"]){
        cell.retweets.text = retweet_favs;
    }
    
    
    full_name = [full_name stringByAppendingString:@" "];
    full_name = [full_name stringByAppendingString:@"@"];
    full_name = [full_name stringByAppendingString:username];
    
    
    NSMutableAttributedString *temp_user = [[NSMutableAttributedString alloc] initWithString:full_name];
    cell.username.attributedText = [self returnTwitterUsername:temp_user];
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *tweetCreatedDate = [dateFormatter dateFromString:created_at];
    NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:tweetCreatedDate];
    double seconds = 1;
    double minutes = 60;
    double hours = minutes*60;
    double days = hours * 24;
    double weeks = days * 7;
    NSInteger secondsBetweenDates = distanceBetweenDates;
    NSInteger minutesBetweenDates = distanceBetweenDates / minutes;
    NSInteger hoursBetweenDates = distanceBetweenDates / hours;
    NSInteger daysBetweenDates = distanceBetweenDates / days;
    NSInteger weeksBetweenDates = distanceBetweenDates / weeks;
    NSString *created_time = created_at;
    if(secondsBetweenDates < 60){
        created_time = [NSString stringWithFormat:@"%d", secondsBetweenDates];
        created_time = [created_time stringByAppendingString:@"s"];
        NSLog(@"%d", secondsBetweenDates);
    }else
        if(minutesBetweenDates < 60){
            created_time = [NSString stringWithFormat:@"%d", minutesBetweenDates];
            created_time = [created_time stringByAppendingString:@"m"];
        }else
            if(hoursBetweenDates < 24){
                created_time = [NSString stringWithFormat:@"%d", hoursBetweenDates];
                created_time = [created_time stringByAppendingString:@"h"];
            }else
                if(daysBetweenDates < 7){
                    created_time = [NSString stringWithFormat:@"%d", daysBetweenDates];
                    created_time = [created_time stringByAppendingString:@"d"];
                }
                else{
                    created_time = [NSString stringWithFormat:@"%d", weeksBetweenDates];
                    created_time = [created_time stringByAppendingString:@"w"];
                }
    
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.5f];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGRect size = [text
                   boundingRectWithSize:CGSizeMake(screenWidth-65-75, 500)
                   options:NSStringDrawingUsesLineFragmentOrigin
                   attributes:@{
                                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:14.5f]
                                }
                   context:nil]; // default mode
    float numberOfLines = size.size.height / font.lineHeight;
    int addedHeight = (int)numberOfLines * (int)font.lineHeight;
    int addedPhoto = 0;
    if([[temp_twitter objectForKey:@"entities"] objectForKey:@"media"] != nil) {
        addedPhoto = 120;
        NSArray *media_url_array = [[[temp_twitter objectForKey:@"entities"] objectForKey:@"media"] valueForKey:@"media_url"];
        NSString *media_url = [media_url_array objectAtIndex:0];
        //        NSLog(@"%@",media_url);
        cell.optionalImage.imageURL = [NSURL URLWithString:media_url];
        
        cell.optionalImage.frame = CGRectMake(cell.tweet.frame.origin.x, cell.tweet.frame.origin.y+addedHeight, 240, 120);
        
        [cell.optionalImage setContentMode:UIViewContentModeScaleAspectFill];
        [cell.optionalImage setClipsToBounds:YES];
        cell.optionalImage.layer.cornerRadius = 5;
    }
    // NSLog(@"%@ - %f", username, numberOfLines);
    cell.time_label.text = created_time;
    //NSString  *created_time = [temp_twitter[(int)indexPath.row]valueForKey:@"created_time"];
    CGRect footer_frame = cell.interact_footer.frame;
    
    footer_frame.origin.y = cell.tweet.frame.origin.y+addedHeight+addedPhoto;
    
    cell.interact_footer.frame = footer_frame;
//    
//    UITapGestureRecognizer *favTap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(twitFavTap:)];
//    favTap.numberOfTapsRequired = 1;
//    cell.fav_image.userInteractionEnabled = YES;
//    [cell.fav_image addGestureRecognizer:favTap];
//    
//    
//    UITapGestureRecognizer *retweet_sheet = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(loadRetweetSheet:)];
//    cell.retweet_image.userInteractionEnabled = YES;
//    [cell.retweet_image addGestureRecognizer:retweet_sheet];
//    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
//    [gr setNumberOfTapsRequired:1];
//    [cell.tweet addGestureRecognizer:gr];
//    
//    UITapGestureRecognizer *twitterCompose = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(loadTwitterCompose:)];
//    cell.reply_image.userInteractionEnabled = YES;
//    [cell.reply_image addGestureRecognizer:twitterCompose];
//    
//    UITapGestureRecognizer *prof_pic_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profile_from_twitter_tap:)];
//    cell.profile_picture_image_view.userInteractionEnabled = YES;
//    
//    [cell.profile_picture_image_view addGestureRecognizer:prof_pic_tap];
//    
//    UITapGestureRecognizer *prof_user_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profile_from_user_twitter_tap:)];
//    cell.username.userInteractionEnabled = YES;
//    [cell.username setScrollEnabled:NO];
//    [cell.username addGestureRecognizer:prof_user_tap];
    
    return cell;
}
+(NSMutableAttributedString *)returnTwitterAttributedText:(NSMutableAttributedString *)text{
    //NSLog(@"%@",text);
    NSString *converted = [text string];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
    NSRegularExpression *regexAt = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
    NSRegularExpression *regexhttp = [NSRegularExpression regularExpressionWithPattern:@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+" options:0 error:&error];
    NSArray *matchesAt = [regexAt matchesInString:converted options:0 range:NSMakeRange(0, converted.length)];
    NSArray *matches = [regex matchesInString:converted options:0 range:NSMakeRange(0, converted.length)];
    NSArray *matchesHttp = [regexhttp matchesInString:converted options:0 range:NSMakeRange(0, converted.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange wordRange = [match rangeAtIndex:1];
        NSString* word = [converted substringWithRange:wordRange];
        // NSLog(@"Found tag %@", word);
    }
    for (NSTextCheckingResult *match in matchesAt) {
        NSRange wordRange = [match rangeAtIndex:1];
        NSString* word = [converted substringWithRange:wordRange];
        // NSLog(@"Found tag %@", word);
    }
    for (NSTextCheckingResult *match in matchesHttp) {
        NSRange wordRange = [match rangeAtIndex:1];
        NSString* word = [converted substringWithRange:wordRange];
        // NSLog(@"Found tag %@", word);
    }
    NSRange range = NSMakeRange(0,text.length);
    
    [regex enumerateMatchesInString:converted options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange subStringRange = [result rangeAtIndex:0];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed: 81/255.0 green: 127/255.0 blue:164/255.0 alpha: 1.0] range:subStringRange];
        [text addAttribute:@"hashtag" value:@"1" range:subStringRange];
    }];
    [regexAt enumerateMatchesInString:converted options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange subStringRange = [result rangeAtIndex:0];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed: 81/255.0 green: 127/255.0 blue:164/255.0 alpha: 1.0] range:subStringRange];
    }];
    [regexhttp enumerateMatchesInString:converted options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange subStringRange = [result rangeAtIndex:0];
        [text addAttribute:NSLinkAttributeName value:[UIColor colorWithRed: 81/255.0 green: 127/255.0 blue:164/255.0 alpha: 1.0] range:subStringRange];
        
    }];
    
    [[text mutableString] replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSCaseInsensitiveSearch range:NSMakeRange(0, text.string.length)];
    
    return text;
}
+(NSMutableAttributedString *)returnTwitterUsername:(NSMutableAttributedString *)text{
    //NSLog(@"%@",text);
    NSString *converted = [text string];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
    NSArray *matches = [regex matchesInString:converted options:0 range:NSMakeRange(0, converted.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange wordRange = [match rangeAtIndex:1];
        NSString* word = [converted substringWithRange:wordRange];
        // NSLog(@"Found tag %@", word);
    }
    NSRange range = NSMakeRange(0,text.length);
    
    [regex enumerateMatchesInString:converted options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange subStringRange = [result rangeAtIndex:0];
        [text addAttribute:NSFontAttributeName
                     value:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.5f]
                     range:subStringRange];
        
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:1] range:subStringRange];
        
    }];
    
    
    return text;
}

+(CGFloat)tableView:(UITableView *)tableView heightForInstagram:(NSIndexPath *)indexPath singleton:(NSMutableArray *)singleton_universal{
    UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0f];
    
    int commentsHeight = (int)font.lineHeight;
    
    int path = indexPath.row;
    
    NSDictionary *temp_instagram = [[singleton_universal objectAtIndex:path] objectForKey:@"entry"];
    
    NSDictionary *data = temp_instagram;
    NSString *username = [[data objectForKey:@"user"]objectForKey:@"username"];
    NSString *text = @"";
    
    NSArray *caption = [data objectForKey:@"caption"];
    if(caption != (id)[NSNull null]){
        text = [[data objectForKey:@"caption"]objectForKey:@"text"];
        
        username = [username stringByAppendingString:@" "];
        text = [username stringByAppendingString:text];
    }
    NSString *comments_string = @"";
    
    NSArray *comments = [data objectForKey:@"comments"];
    if(comments != (id)[NSNull null]){
        
        NSString *count_of_comments= @"view all ";
        NSString *counts = [[temp_instagram objectForKey:@"comments"]valueForKey:@"count"];
        NSString *temp_counts = [NSString stringWithFormat:@"%@", counts];
        count_of_comments =[count_of_comments stringByAppendingString:temp_counts];
        count_of_comments = [count_of_comments stringByAppendingString:@" comments"];
        
        if([temp_counts isEqualToString:@"0"]){
            count_of_comments = @"";
            comments_string = @"";
        }else{
            NSArray  *last_comments = [[temp_instagram objectForKey:@"comments"]objectForKey:@"data"];
            NSArray* reversedArray = [[last_comments reverseObjectEnumerator] allObjects];
            last_comments = reversedArray;
            int count = [last_comments count];
            
            
            for(NSDictionary *data in last_comments){
                if(count == [last_comments count] - 2){
                    NSString *comment_username = [[data objectForKey:@"from"]objectForKey:@"username"];
                    NSString *comment_text = [data objectForKey:@"text"];
                    comments_string = [comments_string stringByAppendingString:comment_username];
                    comments_string = [comments_string stringByAppendingString:@" "];
                    comments_string = [comments_string stringByAppendingString:comment_text];
                    comments_string = [comments_string stringByAppendingString:@"\n"];
                    count--;
                }
                if(count == [last_comments count] - 1){
                    NSString *comment_username = [[data objectForKey:@"from"]objectForKey:@"username"];
                    NSString *comment_text = [data objectForKey:@"text"];
                    comments_string = [comments_string stringByAppendingString:comment_username];
                    comments_string = [comments_string stringByAppendingString:@" "];
                    comments_string = [comments_string stringByAppendingString:comment_text];
                    comments_string = [comments_string stringByAppendingString:@"\n"];
                    count--;
                }
                if(count == [last_comments count]){
                    NSString *comment_username = [[data objectForKey:@"from"]objectForKey:@"username"];
                    NSString *comment_text = [data objectForKey:@"text"];
                    comments_string = [comments_string stringByAppendingString:comment_username];
                    comments_string = [comments_string stringByAppendingString:@" "];
                    comments_string = [comments_string stringByAppendingString:comment_text];
                    comments_string = [comments_string stringByAppendingString:@"\n"];
                    count--;
                }
                
            }
            
        }
    }
    
    int addedHeight = [CreationFunctions returnCommentsHeight:indexPath textString:text];
    int threeCommentsHeight = [CreationFunctions returnCommentsHeight:indexPath textString:comments_string];
    return 450+addedHeight+commentsHeight+threeCommentsHeight;
    
}
+(CGFloat)tableView:(UITableView *)tableView heightForBlog:(NSIndexPath *)indexPath singleton:(NSMutableArray *)singleton_universal{
//    BlogCell *t = [tableView cellForRowAtIndexPath:indexPath];
    BlogCell *t = (BlogCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    
    
    return 400;
    
}


+(int)returnCommentsHeight:(NSIndexPath*)indexPath textString:(NSString *)text {
    int addedHeight;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.5f];
    
    CGSize size = [text sizeWithFont:font
                   constrainedToSize:CGSizeMake(screenWidth-40, 1000)
                       lineBreakMode:UILineBreakModeWordWrap]; // default mode
    float numberOfLines = size.height / font.lineHeight;
    addedHeight = (int)numberOfLines * (int)font.lineHeight;
    
    
    return addedHeight;
    
}
+(CGFloat)tableView:(UITableView *)tableView heightForTwitter:(NSIndexPath *)indexPath singleton:(NSMutableArray *)singleton_universal{
    int addedHeight;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    int path = indexPath.row;
    
    NSDictionary *temp_twitter = [[singleton_universal objectAtIndex:path] objectForKey:@"entry"];
    
    NSString *text = [temp_twitter objectForKey:@"text"];
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.5f];
    
    CGRect size = [text
                   boundingRectWithSize:CGSizeMake(screenWidth-65-75, 500)
                   options:NSStringDrawingUsesLineFragmentOrigin
                   attributes:@{
                                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:14.5f]
                                }
                   context:nil]; // default mode
    float numberOfLines = size.size.height / font.lineHeight;
    addedHeight = (int)numberOfLines * (int)font.lineHeight;
    int addedPhoto = 0;
    if([[temp_twitter objectForKey:@"entities"] objectForKey:@"media"] != nil) {
        addedPhoto = 120;
    }
    
    return 30+addedHeight+20 + addedPhoto;
    
}
+(InstagramCell *)createInstagramCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath singleton:(NSMutableArray *)singleton_universal{
    
    // Similar to UITableViewCell, but
    InstagramCell *cell = [[InstagramCell alloc] init];
    
    // Just want to test, so I hardcode the data
    
    int path = indexPath.row;
    
    //    NSDictionary *temp_instagram = [singleton_universal.universal_feed_array objectAtIndex:path];
    NSDictionary *temp_instagram = [[singleton_universal objectAtIndex:path] objectForKey:@"entry"];
//    NSLog(@"%@", temp_instagram);
    //NSArray *temp_instagram = [singleton_universal.universal_feed objectForKey:@"instagram_entry"];
    
    //NSLog(@"%@", [temp_instagram objectAtIndex:(int)indexPath.row]);
    
    //NSLog(@"%@", [[[temp_instagram[(int)indexPath.row]objectForKey:@"caption"]objectForKey:@"from"]objectForKey:@"username"]);
    NSString *username = [[temp_instagram objectForKey:@"user"]objectForKey:@"username"];
    NSString *user_id = [[temp_instagram objectForKey:@"user"]objectForKey:@"id"];
    NSString *profile_picture = [[temp_instagram objectForKey:@"user"]objectForKey:@"profile_picture"];
    NSString *full_name = [[temp_instagram objectForKey:@"user"]objectForKey:@"full_name"];
    NSString  *created_time = [temp_instagram valueForKey:@"created_time"];
    NSString *get_media_id = [temp_instagram valueForKey:@"id"];
//    NSString *user_has_liked = [temp_instagram valueForKey:@"user_has_liked"];
    
//    cell.media_id = get_media_id;
//    cell.user_id = user_id;
    
    NSArray *caption = [temp_instagram objectForKey:@"caption"];
    if(caption != (id)[NSNull null]){
        NSString *text = [[temp_instagram objectForKey:@"caption"]objectForKey:@"text"];
        NSString  *photo_id = [[temp_instagram objectForKey:@"caption"] objectForKey:@"id"];
        
        username = [username stringByAppendingString:@" "];
        text = [username stringByAppendingString:text];
        
        NSMutableAttributedString *attributed_caption = [[NSMutableAttributedString alloc] initWithString:text];
        cell.image_caption.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.5f];
        [attributed_caption addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed: 81/255.0 green: 127/255.0 blue:164/255.0 alpha: 1.0] range:NSMakeRange(0,[username length])];
        [attributed_caption addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"Arial-BoldMT" size:13.8f]
                                   range:NSMakeRange(0, [username length])];
        [attributed_caption addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.5f]
                                   range:NSMakeRange([username length], [attributed_caption length]-[username length])];
        
        cell.image_caption.attributedText = [CreationFunctions returnInstagramAttributedText:attributed_caption];
        cell.image_caption.hidden = NO;
        cell.small_chat.hidden = NO;
    }else{
        NSString *username = @"";
        username = [username stringByAppendingString:@" "];
        NSString *text = @"";
        text = [username stringByAppendingString:text];
        
        cell.image_caption.text = text;
        //cell.time.text = @"";
        //cell.time.hidden = YES;
        cell.image_caption.hidden = YES;
        cell.small_chat.hidden = YES;
        //NSLog(@"here");
    }
    //[cell.image_caption sizeToFit];
    //[cell.image_caption layoutIfNeeded];
    float contentHeight =  cell.image_caption.contentSize.height;
    
    
    NSString *low_res= [[[temp_instagram objectForKey:@"images"]objectForKey:@"low_resolution"]objectForKey:@"url"];
    NSString *std_res = [[[temp_instagram objectForKey:@"images"]objectForKey:@"standard_resolution"]objectForKey:@"url"];
    
    
    NSString  *likes_count = [[temp_instagram objectForKey:@"likes"]valueForKey:@"count"];
    
    
    NSArray  *comments = [temp_instagram objectForKey:@"comments"];
    
    NSString *comments_string = @"";
    
    NSMutableAttributedString *comment_attributed = [[NSMutableAttributedString alloc] initWithString:comments_string];
    
    cell.comments_text.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.5f];
    
    if(comments != (id)[NSNull null]){
        
        NSString *count_of_comments= @"view all ";
        NSString *counts = [[temp_instagram objectForKey:@"comments"]valueForKey:@"count"];
        NSString *temp_counts = [NSString stringWithFormat:@"%@", counts];
        count_of_comments =[count_of_comments stringByAppendingString:temp_counts];
        count_of_comments = [count_of_comments stringByAppendingString:@" comments"];
        
        if([temp_counts isEqualToString:@"0"]){
            count_of_comments = @"";
        }else{
            NSArray  *last_comments = [[temp_instagram objectForKey:@"comments"]objectForKey:@"data"];
            NSArray* reversedArray = [[last_comments reverseObjectEnumerator] allObjects];
            last_comments = reversedArray;
            int count = [last_comments count];
            
            for(NSDictionary *data in last_comments){
                if(count == [last_comments count] - 2){
                    NSString *comment_username = [[data objectForKey:@"from"]objectForKey:@"username"];
                    NSString *comment_text = [data objectForKey:@"text"];
                    comments_string = [comments_string stringByAppendingString:comment_username];
                    comments_string = [comments_string stringByAppendingString:@" "];
                    comments_string = [comments_string stringByAppendingString:comment_text];
                    comments_string = [comments_string stringByAppendingString:@"\n"];
                    
                    NSAttributedString *attr_user = [[NSAttributedString alloc] initWithString:comment_username attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed: 81/255.0 green: 127/255.0 blue:164/255.0 alpha: 1.0], NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:13.8f]}];
                    NSAttributedString *attr_comment = [[NSAttributedString alloc] initWithString:comment_text attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.5f]}];
                    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
                    NSAttributedString *nl = [[NSAttributedString alloc] initWithString:@"\n"];
                    
                    
                    [comment_attributed insertAttributedString:attr_user atIndex:0];
                    [comment_attributed insertAttributedString:space atIndex:[attr_user length]];
                    [comment_attributed insertAttributedString:attr_comment atIndex:[attr_user length]+[space length]];
                    [comment_attributed insertAttributedString:nl atIndex:[attr_comment length]+[attr_user length] + [space length]];
                    
                    count--;
                }
                if(count == [last_comments count] - 1){
                    NSString *comment_username = [[data objectForKey:@"from"]objectForKey:@"username"];
                    NSString *comment_text = [data objectForKey:@"text"];
                    comments_string = [comments_string stringByAppendingString:comment_username];
                    comments_string = [comments_string stringByAppendingString:@" "];
                    comments_string = [comments_string stringByAppendingString:comment_text];
                    comments_string = [comments_string stringByAppendingString:@"\n"];
                    NSAttributedString *attr_user = [[NSAttributedString alloc] initWithString:comment_username attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed: 81/255.0 green: 127/255.0 blue:164/255.0 alpha: 1.0], NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:13.8f]}];
                    NSAttributedString *attr_comment = [[NSAttributedString alloc] initWithString:comment_text attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.5f]}];
                    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
                    NSAttributedString *nl = [[NSAttributedString alloc] initWithString:@"\n"];
                    
                    
                    [comment_attributed insertAttributedString:attr_user atIndex:0];
                    [comment_attributed insertAttributedString:space atIndex:[attr_user length]];
                    [comment_attributed insertAttributedString:attr_comment atIndex:[attr_user length]+[space length]];
                    [comment_attributed insertAttributedString:nl atIndex:[attr_comment length]+[attr_user length] + [space length]];
                    
                    count--;
                }
                if(count == [last_comments count]){
                    NSString *comment_username = [[data objectForKey:@"from"]objectForKey:@"username"];
                    NSString *comment_text = [data objectForKey:@"text"];
                    comments_string = [comments_string stringByAppendingString:comment_username];
                    comments_string = [comments_string stringByAppendingString:@" "];
                    comments_string = [comments_string stringByAppendingString:comment_text];
                    comments_string = [comments_string stringByAppendingString:@"\n"];
                    NSAttributedString *attr_user = [[NSAttributedString alloc] initWithString:comment_username attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed: 81/255.0 green: 127/255.0 blue:164/255.0 alpha: 1.0], NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:13.8f]}];
                    NSAttributedString *attr_comment = [[NSAttributedString alloc] initWithString:comment_text attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.5f]}];
                    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
                    NSAttributedString *nl = [[NSAttributedString alloc] initWithString:@"\n"];
                    
                    
                    [comment_attributed insertAttributedString:attr_user atIndex:0];
                    [comment_attributed insertAttributedString:space atIndex:[attr_user length]];
                    [comment_attributed insertAttributedString:attr_comment atIndex:[attr_user length]+[space length]];
                    [comment_attributed insertAttributedString:nl atIndex:[attr_comment length]+[attr_user length] + [space length]];
                    count--;
                }
                
            }
            
        }
        cell.comments_count.text = count_of_comments;
        
        cell.comments_text.attributedText = [CreationFunctions returnInstagramAttributedText:comment_attributed];
        cell.comments_count.hidden = NO;
        cell.comments_text.hidden = NO;
    }else{
        cell.comments_count.hidden = YES;
        cell.comments_text.hidden = YES;
    }
    
    //NSLog(@"%d", (int)indexPath.row);
    //cell.textLabel.text = text;
    cell.username.text = username;
//    cell.profile_picture_image_view.imageURL =[NSURL URLWithString:profile_picture];
//    cell.main_picture_view.imageURL =[NSURL URLWithString:std_res];
    
        [cell.profile_picture_image_view setImageWithURL:[NSURL URLWithString:profile_picture]
                                    placeholderImage:[UIImage imageNamed:@"insta_placeholder.png"]];
        [cell.main_picture_view setImageWithURL:[NSURL URLWithString:std_res]
                               placeholderImage:[UIImage imageNamed:@"insta_placeholders.png"]];
    NSString *temp_likes = [NSString stringWithFormat:@"%@", likes_count];
    temp_likes = [temp_likes stringByAppendingString:@" likes"];
    cell.photo_likes.text = temp_likes;
    cell.caption_username.text = username;
    
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSTimeInterval epoch = [created_time doubleValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:epoch];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSDate *now = [NSDate date];
    NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:date];
    
    double seconds = 1;
    double minutes = 60;
    double hours = minutes*60;
    double days = hours * 24;
    double weeks = days * 7;
    NSInteger secondsBetweenDates = distanceBetweenDates;
    NSInteger minutesBetweenDates = distanceBetweenDates / minutes;
    NSInteger hoursBetweenDates = distanceBetweenDates / hours;
    NSInteger daysBetweenDates = distanceBetweenDates / days;
    NSInteger weeksBetweenDates = distanceBetweenDates / weeks;
    if(secondsBetweenDates < 60){
        created_time = [NSString stringWithFormat:@"%d", secondsBetweenDates];
        created_time = [created_time stringByAppendingString:@"s"];
        NSLog(@"%d", secondsBetweenDates);
    }else
        if(minutesBetweenDates < 60){
            created_time = [NSString stringWithFormat:@"%d", minutesBetweenDates];
            created_time = [created_time stringByAppendingString:@"m"];
        }else
            if(hoursBetweenDates < 24){
                created_time = [NSString stringWithFormat:@"%d", hoursBetweenDates];
                created_time = [created_time stringByAppendingString:@"h"];
            }else
                if(daysBetweenDates < 7){
                    created_time = [NSString stringWithFormat:@"%d", daysBetweenDates];
                    created_time = [created_time stringByAppendingString:@"d"];
                }
                else{
                    created_time = [NSString stringWithFormat:@"%d", weeksBetweenDates];
                    created_time = [created_time stringByAppendingString:@"w"];
                }
    
    cell.time.text = created_time;
    
    UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0f];
    
    
    NSDictionary *data = [[singleton_universal objectAtIndex:path] objectForKey:@"entry"];
    NSString *text = @"";
    
    if(caption != (id)[NSNull null]){
        text = [[data objectForKey:@"caption"]objectForKey:@"text"];
        
        username = [username stringByAppendingString:@" "];
        text = [username stringByAppendingString:text];
    }
    
    
    int threeCommentsHeight = [self returnCommentsHeight:indexPath textString:comments_string];
    
    int commentsHeight = (int)font.lineHeight;
    CGRect frame = cell.image_caption.frame;
    frame.origin.y = [self returnCommentsHeight:indexPath textString:text]+commentsHeight+385;
    frame.size.height = commentsHeight;
    frame.origin.x = 25;
    cell.comments_count.frame = frame;
    
    CGRect comments_frame = cell.comments_text.frame;
    comments_frame.origin.y = cell.comments_count.frame.origin.y+commentsHeight-5;
    comments_frame.size.height = threeCommentsHeight+10;
    comments_frame.origin.x = 20;
    cell.comments_text.frame = comments_frame;
    cell.comments_text.backgroundColor = [UIColor clearColor];
    
    
    NSArray  *commentsD = [[temp_instagram objectForKey:@"comments"]objectForKey:@"data"];
    if(commentsD != (id)[NSNull null]){
        if([commentsD count] != 0){
            CGRect footer_frame = cell.foot.frame;
            footer_frame.origin.y = cell.comments_text.frame.origin.y+cell.comments_text.frame.size.height+10;
            footer_frame.origin.x = 5;
            cell.foot.frame = footer_frame;
        }else{
            CGRect footer_frame = cell.foot.frame;
            footer_frame.origin.y = cell.comments_count.frame.origin.y;
            footer_frame.origin.x = 5;
            cell.foot.frame = footer_frame;
        }
        
    }
    
    
//    UITapGestureRecognizer *commentView = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(loadCommentView:)];
//    UITapGestureRecognizer *commentViewMain = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(loadCommentViewMiddle:)];
//    cell.foot_comment.userInteractionEnabled = YES;
//    [cell.foot_comment addGestureRecognizer:commentView];
//    [cell.comments_count setUserInteractionEnabled:YES];
//    [cell.comments_count addGestureRecognizer:commentViewMain];
//    
//    
//    
//    [cell.comments_text setUserInteractionEnabled:YES];
//    [cell.comments_text setScrollEnabled:NO];
//    [cell.comments_text setEditable:NO];
//    //    [cell.comments_text addGestureRecognizer:gr];
//    //    [cell.comments_text setBackgroundColor:[UIColor blackColor]];
//    
//    UITapGestureRecognizer *prof_pic_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profile_from_instagram_tap:)];
//    cell.profile_picture_image_view.userInteractionEnabled = YES;
//    
//    [cell.profile_picture_image_view addGestureRecognizer:prof_pic_tap];
//    
//    UITapGestureRecognizer *prof_user_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profile_from_user_instagram_tap:)];
//    cell.username.userInteractionEnabled = YES;
//    //    [cell.username setScrollEnabled:NO];
//    [cell.username addGestureRecognizer:prof_user_tap];
//    
//    NSString *uhl = [NSString stringWithFormat:@"%@", user_has_liked];
//    if([uhl isEqualToString:@"1"]){
//        [cell.like setBackgroundColor:[UIColor grayColor]];
//        [cell.like_label setText:@"Liked"];
//        [cell.like_label setTextColor:[UIColor whiteColor]];
//        [cell.like_image setImage:[UIImage imageNamed:@"heart_tumblr.png"]];
//    }
//    
//    UIView *t = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [t setUserInteractionEnabled:YES];
//    [t setBackgroundColor:[UIColor blueColor]];
//    //    [t addGestureRecognizer:gr];
//    //    [cell addSubview:t];
//    
//    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTappedInsta:)];
//    [gr setNumberOfTapsRequired:1];
//    [cell.image_caption addGestureRecognizer:gr];
    
    return cell;
}
+(BlogCell *)createBlogCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath singleton:(NSMutableArray *)singleton_universal{
    
    // Similar to UITableViewCell, but
    BlogCell *cell = [[BlogCell alloc] init];
    
    // Just want to test, so I hardcode the data
    
    int path = indexPath.row;
    
    //    NSDictionary *temp_instagram = [singleton_universal.universal_feed_array objectAtIndex:path];
    NSDictionary *temp_blog = [singleton_universal objectAtIndex:path];
    //    NSLog(@"%@", temp_instagram);
    NSString *content = [temp_blog objectForKey:@"content"];
//    cell.webview.delegate = self;
    cell.webview.userInteractionEnabled = YES;
    cell.webview.scalesPageToFit = YES;
    cell.webview.scrollView.bounces = NO;
//    cell.webview.scrollView.scrollEnabled = NO;

//    cell.webview.scrollView.bounces = NO;

//    cell.web
    

    NSString *htmlString = [NSString stringWithFormat:@"<body><style>  a:link { color:#000; text-decoration:underline; } img{padding-top:10px; padding-bottom:10px;}</style> <span style=\"font-size: %i;\">%@</span>",
                            (int) 20,
                            content];
    
    [cell.webview loadHTMLString:htmlString baseURL:nil];
    
//    
    
    return cell;
}


+(NSMutableAttributedString *)returnInstagramAttributedText:(NSMutableAttributedString *)text{
    //NSLog(@"%@",text);
    NSString *converted = [text string];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
    NSRegularExpression *regexAt = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
    NSArray *matchesAt = [regexAt matchesInString:converted options:0 range:NSMakeRange(0, converted.length)];
    NSArray *matches = [regex matchesInString:converted options:0 range:NSMakeRange(0, converted.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange wordRange = [match rangeAtIndex:1];
        NSString* word = [converted substringWithRange:wordRange];
        // NSLog(@"Found tag %@", word);
    }
    for (NSTextCheckingResult *match in matchesAt) {
        NSRange wordRange = [match rangeAtIndex:1];
        NSString* word = [converted substringWithRange:wordRange];
        // NSLog(@"Found tag %@", word);
    }
    NSRange range = NSMakeRange(0,text.length);
    
    [regex enumerateMatchesInString:converted options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange subStringRange = [result rangeAtIndex:0];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed: 81/255.0 green: 127/255.0 blue:164/255.0 alpha: 1.0] range:subStringRange];
    }];
    [regexAt enumerateMatchesInString:converted options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange subStringRange = [result rangeAtIndex:0];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed: 81/255.0 green: 127/255.0 blue:164/255.0 alpha: 1.0] range:subStringRange];
    }];
    return text;
}
+(TumblrCell *)createTumblrCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath singleton:(NSMutableArray *)singleton_universal{
    
    // Similar to UITableViewCell, but
    TumblrCell *cell = [[TumblrCell alloc] init];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Just want to test, so I hardcode the data
    
    int path = indexPath.row;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //    NSDictionary *temp_tumblr = [singleton_universal.universal_feed_array objectAtIndex:path];
    NSDictionary *temp_tumblr = [[singleton_universal objectAtIndex:path] objectForKey:@"entry"];
    
    NSString *username = [temp_tumblr objectForKey:@"blog_name"];
    NSString *caption = [temp_tumblr objectForKey:@"caption"];
    NSDictionary *photos = [temp_tumblr objectForKey:@"photos"];
    NSArray *tags = [temp_tumblr objectForKey:@"tags"];
    NSString *note_count = [[temp_tumblr objectForKey:@"note_count"] stringValue];
    //NSDate *date = [temp_tumblr objectForKey:@"date"];
    NSString *liked = [[temp_tumblr objectForKey:@"liked"] stringValue];
    cell.liked = liked;
    cell.post_url = [temp_tumblr objectForKey:@"post_url"];
    
    NSArray *reblog_key = [temp_tumblr objectForKey:@"reblog_key"];
    NSString *tumblr_id = [[temp_tumblr objectForKey:@"id"] stringValue];
    
    cell.reblog_key = reblog_key;
    cell.unique_id = tumblr_id;
    
    cell.username.text = username;
    note_count = [note_count stringByAppendingString:@" notes"];
    cell.notes_label.text = note_count;
    UIScrollView *tag_scroll_view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
    int content_width = 0;
    int last_width = 10;
    int final_width = 0;
    
    for(int i = 0; i < [tags count]; i ++){
        UILabel *temp_tag = [[UILabel alloc] initWithFrame:CGRectMake(last_width, 0, 0, 20)];
        [temp_tag setTextColor:[UIColor lightGrayColor]];
        temp_tag.font =[UIFont fontWithName:@"Helvetica-Light" size:14.0f];
        NSString *hashtag = [@"#" stringByAppendingString:[tags objectAtIndex:i]];
        temp_tag.text = hashtag;
        
        CGSize stringSize = [temp_tag.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14.0f]];
        CGFloat width = stringSize.width;
        CGRect new_frame = temp_tag.frame;
        new_frame.size.width = width;
        temp_tag.frame = new_frame;
        [tag_scroll_view addSubview:temp_tag];
        
        UITapGestureRecognizer  *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTappedTumblr:)];
        [temp_tag setUserInteractionEnabled:YES];
        [temp_tag addGestureRecognizer:gr];
        
        //        temp_tag.contentMode = UIViewContentModeScaleAspectFit;
        last_width += width+10;
    }
    
    NSString *base  =@"http://api.tumblr.com/v2/blog/";
    base = [base stringByAppendingString:username];
    base = [base stringByAppendingString:@".tumblr.com/avatar/96"];
    base = [base stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //
//    cell.profile_image_view.imageURL =[NSURL URLWithString:base];
        [cell.profile_image_view setImageWithURL:[NSURL URLWithString:base]
                                        placeholderImage:[UIImage imageNamed:@"insta_placeholder.png"]];
    
    
    NSMutableArray *sources_for_widths_array = [[NSMutableArray alloc] init];
    NSMutableArray *sources_for_heights_array = [[NSMutableArray alloc] init];
    for(NSDictionary *photo in photos){
        NSMutableDictionary *sources_for_widths = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *sources_for_heights = [[NSMutableDictionary alloc] init];
        NSArray *widths = [photo objectForKey:@"alt_sizes"];
        //if([widths objectForKey:@"width"] == @"500"){
        for (int i = 0; i < [widths count]; i++){
            NSDictionary *breaks = [widths objectAtIndex:i];
            NSString *actual_width_string = [[breaks objectForKey:@"width"] stringValue];
            long actual_width = [actual_width_string longLongValue];
            
            NSString *actual_height_string = [breaks objectForKey:@"height"];
            long actual_height = [actual_height_string longLongValue];
            
            [sources_for_widths setObject:[breaks objectForKey:@"url"] forKey:actual_width_string];
            [sources_for_heights setObject:[breaks objectForKey:@"height"] forKey:actual_width_string];
            
            
        }
        [sources_for_widths_array addObject:sources_for_widths];
        [sources_for_heights_array addObject:sources_for_heights];
        
    }
    
    NSMutableArray *photo_views_array = [[NSMutableArray alloc] initWithCapacity:[photos count]];
    int end_of_photo_content = 0;
    for(int i = 0; i < [photos count]; i++){
        
        
        NSArray *keys=[[sources_for_widths_array objectAtIndex:i] allKeys];
        int intended = 500;
        int closest = 1000;
        NSString *close_string;
        for(NSString *widths in keys){
            int value = [widths intValue];
            int difference = value - intended;
            difference = abs(difference);
            
            if(difference < closest){
                close_string = widths;
            }
            
        }
        
        NSString *height =[[sources_for_heights_array objectAtIndex:i] objectForKey:close_string];
        double height_int = [height doubleValue];
        double width_int = [close_string doubleValue];
        double ratio = height_int/width_int;
        
        UIImageView *content_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60+end_of_photo_content+(10*i), screenWidth, screenWidth*ratio)];
        //        NSLog(@"we %f", 60+((screenWidth*ratio)*i)+(10*i));
        //        NSLog(@"screenwidth *ratio %f", screenWidth*ratio);
        //        NSLog(@"ratio %f", ratio);
        NSString *source_url =[[sources_for_widths_array objectAtIndex:i] objectForKey:close_string];
        
//                [content_image_view setImageWithURL:[NSURL URLWithString:source_url] placeholderImage:@"insta_placeholder.png"];
        content_image_view.imageURL = [NSURL URLWithString:source_url];
        
        [photo_views_array addObject:content_image_view];
        end_of_photo_content += content_image_view.frame.size.height;
        
    }
    end_of_photo_content += 60;
    [cell.contentView setFrame:CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, cell.contentView.frame.size.width, end_of_photo_content)];
    for(UIImageView *content_image_views in photo_views_array){
        CGRect frame = content_image_views.frame;
        [cell.contentView addSubview:content_image_views];
    }
//    NSString *myHTML = caption;
//    UIFont *font = [UIFont fontWithName:@"Helvetica-Light" size:14];
//    NSString *htmlString = [NSString stringWithFormat:@"<html><body><div id='main'><style>  a:link { color:#000; text-decoration:underline; } img{width:300px; padding-top:15px; }</style> <span style=\"font-family: %@; font-size: %i;\">%@</span>",
//                            font.fontName,
//                            (int) font.pointSize,
//                            caption];
//    htmlString = [htmlString stringByAppendingString:@"</div></body></html>"];
//    
//    //    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"string" withString:@"duck"];
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
//    //    webView.userInteractionEnabled = YES;
//    webView.delegate = self;
//    //    [webView loadHTMLString:htmlString baseURL:nil];
//    //load file into webView
////    [webView loadHTMLString:htmlString baseURL:nil];
//    //    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.ca"]]];
//    
//    NSString *innerText = [self stringByStrippingHTML:htmlString];
//    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
//                                                                forKey:NSFontAttributeName];
//    NSAttributedString *attributed_string = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
//                                                                             options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                                                       NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
//                                                                  documentAttributes:nil error:nil];
//    
//    //    UILabel *m = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1000)];
//    //    m.attributedText = attributed_string;
//    //    [cell.textView addSubview:m];
//    //NSLog(@"%@", htmlString);
//    
//    int height = [self returnTumblrMessageHeight:indexPath textString:attributed_string];
//    //    int height = webView.scrollView.contentSize.height;
//    webView.frame = CGRectMake(0, 0, screenWidth, height);
//    webView.delegate = self;
//    webView.userInteractionEnabled = NO;
//    [webView.scrollView setBounces:NO];
//    //    webView.clipsToBounds = YES;
//    
//    CGRect new_frame = cell.textView.frame;
//    new_frame.origin.y = end_of_photo_content;
//    new_frame.origin.x = 0;
//    new_frame.size.height = height;
//    new_frame.size.width = screenWidth;
//    //new_frame.size.height = webView.scrollView.contentSize.height;
//    cell.textView.frame = new_frame;
//    
//    [cell.textView setBackgroundColor:[UIColor blackColor]];
//    [cell.textView setUserInteractionEnabled:YES];
//    
//    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, height)];
//    //    [a setBackgroundColor:[UIColor blackColor]];
//    [cell.textView addSubview:a];
//    
//    
//    [a addSubview:webView];
    CGFloat height = 0;
    //    CGFloat hForT = [self tableView:tableView heightForTumblr:indexPath singleton:singleton_universal];
    
    CGRect new_frame = cell.interactView.frame;
    //    new_frame.origin.y = hForT-50;
    new_frame.origin.y = cell.contentView.frame.origin.y +cell.contentView.frame.size.height+10;
    //NSLog(@"cell height %f", cell.frame.size.height);
    new_frame.size.height = 30;
    cell.interactView.frame = new_frame;
    
    tag_scroll_view.contentSize = CGSizeMake(last_width,20);
    tag_scroll_view.userInteractionEnabled = YES;
    [tag_scroll_view setShowsVerticalScrollIndicator:NO];
    [tag_scroll_view setShowsHorizontalScrollIndicator:NO];
    tag_scroll_view.scrollEnabled = YES;
    tag_scroll_view.canCancelContentTouches = YES;
    tag_scroll_view.delegate = self;
    
    new_frame = cell.tagView.frame;
    //    new_frame.origin.y = hForT-70;
    new_frame.origin.y = cell.contentView.frame.origin.y + cell.contentView.frame.size.height-20;
    //new_frame.origin.y = 0;
    cell.tagView.frame = new_frame;
    
    //[cell.contentView addSubview:scrollView];
    //[cell.tagView setContentSize:CGSizeMake(1000, 20)];
    [cell.tagView setShowsHorizontalScrollIndicator:NO];
    [cell.tagView setShowsVerticalScrollIndicator:NO];
    [cell.tagView setUserInteractionEnabled:YES];
    [cell.tagView setBackgroundColor:[UIColor whiteColor]];
    [cell.tagView addSubview:tag_scroll_view];
    // [cell.contentView addSubview:cell.tagView];
    
    
    new_frame = cell.interactView.frame;
    new_frame.origin.y += height;
    cell.interactView.frame = new_frame;
    
    new_frame = cell.interactView.frame;
    new_frame.origin.y -= 30;
    cell.tagView.frame = new_frame;
    
    
//    
//    UITapGestureRecognizer *tumblrReblog = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(loadTumblrCompose:)];
//    cell.reblog_view.userInteractionEnabled = YES;
//    [cell.reblog_view addGestureRecognizer:tumblrReblog];
//    
//    //    UITapGestureRecognizer *tumblrLike = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(likeTumblr:)];
//    //    cell.heart_view.userInteractionEnabled = YES;
//    //    [cell.heart_view addGestureRecognizer:tumblrLike];
//    //
//    //    UITapGestureRecognizer *tumblrDoubleLike = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(likeDoubleTumblr:)];
//    //    tumblrDoubleLike.numberOfTapsRequired = 2;
//    //    cell.userInteractionEnabled = YES;
//    //    [cell addGestureRecognizer:tumblrDoubleLike];
//    
//    
//    UITapGestureRecognizer *tumblrShare = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(shareTumblr:)];
//    cell.share_view.userInteractionEnabled = YES;
//    [cell.share_view addGestureRecognizer:tumblrShare];
//    
//    UITapGestureRecognizer *prof_pic_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profile_from_tumblr_tap:)];
//    cell.profile_image_view.userInteractionEnabled = YES;
//    
//    [cell.profile_image_view addGestureRecognizer:prof_pic_tap];
//    
//    UITapGestureRecognizer *prof_user_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profile_from_user_tumblr_tap:)];
//    cell.username.userInteractionEnabled = YES;
//    //    [cell.username setScrollEnabled:NO];
//    [cell.username addGestureRecognizer:prof_user_tap];
    
    if([liked isEqualToString:@"0"]){
        cell.heart_view.image = [UIImage imageNamed:@"heart_small.png"];
    }else{
        cell.heart_view.image = [UIImage imageNamed:@"heart_tumblr.png"];
    }
    
    return cell;
}
+(NSString *)stringByStrippingHTML:(NSString*)str{
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    return str;
}
+(int)returnTumblrMessageHeight:(NSIndexPath*)indexPath textString:(NSAttributedString *)text {
    int addedHeight;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Light" size:14.0f];
    CGRect size = [text boundingRectWithSize:CGSizeMake(screenWidth, 500) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    CGRect size_text = [[text string]
                        boundingRectWithSize:CGSizeMake(screenWidth, 500)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{
                                     NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Light" size:14.0f]
                                     }
                        context:nil]; // default mode*/
    float numberOfLines = size.size.height / font.lineHeight;
    addedHeight = (int)numberOfLines * (int)font.lineHeight;
    
    
    float numberOfLines_text = size_text.size.height / font.lineHeight;
    int addedHeight_text = (int)numberOfLines * (int)font.lineHeight;
    return 0;
    return addedHeight_text;
    
}
+(CGFloat)tableView:(UITableView *)tableView heightForTumblr:(NSIndexPath *)indexPath singleton:(NSMutableArray *)singleton_universal{

    int path = indexPath.row;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    NSDictionary *temp_tumblr = [[singleton_universal objectAtIndex:path] objectForKey:@"entry"];
    
    NSString *username = [temp_tumblr objectForKey:@"blog_name"];
    NSString *caption = [temp_tumblr objectForKey:@"caption"];
    NSDictionary *photos = [temp_tumblr objectForKey:@"photos"];
    
    
    NSMutableArray *sources_for_widths_array = [[NSMutableArray alloc] init];
    NSMutableArray *sources_for_heights_array = [[NSMutableArray alloc] init];
    for(NSDictionary *photo in photos){
        NSMutableDictionary *sources_for_widths = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *sources_for_heights = [[NSMutableDictionary alloc] init];
        NSArray *widths = [photo objectForKey:@"alt_sizes"];
        //if([widths objectForKey:@"width"] == @"500"){
        for (int i = 0; i < [widths count]; i++){
            NSDictionary *breaks = [widths objectAtIndex:i];
            NSString *actual_width_string = [[breaks objectForKey:@"width"] stringValue];
            long actual_width = [actual_width_string longLongValue];
            
            NSString *actual_height_string = [breaks objectForKey:@"height"];
            long actual_height = [actual_height_string longLongValue];
            
            [sources_for_widths setObject:[breaks objectForKey:@"url"] forKey:actual_width_string];
            [sources_for_heights setObject:[breaks objectForKey:@"height"] forKey:actual_width_string];
            
            
        }
        [sources_for_widths_array addObject:sources_for_widths];
        [sources_for_heights_array addObject:sources_for_heights];
        
    }
    NSMutableArray *photo_views_array = [[NSMutableArray alloc] initWithCapacity:[photos count]];
    double photo_content_height = 0;
    for(int i = 0; i < [photos count]; i++){
        
        
        NSArray *keys=[[sources_for_widths_array objectAtIndex:i] allKeys];
        int intended = 1000;
        int closest = 1000;
        NSString *close_string;
        for(NSString *widths in keys){
            int value = [widths intValue];
            int difference = value - intended;
            difference = abs(difference);
            
            if(difference < closest){
                close_string = widths;
            }
            
        }
        
        NSString *height =[[sources_for_heights_array objectAtIndex:i] objectForKey:close_string];
        double height_int = [height doubleValue];
        double width_int = [close_string doubleValue];
        double ratio = height_int/width_int;
        photo_content_height = photo_content_height + screenWidth*ratio;
    }
    //photo_content_height += 60;
    
//    NSString *myHTML = caption;
//    UIFont *font = [UIFont fontWithName:@"Helvetica-Light" size:14];
//    NSString *htmlString = [NSString stringWithFormat:@"<body><style>  a:link { color:#000; text-decoration:underline; } img{width:300px;}</style> <span style=\"font-family: %@; font-size: %i;\">%@</span>",
//                            font.fontName,
//                            (int) font.pointSize,
//                            caption];
//    htmlString = [htmlString stringByAppendingString:@"</body>"];
//    
//    NSAttributedString *attributed_string = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
//                                                                             options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                                                       NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding), NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Light" size:14.0f]}
//                                                                  documentAttributes:nil error:nil];
    

//    int height = [self returnTumblrMessageHeight:indexPath textString:attributed_string];
    //    int height = 0;
    int height = 0;
    
    return 60+ photo_content_height + 10*[photos count] + height+20 +45+20;
    
}
@end
