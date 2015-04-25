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

In an article published in 2000 (\cite{demoor2000pointwise}), de Moor
and Gibbons start by presenting an exam question for a first-year
course on algorithm design.  The question was not easy, but it also
did not seem particularly difficult.  Still:

\begin{quote}
  In the exam itself, however, no one got the answer right, so
  apparently this kind of question is too hard. That is discouraging,
  especially in view of the highly sophisticated problems that the
  same students can solve in mathematics exams.  Why is programming so
  much harder?
\end{quote}

Fifteen year later, we are confronted at Chalmers with the opposite
problem: many third-year students are having unusual difficulties in
courses involving classical mathematics (especially analysis, real and
complex) and its applications, while they seem quite capable of
dealing with ``highly sophisticated problems'' in computer science and
software engineering.

Why is mathematics so much harder?

One of the reasons for that is, we suspect, that by the third year
these students have grown very familiar to what could be called ``the
computer science perspective''.  For example, computer science places
strong emphasis on syntax, and introduces conceptual tools for
describing it and resolving potential ambiguities.  In contrast to
this, mathematical notation is often ambiguous and context-dependent,
and there is no attempt to even make this ambiguity explicit (Sussman
and Wisdom talk about ``variables whose meaning depends upon and
changes with context, as well as the sort of impressionistic
mathematics that goes along with the use of such variables'', see
\cite{sussman2002role}).

Further, proofs in computer science tend to be more formal, often
using an equational logic format with explicit mention of the rules
that justify a given step, whereas mathematical proofs are presented
in natural language, with many steps being justified by an appeal to
intuition and to the semantical content, leaving a more precise
justification to the reader.  Unfortunately, the task of providing
such a justification requires a certain amount of expertise, and can
be discouraging to the beginner.

Mathematics requires (and rewards) active study.  Halmos, in a book
that cannot be strongly enough recommended (\cite{halmos1985want}),
phrases it as follows (page 69):

\begin{quote}
  It's been said before and often, but it cannot be overemphasized:
  study actively. Don't just read it; fight it!  
\end{quote}

\noindent
but, as in the case of proofs, following this advice requires some
expertise, otherwise it risks being taken in too physical a sense.

In this paper, we present a course on \emph{Domain-Specific Languages
  of Mathematics} (\cite{dslmcourseplan}) being developed at Chalmers
to alleviate these problems.  The main idea is to show the students
that they are, in fact, well-equipped to take an active approach to
mathematics: they need only apply the software engineering and
computer science tools they have aquired in the rest of their studies.
The students should approach a mathematical domain in the same way
they would any other domain they are supposed to model as a software
system.

In particular, we are referring to the approach that a functional
programmer would take.  Functional programming deals with modeling in
terms of types and pure functions, and this seems to be ideal for a
domain where functions are natural objects of study, and which is
possibly the only one where we can be certain that data is immutable.
Explicitely introducing functions and their types, often left explicit
in mathematical texts, is an easy way to begin an active approach to
study.  Moreover, it serves as a way of relating new concepts to
familiar ones: even in continuous mathematics, many functions turn out
to be variants of the standard Haskell ones (not surprising,
considering that the former were often the inspiration for the
latter).  Finally, the explicit elements we introduce can be reasoned
about, and lead to proofs in a more calculational style.  In the next
three sections (TODO: check) we present these aspects in detail; in
particular, the third section contains two simple examples combining
all these features.

At a higher-level, when it comes to the organization of our types and
functions, we emphasize \emph{domain-specific languages} (DSLs).  As
we explain in Section \ref{sec:dsls}, this is a good fit for the
mathematical domain, which can itself be seen as a collection
specialized languages.  Here, we would like to single out a different
aspect: namely that building DSLs is increasingly becoming a standard
industry practice.  Empirical studies show that DSLs can lead to
fundamental increases in productivity, above alternative modelling
approaches such as UML \cite{tolvanen2011industrial}.  The course we
are developing will exercise and develop new skills in designing and
implementing DSLs.  The students will not simply use previously
aquired software engineering expertise, but also extend it, which can
be an important motivating aspect.

We have been referring to the computer science students at Chalmers,
who are our main target audience, but we hope we can also attract some
of the mathematics students.  Indeed, for the latter the course can
serve as an introduction to functional programming and to DSLs by
means of examples with which they are familiar.  Thus, ideally, the
course would improve the mathematical education of computer scientists
and the computer science education of mathematicians.

