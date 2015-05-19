\begin{code}
module dslm where
import Data.Nat
open Data.Nat using (zero; suc) renaming (ℕ to Nat; _≤_ to _<=N_)
open import Data.List hiding (sum; product; _++_) renaming (_∷_ to _::_)
open import Data.Product hiding (map) renaming (∃ to Exists)
open import Relation.Nullary renaming (¬_ to not)
open import Function
open import Data.String using (String; _++_)

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
postulate
  _=S=_     : {A : Set} -> PS A -> PS A -> Set
  _elemOf_ : {A : Set} -> A -> PS A -> Set
  mkSet    :              {A : Set} ->             (A -> Set) -> PS A
  mkSetI   : {I : Set} -> {A : Set} -> (I -> A) -> (I -> Set) -> PS A

RPos : Set  -- defined as a synonym for Real to avoid explicit subtype coercions
RPos = Real

_notElemOf_ : {A : Set} -> A -> PS A -> Set
x notElemOf X = not (x elemOf X)

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
    abs  : X -> RPos -- return value is always a non-negative Real

    setX : PS X -- the set of all values of type X
    -- This is included here to handle the difference between the type
    -- |(X : Set)| and (the encoding of) the set |(setX : PS X)|.

    showR : X -> String
    _=R=_ : X -> X -> Set

  -- It is not clear what is the best way of handling "subtyping"
  -- between subsets of Real.  In many cases an X is used which is not
  -- closed under several operations. Then the type signatures are
  -- intended mostly to limit quantifications, not to actually make
  -- _+_, say, partial. One way is to require a superset (Super) into
  -- which all of X can be embedded.

  --    Super : Set
  --    embed : X -> Super

  -- Super should be closed under the operations (and will often be
  -- Real or Complex). In fact, the operations should all be on Super,
  -- not on X. But then the purpose of X is not all that clear. If we
  -- use this whole NumDict just to abstract from the superset (and
  -- all operations are defined on the superset) we can ignore the
  -- earlier meaning of NumDict X and just use it for Real and Complex
  -- (and perhaps some more Ring or Field). But then we will need to
  -- keep track of the "current subset" in some other way.

  sum : List X → X
  sum = foldr _+_ zer

  product : List X → X
  product = foldr _*_ one

  pow : X -> Nat -> X
  pow x zero = one
  pow x (suc n) = x * pow x n

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
 -- lim = {!!}

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

Note the difference between |(X : Set)| and |(setX : PS X)| which can
be used as the second argument to |_elemOf_|.

\begin{quote}
  If |ubs A noteq empty| then |min (ubs A)| is defined.
\end{quote}

\noindent
and we have that

TODO:
\begin{code}
 sup : PS X -> X -- TODO: Real or X?
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

There was a type mismatch here: |eps| is an |RPos| (or |Real|) but we
had only assumed numeric operations on |X|. To resolve it we made |X =
Real| in this part of the development.

\begin{code}
 Drop : Nat -> (Nat -> X) -> PS X
 Drop n a = mkSetI a ( \(i : Nat) ->   n <=N i)
              -- { a i | i elemOf Nat, n <=  i}
\end{code}

\item anti-monotonous in the first argument


\begin{code}
 postulate
   _included_ : PS X -> PS X -> Set  -- TODO move to a record of assumptions (module parameter), or implement in terms of other assumptions

   antiMonFstDrop : {m n : Nat} -> (a : Nat -> X) ->
           (m <=N n)  ->  (Drop n a) included (Drop m a)

 corollary1 : (n : Nat) -> (a : Nat -> X) ->
              (Drop n a) included (Drop 0 a)
 corollary1 n a = antiMonFstDrop a Data.Nat.z≤n

 increasing : (Nat -> X) -> Set
 increasing a = forall {n : Nat} ->   a n <= a (suc n)

 postulate
   increasingUbsDrop : {a : Nat -> X} -> increasing a -> {m n : Nat} ->
                       ubs (Drop m a) =S= ubs (Drop n a)

--   Clopen : X ->

 bounded : PS X -> Set
 bounded A = Exists (\x -> x upperBoundOf A)

 postulate
   lemma : (a : Nat -> X) -> {m n : Nat} ->
           bounded (Drop 0 a) -> sup (Drop m a) =R= sup (Drop n a)

   lemma2 : {a : Nat -> X} -> increasing a -> {n : Nat} ->
     (Drop n a) included {! (Clopen(a n , infinity)) !}

\end{code}

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
