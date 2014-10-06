//
//  AboutUsSectionHeaderLabel.m
//  SMART Genomics Precision Cancer Medicine
//
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "AboutUsSectionHeaderLabel.h"

@implementation AboutUsSectionHeaderLabel

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.font = [UIFont systemFontOfSize:20.0f];
    }
    
    return self;
}

@end
