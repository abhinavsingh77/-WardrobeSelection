//
//  WRSSettingsViewController.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 26/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSSettingsViewController.h"
#import "WRSDatabaseManager.h"
#import "WRSUtility.h"
#import "WRSPriortySelectionViewController.h"
#import "WRSRootViewController.h"

@interface WRSSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation WRSSettingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Settings";
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    theTableView.tableFooterView = footer;
    
    userNameLabel.text = [NSString stringWithFormat:@"Logged in as : %@", self.database.loggedInUser.name];
    userNameLabel.textColor = [UIColor primaryColor];
    
    logOutButton.tintColor = [UIColor primaryColor];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"DefaultTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *index = nil;
    if (indexPath.section == 0) {
        
        index = self.database.allShirtTypes[indexPath.row];
    }else if (indexPath.section == 1) {
        index = self.database.allPantTypes[indexPath.row];
    }
    
    NSString *displayName = [WRSWearable displayNameForWearableType:index.integerValue];
    cell.textLabel.text = displayName;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    if (section == 0) {
        count = self.database.allShirtTypes.count;
    }
    else if (section == 1) {
        count = self.database.allPantTypes.count;
    }
    return count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *index = nil;
    if (indexPath.section == 0) {
        index = self.database.allShirtTypes[indexPath.row];
    }else if (indexPath.section == 1) {
        index = self.database.allPantTypes[indexPath.row];
    }
    
    WRSPriortySelectionViewController *priortyCont = [self controllerOfClass:[WRSPriortySelectionViewController class]];
    priortyCont.type = index.integerValue;
    [self.navigationController pushViewController:priortyCont animated:YES];
    
    __weak WRSSettingsViewController *settings = self;
    
    [priortyCont setCompletionBlock:^(BOOL success){
        
        [settings.navigationController popViewControllerAnimated:YES];
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    header.backgroundColor = [UIColor primaryColor];
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.numberOfLines = 0;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont wrsRegularFontOfSize:13];
    titleLabel.textColor = [UIColor whiteColor];
    [header addSubview:titleLabel];
    
    if (section == 0) {
        titleLabel.text = @"Choose your priorty of pants with these shirts";
    }
    else if (section == 1) {
        titleLabel.text = @"Choose your priorty of shirts with these pants";
    }
    NSDictionary *dict = NSDictionaryOfVariableBindings(titleLabel);
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleLabel]-10-|" options:0 metrics:nil views:dict]];
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-5-|" options:0 metrics:nil views:dict]];
    
    return header;
}

#pragma mark Action

-(IBAction)logoutClicked:(id)sender {
    
    NSMutableArray *actions = [NSMutableArray new];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self.rootViewController logoutCurrentUser];
    }];
    
    [actions addObject:actionCancel];
    [actions addObject:actionYes];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please Confirm!"
                                                                   message:@"Are you sure you want to logout?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    for (UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
