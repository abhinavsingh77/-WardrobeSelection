//
//  WRSRootViewController.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSRootViewController.h"
#import "WRSUtility.h"
#import "WRSLoginViewController.h"
#import "WRSBookmarksViewController.h"
#import "WRSWardrobeViewController.h"
#import "WRSSettingsViewController.h"
#import "WRSFacebookHandler.h"

@import Accounts;

@interface WRSRootViewController () {
    
    id notificationObject;
    UINavigationController *loginNavController;
    UITabBarController *homeTabbarController;
}

@end

@implementation WRSRootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _dbManager = [[WRSDatabaseManager alloc] init];
    
    if (!self.dbManager.loggedInUser) {
        [self showLoginViewControllerAnimated:NO];
    }else {
        [self showTabbarViewController];
    }
}

-(void)logoutCurrentUser {
    
    [self.database deleteUserAndRelatedData];
    [self showLoginViewControllerAnimated:YES];
}

-(void)showLoginViewControllerAnimated:(BOOL)animated {
    
    if (!loginNavController) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:notificationObject];
        
        __weak WRSRootViewController *weakSelf = self;
        
        WRSLoginViewController *loginCont = [self controllerOfClass:[WRSLoginViewController class]];
        loginNavController = [[UINavigationController alloc] initWithRootViewController:loginCont];
        [loginNavController applyDefaultStyle];
        
        TransactionDirection direction = TransactionDirectionNone;
        if (animated) {
            direction = TransactionDirectionTop;
        }
        [self addController:loginNavController replacing:homeTabbarController transactionStyle:direction];
        
        [loginCont setCompletionBlock:^(id data, NSError *error) {
            
            if (data) {
                
                ACAccount *account = (ACAccount*)data;
                NSString *userID = [[[account valueForKey:@"properties"] valueForKey:@"uid"] stringValue];
                NSString *fullName = [[account valueForKey:@"properties"] valueForKey:@"ACPropertyFullName"];
                
                [self.dbManager insertNewUserWithID:userID andName:fullName];
                [weakSelf showTabbarViewController];
            }
        }];
    }
}

-(UITabBarController*)createNewTabbarController {
    
    UINavigationController *(^naviControllerWithViewControllerOfClass)(Class class) = ^UINavigationController * (Class class) {
    
        UIViewController *vCont = [self controllerOfClass:class];
        UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:vCont];
        [navCont applyDefaultStyle];
        
        return navCont;
    };
    
    UINavigationController *wardrobeNav = naviControllerWithViewControllerOfClass([WRSWardrobeViewController class]);
    UINavigationController *bookmarkNav = naviControllerWithViewControllerOfClass([WRSBookmarksViewController class]);
    UINavigationController *settingsNav = naviControllerWithViewControllerOfClass([WRSSettingsViewController class]);
    
    UITabBarController *controller = [[UITabBarController alloc] init];
    controller.tabBar.tintColor = [UIColor primaryColor];
    [controller setViewControllers:@[wardrobeNav, bookmarkNav, settingsNav]];
    
    NSInteger itemCount = controller.tabBar.items.count;
    for ( int i = 0; i < itemCount; i++ ) {
        
        UITabBarItem *item = controller.tabBar.items[i];
        switch (i) {
            case 0:
                [item setTitle:@"My Wardrobe"];
                [item setImage:[UIImage imageNamed:@"WardrobeIcon"]];
                break;
            case 1:
                [item setTitle:@"Bookmarks"];
                [item setImage:[UIImage imageNamed:@"FavouriteSelected"]];
                break;
            case 2:
                [item setTitle:@"Settings"];
                [item setImage:[UIImage imageNamed:@"SettingsIcon"]];
                break;
            default:
                break;
        }
    }
    
    return controller;
}

-(void)showTabbarViewController{
    
    if (!homeTabbarController) {
        
        notificationObject = [[NSNotificationCenter defaultCenter] addObserverForName:ACAccountStoreDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            
            WRSFacebookHandler *handler = [[WRSFacebookHandler alloc] init];
            [handler loginWithCompletion:^(id data, NSError *error) {
                
                if (error) {
                    
                    [self showLoginViewControllerAnimated:YES];
                }
            }];
        }];
        
        homeTabbarController = [self createNewTabbarController];
        [self addController:homeTabbarController replacing:loginNavController transactionStyle:TransactionDirectionTop];
    }
}

@end
