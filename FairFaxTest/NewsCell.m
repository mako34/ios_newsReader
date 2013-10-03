//
//  NewsCell.m
//  FairFaxTest
//
//  Created by Manuel Betancurt on 24/03/13.
//  Copyright (c) 2013 Manuel Betancurt. All rights reserved.
//

#import "NewsCell.h"
#import <QuartzCore/QuartzCore.h>

@interface NewsCell()

@property (nonatomic, assign)bool hasImage;

@end

@implementation NewsCell

@synthesize headLine = _headLine;
@synthesize slugLine = _slugLine;
@synthesize dateLine = _dateLine;
@synthesize newsImage = _newsImage;

- (void)dealloc
{
    [_headLine release];
    [_slugLine release];
    [_dateLine release];
    [_newsImage release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.hasImage = NO;
        
        self.headLine = [[[UILabel alloc]init]autorelease];

        
        self.headLine.backgroundColor = [UIColor clearColor];
        self.headLine.font = [UIFont systemFontOfSize:16.0f];
        self.headLine.textAlignment = UITextAlignmentLeft;
        self.headLine.textColor = [UIColor blueColor];
        self.headLine.lineBreakMode = UILineBreakModeWordWrap;
        self.headLine.numberOfLines = 0;
        
 
        
        [self.contentView addSubview:self.headLine];
        
 

        self.slugLine = [[[UILabel alloc]init]autorelease];

        self.slugLine.backgroundColor = [UIColor clearColor];
        //self.slugLine.adjustsFontSizeToFitWidth = NO;
        self.slugLine.font = [UIFont systemFontOfSize:16.0f];

        self.slugLine.textAlignment = UITextAlignmentLeft;
        self.slugLine.textColor = [UIColor blackColor];
        self.slugLine.lineBreakMode = UILineBreakModeWordWrap;
        self.slugLine.numberOfLines = 0;
 
        
        [self.contentView addSubview:self.slugLine];
        
 
        //
        self.dateLine = [[[UILabel alloc]init]autorelease];
        
        self.dateLine.backgroundColor = [UIColor clearColor];
        self.slugLine.font = [UIFont systemFontOfSize:14.0f];
        
        self.dateLine.textAlignment = UITextAlignmentLeft;
        self.dateLine.textColor = [UIColor darkGrayColor];
        //self.dateLine.lineBreakMode = UILineBreakModeWordWrap;
        //self.dateLine.numberOfLines = 0;
        
        
        [self.contentView addSubview:self.dateLine];
        //
        
        self.newsImage = [[[UIImageView alloc]init]autorelease];

        self.newsImage.backgroundColor = [UIColor clearColor];
        
        self.newsImage.layer.cornerRadius = 10;
        self.newsImage.clipsToBounds = YES;
   
        
         [self.contentView addSubview:self.newsImage];
         
 
        
    } 
    return self;
}

- (float)calculateCellHeight:(NSString*)string
{
 
  
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(self.contentView.frame.size.width, 9999) lineBreakMode:UILineBreakModeWordWrap];
    
    float height = size.height;
    
 
       
    return height + 40;
}

- (void)populateCell:(NSDictionary*)dataDicto
{
    self.hasImage = NO;
    
    [self.newsImage setImage:nil];
    
    self.headLine.text = [dataDicto objectForKey:@"headLine"];
    self.slugLine.text = [dataDicto objectForKey:@"slugLine"];

    //image
    NSString *imageLink = [dataDicto objectForKey:@"thumbnailImageHref"];
    
    
    if (![imageLink isEqual:[NSNull null]]) {
        NSLog(@"image link:: %@", imageLink);
 
        
        //GCD QEUE SENT
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            [self getImage:imageLink];
            [pool release];
        });
        
        //
        
        
       
        
        self.hasImage = YES;
    }
    
    self.dateLine.text = [self dateToString:[dataDicto objectForKey:@"dateLine"]];
 
    ;
}


- (void)getImage:(NSString*)imageLink
{
    NSURL *url = [NSURL URLWithString:imageLink];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    
    [self performSelectorOnMainThread:@selector(placeImage:) withObject:image waitUntilDone:YES];
    
    //[self.newsImage setImage:image];
}


- (void)placeImage:(UIImage*)image
{
    [self.newsImage setImage:image];

}

- (NSString*)dateToString:(NSString*)str
{
    // convert to date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // ignore +11 and use timezone name instead of seconds from gmt
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'+11:00'"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Melbourne"]];
    NSDate *dte = [dateFormat dateFromString:str];
    NSLog(@"Date: %@", dte);
    
    // back to string
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
//    [dateFormat2 setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
    
    [dateFormat2 setDateFormat:@"EEE dd-MM-YYYY HH:mm"];

    
    [dateFormat2 setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Melbourne"]];
    NSString *dateString = [dateFormat2 stringFromDate:dte];
    NSLog(@"DateString: %@", dateString);
    
    [dateFormat release];
    [dateFormat2 release];
    
    return dateString;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
 
    float headLineHeight = [self calculateCellHeight:self.headLine.text];

    float contentLineHeight = [self calculateCellHeight:self.slugLine.text];

    
    self.headLine.frame = CGRectMake(14, 0,
                                     self.contentView.frame.size.width - 40, headLineHeight);
 
    
    if (self.hasImage) {
        self.slugLine.frame = CGRectMake(14, headLineHeight - 15,
                                         self.contentView.frame.size.width - 100,
                                         [self calculateCellHeight:self.slugLine.text]);
        
        self.newsImage.frame = CGRectMake(self.contentView.frame.size.width - 80,  headLineHeight, 80, 80);
        
        self.dateLine.frame = CGRectMake(14, headLineHeight + contentLineHeight - 15,
                                         self.contentView.frame.size.width - 40,
                                         30);
        
    } else {
        
        self.slugLine.frame = CGRectMake(14, headLineHeight - 15,
                                         self.contentView.frame.size.width - 40,
                                         [self calculateCellHeight:self.slugLine.text]);
        
        self.dateLine.frame = CGRectMake(14, headLineHeight + contentLineHeight - 30,
                                         self.contentView.frame.size.width - 40,
                                         30);
    }
 
    

NSLog(@"heightus %f", self.contentView.frame.size.height);


}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
