//
//  User.m
//  twitter
//
//  Created by Mary Jiang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        //just set properties based on passed in dictionary
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicture = [dictionary[@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal" withString:@""]; //when the api sends profile picture image _normal is appended to make the image 48x48, so this gets rid of that _normal to get the full size
        self.tagline = dictionary[@"description"];
        self.followersCount = [dictionary[@"followers_count"] intValue];
        self.followingCount = [dictionary[@"friends_count"] intValue];
        self.tweetsCount = [dictionary[@"statuses_count"] intValue];
        self.headerPicture = dictionary[@"profile_banner_url"];
    }
    return self;
}

@end
