class Essentia < Formula
  desc "Library for audio analysis and audio-based music information retrieval"
  homepage "http://essentia.upf.edu"
  head 'https://github.com/MTG/essentia.git'

  include Language::Python::Virtualenv

  depends_on "pkg-config" => :build
  depends_on "gcc" => :build
  depends_on "eigen"
  depends_on "libyaml"
  depends_on "fftw"
  depends_on "ffmpeg"
  depends_on "libsamplerate"
  depends_on "libtag"
  depends_on "chromaprint"
  depends_on "gaia" => :optional

  option "without-python", "Build without python3 support"

  depends_on "python" if build.with? "python"
  depends_on "numpy" if build.with? "python"

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install

    build_flags = [
      "--mode=release",
      "--with-examples",
      "--with-vamp",
      "--prefix=#{prefix}"
    ]

    if build.with? "gaia"
      system "python3", "waf", "configure", "--with-gaia", *build_flags
    end
    if build.without? "gaia"
      system "python3", "waf", "configure", *build_flags
    end
    system "python3", "waf"
    system "python3", "waf", "install"

    python_flags = [
      "--mode=release",
      "--only-python",
      "--prefix=#{prefix}"
    ]

    # Adding path to newly installed Essentia
    ENV['PKG_CONFIG_PATH'] = "#{prefix}/lib/pkgconfig:" + ENV['PKG_CONFIG_PATH']

    if build.with? "python"
      system "python3", "waf", "configure", *python_flags
      system "python3", "waf"
      system "python3", "waf", "install"
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
      system "python3", "-c", "#{py_test}"
    end
  end
end
