%-------------------------------------------------------------------------------
% Template class for ATLAS documents
%
% See ChangeLog or SVN log for history of changes.
% Responsible: Ian Brock (ian.brock@cern.ch)
%-------------------------------------------------------------------------------
\def\ATPackageVersion{03-00-03}

\ProvidesClass{latex/atlasdoc}[2017/03/31 v.03-00-03 ATLAS document class]
% Needs 2009 TeX Live or later
\NeedsTeXFormat{LaTeX2e}[2009/01/01]

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
\DeclareBoolOption[false]{BOOK}
\DeclareBoolOption[false]{auxmat}
\DeclareStringOption[2016]{texlive}
\DeclareStringOption{paper}
\DeclareStringOption[normal]{titlesize}
\DeclareBoolOption[true]{floatopt}
\DeclareBoolOption[false]{texmf}
\DeclareBoolOption[true]{newtx}
\DeclareBoolOption[false]{txfonts}
\DeclareBoolOption[false]{libertine}
\DeclareBoolOption[false]{palatino}
\DeclareBoolOption[false]{mhchem}
\DeclareBoolOption[true]{datetop}
\DeclareBoolOption[false]{showframe}
\DeclareStringOption[0pt]{titleextraheight}
\DeclareStringOption[0pt]{copyrightoffset}
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
  \ADOC@BOOKfalse
\else
  \ifADOC@CONF
    \typeout{atlasdoc: ATLAS CONF note}
    \renewcommand*{\ADOC@docheadingdefault}{ATLAS CONF Note}
    \ADOC@PAPERfalse
    \ADOC@NOTEfalse
    \ADOC@CONFnotetrue
    \ADOC@PUBnotefalse
    \ADOC@BOOKfalse
  \else
    \ifADOC@PUB
      \typeout{atlasdoc: ATLAS PUB note}
      \renewcommand*{\ADOC@docheadingdefault}{ATLAS PUB Note}
      \ADOC@PAPERfalse
      \ADOC@NOTEfalse
      \ADOC@CONFnotefalse
      \ADOC@PUBnotetrue
      \ADOC@BOOKfalse
    \else
      \ifADOC@BOOK
        \typeout{atlasdoc: ATLAS BOOK}
        \ADOC@PAPERfalse
        \ADOC@NOTEfalse
        \ADOC@CONFnotefalse
        \ADOC@PUBnotefalse
        \ADOC@BOOKtrue
      \else
        \typeout{atlasdoc: ATLAS Note}
        \renewcommand*{\ADOC@docheadingdefault}{}
      \fi
    \fi
  \fi
\fi

% Decide on the main class
\ifADOC@BOOK
  \typeout{atlasdoc: use KOMA-script scrbook class}
  \def\ADOC@mainclass{scrbook}
\else
  \typeout{atlasdoc: use KOMA-script scrartcl class}
  \def\ADOC@mainclass{scrartcl}
\fi

% Set paper size
\ifx\ADOC@paper\@empty
  \def\ADOC@paperstring{a4paper}
  \PassOptionsToClass{a4paper}{\ADOC@mainclass}
  \typeout{atlasdoc: paper size set to default A4}
\else
  \def\ADOC@paperstring{\ADOC@paper paper}
  \PassOptionsToClass{\ADOC@paperstring}{\ADOC@mainclass}
  \typeout{atlasdoc: paper is \ADOC@paper, string for class is \ADOC@paperstring}
\fi

% Set font sizes for title page
%\ifthenelse{\ADOC@texlive < 2013}{%
%    \typeout{*** atlasdoc: reduced font sizes not available for TeX Live < 2013}
%    \newcommand*{\ADOC@abstractsize}{\normalsize}
%}{%
  \ifthenelse{\equal{\ADOC@titlesize}{small}}{%
    \newcommand*{\ADOC@maintitlesize}{\LARGE}
    \newcommand*{\ADOC@authorsize}{\large}
    \newcommand*{\ADOC@abstractsize}{\small}
  }{%
    \newcommand*{\ADOC@maintitlesize}{\huge}
    \newcommand*{\ADOC@authorsize}{\Large}
    \newcommand*{\ADOC@abstractsize}{\normalsize}
  }
%}

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
\ifADOC@BOOK
  \LoadClass[titlepage,11pt]{scrbook}
  %\LoadClass[titlepage,11pt,twoside=semi]{scrbook}
