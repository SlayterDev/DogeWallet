//
//  SendDogeController.h
//  DWallet
//
//  Created by Brad Slayter on 2/4/14.
//  Copyright (c) 2014 Brad Slayter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NMSSH/NMSSH.h>
#import "ZBarSDK.h"
#import "BSFileHelper.h"

@interface SendDogeController : UITableViewController <ZBarReaderDelegate, UIAlertViewDelegate> {
    UITextField *addressField;
    UITextField *amountField;
	
	UIAlertView *confirmView;
	UIAlertView *sentView;
    UIAlertView *walletPassView;
    
    NSDictionary *server;
}


@end
