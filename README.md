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

By default, the installation includes Python bindings for Python 3 and ``python`` Homebrew formula will be installed as a dependency. If you want to avoid it and skip building python extension, use the ``--without-python`` flag. 
