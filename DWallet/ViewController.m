//
//  ViewController.m
//  DWallet
//
//  Created by Brad Slayter on 2/4/14.
//  Copyright (c) 2014 Brad Slayter. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"My Wallet";
    
    UIBarButtonItem *sendBtn = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(showSendView:)];
    self.navigationItem.rightBarButtonItem = sendBtn;
    
    [self createTableView];
    [self createBalanceLabel];
	
	[self getBalanceAndTransactionsFromServer];
}

-(void) createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 194.0f, self.view.bounds.size.width, self.view.bounds.size.height - 194.0f) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

-(void) createBalanceLabel {
    self.balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 50.0f)];
    self.balanceLabel.center = self.view.center;
    CGRect labelFrame = self.balanceLabel.frame;
    labelFrame.origin.y -= 155.0f;
    [self.balanceLabel setFrame:labelFrame];
    self.balanceLabel.textAlignment = NSTextAlignmentCenter;
    
    self.balanceLabel.font = [UIFont systemFontOfSize:36.0f];
    
    self.balanceLabel.text = @"0.00000000 Ð";
    [self.view addSubview:self.balanceLabel];
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
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", amount];
	
	if (amount > 0.0f)
		cell.detailTextLabel.textColor = [UIColor greenColor];
	else
		cell.detailTextLabel.textColor = [UIColor redColor];
    
    return cell;
}

#pragma mark - Data Fetching

-(void) getBalanceAndTransactionsFromServer {
	self.ssh = [NMSSHSession connectToHost:@"69.90.132.160" withUsername:@"dogecoin"];
	
	if (self.ssh.isConnected) {
		[self.ssh authenticateByPassword:@"mixmaster1"];
		
		if (self.ssh.isAuthorized) {
			NSLog(@"[+] Authentication succeeded");
		}
	}
	
	self.ssh.channel.requestPty = YES;
	
	NSError *error = nil;
	NSString *response = [self.ssh.channel execute:@"cd dogecoin/src; ./dogecoind getbalance" error:&error];
	if (error)
		NSLog(@"[-] Error changing dir: %@", error.localizedDescription);
	else
		NSLog(@"[+] Recieved response: %@", response);
	
	float balance = [response floatValue];
	self.balanceLabel.text = [NSString stringWithFormat:@"%.2f Ð", balance];
	
	response = [self.ssh.channel execute:@"cd dogecoin/src; ./dogecoind listtransactions" error:&error];
	if (error)
		NSLog(@"[-] Error changing dir: %@", error.localizedDescription);
	else {
		NSLog(@"[+] Recieved response: %@", response);
		transactions = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
		
		[self.tableView reloadData];
	}
	
	[self.ssh disconnect]; // don't forget to do this when done
}

@end
