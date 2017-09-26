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
@property (nonatomic) NSMutableArray<HMeasurement *> *measurements;
@property (nonatomic) NSDateFormatter *formatter;
@end

@implementation HMeasurementsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formatter = [NSDateFormatter new];
    self.formatter.dateStyle = NSISO8601DateFormatWithDay;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    HApiClient.instance.getMeasurements.then(^(id measurements) {
        self.measurements = [measurements mutableCopy];
        [self.tableView reloadData];
    }).catch(^(NSError *error) {
        self.measurements = [NSMutableArray new];
    }).finally(^() {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(testAddAction:)];
    self.navigationItem.rightBarButtonItem = item;
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
    
    measurementCell.titleLabel.text = measurement.user.name;
    measurementCell.avatarImgView.image = measurement.user.avatar;
    measurementCell.avatarImgView.hidden = measurement.id == nil;
    measurementCell.activityIndicator.hidden = measurement.id != nil;
    measurementCell.statusLabel.text = [self.formatter stringFromDate:measurement.timestamp];
    
    if (!measurement.id) {
        measurementCell.titleLabel.text = @"Pending";
        [measurementCell.activityIndicator startAnimating];
    }
}

- (IBAction)testAddAction:(NSObject *)sender {
    HMeasurement *m = [HMeasurement new];
    m.timestamp = [NSDate new];
    
    [self.measurements insertObject:m atIndex:0];
    [self.tableView reloadData];
    
    __weak HMeasurementsController *weakSelf = self;
    static HUser *unrecognizedUser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unrecognizedUser = [HUser new];
        unrecognizedUser.name = @"Unrecognized";
        unrecognizedUser.avatar = [UIImage imageNamed:@"user"];
    });
    
    [HApiClient.instance createMeasurement:m].then(^(HMeasurement *measruement) {
        NSInteger index = [weakSelf.measurements indexOfObject:m];
        
        if (!measruement.user) {
            measruement.user = unrecognizedUser;
        }
        
        if (index != NSNotFound) {
            [weakSelf.measurements replaceObjectAtIndex:index withObject:measruement];
            [weakSelf.tableView reloadData];
        }
    });
}

@end
