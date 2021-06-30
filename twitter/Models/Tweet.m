//
//  Tweet.m
//  twitter
//
//  Created by Mary Jiang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        //is this a retweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil){ //if it comes back not null than this tweet is a retweet
            NSDictionary *userDictionary = dictionary[@"user"]; //dictionary representing the user who retweeted the tweet
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary]; //create user object for the user who retweeted the tweet
            
            dictionary = originalTweet; //change tweet to the original tweet
        }
        //put in all of the property information based on the data inside the dictionary
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        //format created at date 
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y"; //configure the input format to parse the date string
        NSDate *date = [formatter dateFromString:createdAtOriginalString]; //convert string to date
        self.createdAt = date;
    }
    return self;
}

//returns array of Tweets (the object) when intizlaied with an array of tweet dictionaries
+ (NSMutableArray *)tweetsWithArray: (NSArray *)dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for(NSDictionary *dictionary in dictionaries){ //like a for each loop, goes through each dictionary in the array dictioonaries
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary]; //create Tweet object from a dictionary
        [tweets addObject:tweet]; //add that Tweet object to the array of Tweets
    }
    return tweets;
}

@end
