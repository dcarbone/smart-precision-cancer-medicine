//
//  AminoAcidData.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/25/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AminoAcidData : NSObject

- (UIColor *)aminoAcidColorWithIndex:(NSUInteger)index;

- (UIColor *)aminoAcidLabelColorWithIndex:(NSUInteger)index;

- (NSString *)aminoAcidDisplayValue:(NSString *)aminoAcidName;

@end
