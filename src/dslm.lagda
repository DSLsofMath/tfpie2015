\begin{code}
module dslm where
import Data.Nat
open Data.Nat using (zero; suc) renaming (ℕ to Nat; _≤_ to _<=N_; _+_ to _+N_)
open import Data.List hiding (sum; product; _++_; drop) renaming (_∷_ to _::_)
open import Data.Product hiding (map) renaming (∃ to Exists)
open import Relation.Nullary renaming (¬_ to not)
open import Function
open import Data.String using (String; _++_)
open import Relation.Binary.PropositionalEquality

postulate
  Real : Set
  CC   : Set
  PS   : Set -> Set
\end{code}

TODO: Think about the type of |PS|: does it take a type to a type or a
set to a set? Currently it is a "type to type" operation, which means
it cannot really do any work with actual sets of values. We would like
to get help from the type-checker in checking mathematical arguments,
but not at the cost of quite a bit of formal "noise".

\begin{code}
PS+ = PS  -- To avoid too many subset conversions

postulate
  _=S=_    : {A : Set} -> PS A -> PS A -> Set
  _elemOf_ : {A : Set} -> A -> PS A -> Set
  mkSet    :              {A : Set} ->             (A -> Set) -> PS A
  mkSetI   : {I : Set} -> {A : Set} -> (I -> A) -> (I -> Set) -> PS A

RPos : Set  -- defined as a synonym for Real to avoid explicit subtype coercions
RPos = Real

_notElemOf_ : {A : Set} -> A -> PS A -> Set
x notElemOf X = not (x elemOf X)

_&&_ : Set -> Set -> Set
_&&_ = _×_
\end{code}

|X| with a |NumDict X| is a generalization from "Real or Complex".

It is not clear what is the best way of handling "subtyping" between
subsets of Real (or Complex). In many cases a subset of X (like |Real|
numbers between 0 and 1, or |RPos|) is used which is not closed under
almost any of the operations.

\begin{code}
record NumDict (X : Set) : Set1 where
  field
    zer  : X
    one  : X
    _+_  : X -> X -> X
    _-_  : X -> X -> X
    _*_  : X -> X -> X
    _<=_ : X -> X -> Set
    _<_  : X -> X -> Set
    abs  : X -> RPos -- return value is always a non-negative Real

    setX : PS X -- the set of all values of type X
    -- This is included here to handle the difference between the type
    -- |(X : Set)| and (the encoding of) the set |(setX : PS X)|.

    showR : X -> String
    _=R=_ : X -> X -> Set
  -- end of fields, start of derived operations

  sum : List X → X
  sum = foldr _+_ zer

  product : List X → X
  product = foldr _*_ one

  pow : X -> Nat -> X
  pow x zero     = one
  pow x (suc n)  = x * pow x n

  minSpec : X -> PS X -> Set
  minSpec x A = (x elemOf A) && ((forall {a} -> (a elemOf A) -> (x <= a)))
-- end of record NumDict

postulate
  enumFromTo : Nat -> Nat -> List Nat
\end{code}

TODO: fill in more

\begin{code}
module Inner (X : Set) (numDict : NumDict X) where
 open NumDict numDict

 Seq : Set -> Set
 Seq X = Nat -> X

 postulate lim : (Nat -> X) -> X
  -- The paper does not try to _define_ lim, it only provides a type
  -- and some use cases.

 Sigma    :  (Nat -> X) -> X
 Sigma f  =  lim s
   where  s : Nat -> X
          s n = sum (map f (enumFromTo 0 n))

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

 postulate Lap  :  (T -> CC) -> (S -> CC)
 -- Lap  =  {!!}

-- end of module Inner
\end{code}

Now we move on to some examples where |X = Real| (but the choice of
ordering etc. is still somewhat flexible):

\begin{code}
module OnlyWorksWhenXIsReal (numDict : NumDict Real) where
 open NumDict numDict
 X = Real
 postulate min    :  PS X -> X
 -- min A  =  {!!}
 -- min is not always defined either

 postulate minProof : forall {A} -> minSpec (min A) A
 -- minProof = {!!}
\end{code}


If |x elemOf X| and |x < min A|, then |x notElemOf A|.

\begin{code}
 _upperBoundOf_ : X -> PS X -> Set
 x upperBoundOf A = forall {a} -> (a elemOf A) -> (a <= x)

 ubs    :  PS X -> PS X
 ubs A  = mkSet (\ x -> (x elemOf setX) && (x upperBoundOf A))
\end{code}

Note the difference between the type |(X : Set)| and the set |(setX :
PS X)| which can be used as the second argument to |_elemOf_|.

\begin{quote}
  If |u elemOf ubs A| then |min (ubs A)| is defined.
\end{quote}
\noindent
and we have that
\begin{code}
 sup : PS+ X -> X
 -- sup is defined for all non-empty sets bounded from above
 -- TODO: what is a convenient encoding of partial functions in Agda?
 sup = min ∘ ubs
\end{code}

if |s = sup A|:

TODO: check the equality proof

\begin{code}
 _<_<=_ = \x y z -> (x < y) && (y <= z)

 poorMansProof : RPos -> X -> PS X -> List Set
 poorMansProof eps s A =
   (zer < eps)
  :: -- => {- arithmetic -}
   ((s - eps) < s)
  :: -- => {- |s = min (ubs A)|, property of |min| -}
   (s - eps) notElemOf (ubs A)
  :: -- => {- set membership -}
   not (forall {a} -> (a elemOf A) -> (a <= (s - eps)))
  :: -- => {- quantifier negation -}
   Exists (\a -> (a elemOf A) && ((s - eps) < a))
  :: -- => {- definition of upper bound -}
   Exists (\a -> (a elemOf A) && ((s - eps) < a <= s))
  :: -- => {- absolute value -}
   Exists (\a -> (a elemOf A) && ((abs(a - s)) < eps))
  ::
   []
