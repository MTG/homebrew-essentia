class Essentia < Formula
  desc "Library for audio analysis and audio-based music information retrieval"
  homepage "http://essentia.upf.edu"
  head 'https://github.com/MTG/essentia.git'
  revision 1

  include Language::Python::Virtualenv

  depends_on "pkg-config" => :build
  depends_on "gcc" => :build
  depends_on "eigen"
  depends_on "libyaml"
  depends_on "fftw"
  depends_on "ffmpeg@2.8"
  depends_on "libsamplerate"
  depends_on "libtag"
  depends_on "chromaprint"
  depends_on "gaia" => :optional
  depends_on "tensorflow" => :optional

  option "without-python", "Build without Python 3.9 support"

  depends_on "python@3.9" if build.with? "python"
  depends_on "mtg/essentia/numpy@1.23.3" if build.with? "python"

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  def install

    build_flags = [
      "--mode=release",
      "--with-examples",
      "--with-vamp",
      "--prefix=#{prefix}"
    ]

    if build.with? "gaia"
      build_flags += ["--with-gaia"]
    end

    if build.with? "tensorflow"
      build_flags += ["--with-tensorflow"]
    end

    system Formula["python@3.9"].opt_bin/"python3.9", "waf", "configure", *build_flags
    system Formula["python@3.9"].opt_bin/"python3.9", "waf"
    system Formula["python@3.9"].opt_bin/"python3.9", "waf", "install"

    python_flags = [
      "--mode=release",
      "--only-python",
      "--prefix=#{prefix}"
    ]

    # Adding path to newly installed Essentia
    ENV['PKG_CONFIG_PATH'] = "#{prefix}/lib/pkgconfig:" + ENV['PKG_CONFIG_PATH']

    if build.with? "python"
      site_packages = Language::Python.site_packages(Formula["python@3.9"].opt_libexec/"bin/python")
      ENV.prepend_create_path "PYTHONPATH", Formula["mtg/essentia/numpy@1.23.3"].opt_prefix/site_packages

      system Formula["python@3.9"].opt_bin/"python3.9", "waf", "configure", *python_flags
      system Formula["python@3.9"].opt_bin/"python3.9", "waf"
      system Formula["python@3.9"].opt_bin/"python3.9", "waf", "install"

      resource("six").stage do
        system Formula["python@3.9"].opt_bin/"python3.9", *Language::Python.setup_install_args(libexec)
      end

      version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3.9"
      site_packages = "lib/python#{version}/site-packages"
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-essentia.pth").write pth_contents
    end
  end

  test do
    system "#{bin}/essentia_streaming_extractor_music",
           "/System/Library/Sounds/Glass.aiff",
           "Glass.json"

    py_test = <<~EOS
      import essentia.standard as estd
      import essentia.streaming as estr
      estd.MusicExtractor()("/System/Library/Sounds/Glass.aiff")
    EOS

    if build.with? "python"
      system Formula["python@3.9"].opt_bin/"python3.9", "-c", "#{py_test}"
    end
  end
end
