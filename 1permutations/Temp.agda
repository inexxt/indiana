{-# OPTIONS --without-K #-}
{-# OPTIONS --allow-unsolved-metas #-}

module _ where
    open import General
    open import Level
    open _≈_

    variable
        ι ℓ l : Level

    data Type : Set where
        𝟘   : Type
        𝟙   : Type
        _×_ : Type -> Type -> Type
        _+_ : Type -> Type -> Type

    data Member : Type -> Set where
        *     : Member 𝟙
        _,_     : {X : Type} -> {Y : Type} -> Member X -> Member Y -> Member (X × Y)
        left    : {X : Type} -> {Y : Type} -> Member X -> Member (X + Y)
        right   : {X : Type} -> {Y : Type} -> Member Y -> Member (X + Y)

    intro-prod : {A B C : Type} -> ((Member C) -> (Member A)) -> ((Member C) -> (Member B)) -> (Member C) -> (Member (A × B))
    intro-prod f g c = (f c) , (g c)

    elim-prod : {A B : Type} ->
                {C : (Member (A × B)) -> Type} ->
                (f : (a : (Member A)) ->
                     (b : (Member B)) ->
                     (Member (C (a , b)))) ->
                (p : Member (A × B)) -> Member (C p)
    elim-prod f (a , b) = f a b


    ×fst : {X : Type} -> {Y : Type} -> Member (X × Y) -> Member X
    ×fst (a , b) = a

    ×snd : {X : Type} -> {Y : Type} -> Member (X × Y) -> Member Y
    ×snd (a , b) = b

    _∘_ : {A : Set ℓ} -> {B : Set ι} -> {C : Set l} -> (B -> C) -> (A -> B) -> A -> C
    f ∘ g = λ x -> f (g x)

    data _==_ {ℓ} {A : Set ℓ} (a : A) : (b : A) ->  Set ℓ where
        idp : a == a

    J : {A : Set ℓ} ->
        {a : A} ->
        (C : {x : A} -> (a == x) -> Set ι) ->
        (p : C {a} idp) ->
        {x : A} ->
        ((q : (a == x)) -> C q)
    J C p = λ { idp → p }

    ap : {A : Set ℓ} -> {B : Set ι} -> {a b : A} -> (f : A -> B) -> (a == b) -> (f(a) == f(b))
    ap {a = a} f p = J (λ {x} q → f a == f x) idp p

    -- ap : {A : Set ℓ} -> {B : Set ι} -> {a b : A} -> (f : A -> B) -> (a == b) -> (f(a) == f(b))
    -- ap f idp = idp

    coe : {A B : Set ℓ} -> (A == B) -> A -> B
    coe idp a = a

    transport : {A : Set ℓ} -> {a b : A} -> (C : A -> Set ι) -> (a == b) -> C(a) -> C(b)
    transport C = coe ∘ (ap C)

    apd : {A : Set ℓ} -> {C : A -> Set ι} -> {a b : A} -> (f : (a : A) -> C a) -> (p : (a == b)) -> (transport C p (f a)) == (f b)
    apd {C = C} f idp = idp

    -- p^-1 : Id

    data _≡_ : {T : Type} -> Member T -> Member T -> Set where
        refl₁ : * ≡ *
        reflₓ : {X : Type} -> {Y : Type}
                -> {p11 : Member X}
                -> {p21 : Member X}
                -> {p12 : Member Y}
                -> {p22 : Member Y}
                -> p11 ≡ p21
                -> p12 ≡ p22
                -> (p11 , p12) ≡ (p21 , p22)
        reflₗ : {X : Type} -> {Y : Type}
                -> {x1 : Member X}
                -> {x2 : Member X}
                -> x1 ≡ x2
                -> _≡_ {X + Y} (left x1) (left x2)
        reflᵣ : {X : Type} -> {Y : Type}
                -> {y1 : Member Y}
                -> {y2 : Member Y}
                -> y1 ≡ y2
                -> (right {X} y1) ≡ (right {X} y2)
        -- ≡comp : {A : Type} -> {a b c : Member A} -> a ≡ b -> b ≡ c -> a ≡ c -- TODO don't need that
        -- ≡app  : {A B : Type} -> {a b : Member A} -> (f : Member A -> Member B) -> a ≡ b -> (f a) ≡ (f b) -- TODO don't need that

    Id->× : {A B : Type} -> {a c : Member A} -> {b d : Member B} -> (a == c) -> (b == d) -> (a , b) == (c , d)
    Id->× idp idp = idp

    ×->Id : {A B : Type} -> {p q : Member (A × B)} -> p == q -> (×fst p) == (×fst q)
    ×->Id x = ap ×fst x

    ×<->Id : {A B : Type} -> {p q : Member (A × B)} -> p == q -> (×fst p) == (×fst q)
    ×<->Id x = ap ×fst x

    -- ≡-Id : {T : Type} -> {a b : Member T} -> (a ≡ b) -> (a == b)
    -- ≡-Id refl₁ = idp
    -- ≡-Id (reflₓ pa pb) = let x = (≡-Id pa)
    --                          y = (≡-Id pb) in
    --                      {!   !}
    -- ≡-Id (reflₗ p) = {!   !}
    -- ≡-Id (reflᵣ p) = {!   !}
    -- ≡-Id (≡comp p p₃) = {!   !}
    -- ≡-Id (≡app f₁ p) = {!   !}


    refl : {A : Type} -> (a : Member A) -> a ≡ a
    refl * = refl₁
    refl (a , b) = reflₓ (refl a) (refl b)
    refl {A + B} (left a) = reflₗ {A} {B} (refl a)
    refl {A + B} (right b) = reflᵣ {A} {B} (refl b)

    -- J≡ : {A : Type} ->
    --     {a : Member A} ->
    --     (C : {x : Member A} -> (a ≡ x) -> Type) ->
    --     (p : Member (C {a} (refl a))) ->
    --     {x : Member A} ->
    --     ((q : (a ≡ x)) -> Member (C q))
    -- J≡ {a = *} C p refl₁ = p
    -- J≡ {A = X × Y} {a1 , a2} C p (reflₓ q q₁) = J≡ (λ z → C (reflₓ z q₁)) (J≡ (λ z → C (reflₓ (refl a1) z)) p q₁) q
    -- J≡ {A = X + Y} {a = left a} C p (reflₗ q) = J≡ (λ z → C (reflₗ z)) p q
    -- J≡ {A = X + Y} {a = right a} C p (reflᵣ q) = J≡ (λ z → C (reflᵣ z)) p q

    J≡ : {A : Type} ->
        {a : Member A} ->
        (C : {x : Member A} -> (a ≡ x) -> Set ℓ) ->
        (p : C {a} (refl a)) ->
        {x : Member A} ->
        ((q : (a ≡ x)) -> C q)
    J≡ {a = *} C p refl₁ = p
    J≡ {A = X × Y} {a1 , a2} C p (reflₓ q q₁) = let ll : {x₁ : Member Y} → a2 ≡ x₁ → Set _
                                                    ll = λ z → C (reflₓ (refl a1) z)

                                                    p2 : C (reflₓ (refl a1) q₁)
                                                    p2 = J≡ ll p q₁

                                                in  J≡ {_} {X} {a1} (λ {xx} z → C {xx , _} (reflₓ z q₁)) p2 {_} q
    J≡ {A = X + Y} {a = left a} C p (reflₗ q) = J≡ (λ z → C (reflₗ z)) p q
    J≡ {A = X + Y} {a = right a} C p (reflᵣ q) = J≡ (λ z → C (reflᵣ z)) p q
