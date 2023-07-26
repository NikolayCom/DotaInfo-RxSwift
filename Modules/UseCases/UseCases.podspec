Pod::Spec.new do |spec|
  spec.name         = "UseCases"
  spec.version      = "0.0.1"
  spec.summary      = "UseCases"
  spec.description  = <<-DESC
  Design module

                   DESC
  spec.homepage     = "https://nikolaypivnik.com"
  spec.license      = "BSD"
  spec.author       = { "Nikolay Pivnik" => "nikolaypivnik@gmail.com" }
  spec.platform     = :ios, "14.0"
  spec.swift_version = "5.6.1"
  spec.source       = { :path => "." }
  spec.source_files  = "UseCases/**/*.{h,m,swift}"

  spec.frameworks = "Foundation"
  
  spec.dependency "RxSwift"
  spec.dependency "Alamofire"
  
  spec.dependency "Models"
  spec.dependency "Core"
end
