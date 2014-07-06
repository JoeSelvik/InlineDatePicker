//
//  TNTMasterViewController.m
//  InlineDatePicker
//
//  Created by Joe Selvik on 7/6/14.
//  Copyright (c) 2014 The New Tricks. All rights reserved.
//

#import "TNTPeopleViewController.h"
#import "TNTPerson.h"
#import "TNTDetailViewController.h"


static NSString *kPersonCellID = @"personCell";
static NSString *kDatePickerCellID = @"datePickerCell";
static NSInteger kDatePickerTag = 1;


@interface TNTPeopleViewController ()

@property (strong, nonatomic) NSMutableArray *persons;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSIndexPath *datePickerIndexPath;

@end



@implementation TNTPeopleViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self createDateFormatter];
    [self createFakeData];
}

// Helper method to instantiate the date formatter
- (void)createDateFormatter {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

// Create fake data
- (void)createFakeData {
    TNTPerson *p1 = [[TNTPerson alloc] initWithName:@"John Smith"
                                        dateOfBirth:[NSDate dateWithTimeIntervalSince1970:632448000]
                                       placeOfBirth:@"London"];
    
    TNTPerson *p2 = [[TNTPerson alloc] initWithName:@"Jane Anderson"
                                        dateOfBirth:[NSDate dateWithTimeIntervalSince1970:123456789]
                                       placeOfBirth:@"San Francisco"];
    
    if (!self.persons) {
        self.persons = [[NSMutableArray alloc] init];
    }
    
    [self.persons addObject:p1];
    [self.persons addObject:p2];
}

- (BOOL)datePickerIsShown {
    return self.datePickerIndexPath != nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    //if (!_objects) {
    if (!_persons) {
        //_objects = [[NSMutableArray alloc] init];
        _persons = [[NSMutableArray alloc] init];
    }
    //[_objects insertObject:[NSDate date] atIndex:0];
    [_persons insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [self.persons count];
    
    if ([self datePickerIsShown]) {
        numberOfRows++;
    }
    
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row == indexPath.row)) {
        
        TNTPerson *person = self.persons[indexPath.row -1];
        cell = [self createPickerCell:person.dateOfBirth];
        
    } else {
        
        TNTPerson *person = self.persons[indexPath.row];
        cell = [self createPersonCell:person];
        
    }
    
    return cell;
}

- (UITableViewCell *)createPersonCell:(TNTPerson *)person {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPersonCellID];
    
    cell.textLabel.text = person.name;
    
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:person.dateOfBirth];
    
    return cell;
}

- (UITableViewCell *)createPickerCell:(NSDate *)date {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
    
    UIDatePicker *targetedDatePicker = (UIDatePicker *)[cell viewWithTag:kDatePickerTag];
    
    [targetedDatePicker setDate:date animated:NO];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[_objects removeObjectAtIndex:indexPath.row];
        [_persons removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSDate *object = _objects[indexPath.row];
        NSDate *object = _persons[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
