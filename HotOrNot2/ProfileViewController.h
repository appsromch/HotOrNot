//
//  QCFirstViewController.h
//  HotOrNot2
//
//  Created by Eliot Arntz on 6/20/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "QTLocation.h"
@class QCSettingsViewController;

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *numberOfLikes;

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *banner;

@property (nonatomic, strong) NSMutableData *imageData;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *interestedInLabel;
@end
