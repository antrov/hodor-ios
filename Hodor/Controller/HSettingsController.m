//
//  HSettingsController.m
//  Hodor
//
//  Created by Antrov on 27.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import "HSettings.h"
#import "HSettingsController.h"

@interface HSettingsController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *autoTurnOffSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *darnkessDetectionSwitch;
@property (weak, nonatomic) IBOutlet UITextField *hoursTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *hoursPicker;
@property (strong, nonatomic) IBOutlet UIToolbar *hoursToolbar;
@property (nonatomic) NSMutableArray<NSString *> *hours;
@property (nonatomic) HSettings *settings;
@end

@implementation HSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hoursTextField.inputAccessoryView = self.hoursToolbar;
    self.hoursTextField.inputView = self.hoursPicker;
    self.hours = [@[@"None"] mutableCopy];
    
    for (int i = 0; i < 24; i++) {
        [self.hours addObject:[NSString stringWithFormat:@"%d:00", i]];
    }
    
    [self loadSettings];
    
    [self.autoTurnOffSwitch setOn:self.settings.screenTurnOff];
    [self.darnkessDetectionSwitch setOn:self.settings.darknessDetection];
    [self.hoursPicker selectRow:self.settings.hoursIndexFrom inComponent:0 animated:NO];
    [self.hoursPicker selectRow:self.settings.hoursIndexTo inComponent:1 animated:NO];
    [self updateHours];
}

- (void)loadSettings {
    NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [documents stringByAppendingPathComponent:@"settings.json"];
    
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        self.settings = [[HSettings alloc] initWithData:data error:nil];
    } else {
        self.settings = [HSettings new];
    }
}

- (void)saveSettings {
    NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [documents stringByAppendingPathComponent:@"settings.json"];
    NSData *data = [self.settings toJSONData];
    
    [data writeToFile:path atomically:NO];
}

- (void)updateHours {
    NSInteger fromIndex = self.settings.hoursIndexFrom;
    NSInteger toIndex = self.settings.hoursIndexTo;
    
    if (fromIndex == 0 || toIndex == 0) {
        self.hoursTextField.text = @"None";
        return;
    }
    
    self.hoursTextField.textColor = fromIndex >= toIndex ? UIColor.redColor : UIColor.blueColor;
    self.hoursTextField.text = [NSString stringWithFormat:@"%@ - %@", self.hours[fromIndex], self.hours[toIndex]];
}

#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.hoursTextField becomeFirstResponder];
}

#pragma mark <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark <UIPickerViewDataSource>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.hours.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.hours[row];
}

#pragma mark <UIPickerViewDelegate>

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.settings.hoursIndexFrom = [pickerView selectedRowInComponent:0];
    self.settings.hoursIndexTo = [pickerView selectedRowInComponent:1];
    
    [self updateHours];
    [self saveSettings];
}

#pragma mark Actions

- (IBAction)doneBtnAction:(id)sender {
    [self.hoursTextField resignFirstResponder];
}

- (IBAction)clearBtnAction:(id)sender {
    self.hoursTextField.text = @"None";
    [self.hoursTextField resignFirstResponder];
    
    self.settings.hoursIndexFrom = 0;
    self.settings.hoursIndexTo = 0;
    [self saveSettings];
}

- (IBAction)autoTurnOffSwitchAction:(id)sender {
    self.settings.screenTurnOff = self.autoTurnOffSwitch.isOn;
    [self saveSettings];
}

- (IBAction)darknessDetectionSwitchAction:(id)sender {
    self.settings.darknessDetection = self.darnkessDetectionSwitch.isOn;
    [self saveSettings];
}

@end
