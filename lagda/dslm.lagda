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


%include dslmagda.fmt

%include dslm.format

\begin{document}

\maketitle

\begin{abstract}

  We present some interesting things in a clear and
  entertaining style.

\end{abstract}


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

\section{Equational proofs}

Consider the following statement of the completeness property for
|Real| (Adams and Edwards, page 4):

\begin{quote}
  
    The \emph{completeness} property of the real number system is more
    subtle and difficult to understand. One way to state it is as
    follows: if |A| is any set of real numbers having at least one
    number in it, and if there exists a real number |y| with the
    property that |x < y| for every |x elemOf A| (such a number |y| is
    called an \textbf{upper bound} for |A|), then there exists a
    smallest such number, called the \textbf{least upper bound} or
    \textbf{supremum} of |A|, and denoted |sup(A)|. Roughly speaking,
    this says that there can be no holes or gaps on the real
    line-every point corresponds to a real number.

\end{quote}

The functional programmer trying to make sense of this ``subtle and
difficult to understand'' property will start by making explicit the
functions involved:

> sup : PS Real -> Real

|sup| is defined only for those subsets of |Real| which are bounded;
for these it returns the least upper bound.

Functional programmers are acquainted with a large number of standard
function.  Among these are |minimum| and |maximum|, which
return the smallest and the largest element of a given (non-empty)
list.  It is easy enough to define set versions of these functions,
for example:

> min    :  PS X -> X
> min A  =  x ifandonlyif x elemOf A && ((Forall (a elemOf A) (a <= x)))

|min| on sets enjoys similar properties to its list counterpart, and
some are easier to prove in this context, since the structure is
simpler (no duplicates, no sequentialization of elements).  For
example, we have 

\begin{quote}
  If |x elemOf X| and |x < min A|, then |x notElemOf A|.
\end{quote}

Exploring the relationship between the ``new'' function |sup| and the
familiar |min| and |max| can dispel some of the difficulties
involved in the completeness property.  For example, |sup A| is
similar to |max A|: if the latter is defined, then so is the former;
but it also is the smallest element of a set, which suggests a
connection to |min|.  To see this, introduce the function

> ubs    :  PS X -> PS X
> ubs A  =  { x | x elemOf X, x upper bound of A }

which returns the set of upper bounds of |A|.  The completeness axiom
can be stated as

\begin{quote}
  If |ubs A noteq empty| then |min (ubs A)| is defined.
\end{quote}

\noindent
and we have that |sup = min . ubs|.

The explicit introduction of functions such as |ubs| allows us to give
calculational proofs in the style introduced by Wim Feijen and used in
many computer science textbooks, especially in functional programming.
For example, if |s = sup A|:

\def\commentbegin{\quad\{\ }
\def\commentend{\}}





\begin{spec}
   eps > 0

=> {- arithmetic -}

   s - eps < s

=> {- |s = min (ups A)|, property of |min| -}

   s - eps notElemOf ups A

=> {- converse of upper bound definition -}

   (Exists (a elemOf A) (s - eps < a))

=> {- definition of upper bound -}

   (Exists (a elemOf A) (s - eps < a <= s))

=> {- absolute value -}

   (Exists (a elemOf A) ((abs(a - s)) < eps))
\end{spec}

This simple proof shows that we can always find an element of |A| as
near to |sup A| as we want, which explains perhaps the above statement
``Roughly speaking, [the completeness axiom] says that there can be no
holes or gaps on the real line-every point corresponds to a real
number.''  It is also easy to see that, if |min A| is not defined,
then |A| must be infinite.

As another example of work on the text, consider the following
definition (Adams and Edwards, page A-23):

\begin{quote}
  \textbf{Limit of a sequence}

  We say that |lim an = x| if for every positive number |eps|
  there exists a positive number |N = N (eps)| such that
  |(abs(an - x)) < eps| holds whenever |n <= N|.
\end{quote}

There are many opportunities for functional programmers to apply their
craft here, such as

\begin{itemize}
\item giving an explicit typing |lim : (Nat -> X) -> X| and writing
  |lim a| in order to avoid the impression that the result depends on
  some value |a n|;
