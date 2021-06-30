//
//  TweetCell.m
//  twitter
//
//  Created by Mary Jiang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "NSDate+DateTools.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(id)sender {
    //check if the tweet is already favorited or not, if it is not favorited it should favorite, if favorited should unfavorite
    if(self.tweet.favorited){
        //favorited so should unfavorite the tweet
        //send POST request to POST favorites/destroy endpoint
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"error UNfavoriting tweet: %@", error.localizedDescription);
            }else{
                NSLog(@"successfully UNfavorited tweet: %@", tweet.text);
                //update local Tweet properities
                self.tweet.favorited = false;
                self.tweet.favoriteCount -= 1;
                //update the UI elements to account for any changes
                [self refreshData];
            }
        }];
    }else{
        //not favorited so should make the tweet favorited
        //update the local Tweet properties
        //send POST request to POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"error favoriting tweet: %@", error.localizedDescription);
            }else{
                NSLog(@"successfully favorited tweet: %@", tweet.text);
                self.tweet.favorited = true;
                self.tweet.favoriteCount +=1;
                //update the UI elements to account for any changes
                [self refreshData];
            }
        }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    //check if the tweet is already rted or not, if it is not rtd it should rt, if favorited should unrt
    if(self.tweet.retweeted){
        //retweeted already, should unretweet
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"error UNrting tweet: %@", error.localizedDescription);
            }else{
                NSLog(@"successfully UNrt tweet: %@", tweet.text);
            }
        }];
        self.tweet.retweeted = false;
        self.tweet.retweetCount -= 1;
        [self refreshData];
    }else{
        //not retweeted, should retweet
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"error rting tweet: %@", error.localizedDescription);
            }else{
                NSLog(@"successfully rt tweet: %@", tweet.text);
            }
        }];
        self.tweet.retweeted = true;
        self.tweet.retweetCount += 1;
        [self refreshData];
    }
    
    
}


//updates UI based on local Tweet model
- (void)refreshData{
    //set all of the labels to have their respective text
    self.nameLabel.text = self.tweet.user.name;
    if(self.tweet != nil){ //stringByAppendingString will throw a fit if appending a nil string, so can only set this if tweet is not nil
        self.screenNameLabel.text = [@"@" stringByAppendingString:self.tweet.user.screenName];
    }else{
        self.screenNameLabel.text = nil;
    }
//    self.dateLabel.text = self.tweet.createdAtString;
    self.tweetTextLabel.text = self.tweet.text;
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState: UIControlStateNormal];
    [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState: UIControlStateNormal];
    //set the profile picture to have the right pictures
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profileView.image = [UIImage imageWithData:urlData];
    self.profileView.layer.cornerRadius = 10;
    //set the button icons to be the correct image
    if(self.tweet.favorited){
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:(UIControlStateNormal)];
    }else{
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:(UIControlStateNormal)];
    }
    if(self.tweet.retweeted){
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }else{
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    }
    NSDate *today = [NSDate date]; //create a date to represent user's current time to compare to the date tweet was posted
    int minutes = (int)[today minutesFrom:self.tweet.createdAt];
    if(minutes > 10080){ //tweet was tweeted more than a week ago
        //format MM/DD/YY for tweets tweeted that long ago
        //format the time stamp
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        self.dateLabel.text = [formatter stringFromDate:self.tweet.createdAt]; //convert date to string
    }else if(minutes > 1440){ //tweet was tweeted more than a day ago, but less than a week ago
        //format as days passed
        int days = (int)[today daysFrom:self.tweet.createdAt];
        self.dateLabel.text = [NSString stringWithFormat:@"%dd", days];
    }else if(minutes > 60){ //tweet was tweeted more than an hour ago, but less than a day ago
        //format as hours passed
        int hours = (int)[today hoursFrom:self.tweet.createdAt];
        self.dateLabel.text = [NSString stringWithFormat:@"%dh", hours];
    }else if(minutes == 0){ //casting the double to int will truncate, so if minutes is 0 then it was tweeted seconds ago, but less than a minute ago
        //format as seconds passed
        int seconds = (int)[today secondsFrom:self.tweet.createdAt];
        self.dateLabel.text = [NSString stringWithFormat:@"%ds", seconds];
    }else{ //tweet was tweeted more than a minute ago, but less than an hour ago
        //format as minutes passed
        self.dateLabel.text = [NSString stringWithFormat:@"%dm", minutes];
    }
    if(self.tweet == nil){
        self.dateLabel.text = nil; //so when tweet is not in the cell yet just make the label empty 
    }
}

@end
