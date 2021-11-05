//
//  MainWindowController.m
//  Free_I_See
//
//  Created by shen ning on 2021/10/28.
//

#import "MainWindowController.h"
#import "ViewController.h"
#import "CollectionListViewContoller.h"

#define  IS_PROJECT_DEVELOPING true


@interface MainWindowController ()


@end

@implementation MainWindowController
@synthesize skipSubfiles;
@synthesize selectedFiles;
@synthesize allowedFileTypes;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    selectedFiles=[[NSMutableArray alloc] init];
    allowedFileTypes=[[NSArray alloc] initWithObjects:@"jpg",@"gif",@"png", nil];
    skipSubfiles=false;
}

-(void)switchViewController:(id)sender{
    NSInteger tag=[(NSButton *)sender tag];
    if (tag==9) {
        NSLog(@"点击的按钮为列表模式 什么都不需要做");
        if (   [self.window.contentViewController isKindOfClass:[ViewController   class ]]) {
            NSLog(@"Viewcontroller");
         
        }
        else {
            NSLog(@"Change VC to list VC");
            
            
            
        }
        
        
    }
    if (tag==10) {
        NSLog(@"点击的按钮为缩略图 什么都不需要做");
        if (   [self.window.contentViewController isKindOfClass:[CollectionListViewContoller   class ]]) {
            NSLog(@"CollectionListViewContoller");
         
        }
        else {
            NSLog(@"Change VC to Collection VC");
            
            CollectionListViewContoller *collectionListVC=[[CollectionListViewContoller alloc] initWithNibName:@"CollectionListViewContoller" bundle:[NSBundle mainBundle]];
            NSRect _size= self.window.contentView.frame;
            collectionListVC.view.frame=_size;
            self.window.contentViewController=collectionListVC;
            
            
        }
    }
    
   
 
    
    
}








