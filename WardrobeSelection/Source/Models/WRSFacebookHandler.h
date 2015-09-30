//
//  WRSFacebookHandler.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSUtility.h"

FOUNDATION_EXPORT NSString *const FacebookAccountID;

@import Accounts;

@interface WRSFacebookHandler : NSObject {
    
    ACAccountStore *accountStore;
    ACAccountType *accountType;
}

-(void)loginWithCompletion:(CompletionBlock)block;

@end
