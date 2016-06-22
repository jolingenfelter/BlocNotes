//
//  NoteEntry.m
//  BlocNotes
//
//  Created by Joanna Lingenfelter on 6/19/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

#import "NoteEntry.h"

@implementation NoteEntry

- (NSString *) sectionName {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM EE yy"];
    
    return [dateFormatter stringFromDate:date];
}

@end
