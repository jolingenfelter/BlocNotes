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

@property (nonatomic, strong) UITextView *bodyTextView;
@property (nonatomic, strong) UITextView *titleTextView;

@end

@implementation NewEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"New note";
  
    
    [self createTitleTextView];
    [self createBodyTextView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelWasPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveWasPressed)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    NSDate *noteDate;
    
    if (self.noteEntry != nil) {
        self.bodyTextView.text = self.noteEntry.body;
        self.titleTextView.text = self.noteEntry.title;
        noteDate = [NSDate dateWithTimeIntervalSince1970:self.noteEntry.date];
    } else {
        noteDate = [NSDate date];
    }
    
}

- (void) createTitleTextView {
    self.titleTextView = [[UITextView alloc] init];
    self.titleTextView.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.titleTextView.text = @"Title goes here...";
    self.titleTextView.textColor = [UIColor lightGrayColor];
    self.titleTextView.textContainer.maximumNumberOfLines = 2;
}

- (void) createBodyTextView {
    self.bodyTextView = [[UITextView alloc] init];
    self.bodyTextView.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.bodyTextView.text = @"Write your note...";
    self.bodyTextView.textColor = [UIColor lightGrayColor];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.titleTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect titleTextViewRect = CGRectMake(0, 60, self.view.bounds.size.width, 60);
    CGRect bodyTextViewRect = CGRectMake(0, 120, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.titleTextView.frame = titleTextViewRect;
    self.bodyTextView.frame = bodyTextViewRect;

    [self.view addSubview:self.titleTextView];
    [self.view addSubview:self.bodyTextView];

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
    noteEntry.title = self.titleTextView.text;
    noteEntry.date = [[NSDate date] timeIntervalSince1970];
    [coreDataStack saveContext];
}

- (void) updateNote {
    self.noteEntry.body = self.bodyTextView.text;
    self.noteEntry.title = self.titleTextView.text;
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}
@end
