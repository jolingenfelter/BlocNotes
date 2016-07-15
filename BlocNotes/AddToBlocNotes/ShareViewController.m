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

@property(nonatomic, strong) NSExtensionItem *inputItem;
@property(nonatomic, strong) NSExtensionItem *outputItem;

@property(nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UITextView *bodyTextView;
@property (nonatomic, strong) UITextField *titleTextField;

@end

@implementation ShareViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect navBarFrame = CGRectMake(0, 0, self.view.bounds.size.width, 60);
    self.navBar = [[UINavigationBar alloc] initWithFrame: navBarFrame];
    [self.view addSubview:self.navBar];
    self.navBar.backgroundColor = [UIColor purpleColor];
    
//    UIView *separator = [[UIView alloc] init];
//    separator.backgroundColor = [UIColor blackColor];
//    separator.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview: separator];
//    
//    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_navBar, _titleTextField, _bodyTextView, separator);
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_navBar]|" options:kNilOptions metrics:nil views:viewDictionary]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleTextField]|" options:kNilOptions metrics:nil views:viewDictionary]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bodyTextView]|" options:kNilOptions metrics:nil views:viewDictionary]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator]|" options:kNilOptions metrics:nil views:viewDictionary]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.navBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:separator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleTextField attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:separator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bodyTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:separator attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bodyTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//    
//    [self createTitleTextField];
//    [self createBodyTextView];
    
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelWasPressed)];
//    UIBarButtonItem *saveButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveWasPressed)];
//
//    //[self.navBar setItems:@[cancelButton, saveButton]];
//    
    self.inputItem = [[NSExtensionItem alloc] init];
    self.outputItem = [[NSExtensionItem alloc] init];
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
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.titleTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) cancelWasPressed {
    [self dismissSelf];
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
//    newSharedNote.title = @"Note";
//    newSharedNote.body = self.contentText;
//    newSharedNote.date = [NSDate date];
//    
//    NSError *error;
//    [context save:&error];
    
}

- (void) dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//- (BOOL)isContentValid {
//    // Do validation of contentText and/or NSExtensionContext attachments here
//    return YES;
//}
//
//- (void)didSelectPost {
//    NSExtensionItem *inputItem = self.extensionContext.inputItems.firstObject;
//    NSExtensionItem *outputItem = [inputItem copy];
//    outputItem.attributedContentText = [[NSAttributedString alloc] initWithString:self.contentText attributes:nil];
//     NSArray *outputItems = @[outputItem];
//    [self.extensionContext completeRequestReturningItems:outputItems completionHandler:nil];
//    
//    NSManagedObjectContext *context = [CoreDataStack defaultStack].managedObjectContext;
//    NoteEntry *newSharedNote = [NSEntityDescription insertNewObjectForEntityForName:@"NoteEntry" inManagedObjectContext:context];
//    
//    newSharedNote.title = @"Note";
//    newSharedNote.body = self.contentText;
//    newSharedNote.date = [NSDate date];
//    
//    NSError *error;
//    [context save:&error];
//    
//    
//}
//
//- (NSArray *)configurationItems {
//    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
//    return @[];
//}

@end
