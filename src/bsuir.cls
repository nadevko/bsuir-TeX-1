%%% metadata
% define class
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bsuir}[2024/02/14 BSUIR ENSTD 2017 compatible class]
% configure paper and margins
\LoadClass[14pt, final, onecolumn, oneside, titlepage, openany]{extreport}
\RequirePackage[a4paper, top=20mm, bottom=27mm, left=30mm, right=15mm, footskip=17mm]{geometry}
\linespread{1.1}
\setlength{\parindent}{1.25cm}

%%% language
% translations
\RequirePackage[main=russian, english]{babel}
% fonts
\babelfont{rm}{Times New Roman}
\babelfont{sf}{Times New Roman}
\babelfont{tt}{Courier New}

%%% misc
% to merge other pdf files into document
\RequirePackage{pdfpages}
% fancy quotes
\RequirePackage{csquotes}
% enable links
\RequirePackage[hidelinks, unicode]{hyperref}
\RequirePackage{bookmark}
% bibliography
\bibliographystyle{ugost2003}

%%% page numbering
\RequirePackage{fancyhdr}
% define style
\fancypagestyle{plain}{
    % clean styles
    \fancyhf{}
    % new style
    \rfoot{\underline{\thepage}}
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
}
\pagestyle{plain}

%%% headers
\RequirePackage[clearempty,newlinetospace]{titlesec}
% for ...DocumentCommand
\RequirePackage{xparse}
% \bsuirtitle
\NewDocumentCommand{\bsuirtitle}{
    m % heading to modify
    O{} % usual title formatting
    O{} % additional numberless title formatting
    m % label formatting
    O{\baselineskip} % vertical indent before (remove from chapters)
}{
    % usual
    \titleformat{name=#1}{\bfseries#2}{#4}{\wordsep}{}
    \titlespacing{name=#1}{\parindent}{#5}{\baselineskip}
    % without number
    \titleformat{name=#1,numberless}{#3\bfseries#2}{}{0pt}{}
    \titlespacing{name=#1,numberless}{\parindent}{#5}{\baselineskip}
}
% set formatting
\bsuirtitle{\section}[\MakeUppercase]{\thesection}
\bsuirtitle{\subsection}{\thesubsection}
\bsuirtitle{\subsubsection}{\thesubsubsection}
% numbering depth
\setcounter{secnumdepth}{3}

%%% table of contents
\RequirePackage{titletoc}
% toc style for its parts
\titlecontents{section}[24pt]{}{\contentslabel{24pt}}{\hspace*{-24pt}}
{\titlerule*[4pt]{.}\thecontentspage}
% toc counter
\setcounter{tocdepth}{3}
% excludable toc
\let\oldtableofcontents\tableofcontents
\NewDocumentCommand{\maketoc}{
    s % exclude it?
}{
    \IfBooleanT{#1}{\addtocontents{toc}{\protect\setcounter{tocdepth}{-1}}}
    \tableofcontents
    \IfBooleanT{#1}{\addtocontents{toc}{\protect\setcounter{tocdepth}{3}}}
}

%%% chapter with appendices
% appendix counter
\newcounter{appendix}
% chapter/appendix
\let\oldchapter\chapter
\NewDocumentCommand{\chapterwithnumberlesstoc}{
    s % is numberless?
    o % appendix type
    m % title
    o % toc line
}{
    \titlecontents{chapter}[0pt]{}{\contentslabel{12pt}}{\hspace*{-12pt}}
    {\titlerule*[4pt]{.}\thecontentspage}
    \bsuirtitle{\chapter}[\MakeUppercase][\centering]{\thechapter}[0pt]
    \IfBooleanTF{#1}{
        \oldchapter*{#3}
        \addcontentsline{toc}{chapter}{\IfValueTF{#4}{#4}{#3}}
    }{
        \IfValueT{#2}{
            \stepcounter{appendix}
            \titleformat{\chapter}{\centering\bfseries}
            {\MakeUppercase{Приложение~\Asbuk{appendix}}}{\wordsep}{\\(#2)\\}
            \addtocontents{toc}{\protect\setcounter{tocdepth}{-1}}
        }
        \IfValueTF{#4}
        {\oldchapter[#4]{#3}}
        {\oldchapter{#3}}
        \IfValueT{#2}{
            \addtocontents{toc}{\protect\setcounter{tocdepth}{3}}
            \addcontentsline{toc}{chapter}
            {\IfValueTF{#4}{#4}{Приложение \Asbuk{appendix} (#2) #3}}
        }
    }
}
\let\chapter\chapterwithnumberlesstoc

%%% class options
\RequirePackage{kvoptions}
% init
\SetupKeyvalOptions{
    family=KVO,
    prefix=KVO@
}
% variant is one of: custom, labwork, courcework, diploma, practice
\DeclareStringOption[custom]{variant}
% load them
\ProcessKeyvalOptions{KVO}
% validate variant
\RequirePackage{xifthen}
\ifthenelse{
    \equal{\KVO@variant}{custom}\OR
    \equal{\KVO@variant}{labwork}\OR
    \equal{\KVO@variant}{courcework}\OR
    \equal{\KVO@variant}{diploma}\OR
    \equal{\KVO@variant}{practice}
}{}{
    \ClassError{bsuir}{Unknown variant. Use one of: custom, labwork, courcework,
        diploma, practice}{\KVO@variant variant not available}
}

%%% titlepage
% template values
\newcommand{\faculty}[1]{\def\@faculty{#1}}
\newcommand{\departmentlong}[1]{\def\@departmentlong{#1}}
\newcommand{\departmentshort}[1]{\def\@departmentshort{#1}}
\newcommand{\manager}[1]{\def\@manager{#1}}
\newcommand{\worktitle}[1]{\def\@worktitle{#1}}
\newcommand{\workcode}[1]{\def\@workcode{#1}}
\newcommand{\titlepageyear}[1]{\def\@titlepageyear{#1}}
\newcommand{\titleright}[1]{\def\@titleright{#1}}
\newcommand{\titlecenter}[1]{\def\@titlecenter{#1}}
\newcommand{\titleleft}[1]{\def\@titleleft{#1}}
\newcommand{\group}[1]{\def\@group{#1}}
\newcommand{\student}[1]{\def\@student{#1}}
% template
\renewcommand{\maketitle}{
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

        \ifthenelse{
        \equal{\KVO@variant}{diploma}
        }{
        \raggedright
        \begin{tabular}{l l}
            Факультет & \@faculty        \\
            Кафедра   & \@departmentlong
        \end{tabular}\\
        [\the\baselineskip]
        }{
        Кафедра \@departmentlong\\
        [\dimexpr\the\baselineskip * 3]
        }

        \ifthenelse{
        \equal{\KVO@variant}{diploma}
        }{
        \raggedleft
        \begin{tabular}{l}
            \textit{К защите допустить}:          \\\\
            Заведующий кафедрой \@departmentshort \\
            \hrulefill \@manager
        \end{tabular}\\
        [\the\baselineskip]
        }{
        ~\\[\dimexpr\the\baselineskip * 4]
        }

        \ifthenelse{
        \equal{\KVO@variant}{custom}
        }{
        \@worktitle\\
        [\dimexpr\the\baselineskip * 7]
        }{\ifthenelse{
        \equal{\KVO@variant}{practice}
        }{
        \MakeUppercase{Отчет по учебной (\@worktitle) практике}\\
        [\dimexpr\the\baselineskip * 7]
        }{\ifthenelse{
        \equal{\KVO@variant}{labwork}
        }{
        Лабораторная работа \textnumero\@workcode\\
        \textquote{\@worktitle}\\
        [\dimexpr\the\baselineskip * 7]
        }{
        \centering
        \MakeUppercase{Пояснительная записка}\\
        \ifthenelse{
            \equal{\KVO@variant}{courcework}
        }{к курсовой работе}{к дипломной работе}\\
        на тему\\
        [\the\baselineskip]
        \textbf{\MakeUppercase{\@worktitle}}\\
        [\the\baselineskip]
        \@workcode\\
        [\the\baselineskip]
        }}}

        \ifthenelse{
            \equal{\KVO@variant}{practice}
        }{
            \begin{tabular}{l}
                Студент группы \@group \\\\
                Руководитель практики  \\
                от кафедры \@departmentshort
            \end{tabular}\hfill
            \begin{tabular}{c c l}
                \hrulefill & \hspace{30pt} & \@student \\
                \textsuperscript{(подпись)}            \\
                \hrulefill &               & \@manager \\
                ~
            \end{tabular}
        }{
            \begin{tabular}{l}
                \@titleleft
            \end{tabular}\hfill
            \begin{tabular}{l}
                \@titleright
            \end{tabular}

            \vfill
            \centering
            Минск \@titlepageyear
        }
    \end{titlepage}
    \stepcounter{page}
}

%%% lists
\RequirePackage{enumitem}
% itemize
\setlist[itemize]{
    label=--,
    leftmargin=1.4\parindent,
    topsep=0pt,
    itemsep=0pt,
    parsep=0pt
}
% enumerate
\setlist[enumerate]{
    leftmargin=1.5\parindent,
    topsep=0pt,
    itemsep=0pt,
    parsep=0pt
}

%%% figures
% figures factory
\RequirePackage{float}
\RequirePackage{caption}
\captionsetup[figure]{name=Рисунок, labelsep=endash}
% \makefigure
\NewDocumentCommand{\makefigure}{
    O{img} % figure prefix
    m % figure name
    m % code to make figure
}{
    \begin{figure}[H]
        \centering
        #3
        \label{#1:#2}
    \end{figure}
}
% images
% \makeimage
\RequirePackage{graphicx}
\NewDocumentCommand{\makeimage}{
    o % caption
    m % filename
    O{width=\textwidth} % image width
}{
    \makefigure{#2}{
        \includegraphics[#3]{#2}
        \IfValueT{#1}{\caption{#1}}
    }
}
% \makesvg
\RequirePackage{svg}
\NewDocumentCommand{\makesvg}{
    o % caption
    m % filename
    O{width=\textwidth} % image width
}{
    \makefigure{#2}{
        \includesvg[inkscapelatex=false, #3]{#2}
        \IfValueT{#1}{\caption{#1}}
    }
}

%%% listings
\RequirePackage{minted}
\setminted{
    fontsize=\fontsize{12}{\baselineskip},
    tabsize=2,
    breaklines,
    mathescape,
    stripnl,
    breakanywhere,
    breaksymbolleft=,
    breaksymbolright=,
    breakbeforesymbolpre=,
    breakaftersymbolpre=,
    breakanywheresymbolpre=,
    breakautoindent=false,
}
% unite counters
\makeatletter
\let\c@figure\c@listing
\makeatother
% set caption
\renewcommand\listingscaption{Рисунок}
\newenvironment{listingcaption}{\captionsetup{type=listing, name=Рисунок, labelsep=endash}}{}
% \makelisting
\NewDocumentCommand{\makelisting}{
    m % file
    o % caption
}{
    \begin{listingcaption}
        \centering
        \inputminted{text}{#1}
        \IfValueT{#2}{\caption{#2}~\\}
        \label{lst:#1}
    \end{listingcaption}
}

%%% tables
\RequirePackage{longtable}
% caption
\captionsetup[longtable]{name=Таблица, labelsep=endash, justification=raggedright, singlelinecheck=false}
% margins
\LTpre=\baselineskip
\LTpost=\baselineskip

%%% translations
\addto\captionsrussian{
    \renewcommand{\contentsname}{Содержание}
    \renewcommand{\bibname}{Список использованных источников}
}
