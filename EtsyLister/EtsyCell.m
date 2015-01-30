//
//  EtsyCell.m
//  EtsyLister
//
//  Created by Rick Windham on 1/29/15.
//  Copyright (c) 2015 Rick Windham. All rights reserved.
//

#import "EtsyCell.h"

@implementation EtsyCell

#pragma mark - class methods

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - lifecycle methods

- (void)awakeFromNib {
    // Initialization code

}

#pragma mark - custom methods

- (void)fadeIn {
    self.alpha = 0.0f;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){}];
}

- (void)fadeOut {
    self.alpha = 1.0f;
    
    [UIView animateWithDuration:0.5
                     animations:^{ self.alpha = 0.0f; }
                     completion:^(BOOL finished){}];
}

#pragma mark - interaction methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