\else
  \LoadClass[titlepage,11pt]{scrartcl}
  %\LoadClass[titlepage,11pt,twoside=semi]{scrartcl}
\fi

% Turn on bold math when using \bfseries
\def\bfseries{\fontseries\bfdefault\selectfont\boldmath}

% Set KOMA-script options for ATLAS style
\ifADOC@atlasstyle
  \KOMAoptions{headinclude=true, footinclude=false}
  % Put less text on the pages of BOOKs etc.
  \ifADOC@BOOK
    \KOMAoptions{DIV=12, BCOR=5mm, twoside}
  \else
    \KOMAoptions{DIV=14, BCOR=5mm}
  \fi
  % Do not put a dot after Section/Chapter, nor in the figure caption.
  \KOMAoptions{numbers=noendperiod}
  % Paragraph spacing is half a line
  \KOMAoptions{parskip=half}
  \addtokomafont{disposition}{\rmfamily}
  \ifthenelse{\ADOC@texlive < 2013}{%
    \relax
  }{%
    \addtokomafont{author}{\ADOC@authorsize}
  }
  \addtokomafont{part}{\LARGE}
  \addtokomafont{descriptionlabel}{\rmfamily}
  %\setkomafont{pageheadfoot}{\normalsize\sffamily}
  \setkomafont{pagehead}{\normalsize\rmfamily}
  %\setkomafont{publishers}{\normalsize\rmfamily}
  \setkomafont{caption}{\normalfont\small}
  \setcapindent{0pt}
  \deffootnote[1em]{1em}{1em}{\textsuperscript{\thefootnotemark}\ }
\fi

% Adjust font size for title
% For recent TeX Live version use xpatch. Have to use etoolbox for older versions.
\ifthenelse{\ADOC@texlive < 2013}{%
  \RequirePackage{etoolbox}
  \tracingpatches
  \expandafter\patchcmd\csname\string\maketitle\endcsname{\huge \@title \par}{\ADOC@maintitlesize \@title \par}{\typeout{atlasdoc etoolbox: OK! Title size changed!}}{\typeout{atlasdoc etoolbox: Oh no! Title still huge!}}
}{%
  % mhchem has to come before xpatch for TeX Live 2014
  \ifthenelse{\ADOC@texlive = 2014}{%
    \ifADOC@mhchem
      \RequirePackage[version=3]{mhchem}
    \fi
  }{}
  \RequirePackage{xpatch}
  % \xshowcmd\maketitle
  \xpatchcmd{\maketitle}{\usekomafont{title}{\huge \@title \par}}{\usekomafont{title}{\ADOC@maintitlesize \@title \par}}{\typeout{atlasdoc xpatch: OK! Title size changed!}}{\typeout{atlasdoc xpatch: Oh no! Title size is still huge!}}
}

% Some tweaks to remove the date from \maketitle
%\expandafter\show\csname\string\maketitle\endcsname
%\expandafter\show\csname\string\maketitle\space\endcsname
\ifADOC@datetop
  \ifthenelse{\ADOC@texlive < 2013}{%
    % Remove \@date and spacing following it from \@maketitle
    \expandafter\patchcmd\csname\string\maketitle\endcsname{{\Large \@date \par}\vskip \z@ \@plus 3fill}{}{\typeout{atlasdoc etoolbox: OK! Date removed!}}{\typeout{atlasdoc etoolbox: Oh no! Date is still there!}}
  }{% \xshowcmd\maketitle
    % Remove \@date and spacing following it from \@maketitle
    \xpatchcmd{\maketitle}{{\usekomafont{date}{\@date \par}}\vskip \z@ \@plus 3fill}{}{\typeout{atlasdoc xpatch: OK! Date font adjusted!}}{\typeout{atlasdoc xpatch: Oh no! Date font unchanged!}}
    % \xshowcmd\maketitle
  }
\fi

