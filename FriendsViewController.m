//
//  FriendsViewController.m
//  WeShould
//
//  Created by Noah Teshu on 11/29/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "FriendsViewController.h"
#import <Parse/Parse.h>

@interface FriendsViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *friendRequestTableView;
@property (strong, nonatomic) NSArray *pendingFriendRequests;


@property (strong, nonatomic) NSMutableArray *searchResults;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentUser = [PFUser currentUser];

    NSLog(@"tab bar controller is: %@", self.tabBarController);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    PFQuery *pendingRequestsQuery = [PFQuery queryWithClassName:@"FriendRequest" ];
    [pendingRequestsQuery whereKey:@"to" equalTo:self.currentUser];
    [pendingRequestsQuery whereKey:@"status" equalTo:@"pending"];
    [pendingRequestsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.pendingFriendRequests = objects;
//            for (PFObject *friendRequest in <#collection#>) {
//                <#statements#>
//            }

            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                NSLog(@"search results: %lu", (unsigned long)objects.count);
                [self.friendRequestTableView reloadData];
                NSLog(@"this is past the reloadData call");

            });
        } else {
            NSLog(@"%@", error.description);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{


        self.searchResults = [NSMutableArray array];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:searchBar.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.description);
        }
        if (objects.count > 0) {
            
            for (PFUser *user in objects) {
                [self.searchResults addObject:user];
            }
        }
        [self.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.searchResults.count;
    } else {
        return self.pendingFriendRequests.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        //    UIImage *accessoryButtonImage = [UIImage imageNamed:@"plus"];
        //    UIButton *accessoryButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        //    [accessoryButton setBackgroundImage:accessoryButtonImage forState:UIControlStateNormal];
        //    [accessoryButton addTarget:self action:@selector(addOrRemoveFriend:event:) forControlEvents:UIControlEventTouchUpInside];
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        PFUser *user = [self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = user.username;
        //    cell.accessoryView = accessoryButton;
        return cell;
    } else if(tableView == self.friendRequestTableView) {
        //add pending friend requests here
        NSLog(@"HELLO THERE");

        PFObject *FriendRequest = [self.pendingFriendRequests objectAtIndex:indexPath.row];
        PFUser *userWhoSentFriendRequest = FriendRequest[@"from"];
        NSLog(@"userwhosentrequest: %@", userWhoSentFriendRequest);
        
        UITableViewCell *cell = [self.friendRequestTableView dequeueReusableCellWithIdentifier:@"requestCell" forIndexPath:indexPath];
        cell.textLabel.text = userWhoSentFriendRequest.objectId;
        
        return cell;
    }
    

    return false;
}

- (void)addOrRemoveFriend:(id)sender event:(id)event
{
    NSLog(@"The sender is: %@", sender);
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
        NSLog(@"index path is: %@", indexPath);
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
        PFUser *user = [self.searchResults objectAtIndex:indexPath.row];
        [friendsRelation addObject:user];
        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                NSLog(@"error: %@", error);
            }
        }];

    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        PFUser *selectedUser = [self.searchResults objectAtIndex:indexPath.row];
        
        
        PFObject *friendRequest = [PFObject objectWithClassName:@"FriendRequest"];
        friendRequest[@"from"] = self.currentUser;
        friendRequest[@"to"] = selectedUser;
        friendRequest[@"status"] = @"pending";
        [friendRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cool!" message:@"Friend request sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }];

    }
    
}

@end
