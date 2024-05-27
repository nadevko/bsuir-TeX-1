%%% metadata
% define class
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bsuir}[2024/02/14 BSUIR ENSTD 2017 compatible class]
% configure paper and margins
\LoadClass[14pt,final,onecolumn,oneside,titlepage,openany]{extreport}
\RequirePackage[
    a4paper,
    left=30mm,
    bottom=27mm,
    right=15mm,
    top=20mm,
    footskip=17mm
]{geometry}
\linespread{1.1}
\setlength{\parindent}{1.25cm}

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

%%% language
% translations
\RequirePackage[main=russian,english]{babel}
% fonts
\babelfont{rm}{Times New Roman}
\babelfont{sf}{Times New Roman}
\babelfont{tt}{Courier New}

%%% TeX improvements
% for ...DocumentCommand
\RequirePackage{xparse}

%%% misc
% break long URLs
\RequirePackage{xurl}
% to merge other pdf files into document
\RequirePackage{pdfpages}
% fancy quotes
\RequirePackage{csquotes}
% enable links
\RequirePackage[
    hidelinks,
    unicode,
    bookmarksdepth=3,
    breaklinks
]{hyperref}
% make metadata toc
\RequirePackage{bookmark}
% for rows of images
\RequirePackage{subcaption}
% bibliography style
\bibliographystyle{ugost2003}

%%% page numbering
\RequirePackage{fancyhdr}
% define style
\fancypagestyle{plain}{
    \fancyhf{}
    \rfoot{\underline{\thepage}}
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
}
\pagestyle{plain}

