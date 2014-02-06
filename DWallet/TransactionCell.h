//
//  TransactionCell.h
//  DWallet
//
//  Created by Bradley Slayter on 2/5/14.
//  Copyright (c) 2014 Brad Slayter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionCell : UITableViewCell

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *unconfirmedLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end
