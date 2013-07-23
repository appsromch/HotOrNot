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
    NSArray *array = [query findObjects];
    
    NSMutableArray *topLikesArray = [[NSMutableArray alloc]init];
    for (int x=0; x<array.count; x++)
    {
        PFQuery *likesForPhoto = [PFQuery queryWithClassName:@"Activity"];
        [likesForPhoto whereKey:@"type" equalTo:@"like"];
        [likesForPhoto whereKey:@"photo" equalTo:array[x]];
        NSArray *toPhoto =[likesForPhoto findObjects];
        QCLikerAndDisliker *liked = [[QCLikerAndDisliker alloc]init];
        liked.photo = array[x];
        liked.number = toPhoto.count;
        [topLikesArray addObject:liked];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.likerAndDislikerArray = [topLikesArray sortedArrayUsingDescriptors:sortDescriptors];
    [self.leaderBoardTableView reloadData];
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed: @"bg_leaderboard"]]];
    
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"toplikes_button"] forState:UIControlStateNormal];
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"top_likes_pressed"] forState:UIControlStateHighlighted];
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"top_likes_pressed"] forState:UIControlStateSelected];


    
    [self.dislikeButton setBackgroundImage:[UIImage imageNamed:@"top_dislikes_button-01"] forState:UIControlStateNormal];
    [self.dislikeButton setBackgroundImage:[UIImage imageNamed:@"top_dislikes_button_pressed"] forState:UIControlStateHighlighted];
    [self.dislikeButton setBackgroundImage:[UIImage imageNamed:@"top_dislikes_button_pressed"] forState:UIControlStateSelected];
    
    
    
    [self.likerButton setBackgroundImage:[UIImage imageNamed:@"liker_button-01"] forState:UIControlStateNormal];
    
    
    
    
    [self.dislikerButton setBackgroundImage:[UIImage imageNamed:@"disliker_button"] forState:UIControlStateNormal];
    [self.dislikerButton setBackgroundImage:[UIImage imageNamed:@"disliker_button_pressed"] forState:UIControlStateHighlighted];
    [self.dislikerButton setBackgroundImage:[UIImage imageNamed:@"disliker_button_pressed"] forState:UIControlStateSelected];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.likerAndDislikerArray.count;
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
        
        QCTopLikesAndDislikes *object= [[QCTopLikesAndDislikes alloc]init];
        object = [self.likerAndDislikerArray objectAtIndex:indexPath.row];
        PFUser *User = object.user;
        NSString *fullName = [User objectForKey:@"profile"][@"name"];
        NSArray *separateName = [fullName componentsSeparatedByString:@" "];
        cell.nameLabel.text = separateName[0];
        NSString *fullLocation = [User objectForKey:@"profile"][@"location"];
        NSArray *separateLocation = [fullLocation componentsSeparatedByString:@","];
        cell.addressLabel.text = separateLocation[1];
        cell.numberOfLikesLabel.text = [NSString stringWithFormat:@"%i",object.number];
        int rank = indexPath.row+1;
        cell.rankLabel.text = [NSString stringWithFormat:@"%i",rank];
        
        PFQuery *photoQuery = [PFQuery queryWithClassName:@"Photo"];
        [photoQuery whereKey:@"user" equalTo:User];
        
        NSArray *photo = [photoQuery findObjects];
        
        PFFile *file = photo[0][@"image"];
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
        
        QCLikerAndDisliker *object= [[QCLikerAndDisliker alloc]init];
        object = [self.likerAndDislikerArray objectAtIndex:indexPath.row];
        NSLog(@"____________%@", object);
        PFObject *photo = object.photo;
        NSString *fullName = [photo[@"user"] objectForKey:@"profile"][@"name"];
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
    return cell;
}

- (IBAction)topLikeButtonPressed:(id)sender
{
    self.likerAndDislikerBOOL = NO;
    self.likerBOOL = YES;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    NSArray *array = [query findObjects];
    NSLog(@"______array.count%i", array.count);
    NSMutableArray *topLikesArray = [[NSMutableArray alloc]init];
    for (int x=0; x<array.count; x++)
    {
        PFQuery *likesForPhoto = [PFQuery queryWithClassName:@"Activity"];
        [likesForPhoto whereKey:@"type" equalTo:@"like"];
        [likesForPhoto whereKey:@"photo" equalTo:array[x]];
        NSArray *toPhoto =[likesForPhoto findObjects];
        QCLikerAndDisliker *liked = [[QCLikerAndDisliker alloc]init];
        liked.photo = array[x];
        liked.number = toPhoto.count;
        [topLikesArray addObject:liked];
    }
    NSLog(@"_____________Toplikesarray.count %i",topLikesArray.count);
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.likerAndDislikerArray = [topLikesArray sortedArrayUsingDescriptors:sortDescriptors];
    [self.leaderBoardTableView reloadData];
}

- (IBAction)topDislikesButtonPressed:(id)sender
{
    self.likerAndDislikerBOOL = NO;
    self.likerBOOL = NO;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    NSArray *array = [query findObjects];
    
    NSMutableArray *topLikesArray = [[NSMutableArray alloc]init];
    for (int x=0; x<array.count; x++)
    {
        PFQuery *likesForPhoto = [PFQuery queryWithClassName:@"Activity"];
        [likesForPhoto whereKey:@"type" equalTo:@"dislike"];
        [likesForPhoto whereKey:@"photo" equalTo:array[x]];
        NSArray *toPhoto =[likesForPhoto findObjects];
        QCLikerAndDisliker *disliked = [[QCLikerAndDisliker alloc]init];
        disliked.photo = array[x];
        disliked.number = toPhoto.count;
        [topLikesArray addObject:disliked];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.likerAndDislikerArray = [topLikesArray sortedArrayUsingDescriptors:sortDescriptors];
    [self.leaderBoardTableView reloadData];
}

- (IBAction)topLikerButtonPressed:(id)sender
{
    self.likerAndDislikerBOOL = YES;
    self.likerBOOL = YES;
    PFQuery *query = [PFUser query];
    NSArray *array = [query findObjects];
    NSLog(@"array.count %i",array.count);
    
    NSLog(@"array %@",array);
    NSMutableArray *likerArray = [[NSMutableArray alloc]init];
    for (int x=0; x<array.count; x++)
    {
        PFQuery *fromUser = [PFQuery queryWithClassName:@"Activity"];
        [fromUser whereKey:@"type" equalTo:@"like"];
        [fromUser whereKey:@"fromUser" equalTo:array[x]];
        NSArray *userArray =[fromUser findObjects];
        QCTopLikesAndDislikes *liker = [[QCTopLikesAndDislikes alloc]init];
        liker.user = array[x];
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
    PFQuery *query = [PFUser query];
    NSArray *array = [query findObjects];
    NSLog(@"array.count %i",array.count);
    
    NSLog(@"array %@",array);
    NSMutableArray *dislikerArray = [[NSMutableArray alloc]init];
    for (int x=0; x<array.count; x++)
    {
        PFQuery *fromUserD = [PFQuery queryWithClassName:@"Activity"];
        [fromUserD whereKey:@"type" equalTo:@"dislike"];
        [fromUserD whereKey:@"fromUser" equalTo:array[x]];
        NSArray *userArray =[fromUserD findObjects];
        QCTopLikesAndDislikes *disliker = [[QCTopLikesAndDislikes alloc]init];
        disliker.user = array[x];
        disliker.number = userArray.count;
        [dislikerArray addObject:disliker];

    }

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.likerAndDislikerArray = [dislikerArray sortedArrayUsingDescriptors:sortDescriptors];
    [self.leaderBoardTableView reloadData];
}

@end
