//
//  TransactionViewController.m
//  DWallet
//
//  Created by Brad Slayter on 2/5/14.
//  Copyright (c) 2014 Brad Slayter. All rights reserved.
//

#import "TransactionViewController.h"

@interface TransactionViewController ()

@end

@implementation TransactionViewController

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
    
    self.navigationItem.title = @"Transaction Details";
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
    return @"Tap any cell to copy its value";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    if (indexPath.row == 0) {
        if ([[self.transaction objectForKey:@"category"] isEqualToString:@"send"])
            cell.textLabel.text = @"Sent To";
        else
            cell.textLabel.text = @"Recieved From";
        
        cell.detailTextLabel.text = [self.transaction objectForKey:@"address"];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Amount";
        
        float amount = [[self.transaction objectForKey:@"amount"] floatValue];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", amount];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Fee";
        
        float fee = [[self.transaction objectForKey:@"fee"] floatValue];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", fee];
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"Blockhash";
        
        cell.detailTextLabel.text = [self.transaction objectForKey:@"blockhash"];
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"txid";
        
        cell.detailTextLabel.text = [self.transaction objectForKey:@"txid"];
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"Time";
        
        double epochTime = [[self.transaction objectForKey:@"timereceived"] doubleValue];
        NSTimeInterval seconds = epochTime;
        
        // (Step 1) Create NSDate object
        NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
        NSLog (@"Epoch time %lf equates to UTC %@", epochTime, epochNSDate);
        
        // (Step 2) Use NSDateFormatter to display epochNSDate in local time zone
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm:ss zzz"];
        NSLog (@"Epoch time %lf equates to %@", epochTime, [dateFormatter stringFromDate:epochNSDate]);
        
        cell.detailTextLabel.text = [dateFormatter stringFromDate:epochNSDate];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    pb.string = cell.detailTextLabel.text;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[[UIAlertView alloc] initWithTitle:@"Copied!" message:[NSString stringWithFormat:@"Copied %@ to clipboard", cell.textLabel.text] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
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
