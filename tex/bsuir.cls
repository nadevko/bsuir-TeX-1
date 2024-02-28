\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bsuir}[2024/02/27 BSUIR ENSTD 2017 compatible class]

\LoadClass[14pt, final, onecolumn, oneside, titlepage, openany]{extreport}
\RequirePackage[a4paper, top=20mm, bottom=27mm, left=30mm, right=15mm, footskip=17mm]{geometry}

\RequirePackage[main=russian, english]{babel}
\babelfont{rm}{Times New Roman}
\babelfont{sf}{Times New Roman}
\babelfont{tt}{Times New Roman}

\RequirePackage{fancyhdr}
\fancypagestyle{plain}{
\fancyhf{}
\rfoot{\underline{\thepage}}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
}
\pagestyle{plain}

\setlength{\parindent}{1.27cm}

\RequirePackage{titlesec}
\RequirePackage{xparse}

\setlength{\parindent}{0cm}
\setlength{\parskip}{.25cm}

\RequirePackage{minted}
\RequirePackage{svg}
\RequirePackage{graphicx}

\newcommand{\department}[1]{\def\@departament{#1}}
\newcommand{\worktype}[1]{\def\@worktype{#1}}
\newcommand{\numero}[1]{\def\@numero{#1}}
\newcommand{\group}[1]{\def\@group{#1}}
\newcommand{\teacher}[1]{\def\@teacher{#1}}
\newcommand{\location}[1]{\def\@location{#1}}

\RequirePackage{xifthen}
\NewDocumentCommand{\ifequals}{m m m o}{\ifthenelse{\equal{#1}{#2}}{#3}{\IfValueT{#4}{#4}}}
\newcommand{\case}[2]{#1 #2}

\usepackage{enumitem}
\setlist[itemize]{noitemsep, topsep=-\parskip}
\def\labelitemi{---}
\setlist[enumerate]{noitemsep, topsep=-\parskip}

\RequirePackage{csquotes}
\RequirePackage{caption}
\captionsetup[figure]{name=Рисунок, labelsep=endash}

\renewcommand{\maketitle}{
    \begin{titlepage}
        \centering
        Учреждение образования\\
        [\the\baselineskip]
        \textquote{Белорусский государственный университет\\информатики и радиоэлектроники}\\
        [\the\baselineskip]
        \@departament\\
        [\dimexpr\the\baselineskip * 7]
        Отчет по лабораторной работе~\textnumero\@numero\\
        \textbf{\textquote{\@title}}\\
        [\dimexpr\the\baselineskip * 10]
        \raggedleft
        \parbox[right]{7cm}{\@author\\\@group\\\@teacher}
        \vfill
        \centering
        \@location~\@date
    \end{titlepage}
}

\newcommand{\makepar}[2]{\textbf{\textit{#1:}} #2}
\newcommand{\makegoal}[1]{\makepar{Цель}{#1}}
\newcommand{\makesummary}[1]{\makepar{Вывод}{#1}}
\newcommand{\makevariant}[2]{\makepar{Вариант~\textnumero #1}{#2}}

\NewDocumentCommand{\makefilelisting}{m m o}{
    \begin{figure}[H]
        \centering
        \inputminted[curlyquotes, texcomments, breaklines, fontsize=\small]{#2}{#1}
        \IfValueT{#3}{\caption{\ifequals{#3}{\\FILENAME}{#1}[#3]}}
        \label{fig:#1}
    \end{figure}
}

\NewDocumentCommand{\makeimage}{m o}{
    \begin{figure}[H]
        \centering
        \includegraphics[width=\textwidth]{#1}
        \caption{\IfValueTF{#2}{#2}{#1}}
        \label{fig:#1}
    \end{figure}
}

\NewDocumentCommand{\makescheme}{m o}{
    \begin{figure}[H]
        \centering
        \includesvg{#1}
        \caption{\IfValueTF{#2}{#2}{#1}}
        \label{fig:#1}
    \end{figure}
}

\NewDocumentEnvironment{problem}{m m o}{
    \titleformat{\section}{\large}{Задание \textnumero\thesection~}{0em}{}
    \section{\IfValueT{#3}{\textquote{#3}}}
    \makevariant{#1}{#2}
}{}
