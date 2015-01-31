//
//  EtsyCell.h
//  EtsyLister
//
//  Created by Rick Windham on 1/29/15.
//  Copyright (c) 2015 Rick Windham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EtsyCell : UITableViewCell {
    NSString *_imageURL;
}
@property (strong, nonatomic)        NSString *imageURL;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (void)fadeIn;
- (void)fadeOut;
@end