% ATLAS draft cover pages for papers, PUB and CONF notes
\def\ADOC@atlascover{\ATLASLATEXPATH atlascover}
\ifADOC@coverpage
  \typeout{atlasdoc: load atlascover package}
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
  \typeout{atlasdoc: using txfonts}
  \RequirePackage[varg]{txfonts}
  \RequirePackage[T1]{fontenc}
  % Pass eVkern option to atlaspackage for siunitx
  \def\ADOC@atlaspackage{\ATLASLATEXPATH atlaspackage}
  \PassOptionsToPackage{eVkern}{\ADOC@atlaspackage}
\else
  \ifADOC@libertine
    \typeout{atlasdoc: using Libertine fonts}
    \RequirePackage{libertine}
    \RequirePackage[T1]{fontenc}
    \RequirePackage[libertine]{newtxmath}
  \else
    \ifADOC@palatino
      \typeout{atlasdoc: using Palatino fonts}
      % Palatino for rm and math | Helvetica for ss | Courier for tt
      \RequirePackage{mathpazo} % math & rm
      \linespread{1.05}        % Palatino needs more leading (space between lines)
      \RequirePackage[scaled]{helvet} % ss
      \RequirePackage{courier} % tt
      \normalfont
      \RequirePackage[T1]{fontenc}
    \else
      \typeout{atlasdoc: using newtx fonts package}
      \RequirePackage{newtxtext}
      \ifthenelse{\ADOC@texlive < 2013}{%
        \typeout{*** atlasdoc: include amsmath before newtxmath}
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
  \RequirePackage[headsepline]{scrpage2}
  \ihead{}
  \chead[]{\fbox{\textsf\bfseries DRAFT}}
  \ohead{}
  \ifoot{\dateandtime}
  \cfoot{}
  \ofoot{\thepage}
  \pagestyle{scrheadings}
}

% Include fancier header and footer for auxiliary material document
\ifADOC@auxmat
  \RequirePackage[headsepline]{scrpage2}
  \chead{ATLAS Collaboration -- arXiv:\AtlasArXivId\ \AtlasArXivCat}
  \pagestyle{scrheadings}
\fi

% BOOK, i.e. book heading/footer code
\newcommand{\AtlasBookHeading}{%
  \RequirePackage[headsepline]{scrpage2}
  \ifx\ADOC@draftversion\@empty%
    \relax
  \else
    \ihead{DRAFT}
    \ifoot{\dateandtime}
  \fi
  \pagestyle{scrheadings}
}

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
       \includegraphics[height=25mm]{University_of_Washington_Seal.png}
    }
    \hspace*{\fill}
    \parbox[b][35mm][c]{0.48\titlepageparbox}{%
      \centering
        {\sffamily\bfseries\fontsize{20}{24}\selectfont
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
        \vspace*{1.5ex}
        % Date, if any
        \ifADOC@datetop
          \ifx\@date\@empty
            \mbox{}\par
          \else
            \@date\par
          \fi
        \fi
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
      \sffamily\mdseries\fontsize{14}{16.8}\selectfont
      EUROPEAN ORGANISATION FOR NUCLEAR RESEARCH (CERN)\par
    }
    \vspace*{2mm}
    \parbox[t]{0.45\linewidth}{%
%      \includegraphics[height=25mm]{AT_atlaslogo_2015}\par
      \includegraphics[height=25mm]{University_of_Washington_Seal.png}\par
      \sffamily\mdseries\fontsize{11}{13.2}\selectfont
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
      \sffamily\mdseries\fontsize{11}{13.2}\selectfont
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
      \sffamily\mdseries\fontsize{14}{16.8}\selectfont 
      EUROPEAN ORGANISATION FOR NUCLEAR RESEARCH (CERN)\par
    }
    \vspace*{2mm}
    \parbox[t]{0.45\linewidth}{%
%      \includegraphics[height=25mm]{AT_atlaslogo_2015}\par
      \includegraphics[height=25mm]{University_of_Washington_Seal.png}\par
      \sffamily\mdseries\fontsize{11}{13.2}\selectfont 
      arXiv: \AtlasArXivId\ \AtlasArXivCat
    }
    \hspace*{\fill}
    \parbox[t]{0.45\linewidth}{%
      \hspace*{\fill}\includegraphics[height=25mm]{AT_cernlogo}\par
      \sffamily\mdseries\fontsize{11}{13.2}\selectfont 
      \hspace*{\fill}\ADOC@preprintnumber\par
      \hspace*{\fill}\ADOC@atlasdate\par
    }\par
    \vspace*{2mm}
    \rule{\linewidth}{1pt}\par
  }
}

