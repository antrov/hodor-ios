//
//  HUserFormController.m
//  Hodor
//
//  Created by Antrov on 24.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import "HApiClient.h"
#import "HUser.h"
#import "HUserFormController.h"
#import "MBProgressHUD.h"

@interface HUserFormController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@end

@implementation HUserFormController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.user) {
        self.user = [HUser new];
        [self.photoBtn setTitle:@"set photo" forState:UIControlStateNormal];
        [self.deleteBtn setHidden:YES];
    } else {
        self.avatarImgView.image = self.user.avatar;
        self.nameTextField.text = self.user.name;
    }
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.avatarImgView.image = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UINavigationControllerDelegate>

#pragma mark - Actions

- (IBAction)cancelBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)doneBtnAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    BOOL userCreated = self.user.id == nil;
    BOOL userModified = ![self.user.name isEqualToString:self.nameTextField.text] || self.user.avatar != self.avatarImgView.image;
    PMKPromise *promise = [PMKPromise promiseWithValue:nil];

    if (userModified) {
        self.user.name = self.nameTextField.text;
        self.user.avatar = [HUserFormController imageWithImage:self.avatarImgView.image scaledToSize:CGSizeMake(75, 75)];
        //self.user.photo = self.avatarImgView.image;
    }
    
    if (userCreated)
        promise = [HApiClient.instance createUser:self.user];
    else if (userModified) {
        promise = [HApiClient.instance updateUser:self.user];
    }
    
    promise.then(^(){
        [self dismissViewControllerAnimated:YES completion:nil];
    }).then(^(){
        [NSNotificationCenter.defaultCenter postNotificationName:HUserDataChangedNotification object:nil];
    }).catch(^(NSError *error){
        
    }).finally(^() {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (IBAction)deleteBtnAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HApiClient.instance deleteUser:self.user].then(^(){
        [self dismissViewControllerAnimated:YES completion:nil];
    }).then(^(){
        [NSNotificationCenter.defaultCenter postNotificationName:HUserDataChangedNotification object:nil];
    }).catch(^(NSError *error){
        
    }).finally(^() {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (IBAction)photoBtnAction:(id)sender {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    [self presentViewController:picker animated:YES completion:nil];
}

@end
