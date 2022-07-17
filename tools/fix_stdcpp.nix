# Useful when some python libs need throw runtime errors like:
#
# error while loading shared libraries: libstdc++.so.6: cannot open shared object file: No such file or directory
#
# Example usage:
#
# nix-shell --command "python synthetic_performance.py --dir data/ -n 300 -m 2500 -k 300 -l 0"

with import <nixpkgs> { };

let python = python39;
in pkgs.mkShell {
  name = "pip-env";
  buildInputs = with pkgs; [
    python39Packages.ipython
    python39Packages.virtualenv
    git
    bash
    docker
  ];
  src = null;
  shellHook = ''
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [ stdenv.cc.cc ]}

    VENV=venv
    if test ! -d $VENV; then
      python -m venv $VENV
    fi
    source ./$VENV/bin/activate
    #pip install -r requirements.txt
  '';
}
