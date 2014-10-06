//
//  PCMOAuthViewController.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/13/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
// 
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
//

#import "PCMOAuthViewController.h"

@interface PCMOAuthViewController ()

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSString *stateHash;

- (NSString *) createAuthorizationCodeURLString;

@end

@implementation PCMOAuthViewController

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.title = @"Authorization Needed";
        self.modalPresentationStyle = UIModalPresentationFullScreen;        
        _webView = [[UIWebView alloc] init];
        
        _webView.delegate = self;
        
        _webView.scrollView.scrollEnabled = YES;
        _webView.scrollView.bounces = NO;
        
        
        [_webView setAutoresizingMask: self.view.autoresizingMask];
    }
    
    return self;
}

- (void) loadView
{
    self.view = _webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *urlString = [self createAuthorizationCodeURLString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:0];
    
    [_webView loadRequest:urlRequest];
}

- (NSString *)genRandStringLength:(int)len {
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) createAuthorizationCodeURLString
{
    _stateHash = [self genRandStringLength:32];
    
    return [NSString stringWithFormat:@"%@?client_id=%@&response_type=%@&scope=%@&redirect_uri=%@&state=%@",
            fhirAuthEndpoint,
            clientID,
            @"token",
            [@"fhir_complete" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],
            redirectURI,
            _stateHash];
    
    //    return [NSString stringWithFormat:@"%@?scope=read&client_id=phenome&response_type=token", authorizeTokenEndpoint];
}

#pragma mark - UIWebViewDelegate implementation

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [request.URL absoluteString];
    
    if ([url hasPrefix:redirectURI])
    {
        NSArray *split = [[[[url stringByReplacingOccurrencesOfString:@"%23"
                                                           withString:@"?"]
                            componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"];
        
        NSString *accessToken, *state;
        
        for (NSString *part in split)
        {
            NSArray *tmp = [part componentsSeparatedByString:@"="];
            
            if ([tmp count] < 2)
            {
                [_oAuthDataDelegate authorizationFail];
                return NO;
            }
            
            if ([tmp[0] isEqualToString:@"access_token"])
            {
                accessToken = tmp[1];
            }
            else if ([tmp[0] isEqualToString:@"state"])
            {
                state = tmp[1];
            }
        }
        
        if (accessToken == nil || state == nil || ![state isEqualToString:_stateHash])
        {
            [_oAuthDataDelegate authorizationFail];
        }
        else
        {
            [_oAuthDataDelegate authorizationSuccess:accessToken];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else
    {
        return YES;
    }
    
    return NO;
}


@end
