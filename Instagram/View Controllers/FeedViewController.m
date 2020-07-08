//
//  FeedViewController.m
//  Instagram
//
//  Created by David Lara on 7/6/20.
//  Copyright © 2020 David Lara. All rights reserved.
//

#import "FeedViewController.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import <Parse/Parse.h>
#import "PostCell.h"
#import "Post.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;

- (IBAction)onLogoutPress:(id)sender;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.feedTableView.delegate = self;
    self.feedTableView.dataSource = self;
    
    [self fetchPosts];
}

- (void)fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *) posts;
            [self.feedTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)onLogoutPress:(id)sender {
    //logout
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else {
            SceneDelegate *sceneDelegate = (SceneDelegate *) self.view.window.windowScene.delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            sceneDelegate.window.rootViewController = loginViewController;
            
        }
    }];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [self.feedTableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    Post *post = self.posts[indexPath.row];
    [cell setPost:post];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
