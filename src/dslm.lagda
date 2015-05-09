> module dslm where

> record NumDict (X : Set) where
>   field
>     _+_ : X -> X -> X

TODO: fill in more

> module Inner (X : Set) (numDict : NumDict X) where

>  Seq X = Nat -> X

>  lim : (Nat -> X) -> X
>  lim = ?

>  Sigma    :  (Nat -> X) -> X
>  Sigma a  =  lim s where s n = sum (map a [0 .. n])

>  Powers      :  (Nat -> X) -> X -> X
>  Powers a x  =  Sigma f where f n = (a n) * (pow x n)

\begin{quote}
  The differentiation operator |D| can be viewed as a transformation
  which, when applied to the function |f(t)|, yields the new function
  |D{f(t)} = f'(t)|. The Laplace transformation |Lap| involves the
  operation of integration and yields the new function |Lap{f(t)} =
  F(s)| of a new independent variable |s|.
\end{quote}

>  T : Set
>  T  =  T Real
>  S : Set
>  S  =  S CC
>  Lap  :  (T -> CC) -> (S -> CC)

>  sup : PS Real -> Real

>  minSpec x A = x elemOf A && ((forall {a} -> (a elemOf A) -> (x <= a)))

>  min    :  PS X -> X
>  min A  =  ?

>  minProof : forall {A} -> minSpec (min A) A
>  minProof = ?

TODO:

If |x elemOf X| and |x < min A|, then |x notElemOf A|.

>  ubs    :  PS X -> PS X
>  ubs A  = ? -- { x | x elemOf X, x upper bound of A }

>  --       = { x | x elemOf X, (Forall (a elemOf A) (a <= x)) }

\begin{quote}
  If |ubs A noteq empty| then |min (ubs A)| is defined.
\end{quote}

\noindent
and we have that

>  sup = min . ubs

if |s = sup A|:

TODO: check the equality proof

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


