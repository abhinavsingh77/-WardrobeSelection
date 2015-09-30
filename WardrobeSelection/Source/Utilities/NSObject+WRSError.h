//
//  NSObject+WRSError.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const WRSErrorDomain;

@interface NSObject (WRSError)

+(NSError*)errorWithMessage:(NSString*)message andTitle:(NSString*)title;
+(NSError*)errorWithMessage:(NSString*)message;

+(void)showAlertForError:(NSError*)error;


@end

