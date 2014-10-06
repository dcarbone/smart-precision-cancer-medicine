//
//  OAuthDataDelegate.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/13/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OAuthDataDelegate <NSObject>

- (void) authorizationFail;
- (void) authorizationSuccess:(NSString *) token;

@end
