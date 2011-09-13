{-# OPTIONS --universe-polymorphism #-}

open import Relation.Binary
  using (Setoid; module IsEquivalence)

-- Free category generated by a directed graph.
-- The graph is given by a type (Obj) of nodes and a (Obj × Obj)-indexed
-- Setoid of (directed) edges.  Every inhabitant of the node type is 
-- considered to be a (distinct) node of the graph, and (equivalence 
-- classes of) inhabitants of the edge type (for a given pair of 
-- nodes) are considered edges of the graph.  
module Categories.Free
  {o ℓ e} {Obj : Set o} 
  (ArrSetoid : Obj → Obj → Setoid ℓ e) where

open import Categories.Category
open import Categories.Functor using (Functor)
open import Relation.Binary.PropositionalEquality
  using ()
  renaming (_≡_ to _≣_; refl to ≣-refl)
open import Data.Product
open import Data.Star
import Data.Star.Equality as StarEquality
open import Function using (flip)
open import Level using (_⊔_)

private
  Arr : Obj → Obj → Set ℓ
  Arr c d = Setoid.Carrier (ArrSetoid c d)

Free : Category o (o ⊔ ℓ) (o ⊔ ℓ ⊔ e)
Free = record
  { Obj       = Obj
  ; _⇒_       = Star Arr
  ; id        = ε
  ; _∘_       = _▻▻_
  ; _≡_       = _≡_
  ; equiv     = equiv
  ; assoc     = λ{A}{B}{C}{D} {f}{g}{h} → ▻▻-assoc {A}{B}{C}{D} f g h
  ; identityˡ = IsEquivalence.reflexive equiv f◅◅ε≣f
  ; identityʳ = IsEquivalence.reflexive equiv ≣-refl
  ; ∘-resp-≡  = flip _◅◅-cong_
  }
  where
    open StarEquality ArrSetoid
      renaming (_≈_ to _≡_; isEquivalence to equiv)
    
    f◅◅ε≣f : ∀ {A B}{f : Star Arr A B} -> (f ◅◅ ε) ≣ f
    f◅◅ε≣f {f = ε} = ≣-refl
    f◅◅ε≣f {f = x ◅ xs} rewrite f◅◅ε≣f {f = xs}  = ≣-refl


-- Given a map F₀ from Obj to the objects of some category C
-- and a map F₁ from Arr A B to C [ A ⇒ B ] which respects the
-- equivalence in ArrSetoid (and a proof F₁-resp-≈ of that fact),
-- cata F₀ F₁ F₁-resp-≈ gives a functor from Free to C which
-- maps:
--  Objects:  X : Obj       ↦ F₀ X : C.Obj
--  Edges:    f : Arr A B   ↦ F₁ f : C [ F₀ A , F₁ B ]
--  Paths:    ε             ↦ id
--            fs ▻▻ gs      ↦ fs ∘ gs
-- 
-- This functor is (I believe) an initial morphism from ArrSetoid 
-- (considered as an object in "Graphs") to the underlying graph
-- functor (from "Categories" to "Graphs").
-- 
-- TODO: Prove:
--  Free : Functor Graphs Categories
--  Free⊣Underlying : Adjunction Free Underlying
-- Then let Cata = Adjunction.unit Free⊣Underlying
-- and prove Cata to be initial in the appropriate comma category
-- (Constant G ↓ Underlying, I think - where G is the generating graph).
Cata : ∀{o₂ ℓ₂ e₂}{C : Category o₂ ℓ₂ e₂}
  → (F₀        : Obj → Category.Obj C)
  → (F₁        : ∀ {A B} → Arr A B → C [ F₀ A , F₀ B ])
  → (F₁-resp-≈ : ∀ {A B} {f g : Arr A B}
                → Setoid._≈_ (ArrSetoid A B) f g
                → C [ F₁ f ≡ F₁ g ])
  → Functor Free C
Cata {C = C} F₀ F₁ F₁-resp-≈ = record
  { F₀            = F₀
  ; F₁            = F₁*
  ; identity      = refl
  ; homomorphism  = λ{X}{Y}{Z}{f}{g} → homomorphism {X}{Y}{Z}{f}{g}
  ; F-resp-≡      = F₁*-resp-≡
  }
  where
    open Category C
    open Equiv
    open HomReasoning
    open StarEquality ArrSetoid using (ε-cong; _◅-cong_)
    
    F₁* : ∀ {A B} → Free [ A , B ] → C [ F₀ A , F₀ B ]
    F₁* ε = id
    F₁* (f ◅ fs) = F₁* fs ∘ F₁ f
    
    .homomorphism : ∀ {X Y Z} {f : Free [ X , Y ]} {g : Free [ Y , Z ]}
                  → C [ F₁* (Free [ g ∘ f ]) ≡ C [ F₁* g ∘ F₁* f ] ]
    homomorphism {f = ε} = sym identityʳ
    homomorphism {f = f ◅ fs}{gs} =
      begin
        F₁* (fs ◅◅ gs) ∘ F₁ f
      ↓⟨ homomorphism {f = fs}{gs} ⟩∘⟨ refl ⟩
        (F₁* gs ∘ F₁* fs) ∘ F₁ f
      ↓⟨ assoc ⟩
        F₁* gs ∘ F₁* fs ∘ F₁ f
      ∎
    
    .F₁*-resp-≡ : ∀ {A B} {f g : Free [ A , B ]} → Free [ f ≡ g ] → C [ F₁* f ≡ F₁* g ]
    F₁*-resp-≡ {f = ε}{.ε} ε-cong = refl
    F₁*-resp-≡ {f = f ◅ fs}{g ◅ gs} (f≈g ◅-cong fs≈gs) = 
      begin
        F₁* fs ∘ F₁ f
      ↓⟨ F₁*-resp-≡ fs≈gs ⟩∘⟨ F₁-resp-≈ f≈g ⟩
        F₁* gs ∘ F₁ g
      ∎
    F₁*-resp-≡ {f = f ◅ fs}{ε} ()