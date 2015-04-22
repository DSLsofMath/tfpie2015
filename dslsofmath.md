---
title: 'Domain-Specific Languages of Mathematics'
documentclass: eptcsstyle/eptcs
classoption: adraft
---

\begin{abstract}

  We present some interesting things in a clear and
  entertaining style.

\end{abstract}

Introduction
============

- Context

- Active learning

- Modeling a problem with functions and types

First-class functions
=====================

Sequences
---------

> f : Nat -> X

Series
------

Power series
------------

Operators and transformations
-----------------------------

Types
=====

- strange remark on independent variables
- lack of types probably at the origin of ```f(x)```
- types for syntax

DSLs
====

- helps to distinguish syntax and semantics
- same syntax can be given many interpretations
  + power series: formal, real, complex, intervals
- different syntaxes can have the same  semantics
  + cartesian versus polar
  + matrices versus linear applications
  + holomorphic versus analytic function

  many important theorems are "translations"

Equational proofs
=================

Definition (Adams and Edwards, page A-23):

  > **Limit of a sequence**

  > We say that $\lim x_n = L$ if for every positive number $\epsilon$
  > there exists a positive number $N = N (\epsilon)$ such that
  > $|x_n - L| < \epsilon$ holds whenever $n \geq N$.

\newcommand{\NN}{\mathbb{N}}

> lim a = x
$\iff$
> $\exists n \in \NN$ 
