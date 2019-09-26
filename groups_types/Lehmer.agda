{-# OPTIONS --without-K #-}

module Lehmer where

open import Data.Nat
open import Data.Fin
open import General
open import Relation.Nullary
open import Relation.Binary.PropositionalEquality
open import Data.Vec hiding (insert)
open import Function

FinN : {n : ℕ} -> (k : Fin n) -> Set
FinN k = Fin (suc (toℕ k))

data Code (n : ℕ): Set where
    Perm : ((k : Fin n) -> (FinN k)) -> Code n


howManySmaller : {n m : ℕ} -> (Fin (suc n) -> Fin m) -> Fin m -> Fin (suc n)
howManySmaller {0F} {m} f my = 0F
howManySmaller {suc n} {m} f my with my Data.Fin.<? f 0F
...  | yes _ = suc (howManySmaller {n} {m} (λ k ->  f (suc k)) my)
...  | Dec.no _ = inject₁ (howManySmaller {n} {m} (λ k ->  f (suc k)) my)

encode : {n : ℕ} -> (Fin n ≈ Fin n) -> Code n
encode {0F} (Equiv f g x y) = Perm (λ ())
encode {suc n} (Equiv f g x y) = Perm (λ k → howManySmaller (λ l → f (inject! l)) k)

-- -- addTo : {n : ℕ} -> (Fin n -> Fin n) -> (k : Fin n) ->

injection-eq : {n : ℕ} -> {k : Fin n} -> toℕ k == toℕ (inject₁ k)
injection-eq {suc n} {0F} = idp
injection-eq {suc n} {suc k} = let p =  injection-eq {k = k} in ap suc p

injection-type-eq : {n : ℕ} -> {k : Fin n} -> {C : ℕ -> Set} -> C (toℕ k) == C (toℕ (inject₁ k))
injection-type-eq {C = C} = ap C injection-eq

coe-inject : {n : ℕ} -> {k : Fin n} -> {C : ℕ -> Set} -> C (toℕ k) -> C (toℕ (inject₁ k))
coe-inject {C = C} = coe (injection-type-eq {C = C})


toℕ-fromℕ : {n : ℕ} -> toℕ (fromℕ n) == n
toℕ-fromℕ {0F} = idp
toℕ-fromℕ {suc n} = let p = toℕ-fromℕ {n}
                    in ap suc p


insert' : {n : ℕ} -> {k : Fin n} -> Vec (Fin n) (suc (toℕ k)) -> (Fin (suc (toℕ k))) -> (Fin (suc n)) -> Vec (Fin (suc n)) (suc (suc (toℕ k)))
insert' {suc n} v 0F e = e ∷ (map inject₁ v)
insert' {suc n} {suc k} (x ∷ v) (suc place) e = let pv : Vec (Fin (suc n)) (suc (toℕ k)) == Vec (Fin (suc n)) (suc (toℕ (inject₁ k)))
                                                    pv = ap (λ x → Vec (Fin (suc n)) (suc x)) injection-eq
                                                    v' = coe pv v

                                                    pplace : Fin (suc (toℕ k)) == Fin (suc (toℕ (inject₁ k)))
                                                    pplace = ap (λ x → Fin (suc x)) injection-eq
                                                    place' = coe pplace place

                                                    l = insert' {n = suc n} {k = inject₁ k} v' place' e

                                                    pl : Vec (Fin (suc (suc n))) (suc (suc (toℕ (inject₁ k)))) == Vec (Fin (suc (suc n))) (suc (suc (toℕ k)))
                                                    pl = ap (λ x → Vec (Fin (suc (suc n))) (suc (suc x))) (rev injection-eq)
                                                    l' = coe pl l
                                                in (inject₁ x) ∷ l'

insert : {n : ℕ} -> Vec (Fin n) n -> Fin n ->  Vec (Fin (suc n)) (suc n)
-- insert {0F} [] 0F = 0F ∷ []
insert {suc n} v place = let pp : Vec (Fin (suc n)) (suc n) == Vec (Fin (suc n)) (suc (toℕ (fromℕ n)))
                             pp = ap (λ x → Vec (Fin (suc n)) (suc x)) (rev (toℕ-fromℕ {n}))

                             v' = coe pp v

                             place' = transport (λ x → Fin x) (rev toℕ-fromℕ) place

                             vv = insert' {n = (suc n)} {k = fromℕ n} v' place' (fromℕ (suc n))

                             ppp : Vec (Fin (suc (suc n))) (suc (suc n)) == Vec (Fin (suc (suc n))) (suc (suc (toℕ (fromℕ n))))
                             ppp = ap (λ x → Vec (Fin (suc (suc n))) (suc (suc x))) (rev (toℕ-fromℕ {n}))

                         in  coe (rev ppp) vv


decrease-fin : {n : ℕ} -> (i : Fin n) -> Fin (suc (toℕ i))
decrease-fin {suc n} 0F = 0F
decrease-fin {suc n} (suc i) = suc (decrease-fin i)

toℕ-suc : {n : ℕ} -> {k : Fin n} -> suc (toℕ k) == toℕ (suc k)
toℕ-suc {suc n} {0F} = idp
toℕ-suc {suc n} {suc k} = let p = toℕ-suc
                          in ap suc p

decode : {n : ℕ} -> Code n -> Vec (Fin n) n
decode {0F} (Perm p) = []
decode {suc n} (Perm p) = let C = (λ x → Vec (Fin (toℕ x)) (toℕ x))
                              f = λ i x → let pp : Vec (Fin (suc (toℕ i))) (suc (toℕ i)) == Vec (Fin (toℕ (suc i))) (toℕ (suc i))
                                              pp = ap (λ kk → Vec (Fin kk) kk) toℕ-suc
                                          in coe pp {!insert' ? ? ?!}
                              x = fold′ {suc n} C f []
                              xl = x (fromℕ (suc n))
                          in transport _ (toℕ-fromℕ {n}) xl



-- decode' {suc n} (Perm p) acc zero = ? -- addTo acc k (p 0F)
-- decode' {suc n} (Perm p) acc (suc k) = {!   !}
    -- where
    -- pp : (k : Fin n) -> Fin (suc (toℕ k))
    -- pp k = {! p (inject₁ k) !}
    --  f' = decode' {n} (Perm (λ l → pp l)) acc k
