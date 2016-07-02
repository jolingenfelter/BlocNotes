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

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    NSExtensionItem *inputItem = self.extensionContext.inputItems.firstObject;
    NSExtensionItem *outputItem = [inputItem copy];
    outputItem.attributedContentText = [[NSAttributedString alloc] initWithString:self.contentText attributes:nil];
     NSArray *outputItems = @[outputItem];
    [self.extensionContext completeRequestReturningItems:outputItems completionHandler:nil];
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    NSManagedObjectContext *context = coreDataStack.managedObjectContext;
    NoteEntry *newSharedNote = [[NoteEntry alloc] init];
    newSharedNote = [NSEntityDescription insertNewObjectForEntityForName:@"NoteEntry" inManagedObjectContext:context];
    
    newSharedNote.title = @"Note";
    newSharedNote.body = self.contentText;
    newSharedNote.date = [NSDate date];
    
    NSError *error;
    [context save:&error];
    
    
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
