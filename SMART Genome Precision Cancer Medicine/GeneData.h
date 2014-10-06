//
//  GeneData.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/22/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneData : NSObject

- (UIColor *)geneColorWithName:(NSString *)geneName;
- (UIColor *)geneColorWithIndex:(NSUInteger)index;

- (UIColor *)geneLabelColorWithName:(NSString *)geneName;
- (UIColor *)geneLabelColorWithIndex:(NSUInteger)index;

- (NSString *)geneDisplayValue:(NSString *)geneName;

- (NSURL *)geneReferenceURLWithName:(NSString *)geneName;
- (NSURL *)geneReferenceURLWithIndex:(NSUInteger)index;

@end
