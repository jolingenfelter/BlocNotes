//
//  NoteEntry+CoreDataProperties.m
//  BlocNotes
//
//  Created by Joanna Lingenfelter on 6/19/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NoteEntry+CoreDataProperties.h"

@implementation NoteEntry (CoreDataProperties)

@dynamic body;
@dynamic date;

- (NSString *) sectionName {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM EE yy"];
    
    return [dateFormatter stringFromDate:date];
}

@end
