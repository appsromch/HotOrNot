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
        self.tabBarItem.image = [UIImage imageNamed:@"tab_leaderboard"];
        [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"textured_nav"] forBarMetrics:UIBarMetricsDefault];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.likerAndDislikerBOOL = NO;
    self.likerBOOL = YES;
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
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"toplikes_button"] forState:UIControlStateNormal];
    
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
    if (self.likerAndDislikerArray)
    {
        return self.likerAndDislikerArray.count;
    }
    else
    {
        return self.photos.count;
    }
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
    if (self.likerAndDislikerBOOL==YES)
    {
        if (self.likerBOOL==YES)
        {
            cell.numberImageView.image = [UIImage imageNamed:@"rank_box_magenta"];

        } else {
            cell.numberImageView.image = [UIImage imageNamed:@"rank_box_yellow"];
        }
        
        QCLikerAndDisliker *object= [[QCLikerAndDisliker alloc]init];
        object = [self.likerAndDislikerArray objectAtIndex:indexPath.row];
        PFObject *photo = object.photo;
        NSString *fullName = [photo[@"user"]objectForKey:@"profile"][@"name"];
        NSArray *separateName = [fullName componentsSeparatedByString:@" "];
        cell.nameLabel.text = separateName[0];
        NSString *fullLocation = [photo[@"user"] objectForKey:@"profile"][@"location"];
        NSArray *separateLocation = [fullLocation componentsSeparatedByString:@","];
        cell.addressLabel.text = separateLocation[1];
        cell.numberOfLikesLabel.text = [NSString stringWithFormat:@"%i",object.number];
        int rank = indexPath.row+1;
        cell.rankLabel.text = [NSString stringWithFormat:@"%i",rank];
        
        PFFile *file = photo[@"image"];
        cell.photoImageView.image = [UIImage imageNamed:@"placeHolderImage.png"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
         {
             UIImage *image = [UIImage imageWithData:data];
             cell.photoImageView.image = image;
         }];
        
    }
    else
    {
        if(self.likerBOOL==YES) {
            cell.numberImageView.image = [UIImage imageNamed:@"rank_box_orange.png"];
        } else {
            cell.numberImageView.image = [UIImage imageNamed:@"rank_box_green.png"];
        }
        
        PFObject *photo = [self.photos objectAtIndex:indexPath.row];
        NSNumber *number = photo[@"numberOfLikes"];
        
        NSString *fullName = [photo[@"user"]objectForKey:@"profile"][@"name"];
        NSArray *separateName = [fullName componentsSeparatedByString:@" "];
        cell.nameLabel.text = separateName[0];
        NSString *fullLocation = [photo[@"user"] objectForKey:@"profile"][@"location"];
        NSArray *separateLocation = [fullLocation componentsSeparatedByString:@","];
        cell.addressLabel.text = separateLocation[1];

        cell.numberOfLikesLabel.text = [NSString stringWithFormat:@"%@",number];
        int rank = indexPath.row+1;
        cell.rankLabel.text = [NSString stringWithFormat:@"%i",rank];

        PFFile *file = photo[@"image"];
        cell.photoImageView.image = [UIImage imageNamed:@"placeHolderImage.png"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.photoImageView.image = image;
        }];
    }
    return cell;
}

- (IBAction)topLikeButtonPressed:(id)sender
{
    self.likerAndDislikerBOOL = NO;
    self.likerBOOL = YES;
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
    self.likerAndDislikerBOOL = NO;
    self.likerBOOL = NO;
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
    self.likerAndDislikerBOOL = YES;
    self.likerBOOL = YES;
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    NSArray *array = [query findObjects];
    NSLog(@"array.count %i",array.count);
    
    NSLog(@"array %@",array);
    NSMutableArray *likerArray = [[NSMutableArray alloc]init];
    for (int x=1; x<array.count; x++)
    {
        PFQuery *userLikes = [PFQuery queryWithClassName:@"Activity"];
        [userLikes whereKey:@"type" equalTo:@"like"];
        [userLikes whereKey:@"photo" equalTo:array[x]];
        NSArray *userArray =[userLikes findObjects];
        QCLikerAndDisliker *liker = [[QCLikerAndDisliker alloc]init];
        liker.photo = array[x];
        liker.number = userArray.count;
        [likerArray addObject:liker];
    }

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.likerAndDislikerArray = [likerArray sortedArrayUsingDescriptors:sortDescriptors];
    [self.leaderBoardTableView reloadData];
}
- (IBAction)topDislikerButtonPressed:(id)sender
{
    self.likerAndDislikerBOOL = YES;
    self.likerBOOL = NO;
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    NSArray *array = [query findObjects];
    NSLog(@"array.count %i",array.count);
    
    NSLog(@"array %@",array);
    NSMutableArray *dislikerArray = [[NSMutableArray alloc]init];
    for (int x=1; x<array.count; x++)
    {
        PFQuery *userDislikes = [PFQuery queryWithClassName:@"Activity"];
        [userDislikes whereKey:@"type" equalTo:@"dislike"];
        [userDislikes whereKey:@"photo" equalTo:array[x]];
        NSArray *userArray =[userDislikes findObjects];
        QCLikerAndDisliker *disliker = [[QCLikerAndDisliker alloc]init];
        disliker.photo = array[x];
        disliker.number = userArray.count;
        [dislikerArray addObject:disliker];

    }

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.likerAndDislikerArray = [dislikerArray sortedArrayUsingDescriptors:sortDescriptors];
    [self.leaderBoardTableView reloadData];
}

@end
