//
//  TNTAddPersonTableViewController.m
//  InlineDatePicker
//
//  Created by Joe Selvik on 7/7/14.
//  Copyright (c) 2014 The New Tricks. All rights reserved.
//

#define kDatePickerIndex 2
#define kDatePickerCellHeight 164

#import "TNTAddPersonTableViewController.h"

@interface TNTAddPersonTableViewController ()

- (IBAction)cancelPressed:(id)sender;
- (IBAction)savePressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)datePickerChanged:(UIDatePicker *)sender;
@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerCell;

@property (weak, nonatomic) IBOutlet UITextField *placeOfBirthTextField;

@property NSDateFormatter *dateFormatter;
@property NSDate *selectedBirthday;
@property (nonatomic, assign) BOOL datePickerIsShowing;

@property UITextField *activeTextField;

@end

@implementation TNTAddPersonTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupBirthdayLabel];
    [self signUpForKeyboardNotifications];
}

- (void)setupBirthdayLabel {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *defaultDate = [NSDate date];
    
    self.birthdayLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    self.birthdayLabel.textColor = [self.tableView tintColor];
    
    self.selectedBirthday = defaultDate;
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Hide DOB picker until cell is tapped on.
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    if ([indexPath section] == kDatePickerIndex){
        
        height = self.datePickerIsShowing ? kDatePickerCellHeight : 0.0f;
        
    }
    
    return height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"%ld", (long)[indexPath section]);
    
    if ([indexPath section] == 1){
        
        if (self.datePickerIsShowing){
            
            [self hideDatePickerCell];
            
        }else {
            
            [self.activeTextField resignFirstResponder];
            [self showDatePickerCell];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showDatePickerCell {
    
    self.datePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.datePicker.hidden = NO;
    self.datePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.datePicker.alpha = 1.0f;
        
    }];
}

- (void)hideDatePickerCell {
    
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.datePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.datePicker.hidden = YES;
                     }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePressed:(id)sender {
}

//- (IBAction)datePickerChanged:(id)sender
- (IBAction)datePickerChanged:(UIDatePicker *)sender
{
    self.birthdayLabel.text =  [self.dateFormatter stringFromDate:sender.date];
    
    self.selectedBirthday = sender.date;
}


#pragma mark - Keyboard

- (void)keyboardWillShow {
    
    if (self.datePickerIsShowing){
        
        [self hideDatePickerCell];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.activeTextField = textField;
}


@end
