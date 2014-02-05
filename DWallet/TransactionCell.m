//
//  TransactionCell.m
//  DWallet
//
//  Created by Bradley Slayter on 2/5/14.
//  Copyright (c) 2014 Brad Slayter. All rights reserved.
//

#import "TransactionCell.h"

@implementation TransactionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
		self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 5.0f, 160, 39)];
		self.addressLabel.numberOfLines = 0;
		[self.contentView addSubview:self.addressLabel];
		
		self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 5, 145, 39)];
		self.amountLabel.numberOfLines = 0;
		[self.contentView addSubview:self.amountLabel];
		self.amountLabel.textAlignment = NSTextAlignmentRight;
		self.amountLabel.font = [UIFont boldSystemFontOfSize:17.0f];
		
		self.unconfirmedLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 30, 145, 25)];
		[self.contentView addSubview:self.unconfirmedLabel];
		self.unconfirmedLabel.textColor = [UIColor orangeColor];
		self.unconfirmedLabel.textAlignment = NSTextAlignmentRight;
		self.unconfirmedLabel.font = [UIFont boldSystemFontOfSize:15.0f];
		
    }
    return self;
}

-(void) layoutSubviews {
	[super layoutSubviews];
	
	if ([self.unconfirmedLabel.text isEqualToString:@"unconfirmed"]) {
		CGPoint addCenter = self.addressLabel.center;
		addCenter.y = self.center.y;
		self.addressLabel.center = addCenter;
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
