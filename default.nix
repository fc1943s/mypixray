let
  nixos-unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  nixos = import <nixos> { config = { allowUnfree = true; }; };

  cleanipynb = import ./cleanipynb.nix;

  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix";
    #ref = "refs/heads/3.4.0";  # update this version
  }) {
    python = "python39";
  };

  pytorch-ranger = nixos-unstable.python39Packages.buildPythonPackage rec {
    pname = "pytorch-ranger";
    #doCheck = false;
    propagatedBuildInputs = [
      #nixos-unstable.python39Packages.pytorch
      nixos-unstable.python39Packages.pytorchWithCuda
      #nixos-unstable.python39Packages.torchvision
    ];
#    src = nixos-unstable.python39Packages.fetchPypi {
#      inherit version pname;
#      sha256 = "ba06633ebcc047b710e9496a007762f79ec993655159617b5d9c188a79fea8c8";
#    };
#    src = nixos.fetchFromGitHub {
#        owner = "NingAnMe";
#        repo = "Ranger-Deep-Learning-Optimizer";
#        rev = "master";
#        sha256 = "0l0d6110h81x7072nz8lz2yqd9q1mzk48z3nh4qv617x3kdpky07";
#      };
    src = nixos.fetchFromGitHub {
        owner = "mpariente";
        repo = "Ranger-Deep-Learning-Optimizer";
        rev = "master";
        sha256 = "11xzvk5n68898y4d4vwdcrnki30clsxkib4x4jji6rb7pfg5xxcl";
      };
    version = "0.1.1";
  };

  perlin-numpy = nixos-unstable.python39Packages.buildPythonPackage rec {
    pname = "perlin-numpy";
    propagatedBuildInputs = [
      nixos-unstable.python39Packages.numpy
      #nixos-unstable.python39Packages.pytorchWithCuda
    ];
    src = nixos.fetchFromGitHub {
        owner = "pvigier";
        repo = "perlin-numpy";
        rev = "master";
        sha256 = "1ivdv9rvpliy2cfszxpdbippwkr7wqr5z5scp7k7djasssly07g4";
      };
    version = "0.1";
  };


  torch-optimizer = nixos-unstable.python39Packages.buildPythonPackage rec {
    pname = "torch-optimizer";
    #doCheck = false;
    propagatedBuildInputs = [
      #nixos-unstable.python39Packages.pytorchWithCuda
      pytorch-ranger
    ];
    src = nixos-unstable.python39Packages.fetchPypi {
      inherit version pname;
      sha256 = "b2180629df9d6cd7a2aeabe71fa4a872bba938e8e275965092568cd9931b924c";
    };
    version = "0.3.0";
  };





  torchmetrics = nixos-unstable.python39Packages.buildPythonPackage rec {
    doCheck = false;
    pname = "torchmetrics";
    propagatedBuildInputs = [
      pyDeprecate
      #torch-optimizer
      nixos-unstable.python39Packages.packaging
      nixos-unstable.python39Packages.pytorchWithCuda
    ];
    src = nixos-unstable.python39Packages.fetchPypi {
      inherit version pname;
      sha256 = "af03334c4a33fc32a9a40b037b1ce3ff6273ea9a0050c11ddde29bf1335da95e";
    };
    version = "0.7.2";
  };

  pyDeprecate = nixos-unstable.python39Packages.buildPythonPackage rec {
    pname = "pyDeprecate";
    propagatedBuildInputs = [
    ];
    src = nixos-unstable.python39Packages.fetchPypi {
      inherit version pname;
      sha256 = "d481116cc5d7f6c473e7c4be820efdd9b90a16b594b350276e9e66a6cb5bdd29";
    };
    version = "0.3.2";
  };

  pytorch-lightning = nixos-unstable.python39Packages.buildPythonPackage rec {
    pname = "pytorch-lightning";
    #doCheck = false;
    patchPhase = ''
      echo "### patchPhase"
      substituteInPlace requirements.txt --replace "setuptools==" "setuptools<="
      substituteInPlace requirements.txt --replace "pyDeprecate==" "pyDeprecate>="
    '';
    propagatedBuildInputs = [
     pyDeprecate
      torchmetrics
      #nixos-unstable.python39Packages.pytorchWithCuda
      #nixos-unstable.python39Packages.pytorch
      nixos-unstable.python39Packages.tqdm
      nixos-unstable.python39Packages.fsspec
      nixos-unstable.python39Packages.setuptools
    ];
    src = nixos-unstable.python39Packages.fetchPypi {
      inherit version pname;
      sha256 = "119e5a0ad0678444c0bbf95755da571e5e372ab12df7c6115ddd26e364a8ddfa";
    };
    version = "1.5.10";
  };

  kornia = nixos-unstable.python39Packages.buildPythonPackage rec {
    pname = "kornia";
    doCheck = false;
    propagatedBuildInputs = [
      nixos-unstable.python39Packages.pytest-runner
      nixos-unstable.python39Packages.pytest
      nixos-unstable.python39Packages.packaging
      nixos-unstable.python39Packages.pytorchWithCuda
      #nixos-unstable.python39Packages.pytorch
    ];
    src = nixos-unstable.python39Packages.fetchPypi {
      inherit version pname;
      sha256 = "0b689b5a47f55f2b08f61e6731760542cc3e3c09c3f0498164b934a3aef0bab3";
    };
    version = "0.6.3";
  };

  resmem = nixos-unstable.python39Packages.buildPythonPackage rec {
    pname = "resmem";
    propagatedBuildInputs = [
      nixos-unstable.python39Packages.pytorchWithCuda
      torchvision
    ];
    src = nixos-unstable.python39Packages.fetchPypi {
      inherit version pname;
      sha256 = "aee37b5c1eab321475d748e6d4c904d7c24bc4372cc51a4c193939af6902147f";
    };
    version = "1.1.4";
  };

  ninja = nixos-unstable.python39Packages.buildPythonPackage rec {
    pname = "ninja";
    doCheck = false;
    propagatedBuildInputs = [
      nixos-unstable.python39Packages.scikit-build
    ];
    src = nixos-unstable.python39Packages.fetchPypi {
      inherit version pname;
      sha256 = "e1b86ad50d4e681a7dbdff05fc23bb52cb773edb90bc428efba33fa027738408";
    };
    version = "1.10.2.3";
  };

  torchvision = nixos-unstable.python39Packages.buildPythonPackage rec {
    pname = "torchvision";
    doCheck = false;
    nativeBuildInputs = [
      nixos-unstable.which
      nixos-unstable.python39Packages.pytorchWithCuda
      nixos-unstable.python39Packages.ha-ffmpeg
      nixos-unstable.python39Packages.ffmpeg-python
      #nixos-unstable.python39Packages.ha-ffmpeg
      #ninja
      #nixos-unstable.python39Packages.torchvision
    ];
    propagatedBuildInputs = [
      #ninja
      #nixos-unstable.python39Packages.torchvision
    ];
    patchPhase = ''
      echo "### patchPhase"
      echo substituteInPlace setup.py --replace '"build_ext"' '"build_ext2"'
      echo cat setup.py
    '';
#    dontUseSetuptoolsCheck = true;
#    doInstallCheck = false;

#    src = builtins.fetchTarball {
#      url = "https://github.com/pytorch/vision/archive/refs/tags/v0.12.0.tar.gz";
#      sha256 = "0chjd6zs46136sg65z1c2g07a534dg72xpy20s3bx1prwmvyxp5v";
#    };

    src = builtins.fetchTarball {
      url = "https://github.com/pytorch/vision/archive/refs/tags/v0.11.3.tar.gz";
      sha256 = "08kbdaa6qdsp4qz8qvw8p4hkm4v2791pl8nhl45y0wwlpqk795cw";
    };



#    src = nixos-unstable.python39Packages.fetchPypi {
#      inherit version pname;
#      format = "wheel";
#      python = "cp39";
#      abi = "cp39";
#      #dist = "fc/68/398ce995940b5534fc28ef1c9612005fcf58785c31b03eb26ca183f9fc19";
#      platform = "manylinux1_x86_64";
#
##torchvision-0.12.0-cp39-cp39-manylinux1_x86_64.whl (
##https://files.pythonhosted.org/packages/fc/68/398ce995940b5534fc28ef1c9612005fcf58785c31b03eb26ca183f9fc19/torchvision-0.12.0-cp39-cp39-manylinux1_x86_64.whl
#      #hash = "398ce995940b5534fc28ef1c9612005fcf58785c31b03eb26ca183f9fc19";
#      sha256 = "49ed7886b93b80c9733462edd06a07f8d4c6ea4d5bd2894e7268f7a3774f4f7d";
#    };
#    src = nixos.fetchFromGitHub {
#        owner = "pytorch";
#        repo = "vision";
#        rev = "main";
#        sha256 = "12kdk4gy4a3ai1dlhasd9v2dcw4sf0yx3w69s877wgmbzz41c7cz";
#      };
    version = "0.11.3";

  };

  clip = nixos-unstable.python39Packages.buildPythonPackage rec {
    pname = "clip";
    #doCheck = false;
    propagatedBuildInputs = [
      torchvision
      nixos-unstable.python39Packages.pytorchWithCuda
#      nixos-unstable.python39Packages.torchvision
      nixos-unstable.python39Packages.tqdm
      nixos-unstable.python39Packages.ftfy
      nixos-unstable.python39Packages.regex
    ];
    src = nixos.fetchFromGitHub {
        owner = "openai";
        repo = "CLIP";
        rev = "master";
        sha256 = "1nwirs42qnjzl4wl3janmmh0rd8y3p8ylaykzsa37clph610gly4";
      };
    version = "1.0";
  };

  pixray = nixos-unstable.python39Packages.buildPythonPackage rec {
    pname = "pixray";
    doCheck = false;
    propagatedBuildInputs = [
      clip
      kornia
      torch-optimizer
      perlin-numpy
      torchvision
      pytorch-lightning
      resmem
      nixos-unstable.python39Packages.imageio
      nixos-unstable.python39Packages.braceexpand
      nixos-unstable.python39Packages.pyyaml
      nixos-unstable.python39Packages.omegaconf
      nixos-unstable.python39Packages.pillow
      nixos-unstable.python39Packages.einops
      nixos-unstable.python39Packages.pytorchWithCuda
      nixos-unstable.python39Packages.colorthief

      #nixos-unstable.python39Packages.aphantasia
      #nixos-unstable.python39Packages.pydiffvg
      #nixos-unstable.python39Packages.basicsr

      nixos-unstable.libpng
      nixos-unstable.libjpeg

    ];
    patchPhase = ''
      echo "### patchPhase"
      echo rm -rf requirements.txt

      substituteInPlace slip.py --replace "from tokenizer" "from simple_tokenizer"
      substituteInPlace slip.py --replace "import utils" ""
      echo 'from setuptools import setup, find_packages
      setup(
          name="pixray",
          version="1.0",
          packages=find_packages("."),
          package_dir={"":"."},
          zip_safe = True,
          entry_points={
              "console_scripts": [
                  "pixray=pixray.main:main",
              ],
          },
      )' > setup.py
    '';
    src = nixos.fetchFromGitHub {
        owner = "pixray";
        repo = "pixray";
        rev = "master";
        sha256 = "1jzq3n31aqfcz82x7mpjrk9gna8f5sifkdjfjqmzrfqzdfx8vmdb";
      };
#    src = nixos.fetchFromGitHub {
#        owner = "dribnet";
#        repo = "pixray";
#        rev = "master";
#        sha256 = "0qgkf8cdlkmqxhjxrh1jy8crwlpbcw1h3zhxfk5ambrd7phgbs1h";
#      };
    version = "1.0";
  };

in
  mach-nix.nixpkgs.mkShell {
    buildInputs = [
#      clip
#      torch-optimizer
#      pytorch-lightning
#
#      nixos-unstable.python39Packages.colorthief
#      resmem

      cleanipynb
      pixray

#      perlin-numpy
#      #torchmetrics

#      clip
#      kornia
#      perlin-numpy
#      torch-optimizer
#      torchvision
#      nixos-unstable.python39Packages.braceexpand
#      nixos-unstable.python39Packages.colorthief
#      nixos-unstable.python39Packages.omegaconf

      #nixos-unstable.python39Packages.tqdm #clip

#      #nixos-unstable.python39Packages.torchvision
#      nixos-unstable.python39Packages.ftfy
#      nixos-unstable.python39Packages.imageio
#      nixos-unstable.python39Packages.einops
#      #nixos-unstable.python39Packages.pytorch-lightning
#      #nixos-unstable.python39Packages.pytorchWithCuda
    ];

    shellHook = ''
      jupyter notebook
    '';
  }
