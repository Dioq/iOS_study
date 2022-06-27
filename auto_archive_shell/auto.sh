#!/bin/bash

# 待打包的工程目录
ProjectDir=$1
# 当前目录的绝对路径
CurrentDir="$(pwd)" 

# app 名字
AppName="Dio"
# BundleID
BundleIdentifier=""
# 最低支持的系统
version=9.0

# 编译的架构
Architecture=arm64
# -isysroot指定系统SDK路径
SDK_path=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk

# 签名需要的证书
CertificateName="Apple Distribution: Zhendong Li (38D3676P2T)"

# 为编译工程做些准备工作
make_supporting_file(){
	#1. 创建 app 文件
	if [ -d "${CurrentDir}/Payload" ]
	then
        echo "${CurrentDir}/Payload"
		rm -rf $CurrentDir/Payload
	fi
    mkdir $CurrentDir/Payload
	mkdir $CurrentDir/Payload/"${AppName}.app"
	
    # 描述文件 放到 xx.app 文件里
    cp $CurrentDir/embedded.mobileprovision $CurrentDir/Payload/"${AppName}.app"

    # 生成签名时的权限文件
    security cms -D -i $CurrentDir/embedded.mobileprovision > $CurrentDir/profile.plist
    /usr/libexec/PlistBuddy -x -c 'Print :Entitlements' $CurrentDir/profile.plist > $CurrentDir/entitlements.plist

    # 获取 BundleID (Info.plist 里的 BundleID 要和描述文件里的一样)
    tmp=$(/usr/libexec/PlistBuddy -c "Print :'application-identifier'" $CurrentDir/entitlements.plist)
    BundleIdentifier=${tmp:11}
    # echo "BundleIdentifier: $BundleIdentifier"
}

make_supporting_file

# 递归遍历所有文件(把当前工程里需要处理的文件都放到新的工作目录 Payload)
copy_projectFile_to_Payload(){
    for file in `ls -a $1`
    do
        if [ -d $1"/"$file ]  # 判断是否是 Directory, 如果是 Directory 则进行递归
        then
            if [[ $file != '.' && $file != '..' ]]
            then
                # xxx.lproj 是 storyboard 存放文件需要特别处理
                if test "${file##*.}" = "lproj"
                then
                        cp -r $1"/"$file $CurrentDir/Payload/"${AppName}.app"
                else    # 其他文件则继续递归
                        copy_projectFile_to_Payload $1"/"$file
                fi
            fi
        else    # 如果是 file
            if test "${file##*.}" = "m"
            then
                    cp $1"/"$file $CurrentDir/Payload/"${AppName}.app"
            elif test "${file##*.}" = "h"
            then
                    cp $1"/"$file $CurrentDir/Payload/"${AppName}.app"
            elif test "${file##*.}" = "storyboard"
            then
                    cp $1"/"$file $CurrentDir/Payload/"${AppName}.app"
            elif test "${file##*.}" = "xib"
            then
                    cp $1"/"$file $CurrentDir/Payload/"${AppName}.app"
            elif test "${file##*.}" = "png"
            then
                    cp $1"/"$file $CurrentDir/Payload/"${AppName}.app"
            fi
        fi
    done
}

copy_projectFile_to_Payload $ProjectDir

# 编译 storyboard 和 xib 文件
compile_storyboardAndXib(){
    for file in `ls -a $1`
    do
        if [ -d $1"/"$file ]
        then
            if [[ $file != '.' && $file != '..' ]]
            then
                compile_storyboardAndXib $1"/"$file
            fi
        else
            if test "${file##*.}" = "storyboard"
            then
                    ibtool --compilation-directory $1 $1"/"$file
            elif test "${file##*.}" = "xib"
            then
                    tmp=$file
                    ibtool --errors --warnings --output-format human-readable-text --compile $1"/"${tmp%%.*}".nib" $1"/"$file
            fi
        fi
    done
}

compile_storyboardAndXib $CurrentDir/Payload/"${AppName}.app"

