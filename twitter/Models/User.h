//
//  User.h
//  twitter
//
//  Created by Mary Jiang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

//all public properties and methods are added to .h file

//properties

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *headerPicture;
@property (nonatomic) int followersCount;
@property (nonatomic) int followingCount;
@property (nonatomic) int tweetsCount;

//methods

//because user comes back as a dict, have initializer that can set properties based on the dictionary
//initalizer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end

NS_ASSUME_NONNULL_END
