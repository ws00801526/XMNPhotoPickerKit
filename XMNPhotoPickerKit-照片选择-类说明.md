

1. XMNBaseRequesVM

| 属性        | 作用           |
| ------------- |:-------------:| 
| requestCommand      | 处理请求的 | 
| errorMsg     | 错误的信息,从requestCommand中获取      | 



##1. XMNPhotoPickerKit

###1.1 照片管理Manager
####1.1.1 相关类

#####1.1.1.1. XMNAlbumModel : 专辑信息

| 属性        |  属性说明     |  作用           |
| ------------- | --- |:-------------:| 
| name   |    | album 名称 | 
| count     |   | 照片数量  | 
| result |    | 包含的图片数组,PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset> | 


| 方法        |  方法说明     |  作用           |
| ------------- | --- |:-------------:| 
| albumWithResult:   | Class方法   |  通过获取的PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset> | 
| setName:     |  重写name的setter方法  | 设置name为中文字符串  | 

#####1.1.1.2. XMNAssetModel : 照片,视频等信息

| 属性        |  属性说明     |  作用           |
| ------------- | --- |:-------------:| 
| asset   |    | 资源类型,PHAsset or ALAsset | 
| selected     |   | 是否被选中   | 
| type |  readonly  | 图片,视频,livePhoto,audio等| 
| timeLength | readonly | 视频长度 |
| originImage   | readOnly  | 原图 | 
| thumbnail     |  readonly | 缩略图,默认大小的缩略图   | 
| previewImage |  readonly  |适合当前屏幕的预览图 | 
| imageOrientation | readonly | 图片方向|

#####1.1.1.3. XMNPhotoManager : 获取所有专辑,专辑内照片视频等

| 	方法        |  方法说明          | 作用 | 
| ------------- |:-------------:| --- | 
| hasAuthorized| classMethods | 判断是否授权 |
| | 
| requestOriginImageWithAsset:WithCompletion:      | getter方法 | 获取asset的原图  | 
| requestThumbnailWithAsset:WithCompletion:     | getter方法   | 获取asset的对应的缩略图 |
| requestPreviewImageWithAsset:WithCompletion: |  getter方法 | 获取asset对应的预览图,适应当前屏幕的尺寸 |  
| imageOrientationWithAsset:WithCompletion: | getter方法  |获取对应asset的图片方向 | 

###1.2 照片选择ViewController
####1.2.1 XMNPhotoPickerController :继承UINavigationController的 
#####1.2.2 XMNAlbumListController :继承UITableViewController 显示
###1.3 照片预览XMNPhotoPreviewController 继承UICollectionController

###1.4 视频预览XMNVideoPreviewController
