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
}

-(void) createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 150.0f, self.view.bounds.size.width, self.view.bounds.size.height - 150.0f) style:UITableViewStylePlain];
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
    return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    return cell;
}

@end
