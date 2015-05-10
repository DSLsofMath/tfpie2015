\begin{code}
module dslm where
import Data.Nat
open Data.Nat using (zero; suc) renaming (ℕ to Nat; _≤_ to _<=N_)
open import Data.List hiding (sum; product; _++_) renaming (_∷_ to _::_)
open import Data.Product hiding (map)
open import Function
open import Data.String using (String; _++_)

postulate
  Real : Set
  CC   : Set
  PS   : Set -> Set
  _elemOf_ : {A : Set} -> A -> PS A -> Set
  mkSet  :              {A : Set} ->             (A -> Set) -> PS A
  mkSetI : {I : Set} -> {A : Set} -> (I -> A) -> (I -> Set) -> PS A

RPos : Set  -- defined as a synonym for Real to avoid explicit subtype coercions
RPos = Real

_&&_ : Set -> Set -> Set
_&&_ = _×_

record NumDict (X : Set) : Set1 where
  field
    zer  : X
    one  : X
    _+_  : X -> X -> X
    _-_  : X -> X -> X
    _*_  : X -> X -> X
    _<=_ : X -> X -> Set
    _<_  : X -> X -> Set
    abs  : X -> X

  -- It is not clear what is the best way of handling "subtyping" between subsets of Real.

    showR : X -> String

  sum : List X → X
  sum = foldr _+_ zer

  product : List X → X
  product = foldr _*_ one

  pow : X -> Nat -> X
  pow x zero = one
  pow x (suc n) = x * pow x n

  minSpec : X -> PS X -> Set
  minSpec x A = (x elemOf A) && ((forall {a} -> (a elemOf A) -> (x <= a)))
postulate
  enumFromTo : Nat -> Nat -> List Nat
\end{code}

TODO: fill in more

\begin{code}
module Inner (X : Set) (numDict : NumDict X) where
 open NumDict numDict

 Seq : Set -> Set
 Seq X = Nat -> X

 lim : (Nat -> X) -> X
 lim = {!!}

 Sigma    :  (Nat -> X) -> X
 Sigma a  =  lim s
   where  s : Nat -> X
          s n = sum (map a (enumFromTo 0 n))

 Powers      :  (Nat -> X) -> X -> X
 Powers a x  =  Sigma f
   where  f : Nat -> X
          f n = (a n) * (pow x n)
\end{code}

\begin{quote}
  The differentiation operator |D| can be viewed as a transformation
  which, when applied to the function |f(t)|, yields the new function
  |D{f(t)} = f'(t)|. The Laplace transformation |Lap| involves the
  operation of integration and yields the new function |Lap{f(t)} =
  F(s)| of a new independent variable |s|.
\end{quote}

\begin{code}
 data T : Set where mkT : Real  -> T
 data S : Set where mkS : CC    -> S

 Lap  :  (T -> CC) -> (S -> CC)
 Lap  =  {!!}

 -- sup : PS X -> X -- TODO: Real or X?
 -- sup is defined for all non-empty sets bounded from above

 min    :  PS X -> X
 min A  =  {!!}
 -- min is not always defined either

 minProof : forall {A} -> minSpec (min A) A
 minProof = {!!}
\end{code}

TODO:

If |x elemOf X| and |x < min A|, then |x notElemOf A|.

\begin{code}
 ubs    :  PS X -> PS X
 ubs A  = mkSet (λ x → {!x elemOf X!} && {!x upper bound of A!})
 --       = { x | x elemOf X, (Forall (a elemOf A) (a <= x)) }
 -- type error in (x elemOf X): mismatch between (X : Set) and _elemOf_ expecting something of type (PS X)
\end{code}

\begin{quote}
  If |ubs A noteq empty| then |min (ubs A)| is defined.
\end{quote}

\noindent
and we have that

TODO:
-- \begin{code}
 sup = min ∘ ubs
-- \end{code}

if |s = sup A|:

TODO: check the equality proof

\begin{code}
 poorMansProof : X -> X -> List Set
 poorMansProof eps s =
   (zer < eps)
  :: -- => {- arithmetic -}
   ((s - eps) < s)
--  , -- => {- |s = min (ubs A)|, property of |min| -}
  ::
   []
\end{code}

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
\begin{code}
 V : X -> RPos -> PS X
 V x eps = mkSet (\x' -> {!x' elemOf X!} && ((abs(x' - x)) < {!eps!}))
  -- TODO: mkSet (\x' -> (x' elemOf X) && ((abs(x' - x)) < eps) )
  -- There is a type mismatch here: eps is an RPos (or Real) but we have only assumed numeric operations on the set X.


 Drop : Nat -> (Nat -> X) -> PS X
 Drop n a = mkSetI a ( \(i : Nat)   -> n <=N i)
              -- { a i | i elemOf Nat, n <= i }
\end{code}

\item anti-monotonous in the first argument

\begin{code}

  -- m <= n => Drop n a included Drop m a
\end{code}

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
\begin{code}
module ComplexNumbers (Real : Set) (numDict : NumDict Real) where
 open NumDict numDict

 data I : Set where i : I

 data Complex1 : Set where
   Plus1 : Real -> Real -> I -> Complex1
   Plus2 : Real -> I -> Real -> Complex1

 show                :  Complex1 -> String
 show (Plus1 x y i)  = showR x ++ " + " ++ showR y ++ "i"
 show (Plus2 x i y)  = showR x ++ " + " ++ "i" ++ showR y

 toComplex : Real -> Complex1
 toComplex x = Plus1 x zer i

 data Complex2 : Set where Plus : Real -> Real -> I -> Complex2

 data Complex3 : Set where PlusI : Real -> Real -> Complex3

 data Complex : Set where C : (Real × Real) -> Complex

 Re : Complex -> Real
 Re (C (x , y))  =  x

 Im : Complex -> Real
 Im (C (x , y))  =  y

 _+C_  :  Complex -> Complex -> Complex
 (C (a , b)) +C (C (x , y))  =  C ((a + x) , (b + y))

data ComplexSyntax : Set where
  C     : (Real × Real) -> ComplexSyntax
  Plus  : ComplexSyntax -> ComplexSyntax -> ComplexSyntax
  Times : ComplexSyntax -> ComplexSyntax -> ComplexSyntax
  -- ...
\end{code}

TODO

data Complex' : Set where
  C' : (RPosz, (Opclosed(-(pi), pi))) -> Complex'
