//
//  FriendsViewController.h
//  WeShould
//
//  Created by Noah Teshu on 11/29/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MSCellAccessory.h>
#import <Parse/Parse.h>

@interface FriendsViewController : UIViewController

@property (strong, nonatomic) PFUser *currentUser;

@end
