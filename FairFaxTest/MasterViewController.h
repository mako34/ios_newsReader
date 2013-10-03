//
//  MasterViewController.h
//  FairFaxTest
//
//  Created by Manuel Betancurt on 22/03/13.
//  Copyright (c) 2013 Manuel Betancurt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

@interface MasterViewController : UIViewController {
    
   // NetworkStatus internetConnectionStatus;

    //Reachability *reachability;
}


//@property NetworkStatus internetConnectionStatus;

- (BOOL)connected ;
- (void)showAlert:(NSString*)title message:(NSString*)message;
- (void)handleDeviceOrientation;

@end
