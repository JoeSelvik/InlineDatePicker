//
//  TNTAddPersonTableViewController.h
//  InlineDatePicker
//
//  Created by Joe Selvik on 7/7/14.
//  Copyright (c) 2014 The New Tricks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNTPeopleViewController.h"

@interface TNTAddPersonTableViewController : UITableViewController <UITextFieldDelegate>

@property  (weak, nonatomic) id<TNTAddPersonDelegate> delegate;

@end
