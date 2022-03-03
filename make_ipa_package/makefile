CurrentDir = "$(shell pwd)"
ResourceDirecrory = ProjectFile
AppName = Makeipa
TmpBuildFile = $(AppName).app
ConstIBFile = Base.lproj
Architecture = arm64
CertificateName = "Apple Development: zhendong2011@live.cn (W754JF95X9)"

version = 9.0
BundleIdentifier = com.my.${AppName}

compile:
	#1、创建BuildDemo.app文件
	@rm -rf $(TmpBuildFile)
	@test -d $(TmpBuildFile) || mkdir $(TmpBuildFile)
	
	@#如果不用xcrun直接用clang，需要用-isysroot指定系统SDK路径，如/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
	@#@xcrun -sdk iphoneos clang \
			-arch $(Architecture) \
			-mios-version-min=${version} \
			-fmodules \
			-fobjc-arc \
			-c $(ResourceDirecrory)/AppDelegate.m \
			-o $(TmpBuildFile)/AppDelegate.o
	
	@clang \
			-fmodules -fobjc-arc \
			-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk \
			-arch $(Architecture) \
			-mios-version-min=${version} \
			-c $(ResourceDirecrory)/AppDelegate.m \
			-o $(TmpBuildFile)/AppDelegate.o
	
	@clang \
			-fmodules -fobjc-arc \
			-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk \
			-arch $(Architecture) \
			-mios-version-min=${version} \
			-c $(ResourceDirecrory)/main.m \
			-o $(TmpBuildFile)/main.o
	@clang \
			-fmodules -fobjc-arc \
			-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk \
			 -arch $(Architecture) \
			-mios-version-min=${version} \
			-c $(ResourceDirecrory)/ViewController.m \
			-o $(TmpBuildFile)/ViewController.o
	
	@clang \
			-fmodules -fobjc-arc \
			-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk \
			 -arch $(Architecture) \
			-mios-version-min=${version} \
			-c $(ResourceDirecrory)/SecViewController.m \
			-o $(TmpBuildFile)/SecViewController.o

link:
	#2、Link Object file
	@clang \
			-fmodules -fobjc-arc \
			-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk \
			-arch $(Architecture) \
			-mios-version-min=${version} \
			$(TmpBuildFile)/main.o $(TmpBuildFile)/AppDelegate.o $(TmpBuildFile)/ViewController.o $(TmpBuildFile)/SecViewController.o \
			-o $(TmpBuildFile)/$(AppName)
	
	@rm $(TmpBuildFile)/AppDelegate.o $(TmpBuildFile)/main.o $(TmpBuildFile)/ViewController.o

storyboard:
	#3、编译storyboard文件
	@mkdir $(TmpBuildFile)/$(ConstIBFile)
	
	@#@ibtool --compilation-directory $(TmpBuildFile)/$(ConstIBFile) $(ResourceDirecrory)/$(ConstIBFile)/Main.storyboard
	
	@ibtool --compilation-directory $(TmpBuildFile)/$(ConstIBFile) $(ResourceDirecrory)/$(ConstIBFile)/LaunchScreen.storyboard

	@ibtool --errors --warnings --output-format human-readable-text --compile $(TmpBuildFile)/SecViewController.nib $(ResourceDirecrory)/SecViewController.xib
plist:
	#4、plist : App ID、name、version ...
	
	@defaults write $(CurrentDir)/$(TmpBuildFile)/Info CFBundleDevelopmentRegion en #国际化时优先使用的语言
	
	@defaults write $(CurrentDir)/$(TmpBuildFile)/Info CFBundleExecutable $(AppName)
	@defaults write $(CurrentDir)/$(TmpBuildFile)/Info CFBundleIdentifier ${BundleIdentifier}
	@defaults write $(CurrentDir)/$(TmpBuildFile)/Info CFBundleInfoDictionaryVersion 6.0 #plist文件结构的版本
	@defaults write $(CurrentDir)/$(TmpBuildFile)/Info CFBundleName $(AppName)
	@defaults write $(CurrentDir)/$(TmpBuildFile)/Info CFBundlePackageType APPL #APPL: app，FMWK: frameworks，BND: loadable bundles
	@defaults write $(CurrentDir)/$(TmpBuildFile)/Info CFBundleShortVersionString 1.0
	@defaults write $(CurrentDir)/$(TmpBuildFile)/Info CFBundleVersion 1
	@defaults write $(CurrentDir)/$(TmpBuildFile)/Info LSRequiresIPhoneOS YES
	@#@defaults write $(CurrentDir)/$(TmpBuildFile)/Info UIMainStoryboardFile Main
	@defaults write $(CurrentDir)/$(TmpBuildFile)/Info UILaunchStoryboardName LaunchScreen
	@defaults write $(CurrentDir)/$(TmpBuildFile)/Info MinimumOSVersion ${version}
	@defaults write $(CurrentDir)/$(TmpBuildFile)/Info DTPlatformName iphoneos

asset:
	#5、复制图片资源
	@cp -a $(ResourceDirecrory)/Assets.xcassets/AppIcon.appiconset/*.png $(TmpBuildFile)/
	@cp -a $(ResourceDirecrory)/Assets.xcassets/launch.imageset/*.png $(TmpBuildFile)/

dsym:
	#6、生成dSYM文件
	@#使用`dwarfdump --uuid `可以查看dSYM或可执行文件的UUID，匹配成功才能完全将crash log中的16进制地址符号化
	@dsymutil -arch $(Architecture) $(TmpBuildFile)/$(AppName) -o $(AppName).app.dSYM

codesign:
	#7、签名
	@#mobileprovision文件包含Team ID和允许安装设备的ID
	@cp -f embedded.mobileprovision $(TmpBuildFile)
	@#provision查看命令：security cms -D -i provision_file
	
	@# Entitlements 是应用功能和授权相关的文档，涉及到 iCloud、推送等功能的配置信息。可以通过开发环境配置文档重新生成一份，后面签名要用到
	@security cms -D -i ${CurrentDir}/embedded.mobileprovision > ${CurrentDir}/profile.plist
	@# 上面会生成一个完整的 plist，我们只需要里面的Entitlements字段，执行命令行：
	@/usr/libexec/PlistBuddy -x -c 'Print :Entitlements' ${CurrentDir}/profile.plist > ${CurrentDir}/entitlements.plist

	@/usr/bin/codesign --force --sign $(CertificateName) --entitlements ${CurrentDir}/entitlements.plist $(TmpBuildFile)
	@#使用codesign -vv xx.app 命令查看App签名信息

package:
	#8、打包ipa
	@mkdir -p Payload
	@cp -r -f $(TmpBuildFile) Payload
	@zip -r -q $(AppName).ipa Payload
	@rm -f -r Payload/
	@rm -f -r $(TmpBuildFile)

clean:
	@-rm -rf ${CurrentDir}/profile.plist
	@-rm -rf ${CurrentDir}/entitlements.plist
	@-rm -rf $(AppName).ipa
	@-rm -rf $(AppName).app.dSYM

all: compile link storyboard plist asset dsym codesign package
