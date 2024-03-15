% meta
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bsuir}[2024/02/14 BSUIR ENSTD 2017 compatible class]
\RequirePackage{xparse}
\RequirePackage{tabularx}
\RequirePackage{kvoptions}
\RequirePackage{ifthen}
\RequirePackage{calc}

\newcommand{\ifeqfal}[3]{\ifthenelse{\equal{#1}{#2}}{#3}}
\newcommand{\ifeqesc}[3]{\ifthenelse{\equal{#1}{#2}}{#3}{}}
\newcommand{\falcase}[2]{#1 #2}
\newcommand{\esccase}[2]{#1 #2}
\newenvironment{switch}[1]{
    \renewcommand{\falcase}{\ifeqfal{#1}}
    \renewcommand{\esccase}{\ifeqesc{#1}}
}{}

% base class, font size, A4 geometry, margins
\LoadClass[14pt, final, onecolumn, oneside, titlepage, openany]{extreport}
\RequirePackage[a4paper, top=20mm, bottom=27mm, left=30mm, right=15mm, footskip=17mm]{geometry}
\linespread{1.1}
\setlength{\parindent}{1.25cm}

% language and fonts
\RequirePackage[main=russian, english]{babel}
\babelfont{rm}{Times New Roman}
\babelfont{sf}{Times New Roman}
\babelfont{tt}{Courier New}
\RequirePackage{csquotes}
\addto\captionsrussian{
    \renewcommand{\contentsname}{Содержание}
}

% links
% warning after change toc style
\RequirePackage[hidelinks, unicode]{hyperref}
\usepackage{bookmark}

% page numbering
\RequirePackage{fancyhdr}
\fancypagestyle{plain}{
    \fancyhf{}
    \rfoot{\underline{\thepage}}
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
}
\pagestyle{plain}

% headers
\RequirePackage{titlesec}
\NewDocumentCommand{\bsuirtitle}{m O{} O{} m O{\baselineskip}}{
    \titleformat{name=#1}[hang]{\raggedright\bfseries#2}{#4}{\wordsep}{#3}
    \titleformat{name=#1,numberless}{\bfseries#2}{}{0pt}{}
    \titlespacing{name=#1}{\parindent}{#5}{\baselineskip}
    \titlespacing{name=#1,numberless}{\parindent}{#5}{\baselineskip}
}
\bsuirtitle{\chapter}[\fontsize{16}{\baselineskip}\MakeUppercase]{\thechapter}[0pt]
\bsuirtitle{\section}{\thesection}
\bsuirtitle{\subsection}{\thesubsection}
\bsuirtitle{\subsubsection}{\thesubsubsection}
\setcounter{secnumdepth}{3}

% class options
\SetupKeyvalOptions{
    family=KVO,
    prefix=KVO@
}
\DeclareStringOption[labwork]{variant}
\ProcessKeyvalOptions{KVO}

% variant validation
\begin{switch}{\KVO@variant}
    \falcase{labwork}{}{
        \falcase{courcework}{}{
            \falcase{diplomawork}{}{
                \ClassError{bsuir}{
                    Unknown variant. Use one of: labwork, courcework
                }{
                    \KVO@variant variant not available
                }}}}
\end{switch}

% titlepage template values
\newcommand{\faculty}[1]{\def\@faculty{#1}}
\newcommand{\departmentlong}[1]{\def\@departmentlong{#1}}
\newcommand{\departmentshort}[1]{\def\@departmentshort{#1}}
\newcommand{\departmentmanager}[1]{\def\@departmentmanager{#1}}
\newcommand{\worktitle}[1]{\def\@worktitle{#1}}
\newcommand{\workcode}[1]{\def\@workcode{#1}}
\newcommand{\titlepageyear}[1]{\def\@titlepageyear{#1}}

% titlepage template
\renewcommand{\maketitle}[2]{
    \begin{titlepage}
        \centering
        Министерство образования Республики Беларусь\\
        [\the\baselineskip]
        Учреждение образования\\
        \MakeUppercase{
            Белорусский Государственный Университет\\
            Информатики и Радиоэлектроники
        }\\
        [\the\baselineskip]

        \ifeqfal{\KVO@variant}{labwork}{
        Кафедра \@departmentlong\\
        [\dimexpr\the\baselineskip * 3]
        }{
        \raggedright
        \begin{tabular}{l l}
            Факультет & \@faculty        \\
            Кафедра   & \@departmentlong
        \end{tabular}\\
        [\the\baselineskip]
        }

        \ifeqfal{\KVO@variant}{diplomawork}{
        \raggedleft
        \begin{tabular}{l}
            \textit{К защите допустить}:          \\\\
            Заведующий кафедрой \@departmentshort \\
            \hrulefill \@departmentmanager
        \end{tabular}\\
        [\the\baselineskip]
        }{
        ~\\[\dimexpr\the\baselineskip * 4]
        }

        \ifeqfal{\KVO@variant}{labwork}{
        Лабораторная работа \textnumero\@workcode\\
        \textquote{\@worktitle}\\
        [\dimexpr\the\baselineskip * 7]
        }{
        \centering
        \MakeUppercase{Пояснительная записка}\\
        \begin{switch}{\KVO@variant}
            \esccase{courcework}{к курсовой работе}
            \esccase{diplomawork}{к дипломной работе}
        \end{switch}\\
        на тему\\
        [\the\baselineskip]
        \textbf{\MakeUppercase{\@worktitle}}\\
        [\the\baselineskip]
        \@workcode\\
        [\the\baselineskip]
        }

        \begin{tabular}{l}
            #1
        \end{tabular}\hfill
        \begin{tabular}{l}
            #2
        \end{tabular}

        \vfill
        \centering
        Минск \@titlepageyear
    \end{titlepage}
    \stepcounter{page}
}

% table of contents
\RequirePackage{titletoc}

\titlecontents{chapter}[0pt]{}{\contentslabel{12pt}}{\hspace*{-12pt}}{\titlerule*[4pt]{.}\thecontentspage}
\titlecontents{section}[24pt]{}{\contentslabel{24pt}}{\hspace*{-24pt}}{\titlerule*[4pt]{.}\thecontentspage}

\let\oldtableofcontents\tableofcontents
\renewcommand{\tableofcontents}{
    \bsuirtitle{\chapter}[\centering\fontsize{16}{\baselineskip}\MakeUppercase]{\thechapter}[0pt]
    \oldtableofcontents
    \let\chapter\chapterwithasteriskintoc
    \bsuirtitle{\chapter}[\fontsize{16}{\baselineskip}\MakeUppercase]{\thechapter}[0pt]
}
\setcounter{tocdepth}{1}
\let\oldchapter\chapter
\NewDocumentCommand{\chapterwithasteriskintoc}{s m}{
    \IfBooleanTF{#1}{
        \oldchapter*{#2}
        \addcontentsline{toc}{chapter}{#2}
    }{
        \oldchapter{#2}
    }
}
