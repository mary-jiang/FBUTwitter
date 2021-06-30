//
//  Tweet.h
//  twitter
//
//  Created by Mary Jiang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet : NSObject

//properties

@property (nonatomic, strong) NSString *idStr; //for favoriting (liking), rting, replying (it is the unique identifier for the twt)
@property (nonatomic, strong) NSString *text; //text content of tweet
@property (nonatomic) int favoriteCount; //update fav (liking) count label
@property (nonatomic) BOOL favorited; //configure fav (like) button
@property (nonatomic) int retweetCount; //update rewteet count label
@property (nonatomic) BOOL retweeted; //configure retweet button
@property (nonatomic, strong) User *user; //contains tweet's author's name, screenname, etc (author's user info)
@property (nonatomic, strong) NSDate *createdAt; //date tweet was created at

//for retweets
@property (nonatomic, strong) User *retweetedByUser; //user who retweeted if tweet is retweet

//methods

//initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
//returns array of Tweets (the object) when intizlaied with an array of tweet dictionaries
+ (NSMutableArray *)tweetsWithArray: (NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
