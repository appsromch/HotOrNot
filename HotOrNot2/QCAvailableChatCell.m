//
//  QCAvailableChatCell.m
//  HotOrNot
//
//  Created by Just Carry On on 7/16/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import "QCAvailableChatCell.h"

@implementation QCAvailableChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    NSLog(@"^^^QCAvailableChatCell was initialized");
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
