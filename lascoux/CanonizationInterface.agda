module CanonizationInterface where

open import Data.List
open import Data.Nat
open import Data.List.Properties
open import Data.Nat.Properties
open import Data.Product using (∃; Σ; _×_; _,_; _,′_)
open import Relation.Binary
open import Relation.Binary.PropositionalEquality using (_≡_; refl; cong; subst) renaming (trans to ≡-trans; sym to ≡-sym)

open import General
open import Relation.Nullary
open import Data.Empty
open Relation.Binary.PropositionalEquality.≡-Reasoning

open ≤-Reasoning renaming (_∎ to _≤∎; begin_ to begin-≤_) hiding (_≡⟨_⟩_)
open import Arithmetic hiding (n)
open import Coxeter hiding (n; l)
open import Canonization hiding (n; l)

variable
    n : ℕ
    l : List ℕ

F-canonize-p> : (n r i : ℕ)
                -> (0 < n)
                -> (r ≤ n)
                -> ((suc i) < n)
                -> (n < (suc i) + r)
                -> ((n ↓ r) ++ [ suc i ]) ≃ (i ∷ n ↓ r)
F-canonize-p> (suc n) (suc (suc r)) i pn (s≤s prn) (s≤s pin) (s≤s pirn) =
  let lmm : suc (n ∸ suc i) ≤ n
      lmm = ∸-implies-≤ {r = i} (≡-sym (∸-up pin))
      lm2 =
        begin
          i + suc (n ∸ suc i)
        ≡⟨ +-three-assoc {i} {1} {n ∸ suc i} ⟩
          suc i + (n ∸ suc i)
        ≡⟨ +-comm (suc i) (n ∸ suc i) ⟩
          (n ∸ suc i) + suc i
        ≡⟨ minus-plus {n} {suc i} {pin}⟩
          n
        ∎
      pin' : i ≡ n ∸ suc (n ∸ suc i)
      pin' = introduce-∸ lmm lm2

      tt : n ≤ (i + suc r)
      tt = ≤-down2
        (begin-≤
          suc n
         ≤⟨ pirn ⟩
          i + suc (suc r)
        ≤⟨ ≤-reflexive (+-three-assoc {i} {1} {suc r}) ⟩
          suc (i + suc r)
        ≤∎)

      pr2 : 1 ≤ suc i ∸ (n ∸ suc r)
      pr2 = introduce-∸-≤ (introduce-∸-≤l prn (≤-up tt)) (s≤s (introduce-∸-≤l prn (tt)))

      pirn' : n ∸ suc i + (suc i ∸ (n ∸ suc r)) ≤ n
      pirn' = eliminate-∸-≤ (introduce-∸-≤l (introduce-∸-≤l {n} {suc i} {r = suc r} prn (≤-up tt)) (≤-up-+ pin)) (∸-anti-≤ (∸-implies-≤ {r = n ∸ suc r} refl) pin)

      tt = canonize-p> (suc n) ((suc n) ∸ (1 + (suc i)) ) ((1 + i) ∸ ((suc n) ∸ (suc (suc r)))) {i} pr2 (s≤s pirn') {pin'}
  in {!  tt !}
-- TODO move the impossible cases up
-- r ≤ 1
F-canonize-p> (suc n) zero i pn prn (s≤s pin) (s≤s pirn) =
  let tt = begin-≤
             suc (suc n)
           ≤⟨ s≤s pirn ⟩
             suc (i + zero)
           ≤⟨ s≤s (≤-reflexive (+-comm i zero)) ⟩
             suc i
           ≤⟨ pin ⟩
             n
           ≤⟨ ≤-up (≤-reflexive refl) ⟩
             suc n
           ≤∎
  in  ⊥-elim (1+n≰n tt)
-- r ≤ 1
F-canonize-p> (suc n) (suc zero) i pn prn (s≤s pin) (s≤s pirn) =
  let tt = begin-≤
             suc (suc n)
           ≤⟨ s≤s pirn ⟩
             suc (i + 1)
           ≤⟨ s≤s (≤-reflexive (+-comm i 1)) ⟩
             suc (suc i)
           ≤⟨ s≤s pin ⟩
             suc n
           ≤∎
  in  ⊥-elim (1+n≰n tt)


F-canonize-p≡ : (n r i : ℕ)
                -> (0 < n)
                -> (r < n)
                -> ((suc i) < n)
                -> (((suc i) + 1 + r) ≡ n)
                -> ((n ↓ r) ++ [ suc i ]) ≃ (n ↓ (1 + r))
F-canonize-p≡ n r i pn prn pin pirn =
  let tx = begin
             (suc i) + suc r
           ≡⟨ cong suc (≡-sym (+-assoc i 1 r)) ⟩
             suc ((i + 1) + r)
           ≡⟨ pirn ⟩
             n
           ∎
  in  canonize-p≡ n r (suc i) pn prn (introduce-∸ prn tx)

F-canonize-p< : (n r i : ℕ)
                -> (0 < n)
                -> (r ≤ n)
                -> ((suc i) < n)
                -> ((suc i) + (1 + r) < n)
                -> ((n ↓ r) ++ [ suc i ]) ≃ ((suc i) ∷ n ↓ r)
F-canonize-p< (suc n) r i pn prn (s≤s pin) pirn = {!!} --
--  let xx = {!!}
--  in  canonize-p< n r ( n ∸ (2 + i + r)) {suc i} {!!} {!!} {{!!}}
