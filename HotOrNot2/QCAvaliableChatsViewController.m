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
    
    PFObject *chat = [PFObject objectWithClassName:@"Chat"];
    [chat setObject:[PFUser currentUser] forKey:@"user1"];
    [chat setObject:[PFUser currentUser] forKey:@"user2"];
    [chat setObject:@"Entered Text 1" forKey:@"text"];

    PFObject *chat2 = [PFObject objectWithClassName:@"Chat"];
    [chat2 setObject:[PFUser currentUser] forKey:@"user1"];
    [chat2 setObject:[PFUser currentUser] forKey:@"user2"];
    [chat2 setObject:@"Entered Text 2" forKey:@"text"];

    PFObject *chat3 = [PFObject objectWithClassName:@"Chat"];
    [chat3 setObject:[PFUser currentUser] forKey:@"user1"];
    [chat3 setObject:[PFUser currentUser] forKey:@"user2"];
    [chat3 setObject:@"Entered Text 3" forKey:@"text"];
    
    NSMutableArray *chatsArray = [[NSMutableArray alloc] initWithObjects:chat, chat2, chat3, nil];
    
    PFObject *chatroom = [PFObject objectWithClassName:@"ChatRoom"];
    [chatroom setObject:[PFUser currentUser] forKey:@"user1"];
    [chatroom setObject:[PFUser currentUser] forKey:@"user2"];
    [chatroom setObject:chatsArray forKey:@"chats"];
    
    [chat setObject:chatroom forKey:@"chatroom"];
    [chat2 setObject:chatroom forKey:@"chatroom"];
    [chat3 setObject:chatroom forKey:@"chatroom"];
    
    // save
    [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){

    }];
    
//    PFQuery *query = [self queryForChats];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//    {
//        NSLog(@"%@", objects);
//        [_availableChatRoomsArray addObjectsFromArray:objects];
//    }];
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
    QCChatViewController *chatViewController = [[QCChatViewController alloc] init];
    [self.navigationController pushViewController:chatViewController animated:YES];
}
//
//- (PFQuery *)queryForChats
//{
//    PFUser *user1 = [PFUser currentUser];
//    PFUser *user2 = 
//    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
//    PFQuery *queryInverse = [PFQuery queryWithClassName:@"ChatRoom"];
//    
//    query whereKey:@"toUser" equalTo:
//    
////    PFQuery *queryMessageForUser = [PFQuery queryWithClassName:kPAPActivityClassKey];
////    [queryMessageForUser whereKey:@"toUser" equalTo:[PFUser currentUser]];
////    [queryMessageForUser whereKey:@"type" equalTo:@"type"];
////    
////    PFQuery *queryMessageSentToUser = [PFQuery queryWithClassName:kPAPActivityClassKey];
////    [queryMessageSentToUser whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
////    [queryMessageSentToUser whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeChat];
////    
////    PFQuery *chatquery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryMessageForUser, queryMessageSentToUser, nil]];
////    
////    [chatquery orderByAscending:@"createdAt"];
////    
////    return chatquery;
//}

@end
