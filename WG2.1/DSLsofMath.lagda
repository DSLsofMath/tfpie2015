% --*-Latex-*--

\documentclass[colorhighlight,coloremph]{beamer}
\usetheme{boxes}
\usetheme{Madrid} % Lots of space (good), but no section headings
%\usetheme{Hannover}% Sections heading but too much wasted space
%\usetheme{Dresden}
%\usetheme{Warsaw}
\usepackage{natbib}
\usepackage{color,soul}
\usepackage{graphicx}
\usepackage{hyperref} %% for run: links
%include dslmagda.fmt
%include DSLsofMath.format

%%\input{macros.TeX}

% Changing the way code blocks are presented:
% \renewcommand\hscodestyle{%
%    \setlength\leftskip{-1cm}%
%    \small
% }

\newenvironment{myquote}
  {\begin{exampleblock}{}}
  {\end{exampleblock}}
%\renewcommand{\inserttotalframenumber}{}
%\renewcommand*{\inserttotalframenumber}{}
% \renewcommand{\insertframenumber}{}
\newtheorem*{def*}{Definition}
\addheadbox{section}{\quad \tiny ACCFun, 2015-08-25}
\title[DSLsofMath]{DSLM: Presenting Mathematical Analysis Using Functional Programming}

\author[C. Ionescu and P. Jansson]
       {Cezar Ionescu \hspace{2.5cm} Patrik Jansson\\
        cezar@@chalmers.se \hspace{2cm} patrikj@@chalmers.se}
%       {Cezar Ionescu  \qquad {\small \texttt{cezar@@chalmers.se}} \and
%        Patrik Jansson \qquad {\small \texttt{patrikj@@chalmers.se}} }

\begin{document}
\setbeamertemplate{navigation symbols}{}
\date{}
\begin{frame}

\maketitle

Paper + talk: \url{https://github.com/DSLsofMath/tfpie2015}

\begin{exampleblock}{Style example}
\begin{spec}
Forall (eps elemOf Real) ((eps > 0)  =>  (Exists (a elemOf A) ((abs(a - sup A)) < eps)))
\end{spec}
\end{exampleblock}

\end{frame}



%% -------------------------------------------------------------------
\section{Intro}

\begin{frame}
\frametitle{Background}
\vfill

\emph{Domain-Specific Languages of Mathematics}
\citep{dslmcourseplan}: is a course currently developed at Chalmers in
response to difficulties faced by third-year students in learning and
applying classical mathematics (mainly real and complex analysis)

Main idea: encourage students to approach mathematical domains from a
functional programming perspective (similar to
\cite{wells1995communicating}).

\vfill

\begin{exampleblock}{}
``... ideally, the course would improve the mathematical education of computer scientists and the computer science education of mathematicians.''
\end{exampleblock}


\end{frame}


%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Introduction}

\begin{itemize}
\item make functions and types explicit

\item make the distinction between syntax and semantics explicit

\item use types (|Real|, |CC|) as carriers of semantic information,
  not just variable names (|x|, |z|)

\item introduce functions and types for implicit operations such as
  the power series interpretation of a sequence

\item use a calculational style for proofs

\item organize the types and functions in DSLs
\end{itemize}

Not working code, rather working understanding of concepts

\end{frame}

%% -------------------------------------------------------------------

\section{Types}
\begin{frame}
\frametitle{Complex numbers}
\begin{myquote}
  We begin by defining the symbol |i|, called \textbf{the imaginary unit}, to
  have the property

>      square i = -1

  Thus, we could also call |i| the square root of |-1| and denote it
  |sqrt (-1)|. Of course, |i| is not a real number; no real number has
  a negative square.
\end{myquote}

\hfill (\cite{adams2010calculus}, Appendix I)

\pause

> data I = i

\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Complex numbers}

\begin{myquote}
  \textbf{Definition:} A \textbf{complex number} is an expression of
  the form

>  a + bi {-"\qquad \mathrm{or} \qquad"-} a + ib,

  where |a| and |b| are real numbers, and |i| is the imaginary unit.
\end{myquote}

\pause

> data Complex  =  Plus1 Real Real I
>               |  Plus2 Real I Real

> show :  Complex     ->  String
> show (Plus1 x y i)  =   show x ++ " + " ++ show y ++ "i"
> show (Plus2 x i y)  =   show x ++ " + " ++ "i" ++ show y

