Pod::Spec.new do |spec|
  spec.name         = "HeroInfo"
  spec.version      = "0.0.1"
  spec.summary      = "HeroInfo"
  spec.description  = <<-DESC
  Extensions module
                   DESC
  spec.homepage     = "https://nikolaypivnik.com"
  spec.license      = "BSD"
  spec.author       = { "Nikolay Pivnik" => "nikolaypivnik@gmail.com" }
  spec.platform     = :ios, "14.0"
  spec.swift_version = "5.6.1"
  spec.source       = { :path => "." }
  spec.source_files  = "HeroInfo/**/*.{h,m,swift}"

  spec.frameworks = "Foundation"
  
  spec.dependency "RxSwift"
  spec.dependency "SnapKit"
  spec.dependency "Then"
  spec.dependency "SDWebImage"
  spec.dependency "RxDataSources"
  spec.dependency "PKHUD"
  spec.dependency "Extensions"
  spec.dependency "Core"
  spec.dependency "Models"
  spec.dependency "UseCases"
end
