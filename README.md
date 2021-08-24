# 皮卡智能抠图API接口项目示例代码

#### 使用示例
- 使用命令: git clone https://github.com/picup-shop/api-objective-c-examples.git 克隆下此项目
- 在PKZNNetwork.m下更改APIKEY，在页面方法调用需要执行的API接口方法即可 注:(*示例代码仅供参考，如需使用请结合项目实际情况做出更改*)
```
//拼接请求URL
NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=6", self.baseUrl];
//获取图片数据
NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
NSData *data = [NSData dataWithContentsOfURL:fileUrl];

//是否裁剪至最小非透明区域 （非必填）
BOOL crop = 1;
//填充背景色 （非必填）
NSString *bgColor = @"000000";
NSDictionary *params = @{@"crop" : @(crop), @"bgcolor" : bgColor};
[[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:params data:data success:^(id  _Nonnull responseObject) {
    if (responseObject) {
        //得到处理后的图片
        self.handleImage.image = responseObject;
    }
} failure:^(NSError * _Nonnull error) {

}];
```

##### 注：更多API接口的详细信息请参考官网的API文档(示例项目的代码会根据官网的API文档同步更新)
[皮卡智能抠图](http://www.picup.shop/apidoc-image-matting.html)

---
#### 关于我们
皮卡智能（英文名：PicUP.AI）是杭州王道控股有限公司旗下产品

皮卡智能利用人工智能和计算机视觉的力量，提供各种各样的产品，使您的生活更容易，工作更富有成效。无论是人像裁剪、风格转换、绘画、图像增强、逆向图像搜索利基或通用图像分类、检测或语义分割任务，我们都能满足您的需求。让我们一起让人类变得更聪明！

#### 如有其他需求可以通过以下方式联系我们
- 邮箱
pikachu@picup.ai
- 微信
roymind
- 电话
4001180827
