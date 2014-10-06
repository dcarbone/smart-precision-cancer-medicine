//
//  MRNSearchView.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/26/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRNSearchDelegate <NSObject>

- (void) mrnSearchAction:(NSString *) mrnID;

@end

@interface MRNSearchView : UIView

@property (nonatomic, assign) id<MRNSearchDelegate> mrnSearchDelegate;

@end
