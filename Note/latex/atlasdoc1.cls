%-------------------------------------------------------------------------------
% Template class for ATLAS documents
%
% See ChangeLog or SVN log for history of changes.
% Responsible: Ian Brock (ian.brock@cern.ch)
%-------------------------------------------------------------------------------
\def\ATPackageVersion{03-00-00}

\ProvidesClass{latex/atlasdoc1}[2017/03/02 v.03-00-00 ATLAS deprecated document class]
\NeedsTeXFormat{LaTeX2e}

%-------------------------------------------------------------------------------
% More advanced if syntax
\RequirePackage{ifthen}
% Process options. Use kvoptions package.
\RequirePackage{kvoptions}
%\RequirePackage[debugshow]{kvoptions}
\SetupKeyvalOptions{
  family=ADOC,
  prefix=ADOC@
}
\DeclareBoolOption[true]{atlasstyle}
\DeclareBoolOption[false]{coverpage}
\DeclareBoolOption[false]{cernpreprint}
\DeclareBoolOption[false]{preprint}
\DeclareBoolOption[true]{NOTE}
\DeclareBoolOption[false]{PAPER}
\DeclareBoolOption[false]{CONF}
\DeclareBoolOption[false]{PUB}
\DeclareBoolOption[false]{auxmat}
\DeclareStringOption[2013]{texlive}
\DeclareStringOption{paper}
\DeclareBoolOption[true]{floatopt}
\DeclareBoolOption[false]{texmf}
\DeclareBoolOption[true]{newtx}
\DeclareBoolOption[false]{txfonts}
\DeclareBoolOption[false]{libertine}
\DeclareBoolOption[false]{palatino}
\DeclareBoolOption[false]{showframe}
\DeclareStringOption[0pt]{titleextraheight}
\DeclareStringOption[0pt]{copyrightoffset}
\DeclareBoolOption[false]{maketitle}
\DeclareBoolOption[true]{nomaketitle}
\DeclareBoolOption[false]{koma}
\DeclareBoolOption[false]{letterpaper}
\ProcessKeyvalOptions{ADOC}

% Standard LaTeX options for paper size
%\newif\ifADOC@aivpaper
%\ADOC@aivpapertrue
%\DeclareOption{a4paper}{\PassOptionsToClass{\CurrentOption}{\ADOC@mainclass}} % \ADOC@aivpapertrue} %\def\ADOC@paperstring{a4paper}}
%\DeclareOption{letterpaper}{\PassOptionsToClass{\CurrentOption}{\ADOC@mainclass}} % \ADOC@aivpaperfalse} %\def\ADOC@paperstring{letterpaper}}
%\ProcessOptions\relax
\newcommand*{\ATTeXLiveVersion}{\ADOC@texlive}

\newif\ifADOC@CONFnote
\newif\ifADOC@PUBnote

% ATLAS style needs KOMA-Script
\ifADOC@atlasstyle
  \ADOC@komatrue
\fi

% CERN preprint or auxiliary material
\ifADOC@cernpreprint
  \ADOC@auxmatfalse
\else
  \ifADOC@preprint
    \ADOC@cernpreprinttrue
    \ADOC@auxmatfalse
  \else
    \ifADOC@auxmat
      \ADOC@cernpreprintfalse
      \ADOC@auxmattrue
    \fi
  \fi
\fi

% Directory for style files
\ifADOC@texmf
  \providecommand*{\ATLASLATEXPATH}{}
\else
  \providecommand*{\ATLASLATEXPATH}{latex/}
\fi

% Type of document
\newcommand*{\ADOC@docheadingdefault}{}
\ifADOC@PAPER
  \typeout{atlasdoc: ATLAS paper}
  \renewcommand*{\ADOC@docheadingdefault}{ATLAS Paper}
  \ADOC@PAPERtrue
  \ADOC@NOTEfalse
  \ADOC@CONFnotefalse
  \ADOC@PUBnotefalse
\else
  \ifADOC@CONF
    \typeout{atlasdoc: ATLAS CONF note}
    \renewcommand*{\ADOC@docheadingdefault}{ATLAS CONF Note}
    \ADOC@PAPERfalse
    \ADOC@NOTEfalse
    \ADOC@CONFnotetrue
    \ADOC@PUBnotefalse
  \else
    \ifADOC@PUB
      \typeout{atlasdoc: ATLAS PUB note}
      \renewcommand*{\ADOC@docheadingdefault}{ATLAS PUB Note}
      \ADOC@PAPERfalse
      \ADOC@NOTEfalse
      \ADOC@CONFnotefalse
      \ADOC@PUBnotetrue
    \else
