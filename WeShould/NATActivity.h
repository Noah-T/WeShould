//
//  NATActivity.h
//  WeShould
//
//  Created by Noah Teshu on 10/15/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import <Parse/Parse.h>

@interface NATActivity : PFObject

@property (strong, nonatomic)NSString *activityName;
@property (strong, nonatomic)NSString *link;
@property (strong, nonatomic)NSString *location;
@property (strong, nonatomic)NSString *phoneNumber;
@property (strong, nonatomic)NSString *description;

@end
