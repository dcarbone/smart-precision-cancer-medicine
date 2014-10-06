//
//  PatientSearchTableViewController.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/26/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FHIRDataService.h"

#import "PatientViewController.h"

@interface PatientSearchTableViewController : UITableViewController <FHIRDataServiceDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@end