A word of warning.  We assume familiarity with Haskell (though not
with calculus), and we will take certain notational and semantic
liberties with it.  For example, we will use |:| for the typing
relation, instead of |::|, and we will assume the existence of the
set-theoretical datatypes and operations used in classical analysis,
even though they are not implementable.  For example, we assume we
have at our disposal a powerset operation |PS|, real numbers |Real|,
choice operations, and so on.  

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
|Real| (\cite{adams2010calculus}, page 4):

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
familiar |min| and |max| can dispel some of the difficulties involved
in the completeness property.  For example, |sup A| is similar to |max
A|: if the latter is defined, then so is the former, and they are
equal.  But |sup A| is also the smallest element of a set, which
suggests a connection to |min|.  To see this, introduce the function

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
definition (\cite{adams2010calculus}, page A-23):

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

We can show that increasing sequences which are bounded from above are
convergent.  Let |a| be a sequence bounded from above (i.e., |ubs
(Drop 0 a) noteq empty|) and let |s = sup (Drop 0 a)|.  Then, we know
from our previous example that |Drop 0 a intersect V s eps noteq
empty| for any |eps|.  Assuming a function |choice : PS X -> X| which
selects an element from every non-empty set (and is undefined for the
empty set), we define

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
\label{sec:dsls}

There is no clear-cut line between libraries and DSLs, and intuitions
differ.  For example, in Chapter 8 of \emph{Thinking Functionally with
  Haskell}, Richard Bird presents a language for pretty-printing
documents based on Wadler's TODO, but refers to it as a library, only
mentioning DSLs in the chapter notes.

Both libraries and DSLs are collections of types and functions meant
to represent concepts from a domain at a high level of abstraction.
What separates a DSL from a library is, in our opinion, the deliberate
separation of syntax from semantics, which is a feature of all
programming languages (and, arguably, of languages in general).

As we have seen above, in mathematics the syntactical elements are
sometimes conflated with the semantical ones ($f(t)$ versus $f(s)$,
for example), and disentangling the two aspects can be an important
aid in coming to terms with a mathematical text.  Hence, our emphasis
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
which in turn are interpreted in terms of endo-functions, which are
ultimately represented as sets of ordered pairs).  Currently, however,
even the most ``formalist'' mathematical texts offer to the computer
scientist many opportunities for active reading.

\subsection{A case study: complex numbers}

To illustrate the above, we present an analytic reading of the
introduction of complex numbers in \cite{adams2010calculus}.  This is
not meant to be a realistic case study; the attention paid to the
letter of the text is exaggerated when dealing with such a familiar
domain.  It is a sketch, even a caricature of our approach: we hope
that, like any good caricature, it preserves the spirit of the
enterprise at the expense of (almost) all details.

Adams and Essex introduce complex numbers in Appendix 1.  The
section \emph{Definition of Complex Numbers} begins with:

\begin{quote}
  We begin by defining the symbol |i|, called \textbf{the imaginary unit}, to
  have the property

      $i^2 = -1$

  Thus, we could also call |i| the square root of |-1| and denote it
  $\sqrt -1$ . Of course, |i| is not a real number; no real number has
  a negative square.
\end{quote}

At this stage, it is not clear what the type of |i| is meant to be, we
only know that it is not a real number.  Moreover, we do not know what
operations are possible on |i|, only that $i^2$ is another name for
$-1$ (but it is not obvious that, say $i \times i$ is related in any
way with $i^2$, since the operations of multiplication and squaring
have only been introduced so far for numerical types such as |Nat| or
|Real|, and not for symbols).

For the moment, we introduce a type for the value |i|, and, since we
know nothing about other values, we make |i| the only member of this
type:

> data I = i

(We have taken the liberty of introducing a lowercase constructor,
which would cause a syntax error in Haskell.)

Next, we have the following definition:

\begin{quote}
  \textbf{Definition:} A \textbf{complex number} is an expression of
  the form

  |a + bi| or |a + ib|,

  where |a| and |b| are real numbers, and |i| is the imaginary unit.
\end{quote}

This definition clearly points to the introduction of a syntax (notice
the keyword ``form'').   This is underlined by the presentation of
\emph{two} forms, which can suggest that the operation of
juxtaposing |i| (multiplication?) is not commutative.

A profitable way of dealing with such concrete syntax in functional
programming is to introduce an abstract representation of it in the
form of a datatype:

> data Complex  =  Plus1 Real Real I
>               |  Plus2 Real I Real