%      \typeout{atlasdoc: ATLAS Note}
      \renewcommand*{\ADOC@docheadingdefault}{ATLAS Note}
    \fi
  \fi
\fi

% Decide on the main class
\ifADOC@koma
  \typeout{atlasdoc: use KOMA-script scrartcl class}
  \def\ADOC@mainclass{scrartcl}
\else
  \typeout{atlasdoc: use standard LaTeX article class}
  \def\ADOC@mainclass{article}
\fi

% Set paper size
\ifx\ADOC@paper\@empty
  %\typeout{atlasdoc: paper option not specified}
  \ifADOC@letterpaper%
    \typeout{atlasdoc: set paper size to letter - deprecated option}
    \def\ADOC@paperstring{letterpaper}
    \PassOptionsToClass{letterpaper}{\ADOC@mainclass}
    \typeout{atlasdoc: paper size set to letter}
  \else
    \def\ADOC@paperstring{a4paper}
    \PassOptionsToClass{a4paper}{\ADOC@mainclass}
    \typeout{atlasdoc: paper size set to default A4}
  \fi
\else
  \def\ADOC@paperstring{\ADOC@paper paper}
  \PassOptionsToClass{\ADOC@paperstring}{\ADOC@mainclass}
  \typeout{atlasdoc: paper is \ADOC@paper, string for class is \ADOC@paperstring}
\fi

% Obsolete command to turn off making title page
\ifADOC@nomaketitle
  \relax
\else
  \typeout{*** atlasdoc: this option has no effect. Users should use the macro maketitle instead}
\fi
% Obsolete command to turn on or off making title page - user should say \maketile
\ifADOC@maketitle
  \typeout{*** atlasdoc: maketitle is a deprecated option.}
  \typeout{*** atlasdoc: users should use the macro maketitle instead}
\fi

% Switch to txfonts for TeX Live <= 2012
% Need to pass this option to atlaspackage as well
\ifthenelse{\ADOC@texlive < 2012 \AND \boolean{ADOC@newtx}}{%
  \typeout{*** atlasdoc: use txfonts instead of newtx}
  \ADOC@newtxfalse
  \ADOC@txfontstrue
  \PassOptionsToPackage{txfonts}{\ATLASLATEXPATH atlaspackage}
}{%
}

