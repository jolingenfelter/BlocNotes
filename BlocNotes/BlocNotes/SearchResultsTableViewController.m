//
//  SearchResultsTableViewController.m
//  BlocNotes
//
//  Created by Joanna Lingenfelter on 7/7/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "NoteEntry.h"
#import "NewEntryViewController.h"

@implementation SearchResultsTableViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.filteredList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath: indexPath];
    
    NoteEntry *searchedNote = [self.filteredList objectAtIndex:indexPath.row];
    cell.textLabel.text = searchedNote.title;
    cell.textLabel.font= [UIFont boldSystemFontOfSize:16];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewEntryViewController *entry = [[NewEntryViewController alloc] init];
    entry.noteEntry = [self.filteredList objectAtIndex:indexPath.row];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:entry];
    [self presentViewController:navigationController animated:YES completion: nil];

}

@end
