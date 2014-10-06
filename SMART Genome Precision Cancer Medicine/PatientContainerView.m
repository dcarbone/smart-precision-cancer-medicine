//
//  PatientContainerView.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/23/14.
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

#import "PatientContainerView.h"

@interface PatientContainerView()

@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;

@end

@implementation PatientContainerView

#pragma mark - Patient Detail View
- (void) setPatientDetailView:(PatientDetailView *)patientView
{
    _patientDetailView = patientView;
    [self addSubview:_patientDetailView];
    [self layoutPatientDetailViewConstraints];
}

- (void) layoutPatientDetailViewConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_patientDetailView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_patientDetailView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_patientDetailView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
}

#pragma mark - Patient Phenomic Data view
- (void) setGenomePhenomeDataView:(PatientGenomePhenomeDataView *)pgoView
{
    _genomePhenomeDataView = pgoView;
    [self addSubview:_genomePhenomeDataView];
    [self layoutPatientGenomePhenomeDataView];
}

- (void) layoutPatientGenomePhenomeDataView
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_genomePhenomeDataView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_genomePhenomeDataView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1.0f
                                                       constant:0.0f]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_genomePhenomeDataView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_patientDetailView
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1.0f
                                                       constant:0.0f]];
}

- (void)setPopulationPlotView:(UIView *)populationPlotView
{
    _populationPlotView = populationPlotView;
    [self addSubview:_populationPlotView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_genomePhenomeDataView]-20-[_populationPlotView]"
                                                                 options:NSLayoutFormatAlignAllCenterX
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_genomePhenomeDataView, _populationPlotView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_populationPlotView]|"
                                                                 options:NSLayoutFormatAlignAllTop
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_populationPlotView)]];
}

@end
