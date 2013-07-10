//
//  QCFirstViewController.m
//  HotOrNot2
//
//  Created by Eliot Arntz on 6/20/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import "QCFirstViewController.h"

@interface QCFirstViewController ()

@end

@implementation QCFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"User Profile", @"FirstComment");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    // Send request to Facebook
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            
            NSDictionary *userData = (NSDictionary *)result;
            NSLog(@"&&& %@", userData);
            NSString *facebookID = userData[@"id"];
            NSLog(@"&&& %@", facebookID);
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
            }
            if (userData[@"name"]) {
                userProfile[@"name"] = userData[@"name"];
            }
            if (userData[@"location"][@"name"]) {
                userProfile[@"location"] = userData[@"location"][@"name"];
            }
            if (userData[@"gender"]) {
                userProfile[@"gender"] = userData[@"gender"];
            }
            if (userData[@"birthday"]) {
                userProfile[@"birthday"] = userData[@"birthday"];
            }
            if (userData[@"relationship_status"]) {
                userProfile[@"relationship"] = userData[@"relationship_status"];
            }
            if ([pictureURL absoluteString]) {
                userProfile[@"pictureURL"] = [pictureURL absoluteString];
            }
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [self logoutButtonTouchHandler:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    [self startPhotoDownload];
    
    self.nameLabel.text = [[PFUser currentUser] objectForKey:@"profile"][@"name"];
    self.locationLabel.text = [[PFUser currentUser] objectForKey:@"profile"][@"location"];
    self.birthdayLabel.text = [[PFUser currentUser] objectForKey:@"profile"][@"birthday"];
    
    NSLog(@"*** %@", [[PFUser currentUser] objectForKey:@"profile"][@"location"]);
    NSLog(@"*** %@", [[PFUser currentUser] objectForKey:@"profile"][@"gender"]);
    NSLog(@"*** %@", [[PFUser currentUser] objectForKey:@"profile"][@"birthday"]);
    NSLog(@"*** %@", [[PFUser currentUser] objectForKey:@"profile"][@"relationship"]);
    NSLog(@"*** %@", [[PFUser currentUser] objectForKey:@"profile"][@"name"]);
    NSLog(@"*** %@", [[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]);
}

- (void)didReceiveMemoryWarning

{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - NSURLConnectionDataDelegate

/* Callback delegate methods used for downloading the user's profile picture */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // As chuncks of the image are received, we build our data file
    
    [self.imageData appendData:data];
    
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // All data has been downloaded, now we can set the image in the header image view
    
    NSLog(@"**** connectionDidFinishLoading");
    
    self.headerImageView.image = [UIImage imageWithData:self.imageData];
    
    
    
    // Add a nice corner radius to the image
    
    //    self.headerImageView.layer.cornerRadius = 8.0f;
    
    //    self.headerImageView.layer.masksToBounds = YES;
    
}





#pragma mark - Logout



- (void)logoutButtonTouchHandler:(id)sender {
    
    // Logout user, this automatically clears the cache
    
    [PFUser logOut];
    
}

#pragma mark - Start Photo Download

-(void)startPhotoDownload {
    
    self.imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
    NSLog(@"%@", [[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]);
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



- (IBAction)centerMapButtonPressed:(UIButton *)sender
{
    NSLog(@"centerMapbuttonPressed");
    [[QTLocation sharedInstance] startLocationManagerWithCompletion:^(BOOL foundLocation) {
        [self centerMapWithLocation:[QTLocation sharedInstance].placemark];
    }];
}
-(void)centerMapWithLocation:(CLPlacemark *)currentLocation{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(currentLocation.location.coordinate.latitude, currentLocation.location.coordinate.longitude);
    if (currentLocation.region.radius < 100) {
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(center, 400, 370)];
        [self.mapView setRegion:adjustedRegion animated:NO];
    }
    else{
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(center, currentLocation.region.radius, currentLocation.region.radius)];
        [self.mapView setRegion:adjustedRegion animated:NO];
    }
}
@end
