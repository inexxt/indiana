{-# OPTIONS --without-K #-}
{-# OPTIONS --allow-unsolved-metas #-}

module Maybe where
    open import FinTypes
    open import General
    
    --- Decidable equality

    Maybe : Set -> Set
    Maybe T = Sum (Member 𝟙) T
    --
    -- some : {T : Type} -> (Member T) -> Maybe (Member T)
    -- some = right
    -- n* : {T : Type} -> Maybe (Member T)
    -- n* = left *

    and : {T1 T2 : Set} -> Maybe T1 -> Maybe T2 -> Maybe (Prod T1 T2)
    and (right x) (right y) = right (x times y)
    and _ _ = left *
