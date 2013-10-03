//
//  AppDelegate.h
//  FairFaxTest
//
//  Created by Manuel Betancurt on 22/03/13.
//  Copyright (c) 2013 Manuel Betancurt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController *_navController;
}
@property (nonatomic, retain) UINavigationController *navController;
@property (strong, nonatomic) UIWindow *window;

@end
