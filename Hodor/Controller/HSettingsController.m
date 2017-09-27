//
//  HSettingsController.m
//  Hodor
//
//  Created by Antrov on 27.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import "HSettingsController.h"

@interface HSettingsController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *autoTurnOffSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *darnkessDetectionSwitch;
@property (weak, nonatomic) IBOutlet UITextField *hoursTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *hoursPicker;
@property (strong, nonatomic) IBOutlet UIToolbar *hoursToolbar;
@property (nonatomic) NSMutableArray<NSString *> *hours;
@end

@implementation HSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hoursTextField.inputAccessoryView = self.hoursToolbar;
    self.hoursTextField.inputView = self.hoursPicker;
    self.hours = [NSMutableArray new];
    
    for (int i = 0; i < 24; i++) {
        [self.hours addObject:[NSString stringWithFormat:@"%d:00", i]];
    }
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
    NSInteger fromIndex = [pickerView selectedRowInComponent:0];
    NSInteger toIndex = [pickerView selectedRowInComponent:1];
    
    self.hoursTextField.textColor = fromIndex >= toIndex ? UIColor.redColor : UIColor.blueColor;
    self.hoursTextField.text = [NSString stringWithFormat:@"%@ - %@", self.hours[fromIndex], self.hours[toIndex]];
}

#pragma mark Actions

- (IBAction)doneBtnAction:(id)sender {
    [self.hoursTextField resignFirstResponder];
}

- (IBAction)clearBtnAction:(id)sender {
    self.hoursTextField.text = @"None";
    [self.hoursTextField resignFirstResponder];
}

@end
