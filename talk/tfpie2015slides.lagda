% --*-Latex-*--

\documentclass[colorhighlight,coloremph]{beamer}
\usetheme{boxes}
\usetheme{Warsaw}
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
\title{DSLM: Presenting Mathematical Analysis Using Functional Programming}

\author[C. Ionescu and P. Jansson]
       {Cezar Ionescu \hspace{2.5cm} Patrik Jansson\\
        cezar@@chalmers.se \hspace{2cm} patrikj@@chalmers.se}
%       {Cezar Ionescu  \qquad {\small \texttt{cezar@@chalmers.se}} \and
%        Patrik Jansson \qquad {\small \texttt{patrikj@@chalmers.se}} }

\begin{document}
\setbeamertemplate{navigation symbols}{}
\date{}
\frame{\maketitle}



%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Background}
\vfill
\emph{Domain-Specific Languages of Mathematics}
\cite{dslmcourseplan}: course currently  developed at
Chalmers in response to difficulties faced by third-year students in
learning and applying classical mathematics (mainly real and complex
analysis)

Main idea is to encourage the students to approach
mathematical domains from a functional programming perspective
\vfill
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

> show                :  Complex -> String
> show (Plus1 x y i)  =  show x ++ " + " ++ show y ++ "i"
> show (Plus2 x i y)  =  show x ++ " + " ++ "i" ++ show y

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

> Re : Complex -> Real
> Re z @ (C (x, y))  =  x

> Im : Complex -> Real
> Im z @ (C (x, y))  =  y

\end{frame}


%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Shallow vs. deep embeddings}
\begin{myquote}
  \textbf{The sum and difference of complex numbers}

  If |w = a + bi| and |z = x + yi|, where |a|, |b|, |x|, and |y| are real numbers,
  then

> w  +  z  =  (a + x)  +  (b + y)i
>
> w  -  z  =  (a - x)  +  (b - y)i
\end{myquote}
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
> data ComplexSyntax  =  C (Real, Real)
>                     |  Plus   Complex  Complex
>                     |  Times  Complex  Complex
>                     |  ...

\onslide<3>
\textbf{Deep embedding}:

> (+)  :  ComplexSyntax -> ComplexSyntax -> ComplexSyntax
> (+) = Plus
>
> data ComplexSyntax  =  C (Real, Real)
>                     |  Plus   ComplexSyntax  ComplexSyntax
>                     |  Times  ComplexSyntax  ComplexSyntax
>                     |  ...

\end{overprint}
\end{frame}



%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Completness property}
\begin{myquote}

    The \emph{completeness} property of the real number system is more
    subtle and difficult to understand. One way to state it is as
    follows: if |A| is any set of real numbers having at least one
    number in it, and if there exists a real number |y| with the
    property that |x < y| for every |x elemOf A| (such a number |y| is
    called an \textbf{upper bound} for |A|), then there exists a
    smallest such number, called the \textbf{least upper bound} or
    \textbf{supremum} of |A|, and denoted |sup(A)|. Roughly speaking,
    this says that there can be no holes or gaps on the real
    line---every point corresponds to a real number.

\end{myquote}

\hfill (\cite{adams2010calculus}, page 4):

\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Min}

Specification (not implementation)

> min    :  PS X -> X
> min A  =  x ifandonlyif x elemOf A && ((Forall (a elemOf A) (x <= a)))

Example consequence:

\begin{quote}
  If |x elemOf X| and |x < min A|, then |x notElemOf A|.
\end{quote}
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Upper bounds}

> ubs    :  PS X -> PS X
> ubs A  =  { x | x elemOf X, x upper bound of A }
>        =  { x | x elemOf X, (Forall (a elemOf A) (a <= x)) }

The completeness axiom can be stated as

\begin{quote}
  If |ubs A noteq empty| then |min (ubs A)| is defined.
\end{quote}

\noindent
and we have that |sup = min . ubs|.

\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{A proof}
\vfill

\def\commentbegin{\quad\{\ }
\def\commentend{\}}
\begin{spec}
   eps > 0

=> {- arithmetic -}

   s - eps < s

=> {- |s = min (ubs A)|, property of |min| -}

   s - eps notElemOf ubs A

=> {- set membership -}

   not (Forall (a elemOf A) (a <= s - eps))

=> {- quantifier negation -}

   (Exists (a elemOf A) (s - eps < a))

=> {- definition of upper bound -}

   (Exists (a elemOf A) (s - eps < a <= s))

=> {- absolute value -}

   (Exists (a elemOf A) ((abs(a - s)) < eps))
\end{spec}

\vfill
\end{frame}


%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Conclusions}

\begin{itemize}
\item make functions and types explicit: |Re : Complex -> Real|, |min
  : PS X -> X|

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
  \item |ComplexSyntax|
  \item |choice| function
  \end{itemize}
\item subsets and coertions
  \begin{itemize}
  \item |RPos|
  \item |X| (``arbitrary subset of |Real| or |CC|''), but closure
    properties unclear
  \item what is the type of |abs|?  Can the result be used with
    elements of |X|?
  \end{itemize}
\end{itemize}
\end{frame}

%% -------------------------------------------------------------------

\end{document}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{}
\vfill
\vfill
\end{frame}

%% -------------------------------------------------------------------