\end{code}

\item introducing explicitly the function |N : RPos -> Nat|;
\item introducing a neighborhood function |V : X  -> RPos -> PS X| with
\begin{code}
 V : X -> RPos -> PS X
 V x eps = mkSet (\x' -> (x' elemOf setX) && ((abs(x' - x)) < eps))
\end{code}

(In the original draft from the Spring of 2014 there was a type
mismatch here: |eps| is an |RPos| (or |Real|) but we had only assumed
numeric operations on |X|. To resolve it we made |X = Real| in this
part of the development.)

\begin{code}
 Drop : Nat -> (Nat -> X) -> PS X
 Drop n f = mkSetI f ( \(i : Nat) ->   n <=N i)
              -- { f i | i elemOf Nat, n <=  i}
\end{code}

\item anti-monotonous in the first argument


\begin{code}
 postulate
   _included_ : PS X -> PS X -> Set  -- TODO move to a record of assumptions (module parameter), or implement in terms of other assumptions
   _intersect_ : PS X -> PS X -> PS X  -- TODO

   antiMonFstDrop : {m n : Nat} -> (f : Nat -> X) ->
           (m <=N n)  ->  (Drop n f) included (Drop m f)

 corollary1 : (n : Nat) -> (f : Nat -> X) ->
              (Drop n f) included (Drop 0 f)
 corollary1 n f = antiMonFstDrop f Data.Nat.z≤n

 increasing : (Nat -> X) -> Set
 increasing f = forall {n : Nat} ->   f n <= f (suc n)

 postulate
   increasingUbsDrop : {f : Nat -> X} -> increasing f -> {m n : Nat} ->
                       ubs (Drop m f) =S= ubs (Drop n f)

--   Clopen : X ->

 bounded : PS X -> Set
 bounded A = Exists (\x -> x upperBoundOf A)

 postulate
   lemma : (f : Nat -> X) -> {m n : Nat} ->
           bounded (Drop 0 f) -> sup (Drop m f) =R= sup (Drop n f)

   lemma2 : {f : Nat -> X} -> increasing f -> {n : Nat} ->
     (Drop n f) included {! (Clopen(f n , infinity)) !}

\end{code}

\begin{code}

 limSpec : (Nat -> X) -> X -> Set
 limSpec f x = Exists \(N : RPos -> Nat) -> (forall {eps : RPos} ->
                 (zer <= eps) -> ((Drop (N eps) f) included (V x eps)))
\end{code}

Note that currently |RPos = Real| so |N| and |V x| have to be defined
also for negative numbers. (They can be defined to be the empty set.)
TODO: check that this works out properly.

\begin{code}
 _Fincluded_ : {A : Set} (f g : A -> PS X) -> Set  -- TODO Perhaps generalise from X to any B?
 f Fincluded g = forall {a} -> (f a  included  g a)

 equalProp : (f : Nat -> X) -> (x : X) ->
   (Exists \(N : RPos -> Nat) -> (forall {eps : RPos} ->
              ((Drop (N eps) f) included (V x eps))))
   ≡
   (Exists \(N : RPos -> Nat) -> ((flip Drop f ∘ N) Fincluded (V x)))
 equalProp f X = refl
\end{code}

We can show that increasing sequences which are bounded from above are
convergent.

N eps = elemIndex (choice ((Drop 0 f) intersect (V s eps))) f

TODO: Update this discussion to match the updated text in the paper.

What we really need is to search through the sequence |f| for an |n|
from which onwards all elements are in |V s eps|. If we have already
converted the sequence into just a set (using |Drop|), this search is
not effectively implementable. We can get around it by postulating
|smallest| which (non-constructively) finds the smallest natural
number satisfying a predicate. But it would probably be better to use
a variant of |Drop| called |drop|:

\begin{code}
 module SymmetricDrop where
  drop : Nat -> (Nat -> X) -> (Nat -> X)
  drop n f = \(i : Nat) ->  f (n +N i)
\end{code}
or equivalently
\begin{code}
  drop' : Nat -> (Nat -> X) -> (Nat -> X)
  drop' n f = f ∘ (_+N_ n)
\end{code}

To connect to the definition of |Drop| we just need the
``sequence-to-set'' conversion |range|:

\begin{code}
  postulate   range : (Nat -> X) -> PS X

  Drop' : Nat -> (Nat -> X) -> PS X
  Drop' n f = range (drop n f)
\end{code}

\begin{code}
 module Convergent (f : Nat -> X) {dummy : Real} (nonEmpty : dummy elemOf (ubs (Drop 0 f))) where
  s : Real
  s = sup (Drop 0 f)

  postulate smallest : (Nat -> Set) -> Nat

  N : RPos -> Nat
  N eps = smallest (\ n -> (Drop n f) included (V s eps))
\end{code}

As soon as |N| is defined, the proof steps below could be used.

TODO: code up at least some of the steps.

\begin{code}
  postulate closedInterval : X -> X -> PS X

  module _ (eps : RPos) where
   step1 = Drop (N eps) f
   -- included {- |f| increasing -}
   step2 = closedInterval (f (N eps)) (sup (Drop (N eps) f))
   -- = {- |f| increasing |=> sup (Drop n f) = sup (Drop 0 f)| -}
   step3 = closedInterval (f (N eps)) s
   -- included {- |f (N eps) elemOf V s eps| -}
   step4 =  V s eps
   prop1 : step1 included step2
   prop1 = {!!}
   prop2 : step2 ≡ step3
   prop2 = {!!}
   prop3 : step3 included step4
   prop3 = {!!}
\end{code}

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
