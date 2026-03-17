\NeedsTeXFormat{LaTeX2e}[2022-06-01]
\ProvidesExplClass
{bsuir}
{2026-03-12}
{0.4}
{expl3 BSUIR Enterprise Standard (UDG) 01-2024 implementation}

\tl_new:N \g_bsuir_style_tl
\tl_new:N \g_bsuir_type_tl
\tl_new:N \g_bsuir_equationnumbering_tl

\msg_new:nnnn { bsuir } { unknown-choice }
{ Invalid value '#3' for key '#1'. \\ Available options for '#1' are: #2. }
{ You tried to set #1=#3. This is not allowed. }


\keys_define:nn { bsuir }
{
	style .choices:nn = { 01-2024 }
		{ \tl_gset:Nn \g_bsuir_style_tl { \l_keys_choice_tl } },
	style / unknown .code:n =
		{ \msg_fatal:nnnnn { bsuir } { unknown-choice } { style } { 01-2024 } {#1} },
	style .initial:n = 01-2024,

	type .choices:nn = { report, lab, assignment, coursework, thesis, research }
		{ \tl_gset:Nn \g_bsuir_type_tl { \l_keys_choice_tl } },
	type / unknown .code:n =
		{ \msg_fatal:nnnnn { bsuir } { unknown-choice }
			{ type } { report,~lab,~assignment,~coursework,~thesis,~research } {#1} },
	type .initial:n = lab,

	equationnumbering .choices:nn = { global, bychapter }
		{ \tl_gset:NV \g_bsuir_equationnumbering_tl \l_keys_choice_tl },
	equationnumbering / unknown .code:n =
		{ \msg_fatal:nnnnn { bsuir } { unknown-choice }
			{ equationnumbering } { global,~bychapter } {#1} },

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

% Set default equationnumbering based on type, unless user set it explicitly.
\bool_set:Nn \l_tmpa_bool
{
	\str_if_eq_p:Vn \g_bsuir_type_tl { thesis } ||
	\str_if_eq_p:Vn \g_bsuir_type_tl { coursework }
}

\RequirePackage{bsuir-lang}
\RequirePackage{bsuir-page}
\RequirePackage{bsuir-headings}
\RequirePackage{bsuir-itemisation}
\RequirePackage{bsuir-equations}

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

\bool_if:NTF \l_tmpa_bool
{ \bsuir_headings_use_full: }
{ \bsuir_headings_use_short: }

% Apply equationnumbering: user choice takes priority, then type-based default.
\tl_if_empty:NTF \g_bsuir_equationnumbering_tl
{
	\bool_if:NTF \l_tmpa_bool
	{ \bsuir_equations_numbering_bychapter: }
	{ \bsuir_equations_numbering_global: }
}
{
	\str_if_eq:VnTF \g_bsuir_equationnumbering_tl { global }
	{ \bsuir_equations_numbering_global: }
	{ \bsuir_equations_numbering_bychapter: }
}

\endinput