//
//  DetailsViewController.m
//  twitter
//
//  Created by Mary Jiang on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "Tweet.h"
#import "APIManager.h"
#import "ProfileViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshData];
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

//updates all of the UI to have the appropriate data according to the Tweet object
-(void)refreshData{
    //set all the text labels to have the right information
    self.nameLabel.text = self.tweet.user.name;
    if(self.tweet != nil){ //stringByAppendingString will throw a fit if appending a nil string, so can only set this if tweet is not nil
        self.screenNameLabel.text = [@"@" stringByAppendingString:self.tweet.user.screenName];
    }
    self.textLabel.text = self.tweet.text;
    self.likesLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetsLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    //set the profile picture to have the right picture
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
    //configure the dates to show properly
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y"; //configure the input format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    self.dateLabel.text = [formatter stringFromDate:self.tweet.createdAt];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.timeLabel.text = [formatter stringFromDate:self.tweet.createdAt];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ProfileViewController *profileViewController = [segue destinationViewController];
    profileViewController.user = self.tweet.user;
}


@end
