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

@interface NewEntryViewController () <UITextViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITextView *bodyTextView;
@property (nonatomic, strong) UITextField *titleTextField;

@property (nonatomic, strong)  UITapGestureRecognizer *tap;

@end

@implementation NewEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

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
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareWasPressed)];
    
    [self.navigationItem setRightBarButtonItems: @[saveButton, shareButton]];
    
    NSDate *noteDate;
    
    if (self.noteEntry != nil) {
        self.bodyTextView.text = self.noteEntry.body;
        self.titleTextField.text = self.noteEntry.title;
        noteDate = [NSDate date];
    } else {
        noteDate = [NSDate date];
    }
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor blackColor];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview: separator];
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleTextField, _bodyTextView, separator);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleTextField]|" options:kNilOptions metrics:nil views:viewDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bodyTextView]|" options:kNilOptions metrics:nil views:viewDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator]|" options:kNilOptions metrics:nil views:viewDictionary]];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:separator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:separator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleTextField attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.titleTextField attribute:NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bodyTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:separator attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bodyTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToBeginEditing:)];
    [self.bodyTextView addGestureRecognizer:self.tap];
    
    if (self.bodyTextView != nil) {
        self.bodyTextView.editable = NO;
        self.bodyTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    }

    
}

- (void) tapToBeginEditing: (UIGestureRecognizer *) gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        if (!self.bodyTextView.editable) {
            self.bodyTextView.editable = YES;
            self.bodyTextView.dataDetectorTypes = UIDataDetectorTypeNone;
            [self.bodyTextView becomeFirstResponder];
        } else {
            self.bodyTextView.editable = NO;
            self.bodyTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        }
    }
    
}

- (void) createTitleTextField {
    self.titleTextField = [[UITextField alloc] init];
    self.titleTextField.placeholder = @"Title goes here...";
    self.titleTextField.leftViewMode = UITextFieldViewModeAlways;
    self.titleTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.titleTextField];
    
}

- (void) createBodyTextView {
    self.bodyTextView = [[UITextView alloc] init];
    self.bodyTextView.text = @"Write your note...";
    self.bodyTextView.delegate = self;
    self.bodyTextView.tag = 0;
    self.bodyTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bodyTextView];
    
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
    self.bodyTextView.editable = NO;
    self.bodyTextView.dataDetectorTypes = UIDataDetectorTypeAll;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.titleTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) shareWasPressed {
   
    NSMutableArray *itemsToShare = [[NSMutableArray alloc] init];
    
    if (self.titleTextField.text.length > 0) {
        [itemsToShare addObject:self.titleTextField.text];
    }
    
    if (self.bodyTextView.text.length > 0) {
        [itemsToShare addObject:self.bodyTextView.text];
    }
    
    if (itemsToShare.count > 0) {
        UIActivityViewController *shareNoteVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        [self presentViewController:shareNoteVC animated:YES completion:nil];
    }
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
