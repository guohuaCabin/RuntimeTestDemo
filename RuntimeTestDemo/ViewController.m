//
//  ViewController.m
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/10.
//

#import "ViewController.h"
#import "TestClass.h"
#import "DynamicMethodTest.h"
#import "MessageForwardTest.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    self.dataSource = @[@"dynamicMethod: resolveInstanceMethod",@"dynamicMethod: resolveClassMethod",@"messageForward: haveMethod",@"messageForward: dynamicMethod",];
    [self.tableView reloadData];
    
}

//动态方法解析:实例方法
- (void)dynamicMethod_resolveInstanceMethod {
    DynamicMethodTest *test = [[DynamicMethodTest alloc]init];
//    [test pushMessage];
    [test message];
}
//动态方法解析:类方法
- (void)dynamicMethod_resolveClassMethod {
    [DynamicMethodTest classMessage];
}


//消息转发:能找到实例方法
- (void)messageForward_haveMethod {
    MessageForwardTest *test = [[MessageForwardTest alloc]init];
    [test message];
}
//消息转发:找不到实例方法
- (void)messageForward_dynamicMethod {
    MessageForwardTest *test = [[MessageForwardTest alloc]init];
    [test pushMessage];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *selStr = self.dataSource[indexPath.row];
    if ([selStr containsString:@": "]) {
        selStr = [selStr stringByReplacingOccurrencesOfString:@": " withString:@"_"];
    }
    
    SEL sel = NSSelectorFromString(selStr);
    
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel withObject:nil];
    }
}
- (void)setupViews {
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}

@end
