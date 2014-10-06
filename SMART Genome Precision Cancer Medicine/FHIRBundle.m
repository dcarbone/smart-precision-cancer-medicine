//
//  FHIRBundle.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/28/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
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
