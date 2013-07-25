//
//  QCFirstViewController.m
//  HotOrNot2
//
//  Created by Eliot Arntz on 6/20/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import "ProfileViewController.h"
//#import "QCSettingsViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Profile", @"FirstComment");
        self.tabBarItem.image = [UIImage imageNamed:@"tab_profile"];
        
    }
    return self;
}

//-(void)setupBarButtonItem
//{
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(settingsBarButtonItemPressed:)];
//    self.navigationItem.rightBarButtonItem = barButtonItem;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
   
//    [self setupBarButtonItem];
    
    [self startPhotoDownload];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_profile2"]]];
    
    NSString *uppercaseName = [[[PFUser currentUser] objectForKey:@"profile"][@"first_name"] uppercaseString];
    PFQuery *numberOfLikes = [PFQuery queryWithClassName:@"Activity"];
    [numberOfLikes whereKey:@"toUser" equalTo:[PFUser currentUser]];
    [numberOfLikes whereKey:@"type" equalTo:@"like"];
    [numberOfLikes countObjectsInBackgroundWithBlock:^(int number, NSError *error)
     {
         self.numberOfLikes.text = [NSString stringWithFormat:@"%i", number];
     }];
    self.nameLabel.text = uppercaseName;
    self.locationLabel.text = [[PFUser currentUser] objectForKey:@"profile"][@"location"];

    
    // Code to create age label
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    NSDate *date = [formatter dateFromString:[[PFUser currentUser] objectForKey:@"profile"][@"birthday"]];
    NSDate *now = [NSDate date];
    NSTimeInterval seconds = [now timeIntervalSinceDate: date];
    NSInteger ageInt = seconds / 31536000;
    NSString *ageStr = [[NSString stringWithFormat:@"%i", (int)ageInt] stringByAppendingString:@" years old"];
    self.ageLabel.text = ageStr;
    
    
    // Code to retrieve interested in from fb
    if ([[PFUser currentUser] objectForKey:@"profile"][@"interested_in"])
    {
        NSArray *interestedIn = [[NSArray alloc] initWithArray:[[PFUser currentUser] objectForKey:@"profile"][@"interested_in"]];
        NSString  *interestedInAtIndex = [interestedIn objectAtIndex:0];
        NSString *upperCaseInterestedIn = [interestedInAtIndex stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[interestedInAtIndex  substringToIndex:1] capitalizedString]];
        NSString *firstInterestedIn = [@"Preference: " stringByAppendingString:upperCaseInterestedIn];
        self.interestedInLabel.text = firstInterestedIn;

    }
    else
    {
        self.interestedInLabel.text = @"Preference unknown";
    }
    
//    NSLog(@"*** %@", [[PFUser currentUser] objectForKey:@"profile"][@"location"]);
//    NSLog(@"*** %@", [[PFUser currentUser] objectForKey:@"profile"][@"gender"]);
//    NSLog(@"*** %@", [[PFUser currentUser] objectForKey:@"profile"][@"relationship"]);
//    NSLog(@"*** %@", [[PFUser currentUser] objectForKey:@"profile"][@"name"]);
//    NSLog(@"*** %@", [[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLConnectionDataDelegate

/* Callback delegate methods used for downloading the user's profile picture */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{    
    // As chuncks of the image are received, we build our data file
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // All data has been downloaded, now we can set the image in the header image view
    
    self.headerImageView.image = [UIImage imageWithData:self.imageData];
    self.headerImageView.layer.cornerRadius = 8.0f;
    self.headerImageView.layer.masksToBounds = YES;
    self.banner.image = [UIImage imageNamed:@"ribbon"];
}

#pragma mark - Logout

- (void)logoutButtonTouchHandler:(id)sender
{    
    // Logout user, this automatically clears the cache
    [PFUser logOut];
}

#pragma mark - Start Photo Download

-(void)startPhotoDownload
{    
    self.imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
    if ([[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]) {
        NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]];

        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
        cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f];
        // Run network request asynchronously
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        if (!urlConnection) {
            NSLog(@"Failed to download picture");
        }
    }    
}

//- (IBAction)centerMapButtonPressed:(UIButton *)sender
//{
//    NSLog(@"centerMapbuttonPressed");
//    [[QTLocation sharedInstance] startLocationManagerWithCompletion:^(BOOL foundLocation) {
//        [self centerMapWithLocation:[QTLocation sharedInstance].placemark];
//    }];
//}
//-(void)centerMapWithLocation:(CLPlacemark *)currentLocation{
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(currentLocation.location.coordinate.latitude, currentLocation.location.coordinate.longitude);
//    if (currentLocation.region.radius < 100) {
//        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(center, 400, 370)];
//        [self.mapView setRegion:adjustedRegion animated:NO];
//    }
//    else{
//        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(center, currentLocation.region.radius, currentLocation.region.radius)];
//        [self.mapView setRegion:adjustedRegion animated:NO];
//    }
//}

//-(void)settingsBarButtonItemPressed:(id)sender
//{
//    QCSettingsViewController *settingsViewController = [[QCSettingsViewController alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:settingsViewController animated:YES];
//}
@end
