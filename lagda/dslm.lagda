%-*-Latex-*-
\documentclass[adraft]{../eptcsstyle/eptcs}

% current annoyance: this will be fixed
% by the next update of agda.fmt
\def\textmu{}

\usepackage{amsmath}

\title{Domain-Specific Languages of Mathematics}

\author{Cezar Ionescu
\institute{Chalmers}
\email{cezar@@chalmers.se}
\and
Patrik Jansson
\institute{Chalmers}
\email{\quad patrikj@@chalmers.se}
}
\def\titlerunning{DSLM}
\def\authorrunning{C. Ionescu, P. Jansson}

\DeclareMathOperator{\Drop}{Drop}


%include agda.fmt

\begin{document}

\maketitle

\begin{abstract}

  We present some interesting things in a clear and
  entertaining style.

\end{abstract}

\newcommand{\NN}{\mathbb{N}}
\newcommand{\RR}{\mathbb{R}}
\newcommand{\Rpos}{\mathbb{R}_{\ge 0}}
\newcommand{\PS}{\mathcal{P}}

\section{Introduction}

- Context

- Active learning

- Modeling a problem with functions and types

\section {First-class functions}


\subsection{Sequences}

> f : Nat -> X

\subsection{Series}

\subsection{Power series}

\subsection{Operators and transformations}


\section{Types}

- strange remark on independent variables
- lack of types probably at the origin of |f(x)|
- types for syntax

\section{DSLs}

- helps to distinguish syntax and semantics
- same syntax can be given many interpretations
  + power series: formal, real, complex, intervals
- different syntaxes can have the same  semantics
  + cartesian versus polar
  + matrices versus linear applications
  + holomorphic versus analytic function

  many important theorems are "translations"

\section{Equational proofs}

Consider the following statement of the completeness property for
$\RR$ (Adams and Edwards, page 4):

\begin{quote}
  
    The *completeness* property of the real number system is more
    subtle and difficult to understand. One way to state it is as
    follows: if $A$ is any set of real numbers having at least one
    number in it, and if there exists a real number $y$ with the
    property that $x < y$ for every $x \in A$ (such a number $y$ is
    called an **upper bound** for $A$), then there exists a smallest
    such number, called the **least upper bound** or **supremum** of
    $A$, and denoted $\sup(A)$. Roughly speaking, this says that there
    can be no holes or gaps on the real line-every point corresponds
    to a real number.

\end{quote}

The functional programmer trying to make sense of this "subtle and
difficult to understand" property will start by making explicit the
functions involved:

 > $\sup : \PS \RR -> \RR$

$sup$ is defined only for those subsets of $\RR$ which are bounded;
for these it returns the least upper bound.

Functional programmers are aquainted with a large number of standard
function.  Among these are ```minimum``` and ```maximum```, which
return the smallest and the largest element of a given (non-empty)
list.  It is easy enough to define set versions of these functions,
for example:

 > $\min : \PS X -> X$

 > $\min\ A = x \iff x \in A \ \And\ \forall a \in A\ a \le x$

Exploring the relationship between the "new" function $\sup$ and the
familiar $\min$ and $\max$ can dispell some of the difficulties
involved in the completeness property.  For example, $\sup A$ is 

As another example of work on the text, consider the following
definition (Adams and Edwards, page A-23):


\begin{quote}
  \textbf{Limit of a sequence}

  We say that $\lim a_n = x$ if for every positive number $\epsilon$
  there exists a positive number $N = N (\epsilon)$ such that
  $|a_n - x| < \epsilon$ holds whenever $n \geq N$.
\end{quote}

There are many opportunities for functional programmers to apply their
craft here:

- giving an explicit typing $\lim : (\NN \to X) \to X$ and writing
  $\lim a$ in order to avoid the impression that the result depends on
  some value $a\ n$;
- introducing explicitely the function $N : \Rpos \to \NN$;
- introducing a function $V : X \to \Rpos \to \PS X$ with

 >  $V\ x\ \epsilon = \{x' \mid x' \in X,\ |x' - x| < \epsilon\}$

Until now, we have just changed the notation of the elements already
present in the text (the *neighbourhood* function $V$ is introduced in
Adams, but first on page 567, long after the chapter on sequences and
convergence, page 495).  Many real analysis textbooks adopt, in fact,
the one or the other of these changes.  However, functional
programmers will probably observe that the expression $a_n \ldots$
*whenever* $n \geq N$ refers to the $N$th tail of the sequence, i.e.,
to the elements remaining after the first $N$ elements
have been dropped.  They will introduce a function $Drop$ patterned
after the standard Haskell ```drop```:


 > $Drop : \NN \to (\NN \to X) \to \PS X$
 
 > $Drop\ n\ f = \{ f\ i \mid i \in \NN,\ i \ge n\}$








\end{document}
