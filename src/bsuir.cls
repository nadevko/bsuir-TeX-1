\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bsuir}[2024/02/14 BSUIR Ultra-Compact]

\LoadClass[14pt,final,onecolumn,oneside,titlepage,openany]{extreport}
\RequirePackage[a4paper,left=30mm,bottom=27mm,right=15mm,top=20mm,footskip=17mm]{geometry}
\linespread{1.1} \setlength{\parindent}{1.25cm}

\RequirePackage{expl3, xparse, xcoffins, etoolbox}
\ExplSyntaxOn

\str_new:N \l_bsuir_variant_str
\keys_define:nn { bsuir } { variant .choices:nn = { custom, labwork, courcework, diploma, practice } { \str_set:Nn \l_bsuir_variant_str { \l_keys_choice_tl } }, variant .initial:n = custom }
\ProcessKeysOptions { bsuir }

\prop_new:N \g_data \cs_new:Npn \getf #1 { \prop_item:Nn \g_data {#1} }
\clist_map_inline:nn { faculty, departmentlong, departmentshort, manager, worktitle, workcode, titlepageyear, titleright, titleleft, group, student } {
    \exp_args:Nc \NewDocumentCommand {#1} { m } { \prop_gput:Nnn \g_data {#1} {##1} }
}

\cs_new_protected:Npn \bsuir_make_title: {
    \begin{titlepage}
        \NewCoffin \Canvas \NewCoffin \Block
        \SetVboxCoffin \Canvas { \textwidth } {
            \centering Министерство~образования~РБ \\ УО~«БГУИР» \\ \MakeUppercase{ БГУИР } \\[\baselineskip]
            \str_if_eq:VnTF \l_bsuir_variant_str { diploma } { \raggedright Факультет:~\getf{faculty} \\ Кафедра:~\getf{departmentlong} } { Кафедра~\getf{departmentlong} }
        }
        \str_if_eq:VnT \l_bsuir_variant_str { diploma } {
            \SetHorizontalCoffin \Block { \raggedleft \begin{tabular}{l} К~защите~допустить: \\ Зав.~кафедрой~\getf{departmentshort} \\ \hrulefill~\getf{manager} \end{tabular} }
            \JoinCoffins \Canvas [r,t] \Block [r,t] (0pt, -\baselineskip)
        }
        \SetVboxCoffin \Block { \textwidth } {
            \vspace{ \str_if_eq:VnTF \l_bsuir_variant_str { diploma } { \baselineskip } { 4\baselineskip } }
            \centering \bfseries \MakeUppercase {
                \str_case:VnF \l_bsuir_variant_str {
                    { practice } { Отчет~по~учебной~практике }
                    { labwork } { Лабораторная~работа~\textnumero \getf{workcode} }
                } { Пояснительная~записка }
            } \\ \str_case:Vn \l_bsuir_variant_str { {courcework}{к~курсовой~работе} {diploma}{к~дипломной~работе} } \par \vspace{\baselineskip}
            \MakeUppercase{\getf{worktitle}}
        }
        \JoinCoffins \Canvas [hc,b] \Block [hc,t]
        \SetVboxCoffin \Block { \textwidth } {
            \vspace{ \str_if_eq:VnTF \l_bsuir_variant_str { diploma } { 3\baselineskip } { 6\baselineskip } }
            \str_if_eq:VnTF \l_bsuir_variant_str { practice } 
            { Студент~гр.~\getf{group} \hfill \getf{student} \\ Рук.~от~кафедры \hfill \getf{manager} }
            { \getf{titleleft} \hfill \getf{titleright} }
        }
        \JoinCoffins \Canvas [hc,b] \Block [hc,t]
        \TypesetCoffin \Canvas \vfill \centering Минск,~\getf{titlepageyear}
    \end{titlepage} \stepcounter{page}
}
\RenewDocumentCommand{\maketitle}{} { \bsuir_make_title: }

\RequirePackage[main=russian,english]{babel}
\RequirePackage[hidelinks,unicode,bookmarksdepth=3,breaklinks]{hyperref}
\RequirePackage[aboveskip=1.2\baselineskip,belowskip=-0.3\baselineskip]{caption}
\clist_map_inline:nn { xurl, pdfpages, csquotes, bookmark, subcaption, float, graphicx, svg, minted, longtable, fancyhdr, enumitem, bsuir-sectioning } { \RequirePackage{#1} }

\babelfont{rm}{Times New Roman} \babelfont{tt}{Courier New}
\captionsetup{labelsep=endash} \captionsetup[figure]{name=Рисунок, justification=centering}

\NewDocumentCommand{\makefigure}{O{img} m m}{ \begin{figure}[H] \centering #3 \label{#1:#2} \end{figure} }
\NewDocumentCommand{\makeimage}{o m O{width=\textwidth}}{ \makefigure{#2}{ \includegraphics[#3]{#2} \IfValueT{#1}{\caption{#1}} } }
\NewDocumentCommand{\makesvg}{o m O{width=\textwidth}}{ \makefigure{#2}{ \includesvg[inkscapelatex=false,#3]{#2} \IfValueT{#1}{\caption{#1}} } }

\setminted{fontsize=\small, tabsize=2, breaklines, breakanywhere}
\AtBeginEnvironment{document}{ \makeatletter \let\c@figure\c@listing \makeatother \renewcommand{\thelisting}{\arabic{chapter}.\arabic{listing}} }
\NewDocumentCommand{\makelisting}{m o}{ \begin{center} \captionsetup{type=listing, name=Рисунок} \inputminted{text}{#1} \IfValueT{#2}{\caption{#2}} \end{center} }

\setlist{nosep, leftmargin=1.5\parindent} \setlist[itemize]{label=--}
\fancypagestyle{plain}{ \fancyhf{} \rfoot{\underline{\thepage}} \renewcommand{\headrulewidth}{0pt} }
\pagestyle{plain} \bibliographystyle{ugost2003}
\ExplSyntaxOff