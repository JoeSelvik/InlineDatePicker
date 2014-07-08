//
//  TNTMasterViewController.m
//  InlineDatePicker
//
//  Created by Joe Selvik on 7/6/14.
//  Copyright (c) 2014 The New Tricks. All rights reserved.
//

#import "TNTPeopleViewController.h"
#import "TNTPerson.h"


static NSString *kPersonCellID = @"personCell";
static NSString *kDatePickerCellID = @"datePickerCell";
//static NSInteger kDatePickerTag = 1;

enum MyViewTags {
    kDatePickerTag = 1
};


@interface TNTPeopleViewController ()

@property (strong, nonatomic) NSMutableArray *persons;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSIndexPath *datePickerIndexPath;
@property CGFloat pickerCellRowHeight;

- (IBAction)dateChanged:(id)sender;

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
    
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
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
        
        TNTPerson *person = self.persons[indexPath.row - 1];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView beginUpdates];
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row - 1 == indexPath.row)) {
        
        [self hideExistingPicker];
        
    } else {
        NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewPicker:indexPath];
        
        if ([self datePickerIsShown]) {
            [self hideExistingPicker];
        }
        
        [self showNewPickerAtIndex:newPickerIndexPath];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:newPickerIndexPath.row + 1 inSection:0];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
}


// Delete the old datePicker cell
- (void)hideExistingPicker {
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    
    self.datePickerIndexPath = nil;
}

// If a date picker is visible and is above the currently selected index then we need to
// remeber that the cell will be deleted from the table
// If the date picker is below then it won't impact the new date picker.
- (NSIndexPath *)calculateIndexPathForNewPicker:(NSIndexPath *)selectedIndexPath {
    
    NSIndexPath *newIndexPath;
    
    if (([self datePickerIsShown]) && (self.datePickerIndexPath.row < selectedIndexPath.row)) {
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row -1 inSection:0];
        
    } else {
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row inSection:0];
        
    }
    
    return newIndexPath;
}

// Need to insert a new datePicker cell in the TV
- (void)showNewPickerAtIndex:(NSIndexPath *)indexPath {
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row +1  inSection:0]];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = self.tableView.rowHeight;
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row == indexPath.row)) {
        rowHeight = self.pickerCellRowHeight;
    }
    
    return rowHeight;
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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        //NSDate *object = _objects[indexPath.row];
//        NSDate *object = _persons[indexPath.row];
//        [[segue destinationViewController] setDetailItem:object];
//    }
//}

- (IBAction)dateChanged:(UIDatePicker *)sender {
    
    NSIndexPath *parentCellIndexPath = nil;
    
    if ([self datePickerIsShown]) {
        parentCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    } else {
        return;
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:parentCellIndexPath];
    TNTPerson *person = self.persons[parentCellIndexPath.row];
    person.dateOfBirth = sender.date;
    
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:sender.date];
}


@end
