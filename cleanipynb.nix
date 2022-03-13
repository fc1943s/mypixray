let
  nixos-unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  nixos = import <nixos> { config = { allowUnfree = true; }; };

  importanize = nixos-unstable.python39Packages.buildPythonPackage rec {
    pname = "importanize";
    doCheck = false;
    propagatedBuildInputs = [
      nixos-unstable.python39Packages.pathlib2
      nixos-unstable.python39Packages.rednose
      nixos-unstable.python39Packages.tox
    ];
    src = nixos-unstable.python39Packages.fetchPypi {
      inherit version pname;
      sha256 = "1bd383aa79d594e3c4cab8722046fe6bd6baf887950531f035ae6152489876f5";
    };
    version = "0.7.0";
  };

  cleanipynb = nixos-unstable.python39Packages.buildPythonPackage rec {
    doCheck = false;
    pname = "cleanipynb";
    propagatedBuildInputs = [
      importanize
      nixos-unstable.autoflake
      nixos-unstable.python39Packages.autopep8
      nixos-unstable.python39Packages.jupytext
    ];
    src = nixos.fetchFromGitHub {
        owner = "i008";
        repo = "clean_ipynb";
        rev = "master";
        sha256 = "141y4v5mwz64rkf37l0f4n89w0vp398dgygq6ws47lqnam44c169";
      };
    version = "0.4.2";
  };

in
  cleanipynb
