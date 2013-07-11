//
//  QCCollectionViewFlowLayout.m
//  HotOrNot2
//
//  Created by Eliot Arntz on 7/9/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import "QCCollectionViewFlowLayout.h"

@implementation QCCollectionViewFlowLayout

-(id)init {
    self = [super init];
    if(!self) return nil;
    
//    self.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1);
//    self.itemSize = CGSizeMake(200, 200);
//    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newAttributes = [NSMutableArray arrayWithCapacity:attributes.count];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if ((attribute.frame.origin.x + attribute.frame.size.width <= self.collectionViewContentSize.width) &&
            (attribute.frame.origin.y + attribute.frame.size.height <= self.collectionViewContentSize.height)) {
            [newAttributes addObject:attribute];
        }
    }
    return newAttributes;
}

@end