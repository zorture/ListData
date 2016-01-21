//
//  ListViewController.m
//  ListData
//
//  Created by Kanwar Zorawar Singh Rana on 1/18/16.
//  Copyright © 2016 Kanwar Zorawar Singh Rana. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "ListBizAdapter.h"

@interface ListViewController ()

@property(nonatomic, assign)BOOL shouldExpand;
@property(nonatomic, weak) NSIndexPath* expandedIndexPath;
@property(nonatomic, strong) ListBizAdapter* mListBA;
@property(nonatomic, strong) NSArray* mlistData;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldExpand = false;
    self.mListBA = [[ListBizAdapter alloc] init];
    
    [self initiateDataRequest];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
}

- (void)initiateDataRequest{
    
    [self.mListBA fetchData:^(NSArray *data) {
        self.mlistData = data;
        [self.tableView reloadData];
    }];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.mlistData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    [cell updateCellWithData:self.mlistData[indexPath.row] BizAdapter:self.mListBA];
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.shouldExpand = true;
    self.expandedIndexPath = indexPath;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.expandedIndexPath == indexPath?180:80;
}

@end
