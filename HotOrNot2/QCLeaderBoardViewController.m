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
//    UINavigationBar *naviBarObj = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    [self.view addSubview:naviBarObj];
    
    self.leaderBoardTableView.backgroundColor = [UIColor clearColor];
    
        PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
        [query includeKey:@"user"];
        [query orderByDescending:@"numberOfLikes"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
        {
            if (!error)
            {
                self.photos = objects;
                [self.leaderBoardTableView reloadData];
            }
        }];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed: @"bg_leaderboard"]]];
    
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"toplikes_button2"] forState:UIControlStateNormal];
    [self.dislikeButton setBackgroundImage:[UIImage imageNamed:@"top_dislikes_button-01"] forState:UIControlStateNormal];
    [self.likerButton setBackgroundImage:[UIImage imageNamed:@"liker_button-01"] forState:UIControlStateNormal];
    [self.dislikerButton setBackgroundImage:[UIImage imageNamed:@"disliker_button"] forState:UIControlStateNormal];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"QCLeaderBoardCell";
    
    QCLeaderBoardCell *cell = (QCLeaderBoardCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QCLeaderBoardCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];        
    }
    
    PFObject *photo = [self.photos objectAtIndex:indexPath.row];
    NSNumber *number = photo[@"numberOfLikes"];

    cell.nameLabel.text = [photo[@"user"]objectForKey:@"profile"][@"name"];
    cell.addressLabel.text = [photo[@"user"] objectForKey:@"profile"][@"location"];
    cell.numberOfLikesLabel.text = [NSString stringWithFormat:@"%@",number];
    
    PFFile *file = photo[@"image"];
    cell.photoImageView.image = [UIImage imageNamed:@"placeHolderImage.png"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        cell.photoImageView.image = image;
    }];
    
    return cell;
}

- (IBAction)topLikeButtonPressed:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    [query orderByDescending:@"numberOfLikes"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            self.photos = objects;
            [self.leaderBoardTableView reloadData];
        }
    }];
}

- (IBAction)topDislikesButtonPressed:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    [query orderByDescending:@"numberOfDislikes"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            self.photos = objects;
            [self.leaderBoardTableView reloadData];
        }
    }];
}

- (IBAction)topLikerButtonPressed:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    [query orderByDescending:@"numberOfLikes"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             self.photos = objects;
             [self.leaderBoardTableView reloadData];
         }
     }];
}
- (IBAction)topDislikerButtonPressed:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    [query orderByDescending:@"numberOfDislikes"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             self.photos = objects;
             [self.leaderBoardTableView reloadData];
         }
     }];
}

@end
