# ZHTestSDK
SDK工程结构demo
## 开发SDK常常遇到的一些问题
- 怎么在SDK工程里创建一个demo方便自我调试，并且能打断点调试
- 怎么让SDK与demo共用一套资源，避免多个地方重复引入资源
- SDK中要用到第三方库怎么办，怎么避免demo和SDK多次引入第三方库

## 开发环境
- Xcode 11.4.1
- macOS  10.15.4

## 下面是我总结的开发步骤
##### 1、创建一个Framework工程
创建一个Framework工程，做SDK相关配置，这里不再赘述。我这里创建的名称是ZHTestSDK
##### 2、在该工程里面创建一个demo工程
- 创建demo目的：验证我们写的SDK代码，更重要的是能打断点调试
- 新建一个target，创建一个Single View App，我这里创建的demo名称是ZHTestSDKDemo
![D879B6ED-FD0B-41B5-BA24-C8A27C970488.png](https://upload-images.jianshu.io/upload_images/8809499-63bec2934d283c4e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![A61BB99E-0D42-4A59-9293-902B367E7AC0.png](https://upload-images.jianshu.io/upload_images/8809499-4517d18e2fdaf977.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
- 创建完后是这样的
![355658DA-90EA-44BB-8EC2-20356CA04D99.png](https://upload-images.jianshu.io/upload_images/8809499-7239529bdcd93b59.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 在demo中引入我们的SDK
![292A7727-A66A-451A-8974-22DA8B6BA58F.png](https://upload-images.jianshu.io/upload_images/8809499-64c004c288ce9c77.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- demo中使用我们要SDK中的东西
比如SDK中有个ZHImageView类可供SDK外部使用，demo ViewController中的代码
```
#import <ZHTestSDK/ZHTestSDK.h>

ZHImageView *imageView = [[ZHImageView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
[self.view addSubview:imageView];

```

##### 3、使用资源，建立bundle
- 创建一个bundle，这里名字为ZHTestSDKResource类型是bundle的target
![AABB487D-6FFB-4225-AB55-39E50116F61B.png](https://upload-images.jianshu.io/upload_images/8809499-5f8ea8a3f17b249e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- bundle设置，把支持的平台设置成iOS，要支持其他平台，自行设置，然后就是要设置支持的系统最低版本
![287CDE0A-BEAC-45D1-9FC9-A1EB2550A0FF.png](https://upload-images.jianshu.io/upload_images/8809499-65648d594d4654f6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 建完之后，工程目录中多了一个ZHTestSDKResource文件夹，注意：资源不会放到这个文件夹里
![6C31E9D6-9F4D-4F3B-B67A-5FE980317C09.png](https://upload-images.jianshu.io/upload_images/8809499-d9fcd7ffac1a712b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 接下来编译我们的bundle，然后在products中找到bundle，然后右击，show in folder，找到这个bundle
![9961B798-EAD5-4E60-A669-05A9E5DBC02C.png](https://upload-images.jianshu.io/upload_images/8809499-d709005cb8b726ff.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 然后我们将文件中的bundle拖入到工程中，只用引入到demo中即可，不用copy
![AB906C35-54C1-4837-9848-D42F6F0BE96F.png](https://upload-images.jianshu.io/upload_images/8809499-db2b065a8575d8bb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 引入后的工程目录是这样的
![19F225AF-00BF-4CD2-A8E9-BCD32EB324E3.png](https://upload-images.jianshu.io/upload_images/8809499-59052d5d4c91db6c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 向bundle中引入资源(以支持iOS的bundle为例)，这里引入了一个名为"123.png"的图片，注意：我们需要将资源拖入到bundle下，而不是跟bundle同名的文件夹下，引入资源后是这样的：
![F3D31689-4DD5-4109-A05E-C203D006D2B5.png](https://upload-images.jianshu.io/upload_images/8809499-05e38080828788fe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 4、使用bundle中的资源
- 使用mainBundle获取我们自己bundle的路径
- 通过路径创建我们自己的bundle
- 通过我们自己的bundle获取需要的资源的路径，有了资源路径自然就能拿到资源了
下面我写了一个工具的代码.m 文件内容:
```
#import "ZHHelper.h"

@interface ZHHelper()

/// 资源bundle
@property (nonatomic, strong) NSBundle *resourceBundle;

@end

@implementation ZHHelper

/// 单例
+ (instancetype)shared {
    static ZHHelper *_helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _helper = [[ZHHelper alloc] init];
    });
    return _helper;
}

/// 通过资源名获取资源路径
/// @param name 资源名称
/// @param type 资源类型
- (NSString *)resourcePathWithName:(NSString *)name ofType:(NSString *)type {
    return [self.resourceBundle pathForResource:name ofType:type];
}

#pragma mark - setter / getter

- (NSBundle *)resourceBundle {
    if (!_resourceBundle) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ZHTestSDKResource" ofType:@"bundle"];
        _resourceBundle = [NSBundle bundleWithPath:bundlePath];
    }
    return _resourceBundle;
}

@end

```

##### 5、引用第三方库
我这里采用pod的形式引入第三方库，以引入SDWebImage为例
- 首先建立pod，这里就不多说了，如果建立了bundle target，podfile文件里也有这个target，删掉它
-  在pod中引入SDWebImage，SDK 和 demo 两个target都要引入，然后pod install，这样在SDK和demo中都可以用SDWebImage了，pod中的代码：
```
platform :ios, '9.0'

target 'ZHTestSDK' do
  use_frameworks!
  pod 'SDWebImage'

end

target 'ZHTestSDKDemo' do
  use_frameworks!
  pod 'SDWebImage'
  
end
```
- 这样引入的优缺点
优点：1.可以让SDK和接入SDK方公用一套第三方代码，避免代码过度冗余；2.减小包体体积
缺点：1.接入方必须引入第三方库； 2.当接入方之前已经引用了某个第三方库，然后再接入SDK，SDK用的第三方库版本和接入方使用的版本不一致，可能会导致其中一方要修改代码

##### 6、打包
打包时，要注意bundle也是SDK一部分，bundle不要放到Framework内部，他两文件结构平级就可以，否则通过上面的方式会读取不到

##### 7、源码地址
[https://github.com/zhengzhanghai/ZHTestSDK](https://github.com/zhengzhanghai/ZHTestSDK)

