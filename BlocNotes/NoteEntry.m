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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM EE yy"];
    
    return [dateFormatter stringFromDate:self.date];
}

@end
