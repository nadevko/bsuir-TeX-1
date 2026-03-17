\NeedsTeXFormat{LaTeX2e}[2022-06-01]
\ProvidesExplClass
{bsuir}
{2026-03-12}
{0.3}
{expl3 BSUIR Enterprise Standard (UDG) 01-2024 implementation}

\tl_new:N \g_bsuir_udg_tl
\tl_new:N \g_bsuir_type_tl

\msg_new:nnnn { bsuir } { unknown-choice }
{ Invalid value '#3' for key '#1'. \\ Available options for '#1' are: #2. }
{ You tried to set #1=#3. This is not allowed. }

\keys_define:nn { bsuir }
{
  udg .choices:nn = { 01-2024 }
  { \tl_gset:Nn \g_bsuir_udg_tl { \l_keys_choice_tl } },
  udg / unknown .code:n =
  { \msg_fatal:nnnnn { bsuir } { unknown-choice } { udg } { 01-2024 } {#1} },
  udg .initial:n = 01-2024,

  doctype .choices:nn = { report, lab, assignment, coursework,
  thesis, research }
  { \tl_gset:Nn \g_bsuir_type_tl { \l_keys_choice_tl } },
  doctype / unknown .code:n =
  { \msg_fatal:nnnnn { bsuir } { unknown-choice }
  { doctype } { report,~lab,~assignment,~coursework,~thesis,~research } {#1} },
  doctype .initial:n = lab,

  unknown .code:n = { \PassOptionsToClass {#1} { scrreprt } },
}

\ProcessKeyOptions [ bsuir ]
\cs_set:Npn \baselinestretch { 1.25 }
\dim_gset:Nn \parindent { 1.25cm }

\LoadClass[
  fontsize=14pt,
  oneside,
  numbers=noenddot,
  captions=tableheading,
  toc=chapterentrydotfill,
]{scrreprt}

\RequirePackage[
  a4paper,
  left=30mm,
  right=15mm,
  top=20mm,
  bottom=20mm,
  footskip=10mm,
]{geometry}

\RequirePackage[tbtags]{amsmath}
\RequirePackage[math-style=upright]{unicode-math}
\RequirePackage{bsuir-lang}

\setmathfont{XITS Math}
\setmathrm{XITS Math}
\setmathfont{Times New Roman}[range=up/{latin,Latin,greek,Greek,num}]

\RequirePackage{scrlayer-scrpage}

\use:c { AtBeginDocument }
{
  \use:c { pagestyle } { scrheadings }
  \use:c { clearpairofpagestyles }
  \use:c { ofoot* } { \use:c { pagemark } }
}

\RequirePackage[
  unicode,
  bookmarksopen=true,
  bookmarksnumbered=true,
  pdfstartview=FitH,
  hidelinks,
]{hyperref}
\RequirePackage{bookmark}
\RequirePackage{bsuir-typography}
\RequirePackage{bsuir-headings}

\pdfstringdefDisableCommands
{ \cs_set:Npn \bsuir@tocnum #1 { #1 \space } }

\msg_new:nnn { bsuir } { subsubsection-not-allowed }
{ \token_to_str:N \subsubsection \ is~not~allowed~for~this~document~type! }

\cs_new_protected:Npn \bsuir_headings_use_full:
{
  \bsuir_declare_chapter:N \chapter
  \bsuir_declare_section:N  \section
  \bsuir_declare_runin:Nnn  \subsection    {true}  {true}
  \bsuir_declare_runin:Nnn  \subsubsection {false} {false}
}

\cs_new_protected:Npn \bsuir_headings_use_short:
{
  \bsuir_declare_section:N  \chapter
  \bsuir_declare_runin:Nnn  \section    {true}  {true}
  \bsuir_declare_runin:Nnn  \subsection {false} {false}
  \RenewDocumentCommand \subsubsection { o m }
  { \msg_error:nn { bsuir } { subsubsection-not-allowed } }
}

\bool_lazy_or:nnTF
{ \str_if_eq_p:Vn \g_bsuir_type_tl { thesis } }
{ \str_if_eq_p:Vn \g_bsuir_type_tl { coursework } }
{ \bsuir_headings_use_full: }
{ \bsuir_headings_use_short: }

\endinput
