require File.expand_path('../spec_helper', __FILE__)

module Jazzy
  describe SourceKitten do
    it 'validates the xcode-select path' do
      SourceKitten.stubs(:`)
        .returns '/Applications/Xcode-beta.app/Contents/Developer'
      should.not.raise { SourceKitten.assert_xcode_location }

      SourceKitten.stubs(:`)
        .returns '/Applications/Xcode.app/Contents/Developer'
      should.raise { SourceKitten.assert_xcode_location }.message.should
        .match %r{Please install or symlink Xcode.*/Applications/Xcode-beta.app}
    end

    it 'validates the current xcode version' do
      SourceKitten.stubs(:`).returns <<-O
Apple Swift version 2.0 (swiftlang-700.0.47.4 clang-700.0.59.1)
Target: x86_64-apple-darwin15.0.0
      O
      should.not.raise { SourceKitten.assert_swift_version }

      SourceKitten.stubs(:`).returns <<-O
Apple Swift version 1.2 (swiftlang-602.0.49.6 clang-602.0.49)
Target: x86_64-apple-darwin14.3.0
      O
      should.raise { SourceKitten.assert_swift_version }.message.should
        .match /Jazzy.*Swift 2\.0/

      SourceKitten.stubs(:`).returns <<-O
Swift version 1.1 (swift-600.0.57.4)
Target: x86_64-apple-darwin14.1.0
      O
      should.raise { SourceKitten.assert_swift_version }.message.should
        .match /Jazzy.*Swift 2\.0/
    end
  end
end
