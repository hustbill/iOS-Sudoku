//
//  SudokuViewController.m
//  Sudoku
//
//  Created by Hua Zhang on 2/20/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "SudokuViewController.h"
#import "SudokuBoardView.h"
#import "ButtonView.h"
#import "SudokuBoard.h"

@interface SudokuViewController ()

- (NSString *)randomSimpleGame;
- (NSString *)randomHardGame;

@end

@implementation SudokuViewController
@synthesize boardView = _boardView;
@synthesize buttonView = _buttonView;
@synthesize boardModel = _boardModel;

-(NSString*)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:@"board.plist"];
}

-(void)saveState:(NSNotification*)notification {
    NSLog(@"SaveState:");
   // save your puzzle to the sandbox
    //notification = "puzzles was saved!";
    
    
    // [board setstate:boardArray];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveState:) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    
    if (self.boardModel != nil) {
        NSString *dataPath = [self dataFilePath];
        if([[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
            // XXXX decode board model
            NSArray *boardArray = [[NSArray alloc] initWithContentsOfFile:dataPath];//see the recowrdl
             [_boardModel setState:boardArray];
        }else {
            NSString *game = [self randomSimpleGame];
            //[board freshGame:game];
            
            [_boardModel freshGame:[self randomSimpleGame]];
        }
    }
    
    
    
    // Creating puzzles
    NSString *path = [[NSBundle mainBundle] pathForResource:@"simple" ofType:@"plist"];
    //load simple.plist into a simpleGames array
    _simpleGames = [[NSArray alloc] initWithContentsOfFile:path];
    
    //load hard.plist into a hardGames array
    path = [[NSBundle mainBundle] pathForResource:@"hard" ofType:@"plist"];
    _hardGames = [[NSArray alloc] initWithContentsOfFile:path];
    
    
    
    //init board model
    _pencilEnabled = NO;
    _boardModel = [[SudokuBoard alloc] init];
    // Make sure that the selceted cell is never a fixed  nuber cell when a new puzzle is generated:
    [_boardModel freshGame:[self randomSimpleGame]];
    
    // Create BoardView
    _boardView = [[SudokuBoardView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    _boardView.boardModel = _boardModel;
    [_boardView setBackgroundColor:[UIColor whiteColor]];
    
    [_boardView selectFirstAvailableCell];
    [self.view addSubview:_boardView];
    
    //init ButtonView
    _buttonView = [[ButtonView alloc]initWithFrame:CGRectMake(0, 320, 320, 140)];
    
    [self addButtons];
    [self.view addSubview:_buttonView];

}

// Add buttons to buttonView
-(void)addButtons {
    for (int i = 0; i < 12; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button.layer setBorderWidth:3.0];
        [button.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        if (i < 9) {
            
            NSString *title = [NSString stringWithFormat:@"%d", i+1];
            [button setTitle:title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(numberPressed:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 9) { // Pencil
            //[button setImage:[UIImage imageNamed:@"pencil.png"] forState:UIControlStateNormal];
            //[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:@"✎" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pencilPressed:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 10) { // Clear Cell
            //[button setImage:[UIImage imageNamed:@"cell_erase.png"] forState:UIControlStateNormal];
            //[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:@"☓" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clearCellPressed:) forControlEvents:UIControlEventTouchUpInside];
            
        } else { // Menu
            //[button setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
            [button setTitle:@"✇" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(menuPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        button.tag = i+1;
        [_buttonView addSubview:button];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)numberPressed:(UIButton *)sender{
 
    NSLog(@"numberPresse: %d", sender.tag);
    if (_pencilEnabled) {
        [_boardModel setPencil:sender.tag AtRow:[_boardView selectedRow] Column:[_boardView selectedCol]];
    } else {
        [_boardModel setNumber:sender.tag AtRow:[_boardView selectedRow] Column:[_boardView selectedCol]];        
    }
    [_boardView setNeedsDisplay];
    //[_boardModel setNumber:sender.tag atrow:[_boardView selectedRow] column:[_boardView selectedCol]];
    
}



-(IBAction)pencilPressed:(UIButton*)sender {
    _pencilEnabled = sender.selected = !_pencilEnabled;
    if (_pencilEnabled) {
        [sender setBackgroundColor:[UIColor grayColor]];
    } else {
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
    sender.highlighted = NO; // seems to reduce "flicker"
    [_buttonView setNeedsDisplay];

}

-(IBAction)clearCellPressed:(UIButton *)sender{
    NSLog(@"clearCellPressed:");
    const int row = [_boardView selectedRow];
    const int col = [_boardView selectedCol];
    
    if ([_boardModel numberOfPencilsSetAtRow:row Column:col] > 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleting all penciled in numbers"
                                                        message:@"Are you sure?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Yes", nil];
        [alert setTag:1];
        [alert show];
    } else {
        [_boardModel clearNumberAtRow:row Column:col];
    }
    [_boardView setNeedsDisplay];
    
}

-(IBAction) menuPressed:(UIButton *)sender{
    NSLog(@"menuPressed:");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Main Menu"
                                            delegate:self cancelButtonTitle:@"cancel"
                                            destructiveButtonTitle:nil
                                            otherButtonTitles:@"New Easy Game",
                                                            @"New Hard Game",
                                                            @"Clear Conflicting Cells",
                                                            @"Clear All Cells", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        NSLog(@"Cancel Button");
    } else {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"New Easy Game"]) {
            NSLog(@"New Easy Game Button");
            [_boardModel freshGame:[self randomSimpleGame]];
            [_boardView selectFirstAvailableCell];
            [_boardView setNeedsDisplay];
        } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"New Hard Game"]) {
            NSLog(@"New Hard Game Button");
            [_boardModel freshGame:[self randomHardGame]];
            [_boardView selectFirstAvailableCell];
            [_boardView setNeedsDisplay];
        } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Clear Conflicting Cells"]) {
            NSLog(@"Clear Conflicting Cells");
            //[_boardModel clearAllConflictingCells];
            //Clear all conflicting cells
            
            [_boardView setNeedsDisplay];
        } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Clear All Cells"]) {
            NSLog(@"Clear All Cells");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                            message:@"Are you sure you want to clear all of the cells?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
            [alert setTag:0];
            [alert show];
        }
    }
    
}

- (NSString *)randomSimpleGame {
    const int n = [_simpleGames count];
    const int i = arc4random() % n;
    return [_simpleGames objectAtIndex:i];
}

- (NSString *)randomHardGame {
    const int n = [_hardGames count];
    const int i = arc4random() % n;
    return [_hardGames objectAtIndex:i];
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet tag] == 0) {
        NSLog(@"actionSheet tag == 0");
        if (buttonIndex != [actionSheet cancelButtonIndex]) { // Yes
            //clear all editable cells
            //[_boardModel clearAllEditableCells ];
            [_boardView setNeedsDisplay];
        }
    } else {
        NSLog(@"actionSheet tag != 0 buttonIndex != cancelButtonIndex:%d", buttonIndex != [actionSheet cancelButtonIndex]);
        if (buttonIndex != [actionSheet cancelButtonIndex]) { // Yes
              //clear all penciles at row and coloumn
            // [_boardModel clearAllPencilsAtRow:[_boardView selectedRow] Column:[_boardView selectedCol]];
            [_boardView setNeedsDisplay];
        }
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


//Provide from Dr.Cochran's HW2 introduction
- (void)viewWillLayoutSubviews {
    NSLog(@"viewVillLayoutSubview");
    const CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    const CGRect viewBounds = self.view.bounds;
    const bool isPortrait = viewBounds.size.height >= viewBounds.size.width;
    if (isPortrait) {
        const CGFloat statusBarHeight = statusBarFrame.size.height;
        const float boardSize = viewBounds.size.width;
        const float buttonsHeight = viewBounds.size.height - boardSize - statusBarHeight;
        _boardView.frame = CGRectMake(0, statusBarHeight, boardSize, boardSize);
        _buttonView.frame = CGRectMake(0, boardSize + statusBarHeight, boardSize, buttonsHeight);
    } else { // landscape
        const CGFloat statusBarHeight = statusBarFrame.size.width;
        const float boardSize = viewBounds.size.height - statusBarHeight;
        const float buttonsWidth = viewBounds.size.width - boardSize;
        _boardView.frame = CGRectMake(0, statusBarHeight, boardSize, boardSize);
        _buttonView.frame = CGRectMake(boardSize, statusBarHeight, buttonsWidth, boardSize);
    }
}




@end
