//
//  FHIRBundleEntryComponent.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/28/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "FHIRBundleEntryComponent.h"

#import "FHIRDateTime.h"
#import "FHIRString.h"

@implementation FHIRBundleEntryComponent

- (void)setContent:(FHIRBaseResource *)content
{
    _content = content;
    _content.idElement = self.idElement;
}

- (FHIRErrorList *)validate
{
    FHIRErrorList *result = [[FHIRErrorList alloc] init];
    
    [result addValidation:[super validate]];
    
    if (_content != nil)
        [result addValidationRange:[_content validate]];
    
    if (_titleElement != nil)
        [result addValidationRange:[_titleElement validate]];
    
    if (_updatedElement != nil)
        [result addValidationRange:[_updatedElement validate]];
    
    return result;
}

@end

