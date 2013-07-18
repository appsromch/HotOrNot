//
//  QCLeaderBoardViewController.h
//  HotOrNot2
//
//  Created by Eliot Arntz on 7/10/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCLeaderBoardViewController.h"
#import "QCLeaderBoardCell.h"
#import "QCLikerAndDisliker.h"

@interface QCLeaderBoardViewController : UIViewController
- (IBAction)topLikeButtonPressed:(id)sender;
- (IBAction)topDislikesButtonPressed:(id)sender;
- (IBAction)topLikerButtonPressed:(id)sender;
- (IBAction)topDislikerButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *leaderBoardTableView;
@property (nonatomic) BOOL likerAndDislikerBOOL;
@property (nonatomic) BOOL likerBOOL;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSArray *likerAndDislikerArray;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;
@property (strong, nonatomic) IBOutlet UIButton *likerButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikerButton;

@end
