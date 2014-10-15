//
//  AddEventViewController.m
//  WeShould
//
//  Created by Noah Teshu on 10/13/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "EventViewController.h"
#import <Parse/Parse.h>
#import "NATActivity.h"

@interface EventViewController ()


@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.activityNameField.text = self.activityNameText;
    self.linkField.text = self.linkFieldText;
    self.locationField.text = self.locationFieldText;
    self.phoneNumberField.text = self.phoneNumberFieldText;
    self.descriptionField.text = self.descriptionFieldText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)saveActivity:(id)sender {
    //make sure the activity has a name
    if (self.activityNameField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter an activity name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } else {
        
        if (!self.activity.objectId) {
            NATActivity *activity = [NATActivity objectWithClassName:@"Activity"];
            [activity setObject:[[PFUser currentUser]username] forKey:@"activityCreator"];
            [activity setObject:self.activityNameField.text forKey:@"activityName"];
            [activity setObject:self.linkField.text forKey:@"linkField"];
            [activity setObject:self.locationField.text forKey:@"locationField"];
            [activity setObject:self.phoneNumberField.text forKey:@"phoneNumberField"];
            [activity setObject:self.descriptionField.text forKey:@"descriptionField"];
            [activity save];
            
        } else {
            PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
            [query getObjectInBackgroundWithId:self.activity.objectId block:^(PFObject *object, NSError *error) {
                if (error) {
                    NSLog(@"error message: %@", error);
                } else {
                    [object setObject:self.activityNameField.text forKey:@"activityName"];
                    [object setObject:self.linkField.text forKey:@"linkField"];
                    [object setObject:self.locationField.text forKey:@"locationField"];
                    [object setObject:self.phoneNumberField.text forKey:@"phoneNumberField"];
                    [object setObject:self.descriptionField.text forKey:@"descriptionField"];

                    [object save];                }
            }];
        }
        [self.navigationController popViewControllerAnimated:YES];

        
    }
}

#pragma mark - Helper methods

@end
