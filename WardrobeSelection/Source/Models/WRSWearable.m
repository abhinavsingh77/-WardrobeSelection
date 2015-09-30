//
//  WRSWearable.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSWearable.h"
#import "WRSLoggedInUser.h"

@implementation WRSWearable

@dynamic relativeImageURL;
@dynamic type;
@dynamic wearableID;
@dynamic user;
@dynamic thumbnailSize;
@dynamic thumbnailImageUrl;

+(NSArray*)allPantTypes {
    
    NSMutableArray *typesArray = [NSMutableArray new];
    for ( NSInteger i = WearableTypePantStart; i <= WearableTypePantEnd; i++ ) {
        [typesArray addObject:@(i)];
    }
    return typesArray;
}

+(NSArray*)allShirtTypes {
    
    NSMutableArray *typesArray = [NSMutableArray new];
    for ( NSInteger i = WearableTypeShirtStart; i <= WearableTypeShirtEnd; i++ ) {
        [typesArray addObject:@(i)];
    }
    return typesArray;
}

+(BOOL)isShirtType:(WearableType)type {
    
    BOOL isShirt = NO;
    if ( type >= WearableTypeShirtStart && type <= WearableTypeShirtEnd ) {
        isShirt = YES;
    }
    
    return isShirt;
}

+(BOOL)isPantType:(WearableType)type {
    
    BOOL isPant = NO;
    if (type >= WearableTypePantStart && type <= WearableTypePantEnd ) {
        isPant = YES;
    }
    
    return isPant;
}

+(NSString*)displayNameForWearableType:(WearableType)type {
    
    NSString *retString = nil;
    if (!retString) {
        switch (type) {
            case WearableTypeCasualPant:
                retString = @"Casual Pant";
                break;
            case WearableTypeFormalPant:
                retString = @"Formal Pant";
                break;
            case WearableTypeJeansPant:
                retString = @"Jeans";
                break;
            case WearableTypeCasualShirt:
                retString = @"Casual Shirt";
                break;
            case WearableTypeFormalShirt:
                retString = @"Formal Shirt";
                break;
            case WearableTypeTShirt:
                retString = @"T-Shirt";
                break;
            default:
                break;
        }
    }
    
    return retString;
}

@end
