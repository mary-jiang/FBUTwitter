//
//  ComposeViewController.m
//  twitter
//
//  Created by Mary Jiang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)closeClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil]; //dismisses this view controller
}

- (IBAction)tweetClicked:(id)sender {
    //step 3 in composing tweet, NSString part put in the string from UITextView (textView), completion do something 
    [[APIManager shared] postStatusWithText:self.textView.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"error composing tweet: %@", error.localizedDescription);
        }else{
            [self.delegate didTweet:tweet]; //when no error send over the tweet to the delegate TimelineViewController to do stuff
            NSLog(@"compose tweet successful");
        }
    }];
    [self dismissViewControllerAnimated:true completion:nil];
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
