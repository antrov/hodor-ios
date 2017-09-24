//
//  HUsersController.m
//  Hodor
//
//  Created by Antrov on 23.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import "HUsersController.h"
#import "HUserFormController.h"
#import "HUserCell.h"
#import "HApiClient.h"
#import "MBProgressHUD.h"

@interface HUsersController ()
@property (nonatomic) NSArray<HUser *> *users;
@end

@implementation HUsersController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchUsers];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userDataChangedNotification:) name:HUserDataChangedNotification object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selected = self.collectionView.indexPathsForSelectedItems.firstObject;
    
    if ([segue.identifier isEqual:@"UserFormSegue"] && selected != nil) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        HUserFormController *userForm = (HUserFormController *)navigationController.topViewController;
        
        [userForm setUser:self.users[selected.item]];
    }
}

- (void)userDataChangedNotification:(NSNotification *)notification {
    [self fetchUsers];
}

- (void)fetchUsers {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    HApiClient.instance.getUsers.then(^(id users) {
        self.users = users;
        [self.collectionView reloadData];
    }).catch(^(NSError *error) {
        
    }).finally(^() {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.users.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HUserCell *userCell = (HUserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"UserCell" forIndexPath:indexPath];
    HUser *user = self.users[indexPath.row];
    
    userCell.titleLabel.text = user.name;
    userCell.avatarImgView.image = user.avatar;
    
    return userCell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"UserFormSegue" sender:self];
}

@end
