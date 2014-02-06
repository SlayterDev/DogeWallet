//
//  ViewController.h
//  DWallet
//
//  Created by Brad Slayter on 2/4/14.
//  Copyright (c) 2014 Brad Slayter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NMSSH/NMSSH.h>
#import "BSFileHelper.h"
#import "SendDogeController.h"
#import "ServerAddView.h"
#import "InfoViewController.h"
#import "TransactionCell.h"
#import "UIImage+MDQRCode.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, ServerAddDelegate> {
	NSMutableArray *transactions;
	
	UIAlertView *addressAlert;
	
	UIImageView *QRView;
	
	NSDictionary *server;
	
	UIButton *refreshButton;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *myAddressLabel;

@property (nonatomic, strong) NMSSHSession *ssh;

@end
