//
//  RootViewController.h
//  CSVDemo
//
//  Created by Guo Feng on 13-4-30.
//  Copyright (c) 2013年 CUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (strong, nonatomic) NSString *filePath;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;

- (IBAction)inputData:(id)sender;
- (IBAction)makeCSV:(id)sender;
 
@end
