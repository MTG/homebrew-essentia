require 'formula'

class Gaia < Formula
  desc "Audio similarity and classification library"
  homepage "https://essentia.upf.edu"
  url "https://github.com/MTG/gaia/archive/v2.4.4.tar.gz"
  version "2.4.4"
  sha256 "5975a3ecfb334cedea101604cb975402f2a2b59e1d9547ebc6d990d6af2652c8"

  head 'https://github.com/MTG/gaia.git'

  include Language::Python::Virtualenv

  depends_on "pkg-config"
  depends_on "python@2"
  depends_on "swig"
  depends_on "libyaml"
  depends_on "eigen"
  depends_on "cartr/qt4/qt@4"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/e3/e8/b3212641ee2718d556df0f23f78de8303f068fe29cdaa7a91018849582fe/PyYAML-5.1.2.tar.gz"
    sha256 "01adf0b6c6f61bd11af6e10ca52b7d4057dd0be0343eb9283c878cf3af56aee4"
  end

  def install
    venv = virtualenv_create(libexec, "python2")
    venv.pip_install resource("PyYAML")
    gaia_path = libexec/"lib/python2.7/site-packages"
    pth_contents = "import site; site.addsitedir('#{gaia_path}')\n"
    (lib/"python2.7/site-packages/homebrew-gaia.pth").write pth_contents

    system "python2", "waf", "configure", "--with-python-bindings", 
                                          "--prefix=#{prefix}"
    system "python2", "waf"
    system "python2", "waf", "install"
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
