//
//  QCChatViewController.h
//  HotOrNot2
//
//  Created by Eliot Arntz on 7/11/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"

@interface QCChatViewController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource>

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;

@property (strong, nonatomic) PFObject *chatroom;

@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) PFUser *withUser;

@end