%%% table of contents
\RequirePackage{titletoc}
% toc depth
\setcounter{tocdepth}{1}
% excludable from toc itself
\let\oldtableofcontents\tableofcontents
\NewDocumentCommand{\maketoc}{
    s % exclude it?
}{
    \IfBooleanT{#1}{\addtocontents{toc}{\protect\setcounter{tocdepth}{-1}}}
    \tableofcontents
    \IfBooleanT{#1}{\addtocontents{toc}{\protect\setcounter{tocdepth}{1}}}
}


%%% headers
\RequirePackage[clearempty,newlinetospace]{titlesec}
\RequirePackage{afterpage}
% numbering depth
\setcounter{secnumdepth}{4}

%%% chapter
% zero-width space
\newcommand{\zwspace}{​}
% static styles
\titleformat{name=\chapter,numberless}
{\centering\bfseries\MakeUppercase}{}{0pt}{}
\titlespacing{name=\chapter,numberless}{0pt}{0pt}{\baselineskip}
\titlespacing{\chapter}{\parindent}{0pt}{\baselineskip}
% \bsuirchapter
\let\oldchapter\chapter
\NewDocumentCommand{\bsuirchapter}{
    s % is numberless?
    o % appendix type. In* - to newpage with title bookmark
    m % title
}{
    \IfValueTF{#2}{
        \titleformat{\chapter}{\centering\bfseries}
        {\MakeUppercase{Приложение~\thechapter}}{\parskip}
        {\\\MakeLowercase{(#2)}\\}
        \titlecontents{chapter}[100pt]{}
        {\hspace*{-100pt}Приложение~\thecontentslabel\hspace*{4pt}}{}
        {\titlerule*[4pt]{.}\thecontentspage}
    }{
        \titleformat{\chapter}{\bfseries\MakeUppercase}{\thechapter}{\wordsep}{}
        \titlecontents{chapter}[12pt]{}{\contentslabel{12pt}}
        {\hspace*{-12pt}}{\titlerule*[4pt]{.}\thecontentspage}
    }
    \IfBooleanTF{#1}{
        \titlecontents{chapter}[0pt]{}{\contentslabel{12pt}}{}
        {\titlerule*[4pt]{.}\thecontentspage}
        \IfValueTF{#2}{
            \afterpage{\addcontentsline{toc}{chapter}{#3}}
        }{
            \oldchapter*{#3}
            \addcontentsline{toc}{chapter}{#3}
        }
    }{
        \oldchapter[\IfValueT{#2}{(#2) }#3]{#3}
        \label{sec:\thechapter}
    }
}
\let\chapter\bsuirchapter

%%% section
% static styles
\titleformat{\section}{\bfseries}{\MakeUppercase\thesection}{\wordsep}{}
\titlecontents{section}[12pt]{}{\contentslabel{0pt}\hspace*{24pt}}
{\hspace*{0pt}}{\titlerule*[4pt]{.}\thecontentspage}
\titlespacing{\section}{\parindent}{\baselineskip}{\baselineskip}
% \bsuirsection
\let\oldsection\section
\NewDocumentCommand{\bsuirsection}{
    s % is numberless?
    m % title
}{
    \IfBooleanTF{#1}{
        \oldsection*{#2}
    }{
        \oldsection{#2}
        \label{sec:\thesection}
    }
}
\let\section\bsuirsection

%%% subsection
\let\oldsubsection\subsection
\NewDocumentCommand{\bsuirsubsection}{
    s % is titled
    m % title
}{
    \titlespacing{\subsection}{\parindent}{\baselineskip}{\IfBooleanTF{#1}{\baselineskip}{\wordsep}}
    \titleformat{\subsection}[\IfBooleanTF{#1}{hang}{runin}]{}
    {\textbf{\thesubsection}}{\wordsep}{}
    \oldsubsection[#2]{\IfBooleanT{#1}{#2}}
    \label{sec:\thesubsection}
}
\let\subsection\bsuirsubsection

%%% subsubsection
\let\oldsubsubsection\subsubsection
\NewDocumentCommand{\bsuirsubsubsection}{
    s % is titled
    m % title
}{
    \titlespacing{\subsubsection}{\parindent}{\baselineskip}{\IfBooleanTF{#1}{\baselineskip}{\wordsep}}
    \titleformat{\subsubsection}[\IfBooleanTF{#1}{hang}{runin}]{}
    {\textbf{\thesubsubsection}}{\wordsep}{}
    \oldsubsubsection[#2]{\IfBooleanT{#1}{#2}}
    \label{sec:\thesubsubsection}
}
\let\subsubsection\bsuirsubsubsection

%%% phantom headings
% phantom sections counter
\newcounter{phantoms}
% \phantomheading
\NewDocumentCommand{\phantomheading}{
    s % add to toc?
    O{0} % section level/type
    m % title
}{
    \IfBooleanTF{#1}{
        \afterpage{\addcontentsline{toc}{#2}{#3}}
    }{
        \stepcounter{phantoms}
        \hypertarget{phantom.\thephantoms}{}
        \bookmark[level=#2,dest=phantom.\thephantoms]{#3}
    }
}

%%% appendices
% fix listings numbering in appendices
\let\oldappendix\appendix
\newcommand{\bsuirappendix}{
    \oldappendix
    \renewcommand{\thechapter}{\Asbuk{chapter}}
    \renewcommand{\thefigure}{\Alph{chapter}.\arabic{figure}}
    \renewcommand{\thelisting}{\Alph{chapter}.\arabic{listing}}
}
\let\appendix\bsuirappendix
% rest of page height
\newcommand\measurepage{\dimexpr\pagegoal-\pagetotal\relax}
% \makeappendix
\NewDocumentCommand{\appendixfirstpage}{
    s % is titleless?
    o % appendix type
    m % appendix title
    m % pdf file
    O{page=1} % includepdf or includegraphics args
}{
    \IfValueTF{#2}{
        \begin{center}
            \IfBooleanTF{#1}{
                \vfill
                \includegraphics[width=\textwidth-8pt,#5]{#4}
                \vfill
            }{
                \chapter[#2]{#3}
                \includegraphics[
                    height=\measurepage-2pt,
                    width=\textwidth,
                    #5
                ]{#4}
            }
        \end{center}
        \clearpage
    }{
        \chapter*[]{#3}
        \includepdf[#5]{#4}
    }
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
\RequirePackage[
    aboveskip=1.2\baselineskip,
    belowskip=-0.3\baselineskip
]{caption}
\captionsetup[figure]{
    name=Рисунок,
    labelsep=endash
}
% \makefigure
\NewDocumentCommand{\makefigure}{
    O{img} % figure prefix
    m % figure name
    m % code to make figure
}{
    \vspace{0.5\baselineskip}
    \begin{figure}[H]
        \centering
        #3
        \label{#1:#2}
    \end{figure}
    \vspace{-0.6\baselineskip}
}

%%% images
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
        \includesvg[inkscapelatex=false,#3]{#2}
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
\BeforeBeginEnvironment{document}{
    \makeatletter
    \let\c@figure\c@listing
    \makeatother
}
% set caption
\renewcommand\listingscaption{Рисунок}
\newenvironment{listingcaption}
{\captionsetup{type=listing,name=Рисунок,labelsep=endash}}{}
% fix listings numbering
\renewcommand{\thelisting}{\arabic{chapter}.\arabic{listing}}
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
\captionsetup[longtable]{
    name=Таблица,
    labelsep=endash,
    justification=raggedright,
    singlelinecheck=false
}
% margins
\LTpre=\baselineskip
\LTpost=\baselineskip

%%% translations
\addto\captionsrussian{
    \renewcommand{\contentsname}{Содержание}
    \renewcommand{\bibname}{Список использованных источников}
}

%%% template variables
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

%%% titlepage
\renewcommand{\maketitle}{
    \begin{titlepage}
        % all
        \centering
        Министерство образования Республики Беларусь\\
        [\the\baselineskip]
        Учреждение образования\\
        \MakeUppercase{
            Белорусский Государственный Университет\\
            Информатики и Радиоэлектроники
        }\\
        [\the\baselineskip]

        \ifthenelse{\equal{\KVO@variant}{diploma}}{
        % diploma
        \raggedright
        \begin{tabular}{l l}
            Факультет & \@faculty        \\
            Кафедра   & \@departmentlong
        \end{tabular}\\
        [\the\baselineskip]
        }{
        % other
        Кафедра \@departmentlong\\
        [\dimexpr\the\baselineskip * 3]
        }

        \ifthenelse{\equal{\KVO@variant}{diploma}}{
        % diploma
        \raggedleft
        \begin{tabular}{l}
            \textit{К защите допустить}:          \\\\
            Заведующий кафедрой \@departmentshort \\
            \hrulefill \@manager
        \end{tabular}\\
        [\the\baselineskip]
        }{
        % other
        ~\\[\dimexpr\the\baselineskip * 4]
        }

        \ifthenelse{\equal{\KVO@variant}{custom}}{
        % custom
        \@worktitle\\
        [\dimexpr\the\baselineskip * 7]
        }{\ifthenelse{\equal{\KVO@variant}{practice}}{
        % practice
        \MakeUppercase{Отчет по учебной (\@worktitle) практике}\\
        [\dimexpr\the\baselineskip * 7]
        }{\ifthenelse{\equal{\KVO@variant}{labwork}}{
        % labwork
        Лабораторная работа \textnumero\@workcode\\
        \textquote{\@worktitle}\\
        [\dimexpr\the\baselineskip * 7]
        }{
        % courcework, diploma
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

        \ifthenelse{\equal{\KVO@variant}{practice}}{
            % practice
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
            % other
            \begin{tabular}{l}
                \@titleleft
            \end{tabular}\hfill
            \begin{tabular}{l}
                \@titleright
            \end{tabular}
        }

        % all
        \vfill
        \centering
        Минск \@titlepageyear
    \end{titlepage}
    \stepcounter{page}
}
