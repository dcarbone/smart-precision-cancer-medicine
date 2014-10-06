//
//  FHIRPopulationDataService.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/24/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "FHIRPopulationDataService.h"

@interface FHIRPopulationDataService()

@property (nonatomic, strong) NSString *resource;
@property (nonatomic, strong) NSDictionary *paramDict;
@property (nonatomic, strong) NSString *idProperty;
@property (nonatomic, strong) NSArray *idValues;
@property (nonatomic, strong) FHIRBundle *bigBundle;


@property (nonatomic, strong) FHIRDataConnection *fhirDataConnection;
@property (nonatomic, strong) NSMutableData *receivedData;


@property (nonatomic) BOOL search;
@property (nonatomic, strong) NSNumber *perResultCount;
@property (nonatomic) int tmpLoopCount;


- (NSArray *)getNextPropArray;
- (void) executeQuery:(NSString *)requestURLString
             withKeys:(NSArray *)paramKeys
            andValues:(NSArray *)paramValues;

@end

@implementation FHIRPopulationDataService

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _perResultCount = [NSNumber numberWithInt:100];
        
        _search = NO;
        _tmpLoopCount = 0;
        
        _fhirDataConnection = [[FHIRDataConnection alloc] init];
        _fhirDataConnection.connectionDelegate = self;
    }
    
    return self;
}

- (void) executeQuery:(NSString *)requestURLString
             withKeys:(NSArray *)paramKeys
            andValues:(NSArray *)paramValues
{
    // Parse and then store the query uri string
    if (![@"/" isEqualToString:[requestURLString substringFromIndex: [requestURLString length] - 1]])
        requestURLString = [NSString stringWithFormat:@"%@/", requestURLString];
    
    [_fhirDataConnection executeQuery:requestURLString withKeys:paramKeys andValues:paramValues];
}

- (void) queryPopulationForResource:(NSString *)resource
                         withParams:(NSDictionary *)params
                      andIDProperty:(NSString *)idProperty
                        andIDValues:(NSArray *)idValues
{
    if (![FHIRDataHelper isValidResource:resource])
        [NSException raise:@"Invalid resource type" format:@"No resource class exists for \"%@\"", resource];
    
    _resource = resource;
    _paramDict = params;
    _idProperty = idProperty;
    _idValues = idValues;
    _search = NO;
    
    NSString *count = params[@"_count"];
    if (count && ![count isEqualToString:[_perResultCount stringValue]])
        _perResultCount = [NSNumber numberWithInt:[count intValue]];
    
    [self executeQuery:[[NSString alloc] initWithFormat:@"%@%@/", fhirEndpoint, resource]
              withKeys:[[params allKeys] arrayByAddingObject:idProperty]
             andValues:[[params allValues] arrayByAddingObject:[self getNextPropArray]]];
}

- (void) searchPopulationForResource:(NSString *)resource
                withParams:(NSDictionary *)params
             andIDProperty:(NSString *)idProperty
               andIDValues:(NSArray *)idValues
{
    if (![FHIRDataHelper isValidResource:resource])
        [NSException raise:@"Invalid resource type" format:@"No resource class exists for \"%@\"", resource];
    
    _resource = resource;
    _paramDict = params;
    _idProperty = idProperty;
    _idValues = idValues;
    _search = YES;
    
    NSString *count = params[@"_count"];
    if (count && ![count isEqualToString:[_perResultCount stringValue]])
        _perResultCount = [NSNumber numberWithInt:[count intValue]];
    
    [self executeQuery:[[NSString alloc] initWithFormat:@"%@%@/_search/", fhirEndpoint, resource]
              withKeys:[[params allKeys] arrayByAddingObject:idProperty]
             andValues:[[params allValues] arrayByAddingObject:[self getNextPropArray]]];
}

- (NSArray *)getNextPropArray
{
    // Get the current offset
    NSNumber *skip = [NSNumber numberWithInt:(_tmpLoopCount * [_perResultCount intValue])];
    
    int offset = 0;
    int length = [_perResultCount intValue];
    
    if ([skip intValue] > 0)
        offset = [skip intValue] - 1;
    
    NSNumber *maxRange = [NSNumber numberWithInt:(offset + [_perResultCount intValue])];
    
    if ([maxRange intValue] > [_idValues count])
    {
        int diff = ([maxRange intValue] - (int)[_idValues count]);
        length = ([_perResultCount intValue] - diff);
    }
    
   return [_idValues subarrayWithRange:NSMakeRange(offset, length)];
}

- (void) cancelConnection
{
    [_fhirDataConnection cancel];
    [_fhirDataServiceDelegate fhirServiceConnectionCancelled];
}

#pragma mark NSURLConnection Delegate Methods
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _receivedData = [[NSMutableData alloc] init];
}

- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    FHIRResource *resource = [FHIRParser mapInfoFromData:self.receivedData];
    
    if ([resource isKindOfClass:[FHIRBundle class]])
    {
        _tmpLoopCount++;
        
        // Get the current offset
        NSNumber *skip = [NSNumber numberWithInt:(_tmpLoopCount * [_perResultCount intValue])];
        
        FHIRBundle *bundle = (FHIRBundle *)resource;
        
        if (_bigBundle == nil)
            _bigBundle = bundle;
        
        if ([skip longValue] >= [_idValues count])
        {
            _tmpLoopCount = 0;
            _resource = nil;
            _paramDict = nil;
            _idValues = nil;
            _idProperty = nil;
            _search = NO;
            
            [_fhirDataServiceDelegate fhirResourceResponseReceived:(FHIRResource *)_bigBundle];
            return;
        }
        
        _bigBundle.entry = [_bigBundle.entry arrayByAddingObjectsFromArray:bundle.entry];
        
        [_fhirDataServiceDelegate fhirPartialResponseReceived:[NSNumber numberWithLong:[_bigBundle.entry count]]
                                                          ofTotal:[NSNumber numberWithLong:[_idValues count]]];
        
        if (_search)
            [self searchPopulationForResource:_resource withParams:_paramDict andIDProperty:_idProperty andIDValues:_idValues];
        else
            [self queryPopulationForResource:_resource withParams:_paramDict andIDProperty:_idProperty andIDValues:_idValues];
        
        return;
    }
    
    [_fhirDataServiceDelegate fhirResourceResponseReceived:resource];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self cancelConnection];
    [_fhirDataServiceDelegate fhirErrorEncountered:error];
}

@end
