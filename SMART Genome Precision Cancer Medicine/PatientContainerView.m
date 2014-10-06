//
//  PatientContainerView.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/23/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
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