\item introducing explicitly the function |N : RPos -> Nat|;
\item introducing a function |V : X  -> RPos -> PS X| with
>  V x eps = { x' | x' elemOf X, (abs(x' - x)) < eps }
\end{itemize}


These are all just changes in the notation of elements already present
in the text (the \emph{neighborhood} function |V| is introduced in
Adams, but first on page 567, long after the chapter on sequences and
convergence, page 495).  Many real analysis textbooks adopt, in fact,
the one or the other of these changes.  However, functional
programmers will probably observe that the expression |an...|
\emph{whenever} |n <= N| refers to the |N|th tail of the sequence,
i.e., to the elements remaining after the first |N| elements have been
dropped.  This recalls the familiar Haskell function |drop : Int ->
[a] -> [a]|, which can be recast to suit the new context:

> Drop : Nat -> (Nat -> X) -> PS X
> Drop n a = { a i | i elemOf Nat, i <= n }

The function |Drop| has many properties, for example:

\begin{itemize}
\item anti-monotonous in the first argument 

> m <= n => Drop n a included Drop m a

in particular |Drop n a included Drop 0 a| for
  all |n|;

\item if |a| is increasing, then 

> ubs (Drop m a) = ubs (Drop n a) 

and therefore, if |Drop 0 a| is bounded

> sup (Drop m a) = sup (Drop n a)

\item if |a| is increasing, then

> Drop n a included (Clopen(an, infinity))

\end{itemize}

Using |Drop|, we have that

\begin{spec}
  lim a = x
ifandonlyif
  (Exists (N : RPos -> Nat)  (Forall (eps elemOf RPos) (Drop (N eps) a included V x eps))
\end{spec}

We can show that bounded increasing sequences are convergent.  Let |a|
be a bounded sequence (i.e., |Drop 0 a| is bounded) and let |s = sup
(Drop 0 a)|.  Then, we know from our previous example that |Drop 0 a
intersect V s eps noteq empty| for any |eps|.  Assuming a function
|choice : PS X -> X| which selects an element from every non-empty set
(and is undefined otherwise), we define

> N eps = choice (Drop 0 a intersect V s eps)

If |a| is increasing, we have

\begin{spec}
  Drop (N eps) a
included {- |a| increasing -}
  [a (N eps), sup (Drop (N eps) a)]
= {- |a| increasing |=> Drop n a = Drop 0 a| -}
  [a (N eps), s]
included {- |a (N eps) elemOf V s eps| -}
  V s eps
\end{spec}

As before, the introduction of a new function has helped in relating
familiar elements (the standard Haskell function |drop|) to new ones
(the concept of limit) and to formulate proofs in a calculational
style.

\section{DSLs}

There is no clear-cut dividing line between libraries and DSLs, and
intuitions differ.  For example, in Chapter 8 of \emph{Thinking
  Functionally with Haskell}, Richard Bird presents a language for
pretty-printing documents based on Wadler's TODO, but refers to it as
a library, only mentioning DSLs in the chapter notes.

Both libraries and DSLs are collections of types and functions meant
to represent concepts from a domain at a high-level of abstraction.
What separates a DSL from a library is, in our opinion, the deliberate
separation of syntax from semantics, which is a feature of all
programming languages (and, arguably, of languages in general).

As we have seen above, in mathematics the syntactical elements are
sometimes conflated with the semantical ones (|f(t)| versus |f(s)|,
for example), and disentangling the two aspects can be an important
aid to coming to terms with a mathematical text.  Hence, our emphasis
on DSLs rather than libraries.

The distinction between syntax and semantics is, in fact, quite common
in mathematics, often hiding behind the keyword ``formal''.  For
example, \emph{formal power series} are an attempt to present the
theory of power series restricted to their syntactic aspects,
independent of their semantic interpretations in terms of convergence
(in the various domains of real numbers, complex numbers, intervals of
reals, etc.).  The ``formalist'' texts of Bourbaki present various
domains of mathematics by emphasizing their formal properties
(\emph{axiomatic structure}), then relating those in terms of ``lower
levels'', with the lowest levels in terms of set theory (so, for
example, groups are initially introduced axiomatically, then various
interpretations are discussed, such as ``groups of transformations'',
which in turn are intepreted in terms of endo-functions, which are
ultimately represented as sets of ordered pairs).  Currently, however,
even the most ``formalist'' mathematical texts offer to the computer
scientist many opportunities for active reading.

%% - different syntaxes can have the same  semantics
%%   + Cartesian versus polar
%%   + matrices versus linear applications
%%   + holomorphic versus analytic function

%%   many important theorems are ``translations''

\begin{quote}
  We begin by defining the symbol |i|, called \textbf{the imaginary unit}, to
  have the property

      $i^2 = -1$

  Thus, we could also call |i| the square root of |-1| and denote it
  $\sqrt -1$ . Of course, |i| is not a real number; no real number has
  a negative square.
\end{quote}

> data I = I

\begin{quote}
  A \textbf{complex number} is an expression of the form

  |a + bi| or |a + ib|,

  where |a| and |b| are real numbers, and |i| is the imaginary unit.
\end{quote}

> data ComplexNumber  =  Plus1 Real Real I
>                     |  Plus2 Real I Real

The translation from the abstract syntax to the concrete syntax is
done by the function |show|:

> show (Plus1 x y I) = show x ++ " + " ++ show y ++ "i"
> show (Plus1 x y I) = show x ++ " + " ++ show y ++ "i"

\begin{quote}
  For example, |3 + 2i|, |div 7 2 - (div 2 3)i| , |i(pi) = 0 + i(pi)| , and |-3 =
  -3 + 0i| are all complex numbers.  The last of these examples shows
  that every real number can be regarded as a complex number. 
\end{quote}

> embed : Real -> ComplexNumber
> embed x = Plus1 x 0 I

\begin{quote}
  (We will normally use |a + bi| unless |b| is a complicated
  expression, in which case we will write |a + ib| instead. Either
  form is acceptable.)
\end{quote}

> data ComplexNumber = PlusI Real Real

(a newtype)

\begin{quote}
  It is often convenient to represent a complex number by a single
  letter; |w| and |z| are frequently used for this purpose. If |a|,
  |b|, |x|, and |y| are real numbers, and |w = a + bi| and |z = x +
  yi|, then we can refer to the complex numbers |w| and |z|. Note that
  |w = z| if and only if |a = x| and |b = y|.
\end{quote}

equality is the standard equality on pairs (|deriving Eq|)

The point of the somewhat confusing discussion of using ``letters'' to
stand for complex numbers is to legitimize the use of \emph{pattern
  matching}, as in the following definition:

\begin{quote}
  If |z = x + yi| is a complex number (where |x| and |y| are real), we
  call |x| the real part of |z| and denote it |Re (z)|. We call |y|
  the imaginary part of |z| and denote it |Im (z)|: 

> Re(z) = Re (x+yi) = x, Im(z) = Im (x + yi) = y

\end{quote}

> Re : ComplexNumber -> Real
> Re (PlusI x y)  =  x

> Im : ComplexNumber -> Real
> Im (PlusI x y)  =  y



\end{document}
