require 'formula'

class Gaia < Formula
  desc "Audio similarity and classification library"
  homepage "https://essentia.upf.edu"
  url "https://github.com/MTG/gaia/archive/v2.4.4.tar.gz"
  version "2.4.4"
  sha256 "5975a3ecfb334cedea101604cb975402f2a2b59e1d9547ebc6d990d6af2652c8"

  head 'https://github.com/MTG/gaia.git'

  depends_on "pkg-config"
  depends_on "python"
  depends_on "swig"
  depends_on "libyaml"
  depends_on "qt"

  def install
    system "./waf", "configure", "--with-python-bindings", 
                                 "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  #test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test gaia`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    #system "false"
  #end
end
