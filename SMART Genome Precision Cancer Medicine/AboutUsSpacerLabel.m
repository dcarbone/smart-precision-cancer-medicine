//
//  AboutUsSpacerLabel.m
//  SMART Genomics Precision Cancer Medicine
//
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "AboutUsSpacerLabel.h"

@implementation AboutUsSpacerLabel

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.text = @"---------------------------------";
        self.font = [UIFont systemFontOfSize:14.0f];
    }
    
    return self;
}

@end
