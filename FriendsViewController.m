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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    PFUser *user = [self.searchResults objectAtIndex:indexPath.row];
    NSLog(@"username: \n\n\n\n %@", user.username);
    cell.textLabel.text = user.username;
    cell.accessoryView = accessoryButton;

    return cell;
}

@end
