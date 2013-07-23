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
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    [self updateSubjectImages];
}

-(void)updateSubjectImages {
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                _chatSubjectImages = objects;
            }
    }
    }];
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
    [queryCombined includeKey:@"chats"];
    [queryCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [_availableChatRoomsArray removeAllObjects];
            [_availableChatRoomsArray addObjectsFromArray:objects];
            [_tableView reloadData];
            NSLog(@"^^^_availableChatRoomsArray: %@", _availableChatRoomsArray);
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"^^^cellForRowAtIndexPath called");
    static NSString *cellIdentifier = @"AvailableChatCell";
    QCAvailableChatCell *cell = (QCAvailableChatCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QCAvailableChatCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSLog(@"^^^Cell created: %@", cell);
    [cell setBackgroundColor:[UIColor clearColor]];
    PFObject *chatroom = [_availableChatRoomsArray objectAtIndex:indexPath.row];
    NSLog(@"^^^Chatroom for cell: %@", chatroom);
    BOOL isUser1CurrentUser;
    if ([[chatroom objectForKey:@"username1"] isEqual:[PFUser currentUser].username]) {
        cell.nameLabel.text = [chatroom objectForKey:@"name2"];
        NSLog(@"^^^Name2 displayed");
        isUser1CurrentUser = YES;
    }
    else {
        cell.nameLabel.text = [chatroom objectForKey:@"name1"];
        NSLog(@"^^^Name1 displayed");
        isUser1CurrentUser = NO;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    for (PFObject *photo in _chatSubjectImages) {
        if (isUser1CurrentUser) {
            if ([((PFUser *)photo[@"user"]).username isEqualToString:chatroom[@"username2"]]) {
                PFFile *file = photo[@"image"];
                NSLog(@"file %@", file);
                cell.chatSubjectImage.image = [UIImage imageNamed:@"placeHolderImage.png"];
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:data];
                        cell.chatSubjectImage.image = image;                        
                    }
                }];
                NSDate *date = [formatter dateFromString:photo[@"user"][@"profile"][@"birthday"]];
                NSDate *now = [NSDate date];
                NSTimeInterval seconds = [now timeIntervalSinceDate: date];
                NSInteger ageInt = seconds / 31536000;
                NSString *ageStr = [[NSString stringWithFormat:@"%i", (int)ageInt] stringByAppendingString:@" years old"];
                cell.ageLabel.text = ageStr;
            }
        }
        else {
            if ([((PFUser *)photo[@"user"]).username isEqualToString:chatroom[@"username1"]]) {
                PFFile *file = photo[@"image"];
                NSLog(@"file %@", file);
                cell.chatSubjectImage.image = [UIImage imageNamed:@"placeHolderImage.png"];
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:data];
                        cell.chatSubjectImage.image = image;
                    }
                }];
                NSDate *date = [formatter dateFromString:photo[@"user"][@"profile"][@"birthday"]];
                NSDate *now = [NSDate date];
                NSTimeInterval seconds = [now timeIntervalSinceDate: date];
                NSInteger ageInt = seconds / 31536000;
                NSString *ageStr = [[NSString stringWithFormat:@"%i", (int)ageInt] stringByAppendingString:@" years old"];
                cell.ageLabel.text = ageStr;
            }
        }
    }            
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QCChatViewController *chatViewController = [[QCChatViewController alloc] init];
    chatViewController.chatroom = [_availableChatRoomsArray objectAtIndex:indexPath.row];
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
    [chat setObject:[PFUser currentUser].username forKey:@"fromUsername"];
    [chat setObject:[PFUser currentUser].username forKey:@"toUsername"];
    [chat setObject:@"Entered Text 1" forKey:@"text"];
    
    PFObject *chat2 = [PFObject objectWithClassName:@"Chat"];
    [chat2 setObject:[PFUser currentUser].username forKey:@"fromUsername"];
    [chat2 setObject:[PFUser currentUser].username forKey:@"toUsername"];
    [chat2 setObject:@"Entered Text 2" forKey:@"text"];
    
    PFObject *chat3 = [PFObject objectWithClassName:@"Chat"];
    [chat3 setObject:[PFUser currentUser].username forKey:@"fromUsername"];
    [chat3 setObject:[PFUser currentUser].username forKey:@"toUsername"];
    [chat3 setObject:@"Entered Text 3" forKey:@"text"];
    
    NSMutableArray *chatsMutableArray = [[NSMutableArray alloc] init];

    [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        [chat2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            [chat3 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
                [query whereKey:@"fromUsername" equalTo:[PFUser currentUser].username];
                [query whereKey:@"toUsername" equalTo:[PFUser currentUser].username];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        for (PFObject *object in objects) {
                            NSLog(@"^^^Object: %@", object);
                            [chatsMutableArray addObject:object];
                        }
                    }
                    NSArray *chatsArray = [chatsMutableArray copy];
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
