//
//  QCSecondViewController.h
//  HotOrNot2
//
//  Created by Eliot Arntz on 6/20/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTLocation.h"
#import <Parse/Parse.h>
#import "QCDetailViewController.h"
#import "QCCustomCell.h"
#import "QCAvaliableChatsViewController.h"

@interface QCFeedViewController : UICollectionViewController

@property (strong, nonatomic) NSArray *photos;

@end
