//
//  SudokuBoard.m
//  Sudoku
//
//  Created by Hua Zhang on 2/20/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "SudokuBoard.h"

@implementation SudokuBoard

typedef struct {
    int number;
    bool isFixed;
    short pencilMark;
    short pencil_Marks[9]; //for 3*3 small grids
}Cell;

Cell sudoBoard[9][9];  //init the sudoku board

@synthesize board = _board;

// Create empty board.
-(id)init {
    self = [super init];
    if (self) {
        for (int r = 0; r < 9; r++) {
            for (int c = 0; c < 9; c++) {
                sudoBoard[r][c].number = 0;
                sudoBoard[r][c].isFixed = NO;
                sudoBoard[r][c].pencilMark = 0;
            }
        }
    }
    return self;
}

//Provided by Dr. Cochran instruction in the lecture March , 2014
-(NSArray*)savedState{
    NSMutableArray *boardArray = [[NSMutableArray alloc ] init ];
    for(int row =0; row < 9; row++) {
        for (int col=0; col<9; col++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            //convert the values into object
            [dict setObject:[NSNumber numberWithInt:sudoBoard[row][col].number] forKey:@"number"];
            [dict setObject:[NSNumber numberWithBool:sudoBoard[row][col].isFixed] forKey:@"isFixed"];
            [dict setObject:[NSNumber numberWithShort:sudoBoard[row][col].pencilMark] forKey:@"pencilMark"];
            [boardArray addObject:dict];
        }
    }
    return boardArray;
}

-(void) setState:(NSArray *)boardArray {
    int n =0;
    for(int row =0; row < 9; row++) {
        for(int col = 0; col< 9; col++) {
            NSMutableDictionary *dict = [boardArray objectAtIndex:n++];
            //set row and col
            sudoBoard[row][col].number = [[dict objectForKey:@"number"] intValue];
            sudoBoard[row][col].isFixed = [[dict objectForKey:@"isFixed"] boolValue];
            sudoBoard[row][col].pencilMark = [[dict objectForKey:@"pencilMark"] shortValue];
        }
    }
}


//Load new game encoded with given string (see Section 4.1).
-(void) freshGame:(NSString *)boardString {
    //NSLog(boardString);
    for (int r=0; r< 9; r++) {
        for (int c=0; c < 9; c++) {
            sudoBoard[r][c].isFixed =NO;
            sudoBoard[r][c].pencilMark = 0;
            sudoBoard[r][c].number = 0;
        }
    }
    //get the number from boardString - simpleGame or hardGame string
    for (int i=0, r=0; r< 9; r++) {
        for (int c=0; c < 9; c++) {
            int num = [boardString characterAtIndex:i];
                if ('0' <= num && num <= '9') {
                    sudoBoard[r][c].isFixed =YES;
                    sudoBoard[r][c].pencilMark = 0;
                    sudoBoard[r][c].number = num -'0';
                }
          i++;
        }
    }
}

// Fetch the number stored in the cell at the specified row and column;
// zero indicates an empty cell or the cell holds penciled in values.
-(int)numberAtRow:(int)r Column:(int)c {
    int number = sudoBoard[r][c].number;
    return number;
}

//Set the number at the specified cell;
//assumes cell does not contain a fixed number,
-(void)setNumber:(int)n AtRow:(int)r Column:(int)c{
   if (sudoBoard[r][c].isFixed == NO) {
       sudoBoard[r][c].number = n;
   }
   
}

// Determines if cell contains a fixed number.
-(BOOL)numberIsFixedAtRow:(int)r Column:(int)c {
     //NSLog(@"row=%d, col=%d", r, c);
    return sudoBoard[r][c].isFixed ;
}

//Doesthenumberconflictwithanyothernumber in the same row, column, or 3 × 3 square?
-(BOOL)isConflictingEntryAtRow:(int)r Column:(int)c{
    //check the row confilicts
    for (int row = 0; row < 9; row++) {
        if (sudoBoard[row][c].number == sudoBoard[r][c].number && row != r)
            return YES;
    }
    //check the colomun confilicts
    for (int col = 0; col < 9; col++) {
        if (sudoBoard[r][col].number == sudoBoard[r][c].number && col != c)
            return YES;
        
    }
    for (int row = r/3*3; row < r/3*3+3; row++) {
        for (int col = c/3*3; col < c/3*3+3; col++) {
            if (sudoBoard[row][col].number == sudoBoard[r][c].number && row != r)
                return YES;
        }
    }
    return NO;
}


//Are the any penciled in values at the given cell(assumes number = 10)?
-(BOOL)anyPencilsSetAtRow:(int)r Column:(int)c{
  if (sudoBoard[r][c].number == 10)
    return YES;
   else return NO;
 
}

//Number of penciled in values at cell.
-(int)numberOfPencilsSetAtRow:(int)r Column:(int)c {
    if (sudoBoard[r][c].pencilMark == 1) {
       return sudoBoard[r][c].number -'0';
    }
    else {
        return 0;
    }
}

//clearNumberAtRow
-(void)clearNumberAtRow:(int)r Column:(int) c{
    sudoBoard[r][c].number =0;
}

//Is the value n penciled in?
-(BOOL)isSetPencil:(int)n AtRow:(int)r Column:(int)c{
    
    return sudoBoard[r][c].pencil_Marks[n];
}

//Pencil the value n in.
-(void)setPencil:(int)n AtRow:(int)r Column:(int)c{
    if (sudoBoard[r][c].isFixed == NO) {
        sudoBoard[r][c].number = 10;
        if (sudoBoard[r][c].pencilMark == NO &&
                sudoBoard[r][c].pencil_Marks[n] == 0){
            sudoBoard[r][c].pencilMark = YES;
            sudoBoard[r][c].pencil_Marks[n] = 1;
        } else {
            sudoBoard[r][c].pencilMark = NO;
             sudoBoard[r][c].pencil_Marks[n] = 0;
        }
    }
}

//Clear pencil value n.
-(void)clearPencil:(int)n AtRow:(int)r Column:(int)c{
 
        sudoBoard[r][c].pencilMark = NO;
     sudoBoard[r][c].pencil_Marks[n] = 0;
}

//Clear all penciled in values.
-(void)clearAllPencilsAtRow:(int)r Column:(int)c{
     sudoBoard[r][c].pencilMark = 0;
    for (int n = 0; n < 9; n++) {
        sudoBoard[r][c].pencil_Marks[n] =0;
    }
}

@end