//
//  HUserCell.m
//  Hodor
//
//  Created by Antrov on 23.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import "HUserCell.h"

@implementation HUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.avatarImgView.layer setMasksToBounds:YES];
    [self.avatarImgView.layer setCornerRadius:24.0];
}

@end
