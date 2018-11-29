# Homebrew-Essentia
Homebrew formulas for Essentia and Gaia installation

Install homebrew tap:
```
brew tap MTG/essentia
```

Install compiling the latest code from the master branch: 
```
brew install essentia --HEAD
```

Install from master branch with Gaia support:
```
brew install essentia --HEAD --with-gaia
```

By default, the installation includes Python bindings for both Python 3 and Python 2 and both ``python`` and ``python@2`` Homebrew formulas will be installed as dependencies. If you want to avoid those dependencies and not build python extensions, use flags ``--without-python`` and ``--without-python@2``. 
