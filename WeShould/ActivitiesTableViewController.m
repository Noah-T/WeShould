//
//  ActivitiesTableViewController.m
//  WeShould
//
//  Created by Noah Teshu on 10/6/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "ActivitiesTableViewController.h"
#import <Parse/Parse.h>
#import "EventViewController.h"

@interface ActivitiesTableViewController ()

@property (strong, nonatomic)NSMutableArray *activitiesArray;

- (IBAction)logout:(id)sender;

@end

@implementation ActivitiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(updatePage) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self updatePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.activitiesArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *activity = [self.activitiesArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text =  [activity objectForKey:@"activityName"];
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ExistingActivitySegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        PFObject *activity = [self.activitiesArray objectAtIndex:indexPath.row];
        
        EventViewController *destinationController = (EventViewController*)segue.destinationViewController;
        
        //create a weak pointer to self (avoid a strong reference cycle)
        __weak typeof(self) welf = self;
        destinationController.backgroundSaveCompletionHandler = ^{
            [welf.tableView reloadData];
        };
        
        //pass the entire activity to the detail view
        destinationController.activity = activity;
        //pass properties individually (text views require this)
        destinationController.activityNameText = [activity objectForKey:@"activityName"];
        destinationController.linkFieldText = [activity objectForKey:@"linkField"];
        destinationController.locationFieldText = [activity objectForKey:@"locationField"];
        destinationController.phoneNumberFieldText = [activity objectForKey:@"phoneNumberField"];
        destinationController.descriptionFieldText = [activity objectForKey:@"descriptionField"];
    }
}


- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)updatePage
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKeyExists:@"activityName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, error.userInfo );
        } else {
            self.activitiesArray = [NSMutableArray arrayWithArray:objects];
            
            [self.tableView reloadData];
        }
    }];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        //user is logged in
    }
    else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }


}
@end
