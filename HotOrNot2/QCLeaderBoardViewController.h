//
//  QCLeaderBoardViewController.h
//  HotOrNot2
//
//  Created by Eliot Arntz on 7/10/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCLeaderBoardCell.h"

@interface QCLeaderBoardViewController : UIViewController
- (IBAction)topLikeButtonPressed:(id)sender;
- (IBAction)topDislikesButtonPressed:(id)sender;
- (IBAction)topLikerButtonPressed:(id)sender;
- (IBAction)topDislikerButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *leaderBoardTableView;
@property (strong, nonatomic) NSString *whichTableView;
- (NSArray*) leaderboardArray;
@property (strong, nonatomic) NSArray *photos;

@end
