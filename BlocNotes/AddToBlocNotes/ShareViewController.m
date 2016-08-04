//
//  ShareViewController.m
//  AddToBlocNotes
//
//  Created by Joanna Lingenfelter on 7/1/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "ShareViewController.h"
#import "CoreDataStack.h"
#import "NoteEntry.h"

@interface ShareViewController () <UITextViewDelegate>

@property(nonatomic, strong) UINavigationBar *navBar;
@property(nonatomic, strong) UITextView *bodyTextView;
@property(nonatomic, strong) UITextField *titleTextField;

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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_navBar]|" options:kNilOptions metrics:nil views:viewDictionary]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
    
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
    
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *provider in item.attachments) {
            if ([provider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePlainText]) {
                [provider loadItemForTypeIdentifier:(NSString *)kUTTypePlainText options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.bodyTextView.text = (NSString *)item;
                    }];
                }];
            }
            
            if ([provider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
                [provider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                         self.titleTextField.text = ((NSURL *)item).absoluteString;
                    }];
                }];
            }
            
            if ([provider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
                [provider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *jsDict, NSError *error) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        NSDictionary *jsPreprocessingResults= jsDict[NSExtensionJavaScriptPreprocessingResultsKey];
                        NSString *selectedText = jsPreprocessingResults[@"selection"];
                        NSString *pageTitle = jsPreprocessingResults[@"title"];
                        NSString *paragraphText = jsPreprocessingResults[@"paragraphText"];
                        if ([selectedText length] > 0) {
                            self.bodyTextView.text = selectedText;
                        } else if ([paragraphText length] > 0) {
                            self.bodyTextView.text = paragraphText;
                        }
                       
                        if ([pageTitle length] > 0) {
                            self.titleTextField.text = pageTitle;
                        }
                    }];
                }];
            }
        }
    }
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
    [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
    
    NSManagedObjectContext *context = [CoreDataStack defaultStack].localDataManagedObjectContext;
    NoteEntry *newSharedNote = [NSEntityDescription insertNewObjectForEntityForName:@"NoteEntry" inManagedObjectContext:context];
    
    newSharedNote.title = self.titleTextField.text;
    newSharedNote.body = self.bodyTextView.text;
    newSharedNote.date = [NSDate date];
    
    NSError *error;
    [context save:&error];
}

@end