%-------------------------------------------------------------------------------
% Defaults for title page
\newdimen\ADOC@skipbeforetitle
\ADOC@skipbeforetitle=60\p@
\newcommand{\skipbeforetitle}[1]{\ADOC@skipbeforetitle=#1}

\def\@title{Dummy title in atlasdoc\\ Use \textbackslash AtlasTitle to set it}
\newcommand{\AtlasTitleText}{Dummy AtlasTitleText in atlasdoc\\ Use \textbackslash AtlasTitle to set it}
\newcommand{\AtlasTitle}[1]{%
  \def\@title{#1}%
  \renewcommand{\AtlasTitleText}{#1}%
}
\def\@author{The ATLAS Collaboration}
\def\@date{\today}

% Draft version 
\def\ADOC@draftversion{}
\newcommand*{\draftversion}[1]{\def\ADOC@draftversion{#1}}
\newcommand*{\AtlasVersion}[1]{\def\ADOC@draftversion{#1}}

% ATLAS reference code - empty by default
% Also create variable with web page
\def\ADOC@refcode{}
\newcommand*{\AtlasRefCode}[1]{\def\ADOC@refcode{#1}}
\newcommand*{\AtlasPaperWebpage}{https://atlas.web.cern.ch/Atlas/GROUPS/PHYSICS/PAPERS/\ADOC@refcode}

% ATLAS note number
\def\ADOC@atlasnote{}
\newcommand*{\AtlasNote}[1]{\def\ADOC@atlasnote{#1}}

% ATLAS date - arXiv submission; to be filled in by the Physics Office
\def\ADOC@atlasdate{\today}
\newcommand*{\AtlasDate}[1]{\def\ADOC@atlasdate{#1}}

% Journal
\def\ADOC@journal{}
\newcommand*{\journal}[1]{\def\ADOC@journal{#1}}
\newcommand*{\AtlasJournal}[1]{\def\ADOC@journal{#1}}

% Preprint
\def\ADOC@preprintnumber{}
\newcommand*{\PreprintIdNumber}[1]{\def\ADOC@preprintnumber{#1}}

% Journal
\def\ADOC@journalref{}
\newcommand*{\AtlasJournalRef}[1]{\def\ADOC@journalref{#1}}

% DOI
\def\ADOC@doi{}
\newcommand*{\AtlasDOI}[1]{\def\ADOC@doi{#1}}

% ATLAS document heading
\def\ADOC@docheading{}
\newcommand*{\AtlasHeading}[1]{\def\ADOC@docheading{#1}}

% arXiv
\def\AtlasArXivId{}
\def\AtlasArXivURL{}
\newcommand*{\arXivId}[1]{\def\AtlasArXivId{#1}\def\AtlasArXivURL{http://arXiv.org/abs/#1}}
\newcommand*{\AtlasArXivCat}{[hep-ex]}

% HEP Data
\def\AtlasHepDataRecord{}
\newcommand*{\HepDataRecord}[1]{\def\AtlasHepDataRecord{http://hepdata.cedar.ac.uk/view/ins#1}}

% Submission details
\def\ADOC@subprepend{To be submitted to:}
\newcommand*{\subprepend}[1]{\def\ADOC@subprepend{#1}}

% Abstract text
\def\AtlasAbstractText{}
\newcommand{\AtlasAbstract}[1]{\def\AtlasAbstractText{#1}}
\newcommand{\abstracttext}[1]{\def\AtlasAbstractText{#1}}

%-------------------------------------------------------------------------------
% Invoke main class
% Note that \KOMAoptions is not available in versions of KOMA-Script older than 3.0
\ifADOC@koma
  \ifthenelse{\ADOC@texlive < 2009}{%
    \PassOptionsToClass{DIV=14,BCOR=5mm}{scrartcl}
    \PassOptionsToClass{parskip=half}{scrartcl}
  }{}
  \LoadClass[titlepage,11pt]{scrartcl}
  %\LoadClass[titlepage,11pt,twoside=semi]{scrartcl}
\else
  \LoadClass[titlepage,11pt]{article}
\fi

% Turn on bold math when using \bfseries
\def\bfseries{\fontseries\bfdefault\selectfont\boldmath}

% Set KOMA-script options for ATLAS style
\ifADOC@atlasstyle
  % Note that \KOMAoptions is not available in versions of KOMA-Script older than 3.0
  \ifthenelse{\ADOC@texlive < 2009}{%
    % Adjust text height according to option headinclude
    \addtolength{\topmargin}{\headheight}
    \addtolength{\topmargin}{\headsep}
    \addtolength{\textheight}{-\headheight}
    \addtolength{\textheight}{-\headsep}
  }{%
    \KOMAoptions{headinclude=true, footinclude=false}
    \KOMAoptions{DIV=14,BCOR=5mm}
    %\KOMAoptions{headings=normal}
    % Do not put a dot after Section/Chapter, nor in the figure caption.
    \KOMAoptions{numbers=noendperiod}
    % Paragraph spacing is half a line
    \KOMAoptions{parskip=half}
  }
  \addtokomafont{disposition}{\rmfamily}
  \addtokomafont{part}{\LARGE}
  \addtokomafont{descriptionlabel}{\rmfamily}
  %\setkomafont{pageheadfoot}{\normalsize\sffamily}
  \setkomafont{pagehead}{\normalsize\rmfamily}
  %\setkomafont{publishers}{\normalsize\rmfamily}
  \setkomafont{caption}{\normalfont\small}
  \setcapindent{0pt}
  \deffootnote[1em]{1em}{1em}{\textsuperscript{\thefootnotemark}\ }
\else
  \RequirePackage[centering,scale=0.75,headheight=16pt]{geometry}
  %\RequirePackage[\ADOC@paperstring,centering,scale=0.75]{geometry}
\fi

% ATLAS draft cover pages for papers, PUB and CONF notes
\def\ADOC@atlascover{\ATLASLATEXPATH atlascover1}
\ifADOC@coverpage
  \typeout{atlasdoc1: load atlascover1 package}
  \ifADOC@CONFnote
    \PassOptionsToPackage{CONF,atlasdoc}{\ADOC@atlascover}
  \else
    \ifADOC@PUBnote
      \PassOptionsToPackage{PUB,atlasdoc}{\ADOC@atlascover}
    \else
      \PassOptionsToPackage{atlasdoc}{\ADOC@atlascover}
    \fi
  \fi
  \RequirePackage{\ADOC@atlascover}
\fi

% Remove the numbers from all the headings (\section, \subsection, etc.)
%\setcounter{secnumdepth}{-1}

% Required packages
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{babel}
% hyperref is needed in many places, so include it here
\RequirePackage{hyperref}

% Font(s)
\ifADOC@txfonts
  % Needs special amsmath code in atlaspackage
  \typeout{atlasdoc1: using txfonts}
  \RequirePackage[varg]{txfonts}
  \RequirePackage[T1]{fontenc}
\else
  \ifADOC@libertine
    \typeout{atlasdoc1: using Libertine fonts}
    \RequirePackage{libertine}
    \RequirePackage[T1]{fontenc}
    \RequirePackage[libertine]{newtxmath}
  \else
    \ifADOC@palatino
      \typeout{atlasdoc1: using Palatino fonts}
      % Palatino for rm and math | Helvetica for ss | Courier for tt
      \RequirePackage{mathpazo} % math & rm
      \linespread{1.05}        % Palatino needs more leading (space between lines)
      \RequirePackage[scaled]{helvet} % ss
      \RequirePackage{courier} % tt
      \normalfont
      \RequirePackage[T1]{fontenc}
    \else
      \typeout{atlasdoc1: using newtx fonts package}
      \RequirePackage{newtxtext}
      \ifthenelse{\ADOC@texlive < 2013}{%
        \typeout{*** atlasdoc1: include amsmath before newtxmath}
        \RequirePackage{amsmath}
      }{%
      }
      \RequirePackage{newtxmath}
    \fi
  \fi
\fi

% Adjust float settings to try to avoid problems.
% These follow the UK FAQ - see also P.199-200 of the LaTeX Book
\ifADOC@floatopt
  \renewcommand{\topfraction}{0.85}
  \renewcommand{\bottomfraction}{0.70}
  \renewcommand{\textfraction}{0.15}
  \renewcommand{\floatpagefraction}{0.66}
  \renewcommand{\dbltopfraction}{0.66}
  \renewcommand{\dblfloatpagefraction}{0.66}
  \setcounter{topnumber}{9}
  \setcounter{bottomnumber}{9}
  \setcounter{totalnumber}{20}
\fi

% Add ability to include line numbers
\RequirePackage{lineno}
% If you have an old lineno or do not have it, you can get it from the latex/other directory
% \RequirePackage{latex/other/lineno}
% \nolinenumbers
\ifADOC@showframe
  \RequirePackage{showframe}
\fi

% Compute the time in hours and minutes; make new variables \timehh and \timemm
\newcount\timehh\newcount\timemm
\timehh=\time 
\divide\timehh by 60 \timemm=\time
\count255=\timehh\multiply\count255 by -60 \advance\timemm by \count255
% Now make a string with date and time
\newcommand{\dateandtime}{\today \ --
  \ifnum\timehh<10 0\fi\number\timehh:\ifnum\timemm<10 0\fi\number\timemm}
% \RequirePackage{scrdate,scrtime}

% Draft heading/footer code
\newcommand{\AtlasDraftHeading}{%
  \ifADOC@koma
    \RequirePackage[headsepline]{scrpage2}
    \ihead{}
    \chead[]{\fbox{\textsf\bfseries DRAFT}}
    \ohead{}
    \ifoot{\dateandtime}
    %\cfoot{atlasdoc: \ATPackageVersion}
    \cfoot{}
    \ofoot{\thepage}
    \pagestyle{scrheadings}
  \else
    \RequirePackage{fancyhdr}
    \chead[]{\fbox{\textsf\bfseries DRAFT}}
    \rhead{}
    \lfoot{\dateandtime}
    %\cfoot{atlasdoc: \ATPackageVersion}
    \cfoot{}
    \rfoot{\thepage}
    \setlength\headheight{16pt}
    \pagestyle{fancy}
  \fi
}

% Include fancier header and footer for auxiliary material document
\ifADOC@auxmat
  \ifADOC@koma
    \RequirePackage[headsepline]{scrpage2}
    \chead{ATLAS Collaboration -- arXiv:\AtlasArXivId\ \AtlasArXivCat}
  \else
    \RequirePackage{fancyhdr}
    \lhead{}
    \chead{ATLAS Collaboration -- arXiv:\AtlasArXivId\ \AtlasArXivCat}
    \rhead{}
  \fi
\fi

% Length needed for parbox/minipage in title page
\newlength{\titlepageparbox}
\setlength{\titlepageparbox}{\textwidth}
%\addtolength{\titlepageparbox}{-2\fboxrule}
%\addtolength{\titlepageparbox}{-2\fboxsep}
%\addtolength{\titlepageparbox}{-9pt}
%\typeout{titlepageparbox is \the\titlepageparbox}

%-------------------------------------------------------------------------------
% Title page design
\newcommand{\AtlasTitleHeader}{%
  \parbox[t][35mm]{\titlepageparbox}{%
    \parbox[b][35mm][t]{0.24\titlepageparbox}{%
%      \includegraphics[height=25mm]{AT_atlaslogo_2015}
    }
    \hspace*{\fill}
    \parbox[b][35mm][c]{0.48\titlepageparbox}{%
      \centering
        {\fontfamily{phv}\bfseries\fontsize{20}{24}\selectfont
         \ifx\ADOC@docheading\@empty
           \textsf{\ADOC@docheadingdefault}\par
         \else
           \textsf{\ADOC@docheading}\par
         \fi
        }
        \vspace*{2ex}
        % ATLAS note number, if any 
        \ifx\ADOC@atlasnote\@empty
          % ATLAS reference code, if any and no note number given
          \ifx\ADOC@refcode\@empty
            \mbox{}%
          \else 
            {\Large \ADOC@refcode}\par
          \fi
        \else
          {\Large \ADOC@atlasnote}\par
        \fi
        % \vspace*{1.5ex}
        % Date, if any
        % \ifx\@date\@empty
        %   \mbox{}\par
        % \else
        %   \@date\par
        % \fi
    }
    \hspace*{\fill}
    \parbox[b][35mm][t]{0.24\titlepageparbox}{%
      \hspace*{\fill}\includegraphics[height=25mm]{AT_cernlogo}\par
      \ifx\ADOC@draftversion\@empty
        \relax
      \else
        \normalsize\hspace*{\fill}Draft version \ADOC@draftversion
      \fi
    }
  }\par
}

%-------------------------------------------------------------------------------
% CERN preprint title header
\newcommand{\CERNPreprintTitleHeader}{%
  \parbox[t]{\linewidth}{%
    {\centering
      \fontfamily{phv}\fontseries{m}\fontsize{14}{16.8}\selectfont
      EUROPEAN ORGANISATION FOR NUCLEAR RESEARCH (CERN)\par
    }
    \vspace*{2mm}
    \parbox[t]{0.45\linewidth}{%
%      \includegraphics[height=25mm]{AT_atlaslogo_2015}\par
      \fontfamily{phv}\fontseries{m}\fontsize{11}{13.2}\selectfont
      \ifx\ADOC@journalref\@empty
        \ifx\ADOC@journal\@empty
          \relax
        \else
          Submitted to: \ADOC@journal\par
        \fi
      \else
          \ADOC@journalref\par
      \fi
      \ifx\ADOC@doi\@empty
        \relax
      \else
        DOI: \href{http://dx.doi.org/\ADOC@doi}{\ADOC@doi}\par
      \fi
    }
    \hspace*{\fill}
    \parbox[t]{0.45\linewidth}{%
      \hspace*{\fill}\includegraphics[height=25mm]{AT_cernlogo}\par
      \fontfamily{phv}\fontseries{m}\fontsize{11}{13.2}\selectfont
      \hspace*{\fill}\ADOC@preprintnumber\par
      \hspace*{\fill}\ADOC@atlasdate\par
    }\par
    \vspace*{2mm}
    \rule{\linewidth}{1pt}\par
  }
}

%-------------------------------------------------------------------------------
% Auxiliary material title header
\newcommand{\AuxmatTitleHeader}{%
  \parbox[t]{\linewidth}{%
    {\centering
      \fontfamily{phv}\fontseries{m}\fontsize{14}{16.8}\selectfont 
      EUROPEAN ORGANISATION FOR NUCLEAR RESEARCH (CERN)\par
    }
    \vspace*{2mm}
    \parbox[t]{0.45\linewidth}{%
      \includegraphics[height=25mm]{AT_atlaslogo_2015}\par
      \fontfamily{phv}\fontseries{m}\fontsize{11}{13.2}\selectfont 
      arXiv: \AtlasArXivId\ \AtlasArXivCat
    }
    \hspace*{\fill}
    \parbox[t]{0.45\linewidth}{%
      \hspace*{\fill}\includegraphics[height=25mm]{AT_cernlogo}\par
      \fontfamily{phv}\fontseries{m}\fontsize{11}{13.2}\selectfont 
      \hspace*{\fill}\ADOC@preprintnumber\par
      \hspace*{\fill}\ADOC@atlasdate\par
    }\par
    \vspace*{2mm}
    \rule{\linewidth}{1pt}\par
  }
}

%\RequirePackage{fancybox}
%\newlength{\dboxpageparbox}
%\setlength{\dboxpageparbox}{\textwidth}
%\addtolength{\dboxpageparbox}{-2\fboxrule}
%\addtolength{\dboxpageparbox}{-2\fboxsep}
%-------------------------------------------------------------------------------
% ATLAS document title body
\newcommand{\AtlasTitleBody}{%
  {\centering
    {\bfseries\fontsize{16}{19.2}\selectfont \@title \par}
    \vskip 3em
    {\large
     \lineskip .75em
     \begin{tabular}[t]{c}
       \@author\\[2em]
       \@date
     \end{tabular}\par}
  }\par
  \vspace{\stretch{0.5}}
  % Astract
  %\doublebox{\begin{minipage}{\dboxpageparbox}
  \if\AtlasAbstractText\@empty
    \mbox{}
  \else
    {\centering
      \bfseries\fontsize{12}{14.4}\selectfont
      \abstractname\par
    }
    {\fontseries{m}\fontsize{11}{13.2}\selectfont%
      \begin{quote}
        %\setlength{\parindent}{0pt}\setlength{\parskip}{0.5ex}\noindent\AtlasAbstractText
        \AtlasAbstractText
      \end{quote}
    }
  \fi
  % Submission details
  \ifx\ADOC@journal\@empty
    \relax
  \else
    \ifADOC@PAPER
      \vspace{\stretch{1}}
      \noindent\begin{minipage}[c]{\linewidth}
        \centering
        \ADOC@subprepend\ \textit{\ADOC@journal}
      \end{minipage}
      %{\submitted}\par
    \fi
  \fi
  %\end{minipage}}
}

%-------------------------------------------------------------------------------
% CERN Preprint title body
\newcommand{\CERNPreprintTitleBody}{%
  \parbox[t]{\linewidth}{%
    {\centering
      \bfseries\fontsize{16}{19.2}\selectfont 
      %\fontfamily{phv}\bfseries\fontsize{16}{19.2}\selectfont 
      \AtlasTitleText\par
    }
    \vspace*{6ex}
    {\centering
      \fontseries{m}\fontsize{12}{14.4}\selectfont
      %\fontfamily{phv}\fontseries{m}\fontsize{12}{14.4}\selectfont
      The ATLAS Collaboration\par
    }
    \vspace*{6ex}
    {\centering
      \bfseries\fontsize{12}{14.4}\selectfont
      %\fontfamily{phv}\bfseries\fontsize{12}{14.4}\selectfont
      \abstractname\par
    }
    {\fontseries{m}\fontsize{11}{13.2}\selectfont%
      %\fontfamily{phv}\fontseries{m}\fontsize{11}{13.2}\selectfont%
      \begin{quote}
      %\setlength{\parindent}{0pt}\setlength{\parskip}{0.5ex}\noindent\AtlasAbstractText
        \AtlasAbstractText
      \end{quote}
    }
  }
}

%-------------------------------------------------------------------------------
% Auxiliary material title body
\newcommand{\AuxmatTitleBody}{%
  \parbox[t]{\linewidth}{%
    {\centering
      \bfseries\fontsize{16}{19.2}\selectfont 
      %\fontfamily{phv}\bfseries\fontsize{16}{19.2}\selectfont 
      Auxiliary figures and tables related to the paper\\[1.5ex]
      \AtlasTitleText\par
    }
    \vspace*{2ex}
    {\centering
      \fontseries{m}\fontsize{12}{14.4}\selectfont
      %\fontfamily{phv}\fontseries{m}\fontsize{12}{14.4}\selectfont
      The ATLAS Collaboration\par
    }
    \vspace*{2ex}
    {\centering
      \fontseries{m}\fontsize{12}{14.4}\selectfont
      %\fontfamily{phv}\fontseries{m}\fontsize{12}{14.4}\selectfont
      \ADOC@refcode\par
    }
    \vspace*{2ex}
    {\centering
      \bfseries\fontsize{12}{14.4}\selectfont
      %\fontfamily{phv}\bfseries\fontsize{12}{14.4}\selectfont
      \abstractname\par
    }
    {\centering
      \fontseries{m}\fontsize{11}{13.2}\selectfont%
      %\fontfamily{phv}\fontseries{m}\fontsize{11}{13.2}\selectfont%
      \begin{quote}
      %\setlength{\parindent}{0pt}\setlength{\parskip}{0.5ex}\noindent\AtlasAbstractText
        \AtlasAbstractText
      \end{quote}
    }
  }
}

%-------------------------------------------------------------------------------
% Copyright cover footer - parbox does not introduce spurious vertical space
\newcommand{\AtlasCopyrightFooter}{%
  \parbox[b]{\linewidth}{%
    \fontseries{m}\fontsize{10}{12}\selectfont
    %\fontfamily{phv}\fontseries{m}\fontsize{10}{12}\selectfont
    \copyright\ \the\year \ CERN for the benefit of the ATLAS Collaboration.\newline
    Reproduction of this article or parts of it is allowed as specified in the CC-BY-4.0 license.
  }\par
}

%-------------------------------------------------------------------------------
% ATLAS title page
\newcommand\MakeAtlasTitle{%
  \thispagestyle{empty}
%  \pagestyle{plain}
  \pagenumbering{arabic}
  \noindent\AtlasTitleHeader
  \vfill
  \noindent\AtlasTitleBody
  \vfill
  \noindent\AtlasCopyrightFooter
  % Footnote with more information about authors.
  \@thanks
  \clearpage
}

% CERN preprint title page
\newcommand{\MakeCERNPreprintTitle}{%
  \thispagestyle{empty}
  \noindent{\CERNPreprintTitleHeader}
  \vfill
  \noindent{\CERNPreprintTitleBody}
  \vfill
  \noindent{\AtlasCopyrightFooter}
  \clearpage
}

% Print the auxilary material cover
\newcommand{\MakeAuxmatTitle}{%
  \thispagestyle{empty}
  \noindent{\AuxmatTitleHeader}
  \vfill
  \noindent{\AuxmatTitleBody}
  \vfill
  \noindent{\AtlasCopyrightFooter}
  \clearpage
}

%-------------------------------------------------------------------------------
% Cover and title pages in one command for old maketitle option
\newcommand{\MakeAtlasCoverTitle}{%
  % If selected, generate ATLAS Cover Page
  \typeout{atlasdoc1: producing the cover and title pages}
  \ifADOC@coverpage
    % Turn line numbers off for cover pages
    \nolinenumbers
    \ACOV@PrintAtlasCover
    \ACOV@PrintAtlasCoverPageTwo
    % Turn line numbers back on
    \ifx\ADOC@draftversion\@empty%
      \relax
    \else
      \linenumbers
    \fi
  \fi
  \setcounter{page}{1}
  % If selected, generate CERN preprint title page
  \ifADOC@cernpreprint
    \typeout{atlasdoc1: making CERN preprint title page}
    \MakeCERNPreprintTitle
  \else
    % If selected, generate ATLAS auxiliary material title page
    \ifADOC@auxmat
      \typeout{atlasdoc1: making auxiliary material title page}
      \MakeAuxmatTitle
    % Standard title page
    \else
      \typeout{atlasdoc1: making standard ATLAS document title page}
      \MakeAtlasTitle
    \fi
  \fi
  \clearpage
}

% KOMA-Script - set up title page elements
\ifADOC@koma
% Header
\ifADOC@cernpreprint
  \typeout{atlasdoc1: defining CERN preprint title page}
  \titlehead{\CERNPreprintTitleHeader}
  \date{}%\vspace*{-5ex}}
\else
  \ifADOC@auxmat
    \typeout{atlasdoc1: defining Auxiliary Material title page}
    \titlehead{\AuxmatTitleHeader}
    \date{}%\vspace*{-5ex}}
  \else
    \typeout{atlasdoc1: defining ATLAS document title page}
    \titlehead{\AtlasTitleHeader}
  \fi
\fi

% Body and copyright
\newlength{\abstractparbox}
\setlength{\abstractparbox}{\textwidth}
%\addtolength{\abstractparbox}{-2\fboxrule}
%\addtolength{\abstractparbox}{-2\fboxsep}
\newlength{\abstractheight}
\setlength{\abstractheight}{0.45\textheight}
\addtolength{\abstractheight}{-\ADOC@titleextraheight}
\newlength{\copyrightoffset}
\setlength{\copyrightoffset}{-6em}
\addtolength{\copyrightoffset}{\ADOC@copyrightoffset}
%\RequirePackage{fancybox}
\newcommand{\AtlasAbstractCopyright}{%
  \begin{minipage}[b][\abstractheight]{\abstractparbox}
    % Astract
    \if\AtlasAbstractText\@empty
      \mbox{}
    \else
      \begin{quote}
      \ifx\ADOC@draftversion\@empty%
        \AtlasAbstractText\par
      \else
        \begin{internallinenumbers}
          \AtlasAbstractText
        \end{internallinenumbers}\par
      \fi
      \end{quote}
    \fi
    % Submission details
    \ifx\ADOC@journal\@empty
      \relax
    \else
      \ifADOC@PAPER
        \vskip 2em
        \parbox[c]{\linewidth}{
          \centering
          \ADOC@subprepend\ \textit{\ADOC@journal}
        }\par
        \vskip 2em
      \fi
    \fi
    \vspace*{\stretch{1}}
    \AtlasCopyrightFooter
  \end{minipage}\par
  \vspace*{\copyrightoffset}
}

\publishers{\normalsize\rmfamily\AtlasAbstractCopyright}
\else
  % Use AtlasCoverTitle for title page
  \typeout{atlasdoc1: redefining the maketitle command to MakeAtlasCoverTitle}
  \renewcommand\maketitle{%
    \MakeAtlasCoverTitle
  }
\fi

% Cover page needs to be made after preamble, as otherwise title page comes first!
% Deprecated option, but kept for backwards compatibility
%\ifADOC@maketitle
%  %\AfterEndPreamble{%
%  \AtBeginDocument{%
%    \typeout{atlasdoc1: deprecated maketitle option set}
%    \ifADOC@koma
%      \typeout{atlasdoc1: executing MakeAtlasCoverTitle from atlasdoc1!}
%      \MakeAtlasCoverTitle
%    \else
%      \typeout{atlasdoc1: executing MakeAtlasCoverTitle from atlasdoc1!}
%      \MakeAtlasCoverTitle
%    \fi
%  }
%\fi

\AtBeginDocument{%
  % Deprecated option, but kept for backwards compatibility
  \ifADOC@maketitle
    \typeout{atlasdoc1: deprecated maketitle option set}
    \typeout{atlasdoc1: executing MakeAtlasCoverTitle}
    \MakeAtlasCoverTitle
  \else
    % Cover pages - add here, so atlascover options work
    \ifADOC@coverpage
      \extratitle{%
        % Turn line numbers off for cover pages
        \nolinenumbers
        \ACOV@PrintAtlasCover
        \ACOV@PrintAtlasCoverPageTwo
        % Turn line numbers back on
        \ifx\ADOC@draftversion\@empty%
          \relax
        \else
          \linenumbers
        \fi
      }
    \fi
  \fi
  % Add draft heading and line numbers
  \ifx\ADOC@draftversion\@empty
    \typeout{atlasdoc1: this is not an ATLAS draft}
  \else 
    \typeout{atlasdoc1: this is an ATLAS draft}
    \AtlasDraftHeading
    \linenumbers
  \fi
}

\endinput
