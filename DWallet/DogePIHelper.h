//
//  DogePIHelper.h
//  DWallet
//
//  Created by Brad Slayter on 2/10/14.
//  Copyright (c) 2014 Brad Slayter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DogePIHelper : NSObject

+(DogePIHelper *) sharedHelper;
-(void) fetchAddress;

@end
