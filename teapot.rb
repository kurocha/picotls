#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "3.0"

define_target "picotls" do |target|
	target.depends :platform
	
	target.depends "Build/Make"
	target.depends "Build/CMake"
	
	target.depends "Library/openssl", public: true
	
	target.provides "Library/picotls" do
		source_files = target.package.path + "picotls"
		cache_prefix = environment[:build_prefix] / environment.checksum + "picotls"
		package_files = [
			cache_prefix / "lib/libpicotls-openssl.a",
			cache_prefix / "lib/libpicotls-core.a",
		]
		
		cmake source: source_files, install_prefix: cache_prefix, arguments: [
			"-DBUILD_SHARED_LIBS=OFF",
		], package_files: package_files
		
		append linkflags package_files
		append header_search_paths cache_prefix + "include"
	end
end

define_configuration "development" do |configuration|
	configuration[:source] = "https://github.com/kurocha/"
	
	configuration.import "picotls"
	
	configuration.require "platforms"
end

define_configuration "picotls" do |configuration|
	configuration.public!
	
	configuration.require "build-make"
	configuration.require "build-cmake"
	
	configuration.require "openssl"
end
