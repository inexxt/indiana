{-# OPTIONS --cubical --without-K #-}

module Groups where
    open import Cubical.Core.Everything
    open import Cubical.Foundations.Id using (compPath ; symP ; isContr ; fiber)

    variable
        ℓ : Level

    refl : {A : Set} -> {x : A} -> x ≡ x
    refl {x = x} = λ i → x

    data S3 : Set where
        * : S3
        e1 : * ≡ *
        e2 : * ≡ *
        b1 : compPath e2 (compPath e1 e2) ≡ compPath e1 (compPath e2 e1)
        i1 : compPath e1 e1 ≡ refl
        i2 : compPath e2 e2 ≡ refl

    data F3 : Set where
        a1 : F3
        a2 : F3
        a3 : F3

    -- data 𝟘 : Set where
    --
    -- data 𝟙 : Set where
    --     * : 𝟙
    --
    -- one≠zero : 𝟙 ≡ 𝟘 -> 𝟘
    -- one≠zero p = transport (id {?})

    absurd : {A : Set} -> a1 ≡ a2 -> A
    absurd p = {!   !}

    proj1≡ : {A : Set} -> {B : A -> Set} -> {a1 a2 : A} -> {b1 : B a1} -> {b2 : B a2} -> (a1 , b1) ≡ (a2 , b2) -> (a1 ≡ a2)
    proj1≡ p = {!!}

    p : (f : F3 -> F3) -> isEquiv f -> * ≡ *
    p f e with f a1 , f a2 , f a3
    p f record { equiv-proof = equiv-proof } | a1 , a1 , _  = let a , b = equiv-proof a1
                                                                  t1 = b (a1 , _)
                                                                  t2 = b (a2 , _)
                                                                  abs = compPath (symP t1) t2 in
                                                              absurd (proj1≡ abs)
    p f record { equiv-proof = equiv-proof } | _  , a1 , a1 = {!   !}
    p f record { equiv-proof = equiv-proof } | a1 , _  , a1 = {!   !}
    p f record { equiv-proof = equiv-proof } | a2 , a2 , _  = {!  !}
    p f record { equiv-proof = equiv-proof } | _  , a2 , a2 = {!   !}
    p f record { equiv-proof = equiv-proof } | a2 , _  , a2 = {!   !}
    p f record { equiv-proof = equiv-proof } | a3 , a3 , _  = {!  !}
    p f record { equiv-proof = equiv-proof } | _  , a3 , a3 = {!   !}
    p f record { equiv-proof = equiv-proof } | a3 , _  , a3 = {!   !}
    ... | a1 , a2 , a3 = refl
    ... | a1 , a3 , a2 =  e2
    ... | a2 , a1 , a3 =  e1
    ... | a2 , a3 , a1 =  compPath  e1 e2
    ... | a3 , a1 , a2 =  compPath e2 e1
    ... | a3 , a2 , a1 =  compPath (compPath e1 e2) e1

    proof : (F3 ≃ F3) ≃ (* ≡ *)
    proof = (λ { (f , e) → p f e}) , record { equiv-proof = eqv }
        where
            eqv = λ y → {!   !}

    -- data Sn {n : ℕ}: Set where
    --     Per : ((k : Fin n) -> (Fin (suc (toℕ k)))) -> Sn

    -- 𝟛 : Set
    -- 𝟛 = Sn {3}

    -- -- x is a (12) cycle
    -- x : 𝟛
    -- x = Per (λ { zero → # 0 ;
    --             (suc zero) →  # 0 ;
    --             (suc (suc zero)) →  # 2  })
