//
//  QTLocation.h
//  Access_Code_PhotoApp
//
//  Created by Eliot Arntz on 6/7/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QTLocationDelegate

-(void)didFindPlaceMark;

@end

typedef void (^MyCompletionBlock)(BOOL);

@interface QTLocation : NSObject <CLLocationManagerDelegate, MKAnnotation>

@property (nonatomic, retain) id <QTLocationDelegate> delegate;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) UIImage *coreDataImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) __block MyCompletionBlock completionBlock;

+(QTLocation *)sharedInstance;

-(void)startLocationManagerWithCompletion:(void (^)(BOOL foundLocation))completionBlock;
-(void)searchLocationWithString:(NSString *)string completion:(void (^)(BOOL foundLocation))completionBlock;
@end

