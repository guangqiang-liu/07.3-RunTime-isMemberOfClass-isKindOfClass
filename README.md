# 07.3-Runtime中isMemberOfClass isKindOfClass的本质区别

我们新建一个工程，创建一个`Person`类，示例代码如下：

`Person`类

```
@interface Person : NSObject

@end


@implementation Person

@end
```

`main`函数

```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        Person *person = [[Person alloc] init];
        
        NSLog(@"%d", [person isMemberOfClass:[Person class]]); // 1
        NSLog(@"%d", [person isMemberOfClass:[NSObject class]]); // 0
        
        NSLog(@"%d", [person isKindOfClass:[Person class]]); // 1
        NSLog(@"%d", [person isKindOfClass:[NSObject class]]); // 1
    }
    return 0;
}
```

我们从`main`函数中的四个语句的打印，然后结合下面底层源码，我们可以看出结论：

* -isMemberOfClass：判断左边的类对象是否等于右边的类对象
* -isKindOfClass：判断左边的类对象是否等于右边的类对象，或者左边的类对象是右边的类对象的子类

上面的示例都是验证实例对象的用法，下面我们在验证下类对象的用法，示例代码如下：

```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        Person *person = [[Person alloc] init];
                
        NSLog(@"%d", [Person isMemberOfClass:[Person class]]); // 0
        NSLog(@"%d", [Person isKindOfClass:[Person class]]); // 0
        
        NSLog(@"%d", [Person isMemberOfClass:object_getClass([Person class])]); // 1
        
        NSLog(@"%d", [Person isKindOfClass:object_getClass([Person class])]); // 1
        
        NSLog(@"%d", [Person isKindOfClass:object_getClass([NSObject class])]); // 1
        
        // 这个比较特殊
        NSLog(@"%d", [[Person class] isKindOfClass:[NSObject class]]); // 1
    }
    return 0;
}
```

我们通过上面`main`函数中的打印结果和下面源码分析可以得出结论：

* +isMemberOfClass：就是判断左边的元类对象是否等于右边的元类对象
* +isKindOfClass：就是判断左边的元类对象是否等于右边的元类对象，或者左边的元类对象是右边的元类对象的子类

但是对于示例`NSLog(@"%d", [[Person class] isKindOfClass:[NSObject class]]); // 1`比较特殊，因为我们上面总结的`+isKindOfClass`右边都应该是元类对象进行比较，但是此示例中右边却是类对象，为什么打印还是1？

这是因为`+isKindOfClass`方法是遍历进行比较，当执行`object_getClass([Person class])`拿到的元类对象不等于右边时，就会通过`superclass`指针一层层往上找，直到找到基类的元类对象时左右两边还是不相等，此时则会从基类的元类对象找到基类的类对象，如下图红框所示，这时正好左边的类对象等于右边的类对象，所以打印结果为1

isa，superclass指针查找逻辑如图：

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200208-171103@2x.png)


**`isMemberOfClass`和`isKindOfClass`底层源码查看路径：`objc4源码 -> NSObject.mm -> isMemberOfClass -> isKindOfClass`**

`isMemberOfClass`实例方法

```
- (BOOL)isMemberOfClass:(Class)cls {
    return [self class] == cls;
}
```

`isMemberOfClass`类方法

```
+ (BOOL)isMemberOfClass:(Class)cls {
    return object_getClass((id)self) == cls;
}
```

`isKindOfClass`实例方法

```
- (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = [self class]; tcls; tcls = tcls->superclass) {
        if (tcls == cls) return YES;
    }
    return NO;
}
```

`isKindOfClass`类方法

```
+ (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->superclass) {
        if (tcls == cls) return YES;
    }
    return NO;
}
```


讲解示例Demo地址：[https://github.com/guangqiang-liu/07.3-RunTime-isMemberOfClass-isKindOfClass]()


## 更多文章
* ReactNative开源项目OneM(1200+star)：**[https://github.com/guangqiang-liu/OneM](https://github.com/guangqiang-liu/OneM)**：欢迎小伙伴们 **star**
* iOS组件化开发实战项目(500+star)：**[https://github.com/guangqiang-liu/iOS-Component-Pro]()**：欢迎小伙伴们 **star**
* 简书主页：包含多篇iOS和RN开发相关的技术文章[http://www.jianshu.com/u/023338566ca5](http://www.jianshu.com/u/023338566ca5) 欢迎小伙伴们：**多多关注，点赞**
* ReactNative QQ技术交流群(2000人)：**620792950** 欢迎小伙伴进群交流学习
* iOS QQ技术交流群：**678441305** 欢迎小伙伴进群交流学习