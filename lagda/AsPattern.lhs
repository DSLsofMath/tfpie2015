> module AsPattern where
> import Prelude hiding (Real)
> type Real = Double
>
> newtype Complex = C (Real, Real)
> re :: Complex -> Real
> re z @ (C (x, y))  =  x

> im :: Complex -> Real
> im z @ (C (x, y))  =  y
