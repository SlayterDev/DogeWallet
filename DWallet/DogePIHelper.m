//
//  DogePIHelper.m
//  DWallet
//
//  Created by Brad Slayter on 2/10/14.
//  Copyright (c) 2014 Brad Slayter. All rights reserved.
//

#import "DogePIHelper.h"

@implementation DogePIHelper

static DogePIHelper *_sharedHelper;

+(DogePIHelper *) sharedHelper {
	if (_sharedHelper != nil)
		return _sharedHelper;
	
	_sharedHelper = [[DogePIHelper alloc] init];
	return _sharedHelper;
}

-(void) fetchAddress {
    NSURL *requestURL = [NSURL URLWithString:@"https://www.dogeapi.com/wow/?api_key=zrqhhms51tzq3im0oahlcs54&a=get_my_addresses"];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:requestURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       
        if (error) {
            NSLog(@"Error fetching: %@", error.localizedDescription);
        } else {
            [self parseJSON:data];
        }
        
    }];
}

-(void) parseJSON:(NSData *)data {
    NSError *error;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error)
        NSLog(@"Error: %@", error.localizedDescription);
    
    NSLog(@"Response: %@", response);
}

@end
