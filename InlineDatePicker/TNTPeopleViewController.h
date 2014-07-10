//
//  TNTMasterViewController.h
//  InlineDatePicker
//
//  Created by Joe Selvik on 7/6/14.
//  Copyright (c) 2014 The New Tricks. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TNTPerson.h"

@protocol TNTAddPersonDelegate <NSObject>

- (void)savePersonDetails:(TNTPerson *)person;

@end

@interface TNTPeopleViewController : UITableViewController

@end
