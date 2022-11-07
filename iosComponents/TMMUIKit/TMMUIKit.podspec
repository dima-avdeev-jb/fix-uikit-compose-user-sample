#
# Be sure to run `pod lib lint TMMUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'TMMUIKit'
    s.version          = '0.0.1'
    s.summary          = '请简单的介绍一下你的组件 TMMUIKit.'
    s.description      = <<-DESC
        TODO: 给你的组件添加一段描述文案。
    DESC

    s.homepage         = 'tmm.pages.oa.com'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'chenxiong' => '478815108@qq.com' }
    s.source           = { :git => 'https://github.com/cx478815108', :tag => s.version.to_s }
    s.ios.deployment_target = '9.0'

    s.source_files = 'TMMUIKit/Classes/**/**/*'


    s.public_header_files = 'TMMUIKit/Classes/Service/*.h', 'TMMUIKit/Classes/Adapter/Output/*.h', 'TMMUIKit/Classes/Impl/Output/*.h', 'TMMUIKit/Classes/Export/*.h'

    # 目前强制使用静态库引入
    s.static_framework = true

end
