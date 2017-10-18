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
#import "HUsersController.h"
#import "HSensorService.h"
#import "MBProgressHUD.h"
#import "UIViewController+PromiseKit.h"

#import <AudioToolbox/AudioToolbox.h>

@interface HMeasurementsController ()
@property (nonatomic) NSMutableArray<HMeasurement *> *measurements;
@property (nonatomic) NSDateFormatter *formatter;
@end

@implementation HMeasurementsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[HSensorService instance] start];
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
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(sensorServiceRecordDidStart:) name:HSensorServiceRecordDidStartNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(sensorServiceRecordDidStop:) name:HSensorServiceRecordDidStopNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(sensorServiceMeasurementDidApear:) name:HSensorServiceMeasurementDidApearNotification object:nil];
}

#pragma mark - Notifications

- (void)sensorServiceRecordDidStart:(NSNotification *)notification {
    self.navigationController.tabBarItem.badgeValue = @"●";
}

- (void)sensorServiceRecordDidStop:(NSNotification *)notification {
    self.navigationController.tabBarItem.badgeValue = nil;
}

- (void)sensorServiceMeasurementDidApear:(NSNotification *)notification {
    NSURL *fileURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/Tock.caf"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)fileURL,&soundID);
    AudioServicesPlaySystemSound(soundID);
    
    [self testAddAction:self];
}

- (void)presentUserSelectorForMeasurement:(HMeasurement *)measurement {
    HUsersController *usersController = [self.storyboard instantiateViewControllerWithIdentifier:@"UsersController"];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:usersController];
    
    __weak HMeasurementsController *weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self promiseViewController:navigation animated:YES completion:nil].then(^(HUser *user) {
        measurement.user = user;
        measurement.userId = user.id;
        return [HApiClient.instance updateMeasurement:measurement];
    }).then(^(HMeasurement *result) {
        [weakSelf updateMeasurement:measurement with:result];
    }).catch(^(NSError *error) {
        NSLog(@"%@", error);
    }).finally(^() {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    });
}

- (void)updateMeasurement:(HMeasurement *)old with:(HMeasurement *)new {
    NSInteger index = [self.measurements indexOfObject:old];
    
    static HUser *unrecognizedUser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unrecognizedUser = [HUser new];
        unrecognizedUser.name = @"Unrecognized";
        unrecognizedUser.avatar = [UIImage imageNamed:@"user"];
    });
    
    if (!new.user) {
        new.user = unrecognizedUser;
    }
    
    if (index != NSNotFound) {
        [self.measurements replaceObjectAtIndex:index withObject:new];
        [self.tableView reloadData];
    }
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

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.measurements[indexPath.row].id != nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self presentUserSelectorForMeasurement:self.measurements[indexPath.row]];
}

// For testing purposes; Should be change to notifications deriven methods
- (IBAction)testAddAction:(NSObject *)sender {
    HMeasurement *measurement = [HMeasurement new];
    measurement.timestamp = [NSDate new];
    
    [self.measurements insertObject:measurement atIndex:0];
    [self.tableView reloadData];
    
    __weak HMeasurementsController *weakSelf = self;
    
    [HApiClient.instance createMeasurement:measurement].then(^(HMeasurement *result) {
        [weakSelf updateMeasurement:measurement with:result];
    });
}

@end
