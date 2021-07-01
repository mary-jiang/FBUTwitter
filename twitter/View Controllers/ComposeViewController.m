//
//  ComposeViewController.m
//  twitter
//
//  Created by Mary Jiang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (nonatomic) int characterCount;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView.delegate = self;
    
    self.characterCount = 0; //intially 0 characters are in the
    
    self.textView.layer.cornerRadius = 8;
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.textView.layer.borderWidth = 1.0;
    
    [self.textView becomeFirstResponder]; //makes the keyboard pop up first when view loaded, ready to edit
}

- (IBAction)closeClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil]; //dismisses this view controller
}

- (IBAction)tweetClicked:(id)sender {
    if(self.characterCount <= 280){
        [[APIManager shared] postStatusWithText:self.textView.text completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"error composing tweet: %@", error.localizedDescription);
            }else{
                [self.delegate didTweet:tweet]; //when no error send over the tweet to the delegate to do stuff with the tweet object the api returnss
                NSLog(@"compose tweet successful");
            }
        }];
        [self dismissViewControllerAnimated:true completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tweet Not Posted" message:@"Your tweet has too many characters. Edit your tweet and try again." preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //do nothing as all we want to do is dismiss alert
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:true completion:^{
            //do nothing after presenting, nothing needs to be done
        }];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    self.characterCount = (int) self.textView.text.length;
    self.characterCountLabel.text = [NSString stringWithFormat:@"%d", 280 - self.characterCount];
}

//tap gesture recognizer on the whole screen that makes the keyboard disappear when screen is tapped
- (IBAction)screenTapped:(id)sender {
    [self.view endEditing:true]; //makes the keyboard go away when user taps on screen
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
