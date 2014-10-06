﻿/*
  Copyright (c) 2011-2013, HL7, Inc.
  All rights reserved.
  
  Redistribution and use in source and binary forms, with or without modification, 
  are permitted provided that the following conditions are met:
  
   * Redistributions of source code must retain the above copyright notice, this 
     list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above copyright notice, 
     this list of conditions and the following disclaimer in the documentation 
     and/or other materials provided with the distribution.
   * Neither the name of HL7 nor the names of its contributors may be used to 
     endorse or promote products derived from this software without specific 
     prior written permission.
  
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
  POSSIBILITY OF SUCH DAMAGE.
  

 * Generated on Fri, May 9, 2014 11:14+1000 for FHIR v0.0.81
 */
/*
 * null
 */
#import "FHIRConceptSetFilterComponent.h"

#import "FHIRCode.h"

#import "FHIRErrorList.h"

@implementation FHIRConceptSetFilterComponent

- (NSString *)property
{
    if(self.propertyElement)
    {
        return [self.propertyElement value];
    }
    return nil;
}

- (void )setProperty:(NSString *)property
{
    if(property)
    {
        [self setPropertyElement:[[FHIRCode alloc] initWithValue:property]];
    }
    else
    {
        [self setPropertyElement:nil];
    }
}


- (kFilterOperator )op
{
    return [FHIREnumHelper parseString:[self.opElement value] enumType:kEnumTypeFilterOperator];
}

- (void )setOp:(kFilterOperator )op
{
    [self setOpElement:[[FHIRCode/*<code>*/ alloc] initWithValue:[FHIREnumHelper enumToString:op enumType:kEnumTypeFilterOperator]]];
}


- (NSString *)value
{
    if(self.valueElement)
    {
        return [self.valueElement value];
    }
    return nil;
}

- (void )setValue:(NSString *)value
{
    if(value)
    {
        [self setValueElement:[[FHIRCode alloc] initWithValue:value]];
    }
    else
    {
        [self setValueElement:nil];
    }
}


- (FHIRErrorList *)validate
{
    FHIRErrorList *result = [[FHIRErrorList alloc] init];
    
    [result addValidation:[super validate]];
    
    if(self.propertyElement != nil )
        [result addValidationRange:[self.propertyElement validate]];
    if(self.opElement != nil )
        [result addValidationRange:[self.opElement validate]];
    if(self.valueElement != nil )
        [result addValidationRange:[self.valueElement validate]];
    
    return result;
}

@end
