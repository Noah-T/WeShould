//
//  AddEventViewController.h
//  WeShould
//
//  Created by Noah Teshu on 10/13/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EventViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *activityImage;


@property (weak, nonatomic) IBOutlet UITextField *activityNameField;
@property (strong, nonatomic)NSString *activityNameText;

@property (weak, nonatomic) IBOutlet UITextField *linkField;
@property (strong, nonatomic)NSString *linkFieldText;

@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (strong, nonatomic)NSString *locationFieldText;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (strong, nonatomic)NSString *phoneNumberFieldText;

@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (strong, nonatomic)NSString *descriptionFieldText;
@property (strong, nonatomic)PFObject *activity;

- (IBAction)saveActivity:(id)sender;

@end
