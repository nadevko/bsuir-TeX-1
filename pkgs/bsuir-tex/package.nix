{
  stdenvNoCC,
  writeShellScript,
  lib,
  texlive,
  corefonts,
}:
stdenvNoCC.mkDerivation {
  pname = "bsuir-tex";
  version = "0.1.0";

  outputs = [ "tex" ];
  passthru.tlDeps = with texlive; [
    amsmath
    appendix
    babel-belarusian
    babel-english
    babel-russian
    biber
    biblatex
    biblatex-gost
    caption
    collection-basic
    collection-langcyrillic  # Hyphenation patterns for Russian/Belarusian
    enumitem
    eso-pic
    fontspec
    geometry
    graphics
    hyphenat
    hyphen-belarusian  # Belarusian hyphenation patterns
    hyphen-russian  # Russian hyphenation patterns
    koma-script
    l3kernel
    l3packages
    listings
    mathtools
    microtype
    pdfpages
    pgf
    piton
    setspace
    svg
    tabularray
    unicode-math
    setspaceenhanced
    scrhack
    lualatex-math
    transparent
    ninecolors
    luacode
    csquotes
    filecontents
    corefonts
    stix2-otf
  ];

  src = ../../src;

  nativeBuildInputs = [
    (writeShellScript "force-tex-output.sh" ''
      out="$${tex-}"
    '')
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir --parents $tex/tex/lualatex/bsuir
    cp $src/* $tex/tex/lualatex/bsuir
  '';

  meta = with lib; {
    description = "LaTeX class for BSUIR thesis compliant with STP 01-2024 standard";
    longDescription = ''
      Modular LaTeX class for formatting thesis according to BSUIR
      technical requirements (STP 01-2024). Uses LuaLaTeX engine with modern
      packages (LaTeX3, KOMA-Script, unicode-math, tabularray) for full compliance
      with GOST standards including typography, formulas, tables, figures, and
      bibliography formatting.
    '';
    homepage = "https://github.com/nadevko/bsuir-TeX-1";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
