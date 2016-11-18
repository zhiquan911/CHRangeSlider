
Pod::Spec.new do |s|
  s.name             = 'CHRangeSlider'
  s.version          = '1.0.1'
  s.summary          = 'Swift3编写的多点滑杆组件'


  s.description      = <<-DESC
Swift3编写的多点滑杆组件，支持一条滑杆，多个滑块滑动操纵
                       DESC

  s.homepage         = 'https://github.com/zhiquan911/CHRangeSlider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chance' => 'zhiquan911@qq.com' }
  s.source           = { :git => 'https://github.com/zhiquan911/CHRangeSlider.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'CHRangeSlider/Classes/**/*'

end


#验证命令：pod lib lint CHRangeSlider.podspec --verbose
#提交命令：pod trunk push CHRangeSlider.podspec
