{-# OPTIONS --universe-polymorphism #-}
module Category.Functor where

open import Support
open import Category
open import Category.Functor.Core public
open import Category.Morphisms

infix  4 _≡_

data [_]_∼_ {o ℓ e} (C : Category o ℓ e) {A B} (f : Category.Hom C A B) : ∀ {X Y} → Category.Hom C X Y → Set (ℓ ⊔ e) where
  refl : {g : Category.Hom C A B} → (f≡g : Category._≡_ C f g) → [ C ] f ∼ g

_≡_ : ∀ {o ℓ e} {o′ ℓ′ e′} {C : Category o ℓ e} {D : Category o′ ℓ′ e′} → (F G : Functor C D) → Set (e′ ⊔ ℓ′ ⊔ ℓ ⊔ o)
_≡_ {C = C} {D} F G = ∀ {A B} → (f : Category.Hom C A B) → [ D ] Functor.F₁ F f ∼ Functor.F₁ G f

{-
.equiv : ∀ {o ℓ e} {o′ ℓ′ e′} {C : Category o ℓ e} {D : Category o′ ℓ′ e′} → IsEquivalence (_≡_ {C = C} {D = D})
equiv {C = C} {D} = record 
  { refl = λ {F} → refl′ {F}
  ; sym = λ {F} {G} → sym′ {F} {G}
  ; trans = λ {F} {G} {H} → trans′ {F} {G} {H}
  }
  where
  module C = Category.Category C
  module D = Category.Category D

  refl′ : {F : Functor C D} {A B : Category.Obj C} (f : Category.Hom C A B) → [ D ] Functor.F₁ F f ∼ Functor.F₁ F f
  refl′ {F} f = refl {C = D} (Functor.F-resp-≡ F (IsEquivalence.refl C.equiv))

  sym′ : {F G : Functor C D} → 
        ({A B : Category.Obj C} (f : Category.Hom C A B) → [ D ] Functor.F₁ F f ∼ Functor.F₁ G f) →
        ({A B : Category.Obj C} (f : Category.Hom C A B) → [ D ] Functor.F₁ G f ∼ Functor.F₁ F f)
  sym′ {F} {G} F∼G {A} {B} f = helper (F∼G f)
    where
    helper : ∀ {a b c d} {f : Category.Hom D a b} {g : Category.Hom D c d}
           → [ D ] f ∼ g → [ D ] g ∼ f
    helper (refl pf) = refl {C = D} (IsEquivalence.sym (Category.equiv D) pf)

  trans′ : {F G H : Functor C D} →
          ({A B : Category.Obj C} (f : Category.Hom C A B) → [ D ] Functor.F₁ F f ∼ Functor.F₁ G f) →
          ({A B : Category.Obj C} (f : Category.Hom C A B) → [ D ] Functor.F₁ G f ∼ Functor.F₁ H f) →
          ({A B : Category.Obj C} (f : Category.Hom C A B) → [ D ] Functor.F₁ F f ∼ Functor.F₁ H f)
  trans′ {F} {G} {H} F∼G G∼H {A} {B} f = helper (F∼G f) (G∼H f)
    where
    helper : ∀ {a b c d x y} {f : Category.Hom D a b} {g : Category.Hom D c d} {h : Category.Hom D x y}
           → [ D ] f ∼ g → [ D ] g ∼ h → [ D ] f ∼ h
    helper (refl pf₀) (refl pf₁) = refl {C = D} (IsEquivalence.trans (Category.equiv D) pf₀ pf₁)
-}

.∘-resp-≡  : ∀ {o₀ ℓ₀ e₀ o₁ ℓ₁ e₁ o₂ ℓ₂ e₂}
               {A : Category o₀ ℓ₀ e₀} {B : Category o₁ ℓ₁ e₁} {C : Category o₂ ℓ₂ e₂}
               {F H : Functor B C} {G I : Functor A B} 
           → F ≡ H → G ≡ I → F ∘ G ≡ H ∘ I
∘-resp-≡ {B = B} {C} {F} {H} {G} {I} F≡H G≡I {P} {Q} q = helper {p = Functor.F₁ F (Functor.F₁ G q)} {q = Functor.F₁ H (Functor.F₁ I q)} (G≡I q) (F≡H (Functor.F₁ I q))
  where
  helper : ∀ {a b c d} {z w} -- give it just enough freedom
             {f : Category.Hom B a b} {h : Category.Hom B c d} 
             {g : Category.Hom C (Functor.F₀ F c) (Functor.F₀ F d)} {i : Category.Hom C z w} 
             {p : Category.Hom C (Functor.F₀ F a) (Functor.F₀ F b)} {q : Category.Hom C z w}
         → [ B ] f ∼ h → [ C ] g ∼ i → [ C ] p ∼ q
  helper (refl f≡h) (refl g≡i) = refl {!!}