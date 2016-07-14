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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.fetchedResultsController performFetch:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidChangeNotification:) name:NSPersistentStoreCoordinatorStoresDidChangeNotification  object:[[CoreDataStack defaultStack] persistentStoreCoordinator]];
}

//- (void) viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:[[CoreDataStack defaultStack] persistentStoreCoordinator]];
//}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NoteEntry *noteEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (noteEntry.title) {
        cell.textLabel.text = noteEntry.title;
    } else {
        cell.textLabel.text = noteEntry.body;
    }
    
    return cell;
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

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewEntryViewController *newEntry = [[NewEntryViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newEntry];
    [self presentViewController:navigationController animated:YES completion: nil];
    
    newEntry.noteEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
}  

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        default:
            break;
    }
}


- (void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        
        default:
            break;
    }
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void) dataDidChangeNotification:(NSNotification *)notification {
    NSLog(@"Data did change");
}




























@end
