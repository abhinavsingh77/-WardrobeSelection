//
//  WRSFacebookHandler.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSFacebookHandler.h"

NSString *const FacebookAccountID = @"874476652634282";

@implementation WRSFacebookHandler

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        accountStore = [[ACAccountStore alloc] init];
        accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    }
    
    return self;
}

-(void)loginWithCompletion:(CompletionBlock)block {
    
    NSDictionary *options = @{ACFacebookAppIdKey:FacebookAccountID,
                              ACFacebookPermissionsKey: @[@"email"]};
    
    [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
        
        if (granted) {
            
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            ACAccount *account = (ACAccount *)[accounts lastObject];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(account, nil);
                }
            });
        }
        else {
            
            if (!error) {
                error = [NSError errorWithDomain:ACErrorDomain code:ACErrorPermissionDenied userInfo:nil];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    if (block) {
                        block(nil, error);
                    }
                }
            });
        }
    }];
}

@end
