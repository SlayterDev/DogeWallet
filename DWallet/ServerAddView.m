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
	
	self.navigationItem.title = @"Server Details";
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
    return 4;
}

-(NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return @"Enter the path to dogecoind. (e.g. ~/dogecoin/src/)";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
		cell = [[UITableViewCell alloc] init];
	
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Host";
		
		hostField = [self createTextField];
		[cell.contentView addSubview:hostField];
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"Username";
		
		userField = [self createTextField];
		[cell.contentView addSubview:userField];
	} else if (indexPath.row == 2) {
		cell.textLabel.text = @"Password";
		
		passField = [self createTextField];
		[cell.contentView addSubview:passField];
	} else if (indexPath.row == 3) {
		cell.textLabel.text = @"Path";
		
		pathField = [self createTextField];
		pathField.text = @"~/";
		[cell.contentView addSubview:pathField];
	}
    
    return cell;
}

-(UITextField *) createTextField {
	UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(100, -2, 320 - 100 - 15, 50)];
	field.keyboardAppearance = UIKeyboardAppearanceDark;
	field.textAlignment = NSTextAlignmentRight;
	
	return field;
}

-(void) doneTapped:(id)sender {
	NSDictionary *serverInfo = @{@"host": hostField.text, @"user": userField.text, @"pass": passField.text, @"path": passField.text};
	
	NSString *path = [NSString stringWithFormat:@"%@/server.plist", [[BSFileHelper sharedHelper] getDocumentsDirectory]];
	
	[serverInfo writeToFile:path atomically:YES];
	
	[self.delegate serverViewDidClose:self];
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
