//
//  NewsCell.h
//  FairFaxTest
//
//  Created by Manuel Betancurt on 24/03/13.
//  Copyright (c) 2013 Manuel Betancurt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell {
    UILabel *_headLine;
    UILabel *_slugLine;
    UILabel *_dateLine;
    UIImageView *_newsImage;
}

@property (nonatomic, retain)UILabel *headLine;
@property (nonatomic, retain)UILabel *slugLine;
@property (nonatomic, retain)UILabel *dateLine;
@property (nonatomic, retain)UIImageView *newsImage;
 

- (void)populateCell:(NSDictionary*)dataDicto;

@end
