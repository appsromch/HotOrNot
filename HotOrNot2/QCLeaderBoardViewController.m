//
//  QCLeaderBoardViewController.m
//  HotOrNot2
//
//  Created by Eliot Arntz on 7/10/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import "QCLeaderBoardViewController.h"

@interface QCLeaderBoardViewController ()

@end

@implementation QCLeaderBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Leaderboard", @"FirstComment");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"QCLeaderBoardCell";
    
    QCLeaderBoardCell *cell = (QCLeaderBoardCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QCLeaderBoardCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        [self leaderboardArray];
        
    }
    return cell;
}

- (NSArray*) leaderboardArray
{
   NSArray *leaderboardArray = [[NSArray alloc]init];
    
    if ([self.whichTableView isEqualToString:@"topLike"])
    {
        NSLog(@"topLikeArray");
    }
    else if ([self.whichTableView isEqualToString:@"topDislike"])
    {
        NSLog(@"topDislike");
    }
    else if ([self.whichTableView isEqualToString:@"topliker"])
    {
        NSLog(@"topDisliker");
    }
    else if ([self.whichTableView isEqualToString: @"topDisliker"])
    {
        NSLog(@"topDisliker");
    }
    
    return leaderboardArray;
}

- (IBAction)topLikeButtonPressed:(id)sender
{
    self.whichTableView = @"topLike";
    [self.leaderBoardTableView reloadData];
}

- (IBAction)topDislikesButtonPressed:(id)sender
{
    self.whichTableView = @"topDislike";
    [self.leaderBoardTableView reloadData];
}

- (IBAction)topLikerButtonPressed:(id)sender
{
    self.whichTableView = @"topLiker";
    [self.leaderBoardTableView reloadData];
}

- (IBAction)topDislikerButtonPressed:(id)sender
{
    self.whichTableView = @"topDisliker";
    [self.leaderBoardTableView reloadData];
}

@end
