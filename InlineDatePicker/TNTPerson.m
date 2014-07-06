//
//  TNTPerson.m
//  InlineDatePicker
//
//  Created by Joe Selvik on 7/6/14.
//  Copyright (c) 2014 The New Tricks. All rights reserved.
//

#import "TNTPerson.h"

@implementation TNTPerson

- (id)initWithName:(NSString *)name dateOfBirth:(NSDate *)dateOfBirth placeOfBirth:(NSString *)placeOfBirth {
    
    if (self = [super init]) {
        
        _name = [name copy];
        _dateOfBirth = dateOfBirth;
        _placeOfBirth = [placeOfBirth copy];
    }
    
    return self;
}

@end
