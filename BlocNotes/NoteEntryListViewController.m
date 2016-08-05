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
#import "SettingsViewController.h"


@interface NoteEntryListViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray *compiledData;
@property (nonatomic, strong) NSFetchedResultsController *localDataFetchedResultsController;

@end

@implementation NoteEntryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Notes";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWasPressed)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsWasPressed)];
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    [settingsButton setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = settingsButton;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self registerForiCloudNotifications];
    
    [self.localDataFetchedResultsController performFetch:nil];
    [self.fetchedResultsController performFetch:nil];
}

- (void) registerForiCloudNotifications {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSPersistentStoreCoordinatorStoresWillChangeNotification object:coreDataStack.managedObjectContext.persistentStoreCoordinator queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [coreDataStack.managedObjectContext performBlock:^{
            if ([coreDataStack.managedObjectContext hasChanges]) {
                NSError *saveError;
                if (![coreDataStack.managedObjectContext save:&saveError]) {
                    NSLog(@"Save error: %@", saveError);
                }
            } else {
                [coreDataStack.managedObjectContext reset];
            }
        
        }];
    
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSPersistentStoreCoordinatorStoresDidChangeNotification object:coreDataStack.managedObjectContext.persistentStoreCoordinator queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [coreDataStack.managedObjectContext performBlock:^{
            [coreDataStack.managedObjectContext reset];
        }];
        
        NSLog(@"StoresDidChange");
        [self.tableView reloadData];
        NSLog(@"TableView has been reloaded");
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:coreDataStack.managedObjectContext.persistentStoreCoordinator queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [coreDataStack.managedObjectContext performBlock:^{
            [coreDataStack.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
        }];
    }];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSArray *) compiledData {
    
    NSArray* iCloudData = [self.fetchedResultsController fetchedObjects];
    NSArray* localData = [self.localDataFetchedResultsController fetchedObjects];
    
    _compiledData = [iCloudData arrayByAddingObjectsFromArray:localData];
    
    return _compiledData;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.compiledData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NoteEntry *noteEntry = [self.compiledData objectAtIndex:indexPath.row];
    
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

- (NSFetchedResultsController *) localDataFetchedResultsController {
    if (_localDataFetchedResultsController != nil) {
        return _localDataFetchedResultsController;
    }
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self entryListFetchRequest];
    
    _localDataFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.localDataManagedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    _localDataFetchedResultsController.delegate = self;
    
    return _localDataFetchedResultsController;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NoteEntry *note = [self.fetchedResultsController objectAtIndexPath: indexPath];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    [[coreDataStack managedObjectContext] deleteObject:note];
    [[coreDataStack localDataManagedObjectContext] deleteObject:note];
    
    [coreDataStack saveContext];
    [coreDataStack localDataSaveContext];
}

- (void) addWasPressed {
    NewEntryViewController *newEntry = [[NewEntryViewController alloc] init];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newEntry];
    [self presentViewController:navigationController animated:YES completion: nil];
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void) settingsWasPressed {
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewEntryViewController *newEntry = [[NewEntryViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newEntry];
    [self presentViewController:navigationController animated:YES completion: nil];
    
    newEntry.noteEntry = [self.compiledData objectAtIndex:indexPath.row];
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

- (void) didBecomeActive:(NSNotification *)notification {
    [self.localDataFetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}






















@end
