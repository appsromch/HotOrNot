//
//  QCLeaderBoardCell.h
//  HotOrNot2
//
//  Created by Weiwei Shi on 7/14/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCLeaderBoardCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberOfLikesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
