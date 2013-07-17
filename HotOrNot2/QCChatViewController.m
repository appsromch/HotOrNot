//
//  QCChatViewController.m
//  HotOrNot2
//
//  Created by Eliot Arntz on 7/11/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import "QCChatViewController.h"

@interface QCChatViewController ()

@end

@implementation QCChatViewController

#pragma mark - Initialization
- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
    return [UIButton defaultSendButton];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
        
    self.title = @"Messages";
    
    _messages = [[NSMutableArray alloc]init];
    _timestamps = [[NSMutableArray alloc]init];
    _chats = [[NSMutableArray alloc]init];
//    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:@"ChatRoom"];
//    [queryForChatRoom findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//     {
//         if (!error) {
//             NSLog(@"^^^ChatRoom Objects: %@", objects);
//             if (objects.count > 0) {
//                 for (PFObject *object in objects) {
//                     if (([[object objectForKey:@"username1"] isEqualToString:[_chatroom objectForKey:@"username1"]] &&
//                          [[object objectForKey:@"username2"] isEqualToString:[_chatroom objectForKey:@"username2"]]) ||
//                         ([[object objectForKey:@"username1"] isEqualToString:[_chatroom objectForKey:@"username2"]] &&
//                          [[object objectForKey:@"username2"] isEqualToString:[_chatroom objectForKey:@"username1"]])) {
//                         //get chat objects and create messages for them
//                         NSArray *chats = [object objectForKey:@"chats"];
//                         for (PFObject *object in chats) {
//                             NSLog(@"^^^Chat: %@", object);
//                             [_messages addObject:[object objectForKey:@"text"]];
//                             [_timestamps addObject:[NSDate distantPast]];
//                         }
//                         NSLog(@"Messages: %@", _messages);
//                     }
//                     NSLog(@"^^^ChatRoom username1: %@", [object objectForKey:@"username1"]);
//                     NSLog(@"^^^ChatRoom username2: %@", [object objectForKey:@"username2"]);
//                 }
//                 NSLog(@"^^^currentUser username: %@", [PFUser currentUser].username);
//                 NSLog(@"^^^currentUser name: %@", [[PFUser currentUser] objectForKey:@"profile"][@"name"]);
//             }
//         }
//         //reload tableView when block has evaluated
//         [self finishSend];
//     }];
    
    [self updateChatRoom];
    [self.tableView reloadData];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    if (text.length != 0) {
        
        PFObject *chat = [PFObject objectWithClassName:@"Chat"];
        NSString *toUsername = [[NSString alloc] init];
        if ([[_chatroom objectForKey:@"username1"] isEqualToString:[PFUser currentUser].username]) {
            toUsername = [_chatroom objectForKey:@"username2"];
            NSLog(@"^^^toUsername set to username2: %@", toUsername);
        }
        else {
            toUsername = [_chatroom objectForKey:@"username1"];
            NSLog(@"^^^toUsername set to username1: %@", toUsername);
        }
        [chat setObject:[PFUser currentUser].username forKey:@"fromUsername"];
        [chat setObject:toUsername forKey:@"toUsername"];
        [chat setObject:text forKey:@"text"];
        [chat save];
        [self updateChatRoom];
        NSMutableArray *updatedMutableChats = [[NSMutableArray alloc] initWithArray:[_chatroom objectForKey:@"chats"]];
        [updatedMutableChats addObject:chat];
        NSArray * updatedChats = [updatedMutableChats copy];
        NSLog(@"^^^updatedChats: %@", updatedChats);
        [_chatroom setObject:updatedChats forKey:@"chats"];
        [_chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"_chatroom updated");
            }
        }];
                
        [JSMessageSoundEffect playMessageSentSound];
//        [JSMessageSoundEffect playMessageReceivedSound];
        
        [self finishSend];

        // Set the proper ACLs
