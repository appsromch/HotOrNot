//
//  QCDetailViewController.m
//  HotOrNot2
//
//  Created by Eliot Arntz on 6/21/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import "QCDetailViewController.h"

@interface QCDetailViewController ()

@end

@implementation QCDetailViewController

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
    
    self.navigationItem.title = @"Like!";
    self.imageView.image = self.imageToBePassed;
    [self.imageView setUserInteractionEnabled:YES];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerTapped:)];
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    self.likeButton.enabled = NO;
    PFQuery *queryForLike = [self queryForLike:self.pfPhotoObject];
    [queryForLike findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", objects);
        if (!error) {
            NSMutableArray *likers = [NSMutableArray array];
            
            self.isLikedByCurrentUser = YES;
            
            for (PFObject *activity in objects) {
                if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike] && [activity objectForKey:kPAPActivityFromUserKey]) {
                    [likers addObject:[activity objectForKey:kPAPActivityFromUserKey]];
                } else if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeComment] && [activity objectForKey:kPAPActivityFromUserKey]) {
                }
                
                NSLog(@"%@",[[activity objectForKey:kPAPActivityFromUserKey] objectId] );
                
                if ([[[activity objectForKey:kPAPActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                    if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike]) {
                        self.isLikedByCurrentUser = YES;
                    }
                }
            }
            
            self.likeButton.enabled = YES;
            
            //            NSDictionary *attributesForPhoto = [[PAPCache sharedCache] attributesForPhoto:self.pfPhotoObject];
            //            if (attributesForPhoto)
            //            {
            //                NSArray *likes = attributesForPhoto[@"likers"];
            //                self.isLikedByCurrentUser = YES;
            //                for (int x = 0; x < likes.count; x ++) {
            //                    PFUser *user = likes[x];
            //                    if ([user[@"profile"][@"facebookId"] isEqual:[PFUser currentUser][@"profile"][@"facebookId"]]) {
            //                        self.isLikedByCurrentUser = NO;
            //                    }
            //                }
            //            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelBarButtonItemPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapGestureRecognizerTapped:(id)sender
{
    [self like];
}

- (IBAction)likebuttonPressed:(UIButton *)sender
{
    NSLog(@"like button Pressed");
    [self like];
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    [self dislike];
    NSLog(@"dislike button");
}

#pragma mark - Helper

-(void)like
{
    self.likeButton.enabled = NO;
    PFUser *user = self.pfPhotoObject[@"user"];
    
    if ([user isEqual:[PFUser currentUser]]) {
        
    }
    else {
        
        PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
        [query whereKey:@"type" equalTo:@"like"];
        [query whereKey:@"photo" equalTo:self.pfPhotoObject];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (objects.count == 0)
                {
                    // Add the current user as a liker of the photo in PAPCache
                    [[PAPCache sharedCache] setPhotoIsLikedByCurrentUser:self.pfPhotoObject liked:self.isLikedByCurrentUser];
                    
                    if (self.isLikedByCurrentUser) {
                        [PAPUtility likePhotoInBackground:self.pfPhotoObject block:^(BOOL succeeded, NSError *error) {
                            self.isLikedByCurrentUser = NO;
                            self.likeButton.enabled = YES;
                            NSLog(@"like Photo");
                            
                            PFQuery *queryForLike = [PFQuery queryWithClassName:@"like"];
                            [queryForLike whereKey:@"user" equalTo:user];
                            [queryForLike findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                if (!error) {
                                    for (PFObject *activity in objects) {
                                        NSLog(@"^^^Activity: %@", activity);
                                        if ([[activity objectForKey:@"user"] isEqual:[PFUser currentUser]]) {
                                            //check chats here
                                            NSLog(@"^^^User liked me");
                                        }
                                    }
                                }
                            }];
                        }];
                    } else {
                        [PAPUtility unlikePhotoInBackground:self.pfPhotoObject block:^(BOOL succeeded, NSError *error) {
                            self.isLikedByCurrentUser = YES;
                            self.likeButton.enabled = YES;
                            NSLog(@"dislike Photo");
                        }];
                    }
                    
                    
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    NSLog(@"user has already liked photo");
                }
            }
        }];

    }
    
}

-(void)dislike {
    self.dislikeButton.enabled = NO;
    // Add the current user as a liker of the photo in PAPCache
    //    [[PAPCache sharedCache] setPhotoIsLikedByCurrentUser:self.pfPhotoObject liked:self.isLikedByCurrentUser];
    
    self.isDislikedByCurrentUser = YES;
    
    if (self.isDislikedByCurrentUser) {
        
        [PAPUtility dislikePhotoInBackground:self.pfPhotoObject block:^(BOOL succeeded, NSError *error) {
            self.isDislikedByCurrentUser = NO;
            self.dislikeButton.enabled = YES;
            NSLog(@"dislike Photo dislikePhotoInBackground");
        }];
    } else {
        [PAPUtility undislikePhotoInBackground:self.pfPhotoObject block:^(BOOL succeeded, NSError *error) {
            self.isDislikedByCurrentUser = YES;
            self.dislikeButton.enabled = YES;
            NSLog(@"dislike Photo");
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Query

-(PFQuery *)queryForLike:(PFObject *)photoPFObject
{
    PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:photoPFObject cachePolicy:kPFCachePolicyNetworkOnly];
    return query;
}

@end
