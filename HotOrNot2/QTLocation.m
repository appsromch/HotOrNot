//
//  QTLocation.m
//  Access_Code_PhotoApp
//
//  Created by Eliot Arntz on 6/7/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import "QTLocation.h"

@implementation QTLocation
{
    BOOL updatingLocation;
    NSError *lastLocationError;
    BOOL didFindLocation;
}

//this is where we define our singleton
+(QTLocation *)sharedInstance
{    
    static dispatch_once_t pred;
    static QTLocation *locationInstance = nil;
    dispatch_once(&pred, ^{
        locationInstance = [[QTLocation alloc]init];
    });
    return locationInstance;
}

-(void)startLocationManagerWithCompletion:(void (^)(BOOL foundLocation))completionBlock
{
    [self stopLocationManager];
    
    self.completionBlock = completionBlock;
    
    if (!self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    // Configure location manager
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500;
    [self.locationManager startUpdatingLocation];
    
    // Tell ourselves we're updating
    updatingLocation = YES;
}

-(void)stopLocationManager
{
    if(updatingLocation) {
        [self.locationManager stopUpdatingLocation];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didTimeOut:) object:nil];
        self.locationManager.delegate = self;
        updatingLocation = NO;
    }
}

-(void)didTimeOut:(id)obj
{    
    NSLog(@"Location timed out");
    if (!self.location) {
        [self stopLocationManager];
        lastLocationError = [NSError errorWithDomain:@"MyLocationsErrorDomain" code:1 userInfo:nil];
    }
}

#pragma mark - TestCoreLocationManager delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    didFindLocation = YES;
    self.location = [locations objectAtIndex:0];
    
    NSLog(@"Updated location %@", self.location);
    if (!self.geocoder)
    {
        self.geocoder = [[CLGeocoder alloc]init];
    }
    
    [self.geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finished reverse geocoding: %@ error: %@", _placemark, error);
        self.placemark = [placemarks objectAtIndex:0];
        [self.delegate didFindPlaceMark];
        self.completionBlock(YES);
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError %@", error);
    self.completionBlock(NO);
    
    if (error.code == kCLErrorLocationUnknown)
    {
        return;
    }
    [self stopLocationManager];
    lastLocationError = error;
    NSLog(@"lastlocerror %@", lastLocationError);
}

-(void)resetLocation
{
    _location = nil;
}

-(void)searchLocationWithString:(NSString *)string completion:(void (^)(BOOL foundLocation))completionBlock
{
    self.completionBlock = completionBlock;
    if (nil == self.geocoder) {
        self.geocoder = [[CLGeocoder alloc]init];
    }
    [self.geocoder geocodeAddressString:string
                  completionHandler:^(NSArray* placemarks, NSError* error)
                    {
                      //for (CLPlacemark* aPlacemark in placemarks)
                      CLPlacemark *placemark = [placemarks objectAtIndex:0];
                      self.placemark = placemark;
                      self.location = placemark.location;
                      self.completionBlock(YES);
                  }];
    
}

-(NSString *)title
{
    if (self.placemark.subLocality) {
        self.title = self.placemark.subLocality;
        return self.title;
    }
    else if (self.placemark.subAdministrativeArea){
        self.title = self.placemark.subAdministrativeArea;
        return self.title;
    }
    
    self.title = self.placemark.administrativeArea;
    return self.title;
}


@end
