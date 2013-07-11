//
//  QCAvaliableChatsViewController.m
//  HotOrNot2
//
//  Created by Eliot Arntz on 7/11/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import "QCAvaliableChatsViewController.h"

@interface QCAvaliableChatsViewController ()

@end

@implementation QCAvaliableChatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    PFQuery *query = [self queryForChats];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        NSLog(@"%@", objects);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"Hello";
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QCChatViewController *chatViewController = [QCChatViewController new];
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (PFQuery *)queryForChats
{    
    PFQuery *queryMessageForUser = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [queryMessageForUser whereKey:kPAPActivityToUserKey equalTo:[PFUser currentUser]];
    [queryMessageForUser whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeChat];
    
    PFQuery *queryMessageSentToUser = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [queryMessageSentToUser whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryMessageSentToUser whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeChat];
    
    PFQuery *chatquery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryMessageForUser, queryMessageSentToUser, nil]];
    
    [chatquery orderByAscending:@"createdAt"];
    
    return chatquery;
}

@end
