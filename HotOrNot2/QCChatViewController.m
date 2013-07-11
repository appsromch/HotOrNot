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
    
    
    //setup users
    self.currentUser = [PFUser currentUser];
    self.withUser = [PFUser currentUser];
    
    self.title = @"Messages";
    
    self.messages = [[NSMutableArray alloc] initWithObjects:
                     @"Testing some messages here.",
                     @"This work is based on Sam Soffes' SSMessagesViewController.",
                     @"This is a complete re-write and refactoring.",
                     @"It's easy to implement. Sound effects and images included. Animations are smooth and messages can be of arbitrary size!",
                     nil];
    
    self.timestamps = [[NSMutableArray alloc] initWithObjects:
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate date],
                       nil];
    PFQuery *query = [self queryForFromUsersTable];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", objects);
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [self.messages addObject:text];
    
    [self.timestamps addObject:[NSDate date]];
    
    if((self.messages.count - 1) % 2)
        [JSMessageSoundEffect playMessageSentSound];
    else
        [JSMessageSoundEffect playMessageReceivedSound];
    
    [self finishSend];
    
    if (text.length != 0) {
        // Create the comment activity object
        PFObject *chat = [PFObject objectWithClassName:kPAPActivityClassKey];
        [chat setValue:text forKey:kPAPActivityContentKey]; // Set comment text
        [chat setValue:self.withUser forKey:kPAPActivityToUserKey]; // Set toUser
        [chat setValue:self.currentUser forKey:kPAPActivityFromUserKey]; // Set fromUser
        [chat setValue:kPAPActivityTypeChat forKey:kPAPActivityTypeKey];
        
        // Set the proper ACLs
        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [ACL setPublicReadAccess:YES];
        chat.ACL = ACL;
        
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
                // Reload the table to display the new comment
                
                PFQuery *query = [self queryForFromUsersTable];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    NSLog(@"*** objects %@", objects);
//                    self.objects = objects;
//                    [self.tableView reloadData];
                }];
            }
        }];
    }
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2) ? JSBubbleMessageStyleIncomingDefault : JSBubbleMessageStyleOutgoingDefault;
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

#pragma mark - Query

- (PFQuery *)queryForFromUsersTable {
    
    PFQuery *queryMessageForUser = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [queryMessageForUser whereKey:kPAPActivityToUserKey equalTo:self.withUser];
    [queryMessageForUser whereKey:kPAPActivityFromUserKey equalTo:self.currentUser];
    [queryMessageForUser whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeChat];

    PFQuery *queryMessageSentToUser = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [queryMessageSentToUser whereKey:kPAPActivityToUserKey equalTo:self.withUser];
    [queryMessageSentToUser whereKey:kPAPActivityFromUserKey equalTo:self.withUser];
    [queryMessageSentToUser whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeChat];
    
    PFQuery *chatquery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryMessageForUser, queryMessageSentToUser, nil]];
    
    [chatquery orderByAscending:@"createdAt"];
    
    return chatquery;
}
@end
