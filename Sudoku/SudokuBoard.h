//
//  SudokuBoard.h
//  Sudoku
//
//  Created by Hua Zhang on 2/20/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SudokuBoard : NSObject

@property (strong, nonatomic) NSMutableArray *board;
@property (strong, nonatomic) NSMutableArray *pencil_marks;

// Create empty board.
-(id)init;

//store the state to plist
-(void) setState:(NSArray *)boardArray;

//Load new game encoded with given string (see Section 4.1).
-(void)freshGame:(NSString*)boardString;

// Fetch the number stored in the cell at the specified row and column;
// zero indicates an empty cell or the cell holds penciled in values.
-(int)numberAtRow:(int)r Column:(int)c;

//clearNumberAtRow
-(void)clearNumberAtRow:(int)r Column:(int) c;

//Set the number at the specified cell;
//assumes cell does not contain a fixed number,
-(void)setNumber:(int)n AtRow:(int)r Column:(int)c;

// Determines if cell contains a fixed number.
-(BOOL)numberIsFixedAtRow:(int)r Column:(int)c;

//Doesthenumberconflictwithanyothernumber in the same row, column, or 3 × 3 square?
-(BOOL)isConflictingEntryAtRow:(int)r Column:(int)c;


//Are the any penciled in values at the given cell(assumes number = 0)?
-(BOOL)anyPencilsSetAtRow:(int)r Column:(int)c;

//Number of penciled in values at cell.
-(int)numberOfPencilsSetAtRow:(int)r Column:(int)c;

//Is the value n penciled in?
-(BOOL)isSetPencil:(int)n AtRow:(int)r Column:(int)c;

//Pencil the value n in.
-(void)setPencil:(int)n AtRow:(int)r Column:(int)c;

//Clear pencil value n.
-(void)clearPencil:(int)n AtRow:(int)r Column:(int)c;

//Clear all penciled in values.
-(void)clearAllPencilsAtRow:(int)r Column:(int)c;

@end
