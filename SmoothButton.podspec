Pod::Spec.new do |s|

  s.name         = "SmoothButton"
  s.version      = "0.0.1"
  s.summary      = "A custom buttom subclass of UIControl."
  s.swift_version = "4.0"
  s.description  = "A custom button made in Swift subclass of UIControl to easily style buttons."
  s.homepage     = "https://cocoapods.org/pods/SmoothButton"
  s.license      = { :type => 'MIT', :file => 'SmoothButton/LICENSE.md' }
  s.authors             = { "Matthew Weldon" => "matt@smooth.tech", "Rushan Benazir" => "rush@smooth.tech" }
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/RushanB/SmoothButton.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "SmoothButton/**/*.swift"
# s.source_files  = "SmoothButton/**/*.{swift}"
  s.resources = "SmoothButton/**/*.{ttf,xib}"
end
