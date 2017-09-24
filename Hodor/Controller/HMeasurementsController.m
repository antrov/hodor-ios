//
//  HMonitorController.m
//  Hodor
//
//  Created by Antrov on 23.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import "HApiClient.h"
#import "HMeasurement.h"
#import "HMeasurementCell.h"
#import "HMeasurementsController.h"
#import "MBProgressHUD.h"

@interface HMeasurementsController ()
@property (nonatomic) NSArray<HMeasurement *> *measurements;
@property (nonatomic) NSDateFormatter *formatter;
@end

@implementation HMeasurementsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formatter = [NSDateFormatter new];
    self.formatter.dateStyle = NSISO8601DateFormatWithDay;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    HApiClient.instance.getMeasurements.then(^(id measurements) {
        self.measurements = measurements;
        [self.tableView reloadData];
    }).catch(^(NSError *error) {
        
    }).finally(^() {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.measurements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"MeasurementCell" forIndexPath:indexPath];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    HMeasurementCell *measurementCell = (HMeasurementCell *)cell;
    HMeasurement *measurement = self.measurements[indexPath.row];
    
    measurementCell.avatarImgView.image = measurement.user.avatar;
    measurementCell.titleLabel.text = measurement.user.name;
    measurementCell.statusLabel.text = [self.formatter stringFromDate:measurement.timestamp];
}

@end
