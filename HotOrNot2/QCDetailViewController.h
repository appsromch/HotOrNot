//
//  QCDetailViewController.h
//  HotOrNot2
//
//  Created by Eliot Arntz on 6/21/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "QCAvaliableChatsViewController.h"

@interface QCDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;

@property (strong, nonatomic) UIImage *imageToBePassed;
@property (strong, nonatomic) PFObject *pfPhotoObject;
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;

@property (strong, nonatomic) NSArray *photos;
@property (nonatomic) int currentIndex;

- (IBAction)likebuttonPressed:(UIButton *)sender;
- (IBAction)dislikeButtonPressed:(UIButton *)sender;

@end