We can give the translation from the abstract syntax to the concrete
syntax as a function |show|:

> show (Plus1 x y I) = show x ++ " + " ++ show y ++ "i"
> show (Plus2 x y I) = show x ++ " + " ++ "i" ++ show y

The text continues with examples:

\begin{quote}
  For example, |3 + 2i|, |div 7 2 - (div 2 3)i| , |i(pi) = 0 + i(pi)| , and |-3 =
  -3 + 0i| are all complex numbers.  The last of these examples shows
  that every real number can be regarded as a complex number. 
\end{quote}

The second example is somewhat problematic: it does not seem to be of
the form |a + bi|.  Given that the rest of the examples seem to
introduce shorthand for various complex numbers, let us assume that
this one does as well, and that |a - bi| can be understood as an
abbreviation of |a + (-b)i|.

With this provision, in our notation the examples are written as
|Plus1 3 2 i|, |Plus1 (div 7 2) (-(div 2 3))|, |Plus2 0 pi|, |Plus1
(-3) 0|.  We interpret the sentence ``The last of these examples
\ldots'' to mean that there is an embedding of the real numbers in
|Complex|, which we introduce explicitly:

> toComplex : Real -> Complex
> toComplex x = Plus1 x 0 i

Again, at this stage there are many open questions.  For example, we
can assume  that |i1| stands for the complex number |Plus2 0 i 1|, but
what about |i|?  If juxtaposition is meant to denote some sort of
multiplication, then perhaps |1| can be considered as a unit, in which
case we would have that |i| abbreviates |i1| and therefore |Plus2 0 i
1|.  But what about, say, |2i|?  Abbreviations with |i| have only been
introduced for the |ib| form, and not for the |bi| one!

The text then continues with a parenthetical remark which helps us
dispel these doubts:

\begin{quote}
  (We will normally use |a + bi| unless |b| is a complicated
  expression, in which case we will write |a + ib| instead. Either
  form is acceptable.)
\end{quote}

This remark suggest strongly that the two syntactic forms are meant to
denote the same elements, since otherwise it would be strange to say
``either form is acceptable''.  After all, they are acceptable by
definition.

Given that |a + ib| is only ``syntactic sugar'' for |a + bi|, we can
simplify our representation for the abstract syntax, eliminating one
of the constructors:

> data Complex = Plus Real Real I

In fact, since it doesn't look as though the type |I| will receive
more elements, we can dispense with it altogether:

> data Complex = PlusI Real Real

\noindent
(The renaming of the constructor from |Plus| to |PlusI| serves as a
guard against the case we have suppressed potentially semantically
relevant syntax.)

We read further:

\begin{quote}
  It is often convenient to represent a complex number by a single
  letter; |w| and |z| are frequently used for this purpose. If |a|,
  |b|, |x|, and |y| are real numbers, and |w = a + bi| and |z = x +
  yi|, then we can refer to the complex numbers |w| and |z|. Note that
  |w = z| if and only if |a = x| and |b = y|.
\end{quote}

First, let us notice that we are given an important semantic
information: |PlusI| is not just syntactically injective (as all
constructors are), but also semantically.  The equality on complex
numbers is what we would obtain in Haskell by using |deriving Eq|.

This shows that complex numbers are, in fact, isomorphic with pairs of
real numbers, a point which we can make explicit by re-formulating the
definition in terms of a type synonym:

> newtype Complex = C (Real, Real)

The point of the somewhat confusing discussion of using ``letters'' to
stand for complex numbers is to introduce a substitute for \emph{pattern
  matching}, as in the following definition:

\begin{quote}
  \textbf{Definition:} If |z = x + yi| is a complex number (where |x|
  and |y| are real), we call |x| the \textbf{real part} of |z| and denote it
  |Re (z)|. We call |y| the \textbf{imaginary part} of |z| and denote it |Im
  (z)|:

> Re(z) = Re (x+yi) = x, Im(z) = Im (x + yi) = y

\end{quote}

This is rather similar to Haskell's \emph{as-patterns}:

> Re : Complex -> Real
> Re (z@C (x, y))  =  x

> Im : Complex -> Real
> Im (z@C (x, y))  =  y

\noindent
the problem being that the symbol introduced by the as-pattern is not
actually used on the right-hand side of the equations.

The use of as-patterns such ``|z = x + yi|'' is repeated throughout
the text, for example in the definition of the algebraic operations
on complex numbers:

