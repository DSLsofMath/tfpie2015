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
%include tfpie2015slides.format

%%\input{macros.TeX}

% Changing the way code blocks are presented:
% \renewcommand\hscodestyle{%
%    \setlength\leftskip{-1cm}%
%    \small
% }

\newenvironment{myquote}
  {\begin{exampleblock}{}}
  {\end{exampleblock}}

\addheadbox{section}{\quad \tiny TFPIE, 2015-06-02}
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

\item use types as carriers of semantic information, not just variable
  names

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
\textbf{Deep embedding (buggy)}:

> (+)  :  Complex -> Complex -> Complex
> (+) = Plus
>
> data ComplexDeep  =  i
>                   |  ToComplex Real
>                   |  Plus   Complex  Complex
>                   |  Times  Complex  Complex
>                   |  ...

\onslide<3>
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

\begin{frame}
\frametitle{Completeness property of |Real|}

Next: start from a more ``mathematical'' quote from the book:

\begin{myquote}

    The \emph{completeness} property of the real number system is more
    subtle and difficult to understand. One way to state it is as
    follows: if |A| is any set of real numbers having at least one
    number in it, and if there exists a real number |y| with the
    property that |x <= y| for every |x elemOf A| (such a number |y| is
    called an \textbf{upper bound} for |A|), then there exists a
    smallest such number, called the \textbf{least upper bound} or
    \textbf{supremum} of |A|, and denoted |sup(A)|. Roughly speaking,
    this says that there can be no holes or gaps on the real
    line---every point corresponds to a real number.

\end{myquote}

\hfill (\cite{adams2010calculus}, page 4)

\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Min (``smallest such number'')}

Specification (not implementation)

> min    :  PS+ Real -> Real
> min A  =  x ifandonlyif x elemOf A && ((Forall (a elemOf A) (x <= a)))

Example consequence (which will be used later):

\begin{quote}
  If |y < min A|, then |y notElemOf A|.
\end{quote}
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Upper bounds}

> ubs    :  PS Real -> PS Real
> ubs A  =  { x | x elemOf Real, x upper bound of A }
>        =  { x | x elemOf Real, (Forall (a elemOf A) (a <= x)) }

The completeness axiom can be stated as

\begin{quote}
  Assume an |A : PS+ Real| with an upper bound |u elemOf ubs A|.

  Then |s = sup A = min (ubs A)| exists.
\end{quote}

\noindent
where

> sup : PS+ Real -> Real
> sup = min . ubs

\end{frame}

\begin{frame}
\frametitle{Completeness and ``gaps''}

\begin{quote}
Assume an |A : PS+ Real| with an upper bound |u elemOf ubs A|.

Then |s = sup A = min (ubs A)| exists.
\end{quote}

But |s| need not be in |A| --- could there be a ``gap''?

\pause

With ``gap'' = ``an |eps|-neighbourhood between |A| and |s|'' we can
show there is no ``gap''.

\end{frame}


%% -------------------------------------------------------------------

\begin{frame}
\frametitle{A proof: Completeness implications step-by-step}
%\setlength{\parskip}{0cm}
\def\commentbegin{\quad\{\ }
\def\commentend{\}}
\newcommand{\gap}{\pause\vspace{-0.8cm}}
\begin{spec}
   eps > 0

=> {- arithmetic -}

   s - eps < s
\end{spec}
\gap
\begin{spec}
=> {- |s = min (ubs A)|, property of |min| -}

   s - eps notElemOf ubs A
\end{spec}
\gap
\begin{spec}
=> {- set membership -}

   not (Forall (a elemOf A) (a <= s - eps))
\end{spec}
\gap
\begin{spec}
=> {- quantifier negation -}

   (Exists (a elemOf A) (s - eps < a))
\end{spec}
\gap
\begin{spec}
=> {- definition of upper bound -}

   (Exists (a elemOf A) (s - eps < a <= s))
\end{spec}
\gap
\begin{spec}
=> {- absolute value -}

   (Exists (a elemOf A) ((abs(a - s)) < eps))
\end{spec}
% More details:
%   (Exists (a elemOf A) (- eps < a - s <= 0))
%   (Exists (a elemOf A) (- eps < a - s < eps))
%   (Exists (a elemOf A) (abs (a - s) < eps))

\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Completeness: proof interpretation (``no gaps'')}

To sum up the proof says that the completeness axiom implies:
\begin{spec}
proof : (Forall (eps elemOf Real) ((eps > 0)  =>  (Exists (a elemOf A) ((abs(a - sup A)) < eps))))
\end{spec}
\pause
\textbf{More detail:}

Assume a non-empty |A : PS Real| with an upper bound |u elemOf ubs A|.

Then |s = sup A = min (ubs A)| exists.

We know that |s| need not be in |A| --- could there be a ``gap''?

\pause

No, |proof| will give us an |a elemOf A| arbitrarily close to the
supremum.

So, there is no ``gap''.

\end{frame}



%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Conclusions}

\begin{itemize}
\item make functions and types explicit: |Re : Complex -> Real|, |min
  : PS+ Real -> Real|

\item use types as carriers of semantic information, not just variable
  names

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
  \item |ComplexDeep|
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
