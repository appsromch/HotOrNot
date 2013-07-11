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

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (nonatomic, strong) NSMutableData *imageData;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

- (IBAction)centerMapButtonPressed:(UIButton *)sender;

@end