\begin{quote}
  \textbf{The sum and difference of complex numbers}

  If |w = a + bi| and |z = x + yi|, where |a|, |b|, |x|, and |y| are real numbers,
  then

> w  +  z  =  (a + x)  +  (b + y)i
>
> w  -  z  =  (a - x)  +  (b - y)i
\end{quote}

With the introduction of algebraic operations, the language of complex
numbers becomes much richer.  We can describe these operations in a
``shallow embedding'' in terms of the concrete datatype |Complex|, for
example:

> (+)  :  Complex -> Complex -> Complex
> (C (a, b)) + (C (x, y))  =  C ((a + x), (b + y))

\noindent
or we can extend the datatype of Complex numbers with additional
constructors associated to the algebraic operations:

> data Complex  =  C (Real, Real)
>               |  Plus Complex Complex
>               |  Times Complex Complex
>               |  ...

The type |Complex| can then be turned into an abstract datatype, by
hiding the representation and providing corresponding operations.
This ``deep embedding'' approach offers a cleaner separation between
syntax and semantics, making it possible to compare and factor out the
common parts of various languages.  For the computer science students,
this is a way of approaching structural algebra; for the mathematics
students, this is a way to learn the ideas of abstract datatypes, type
classes, folds, by relating them to the familiar notions of
mathematical structures and homomorphisms.

Adams and Essex then proceed to introduce the geometric
interpretation of complex numbers, i.e., the isomorphism between
complex numbers and points in the Euclidian plane as pairs of
coordinates.  The isomorphism is not given a name, but we can use the
constructor |C| defined above.  They then define the polar
representation of complex numbers, in terms of modulus and argument:

\begin{quote}
  The distance from the origin to the point |(a, b)| corresponding to
  the complex number |w = a + bi| is called the \textbf{modulus} of |w| and is
  denoted by |abs w| or |abs (a + bi)|: 

> abs w = (abs (a + bi)) = (modulus a b)

  If the line from the origin to |(a, b)| makes angle |Theta| with the
  positive direction of the real axis (with positive angles measured
  counterclockwise), then we call |Theta| an \textbf{argument} of the
  complex number |w = a + bi| and denote it by |arg (w)| or |arg (a +
  bi)|.

\end{quote}

Here, the constant repetitions of ``|w = a + bi|'' and ``|f(w)| or |f
(a + bi)|'' are caused not just by the unavailability of
pattern-matching, but also by the absence of the explicit isomorphism
|C|.  We need only use |C (a, b)|, making clear that the modulus and
arguments are actually defined by pattern matching.

Once the principal argument has been defined as the unique argument in
the interval |Opclosed(-(pi), pi)|, the way is opened to a different
interpretation of complex numbers (usually called the \emph{polar
  representation} of complex numbers):

> newtype Complex' = C' (RPosz, (Opclosed(-(pi), pi)))

|C'| constructs a ``geometric'' complex number from a non-negative
modulus and a principal argument; the (non-implementable) constraints
on the types ensure uniqueness of representation.

The importance of this alternative representation is that the
operations on its elements have a different natural interpretation,
namely as geometrical operations.  For example, multiplication with
|C' (m, Theta)| represents a re-scaling of the Euclidian plane with a
factor |m|, coupled with a rotation with angle |Theta|.  Thus,
multiplication with |i| (which is |C' (1, div pi 2)| in polar
representation) results in a counterclockwise rotation of the plane by
90°.  This interpretation of |i| seems independent of the originally
proposed arithmetical one (``the square root of -1''), and the polar
representation of complex numbers leads to a different, geometrical
language.  

It can be an interesting exercise to develop this language (of
scalings, rotations, etc.) ``from scratch'', without reference to
complex numbers.  In a deep embedding, the result is a datatype
representing a syntax that is quite different from the one suggested
by the algebraic operations.  The fact that this language can also be
given semantics in terms of complex numbers could then be seen as
somewhat surprising, and certainly in need of proof.  This would
introduce in a simple setting the fact that many fundamental theorems
in mathematics establish that two languages with different syntaxes
have, in fact, the same semantics.  A more elaborate example is that
of the identity of the language of matrix manipulations as implemented
in Matlab and that of linear applications.  At the undergraduate
level, the most striking example is perhaps that of the identity of
holomorphic (the language of complex derivatives) and (regular)
analytic functions (the language of complex power series).

\bibliographystyle{../eptcsstyle/eptcs}
\bibliography{dslm}

\end{document}
