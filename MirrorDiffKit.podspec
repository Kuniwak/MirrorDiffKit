Pod::Spec.new do |s|
  s.name         = "MirrorDiffKit"
  s.version      = "0.0.1"
  s.summary      = "Structual diff between any struct/class for efficient testing"
  s.description  = <<-DESC
    Structual diff between any struct/class for efficient testing.
  DESC
  s.homepage     = "https://github.com/Kuniwak/MirrorDiffKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Kuniwak" => "orga.chem.job+github@gmail.com" }
  s.ios.deployment_target     = "8.0"
  s.osx.deployment_target     = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target    = "9.0"
  s.source       = { :git => "https://github.com/Kuniwak/MirrorDiffKit.git", :tag => s.version.to_s }
  s.source_files = "Sources/**/*"
  s.frameworks   = "Foundation"
end
