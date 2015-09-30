//
//  WRSAddWearableHandler.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 27/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSAddWearableHandler.h"
#import "WRSDatabaseManager.h"
#import "WRSUtility.h"

@implementation WRSAddWearableHandler

- (instancetype)initWithDelegate:(id <WRSAddWearableHandlerDelegate>)delegate {
    
    self = [super init];
    if (self) {
        
        _delegate = delegate;
    }
    
    return self;
}

-(void)showActionSheetToAddCollection {
    
    if (!self.delegate) {
        return;
    }
    
    void (^showImagePickerForType)(UIImagePickerControllerSourceType sourceType) = ^void (UIImagePickerControllerSourceType sourceType) {
        
        if([UIImagePickerController isSourceTypeAvailable:sourceType]) {
            
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.delegate = self;
            controller.sourceType = sourceType;
            [controller applyDefaultStyle];
            
            [[self.delegate presentingContollerForHandler:self] presentViewController:controller animated:YES completion:nil];
        }
    };
    
    UIAlertAction *actionLibrary = [UIAlertAction actionWithTitle:@"Take a Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        showImagePickerForType(UIImagePickerControllerSourceTypeCamera);
    }];
    
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"Choose from photo gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        showImagePickerForType(UIImagePickerControllerSourceTypePhotoLibrary);
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wardrobe Collection"
                                                                   message:@"Add your wardrobe items to your collection"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:actionCamera];
    [alert addAction:actionLibrary];
    [alert addAction:actionCancel];
    
    [[self.delegate presentingContollerForHandler:self] presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

-(void)navigationController:(UINavigationController *)navigationController
     willShowViewController:(UIViewController *)viewController
                   animated:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    void (^addWearableOftype)(NSInteger type) = ^void (NSInteger type) {
        
        UIImage *origImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.database addNewWearableOfType:type andImage:origImage completion:^(id data, NSError *error) {
            
            if (error) {
                
                [NSObject showAlertForError:error];
            }
        }];
    };
    
    NSMutableArray *actions = [NSMutableArray new];
    
    if (!allWearableTypesCanBeAdded) {
        
        allWearableTypesCanBeAdded = [self.delegate allWearableTypesThatCanBeAddedForHandler:self];
    }
    
    for ( NSNumber *typeNum in allWearableTypesCanBeAdded ) {
        
        NSString *name = [WRSWearable displayNameForWearableType:typeNum.integerValue];
        if (name) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                addWearableOftype(typeNum.integerValue);
            }];
            [actions addObject:action];
        }
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wardrobe Collection"
                                                                   message:@"Add your wardrobe items to your collection"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    for ( UIAlertAction *action in actions ) {
        [alert addAction:action];
    }
    
    [picker presentViewController:alert animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
