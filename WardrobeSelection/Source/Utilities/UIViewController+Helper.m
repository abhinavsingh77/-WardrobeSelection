//
//  UIViewController+Helper.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "UIViewController+Helper.h"
#import "UIView+Frames.h"

@implementation UIViewController (Helper)

-(id)controllerOfClass:(Class)classIdentifier {
    
    return [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(classIdentifier)];
}

- (void)addController:(UIViewController*)toController
            replacing:(UIViewController*)fromController
     transactionStyle:(TransactionDirection)trascation {
    
    if (!fromController) {
        trascation = TransactionDirectionNone;
    }
    
    if (trascation == TransactionDirectionNone) {
        
        toController.view.frame = self.view.bounds;
        [self.view addSubview:toController.view];
        [self addChildViewController:toController];
        
        [toController didMoveToParentViewController:self];
        [toController setNeedsStatusBarAppearanceUpdate];
        
        if (fromController) {
            
            [fromController.view removeFromSuperview];
            [fromController removeFromParentViewController];
        }
    }
    else if (trascation == TransactionDirectionTop) {
        
        toController.view.frame = self.view.bounds;
        toController.view.originY -= self.view.height;
        
        [self.view addSubview:toController.view];
        [self addChildViewController:toController];
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            fromController.view.originY = self.view.height;
            toController.view.originY = 0;
            
            [toController setNeedsStatusBarAppearanceUpdate];
        } completion:^(BOOL finished) {
            
            [toController didMoveToParentViewController:self];
            
            [fromController.view removeFromSuperview];
            [fromController removeFromParentViewController];
        }];
    }
}

@end