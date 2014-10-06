/*
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
  

 * Generated on Fri, Jan 31, 2014 10:17+1100 for FHIR v0.12
 */
/*
 * null
 */
#import "FHIRProfileSearchParamComponent.h"

#import "FHIRCode.h"
#import "FHIRString.h"

#import "FHIRErrorList.h"

@implementation FHIRProfileSearchParamComponent

- (NSArray /*<NSString>*/ *)resource
{
    if(self.resourceElement)
    {
        NSMutableArray *array = [NSMutableArray new];
        for(FHIRCode *elem in self.resourceElement)
            [array addObject:[elem value]];
        return [NSArray arrayWithArray:array];
    }
    return nil;
}

- (void )setResource:(NSArray /*<NSString>*/ *)resource
{
    if(resource)
    {
        NSMutableArray *array = [NSMutableArray new];
        for(NSString *value in resource)
            [array addObject:[[FHIRCode alloc] initWithValue:value]];
        [self setResourceElement:[NSArray arrayWithArray:array]];
    }
    else
    {
        [self setResourceElement:nil];
    }
}


- (NSString *)name
{
    if(self.nameElement)
    {
        return [self.nameElement value];
    }
    return nil;
}

- (void )setName:(NSString *)name
{
    if(name)
    {
        [self setNameElement:[[FHIRString alloc] initWithValue:name]];
    }
    else
    {
        [self setNameElement:nil];
    }
}


- (NSString *)type
{
    if(self.typeElement)
    {
        return [self.typeElement value];
    }
    return nil;
}

- (void )setType:(NSString *)type
{
    if(type)
    {
        [self setTypeElement:[[FHIRCode alloc] initWithValue:type]];
    }
    else
    {
        [self setTypeElement:nil];
    }
}


- (NSString *)documentation
{
    if(self.documentationElement)
    {
        return [self.documentationElement value];
    }
    return nil;
}

- (void )setDocumentation:(NSString *)documentation
{
    if(documentation)
    {
        [self setDocumentationElement:[[FHIRString alloc] initWithValue:documentation]];
    }
    else
    {
        [self setDocumentationElement:nil];
    }
}


- (NSString *)xpath
{
    if(self.xpathElement)
    {
        return [self.xpathElement value];
    }
    return nil;
}

- (void )setXpath:(NSString *)xpath
{
    if(xpath)
    {
        [self setXpathElement:[[FHIRString alloc] initWithValue:xpath]];
    }
    else
    {
        [self setXpathElement:nil];
    }
}


- (NSArray /*<NSString>*/ *)target
{
    if(self.targetElement)
    {
        NSMutableArray *array = [NSMutableArray new];
        for(FHIRCode *elem in self.targetElement)
            [array addObject:[elem value]];
        return [NSArray arrayWithArray:array];
    }
    return nil;
}

- (void )setTarget:(NSArray /*<NSString>*/ *)target
{
    if(target)
    {
        NSMutableArray *array = [NSMutableArray new];
        for(NSString *value in target)
            [array addObject:[[FHIRCode alloc] initWithValue:value]];
        [self setTargetElement:[NSArray arrayWithArray:array]];
    }
    else
    {
        [self setTargetElement:nil];
    }
}


- (FHIRErrorList *)validate
{
    FHIRErrorList *result = [[FHIRErrorList alloc] init];
    
    [result addValidation:[super validate]];
    
    if(self.resourceElement != nil )
        for(FHIRCode *elem in self.resourceElement)
            [result addValidationRange:[elem validate]];
    if(self.nameElement != nil )
        [result addValidationRange:[self.nameElement validate]];
    if(self.typeElement != nil )
        [result addValidationRange:[self.typeElement validate]];
    if(self.documentationElement != nil )
        [result addValidationRange:[self.documentationElement validate]];
    if(self.xpathElement != nil )
        [result addValidationRange:[self.xpathElement validate]];
    if(self.targetElement != nil )
        for(FHIRCode *elem in self.targetElement)
            [result addValidationRange:[elem validate]];
    
    return result;
}

@end
