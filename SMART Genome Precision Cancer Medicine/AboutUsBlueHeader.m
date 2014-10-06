//
//  AboutUsBlueHeader.m
//  SMART Genomics Precision Cancer Medicine
//
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "AboutUsBlueHeader.h"

@implementation AboutUsBlueHeader

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.font = [UIFont systemFontOfSize:18.0f];
        self.textColor = [UIColor blueColor];
    }
    
    return self;
}

@end
