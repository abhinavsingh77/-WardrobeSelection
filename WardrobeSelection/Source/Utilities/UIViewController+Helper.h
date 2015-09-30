//
//  UIViewController+Helper.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TransactionDirection) {
    
    TransactionDirectionNone = -1,
    TransactionDirectionTop = 0,
    TransactionDirectionBottom,
    TransactionDirectionLeft,
    TransactionDirectionRight
};


@interface UIViewController (Helper)

-(id)controllerOfClass:(Class)classIdentifier;

- (void)addController:(UIViewController*)toController
            replacing:(UIViewController*)fromController
     transactionStyle:(TransactionDirection)trascation;

@end
