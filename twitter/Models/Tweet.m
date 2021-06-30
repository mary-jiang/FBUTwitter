//
//  Tweet.m
//  twitter
//
//  Created by Mary Jiang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "NSDate+DateTools.h"
@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        //is this a retweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil){ //if it comes back not null than this twewt is a retweet
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
        
        //format created at date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y"; //configure the input format to parse the date string
        NSDate *date = [formatter dateFromString:createdAtOriginalString]; //convert string to date
        //configure output format
        NSDate *today = [NSDate date]; //create a date to represent user's current time to compare to the date tweet was posted
        int minutes = (int)[today minutesFrom:date];
        if(minutes > 10080){ //tweet was tweeted more than a week ago
            //format MM/DD/YY for tweets tweeted that long ago
            formatter.dateStyle = NSDateFormatterShortStyle;
            formatter.timeStyle = NSDateFormatterNoStyle;
            self.createdAtString = [formatter stringFromDate:date]; //convert date to string
        }else if(minutes > 1440){ //tweet was tweeted more than a day ago, but less than a week ago
            //format as days passed
            int days = (int)[today daysFrom:date];
            self.createdAtString = [NSString stringWithFormat:@"%dd", days];
        }else if(minutes > 60){ //tweet was tweeted more than an hour ago, but less than a day ago
            //format as hours passed
            int hours = (int)[today hoursFrom:date];
            self.createdAtString = [NSString stringWithFormat:@"%dh", hours];
        }else if(minutes == 0){ //casting the double to int will truncate, so if minutes is 0 then it was tweeted seconds ago, but less than a minute ago
            //format as seconds passed
            int seconds = (int)[today secondsFrom:date];
            self.createdAtString = [NSString stringWithFormat:@"%ds", seconds];
        }else{ //tweet was tweeted more than a minute ago, but less than an hour ago
            //format as minutes passed
            self.createdAtString = [NSString stringWithFormat:@"%dm", minutes];
        }
        

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
