//
//  ViewController.m
//  DWallet
//
//  Created by Brad Slayter on 2/4/14.
//  Copyright (c) 2014 Brad Slayter. All rights reserved.
//

#import "ViewController.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end

@implementation NSMutableArray (Reverse)

- (void)reverse {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
		
        i++;
        j--;
    }
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
	NSString *path = [self getServerPath];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NO]) {
		[self showServerView];
	} else {
		[self loadServerDetails];
	}
	
    self.navigationItem.title = @"My Wallet";
	self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *sendBtn = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(showSendView:)];
    self.navigationItem.rightBarButtonItem = sendBtn;
    
    [self createTableView];
    [self createBalanceLabel];
	
	[self getBalanceAndTransactionsFromServer];
}

-(NSString *) getServerPath {
	return [NSString stringWithFormat:@"%@/server.plist", [[BSFileHelper sharedHelper] getDocumentsDirectory]];
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self getBalanceAndTransactionsFromServer];
}

-(void) showServerView {
	ServerAddView *controller = [[ServerAddView alloc] initWithStyle:UITableViewStyleGrouped];
	controller.delegate = self;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	
	[self presentViewController:nav animated:YES completion:nil];
}

-(void) serverViewDidClose:(ServerAddView *)serverAddController {
	[self dismissViewControllerAnimated:YES completion:nil];
	
	[self loadServerDetails];
}

-(void) loadServerDetails {
	NSString *path = [self getServerPath];
	server = [[NSDictionary alloc] initWithContentsOfFile:path];
}

-(void) createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 154.0f, self.view.bounds.size.width, self.view.bounds.size.height - 218.0f) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
	
	UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, 0.3f)];
	bar.backgroundColor = [UIColor blackColor];
	[self.view addSubview:bar];
}

-(void) createBalanceLabel {
    self.balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 50.0f)];
    self.balanceLabel.center = self.view.center;
    CGRect labelFrame = self.balanceLabel.frame;
    labelFrame.origin.y -= 225.0f;
	
	if (!IS_IPHONE_5)
		labelFrame.origin.y += 50.0f;
	
    [self.balanceLabel setFrame:labelFrame];
    self.balanceLabel.textAlignment = NSTextAlignmentCenter;
    
    self.balanceLabel.font = [UIFont systemFontOfSize:36.0f];
    
    self.balanceLabel.text = @"0.00000000 Ð";
    [self.view addSubview:self.balanceLabel];
	
	self.myAddressLabel = [[UILabel alloc] initWithFrame:self.balanceLabel.frame];
	CGRect addessFrame = self.myAddressLabel.frame;
	addessFrame.origin.y += 24.0f;
	addessFrame.origin.x = 0;
	addessFrame.size.width = self.view.bounds.size.width;
	[self.myAddressLabel setFrame:addessFrame];
	
	self.myAddressLabel.textAlignment = NSTextAlignmentCenter;
	self.myAddressLabel.font = [UIFont systemFontOfSize:14.0f];
	
	UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTapped:)];
	[self.myAddressLabel setUserInteractionEnabled:YES];
	[self.myAddressLabel addGestureRecognizer:gesture];
	
	[self.view addSubview:self.myAddressLabel];
}

-(void) addressTapped:(id)sender {
	addressAlert = [[UIAlertView alloc] initWithTitle:@"My Address" message:@"Would you like to copy your address, or show a QR code?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Copy Address", @"Show QR Code", nil];
	[addressAlert show];
}

-(void) copyAddress {
	UIPasteboard *pb = [UIPasteboard generalPasteboard];
	pb.string = self.myAddressLabel.text;
	[[[UIAlertView alloc] initWithTitle:@"Copied!" message:@"Your address was copied to the clipboard." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

-(void) showQRCode {
	UIImage *qr = [UIImage mdQRCodeForString:self.myAddressLabel.text size:640.0f];
	
	QRView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 320.0f)];
	QRView.center = self.view.center;
	
	CGPoint newCenter = QRView.center;
	newCenter.y -= 60.0f;
	QRView.center = newCenter;
	
	QRView.image = qr;
	QRView.backgroundColor = [UIColor whiteColor];
	
	UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrTapped:)];
	[QRView setUserInteractionEnabled:YES];
	[QRView addGestureRecognizer:gesture];
	
	[self.view addSubview:QRView];
	
}

