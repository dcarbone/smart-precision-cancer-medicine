//
//  FHIRBundle.m
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

#import "FHIRBundle.h"
#import "FHIRDateTime.h"
#import "FHIRResource.h"
#import "FHIRString.h"
#import "FHIRId.h"
#import "FHIRInteger.h"

#import "FHIRErrorList.h"

@implementation FHIRBundle

- (NSNumber *)totalResults
{
    if (_totalResultsElement)
    {
        return (NSNumber *) _totalResultsElement;
    }
    return nil;
}

- (FHIRErrorList *)validate
{
    FHIRErrorList *result = [[FHIRErrorList alloc] init];
    
    [result addValidation:[super validate]];
    
    if (_entry != nil)
        for (FHIRBaseResource *resource in _entry)
            [result addValidationRange:[resource validate]];
    
    if (_author != nil)
        for (FHIRResource *author in _author)
            [result addValidationRange:[author validate]];
    
    if (_resourceTypeElement != nil)
        [result addValidationRange:[_resourceTypeElement validate]];
    
    if (_titleElement != nil)
        [result addValidationRange:[_titleElement validate]];
    
    if (self.idElement != nil)
        [result addValidationRange:[self.idElement validate]];
    
    if (_totalResultsElement != nil)
        [result addValidationRange:[_totalResultsElement validate]];
    
    if (_updatedElement != nil)
        [result addValidationRange:[_updatedElement validate]];
    
    return result;
}

@end
