//
//  PrimaryTabBarController.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/24/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "PrimaryTabBarController.h"

@interface PrimaryTabBarController ()

@property (nonatomic) BOOL firstLoad;

@end

@implementation PrimaryTabBarController

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _firstLoad = YES;
        
        UINavigationController *mrnSearchNav, *patientSearchNav;
        
        mrnSearchNav = [[UINavigationController alloc] init];
        mrnSearchNav.title = @"MRN Search";
        mrnSearchNav.viewControllers = @[[[MRNSearchViewController alloc] init]];
        
        patientSearchNav = [[UINavigationController alloc] init];
        patientSearchNav.title = @"Patient Search";
        patientSearchNav.viewControllers = @[[[PatientSearchTableViewController alloc] init]];
        
        [self setViewControllers:@[mrnSearchNav, patientSearchNav, [[AboutUsController alloc] init]] animated:NO];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_firstLoad)
    {
        UINavigationController *selectedController = (UINavigationController *)self.selectedViewController;
        
        PCMOAuthViewController *loginViewController = [[PCMOAuthViewController alloc] init];
        loginViewController.oAuthDataDelegate = self;
        
        [selectedController presentViewController:loginViewController animated:NO completion:nil];
        
        _firstLoad = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - OAuthDataDelegate implementation
- (void) authorizationFail
{
    
}

- (void) authorizationSuccess:(NSString *) token
{
    [FHIRDataConnection setToken:token];
}

@end
