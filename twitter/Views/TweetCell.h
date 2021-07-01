//
//  TweetCell.h
//  twitter
//
//  Created by Mary Jiang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

//we need to first just declare the protocol here before TweetCell as delegate is of type TweetCell Delegate and then actually define it later as the method tweetCell: uses the class TweetCell as one of the argument's type
@protocol TweetCellDelegate;

@interface TweetCell : UITableViewCell
@property (nonatomic, strong) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

//updates labels inside cell based on data inside the Tweet object that the cell has
- (void)refreshData;
@end

@protocol TweetCellDelegate

- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;

@end

NS_ASSUME_NONNULL_END
