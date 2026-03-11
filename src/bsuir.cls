\NeedsTeXFormat{LaTeX2e}[2022-06-01]
\ProvidesExplClass
{bsuir}
{2026-03-11}
{0.3}
{BSUIR Enterprise Standard (UDG) 01-2024 implementation}

\tl_new:N \g_bsuir_udg_tl
\tl_new:N \g_bsuir_type_tl

\msg_new:nnnn { bsuir } { unknown-choice }
{
  Invalid~value~'#3'~for~key~'#1'. \\
  Available~options~for~'#1'~are:~#2.
}
{
  You~tried~to~set~#1=#3.~This~is~not~allowed.
}

\keys_define:nn { bsuir }
{
  udg .choices:nn = { 01-2024 }
  { \tl_gset:Nn \g_bsuir_udg_tl { \l_keys_choice_tl } },
  udg / unknown .code:n = {
    \msg_fatal:nnnnn { bsuir } { unknown-choice }
    { udg } { 01-2024 } { #1 }
  },
  udg .initial:n = 01-2024,

  doctype .choices:nn = { report, lab, assignment, coursework,
  thesis, research }
  { \tl_gset:Nn \g_bsuir_type_tl { \l_keys_choice_tl } },
  doctype / unknown .code:n = {
    \msg_fatal:nnnnn { bsuir } { unknown-choice }
    { doctype } { report,~lab,~assignment,~coursework,~thesis,~research } { #1 }
  },
  doctype .initial:n = lab,

  unknown .code:n = {
    \PassOptionsToClass { \CurrentOption } { scrreprt }
  }
}

\ProcessKeyOptions [ bsuir ]

\LoadClass[
  fontsize=14pt,
  oneside,
  numbers=noenddot,
  captions=tableheading,
  toc=graduated
]{scrreprt}

\ExplSyntaxOff

\RequirePackage[
  a4paper,
  left=30mm,
  right=15mm,
  top=20mm,
  bottom=20mm,
  footskip=10mm
]{geometry}

\RequirePackage[babelshorthands]{polyglossia}

\setmainlanguage{russian}
\setotherlanguage[variant=british]{english}
\setotherlanguage{belarusian}

\setlanguagealias{belarusian}{be}
\setlanguagealias{russian}{ru}
\setlanguagealias[variant=british]{english}{en}

\newfontfamily{\cyrillicfont}{Times New Roman}[Ligatures=TeX]
\newfontfamily{\cyrillicfontrm}{Times New Roman}[Ligatures=TeX]
\newfontfamily{\cyrillicfontsf}{Arial}[Ligatures=TeX]
\newfontfamily{\cyrillicfonttt}{Courier New}[Ligatures=TeX]

\setmainfont{Times New Roman}[Ligatures=TeX]
\setsansfont{Arial}[Ligatures=TeX]
\setmonofont{Courier New}[Ligatures=TeX]

\endinput
