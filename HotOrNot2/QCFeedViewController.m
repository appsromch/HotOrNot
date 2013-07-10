//
//  QCSecondViewController.m
//  datingApplication
//
//  Created by Eliot Arntz on 6/18/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import "QCSecondViewController.h"

@interface QCSecondViewController ()

@end

@implementation QCSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Feed", @"Feed Of Photos");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navigationItem.title = @"Feed";
    
    [[QTLocation sharedInstance] startLocationManagerWithCompletion:^(BOOL foundLocation) {
        NSLog(@"*** location Found %@", [QTLocation sharedInstance].placemark);
        
        PFQuery *query = [PFUser query];
        CLPlacemark *placemark = [QTLocation sharedInstance].placemark;
        PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLocation:placemark.location];
        [[PFUser currentUser] setObject:userGeoPoint forKey:@"location"];
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:placemark.location];
//        [query whereKey:@"location" nearGeoPoint:geoPoint withinMiles:10000];
        self.users = [query findObjects];
        NSLog(@"%@", self.users);
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSourceMethod

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    QCCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QCCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.photoImageView.image = [UIImage imageNamed:@"loading.jpeg"];
    PFUser *user = [self.users objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[user objectForKey:@"profile"][@"pictureURL"]];
    
    cell.nameLabel.text = [user objectForKey:@"profile"][@"name"];
    if ([user objectForKey:@"profile"][@"relationship"] == nil){
        cell.relationshipLabel.text = @"Whoa!";
    }
    else {
        cell.relationshipLabel.text = @"Don't Bother";
    }
    
    // download the image asynchronously
    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
            cell.photoImageView.image = image;
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 200;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return @"Potential Mates";
    }
    else if (section == 1){
        return @"Duds";
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QCCustomCell *cell = (QCCustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    QCDetailViewController *detailVC = [[QCDetailViewController alloc] initWithNibName: nil bundle:nil];
    detailVC.imageToBePassed = cell.photoImageView.image;
    detailVC.user = [self.users objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
//    [self presentViewController:detailVC animated:YES completion:nil];
}

#pragma mark - Helper

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSLog(@"downLoadImageWithURL");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}


@end
