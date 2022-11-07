#
# Be sure to run `pod lib lint TMMChannel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'TMMChannel'
    s.version          = '0.1.1'
    s.summary          = '请简单的介绍一下你的组件 TMMChannel.'
    s.description      = <<-DESC
        TODO: 给你的组件添加一段描述文案。
    DESC

    s.homepage         = 'https://git.code.oa.com/chenxiong/TMMChannel'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'chenxiong' => '478815108@qq.com' }
    s.source           = { :git => 'http://git.code.oa.com/NextLib/TMMChannel', :tag => s.version.to_s }
    s.ios.deployment_target = '11.0'
    s.libraries     = 'c++'
  

    # 不建议直接这样引用资源文件，但考虑老组件的迁移成本，默认使用这种方式。
    s.source_files = 'TMMChannel/Classes/**/**/*'

    # 建议使用 bundle 打包资源文件，但是代码中的加载需要指定bundle
    s.resources = "TMMChannel/Assets/data.bundle"

    # 目前强制使用静态库引入
    s.static_framework = true

end
