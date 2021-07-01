//
//  ProfileViewController.m
//  twitter
//
//  Created by Mary Jiang on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [@"@" stringByAppendingString:self.user.screenName];
    NSString *profileURLString = self.user.profilePicture;
    NSURL *profileURL = [NSURL URLWithString:profileURLString];
    NSData *profileURLData = [NSData dataWithContentsOfURL:profileURL];
    self.profileView.image = [UIImage imageWithData:profileURLData];
    NSString *headerURLString = self.user.headerPicture;
    NSURL *headerURL = [NSURL URLWithString:headerURLString];
    NSData *headerURLData = [NSData dataWithContentsOfURL:headerURL];
    self.headerView.image = [UIImage imageWithData:headerURLData];
    self.profileView.layer.cornerRadius = 10;
    self.taglineLabel.text = self.user.tagline;
    self.followersLabel.text = [NSString stringWithFormat:@"%d", self.user.followersCount];
    self.followingLabel.text = [NSString stringWithFormat:@"%d", self.user.followingCount];
    self.tweetsCountLabel.text = [NSString stringWithFormat:@"%d", self.user.tweetsCount];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
