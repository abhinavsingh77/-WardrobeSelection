//
//  NSObject+WRSError.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "NSObject+WRSError.h"

@import UIKit;
@import Accounts;

NSString * const WRSErrorDomain = @"WRSErrorDomain";

@implementation NSObject (WRSError)

+ (NSError*)errorWithMessage:(NSString*)message {
    return [self errorWithMessage:message andTitle:@"Sorry!"];
}

+ (NSError*)errorWithMessage:(NSString*)message andTitle:(NSString*)title {
    
    if (message.length) {
        return [NSError errorWithDomain:WRSErrorDomain code:0 userInfo:@{@"message":message, @"title":title}];
    }
    
    return [NSError errorWithDomain:WRSErrorDomain code:0 userInfo:nil];
}


+(void)message:(NSString *__autoreleasing *)retMessage andTitle:(NSString *__autoreleasing *)retTitle forError:(NSError *)error {
    
    NSString *title = @"Sorry!";
    NSString *message = nil;
    
    if ([error.domain isEqualToString:WRSErrorDomain]) {
        
        title = error.userInfo[@"title"];
        message = error.userInfo[@"message"];
    }
    else if ([error.domain isEqualToString:ACErrorDomain]) {
        
        if (error.code == ACErrorPermissionDenied) {
            title = @"Facebook Error!";
            message = @"You haven't Grated Wardobe Selection to use your Facebook accout.\nPlease open Setting->Facebook to allow access";
        }
        else if (error.code == ACErrorAccountNotFound) {
            title = @"Facebook Error!";
            message = @"You haven't added any facebook account in your device.\nPlease open Setting->Facebook to Login";
        }
    }
    
    if (!message) {
        message = [error localizedDescription];
    }
    
    *retMessage = message;
    *retTitle = title;
}

#pragma mark - Error's

+(void)showAlertForError:(NSError*)error {
    
    NSString *title = nil;
    NSString *message = nil;
    
    [self message:&message andTitle:&title forError:error];
    
    if (message.length) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
                                  delegate:nil cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
