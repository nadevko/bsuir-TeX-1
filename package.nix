{
  stdenvNoCC,
  writeShellScript,
  lib,
  texlive,
}:
stdenvNoCC.mkDerivation {
  pname = "bsuir-tex";
  version = "0.2-alpha";

  outputs = [ "tex" ];
  passthru.tlDeps = with texlive; [
    babel-belarusian
    babel-english
    babel-russian
    breqn
    catchfile
    csquotes
    enumitem
    hyphenat
    ifmtarg
    makecell
    minted
    multirow
    pgfplots
    svg
    titlesec
    transparent
    trimspaces
    upquote
    xifthen
    xurl
  ];

  src = ./src;

  nativeBuildInputs = [
    (writeShellScript "force-tex-output.sh" ''
      out="$${tex-}"
    '')
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir --parent $tex/tex/xelatex
    cp $src/* $tex/tex/xelatex
  '';

  meta = with lib; {
    description = "XeLaTeX implementation of BSUIR CoS";
    homepage = "https://github.com/nadevko/bsuir-TeX-1";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
