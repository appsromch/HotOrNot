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

-(void)setupBarButtonItems
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Chat" style:UIBarButtonItemStyleBordered target:self action:@selector(chatBarButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBarButtonItems];
    
    self.navigationItem.title = @"Like!";
    self.imageView.image = self.imageToBePassed;
    [self.imageView setUserInteractionEnabled:YES];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerTapped:)];
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    self.likeButton.enabled = NO;
    
    self.currentIndex = 0;
    NSLog(@"%@", self.pfPhotoObject);
    
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.photos = objects;
        if (self.photos.count > 0)
            self.pfPhotoObject = self.photos[self.currentIndex];
        
        if (!error && self.photos.count > 0){
            
            NSLog(@"self.photos %@", self.photos);
            
            PFFile *file = self.pfPhotoObject[@"image"];
            NSLog(@"file %@", file);
            self.imageView.image = [UIImage imageNamed:@"placeHolderImage.png"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *image = [UIImage imageWithData:data];
                self.imageView.image = image;
            }];
            
            self.isLikedByCurrentUser = YES;
            PFQuery *queryForLike = [PFQuery queryWithClassName:@"Activity"];
            [queryForLike whereKey:@"type" equalTo:@"like"];
            [queryForLike whereKey:@"photo" equalTo:self.pfPhotoObject];
            [queryForLike includeKey:@"fromUser"];
            [queryForLike includeKey:@"toUser"];
            
            [queryForLike findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                NSLog(@"********* %@", objects);
                if (!error) {
                    self.isLikedByCurrentUser = NO;
                    
                    if (objects.count == 0)
                    {
                        NSLog(@"count == 0");
                        self.isLikedByCurrentUser = NO;
                    }
                    else {
                        for (int x = 0; x < objects.count; x ++) {
                            PFObject *object = objects[x];
                            NSLog(@"%@ %@",object[@"fromUser"], [PFUser currentUser] );
                            if ([object[@"fromUser"][@"username"] isEqual:[PFUser currentUser][@"username"]]){
                                self.isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    self.isLikedByCurrentUser ? NSLog(@"YES") : NSLog(@"NO");
                    
                    self.likeButton.enabled = YES;
                }
            }];
            
            self.likeButton.enabled = YES;
        }
    }];
}

-(void)setupNextPhoto
{
    int maxPhotos = self.photos.count;
    
    if (self.currentIndex < maxPhotos -1){
        
        self.likeButton.enabled = NO;
        
        self.currentIndex ++;
        NSLog(@"%i", self.currentIndex);
        self.pfPhotoObject = self.photos[self.currentIndex];
        
        PFFile *file = self.pfPhotoObject[@"image"];
        self.imageView.image = [UIImage imageNamed:@"placeHolderImage.png"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            UIImage *image = [UIImage imageWithData:data];
            self.imageView.image = image;
            
            self.isLikedByCurrentUser = YES;
            PFQuery *queryForLike = [PFQuery queryWithClassName:@"Activity"];
            [queryForLike whereKey:@"type" equalTo:@"like"];
            [queryForLike whereKey:@"photo" equalTo:self.pfPhotoObject];
            [queryForLike includeKey:@"fromUser"];
            [queryForLike includeKey:@"toUser"];
            
            [queryForLike findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                NSLog(@"********* %@", objects);
                if (!error) {
                    self.isLikedByCurrentUser = NO;
                    
                    if (objects.count == 0)
                    {
                        self.isLikedByCurrentUser = NO;
                    }
                    else {
                        for (int x = 0; x < objects.count; x ++) {
                            PFObject *object = objects[x];
                            NSLog(@"%@ %@",object[@"fromUser"], [PFUser currentUser] );
                            if ([object[@"fromUser"][@"username"] isEqual:[PFUser currentUser][@"username"]]){
                                self.isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    self.isLikedByCurrentUser ? NSLog(@"YES") : NSLog(@"NO");
                    self.likeButton.enabled = YES;
                }
            }];
            self.likeButton.enabled = YES;
        }];
        
    }
    else {
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No more avaliable photos" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        //        [alertView show];
        NSLog(@"there are not more photos");
    }
    
}

-(void)setupPreviousPhoto
{
    self.currentIndex --;
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
    PFUser *user = self.pfPhotoObject[@"user"];
    
    if ([user[@"username"] isEqual:[PFUser currentUser][@"username"]]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This is your photo" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: nil];
        [alertView show];
    }
    else {
        
        // Add the current user as a liker of the photo in PAPCache
        [[PAPCache sharedCache] setPhotoIsLikedByCurrentUser:self.pfPhotoObject liked:self.isLikedByCurrentUser];
        
        if (!self.isLikedByCurrentUser) {
            [PAPUtility likePhotoInBackground:self.pfPhotoObject block:^(BOOL succeeded, NSError *error) {
                
                self.isLikedByCurrentUser = NO;
                self.likeButton.enabled = YES;
                NSLog(@"like Photo");
                
                PFObject *photo = self.pfPhotoObject;
                
                NSNumber *number = photo[@"numberOfLikes"];
                NSLog(@"%@", number);
                if (number == 0) {
                    [self.pfPhotoObject setObject:@1 forKey:@"numberOfLikes"];
                }
                else {
                    int x = [number integerValue] + 1;
                    NSNumber *number = [NSNumber numberWithInt:x];
                    [photo setObject:number forKey:@"numberOfLikes"];
                }
                
                [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    NSLog(@"photo save successful");
                    [self setupNextPhoto];
                }];
                
                self.likeButton.enabled = YES;
                            
                PFUser *currentUser = [PFUser currentUser];
                NSLog(@"currentUser %@", currentUser);
                PFUser *toUser = self.pfPhotoObject[@"user"];
                NSLog(@"toUser %@", toUser);
                PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
                [query whereKey:@"fromUser" equalTo:toUser];
                [query whereKey:@"toUser" equalTo:currentUser];
                [query whereKey:@"type" equalTo:@"like"];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    NSLog(@"!@#$ %@", objects);
                    PFObject *chatroom = [PFObject objectWithClassName:@"ChatRoom"];
                    [chatroom setObject:currentUser[@"username"] forKey:@"username1"];
                    [chatroom setObject:toUser[@"username"] forKey:@"username2"];
                    [chatroom setObject:currentUser[@"profile"][@"name"] forKey:@"name1"];
                    [chatroom setObject:toUser[@"profile"][@"name"] forKey:@"name2"];
                    [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        NSLog(@"chatroom object saved");
                    }];
                }];

            }];
        } else {
            NSLog(@"user has already liked Photo");
            //                        [PAPUtility unlikePhotoInBackground:self.pfPhotoObject block:^(BOOL succeeded, NSError *error) {
            //                            self.isLikedByCurrentUser = YES;
            //                            self.likeButton.enabled = YES;
            //                            NSLog(@"dislike Photo");
            //                        }];
            [self setupNextPhoto];
            
        }
        
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
            
            PFObject *photo = self.pfPhotoObject;
            
            NSNumber *number = photo[@"numberOfDislikes"];
            if (number == 0) {
                [self.pfPhotoObject setObject:@1 forKey:@"numberOfDislikes"];
            }
            else {
                int x = [number integerValue] + 1;
                NSNumber *number = [NSNumber numberWithInt:x];
                [photo setObject:number forKey:@"numberOfDislikes"];
            }
            
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"photo save successful");
            }];
            
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

-(void)chatBarButtonItemPressed:(id)sender
{
    QCAvaliableChatsViewController *avaliableChatsViewController = [[QCAvaliableChatsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:avaliableChatsViewController animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self setupNextPhoto];
}

@end
