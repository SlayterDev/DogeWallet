//
//  ServerAddView.h
//  DWallet
//
//  Created by Bradley Slayter on 2/5/14.
//  Copyright (c) 2014 Brad Slayter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSFileHelper.h"

@class ServerAddView;

@protocol ServerAddDelegate

-(void) serverViewDidClose:(ServerAddView *)serverAddController;

@end

@interface ServerAddView : UITableViewController {
	UITextField *hostField;
	UITextField *userField;
	UITextField *passField;
	UITextField *pathField;
	
	UIToolbar *accessoryView;
	NSMutableArray *fields;
}

@property (weak) id<ServerAddDelegate> delegate;

@end
