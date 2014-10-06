//
//  OAuthDelegate.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/13/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OAuthDelegate <NSObject>

- (void) fhirAuthRequired;
- (void) fhirAuthTokenReceived:(NSString *)token;

@end
