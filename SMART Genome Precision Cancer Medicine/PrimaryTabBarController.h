//
//  PrimaryTabBarController.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/24/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRNSearchViewController.h"
#import "PatientSearchTableViewController.h"
#import "AboutUsController.h"

#import "PCMOAuthViewController.h"

#import "OAuthDataDelegate.h"

#import "FHIRDataConnection.h"

@interface PrimaryTabBarController : UITabBarController <OAuthDataDelegate>

@end
