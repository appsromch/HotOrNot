//
//  QCCustomCell.h
//  HotOrNot2
//
//  Created by Eliot Arntz on 6/21/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *relationshipLabel;


@end
