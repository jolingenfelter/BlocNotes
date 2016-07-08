//
//  SearchResultsTableViewController.m
//  BlocNotes
//
//  Created by Joanna Lingenfelter on 7/7/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "NoteEntry.h"

@implementation SearchResultsTableViewController

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.filteredList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath: indexPath];
    
    NoteEntry *searchedNote = [self.filteredList objectAtIndex:indexPath.row];
    cell.textLabel.text = searchedNote.title;
    
    
    return cell;
}

@end
