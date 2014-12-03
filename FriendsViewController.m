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

@property (strong, nonatomic) NSMutableArray *searchResults;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentUser = [PFUser currentUser];
    
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
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *accessoryButtonImage = [UIImage imageNamed:@"plus"];
    UIButton *accessoryButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [accessoryButton setBackgroundImage:accessoryButtonImage forState:UIControlStateNormal];
    [accessoryButton addTarget:self action:@selector(addOrRemoveFriend:event:) forControlEvents:UIControlEventTouchUpInside];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    PFUser *user = [self.searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    cell.accessoryView = accessoryButton;

    return cell;
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

    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    PFUser *user = [self.searchResults objectAtIndex:indexPath.row];
    [friendsRelation addObject:user];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"error: %@", error);
        }
    }];
    
}

@end
