//
//  NewEntryViewController.m
//  BlocNotes
//
//  Created by Joanna Lingenfelter on 6/20/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

#import "NewEntryViewController.h"
#import "NoteEntry.h"
#import "CoreDataStack.h"

@interface NewEntryViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *bodyTextView;
@property (nonatomic, strong) UITextField *titleTextField;

@end

@implementation NewEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    if (self.noteEntry.title) {
        self.title = self.noteEntry.title;
    } else {
         self.title = @"New note";
    }
    
    [self createTitleTextField];
    [self createBodyTextView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelWasPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveWasPressed)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    NSDate *noteDate;
    
    if (self.noteEntry != nil) {
        self.bodyTextView.text = self.noteEntry.body;
        self.titleTextField.text = self.noteEntry.title;
        noteDate = [NSDate date];
    } else {
        noteDate = [NSDate date];
    }
    
}

- (void) createTitleTextField {
    self.titleTextField = [[UITextField alloc] init];
    self.titleTextField.placeholder = @"Title goes here...";
    self.titleTextField.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void) createBodyTextView {
    self.bodyTextView = [[UITextView alloc] init];
    self.bodyTextView.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.bodyTextView.text = @"Write your note...";
    self.bodyTextView.delegate = self;
    self.bodyTextView.tag = 0;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@"Write your note..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write your note...";;
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.titleTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect titleTextViewRect = CGRectMake(15, 60, self.view.bounds.size.width - 30, 60);
    CGRect bodyTextViewRect = CGRectMake(0, 120, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.titleTextField.frame = titleTextViewRect;
    self.bodyTextView.frame = bodyTextViewRect;

    [self.view addSubview:self.titleTextField];
    [self.view addSubview:self.bodyTextView];
    
    // Border on TitleTextField
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.titleTextField.frame.size.height - 1, self.titleTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.titleTextField.layer addSublayer:bottomBorder];

}

- (void) dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) cancelWasPressed {
    [self dismissSelf];
}

- (void) saveWasPressed {
    if (self.noteEntry != nil) {
        [self updateNote];
    } else {
        [self insertNote];
    }
    
    [self dismissSelf];
}

- (void) insertNote {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NoteEntry *noteEntry = [NSEntityDescription insertNewObjectForEntityForName:@"NoteEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    noteEntry.body = self.bodyTextView.text;
    noteEntry.title = self.titleTextField.text;
    noteEntry.date = [NSDate date];
    [coreDataStack saveContext];
}

- (void) updateNote {
    self.noteEntry.body = self.bodyTextView.text;
    self.noteEntry.title = self.titleTextField.text;
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}
@end