%-------------------------------------------------------------------------------
% ATLAS document title body
%\newcommand{\AtlasTitleBody}{%
%  {\centering
%    {\bfseries\fontsize{16}{19.2}\selectfont \@title \par}
%    \vskip 3em
%    {\large
%     \lineskip .75em
%     \begin{tabular}[t]{c}
%       \@author
%     \end{tabular}\par}
%  }\par
%  \vspace{\stretch{0.5}}
%  % Astract
%  \if\AtlasAbstractText\@empty
%    \mbox{}
%  \else
%    {\centering
%      \bfseries\fontsize{12}{14.4}\selectfont
%      \abstractname\par
%    }
%    {\fontseries{m}\fontsize{11}{13.2}\selectfont%
%      \begin{quote}
%        %\setlength{\parindent}{0pt}\setlength{\parskip}{0.5ex}\noindent\AtlasAbstractText
%        \AtlasAbstractText
%      \end{quote}
%    }
%  \fi
%  % Submission details
%  \ifx\ADOC@journal\@empty
%    \relax
%  \else
%    \ifADOC@PAPER
%      \vspace{\stretch{1}}
%      \parbox[c]{\linewidth}{
%        \centering
%        \ADOC@subprepend\ \textit{\ADOC@journal}
%      }\par
%      \vspace{\stretch{1}}
%    \fi
%  \fi
%}

%-------------------------------------------------------------------------------
% CERN Preprint title body
%\newcommand{\CERNPreprintTitleBody}{%
%  \parbox[t]{\linewidth}{%
%    {\centering
%      \bfseries\fontsize{16}{19.2}\selectfont 
%      %\fontfamily{phv}\bfseries\fontsize{16}{19.2}\selectfont 
%      \AtlasTitleText\par
%    }
%    \vspace*{6ex}
%    {\centering
%      \fontseries{m}\fontsize{12}{14.4}\selectfont
%      %\fontfamily{phv}\fontseries{m}\fontsize{12}{14.4}\selectfont
%      The ATLAS Collaboration\par
%    }
%    \vspace*{6ex}
%    {\centering
%      \bfseries\fontsize{12}{14.4}\selectfont
%      %\fontfamily{phv}\bfseries\fontsize{12}{14.4}\selectfont
%      \abstractname\par
%    }
%    {\fontseries{m}\fontsize{11}{13.2}\selectfont%
%      %\fontfamily{phv}\fontseries{m}\fontsize{11}{13.2}\selectfont%
%      \begin{quote}
%      %\setlength{\parindent}{0pt}\setlength{\parskip}{0.5ex}\noindent\AtlasAbstractText
%        \AtlasAbstractText
%      \end{quote}
%    }
%  }
%}

%-------------------------------------------------------------------------------
% Auxiliary material title body
%\newcommand{\AuxmatTitleBody}{%
%  \parbox[t]{\linewidth}{%
%    {\centering
%      \bfseries\fontsize{16}{19.2}\selectfont 
%      %\fontfamily{phv}\bfseries\fontsize{16}{19.2}\selectfont 
%      Auxiliary figures and tables related to the paper\\[1.5ex]
%      \AtlasTitleText\par
%    }
%    \vspace*{2ex}
%    {\centering
%      \fontseries{m}\fontsize{12}{14.4}\selectfont
%      %\fontfamily{phv}\fontseries{m}\fontsize{12}{14.4}\selectfont
%      The ATLAS Collaboration\par
%    }
%    \vspace*{2ex}
%    {\centering
%      \fontseries{m}\fontsize{12}{14.4}\selectfont
%      %\fontfamily{phv}\fontseries{m}\fontsize{12}{14.4}\selectfont
%      \ADOC@refcode\par
%    }
%    \vspace*{2ex}
%    {\centering
%      \bfseries\fontsize{12}{14.4}\selectfont
%      %\fontfamily{phv}\bfseries\fontsize{12}{14.4}\selectfont
%      \abstractname\par
%    }
%    {\centering
%      \fontseries{m}\fontsize{11}{13.2}\selectfont%
%      %\fontfamily{phv}\fontseries{m}\fontsize{11}{13.2}\selectfont%
%      \begin{quote}
%      %\setlength{\parindent}{0pt}\setlength{\parskip}{0.5ex}\noindent\AtlasAbstractText
%        \AtlasAbstractText
%      \end{quote}
%    }
%  }
%}

