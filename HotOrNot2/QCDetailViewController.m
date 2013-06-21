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
    
    NSArray *likedByArray = [self.user objectForKey:@"likedByUsers"];
    BOOL isAlreadyLiked = NO;
    PFUser *currentUser = [PFUser currentUser];
    
    if (likedByArray.count <= 0){
        NSString *currentUser = [[PFUser currentUser] objectForKey:@"profile"][@"name"];
        NSArray *currentArray = @[currentUser];
        [self.user setObject:currentArray forKey:@"likedByUsers"];
        [self.user save];
    }
    else {
        for (int x = 0; x < likedByArray.count; x++ ) {
            NSString *name = [likedByArray objectAtIndex:x];
            if ([name isEqualToString:[currentUser objectForKey:@"name"]]) {
                isAlreadyLiked = YES;
            }
        }
    }
    
    if (isAlreadyLiked == NO){
        NSMutableArray *likes = [[NSMutableArray alloc] initWithArray:likedByArray];
        [likes addObject:[currentUser objectForKey:@"profile"][@"name"]];
        NSArray *arrayToUpdate = [NSArray arrayWithArray:likes];
        [self.user setObject:arrayToUpdate forKey:@"likedByUsers"];
        [self.user save];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have already liked this person, move on" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        [alert show];
    }
    NSLog(@"current user now has a like %@", self.user);
    NSLog(@"%@", [self.user objectForKey:@"likedByUsers"]);

}
@end
