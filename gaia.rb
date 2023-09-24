require 'formula'

class Gaia < Formula
  desc "Audio similarity and classification library"
  homepage "https://essentia.upf.edu"
  url "https://github.com/MTG/gaia/archive/v2.4.6.tar.gz"
  version "2.4.6"
  sha256 "9e7f57150d3bb9547477624b44103743841409226681bc4b3773dbddfd610b39"
  revision 1

  head 'https://github.com/MTG/gaia.git'

  include Language::Python::Virtualenv
  include Language::Python::Shebang

  depends_on "pkg-config"
  depends_on "python@3.8"
  depends_on "swig"
  depends_on "libyaml"
  depends_on "eigen"
  depends_on "qt@5"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/e3/e8/b3212641ee2718d556df0f23f78de8303f068fe29cdaa7a91018849582fe/PyYAML-5.1.2.tar.gz"
    sha256 "01adf0b6c6f61bd11af6e10ca52b7d4057dd0be0343eb9283c878cf3af56aee4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    #venv = virtualenv_create(libexec, "python3")
    #venv.pip_install resource("PyYAML")

    system Formula["python@3.8"].opt_bin/"python3.8", "waf", "configure", "--with-python-bindings",
                                          "--prefix=#{prefix}"
    system Formula["python@3.8"].opt_bin/"python3.8", "waf"
    system Formula["python@3.8"].opt_bin/"python3.8", "waf", "install"

    resource("PyYAML").stage do
      system Formula["python@3.8"].opt_bin/"python3.8", *Language::Python.setup_install_args(libexec)
    end

    resource("six").stage do
      system Formula["python@3.8"].opt_bin/"python3.8", *Language::Python.setup_install_args(libexec)
    end

    version = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3.8"
    site_packages = "lib/python#{version}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-gaia.pth").write pth_contents

    rewrite_shebang detected_python_shebang, bin/"gaiafusion"
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
