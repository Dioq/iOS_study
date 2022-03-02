#!/bin/bash
<<!
iOS     ipa包重签名
        修改部分信息
!

# 开发者证书
certificate="Apple Development: 270488715@qq.com (2TTSFSXGUZ)"
# 发布版本
version=8.0.15
BundleVersion=8.0.15.35

# 1. 处理描述文件
mkdir res_tmp
cd ./res_tmp
# Entitlements 是应用功能和授权相关的文档，涉及到 iCloud、推送等功能的配置信息。可以通过开发环境配置文档重新生成一份，后面签名要用到
security cms -D -i ../*.mobileprovision > ./profile.plist
# 上面会生成一个完整的 plist，我们只需要里面的Entitlements字段，执行命令行：
/usr/libexec/PlistBuddy -x -c 'Print :Entitlements' ./profile.plist > ./entitlements.plist

# 2. 处理 ipa安装包
# 解压ipa文件到当前目录
unzip -q ../*.ipa -d ./

# Mach-O可执行文件名
exe_bin=""
path=./Payload
files=$(ls $path)
for filename in $files
do
        # 找到 .app 后缀的文件
        if test "${filename##*.}" = "app"
        then
#                echo "-------- > go here "
                path="$path/$filename"
                exe_bin="${filename%%.*}"
        fi
done

#echo "---------> path:${path}"
#echo "---------> exe_bin:${exe_bin}"

# ipa 内有些文件不能用自己的证书签名,需要删除
del_arr=("Watch" "Plugins" "_CodeSignature")
for item in ${del_arr[*]}
do
	rm -rf "$path/$item"
done

# 把描述文件添加到包里
cp ../embedded.mobileprovision $path

# 给Mach-O可执行权限
chmod +x "$path/$exe_bin"

# info.plist文件的BundleID要和描述文件中的BundleID保持一致
# 获取描述文件中的BundleID
key="application-identifier"
BundleID=$(/usr/libexec/PlistBuddy -c "Print :'$key'" ./entitlements.plist)
BundleID=${BundleID:11}
# 覆盖Info.plist中的BundleID
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $BundleID" "${path}/Info.plist"
# 也可以更改一些其他信息
# 例如 发布版本
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $version" "${path}/Info.plist"
# 构建版本
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BundleVersion" "${path}/Info.plist"


# 3. 签名
/usr/bin/codesign --force --sign "$certificate" --entitlements entitlements.plist ${path}/Frameworks/*.framework
/usr/bin/codesign --force --sign "$certificate" --entitlements entitlements.plist $path/$exe_bin

# 4. 生成新成ipa
zip -rq newapp.ipa Payload
mv ./newapp.ipa ../

# 5. 清理现场
cd ../
rm -rf ./res_tmp/
