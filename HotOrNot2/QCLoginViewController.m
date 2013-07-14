//
//  QCLoginViewController.m
//  HotOrNot2
//
//  Created by Eliot Arntz on 6/20/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import "QCLoginViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "QCAppDelegate.h"

@interface QCLoginViewController ()

@end

@implementation QCLoginViewController

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
    // Do any additional setup after loading the view from its nib.
    
    //up and down state button
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login-button-small.png"] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login-button-small-pressed.png"] forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login-button-small-pressed.png"] forState:UIControlStateSelected];

    self.title = @"Facebook Profile";
}

-(void)viewDidAppear:(BOOL)animated
{
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        [self updateUserInformation];
        NSLog(@"the user is already signed in ");
        self.userSignIn = YES;
        [(QCAppDelegate*)[[UIApplication sharedApplication] delegate] createAndPresentTabBarController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(UIButton *)sender
{
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating]; // Hide loading indicato
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"*** Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            
            [self updateUserInformation];
 
            NSLog(@"User with facebook signed up and logged in!");
            [(QCAppDelegate*)[[UIApplication sharedApplication] delegate] createAndPresentTabBarController];
        } else {
            
            NSLog(@"else statement");
            
            [self updateUserInformation];
            
  
            NSLog(@"User with facebook logged in!");
            [(QCAppDelegate*)[[UIApplication sharedApplication] delegate] createAndPresentTabBarController];
        }
    }];
    
    [self.activityIndicator startAnimating]; // Show loading indicator until login is finished
}

- (BOOL)shouldUploadImage:(UIImage *)anImage
{
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    
    if (!imageData) {
        return NO;
    }
    
    self.photoFile = [PFFile fileWithData:imageData];
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    NSLog(@"Requested background expiration task with id %d for Anypic photo upload", self.fileUploadBackgroundTaskId);
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded successfully");
            
            //the first time the user logs into our application we are going to save a PhotoObject with the  users profile picture to Parse.  We will add additional functionality onto this PhotoObject (liking)
            
            PFObject *photo = [PFObject objectWithClassName:kPAPPhotoClassKey];
            [photo setObject:[PFUser currentUser] forKey:kPAPPhotoUserKey];
            [photo setObject:self.photoFile forKey:kPAPPhotoPictureKey];
            [photo setObject:@0 forKey:@"numberOfLikes"];
            [photo setObject:@0 forKey:@"numberOfDislikes"];

            
            // photos are public, but may only be modified by the user who uploaded them
//            PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
//            [photoACL setPublicReadAccess:YES];
//            photo.ACL = photoACL;
            
            // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
            self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
            }];
            
            // save
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Photo uploaded");
                    [[PAPCache sharedCache] setAttributesForPhoto:photo likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];
                    
                } else {
                    NSLog(@"Photo failed to save: %@", error);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                    [alert show];
                }
                [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
            }];

            
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    return YES;
}

-(void)userSignedIn
{

}


#pragma mark - NSURLConnectionDataDelegate

/* Callback delegate methods used for downloading the user's profile picture */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // As chuncks of the image are received, we build our data file
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // All data has been downloaded, now we can set the image in the header image view
    UIImage *profileImage = [UIImage imageWithData:self.imageData];    
    [self shouldUploadImage:profileImage];
}

#pragma mark - FacebookUserUpdate

-(void)updateUserInformation
{
    // Send request to Facebook
    FBRequest *request = [FBRequest requestForMe];
  
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            
            NSDictionary *userData = (NSDictionary *)result;
            NSString *facebookID = userData[@"id"];            
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
            
            
            
            PFQuery *query = [PFQuery queryWithClassName:kPAPPhotoClassKey];
            [query whereKey:@"user" equalTo:[PFUser currentUser]];
            NSArray *photosForUser = [query findObjects];
            if (photosForUser.count == 0){
                NSLog(@"logic worked");
                if (self.imageData == nil){
                    PFUser *user = [PFUser currentUser];
                    self.imageData = [[NSMutableData alloc] init];
                    
                    NSURL *pictureURL = [NSURL URLWithString:user[@"profile"][@"pictureURL"]];
                    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f];
                    // Run network request asynchronously
                    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
                    if (!urlConnection) {
                        NSLog(@"Failed to download picture");
                    }
                }
            }
            else {
                NSLog(@"*** logic still working");
            }
            

            
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

@end
