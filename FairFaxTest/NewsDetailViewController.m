//
//  NewsDetailViewController.m
//  FairFaxTest
//
//  Created by Manuel Betancurt on 22/03/13.
//  Copyright (c) 2013 Manuel Betancurt. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "ProgressHUD.h"


@interface NewsDetailViewController ()
@property (nonatomic, retain)NSDictionary *newsDicto;
@property (nonatomic, retain)UIWebView *webView;

@end

@implementation NewsDetailViewController

@synthesize webView = _webView;

- (id)initWithNewsDicto:(NSDictionary*)newsDicto
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.newsDicto = newsDicto;
    }
    return self;
}

- (void)dealloc
{
    //self.webView = nil;
    [_webView release];

    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self handleDeviceOrientation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [self.newsDicto objectForKey:@"headLine"];
    

    
   self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x  ,
                                                                   self.view.bounds.origin.y ,
                                                                   self.view.bounds.size.width,
                                                                    self.view.bounds.size.height )];
 
     self.webView.delegate = self;
    
 
    
    [self loadPage];
    
    [self.view addSubview: self.webView];
    
}

- (void)loadPage
{

    if ([self connected]) {
        [ProgressHUD showWithStatus:@"Loading your latest News"];

        NSString *urlAddress = [self.newsDicto objectForKey:@"webHref"];
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        [ self.webView loadRequest:requestObj];
    } else {
        [self showAlert:@"No internet Connection" message:@"Please try again later"];

    }
    

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [ProgressHUD dismiss];
}



- (void)handleDeviceOrientation
{
    self.webView.frame = CGRectMake(self.view.bounds.origin.x,
                                    self.view.bounds.origin.y ,
                                    self.view.bounds.size.width,
                                    self.view.bounds.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
