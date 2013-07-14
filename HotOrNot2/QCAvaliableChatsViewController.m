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
    
//    [self createFakeChats];
    _availableChatRoomsArray = [[NSMutableArray alloc] init];
    [self updateAvailableChatRooms];
}

-(void)viewDidAppear:(BOOL)animated {
    [self updateAvailableChatRooms];
}

-(void)updateAvailableChatRooms {
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    [query whereKey:@"username1" equalTo:[PFUser currentUser].username];
    PFQuery *queryInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryInverse whereKey:@"username2" equalTo:[PFUser currentUser].username];
    PFQuery *queryCombined = [PFQuery orQueryWithSubqueries:@[query, queryInverse]];
    [queryCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [_availableChatRoomsArray removeAllObjects];
            [_availableChatRoomsArray addObjectsFromArray:objects];
            [_tableView reloadData];
        }
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
    return _availableChatRoomsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"^^^cellForRowAtIndexPath called");
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    PFObject *chatroom = [_availableChatRoomsArray objectAtIndex:indexPath.row];
    NSLog(@"^^^Chatroom for cell: %@", chatroom);
    if ([[chatroom objectForKey:@"username1"] isEqual:[PFUser currentUser].username]) {
        cell.textLabel.text = [chatroom objectForKey:@"name1"];
        NSLog(@"^^^Name1 displayed");
    }
    else {
        cell.textLabel.text = [chatroom objectForKey:@"name2"];
        NSLog(@"^^^Name2 displayed");
    }
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

# pragma mark - creating fake chats

- (void) createFakeChats {
    
    PFObject *chat = [PFObject objectWithClassName:@"Chat"];
    [chat setObject:[PFUser currentUser].username forKey:@"username1"];
    [chat setObject:[PFUser currentUser].username forKey:@"username2"];
    [chat setObject:@"Entered Text 1" forKey:@"text"];
    
    PFObject *chat2 = [PFObject objectWithClassName:@"Chat"];
    [chat2 setObject:[PFUser currentUser].username forKey:@"username1"];
    [chat2 setObject:[PFUser currentUser].username forKey:@"username2"];
    [chat2 setObject:@"Entered Text 2" forKey:@"text"];
    
    PFObject *chat3 = [PFObject objectWithClassName:@"Chat"];
    [chat3 setObject:[PFUser currentUser].username forKey:@"username1"];
    [chat3 setObject:[PFUser currentUser].username forKey:@"username2"];
    [chat3 setObject:@"Entered Text 3" forKey:@"text"];
    
    NSMutableArray *chatsArray = [[NSMutableArray alloc] init];

    [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        [chat2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            [chat3 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        for (PFObject *object in objects) {
                            NSLog(@"^^^Object: %@", object);
                            [chatsArray addObject:object];
                        }
                    }
                    NSLog(@"^^^Chats Array: %@", chatsArray);
                    
                    PFObject *chatroom = [PFObject objectWithClassName:@"ChatRoom"];
                    [chatroom setObject:[PFUser currentUser].username forKey:@"username1"];
                    [chatroom setObject:[PFUser currentUser].username forKey:@"username2"];
                    [chatroom setObject:chatsArray forKey:@"chats"];
                    [chatroom setObject:[[PFUser currentUser] objectForKey:@"profile"][@"name"] forKey:@"name1"];
                    [chatroom setObject:[[PFUser currentUser] objectForKey:@"profile"][@"name"] forKey:@"name2"];
                    [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                        NSLog(@"^^^ChatRoom saved: %@", chatroom);
                    }];
                }];
            }];
        }];
    }];
}



@end