\item introducing explicitly the function |N : RPos -> Nat|;
\item introducing a neighborhood function |V : X  -> RPos -> PS X| with
>  V x eps = { x' | x' elemOf X, (abs(x' - x)) < eps }

>  Drop : Nat -> (Nat -> X) -> PS X
>  Drop n a = ? -- { a i | i elemOf Nat, n <= i }

\item anti-monotonous in the first argument

>  -- m <= n => Drop n a included Drop m a

in particular |Drop n a included Drop 0 a| for
  all |n|;

\item if |a| is increasing, then, for any |m| and |n|

>  -- ubs (Drop m a) = ubs (Drop n a)

and therefore, if |Drop 0 a| is bounded

>  -- sup (Drop m a) = sup (Drop n a)

\item if |a| is increasing, then

>  -- Drop n a included (Clopen(a n, infinity))

TODO

  lim a = x
ifandonlyif
  (Exists (N : RPos -> Nat)  (Forall (eps elemOf RPos) (Drop (N eps) a included V x eps)))


TODO

|f, g : A -> PS B| define

> f included g    ifandonlyif  (Forall (a elemOf A)  (f a  included  g a))

and we could eliminate the quantification of |eps| above:

\begin{spec}
    (Exists (N : RPos -> Nat)  (Forall (eps elemOf RPos) (Drop (N eps) a included V x eps)))
ifandonlyif
    (Exists (N : RPos -> Nat)  ((flip Drop a . N) included V x))
\end{spec}


TODO

We can show that increasing sequences which are bounded from above are
convergent.  Let |a| be a sequence bounded from above (i.e., |ubs
(Drop 0 a) noteq empty|) and let |s = sup (Drop 0 a)|.  Then, we know
from our previous example that |Drop 0 a intersect V s eps noteq
empty| for any |eps|.  Assuming a function |choice : PS X -> X| which
selects an element from every non-empty set (and is undefined for the
empty set), we define

>  -- N eps = choice (Drop 0 a intersect V s eps)

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

%%%%%%
\subsection{A case study: complex numbers}
> module ComplexNumbers where

>  data I where i : I

>  data Complex1 where
>    Plus1 : Real -> Real -> I -> Complex1
>    Plus2 : Real -> I -> Real -> Complex1

>  show                :  Complex1 -> String
>  show (Plus1 x y i)  =  show x ++ " + " ++ show y ++ "i"
>  show (Plus2 x i y)  =  show x ++ " + " ++ "i" ++ show y

>  toComplex : Real -> Complex1
>  toComplex x = Plus1 x 0 i

>  data Complex2 where Plus : Real -> Real -> I -> Complex2

>  data Complex3 where PlusI : Real -> Real -> Complex3

>  data Complex where C : (Real × Real) -> Complex

>  Re : Complex -> Real
>  Re (C (x, y))  =  x

>  Im : Complex -> Real
>  Im (C (x, y))  =  y

>  _+_  :  Complex -> Complex -> Complex
>  (C (a, b)) + (C (x, y))  =  C ((a + x) , (b + y))

> data ComplexSyntax : Set where
>   C     : (Real × Real) -> ComplexSyntax
>   Plus  : ComplexSyntax -> ComplexSyntax -> ComplexSyntax
>   Times : ComplexSyntax -> ComplexSyntax -> ComplexSyntax
>   -- ...

TODO

> {-
> newtype Complex' = C' (RPosz, (Opclosed(-(pi), pi)))

|C'| constructs a ``geometric'' complex number from a non-negative
modulus and a principal argument; the (non-implementable) constraints
on the types ensure uniqueness of representation.

The importance of this alternative representation is that the
operations on its elements have a different natural interpretation,
namely as geometrical operations.  For example, multiplication with
|C' (m, Theta)| represents a re-scaling of the Euclidean plane with a
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
in Matlab and that of linear transformations.  At the undergraduate
level, the most striking example is perhaps that of the identity of
holomorphic functions (the language of complex derivatives) and (regular)
analytic functions (the language of complex power series).

\section{Conclusions and future work}

We have presented the basic ingredients of an approach that uses
functional programming as a way of helping students deal with
classical mathematics and its applications:

\begin{itemize}
\item make functions and the types explicit

\item use types as carriers of semantic information, not variable
  names

\item introduce functions and types for implicit operations such as
  the power series interpretation of a sequence

\item use a calculational style for proofs

\item organize the types and functions in DSLs
\end{itemize}

The lessons in this course will be organized around the active reading
of mathematical texts (suitably prepared in advance).  In the opening
lessons, we will deal with domains of mathematics which are relatively
close to functional programming, such as elementary category theory,
in order to have the chance to introduce newcomers to functional
programming, and the students in general to our approach.

After that, the selection of the subjects will mostly be dictated by
the requirements of the third-year courses in signals and systems, and
control engineering.  They will contain:

\begin{itemize}
\item basic properties of complex numbers

\item the exponential function

\item elementary functions

\item holomorphic functions

\item the Laplace transform

\end{itemize}

One of the important course elements we have left out of this paper is
that of using the modeling effort performed in the course for the
production of actual mathematical software.  One of the reasons for
this omission is that we wanted to concentrate on the more conceptual
part that corresponds to the specification of that software, and as
such is a prerequisite for it.  The development of implementations on
the basis of these specifications will be the topic of most of the
exercises sessions we will organize.  That the computational
representation of mathematical concepts can greatly help with their
understanding was conclusively shown by Sussman and Wisdom in their
recent book on differential geometry \cite{sussman2013functional}.

We believe that this approach can offer an introduction to computer
science for the mathematics students.  We plan to actively involve the
mathematics faculty at Chalmers, via guest lectures and regular
meetings, in order to find the suitable middle ground we alluded to in
the introduction: between a presentation that is too explicit, turning
the student into a spectator of endless details, and one that is too
implicit and leaves so much for the students to do that they are
overwhelmed.  Ideally, some of the features of our approach would be
worked into the earlier mathematical courses.

The computer science perspective has been quite successful in
influencing the presentation of discrete mathematics.  For example,
the classical textbook of Gries and Schneider, \emph{A Logical
  Approach to Discrete Math} \cite{gries1993logical}, has been
well-received by both computer scientists and mathematicians.  When it
comes to continuous mathematics, however, there is no such influence
to be felt.  The work presented here represents the starting point of
an attempt to change this state of affairs.

\bibliographystyle{../eptcsstyle/eptcs}
\bibliography{dslm}

\end{document}


In part, we feel that this is because the logic-based
approach that works in discrete mathematics is too low-level for the
kind of abstractions needed in real and complex analysis.  In
particular, the treatment of functions and datatypes is somewhat
shallow: there are no higher-order functions, recursion is only
treated in the context of recurrence relations for sequences, there is
no discussion of fixed points, and no inductive (let alone
co-inductive) datatypes.

> -}
