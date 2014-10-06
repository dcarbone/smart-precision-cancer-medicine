//
//  PatientDetailLabel.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/11/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "PatientDetailLabel.h"

@implementation PatientDetailLabel

- (id)initWithText:(NSString *)text
{
    self = [super init];
    
    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.text = text;
        
        self.font = [UIFont systemFontOfSize:18.0f];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