%-------------------------------------------------------------------------------
% Copyright cover footer - parbox does not introduce spurious vertical space
\newcommand{\AtlasCopyrightFooter}{%
  \parbox[b]{\linewidth}{%
    \rmfamily\mdseries\fontsize{10}{12}\selectfont
    \copyright\ \the\year \ CERN for the benefit of students based on the ATLAS Collaboration LaTeX template.\newline
    Reproduction of this article or parts of it is allowed as specified in the CC-BY-4.0 license.
  }\par
}

% Add elements to KOMA-Script title page
% Header
\ifADOC@cernpreprint
  \typeout{atlasdoc: defining CERN preprint title page}
  \titlehead{\CERNPreprintTitleHeader}
  \date{}%\vspace*{-5ex}}
\else
  \ifADOC@auxmat
    \typeout{atlasdoc: defining Auxiliary Material title page}
    \titlehead{\AuxmatTitleHeader}
    \date{}%\vspace*{-5ex}}
  \else
    \typeout{atlasdoc: defining ATLAS document title page}
    \titlehead{\AtlasTitleHeader}
  \fi
\fi

% Body and copyright
\newlength{\abstractparbox}
\setlength{\abstractparbox}{\textwidth}
% \addtolength{\abstractparbox}{-2\fboxrule}
% \addtolength{\abstractparbox}{-2\fboxsep}
\newlength{\abstractheight}
\setlength{\abstractheight}{0.50\textheight}
\addtolength{\abstractheight}{-\ADOC@titleextraheight}
\newlength{\copyrightoffset}
\ifthenelse{\equal{\ADOC@maintitlesize}{small}}{%
  \setlength{\copyrightoffset}{-7.5em}
}{%
  \setlength{\copyrightoffset}{-7.5em}
}
\addtolength{\copyrightoffset}{\ADOC@copyrightoffset}
\newcommand{\AtlasAbstractCopyright}{%
  \vspace*{\stretch{1}}
  % \fbox{\begin{minipage}[b][\abstractheight]{\abstractparbox}
  \begin{minipage}[b][\abstractheight]{\abstractparbox}
    % Astract
    \if\AtlasAbstractText\@empty
      \mbox{}
    \else
      \begin{quote}\ADOC@abstractsize
      \ifx\ADOC@draftversion\@empty%
        \AtlasAbstractText\par
      \else
        \begin{internallinenumbers}
          \AtlasAbstractText
        \end{internallinenumbers}\par
      \fi
      \end{quote}
    \fi
    %\vspace*{\stretch{1}}
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
  % \end{minipage}}\par
  \vspace*{\copyrightoffset}
}

\publishers{\normalsize\rmfamily\AtlasAbstractCopyright}

\AtBeginDocument{%
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
  % Add heading for books (i.e. TDR)
  \ifADOC@BOOK
    \AtlasBookHeading
    % Add draft heading and line numbers
    \ifx\ADOC@draftversion\@empty%
      \typeout{atlasdoc: this is not an ATLAS draft book}
    \else 
      \typeout{atlasdoc: this is an ATLAS draft book}
      \linenumbers
    \fi
  \else
    % Add draft heading and line numbers
    \ifx\ADOC@draftversion\@empty%
      \typeout{atlasdoc: this is not an ATLAS draft article}
    \else 
      \typeout{atlasdoc: this is an ATLAS draft article}
      \AtlasDraftHeading
      \linenumbers
    \fi
  \fi
}

\endinput
