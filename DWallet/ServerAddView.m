//
//  ServerAddView.m
//  DWallet
//
//  Created by Bradley Slayter on 2/5/14.
//  Copyright (c) 2014 Brad Slayter. All rights reserved.
//

#import "ServerAddView.h"

@interface ServerAddView ()

@end

@implementation ServerAddView

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
	
	NSString *path = [self getServerPath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NO]) {
		server = [[NSDictionary alloc] initWithContentsOfFile:path];
	}
	
	self.navigationItem.title = @"Server Details";
	self.navigationController.navigationBar.translucent = NO;
	
    UIBarButtonItem *helpBtn = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self action:@selector(helpTapped:)];
    
	if (!server) { // first time entering
		UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped:)];
		self.navigationItem.rightBarButtonItem = doneBtn;
        self.navigationItem.leftBarButtonItem = helpBtn;
	} else {
        self.navigationItem.rightBarButtonItem = helpBtn;
    }
    
	accessoryView = [self createAccessoryView];
	fields = [[NSMutableArray alloc] init];
}

-(void) viewWillDisappear:(BOOL)animated {
	if (server)
		[self doneTapped:nil];
}

-(NSString *) getServerPath {
	return [NSString stringWithFormat:@"%@/server.plist", [[BSFileHelper sharedHelper] getDocumentsDirectory]];
}

-(void) helpTapped:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Help" message:@"Host: Address of the server your wallet is running on.\nUser: Your username for the server.\nPass: Your password for the server.\nPath: Path to Dogecoin wallet software (dogecoind). For example \"~/dogecoin/src/\". Do not include the executable name in the path.\nEncrypted: Turn this on if your wallet is encrypted with a passphrase." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

-(NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return @"Enter the path to dogecoind. \n(e.g. ~/dogecoin/src/)\nDo not include the executable in your path";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
		cell = [[UITableViewCell alloc] init];
	
	if (indexPath.row == 0) {
		cell.textLabel.text = @"View Tutorial";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"Host";
		
		hostField = [self createTextField];
		[cell.contentView addSubview:hostField];
		
		if (server)
			hostField.text = [server objectForKey:@"host"];
		
		[fields insertObject:hostField atIndex:0];
	} else if (indexPath.row == 2) {
		cell.textLabel.text = @"Username";
		
		userField = [self createTextField];
		[cell.contentView addSubview:userField];
		
		if (server)
			userField.text = [server objectForKey:@"user"];
		
		[fields insertObject:userField atIndex:1];
	} else if (indexPath.row == 3) {
		cell.textLabel.text = @"Password";
		
		passField = [self createTextField];
		passField.secureTextEntry = YES;
		[cell.contentView addSubview:passField];
		
		if (server)
			passField.text = [server objectForKey:@"pass"];
		
		[fields insertObject:passField atIndex:2];
	} else if (indexPath.row == 4) {
		cell.textLabel.text = @"Path";
		
		pathField = [self createTextField];
		pathField.text = @"~/";
		[cell.contentView addSubview:pathField];
		
		if (server)
			pathField.text = [server objectForKey:@"path"];
		
		[fields insertObject:pathField atIndex:3];
	} else if (indexPath.row == 5) {
        cell.textLabel.text = @"Wallet is Encrypted";
        
        encryptedSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = encryptedSwitch;
        [encryptedSwitch setOn:NO animated:NO];
        
        if (server)
            [encryptedSwitch setOn:[[server objectForKey:@"encrypted"] boolValue] animated:NO];
    }
	
	if (indexPath.row != 0)
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(UITextField *) createTextField {
	UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(100, -2, 320 - 100 - 15, 50)];
	field.keyboardAppearance = UIKeyboardAppearanceDark;
	field.textAlignment = NSTextAlignmentRight;
	field.autocapitalizationType = UITextAutocapitalizationTypeNone;
	field.autocorrectionType = UITextAutocorrectionTypeNo;
	
	field.inputAccessoryView = accessoryView;
	
	return field;
}

-(void) doneTapped:(id)sender {
	if ([hostField.text isEqualToString:@""] || [userField.text isEqualToString:@""] || [passField.text isEqualToString:@""] || [pathField.text isEqualToString:@""]) {
		[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill out all fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
		return;
	}
	
	
	NSDictionary *serverInfo = @{@"host": hostField.text, @"user": userField.text, @"pass": passField.text, @"path": pathField.text, @"encrypted": [NSNumber numberWithBool:encryptedSwitch.on]};
	
	NSString *path = [NSString stringWithFormat:@"%@/server.plist", [[BSFileHelper sharedHelper] getDocumentsDirectory]];
	
	[serverInfo writeToFile:path atomically:YES];
	
	[self.delegate serverViewDidClose:self];
}

-(UIToolbar *) createAccessoryView {
	UIToolbar *accessory = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    accessory.tintColor = [UIColor darkGrayColor];
	
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(switchField:)];
	next.tag = 0;
    UIBarButtonItem *prev = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:self action:@selector(switchField:)];
	prev.tag = 1;
    
	UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyPad:)];
	
	accessory.items = @[prev, next, space, dismissButton];
	[accessory sizeToFit];
	
	return accessory;
}

-(void) switchField:(id)sender {
	UIBarButtonItem *btn = (UIBarButtonItem *)sender;
	
	UITextField *field;
	for (UITextField *obj in fields) {
		if ([obj isFirstResponder])
			field = obj;
	}
	
	int index = [fields indexOfObject:field];
	
	if (btn.tag == 0) {
		index += 1;
	} else {
		index -= 1;
	}
	
	if (index >= fields.count)
		index = 0;
	else if (index < 0)
		index = fields.count - 1;
	
	[[fields objectAtIndex:index] becomeFirstResponder];
}

-(void) dismissKeyPad:(id)sender {
	for (UITextField *field in fields) {
		if ([field isFirstResponder]) {
			[field resignFirstResponder];
		}
	}
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://slayterdevelopment.com/blog/2014/02/08/how-to-set-up-your-doge-wallet-for-ios-using-a-raspberry-pi/"]];
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
