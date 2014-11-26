//
//  AddEventViewController.m
//  WeShould
//
//  Created by Noah Teshu on 10/13/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "EventViewController.h"
#import <Parse/Parse.h>


@interface EventViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    if (self.activity != nil) {
        
        
        self.activityNameField.text = self.activityNameText;
        self.linkField.text = self.linkFieldText;
        self.locationField.text = self.locationFieldText;
        self.phoneNumberField.text = self.phoneNumberFieldText;
        self.descriptionField.text = self.descriptionFieldText;
        
        PFQuery *imageQuery = [PFQuery queryWithClassName:@"Activity"];
        
        [imageQuery getObjectInBackgroundWithId:self.activity.objectId block:^(PFObject *object, NSError *error) {
            if ([object objectForKey:@"activityImage"]) {
                PFFile *imageFile = [object objectForKey:@"activityImage"];
                NSURL *imageFileUrl = [[NSURL alloc]initWithString:imageFile.url];
                NSData *imageDataFromURL = [NSData dataWithContentsOfURL:imageFileUrl];
                [self.activityImageButton setImage:[UIImage imageWithData:imageDataFromURL] forState:UIControlStateNormal] ;
            }
            
        }];
        
    }
}

- (IBAction)saveActivity:(id)sender {
    //make sure the activity has a name
    if (self.activityNameField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter an activity name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } else {
        
        if (!self.activity.objectId) {
            PFObject *activity = [PFObject objectWithClassName:@"Activity"];
            [activity setObject:[[PFUser currentUser]username] forKey:@"activityCreator"];
            [activity setObject:self.activityNameField.text forKey:@"activityName"];
            [activity setObject:self.linkField.text forKey:@"linkField"];
            [activity setObject:self.locationField.text forKey:@"locationField"];
            [activity setObject:self.phoneNumberField.text forKey:@"phoneNumberField"];
            [activity setObject:self.descriptionField.text forKey:@"descriptionField"];
            PFFile *tempImage = [self.imageObject objectForKey:@"activityImage"];
            if (self.imageObject) {
                [activity setObject:tempImage forKey:@"activityImage"];
            }             
            [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!succeeded) {
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"Activity failed to save." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alertView show];
                    } else {
                        NSLog(@"New activity saved");
                        if (self.backgroundSaveCompletionHandler) {

                            self.backgroundSaveCompletionHandler();
                        }
                    }   
                });
            }];
            
            
        } else {
            PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
            [query getObjectInBackgroundWithId:self.activity.objectId block:^(PFObject *object, NSError *error) {
                if (error) {
                    NSLog(@"error message: %@", error);
                } else {
                    object[@"activityName"] = self.activityNameField.text;
                    [object setObject:@"999" forKey:@"linkField"];
                    [object setObject:self.locationField.text forKey:@"locationField"];
                    [object setObject:self.phoneNumberField.text forKey:@"phoneNumberField"];
                    [object setObject:self.descriptionField.text forKey:@"descriptionField"];
                    NSLog(@"hey there");

                    if (!object[@"activityImage"]) {
                        PFFile *tempImage = [self.imageObject objectForKey:@"activityImage"];
                        [object setObject:tempImage forKey:@"activityImage"];
                    }
                    NSLog(@"this is right before the save");
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        NSLog(@"save succeeded!");
                        NSLog(@"error: %@", error);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (error) {
                                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"Activity failed to save." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [alertView show];
                            } else {
                                NSLog(@"successful save");
                                if (self.backgroundSaveCompletionHandler) {
                                    self.backgroundSaveCompletionHandler();
                                    NSLog(@"refresh");
                                }
                            }
                            
                            
                        });
                    }];
                }
            }];
        }
        //[self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Camera methods

- (IBAction)imageButtonWasPressed:(id)sender {
    self.activityImageButton.imageView.image = nil;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if user didn't cancel
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        
        //if user selected camera
        if (buttonIndex == actionSheet.firstOtherButtonIndex) {
            [self promptForCamera];
        } else {
            [self promptForPhotoRoll];
        }
    }
}

- (void)promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate =  self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate =  self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"finish was fired");
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.activityImageButton setImage:image forState:UIControlStateNormal];
    
    //compress image for uploading
    UIImage *resizedImage = [self resizeImage:image toWidth:320.0f andHeight:480.0f];
    NSData *imageData = UIImagePNGRepresentation(resizedImage);
    
    //note to myself for doing this in the future: I had previously created an activityImage column that behaved differently. Writing to it with new behavior caused problems. Deleting the column adn trying again with this behavior fixed things.
    
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.activity) {
                [self.activity setObject:imageFile forKey:@"activityImage"];
                [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                    
                }];
            } else {
                self.imageObject = [PFObject objectWithClassName:@"TempObject"];
                [self.imageObject setObject:imageFile forKey:@"activityImage"];
                [self.imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            }
            
        });
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)promptForSource {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Roll", nil];
    
    [actionSheet showInView:self.view];
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height
{
    //this works with the passed in parameters: set a size equal to the width and height passed in
    CGSize newSize = CGSizeMake(width, height);
    //something new I learned about CGRect:
    //it basically makes two points: 1. x and y coordinates for upper left 2. x and y coordinates for bottom right. It's smart enough to fill in the rest from here
    
    //convert the passed in size to a rectangle
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    
    //create an image context based on the passed in size
    UIGraphicsBeginImageContext(newSize);
    
    //take the passed in image and draw it onto a rectangle of the passed in size
    //(resize image to passed in dimensions)
    [image drawInRect:newRectangle];
    
    //get the image from the current image context
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //this must be used anytime beginImagecontext is used
    UIGraphicsEndImageContext();
    
    //return the final value
    return resizedImage;
}




@end
