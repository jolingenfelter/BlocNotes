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

@interface NewEntryViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation NewEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"New note";
    self.textView = [[UITextView alloc] init];
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelWasPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveWasPressed)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    NSDate *noteDate;
    
    if (self.noteEntry != nil) {
        self.textView.text = self.noteEntry.body;
        noteDate = [NSDate dateWithTimeIntervalSince1970:self.noteEntry.date];
    } else {
        noteDate = [NSDate date];
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect textViewRect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.textView.frame = textViewRect;
    [self.view addSubview:self.textView];

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
    noteEntry.body = self.textView.text;
    noteEntry.date = [[NSDate date] timeIntervalSince1970];
    [coreDataStack saveContext];
}

- (void) updateNote {
    self.noteEntry.body = self.textView.text;
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}
@end
