\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\RequirePackage{l3keys2e}

\ProvidesExplClass
  {bsuir}
  {2026-03-11}
  {0.3}
  {BSUIR University Document Standard (UDG) 01-2024 implementation}

\ExplSyntaxOn
\tl_new:N \g_bsuir_udg_tl
\tl_new:N \g_bsuir_type_tl

\tl_gset:Nn \g_bsuir_udg_tl {01-2024}
\tl_gset:Nn \g_bsuir_type_tl {coursework}

\keys_define:nn { bsuir }{
  udg .choices:nn = {01-2024} { \tl_gset:Nn \g_bsuir_udg_tl {#1} },
  doctype .choices:nn = {coursework,lab,thesis} { \tl_gset:Nn \g_bsuir_type_tl {#1} },
  unknown .code:n = { \PassOptionsToClass{#1}{scrreprt} }
}

\ProcessKeysOptions{bsuir}
\ExplSyntaxOff

\LoadClass[
  fontsize=14pt,
  oneside,
  numbers=noenddot,
  captions=tableheading,
  toc=graduated
]{scrreprt}

\endinput
