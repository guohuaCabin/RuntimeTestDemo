//
//  ViewController.m
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/10.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "TestClass.h"
#import "DynamicMethodTest.h"
#import "MessageForwardTest.h"
#import "NormalMessageForward.h"
#import "MessageForwardProcess.h"
#import "MessageForwardProcess2.h"
#import "DoesNotRecognizeSelector.h"
#import "SubTestClass.h"
#import "NSObject+DynamicAnalysis.h"
typedef NS_ENUM(NSInteger,Status) {
    Status_startPlay = 1,
    Status_playing,
    Status_playEnd,
    Status_error
};

typedef struct typeEncode {
    id   anObject;
    char *aString;
    int  anInt;
} TypeEncode;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,TestClassDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    self.dataSource = @[@"dynamicMethod: resolveInstanceMethod",@"dynamicMethod: resolveClassMethod",@"forwardingTargetForSelector: haveMethod",@"forwardingTargetForSelector: dynamicMethod",@"complete Message Forward",@"message Forward Process 1",@"message Forward Process 2",@"doesNotRecognizeSelector",@"type Encodings",@"class_copyPropertyList",@"class_copyProtocolList",@"protocol_copyPropertyList",@"timer_call_classMethod",@"rewriteInstanceMethod_classMethod",@"getProperties",@"getIvars",@"practice"];
    [self.tableView reloadData];
    
}

- (void)practice {
    TestClass *test = [[TestClass alloc]init];
    [test test];
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
- (void)forwardingTargetForSelector_haveMethod {
    MessageForwardTest *test = [[MessageForwardTest alloc]init];
    [test message];
}
//消息转发:找不到实例方法
- (void)forwardingTargetForSelector_dynamicMethod {
    MessageForwardTest *test = [[MessageForwardTest alloc]init];
    [test pushMessage];
}

- (void)completeMessageForward {
    NormalMessageForward *test = [[NormalMessageForward alloc]init];
//    [test message];
    [test pushMessage];
    
}

- (void)messageForwardProcess1 {
    MessageForwardProcess *test = [[MessageForwardProcess alloc]init];
    [test runMessage];
    [test pushMessage];
}
- (void)messageForwardProcess2 {
    MessageForwardProcess2 *test = [[MessageForwardProcess2 alloc]init];
    [test runMessage];
    [test pushMessage];
}

- (void)doesNotRecognizeSelector {
    DoesNotRecognizeSelector *test = [[DoesNotRecognizeSelector alloc]init];
    [test pushMessage];
}

//获取类中属性列表
- (void)class_copyPropertyList {
    id testClass = objc_getClass("TestClass");
    unsigned int outCount;
    //获取属性列表
    objc_property_t *propertys = class_copyPropertyList(testClass, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = propertys[i];
        //打印属性的名字
        NSLog(@"%s  \n",property_getAttributes(property));
    }
}

//获取该类做遵守的所有协议
- (void)class_copyProtocolList {
    unsigned int outCount;
    //获取协议列表
    Protocol * __unsafe_unretained  _Nonnull  *protocols = class_copyProtocolList([self class], &outCount);
    Protocol *delegate = objc_getProtocol("UITableViewDelegate");
    for (int i = 0; i < outCount; i++) {
        Protocol *protocol = protocols[i];
        //打印协议的名字
        NSLog(@">> %s  \n",protocol_getName(protocol));
    }
}
//获取某个协议遵守的所有的协议
- (void)protocol_copyPropertyList {
    unsigned int outCount;
    //获取协议列表
    Protocol *delegate = objc_getProtocol("UITableViewDelegate");
    Protocol * __unsafe_unretained  _Nonnull  *protocols = protocol_copyProtocolList(delegate, &outCount);
    for (int i = 0; i < outCount; i++) {
        Protocol *protocol = protocols[i];
        //打印协议的名字
        NSLog(@">> %s  \n",protocol_getName(protocol));
    }
}

//类型编码
- (void)typeEncodings {
    char  *buf1 = @encode(int);
    NSLog(@">> @encode(int)的类型编码： %s",buf1);
    
    char  *buf2 = @encode(int **);
    NSLog(@">> @encode(int **)的类型编码：%s",buf2);
    
    char  *buf3 = @encode(MessageForwardTest *);
    NSLog(@">> @encode(MessageForwardTest *)的类型编码：%s",buf3);
    
    char  *buf3_1 = @encode(MessageForwardTest);
    NSLog(@">> @encode(MessageForwardTest)的类型编码：%s",buf3_1);
    
    char  *buf4 = @encode(NSArray *);
    NSLog(@">> @encode(NSArray *)的类型编码：%s",buf4);
    
    char  *buf5 = @encode(NSDictionary *);
    NSLog(@">> @encode(NSDictionary *)的类型编码：%s",buf5);
    
    char  *buf6 = @encode(NSString *);
    NSLog(@">> @encode(NSString *)的类型编码：%s",buf6);
    
    
    char  *buf7 = @encode(long double);
    char  *buf8 = @encode(double);
    NSLog(@">> @encode(long double)的类型编码：%s ||  >> @encode(double)的类型编码：%s",buf7,buf8);
    
    char  *buf9 = @encode(Status);
    NSLog(@">> @encode(Status)的类型编码：%s",buf9);
    
    char  *buf10 = @encode(TypeEncode);
    NSLog(@">> @encode(TypeEncode)的类型编码：%s",buf10);
}

//计时器调用类方法
- (void)timer_call_classMethod {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    [timer setFireDate:[NSDate distantPast]];
}

- (void)timerMethod {
    [TestClass transfer];
}

- (void)getProperties {
    NSArray *list = [[TestClass alloc] getPropertiesWithClass:[TestClass class]];
    NSLog(@"动态获取属性 ：%@",list);
}

- (void)getIvars {
    NSArray *list = [[TestClass alloc] getIvarsWithClass:[TestClass class]];
    NSLog(@"动态获取变量 ：%@",list);
}

//重写是方法和类方法
- (void)rewriteInstanceMethod_classMethod {
    SubTestClass *subTest = [[SubTestClass alloc]init];
    [subTest instanceMethod];
    
    [SubTestClass classMethod];
}
#pragma mark - table delegate

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
    selStr = [self handleLastSelector:selStr];
    SEL sel = NSSelectorFromString(selStr);
    
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel withObject:nil];
    }
}

- (NSString *)handleLastSelector:(NSString *)selStr {
    if ([selStr containsString:@": "]) {
        selStr = [selStr stringByReplacingOccurrencesOfString:@": " withString:@"_"];
        return selStr;
    }
    if ([selStr containsString:@" "]) {
        selStr = [selStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        return selStr;
    }
    return selStr;
}

#pragma mark - init
- (void)setupViews {
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}

@end
