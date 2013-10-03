//
//  NewsDetailViewController.h
//  FairFaxTest
//
//  Created by Manuel Betancurt on 22/03/13.
//  Copyright (c) 2013 Manuel Betancurt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@interface NewsDetailViewController : MasterViewController <UIWebViewDelegate>


- (id)initWithNewsDicto:(NSDictionary*)newsDicto;

@end
