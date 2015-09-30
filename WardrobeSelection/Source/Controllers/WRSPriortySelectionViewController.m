//
//  WRSPriortySelectionViewController.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 26/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSPriortySelectionViewController.h"

@interface WRSPriortySelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *priorties;

@end

@implementation WRSPriortySelectionViewController

- (void)dealloc {
    
    self.completionBlock = nil;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Priorties";
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    theTableView.tableFooterView = footer;
    [theTableView setEditing:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(doneClicked:)];
    
    self.priorties = [[self.database priortiesForType:self.type] mutableCopy];
}

-(void)doneClicked:(UIBarButtonItem*)item {
    
    [self.database savePriorties:self.priorties forType:self.type];
    if (self.completionBlock) {
        self.completionBlock(YES);
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"DefaultTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *index = self.priorties[indexPath.row];
    
    NSString *displayName = [WRSWearable displayNameForWearableType:index.integerValue];
    cell.textLabel.text = displayName;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = self.priorties.count;
    return count;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSNumber *index = self.priorties[sourceIndexPath.row];
    [self.priorties removeObjectAtIndex:sourceIndexPath.row];
    [self.priorties insertObject:index atIndex:destinationIndexPath.row];
}

@end
