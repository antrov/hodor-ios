//
//  HMeasurement.m
//  Hodor
//
//  Created by Antrov on 23.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import "HMeasurementCell.h"

@implementation HMeasurementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.avatarImgView.layer setMasksToBounds:YES];
    [self.avatarImgView.layer setCornerRadius:12.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
