//
//  ViewController.h
//  Free_I_See
//
//  Created by shen ning on 2021/10/21.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController<NSTableViewDelegate,NSTableViewDataSource>

@property (weak) IBOutlet NSSplitView *spliteView;

@property (weak) IBOutlet NSTableView *filesTableView;
@property (weak) IBOutlet NSImageView *imageView;

@property (weak) IBOutlet NSButton *AddFolderButton;

@property (nonatomic,strong) NSMutableArray *selectedFiles;
@property NSURL *selectedImageURL;

@property NSUInteger selectionChangeTime;

- (IBAction)addFolderPath:(id)sender;
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;

//


// Public function
//  MARK: 与文件系统交互的一些方法
-(void)openSelectionInPreview:(id)sender;
-(void)openSelectionInFinder:(id)sender;
-(void)clearSelection:(id)sender;
// MARK: 关于tableview item的一些方法
-(void)selectPrevious:(id)sender;
-(void)selectNext:(id)sender;
-(void)deleteItemAndModifySelection:(id)sender;
-(void)trashItemAndModifySectection:(id)sender;
// MARK: 关于image 的一些方法
-(void)zoomInSelectedItem:(id)sender;
-(void)zoomOutSelectedItem:(id)sender;
-(void)fullSizeSelectedItem:(id)sender;
-(void)pixelToPixelSelectedItem:(id)sender;
-(void)rotateLeft:(id)sender;
-(void)rotateRight:(id)sender;
-(void)resetModify:(id)sender;
// MARK: 关于UI 的一些方法
-(void) changeSplitViewStyle:(id)sender;
-(void) changeTableViewStyle:(id)sender;
// MARK: 其他的一些方法
//-(void) skip
@end