\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Complex numbers examples}

\begin{myquote}
  \textbf{Definition:} A \textbf{complex number} is an expression of
  the form

>  a + bi {-"\qquad \mathrm{or} \qquad"-} a + ib,

  where |a| and |b| are real numbers, and |i| is the imaginary unit.
\end{myquote}

\begin{myquote}
  For example, |3 + 2i|, |div 7 2 - (div 2 3)i| , |i(pi) = 0 + i(pi)| , and |-3 =
  -3 + 0i| are all complex numbers.  The last of these examples shows
  that every real number can be regarded as a complex number.
\end{myquote}



\end{frame}

%% -------------------------------------------------------------------



\begin{frame}
\frametitle{Complex numbers examples}
\begin{myquote}
  For example, |3 + 2i|, |div 7 2 - (div 2 3)i| , |i(pi) = 0 + i(pi)| , and |-3 =
  -3 + 0i| are all complex numbers.  The last of these examples shows
  that every real number can be regarded as a complex number.
\end{myquote}


> data Complex  =  Plus1 Real Real I
>               |  Plus2 Real I Real

> toComplex : Real -> Complex
> toComplex x = Plus1 x 0 i


\begin{itemize}
\item what about |i| by itself?
\item what about, say, |2i|?
\end{itemize}

\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Complex numbers version 2.0}
\begin{myquote}
  (We will normally use |a + bi| unless |b| is a complicated
  expression, in which case we will write |a + ib| instead. Either
  form is acceptable.)
\end{myquote}


> data Complex = Plus Real Real I

> data Complex = PlusI Real Real

\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Name and reuse}
\begin{myquote}
  It is often convenient to represent a complex number by a single
  letter; |w| and |z| are frequently used for this purpose. If |a|,
  |b|, |x|, and |y| are real numbers, and |w = a + bi| and |z = x +
  yi|, then we can refer to the complex numbers |w| and |z|. Note that
  |w = z| if and only if |a = x| and |b = y|.
\end{myquote}

> newtype Complex = C (Real, Real)

\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Equality and pattern-matching}
\begin{myquote}
  \textbf{Definition:} If |z = x + yi| is a complex number (where |x|
  and |y| are real), we call |x| the \textbf{real part} of |z| and denote it
  |Re (z)|. We call |y| the \textbf{imaginary part} of |z| and denote it |Im
  (z)|:

> Re(z)  =  Re (x+yi)    =  x
> Im(z)  =  Im (x + yi)  =  y

\end{myquote}

> Re : Complex       ->  Real
> Re z @ (C (x, y))  =   x

> Im : Complex       ->  Real
> Im z @ (C (x, y))  =   y

\end{frame}


%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Shallow vs. deep embeddings}
%{
%format == = "{=}"
\begin{myquote}
  \textbf{The sum and difference of complex numbers}

  If |w == a + bi| and |z == x + yi|, where |a|, |b|, |x|, and |y| are real numbers,
  then

> w  +  z  =  (a + x)  +  (b + y)i
>
> w  -  z  =  (a - x)  +  (b - y)i
\end{myquote}
%}
\begin{overprint}
\onslide<1>
\textbf{Shallow embedding}:

> (+)  :  Complex -> Complex -> Complex
> (C (a, b)) + (C (x, y))  =  C ((a + x), (b + y))
>
> newtype Complex = C (Real, Real)

\onslide<2>
\textbf{Deep embedding}:

> (+)  :  Complex -> Complex -> Complex
> (+) = Plus
>
> data Complex  =  i
>               |  ToComplex Real
>               |  Plus   Complex  Complex
>               |  Times  Complex  Complex
>               |  ...

\end{overprint}
\end{frame}



%% -------------------------------------------------------------------
\section{Proofs}

\begin{frame}[fragile]
\frametitle{Abstraction barriers}
\vfill

Example: continuity defined in terms of limits.

\begin{def*}[\cite{adams2010calculus}, page 78]

We say that a function |f| is {\bfseries continuous} at an interior point
|c| of its domain if

< limxc (f x) = f c

If either |limxc (f x)| fails to exist or it exists but is not equal
to |f c|, then we will say that |f| is {\bfseries discontinuous} at |c|.

\end{def*}

