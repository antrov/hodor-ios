//
//  HUserCell.h
//  Hodor
//
//  Created by Antrov on 23.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUserCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
