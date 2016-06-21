//
//  NoteEntryListViewController.m
//  BlocNotes
//
//  Created by Joanna Lingenfelter on 6/20/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

#import "NoteEntryListViewController.h"
#import "CoreDataStack.h"
#import "NoteEntry.h"
#import "NewEntryViewController.h"


@interface NoteEntryListViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation NoteEntryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Notes";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWasPressed)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self.fetchedResultsController performFetch:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];;
}

- (NSFetchRequest *) entryListFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"NoteEntry"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    return fetchRequest;
}

- (NSFetchedResultsController *) fetchedResultsController {
    if (_fetchedResultsController !=nil) {
        return _fetchedResultsController;
    }
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self entryListFetchRequest];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NoteEntry *note = [self.fetchedResultsController objectAtIndexPath: indexPath];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:note];
    [coreDataStack saveContext];
}

- (void) addWasPressed {
    NewEntryViewController *newEntry = [[NewEntryViewController alloc] init];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newEntry];
    [self presentViewController:navigationController animated:YES completion: nil];
}






































@end
