class NumpyAT1233 < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/0a/88/f4f0c7a982efdf7bf22f283acf6009b29a9cc5835b684a49f8d3a4adb22f/numpy-1.23.3.tar.gz"
  sha256 "51bf49c0cd1d52be0a240aa66f3458afc4b95d8993d2d04f0d91fa60c10af6cd"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  depends_on "gcc" => :build # for gfortran
  depends_on "mtg/essentia/libcython@0.29.30" => :build
  # depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "openblas"

  conflicts_with "numpy", because: "both install f2py and other binaries"

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version) # so that `bin/f2py` and `bin/f2py3` use python3.10
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    openblas = Formula["openblas"]
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = openblas.opt_lib/shared_library("libopenblas")

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas.opt_lib}
      include_dirs = #{openblas.opt_include}
    EOS

    Pathname("site.cfg").write config

    pythons.each do |python|
      site_packages = Language::Python.site_packages(python)
      ENV.prepend_path "PYTHONPATH", Formula["mtg/essentia/libcython@0.29.30"].opt_libexec/site_packages

      system python, "setup.py", "build", "--fcompiler=#{Formula["gcc"].opt_bin}/gfortran",
                                          "--parallel=#{ENV.make_jobs}"
      system python, *Language::Python.setup_install_args(prefix, python)
    end
  end

  def caveats
    on_macos do
      <<-EOS
        This formula technically conflicts with the current Homebrew
        version of `numpy`, as they both provide binaries. However,
        the only result is that this formula can't be fully linked.

        Since essentia only requires numpy's python bindings, there are
        a few solutions (you only need to do one of the following):

          1. `brew uninstall numpy` (easiest, only if you have no formulae that depend on numpy)
          2. `brew unlink numpy`, then install this formula
          3. If you need to keep `numpy` linked after installing this, you must run the
             following to use this version of numpy when calling python3.9:

            export PYTHONPATH="#{opt_prefix/Language::Python.site_packages(Formula["python@3.9"].opt_libexec/"bin/python")}"
      EOS
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end
