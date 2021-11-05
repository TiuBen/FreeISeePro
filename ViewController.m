//
//  ViewController.m
//  Free_I_See
//
//  Created by shen ning on 2021/10/21.
//

#import "ViewController.h"

@implementation ViewController

@synthesize filesTableView ;
@synthesize selectedFiles;
@synthesize imageView;
@synthesize selectedImageURL;

@synthesize selectionChangeTime;
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.filesTableView.delegate=self;
    self.filesTableView.dataSource=self;
 
    // default 初始化
    NSURL *defaultImageURL=[[NSURL alloc] initWithString:@"file:///Users/shenning/Downloads/5.jpg"];
    selectedImageURL=[[NSURL alloc] initWithString:@""];
    selectedImageURL=defaultImageURL;
    
    
    selectedFiles=[[NSMutableArray alloc] init];
    [selectedFiles addObject:defaultImageURL];
    NSLog(@"selectedFiles :%@",selectedFiles);
    [filesTableView reloadData];
    // 默认选中第一个
    selectionChangeTime=0;
    NSIndexSet *defaultFirst=[[NSIndexSet alloc] initWithIndex:0];
    [filesTableView.animator selectRowIndexes:defaultFirst byExtendingSelection:NO];
}


-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView  {
    NSLog(@"row count:%i",selectedFiles.count);
    return  selectedFiles.count;
}



-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString *columnIdentifier = [tableColumn identifier];
    NSLog(@"columnIdentifier %@",columnIdentifier);
       if ([columnIdentifier isEqualToString:@"fileName"]) {
           NSTableCellView *result = [tableView makeViewWithIdentifier:@"fileNameCell" owner:self];
           if (self.selectedFiles.count != 0 ) {
               result.textField.stringValue=[[selectedFiles objectAtIndex:row ] absoluteString];
           } else {
               result.textField.stringValue=@"foo";
           }
//           result.textField.stringValue=@"foo";
           return result;
       }  else {
           NSTableCellView *result = [tableView makeViewWithIdentifier:@"createDateCell" owner:self];
           result.textField.stringValue=@"bar";
           return result;
       }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    selectedImageURL=[selectedFiles objectAtIndex:filesTableView.selectedRow ];
    NSLog(@"\ntableViewSelectionDidChange %i\
            \nselected row index:%i\
            \nselectedImageURL: %@",selectionChangeTime,[self.filesTableView selectedRow],selectedImageURL.absoluteString);
    // FIXME: 直接使用URL有问题
    NSImage *image1=[[NSImage alloc] initByReferencingURL:selectedImageURL];
    [image1 setResizingMode:NSImageResizingModeStretch];
    [self.imageView setImage: image1];

    selectionChangeTime++;
    
}


//  MARK:完成一些PUBLIC的方法 当作外界可以使用的接口

-(void)selectPrevious:(id)sender{
    
    NSLog(@"selectUp\nsender: %@",sender);
    //当已经选中的文件数量不为0时,Button才为可用
    if (selectedFiles.count>=1) {
        if(filesTableView.selectedRow>0){
            NSUInteger upItem=(filesTableView.selectedRow-1)>0?(filesTableView.selectedRow-1):0;
            [filesTableView.animator selectRow:upItem byExtendingSelection:NO];
        }
    }else{
        //这时候可能没有添加图片 或者 图片 数量只有1个
        //Button 应该为不可用的状态
        [(NSButton *)sender setState:NSControlStateValueOff];
    }
}
-(void)selectNext:(id)sender{
    //当已经选中的文件数量不为0时,Button才为可用
    if (selectedFiles.count>=1) {
        if(filesTableView.selectedRow!=(selectedFiles.count-1)){
            NSUInteger downItem=filesTableView.selectedRow+1;
            [filesTableView.animator selectRow:downItem byExtendingSelection:NO];
        }
    }else{
        //这时候可能没有添加图片 或者 图片 数量只有1个
        //Button 应该为不可用的状态
    }
}



-(void)openSelectionInPreview:(id)sender{
    NSLog(@"openSelectionInPreview");
    [[NSWorkspace sharedWorkspace] openURL: (NSURL *)[selectedFiles objectAtIndex:filesTableView.selectedRow] ];
}
-(void)openSelectionInFinder:(id)sender{
    NSLog(@"openSelectionInFinder");
    [[NSWorkspace sharedWorkspace] selectFile:[(NSURL *)[selectedFiles objectAtIndex:filesTableView.selectedRow] path]
                     inFileViewerRootedAtPath:nil];
}
-(void)clearSelection:(id)sender{
    [selectedFiles removeAllObjects];
    [selectedImageURL removeAllCachedResourceValues];
    [filesTableView reloadData];
    [imageView setImage:NULL];
}
-(void)changeSplitViewStyle:(id)sender{
    NSInteger _tag=[(NSButton *)sender tag];
    if (_tag==12) {
        [_spliteView setVertical:YES];
    } else {
        [_spliteView setVertical:NO];
    }
   
    
}



//- (IBAction)addFolderPath:(id)sender {
//
//    NSOpenPanel* panel = [NSOpenPanel openPanel];
//    [panel setCanChooseFiles:true];
//    [panel setCanChooseDirectories:true];
//    [panel setAllowsMultipleSelection:true];
//
//    [panel beginWithCompletionHandler:^(NSInteger result){
//
//        if (result == NSModalResponseOK) {
//            [self.selectedFiles removeAllObjects];
//            [self.selectedFiles addObjectsFromArray:panel.URLs];
//            NSLog(@"added fils count:%i",(int)self.selectedFiles.count);
//            [self.FilesTableView reloadData];
//       }
//    }];
//}
@end