\vfill
\end{frame}


%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Abstraction barriers}
\vfill
Differentiability defined in terms of limits.

\begin{def*}[\cite{adams2010calculus}, page 99]

The derivative of a function |f| is another function |f'| defined by

%%< f' x = limfrac (f(x + h) - f(x)) (h)

< f' x = limdiff

at all points |x| for which the limit exists (i.e., is a finite real
number). If |f' (x)| exists, we say that |f| is {\bfseries differentiable}
at |x|.

\end{def*}
\vfill
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Abstraction barriers}
\vfill

Alternative: differentiability in terms of continuity.

\begin{def*}[Adapted from \cite{pickert1969einfuehrung}]

Let |X included Real, a elemOf X| and |f : X -> Real|.  If there
exists a function |phif : X -> X -> Real| such that, for all |x elemOf
X|

< f x = f a + (x - a) * phif a x

\underline{such that |phif a : X -> Real| continuous at |a|}, then |f| is
{\bfseries differentiable} at |x|.  The value |phif a a| is called the
{\bfseries derivative} of |f| at |a| and is denoted |f' a|.
\end{def*}


\vfill
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{A calculational proof}
\vfill
\small
\def\commentbegin{\quad\{\ }
\def\commentend{\}}
\newcommand{\gap}{\pause\vspace{-0.7cm}}
\begin{spec}
   {-"\quad"-} (f x) * (g x)
\end{spec}
\gap
\begin{spec}
= {- differentiability -}

   (f a + (x - a) * phif a x) * (g a + (x - a) * phig a x)
\end{spec}
\gap
\begin{spec}
= {- arithmetic -}

   f a * g a                              +  {-"\quad"-}  f a * (x - a) * phig a x  +
   (x - a) * phif a x * g a  {-"\quad"-}  +  {-"\quad"-}  (x - a) * phif a x * (x - a) * phig a x
\end{spec}
%   (x - a)  *  (g a  *  phif a x  +
%%                        phig a x  *  (f a + (x - a) * phif a x))
\gap
\begin{spec}
= {- factor out |(x - a)| to get |h a + (x - a) * phih a x| -}

   f a * g a  +  (x - a)  *  (f a * phig a x  +  phif a x * g a  +
                              phif a x * (x - a) * phig a x)
\end{spec}
\gap
\begin{spec}
= {- ``pattern-matching'' -}

   h a  +  (x - a) * phih a x
     where  h x       =  f x * g x
            phih a x  =  f a * phig a x  +  phif a x * g a  +
                          phif a x * (x - a) * phig a x
\end{spec}
\pause
%
Therefore, by continuity of composition and differentiability:

\begin{spec}
   h' a = phih a a = f a * g' a + f' a * g a

\end{spec}

\vfill
\end{frame}



%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Conclusions}

\begin{itemize}
\item make functions and types explicit: |Re : Complex -> Real|, |phif : X -> X -> Real|

\item make the distinction between syntax and semantics explicit

\item use types (|Real|, |CC|) as carriers of semantic information,
  not just variable names (|x|, |z|)

\item pay attention to abstraction barriers (such as limits,
  continuity, differentiability)

\item introduce functions and types for implicit operations such as
  |toComplex : Real -> Complex|

\item use a calculational style for proofs

\item organize the types and functions in DSLs (for |Complex|, limits,
  power series, etc.)
\end{itemize}

\end{frame}


%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Future work}

Partial implementation in Agda:

\begin{itemize}
\item errors caught by formalization (but no ``royal road'')
  \begin{itemize}
  \item Mixing up names of the same type
  \item |choice| function
  \end{itemize}
\item subsets and coercions
  \begin{itemize}
  \item |eps : RPos|, different type from |RPosz| and |Real| and |CC|
  \item what is the type of |abs|? (|CC -> RPosz|?)
  \item other subsets of |Real| or |CC| are common, but closure
    properties unclear
  \end{itemize}
\end{itemize}
\end{frame}

%% -------------------------------------------------------------------

\appendix
\section{Bibliography}
\begin{frame}
\frametitle{Bibliography}

\bibliographystyle{abbrvnat}
\bibliography{../lagda/dslm}
\end{frame}


\end{document}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{}
\vfill
\vfill
\end{frame}

%% -------------------------------------------------------------------
