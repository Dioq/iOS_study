## iOS 项目不使用Xcode 自己生成ipa安装包

写完iOS项目后，自己用脚本生成安ipa安装包

1. 使用 clang 编译所有的 Objective-C 和  C/C++ 源文件   
   生成的文件放到 Payload/appname.app 文件里

2. 使用　ibtool　编译 .storyboard 文件为 .storyboardc    
   生成的文件放到 Payload/appname.app/Base.lproj
   
3. 使用　ibtool　编译 .xib 文件为 .nib    
   生成的文件放到 Payload/appname.app

4. 自己构造Info.plist文件，并配置项目的相关信息      
   Info.plist 在 Payload/appname.app 文件里      
   使用 write 往 Info.plist 里写数据    

5. 将项目里的所有图片资源复制到 Payload 里的 appname.app 文件里    
   不需要顺序直接往里面放就可以了

6. 使用 codesign 签名 第一步生成的可执行文件或库文件      
   这里需要用到描述文件　embedded.mobileprovision（可以用苹果开发者账号登录苹果官网下载，但要注意描述文件里要添加测试设备的uuid，当然也有其他方式我就不列举）
   
7. 将 Payload 文件压缩成 ipa 安装包


clang：	
	-fmodules      自动国找到需要的系统库			
        -fobjc-arc     由ARC编译			
	-isysroot	指定系统SDK路径		

注：我在 makefile 里的步骤分的更细一些，由于我测试的项目没有使用 Main.storyboard 所以 在构建　Info.plist 时就没设置这个选项．
当你做完这些后你会发现 其实 Xcode 生成 ipa 包的过程很简单
