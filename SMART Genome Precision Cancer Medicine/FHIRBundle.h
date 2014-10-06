//
//  FHIRBundle.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/28/14.
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

#import "FHIRBaseResource.h"

@class FHIRString;
@class FHIRInteger;
@class FHIRDateTime;
@class FHIRResource;

@interface FHIRBundle : FHIRBaseResource

/*
 * Type of resource being returned.
 */
@property (nonatomic, strong) FHIRString *resourceTypeElement;

@property (nonatomic, strong) NSString *resourceType;

/*
 * Title of Bundle
 */
@property (nonatomic, strong) FHIRString *titleElement;

@property (nonatomic, strong) NSString *title;

/*
 * Local ID for element
 */
@property (nonatomic, strong) FHIRId *idElement;

@property (nonatomic, strong) NSString *id;

/*
 * Number of results in this bundle
 */
@property (nonatomic, strong) FHIRInteger *totalResultsElement;

@property (nonatomic, strong) NSNumber *totalResults;

/*
 * Last updated Date and Time of bundled resources
 */
@property (nonatomic, strong) FHIRDateTime *updatedElement;

@property (nonatomic, strong) NSString *updated;

/*
 * Who and/or what authored the document
 */
@property (nonatomic, strong) NSArray/*<ResourceReference>*/ *author;

/*
 * Array of resources included in this bundle
 */
@property (nonatomic, strong) NSArray *entry;

- (FHIRErrorList *)validate;

@end
