require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name           = 'hume-evi-expo'
  s.version        = package['version']
  s.summary        = 'Hume Evi integration for Expo'
  s.description    = 'Native module for integrating Hume Evi voice emotion analysis in Expo/React Native applications'
  s.license        = package['license']
  s.author         = { 'Middle East Software Solutions' => 'hello@middleeastsoftware.com' }
  s.homepage       = 'https://github.com/middleeastsoftware/hume-evi-expo'
  s.platform       = :ios, '13.4'
  s.source         = { 
    :git => 'https://github.com/middleeastsoftware/hume-evi-expo.git', 
    :tag => s.version.to_s 
  }
  
  s.source_files   = 'ios/**/*.{swift}'
  s.dependency 'ExpoModulesCore'
  
  s.swift_version = '5.0'
  s.module_name = 'HumeEviExpo'
  
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'SWIFT_COMPILATION_MODE' => 'wholemodule'
  }
end 