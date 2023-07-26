Pod::Spec.new do |spec|
  spec.name         = "Models"
  spec.version      = "0.0.1"
  spec.summary      = "Models"
  spec.description  = <<-DESC
  Extensions module
                   DESC
  spec.homepage     = "https://nikolaypivnik.com"
  spec.license      = "BSD"
  spec.author       = { "Nikolay Pivnik" => "nikolaypivnik@gmail.com" }
  spec.platform     = :ios, "14.0"
  spec.swift_version = "5.6.1"
  spec.source       = { :path => "." }
  spec.source_files  = "Models/**/*.{h,m,swift}"

  spec.frameworks = "Foundation"
  
  spec.dependency "RxSwift"
  spec.dependency "Core"
end
