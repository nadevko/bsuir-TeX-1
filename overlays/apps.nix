final: prev: {
  bsuir-tex-build = final.writeShellApplication {
    name = "bsuir-xelatex";
    runtimeInputs = final.bsuir-tex-shell.nativeBuildInputs;
    text = ''
      lualatex -interaction=nonstopmode -halt-on-error -file-line-error "''${1:-report.tex}"
    '';
  };
}
