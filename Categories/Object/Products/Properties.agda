{-# OPTIONS --universe-polymorphism #-}

open import Categories.Category

module Categories.Object.Products.Properties {o ℓ e} 
  (C : Category o ℓ e) where

open Category C

open import Level

import Categories.Object.Terminal
open Categories.Object.Terminal C

import Categories.Object.BinaryProducts
open Categories.Object.BinaryProducts C

import Categories.Object.Products
open Categories.Object.Products C

import Categories.Morphisms
open Categories.Morphisms C

open import Categories.Square

module Properties (P : Products) where
  open Products P
  
  open Terminal terminal
  open BinaryProducts binary
  open HomReasoning
  open Equiv
  open GlueSquares C
  
  unitˡ : ∀ {X} → (⊤ × X) ≅ X
  unitˡ {X} = record
    { f = π₂
    ; g = ⟨ ! , id {X} ⟩
    ; iso = record
      { isoˡ = 
        begin
          ⟨ ! , id {X} ⟩ ∘ π₂
        ↓⟨ ⟨⟩∘ ⟩
          ⟨ ! ∘ π₂ , id ∘ π₂ ⟩
        ↓⟨ ⟨⟩-cong₂ (!-unique₂ (! ∘ π₂) π₁) (identityˡ) ⟩
          ⟨ π₁ , π₂ ⟩
        ↓⟨ η ⟩
          id
        ∎
      ; isoʳ = commute₂
      }
    }
  
  .unitˡ-natural : ∀ {X Y} {f : X ⇒ Y} → ⟨ ! , id {Y} ⟩ ∘ f ≡ second f ∘ ⟨ ! , id {X} ⟩
  unitˡ-natural {f = f} = 
    begin
      ⟨ ! , id ⟩ ∘ f
    ↓⟨ ⟨⟩∘ ⟩
      ⟨ ! ∘ f , id ∘ f ⟩
    ↑⟨ ⟨⟩-cong₂ (!-unique (! ∘ f)) (id-comm {f = f}) ⟩
      ⟨ ! , f ∘ id ⟩
    ↑⟨ second∘⟨⟩ ⟩
      second f ∘ ⟨ ! , id ⟩
    ∎ 
  
  unitʳ : ∀ {X} → (X × ⊤) ≅ X
  unitʳ {X} = record
    { f = π₁
    ; g = ⟨ id {X} , ! ⟩
    ; iso = record
      { isoˡ = 
        begin
          ⟨ id {X} , ! ⟩ ∘ π₁
        ↓⟨ ⟨⟩∘ ⟩
          ⟨ id ∘ π₁ , ! ∘ π₁ ⟩
        ↓⟨ ⟨⟩-cong₂ (identityˡ) (!-unique₂ (! ∘ π₁) π₂)  ⟩
          ⟨ π₁ , π₂ ⟩
        ↓⟨ η ⟩
          id
        ∎
      ; isoʳ = commute₁
      }
    }
  
  .unitʳ-natural : ∀ {X Y} {f : X ⇒ Y} → ⟨ id , ! ⟩ ∘ f ≡ first f ∘ ⟨ id , ! ⟩
  unitʳ-natural {f = f} =
    begin
      ⟨ id , ! ⟩ ∘ f
    ↓⟨ ⟨⟩∘ ⟩
      ⟨ id ∘ f , ! ∘ f ⟩
    ↑⟨ ⟨⟩-cong₂ (id-comm {f = f}) (!-unique (! ∘ f)) ⟩
      ⟨ f ∘ id , ! ⟩
    ↑⟨ first∘⟨⟩ ⟩
      first f ∘ ⟨ id , ! ⟩
    ∎
  
  .assocˡ-commute : ∀ {X₀ Y₀ X₁ Y₁ X₂ Y₂} {f : X₀ ⇒ Y₀} {g : X₁ ⇒ Y₁} {h : X₂ ⇒ Y₂} → assocˡ ∘ ((f ⁂ g) ⁂ h) ≡ (f ⁂ (g ⁂ h)) ∘ assocˡ
  assocˡ-commute {f = f} {g} {h} =
    begin
      assocˡ ∘ ((f ⁂ g) ⁂ h)
    ↓⟨ ⟨⟩∘ ⟩
      ⟨ (π₁ ∘ π₁) ∘ ((f ⁂ g) ⁂ h) , ⟨ π₂ ∘ π₁ , π₂ ⟩ ∘ ((f ⁂ g) ⁂ h) ⟩
    ↓⟨ ⟨⟩-cong₂ (glue π₁∘⁂ π₁∘⁂) ⟨⟩∘ ⟩
      ⟨ f ∘ (π₁ ∘ π₁) , ⟨ (π₂ ∘ π₁) ∘ ((f ⁂ g) ⁂ h) , π₂ ∘ ((f ⁂ g) ⁂ h) ⟩ ⟩
    ↓⟨ ⟨⟩-congʳ (⟨⟩-cong₂ (glue π₂∘⁂ π₁∘⁂) π₂∘⁂) ⟩
      ⟨ f ∘ (π₁ ∘ π₁) , ⟨ g ∘ (π₂ ∘ π₁) , h ∘ π₂ ⟩ ⟩
    ↑⟨ ⟨⟩-congʳ ⁂∘⟨⟩ ⟩
      ⟨ f ∘ (π₁ ∘ π₁) , (g ⁂ h) ∘ ⟨ π₂ ∘ π₁ , π₂ ⟩ ⟩
    ↑⟨ ⁂∘⟨⟩ ⟩
      (f ⁂ (g ⁂ h)) ∘ assocˡ
    ∎

  .assocʳ-commute : ∀ {X₀ Y₀ X₁ Y₁ X₂ Y₂} {f : X₀ ⇒ Y₀} {g : X₁ ⇒ Y₁} {h : X₂ ⇒ Y₂} → assocʳ ∘ (f ⁂ (g ⁂ h)) ≡ ((f ⁂ g) ⁂ h) ∘ assocʳ
  assocʳ-commute {f = f} {g} {h} =
    begin
      assocʳ ∘ (f ⁂ (g ⁂ h))
    ↓⟨ ⟨⟩∘ ⟩
      ⟨ ⟨ π₁ , π₁ ∘ π₂ ⟩ ∘ (f ⁂ (g ⁂ h)) , (π₂ ∘ π₂) ∘ (f ⁂ (g ⁂ h)) ⟩
    ↓⟨ ⟨⟩-cong₂ ⟨⟩∘ (glue π₂∘⁂ π₂∘⁂) ⟩
      ⟨ ⟨ π₁ ∘ (f ⁂ (g ⁂ h)) , (π₁ ∘ π₂) ∘ (f ⁂ (g ⁂ h)) ⟩ , h ∘ (π₂ ∘ π₂) ⟩
    ↓⟨ ⟨⟩-congˡ (⟨⟩-cong₂ π₁∘⁂ (glue π₁∘⁂ π₂∘⁂)) ⟩
      ⟨ ⟨ f ∘ π₁ , g ∘ (π₁ ∘ π₂) ⟩ , h ∘ (π₂ ∘ π₂) ⟩
    ↑⟨ ⟨⟩-congˡ ⁂∘⟨⟩ ⟩
      ⟨ (f ⁂ g) ∘ ⟨ π₁ , π₁ ∘ π₂ ⟩ , h ∘ (π₂ ∘ π₂) ⟩
    ↑⟨ ⁂∘⟨⟩ ⟩
      ((f ⁂ g) ⁂ h) ∘ assocʳ
    ∎