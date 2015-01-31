//
//  EtsyCell.m
//  EtsyLister
//
//  Created by Rick Windham on 1/29/15.
//  Copyright (c) 2015 Rick Windham. All rights reserved.
//

#import "EtsyCell.h"
#import "Haneke.h"

@implementation EtsyCell

#pragma mark - class methods

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - lifecycle methods

- (void)awakeFromNib {
    // Initialization code

}

#pragma mark - accessors

- (NSString *)imageURL {
    return _imageURL;
}

- (void)setImageURL:(NSString *)imageURL {
    if ([_imageURL isEqualToString:imageURL] == NO) {
        _imageURL = imageURL;
        
        if (_imageURL) {
            [_itemImage hnk_setImageFromURL:[NSURL URLWithString:_imageURL] placeholder:[UIImage imageNamed:@"EtsyLogo"]];
        }
    }
}

#pragma mark - custom methods

- (void)fadeIn {
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:nil];
}

- (void)fadeOut {
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.alpha = 0.25f;
                     }
                     completion:nil];
}

#pragma mark - interaction methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
