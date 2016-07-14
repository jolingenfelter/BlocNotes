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

@interface ShareViewController ()

@property(nonatomic, strong) NSExtensionItem *inputItem;
@property(nonatomic, strong) NSExtensionItem *outputItem;
@property(nonatomic, strong) UINavigationBar *navBar;

@end

@implementation ShareViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add To BlocNotes";
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect navBarFrame = CGRectMake(0, 0, self.view.bounds.size.width, 60);
    self.navBar = [[UINavigationBar alloc] initWithFrame: navBarFrame];

    self.navBar.backgroundColor = [UIColor purpleColor];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelWasPressed)];
    UIBarButtonItem *saveButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveWasPressed)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.inputItem = [[NSExtensionItem alloc] init];
    self.outputItem = [[NSExtensionItem alloc] init];
}

- (void) viewDidLayoutSubviews {
    [self.view addSubview:self.navBar];
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
