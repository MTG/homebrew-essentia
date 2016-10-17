require 'formula'

class Essentia < Formula
  desc "Library for audio analysis and audio-based music information retrieval"
  homepage "http://essentia.upf.edu"
  url "https://github.com/MTG/essentia/archive/v2.1_beta3.tar.gz"
  version "2.1_beta3"
  sha256 "974b90af6093fd12d6c9ac370f13b0dd1ecf80a418670bf35582ed5d95d65237"

  head 'https://github.com/MTG/essentia.git'

  depends_on "pkg-config"
  depends_on "gcc"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "gdbm"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "python"
  #depends_on :python
  depends_on "homebrew/python/numpy"
  depends_on "libyaml" => :recommended
  depends_on "fftw" => :recommended
  depends_on "ffmpeg" => :recommended
  depends_on "libsamplerate" => :recommended
  depends_on "libtag" => :recommended


  def install
    system "./waf", "configure", "--mode=release", 
                                 "--with-python", 
                                 "--with-vamp", 
                                 "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  def caveats
"""
You may be also interested in installing ipython and matplotlib python packages.

You can install these using
   pip install ipython matplotlib
Or using the installation method you prefer.
"""
  end

  bottle do
    cellar :any
    sha256 "ded4b3524618ca4fe38a940f09a629cc95b853d808ca174f5da21984922ac435" => :yosemite
  end


#  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test essentia`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
#    system "false"
#  end
end
