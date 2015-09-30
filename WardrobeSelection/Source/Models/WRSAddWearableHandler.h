//
//  WRSAddWearableHandler.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 27/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@class WRSAddWearableHandler;

@protocol WRSAddWearableHandlerDelegate <NSObject>

-(UIViewController*)presentingContollerForHandler:(WRSAddWearableHandler*)handler;
-(NSArray*)allWearableTypesThatCanBeAddedForHandler:(WRSAddWearableHandler*)handler;

@end

@interface WRSAddWearableHandler : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    
    NSArray *allWearableTypesCanBeAdded;
}

@property(nonatomic, weak) id <WRSAddWearableHandlerDelegate> delegate;
- (instancetype)initWithDelegate:(id <WRSAddWearableHandlerDelegate>)delegate;

-(void)showActionSheetToAddCollection;

@end