//        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
//        [ACL setPublicReadAccess:YES];
//        chat.ACL = ACL;
        
        [chat saveEventually:^(BOOL succeeded, NSError *error) {

            // Check if the photo was deleted
            if (error && [error code] == kPFErrorObjectNotFound) {
                // Undo cache update and alert user
                [[[UIAlertView alloc] initWithTitle:@"Chat Failed"
                                            message:@"ChatRoom deleted"
                                           delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil] show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {                
                // Reload the table to display the new message
                PFQuery *query = [self queryForFromUsersTable];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                    NSLog(@"*** objects %@", objects);
//                    self.objects = objects;
                    [self.tableView reloadData];
                }];
            }
        }];
    }
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *chats = [_chatroom objectForKey:@"chats"];
//    if (indexPath.row < chats.count) {
//        NSLog(@"_messages.count: %i", _messages.count);
//        NSLog(@"indexPath.row:, %i", indexPath.row);
//        NSLog(@"chats.count:, %i", indexPath.row);
//        PFObject *chat = chats[indexPath.row];
//        if ([[chat objectForKey:@"toUsername"] isEqualToString:[PFUser currentUser].username]) {
//            return JSBubbleMessageStyleIncomingDefault;
//        }
//        else {
//            return JSBubbleMessageStyleOutgoingDefault;
//        }
//    }
//    else {
//        return JSBubbleMessageStyleOutgoingDefault;
//    }
    return JSBubbleMessageStyleOutgoingDefault;
//    return (indexPath.row % 2) ? JSBubbleMessageStyleIncomingDefault : JSBubbleMessageStyleOutgoingDefault;
}

- (JSMessagesViewTimestampPolicy)timestampPolicyForMessagesView
{
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // custom implementation here, if using `JSMessagesViewTimestampPolicyCustom`
    return [self shouldHaveTimestampForRowAtIndexPath:indexPath];
}

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.timestamps objectAtIndex:indexPath.row];
}

#pragma mark - Update _chatroom

-(void) updateChatRoom {
    PFQuery *queryForChatRoom  = [PFQuery queryWithClassName:@"ChatRoom"];
//    [queryForChatRoom includeKey:@"chats"];
    [queryForChatRoom whereKey:@"username1" equalTo:[_chatroom objectForKey:@"username1"]];
    [queryForChatRoom whereKey:@"username2" equalTo:[_chatroom objectForKey:@"username2"]];
    [queryForChatRoom findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                _chatroom = objects[0];
                NSLog(@"^^^Updated _chatroom: %@", _chatroom);
            }
        }
    }];
    PFQuery *queryForChats = [PFQuery queryWithClassName:@"Chat"];
    [queryForChats whereKey:@"fromUsername" equalTo:_chatroom[@"username1"]];
    [queryForChats whereKey:@"toUsername" equalTo:_chatroom[@"username2"]];
    PFQuery *queryForChatsInverse = [PFQuery queryWithClassName:@"Chat"];
    [queryForChatsInverse whereKey:@"fromUsername" equalTo:_chatroom[@"username2"]];
    [queryForChatsInverse whereKey:@"toUsername" equalTo:_chatroom[@"username1"]];
    PFQuery *combinedQueryForChats = [PFQuery orQueryWithSubqueries:@[queryForChats,queryForChatsInverse]];
    [combinedQueryForChats orderByAscending:@"createdAt"];
    [_chats removeAllObjects];
    [_messages removeAllObjects];
    [_timestamps removeAllObjects];
    [_chats addObjectsFromArray:[combinedQueryForChats findObjects]];
    NSLog(@"^^^_chats: %@", _chats);
    for (PFObject *object in _chats) {
        [_messages addObject:object[@"text"]];
        [_timestamps addObject:object.createdAt];
        NSLog(@"^^^_timestamps: %@", _timestamps);
    }
//    NSArray *chatObjects = [_chatroom objectForKey:@"chats"];
//    NSLog(@"^^^chat objects: %@", chatObjects);
//    if (chatObjects.count > 0) {
//        for (PFObject *object in chatObjects) {
//            PFQuery *queryForChat = [PFQuery queryWithClassName:@"Chat"];
//            [queryForChat includeKey:@"text"];
//            [queryForChat select:<#(id)#>]
//            [queryForChat whereKey:@"fromUsername" equalTo:[object objectForKey:@"fromUsername"]];
//            [queryForChat whereKey:@"toUsername" equalTo:[object objectForKey:@"toUsername"]];
//            [queryForChatRoom findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                if (!error) {
//                    [_messages addObject:[objects[0] objectForKey:@"text"]];
//                    NSLog(@"^^^chat object createdAt: %@", [objects[0] objectForKey:@"createdAt"]);
//                    //          [_timestamps addObject:[object objectForKey:@"createdAt"]];
//                }
//            }];
//        }
//    }
}

#pragma mark - Query

- (PFQuery *)queryForFromUsersTable {
    return nil;
}
@end