-(void) qrTapped:(id)sender {
	[QRView removeFromSuperview];
	QRView = nil;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView == addressAlert) {
		if (buttonIndex == alertView.firstOtherButtonIndex) {
			[self copyAddress];
		} else if (buttonIndex == alertView.firstOtherButtonIndex + 1) {
			[self showQRCode];
		}
	}
}

-(void) showSendView:(id)sender {
    SendDogeController *controller = [[SendDogeController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [transactions count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	
	cell.textLabel.text = [[transactions objectAtIndex:indexPath.row] objectForKey:@"address"];
	float amount = [[[transactions objectAtIndex:indexPath.row] objectForKey:@"amount"] floatValue];
	
	if (amount < 0) {
		float fee = [[[transactions objectAtIndex:indexPath.row] objectForKey:@"fee"] floatValue];
		if (fee < 0) // less than, because fees are also negative
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f Ð + %.2f Ð fee", amount, fee];
		else
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f Ð", amount];
	} else {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f Ð", amount];
	}
	
	if (amount > 0.0f)
		cell.detailTextLabel.textColor = [UIColor greenColor];
	else
		cell.detailTextLabel.textColor = [UIColor redColor];
    
    return cell;
}

#pragma mark - Data Fetching

-(void) getBalanceAndTransactionsFromServer {
	if (!server)
		return;
	
	NSString *host = [server objectForKey:@"host"];
	NSString *user = [server objectForKey:@"user"];
	NSString *pass = [server objectForKey:@"pass"];
	NSString *path = [server objectForKey:@"path"];
	
	self.ssh = [NMSSHSession connectToHost:host	withUsername:user];
	
	if (self.ssh.isConnected) {
		[self.ssh authenticateByPassword:pass];
		
		if (self.ssh.isAuthorized) {
			NSLog(@"[+] Authentication succeeded");
		}
	}
	
	self.ssh.channel.requestPty = YES;
	
	// get balance
	NSError *error = nil;
	
	NSString *command = [NSString stringWithFormat:@"cd %@; ./dogecoind getbalance", path];
	
	NSString *response = [self.ssh.channel execute:command error:&error];
	if (error)
		NSLog(@"[-] Error changing dir: %@", error.localizedDescription);
	else
		NSLog(@"[+] Recieved balance: %@", response);
	
	float balance = [response floatValue];
	self.balanceLabel.text = [NSString stringWithFormat:@"%.2f Ð", balance];
	
	// get address
	command = [NSString stringWithFormat:@"cd %@; ./dogecoind listreceivedbyaddress 0 true", path];
	
	response = [self.ssh.channel execute:command error:&error];
	if (error)
		NSLog(@"[-] Error changing dir: %@", error.localizedDescription);
	else {
		NSLog(@"[+] Recieved address: %@", response);
		
		NSArray *addresses = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
		addresses = [addresses reversedArray];
		
		self.myAddressLabel.text = [[addresses objectAtIndex:0] objectForKey:@"address"];
	}
	
	// get transactions
	command = [NSString stringWithFormat:@"cd %@; ./dogecoind listtransactions", path];
	
	response = [self.ssh.channel execute:command error:&error];
	if (error)
		NSLog(@"[-] Error changing dir: %@", error.localizedDescription);
	else {
		NSLog(@"[+] Recieved response: %@", response);
		transactions = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
		
		[transactions reverse];
		
		[self.tableView reloadData];
	}
	
	[self.ssh disconnect]; // don't forget to do this when done
}

@end