- (IBAction)toolbarItemClicked:(id)sender {
    NSToolbarItem *toolbarItem= sender;
    NSInteger tag=toolbarItem.tag;
    NSLog(@"clicked toolbarItem tag:%li",tag);
    ViewController *mainVC=(ViewController *)self.contentViewController;
    
    if (tag==0) { //添加新的文件 或者 文件夹 到tableview datasouce
        NSOpenPanel* panel = [NSOpenPanel openPanel];
        [panel setCanChooseFiles:true];
        [panel setAllowedFileTypes:allowedFileTypes];
        [panel setCanChooseDirectories:true];
        [panel setAllowsMultipleSelection:true];
      
        [panel beginWithCompletionHandler:^(NSInteger result){
            if (result == NSModalResponseOK) {
                for (NSURL *_url in panel.URLs) {
                    NSLog(@"output selected files/dir:%@",_url.absoluteString);
                    if ([[_url.absoluteString pathExtension] isEqualToString:@""]) {
                        NSLog(@"Is directory");
                        if (self.skipSubfiles) {
                            //
                        }else{
                            NSLog(@"%@",@"不跳过子目录 则添加一层深度的子目录内的文件");
                            NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:_url
                                                                          includingPropertiesForKeys:NULL
                                                                                             options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                                               error:NULL ];
                            for (NSURL *subURL in dirs) {
                                NSString *_subURLPath=subURL.absoluteString;
                                NSString *extension=[[_subURLPath pathExtension] lowercaseString];
                                if ([self.allowedFileTypes containsObject:extension]) {
                                    [self.selectedFiles addObject:subURL];
                                }
                            }
                        }
                    }else{
                        [self.selectedFiles addObject:_url];
                    }
                }
                NSLog(@"added fils count:%i",(int)self.selectedFiles.count);
//                ViewController *mainVC=(ViewController *)self.contentViewController;
                mainVC.selectedFiles=self.selectedFiles;
                [mainVC.filesTableView reloadData];
           }
       
            
            
        }];
    }
    else if (tag==1){// 从这次选中中移除 remove this selected file from this time added folders
        NSLog(@"%@",@"从这次选中中移除 remove this selected file from this time added folders");
        NSLog(@"即将要移除的file Path:%@",mainVC.selectedImageURL);
        NSInteger lastSelectedRow=[mainVC.filesTableView selectedRow];
        [selectedFiles removeObject:mainVC.selectedImageURL];
        [mainVC.filesTableView reloadData];
        NSIndexSet *lastSelectedRowIndex;
    
        if (lastSelectedRow<selectedFiles.count) {
            lastSelectedRowIndex=[[NSIndexSet alloc] initWithIndex:lastSelectedRow];
        }else{
            lastSelectedRowIndex=[[NSIndexSet alloc] initWithIndex:(selectedFiles.count -1)>=0?(selectedFiles.count -1):0];
        }
        [mainVC.filesTableView.animator selectRowIndexes:lastSelectedRowIndex byExtendingSelection:NO];
        // TODO
        //
        
    }
    else if (tag==2){//扔到垃圾回收站 delete this selected file add remove it to trash
        NSLog(@"%@",@"扔到垃圾回收站 delete this selected file add remove it to trash");
        //
        [[NSFileManager defaultManager] trashItemAtURL: mainVC.selectedImageURL resultingItemURL:NULL error:NULL];
        // TODO: 删除以后选中的图片需要自动下一项目
        //
    }
    else if (tag==3){//选中上一个 move up
        NSLog(@"%@",@"选中上一个 move up");
        //
        [mainVC selectPrevious:sender];
    }
    else if (tag==4){// 选中下一个 move down
        NSLog(@"%@",@"选中下一个 move down");
        [mainVC selectNext:sender];
    }
    else if (tag==5){//在Preview预览 App 中打开 open and show this file in Preview App
        NSLog(@"%@",@"在Preview预览 App 中打开 open and show this file in Preview App");
        [mainVC openSelectionInPreview:sender];
    }
    else if (tag==6){//在Finder中打开 open and selected this file in Finder App
        NSLog(@"%@",@"在Finder中打开 open and selected this file in Finder App");
        [mainVC openSelectionInFinder:sender];
    }
    else if (tag==7){//清空选®文件 clear, clear the tableview list
        NSLog(@"%@",@"清空选中的文件 clear, clear the tableview list");
        [mainVC clearSelection:sender];
    }
    else if (tag==8){// skip subufolders
        NSButton *toggleButton=sender;
        NSLog(@"%@",@"skip subufolders");
        NSLog(@"skip subufolders state:%i",toggleButton.state );
            if(toggleButton.state==NSControlStateValueOn){
                skipSubfiles=true;
            }else{
                skipSubfiles=false;
            }
        NSLog(@"skip subufolders state ???:%i",skipSubfiles );
    }
    else if (tag==9){//   file name list列表模式
        NSLog(@"%@",@"文件名列表模式  file name list");
        [self switchViewController:sender];
    }
    else if (tag==10){//缩略图列表模式   thumbnail list
        NSLog(@"%@",@"缩略图列表模式   thumbnail list");
        [self switchViewController:sender];
    }
    else if (tag==11){//  full size
        NSLog(@"%@",@"full size");
    }
    else if (tag==12){// two Column
        NSLog(@"%@",@"two Column");
        [mainVC changeSplitViewStyle:sender];
    }
    else if (tag==13){// two row
        NSLog(@"%@",@"two row");
        [mainVC changeSplitViewStyle:sender];
    }
    else if (tag==14){// zoom in 放大
        NSLog(@"%@",@"zoom in 放大");
    }
    else if (tag==15){// zoom out 缩小
        NSLog(@"%@",@"zoom out 缩小");
    }
    else if (tag==16){// fit window 适应窗体大小
        NSLog(@"%@",@"fit window 适应窗体大小");
    }
    else if (tag==17){// origin size 原始大小
        NSLog(@"%@",@"origin size 原始大小");
    }
    else if (tag==18){// previous 上一个
        NSLog(@"%@",@"previous 上一个");
    }
    else if (tag==19){// next 下一个
        NSLog(@"%@",@"next 下一个");
    }
    else if (tag==20){// rotate left 90 degrees 向左旋转90度
        NSLog(@"%@",@"rotate left 90 degrees 向左旋转90度");
    }
    else if (tag==21){//rotate right 90 degrees 向左旋转90度
        NSLog(@"%@",@"rotate right 90 degrees 向左旋转90度");
    }
    else if (tag==22){// reset 重置就像没有旋转过
        NSLog(@"%@",@"reset 重置就像没有旋转过");
    }
    else if (tag==23){// search 搜索
        NSLog(@"%@",@"search 搜索");
    }
    
}
@end
