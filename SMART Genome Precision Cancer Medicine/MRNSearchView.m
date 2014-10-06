//
//  MRNSearchView.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/26/14.
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

#import "MRNSearchView.h"

@interface MRNSearchView()

@property (nonatomic, strong) UILabel *searchLabel;
@property (nonatomic, strong) UITextField *searchInput;
@property (nonatomic, strong) UIButton *searchSubmit;

@property (nonatomic, strong) UIImageView *bigSMARTLogo;
@property (nonatomic, strong) UIImageView *poweredByVanderbilt;
@property (nonatomic, strong) UIImageView *smallSMARTLogo;
@property (nonatomic, strong) UIImageView *smallFHIRLogo;

@property (nonatomic, strong) UILabel *grantInfoText;
@property (nonatomic, strong) UILabel *copyright;

@end

@implementation MRNSearchView

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.translatesAutoresizingMaskIntoConstraints = YES;
        self.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        
        [self setupSubViews];
        [self setupConstraints];
    }
    
    return self;
}

- (void) setupSubViews
{
    _bigSMARTLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SMARTBig"]];
    _bigSMARTLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_bigSMARTLogo];
    
    _searchLabel = [[UILabel alloc] init];
    _searchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _searchLabel.text = @"Enter an MRN number below";
    [self addSubview:_searchLabel];
    
    _searchInput = [[UITextField alloc] init];
    _searchInput.translatesAutoresizingMaskIntoConstraints = NO;
    _searchInput.keyboardType = UIKeyboardTypeNumberPad;
    _searchInput.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:_searchInput];
    
    _searchSubmit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _searchSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    [_searchSubmit addTarget:self
                      action:@selector(mrnSearchAction:)
            forControlEvents:UIControlEventTouchUpInside];
    [_searchSubmit setTitle:@"Search" forState:UIControlStateNormal];
    [self addSubview:_searchSubmit];
    
    _poweredByVanderbilt = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PoweredByVanderbilt"]];
    _poweredByVanderbilt.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_poweredByVanderbilt];
    
    _grantInfoText = [[UILabel alloc] init];
    _grantInfoText.translatesAutoresizingMaskIntoConstraints = NO;
    _grantInfoText.adjustsFontSizeToFitWidth = NO;
    _grantInfoText.numberOfLines = 0;
    _grantInfoText.textAlignment = NSTextAlignmentCenter;
    _grantInfoText.font = [UIFont systemFontOfSize:12.0f];
    _grantInfoText.text = @"This work was supported by grant ONC 90TR0001/01.  The funder had no direct role in application design, software development, or decision to publish.";
    [self addSubview:_grantInfoText];
    
    _copyright = [[UILabel alloc] init];
    _copyright.translatesAutoresizingMaskIntoConstraints = NO;
    _copyright.textAlignment = NSTextAlignmentCenter;
    _copyright.font = [UIFont systemFontOfSize:12.0f];
    _copyright.text = @"Copyright \u00A9 Vanderbilt-Ingram Cancer Center";
    [self addSubview:_copyright];
    
    _smallSMARTLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SMARTSmall"]];
    _smallSMARTLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_smallSMARTLogo];
    
    _smallFHIRLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FHIRSmall"]];
    _smallFHIRLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_smallFHIRLogo];
}

- (void) setupConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_bigSMARTLogo
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_bigSMARTLogo]-(>=20)-[_searchLabel]-[_searchInput]-[_searchSubmit]-(<=150)-[_poweredByVanderbilt]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_bigSMARTLogo, _searchLabel, _searchInput, _searchSubmit, _poweredByVanderbilt)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_searchLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_searchInput
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:0
                                                        toItem:nil
                                                     attribute:0
                                                    multiplier:1.0
                                                      constant:225.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_searchInput
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_searchSubmit
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_smallSMARTLogo]-50-[_smallFHIRLogo]"
                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_smallSMARTLogo, _smallFHIRLogo)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_smallFHIRLogo]-30-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_smallFHIRLogo)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_smallFHIRLogo
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:85.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_grantInfoText
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:0.9f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_poweredByVanderbilt
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_poweredByVanderbilt]-[_grantInfoText]-[_copyright]-100-|"
                                                                 options:NSLayoutFormatAlignAllCenterX
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_poweredByVanderbilt, _grantInfoText, _copyright)]];
}

-(void) mrnSearchAction:(id)sender
{
    NSString *mrnNumber = [NSString stringWithString:_searchInput.text];
    
    [_mrnSearchDelegate mrnSearchAction:mrnNumber];
}

@end
