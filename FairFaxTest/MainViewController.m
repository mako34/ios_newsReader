//
//  MainViewController.m
//  FairFaxTest
//
//  Created by Manuel Betancurt on 22/03/13.
//  Copyright (c) 2013 Manuel Betancurt. All rights reserved.
//

//todo, object with response of request

#import "MainViewController.h"
#import "NewsDetailViewController.h"
#import "NewsCell.h"
#import "ProgressHUD.h"
#import <QuartzCore/QuartzCore.h>


@interface MainViewController ()

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, retain)NSMutableArray *newsArray;

@end

@implementation MainViewController

@synthesize responseData = _responseData;
@synthesize table = _table;

@synthesize newsArray = _newsArray;

- (void)dealloc
{
    [_table release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self handleDeviceOrientation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.newsArray = [NSMutableArray array];
    
     
    
    
    //make the connection to get the data
    self.responseData = [NSMutableData data];
    
    [self fetchNews];
    
 
    //build the table
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + 10,
                                                             self.view.frame.origin.y ,
                                                             self.view.frame.size.width - 20 ,
                                                              self.view.frame.size.height - 20) style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.layer.cornerRadius = 10;
    
    [self.view addSubview:self.table];
}
 

- (void)fetchNews
{
     
    if ([self connected]) {
        [ProgressHUD showWithStatus:@"Loading your latest News"];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:
                                 [NSURL URLWithString:@"http://mobilatr.mob.f2.com.au/services/views/9.json"]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    } else {
        [self showAlert:@"No internet Connection" message:@"Please try again later"];
    }
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"%@", [NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    
    
    
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
 
     
    NSDictionary *itemsDicto = [res objectForKey:@"items"];
    
    for (NSDictionary *objectDicto in itemsDicto) {
        //NSLog(@"tu dicto :: %@", objectDicto);
        [self.newsArray addObject:objectDicto];
    }
    
    NSLog(@"news Array == %@", self.newsArray);
    
    self.title = [res objectForKey:@"name"];
    
    [ProgressHUD dismiss];

    
    [self.table reloadData];
}

#pragma mark table dataSource n delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsArray count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
  
    NSDictionary *itemNews = [self.newsArray objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = [itemNews objectForKey:@"headLine"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    [cell populateCell:itemNews];
    
    
     
    return cell;
}

  
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
     
    //return cell.frame.size.height;

    //[self calculateCellHeight:indexPath.row];
    
    //NSLog(@"buscada height ::%f",tableView.rowHeight);

    [self calculateCellHeight:indexPath.row];
    
    return [self calculateCellHeight:indexPath.row]+100; // +70


    //return tableView.rowHeight;
}
 


- (float)calculateCellHeight:(int)index
{
    //float height = 0;
    
    NSString *titleString = [[self.newsArray objectAtIndex:index]objectForKey:@"headLine"];
    NSString *slugString = [[self.newsArray objectAtIndex:index]objectForKey:@"slugLine"];

    
    
    //CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:16.0f] forWidth:270 lineBreakMode:UILineBreakModeWordWrap];
    
    //NSLog(@"en index :: %d", index);

    
    CGSize titleSize = [titleString sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(320, 9999) lineBreakMode:UILineBreakModeWordWrap];
    
    float height = titleSize.height;
    
    //NSLog(@"height de example :: %f", height);
    
    
       CGSize slugSize = [slugString sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(320, 9999) lineBreakMode:UILineBreakModeWordWrap];
    
    height += slugSize.height;
    
    //NSLog(@"height de example slug :: %f", height);

    return height + 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc]initWithNewsDicto:[self.newsArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:newsDetailVC animated:YES];
 
}

 

 

- (void)handleDeviceOrientation
{
    self.table.frame = CGRectMake(self.view.frame.origin.x + 10,
                                  self.view.frame.origin.y + 10,
                                  self.view.frame.size.width - 20 ,
                                  self.view.frame.size.height - 20);
    
}

@end
