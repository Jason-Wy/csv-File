//
//  RootViewController.m
//  CSVDemo
//
//  Created by Guo Feng on 13-4-30.
//  Copyright (c) 2013年 CUIT. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "Student.h"

@interface RootViewController()

- (void)createFile:(NSString *)fileName;
- (void)exportCSV:(NSString *)fileName;
- (NSArray *)queryStudents;

@end

@implementation RootViewController

@synthesize filePath = _filePath;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize nameTextField = _nameTextField;
@synthesize numTextField = _numTextField;
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = entity;
    NSArray *students = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    for (Student *stu in students) {
        NSLog(@"name = %@ , num = %@", stu.name, stu.num);
    }
}

- (void)viewDidUnload
{
    
    [self setNameTextField:nil];
    [self setNumTextField:nil];
     [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Property

- (NSManagedObjectContext *)managedObjectContext {

    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = app.managedObjectContext;
    
    return _managedObjectContext;
}


#pragma mark- Private Methods

- (void)createFile:(NSString *)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fileName error:nil];
    
    
    if (![fileManager createFileAtPath:fileName contents:nil attributes:nil]) {
        NSLog(@"不能创建文件");
    }
     
}

- (void)exportCSV:(NSString *)fileName {
    
    
    NSOutputStream *output = [[NSOutputStream alloc] initToFileAtPath:fileName append:YES];
    [output open];
    
    
    if (![output hasSpaceAvailable]) {
        NSLog(@"没有足够可用空间");
    } else {
        
        NSString *header = @"学好,姓名\n";
        const uint8_t *headerString = (const uint8_t *)[header cStringUsingEncoding:NSUTF8StringEncoding];
        NSInteger headerLength = [header lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        NSInteger result = [output write:headerString maxLength:headerLength];
        if (result <= 0) {
            NSLog(@"写入错误");
        }
        
        
        NSArray *students = [self queryStudents];
        for (Student *stu in students) {
         
            NSString *row = [NSString stringWithFormat:@"%@,%@\n", stu.num, stu.name];
            NSLog(@"row is %@",row);
            const uint8_t *rowString = (const uint8_t *)[row cStringUsingEncoding:NSUTF8StringEncoding];
            NSInteger rowLength = [row lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            result = [output write:rowString maxLength:rowLength];
            if (result <= 0) {
                NSLog(@"无法写入内容");
            }
            
        }
        
        [output close];
    }
}

- (NSArray *)queryStudents {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    NSArray *students = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return students;
}


#pragma mark- Public Methods

- (IBAction)inputData:(id)sender {
     
    Student *stu = (Student *)[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    stu.name = self.nameTextField.text;
    stu.num = self.numTextField.text;
    
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    
    self.nameTextField.text = @"";
    self.numTextField.text = @"";
    
}

- (IBAction)makeCSV:(id)sender {
    
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *docementDir = [documents objectAtIndex:0];
    NSString *filePath = [docementDir stringByAppendingPathComponent:@"student.csv"];
    NSLog(@"filePath = %@", filePath);    
    
    [self createFile:filePath];
    [self exportCSV:filePath];
}
@end
