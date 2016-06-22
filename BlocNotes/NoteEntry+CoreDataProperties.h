//
//  NoteEntry+CoreDataProperties.h
//  BlocNotes
//
//  Created by Joanna Lingenfelter on 6/19/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NoteEntry.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteEntry (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *body;
@property (nonatomic) NSTimeInterval date;
@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
