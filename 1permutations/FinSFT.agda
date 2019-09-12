{-# OPTIONS --without-K #-}
{-# OPTIONS --allow-unsolved-metas #-}

module FinSFT where
    open import FinTypes
    open import StandardFinTypes
    open import Agda.Builtin.Sigma
    open import Data.Product using (∃; proj₁; proj₂)
    open import Data.Nat using (ℕ ; _<_)
    open import Data.Fin
    open import NatSFT
    open import General
    open import StandardFinTypesOps
    open ℕ
    open import Relation.Binary.PropositionalEquality

    myFinToFin : {T : Type} -> {t : StandardFinType T} -> (Member T) -> Fin (sftToNat t)
    myFinToFin {_} {FinS t} (left x) = suc (myFinToFin x)
    myFinToFin {_} {FinS t} (right *) = zero

    finToMyFin : {n : ℕ} -> (Fin (suc n)) -> ∃ (λ T -> Prod (StandardFinType T) (Member T))
    finToMyFin {zero} zero = let st = FinS Fin0 in
                             getTypeFromStandardType st , st times right *
    finToMyFin {suc n} (suc k) = let (t , pm) = finToMyFin {n} k
                                     m = p₂ pm in
                                 t Type.+ 𝟙 , ((FinS (p₁ pm)) times left m)

    finfin : {T : Type} -> {t : StandardFinType T} -> Fin (sftToNat t) ≈ (Member T)
    finfin {_} {Fin0} = Equiv (λ ()) (λ ()) (λ ()) (λ ())
    finfin {_} {FinS t} = Equiv ? {!!} {!!} {!!}
                          -- let x = λ k -> p₂ (proj₂ (finToMyFin k)) in
                          -- Equiv (λ _ → right *) myFinToFin {!   !} {!   !}
