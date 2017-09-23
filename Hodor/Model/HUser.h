//
//  HUser.h
//  Hodor
//
//  Created by Antrov on 23.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <UIKit/UIKit.h>

@interface HUser : JSONModel
@property (nonatomic) NSString *id;
@property (nonatomic) NSString *name;
//@property (nonatomic) UIImage *avatar;
@end
