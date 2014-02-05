//
//  SendDogeController.m
//  DWallet
//
//  Created by Brad Slayter on 2/4/14.
//  Copyright (c) 2014 Brad Slayter. All rights reserved.
//

#import "SendDogeController.h"

@interface SendDogeController ()

@end

@implementation SendDogeController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Send Doge";
	self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
	
	UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendTransaction:)];
	self.navigationItem.rightBarButtonItem = sendButton;
}

-(void) cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
		cell = [[UITableViewCell alloc] init];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Address";
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(275, 0, cell.bounds.size.width - 275, cell.bounds.size.height)];
        //button.backgroundColor = [UIColor blackColor];
        [button setImage:[UIImage imageNamed:@"qrcode.png"] forState:UIControlStateNormal];
        [cell.contentView addSubview:button];
        [button addTarget:self action:@selector(scanCode:) forControlEvents:UIControlEventTouchUpInside];
        
        addressField = [[UITextField alloc] initWithFrame:CGRectMake(100, -2, cell.bounds.size.width - 100 - button.bounds.size.width, 50)];
        [cell.contentView addSubview:addressField];
        addressField.inputAccessoryView = [self createAccessoryView];
        addressField.keyboardAppearance = UIKeyboardAppearanceDark;
    } else {
        cell.textLabel.text = @"Amount";
        
        amountField = [[UITextField alloc] initWithFrame:CGRectMake(100, -2, cell.bounds.size.width - 100 - 15, 50)];
        [cell.contentView addSubview:amountField];
        amountField.keyboardType = UIKeyboardTypeDecimalPad;
        amountField.textAlignment = NSTextAlignmentRight;
        amountField.inputAccessoryView = [self createAccessoryView];
        amountField.keyboardAppearance = UIKeyboardAppearanceDark;
    }
    
    return cell;
}

-(UIToolbar *) createAccessoryView {
	UIToolbar *accessory = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    accessory.tintColor = [UIColor darkGrayColor];
	
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(switchField:)];
    UIBarButtonItem *prev = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:self action:@selector(switchField:)];
    
	UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyPad:)];
	
	accessory.items = @[prev, next, space, dismissButton];
	[accessory sizeToFit];
	
	return accessory;
}

-(void) switchField:(id)sender {
    if ([addressField isFirstResponder])
        [amountField becomeFirstResponder];
    else
        [addressField becomeFirstResponder];
}

-(void) dismissKeyPad:(id)sender {
	if ([addressField isFirstResponder])
        [addressField resignFirstResponder];
    else
        [amountField resignFirstResponder];
}

-(void) scanCode:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    [reader.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
    reader.readerView.zoom = 1.0;
	reader.showsZBarControls = YES;
	reader.showsCameraControls = NO;
    
    [self presentViewController:reader animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    
    for (ZBarSymbol *object in results) {
        NSLog(@"From ZBAR: %@", object.data);
        addressField.text = object.data;
    }
}

#pragma mark - sendTransaction

-(void) sendTransaction:(id)sender {
	if ([amountField.text floatValue] == 0.0 || [amountField.text isEqualToString:@""]) {
		[[[UIAlertView alloc] initWithTitle:@"Error." message:@"Please enter a non-zero amount to send." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
		return;
	}
	
	if ([addressField.text isEqualToString:@""]) {
		[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid address to send to." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
		return;
	}
	
	NSString *message = [NSString stringWithFormat:@"Are you sure you want to send %@ Ð to %@?", amountField.text, addressField.text];
	
	confirmView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Do it.", nil];
	[confirmView show];
}

-(void) confirmSend {
	NMSSHSession *ssh = [NMSSHSession connectToHost:@"69.90.132.160" withUsername:@"dogecoin"];
	
	if (ssh.isConnected) {
		[ssh authenticateByPassword:@"mixmaster1"];
		
		if (ssh.isAuthorized) {
			NSLog(@"[+] Authentication succeeded");
		}
	}
	
	ssh.channel.requestPty = YES;
	
	NSString *command = [NSString stringWithFormat:@"cd dogecoin/src; ./dogecoind sendtoaddress %@ %@", addressField.text, amountField.text];
	
	NSError *error;
	NSString *response = [ssh.channel execute:command error:&error];
	if (error)
		NSLog(@"Error sending transaction: %@", error.localizedDescription);
	else {
		NSLog(@"Response: %@", response);
		
		sentView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Transaction sent successfuly!" delegate:self cancelButtonTitle:@"Yay!" otherButtonTitles:nil];
		[sentView show];
		
		[ssh disconnect];
	}
	
}

#pragma mark - UIAlertViewDelegate

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView == confirmView) {
		if (buttonIndex == alertView.firstOtherButtonIndex)
			[self confirmSend];
	} else if (alertView == sentView) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
