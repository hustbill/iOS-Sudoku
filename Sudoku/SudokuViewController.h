//
//  SudokuViewController.h
//  Sudoku
//
//  Created by Hua Zhang on 2/20/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SudokuBoardView.h"
#import "ButtonView.h"
#import "SudokuBoard.h"

@interface SudokuViewController : UIViewController

@property (strong, nonatomic) SudokuBoardView  *boardView;
@property (strong, nonatomic) ButtonView *buttonView;

@property (strong, nonatomic) SudokuBoard *boardModel;

@property (strong, nonatomic) NSUndoManager *undoManager;


@property BOOL pencilEnabled;

@property (strong, nonatomic) NSArray *simpleGames;
@property (strong, nonatomic) NSArray *hardGames;

-(IBAction)numberPressed:(UIButton *)sender;

-(IBAction)pencilPressed:(UIButton *)sender;

-(IBAction)clearCellPressed:(UIButton *)sender;

-(IBAction) menuPressed:(UIButton *)sender;

@end