# 编译 oc 代码
compile_oc() {
    	clang \
			-fmodules -fobjc-arc \
			-isysroot ${SDK_path} \
			-arch ${Architecture} \
			-mios-version-min=${version} \
			$CurrentDir/Payload/"${AppName}.app"/*.m \
			-o $CurrentDir/Payload/"${AppName}.app"/${AppName}
}

compile_oc

# 编译后清理 oc storyboard xib 的源码 以及 Localization 的辅助文件
clear_Payload_dir(){
    for file in `ls -a $1`
    do
        if [ -d $1"/"$file ]  # 判断是否是 Directory, 如果是 Directory 则进行递归
        then
            if [[ $file != '.' && $file != '..' ]]
            then
                # xxx.lproj 是 storyboard 存放文件需要特别处理
                if test "${file##*.}" = "lproj"
                then
                    rm -rf $1"/"$file"/*.strings"
                fi
                clear_Payload_dir $1"/"$file
            fi
        else    # 如果是 file
            if test "${file##*.}" = "m"
            then
                    rm -rf $1"/"$file
            elif test "${file##*.}" = "h"
            then
                    rm -rf $1"/"$file
            elif test "${file##*.}" = "storyboard"
            then
                    rm -rf $1"/"$file
            elif test "${file##*.}" = "xib"
            then
                    rm -rf $1"/"$file
            fi
        fi
    done
}

clear_Payload_dir $CurrentDir/Payload/"${AppName}.app"

# 配置 Info.plist 文件
make_plist() {
    defaults write $CurrentDir/Payload/"${AppName}.app"/Info CFBundleDevelopmentRegion en #国际化时优先使用的语言
	
	defaults write $CurrentDir/Payload/"${AppName}.app"/Info CFBundleExecutable ${AppName}
	defaults write $CurrentDir/Payload/"${AppName}.app"/Info CFBundleIdentifier ${BundleIdentifier}
	defaults write $CurrentDir/Payload/"${AppName}.app"/Info CFBundleInfoDictionaryVersion 6.0 #plist文件结构的版本
	defaults write $CurrentDir/Payload/"${AppName}.app"/Info CFBundleName ${AppName}
	defaults write $CurrentDir/Payload/"${AppName}.app"/Info CFBundlePackageType APPL #APPL: app，FMWK: frameworks，BND: loadable bundles
	defaults write $CurrentDir/Payload/"${AppName}.app"/Info CFBundleShortVersionString 1.0
	defaults write $CurrentDir/Payload/"${AppName}.app"/Info CFBundleVersion 1
	defaults write $CurrentDir/Payload/"${AppName}.app"/Info LSRequiresIPhoneOS YES
	#defaults write $CurrentDir/Payload/"${AppName}.app"/Info UIMainStoryboardFile Main
	defaults write $CurrentDir/Payload/"${AppName}.app"/Info UILaunchStoryboardName LaunchScreen
	defaults write $CurrentDir/Payload/"${AppName}.app"/Info MinimumOSVersion ${version}
	defaults write $CurrentDir/Payload/"${AppName}.app"/Info DTPlatformName iphoneos
}

make_plist

# 生成dSYM文件 (可安装设备和Mach-O文件的有效性)
make_dsym() {
    #使用`dwarfdump --uuid `可以查看dSYM或可执行文件的UUID，匹配成功才能完全将crash log中的16进制地址符号化
    dsymutil -arch ${Architecture} $CurrentDir/Payload/"${AppName}.app"/${AppName} -o "${AppName}.app.dSYM"
}

make_dsym

# 签名 生成的 Mach-O 可执行文件
sign_machO() {
    /usr/bin/codesign --force --sign "${CertificateName}" --entitlements $CurrentDir/entitlements.plist $CurrentDir/Payload/"${AppName}.app"/${AppName}
}

sign_machO

# 生成 ipa 安装包
make_installer_package() {
    zip -rq ${AppName}.ipa ./Payload
}

make_installer_package


# 清理工作现场
clean_workspace() {
    rm -rf $CurrentDir/"${AppName}.app.dSYM"
    rm -rf $CurrentDir/entitlements.plist
    rm -rf $CurrentDir/profile.plist
    rm -rf $CurrentDir/Payload
}

clean_workspace
