//
//  FHIRBundleEntryComponent.h
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

#import "FHIRElement.h"

#import "FHIRBundle.h"
#import "FHIRErrorList.h"

@class FHIRCodeableConcept;
@class FHIRBoolean;
@class FHIRDateTime;
@class FHIRResource;

@interface FHIRBundleEntryComponent : FHIRElement

/*
 * Title of Bundle Entry
 */
@property (nonatomic, strong) FHIRString *titleElement;

@property (nonatomic, strong) NSString *title;

/*
 * Last updated date
 */
@property (nonatomic, strong) FHIRDateTime *updatedElement;

@property (nonatomic, strong) NSString *updated;

/*
 * The content for this bundle entry
 */
@property (nonatomic, strong) FHIRBaseResource *content;

- (FHIRErrorList *)validate;

@end
