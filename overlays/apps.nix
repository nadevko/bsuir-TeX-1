final: prev: {
  bsuir-xelatex = final.writeShellApplication {
    name = "bsuir-xelatex";
    runtimeInputs = final.bsuir-tex-shell.nativeBuildInputs;
    text = ''
      xelatex -synctex=1 -interaction=nonstopmode -file-line-error -shell-escape "$@"
    '';
  };
}
