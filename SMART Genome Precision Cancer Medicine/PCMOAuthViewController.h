//
//  PCMOAuthViewController.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/13/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OAuthDataDelegate.h"

#define fhirAuthEndpoint @""
#define fhirTokenAuthEndpoint @""

#define redirectURI         @""
#define clientID            @""


@interface PCMOAuthViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, assign) id<OAuthDataDelegate> oAuthDataDelegate;

@end
