//
//  AddEventViewController.m
//  WeShould
//
//  Created by Noah Teshu on 10/13/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "AddEventViewController.h"
#import <Parse/Parse.h>

@interface AddEventViewController ()

@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;


@property (weak, nonatomic) IBOutlet UITextField *activityNameField;
@property (weak, nonatomic) IBOutlet UITextField *linkField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;

- (IBAction)saveActivity:(id)sender;

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    if (self.activityNameField.text == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter an activity name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } else {
        //create an activity class
        PFObject *activity = [PFObject objectWithClassName:@"Activity"];
        [activity setObject:self.activityNameField.text forKey:@"activityName"];
        [activity setObject:[[PFUser currentUser]username] forKey:@"activityCreator"];
        [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"An error occurred!" message:@"Please try saving your activity again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } else {
                NSLog(@"activity saved");
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
}
@end
