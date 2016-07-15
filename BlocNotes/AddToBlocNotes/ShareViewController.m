//
//  ShareViewController.m
//  AddToBlocNotes
//
//  Created by Joanna Lingenfelter on 7/1/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

#import "ShareViewController.h"
#import "CoreDataStack.h"
#import "NoteEntry.h"

@interface ShareViewController () <UITextViewDelegate>

@property(nonatomic, strong) NSExtensionContext *extensionContext;
@property(nonatomic, strong) NSExtensionItem *inputItem;
@property(nonatomic, strong) NSExtensionItem *outputItem;

@property(nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UITextView *bodyTextView;
@property (nonatomic, strong) UITextField *titleTextField;

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.navBar = [[UINavigationBar alloc] init];
    self.navBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.navBar];
    
    self.titleTextField = [[UITextField alloc] init];
    self.titleTextField.placeholder = @"Title goes here...";
    self.titleTextField.leftViewMode = UITextFieldViewModeAlways;
    self.titleTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.titleTextField];
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor blackColor];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview: separator];
    
    self.bodyTextView = [[UITextView alloc] init];
    self.bodyTextView.text = @"Write your note...";
    self.bodyTextView.delegate = self;
    self.bodyTextView.tag = 0;
    self.bodyTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bodyTextView];
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_navBar, _titleTextField, separator, _bodyTextView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_navBar]|" options:kNilOptions metrics:nil views:viewDictionary]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleTextField]|" options:kNilOptions metrics:nil views:viewDictionary]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.navBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator]|" options:kNilOptions metrics:nil views:viewDictionary]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:separator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleTextField attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:separator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5]];

    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bodyTextView]|" options:kNilOptions metrics:nil views:viewDictionary]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bodyTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:separator attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bodyTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];


    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelWasPressed)];
    UIBarButtonItem *saveButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveWasPressed)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Add to BlocNotes"];
    navigationItem.rightBarButtonItem = saveButton;
    navigationItem.leftBarButtonItem = cancelButton;

    [self.navBar setItems:@[navigationItem]];
    
    self.extensionContext = [[NSExtensionContext alloc] init];
    self.inputItem = [[NSExtensionItem alloc] init];
    self.outputItem = [[NSExtensionItem alloc] init];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.titleTextField becomeFirstResponder];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) cancelWasPressed {
    [UIView animateWithDuration:0.20 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
    }];
}

- (void) saveWasPressed {
//    NSExtensionItem *inputItem = self.extensionContext.inputItems.firstObject;
//    NSExtensionItem *outputItem = [inputItem copy];
//    outputItem.attributedContentText = [[NSAttributedString alloc] initWithString:self.contentText attributes:nil];
//    NSArray *outputItems = @[outputItem];
//    [self.extensionContext completeRequestReturningItems:outputItems completionHandler:nil];
//    
//    NSManagedObjectContext *context = [CoreDataStack defaultStack].managedObjectContext;
//    NoteEntry *newSharedNote = [NSEntityDescription insertNewObjectForEntityForName:@"NoteEntry" inManagedObjectContext:context];
//    
//    newSharedNote.title = newSharedNote.title;
//    newSharedNote.body = newSharedNote.body;
//    newSharedNote.date = [NSDate date];
//    
//    NSError *error;
//    [context save:&error];
}

//
//- (NSArray *)configurationItems {
//    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
//    return @[];
//}

@end
