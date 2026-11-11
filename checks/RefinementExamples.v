From Stdlib Require Import List Arith.
From stdpp Require Import base gmap.
Import ListNotations.

(* Nested inductives are not categorically forbidden. *)
Inductive rose : Type := Node : list rose -> rose.
Inductive direct_positive : Prop :=
| direct_positive_intro : direct_positive -> direct_positive.
Inductive positive : nat -> Prop :=
| positive_node : forall xs : list nat,
    (forall x, In x xs -> positive x) -> positive (length xs).
Fail Inductive negative : Prop :=
| negative_intro : (negative -> False) -> negative.

(* A pattern let in a constructor premise is legal. *)
Inductive pair_property : nat * nat -> Prop :=
| pair_property_intro : forall p,
    (let '(a, b) := p in a = b) -> pair_property p.

(* Concrete mutual operations can precede typeclass registration. *)
Inductive value : Type :=
| unit_value : value
| abstraction : term -> value
with term : Type :=
| return_value : value -> term
| application : term -> term -> term.

Fixpoint value_size (v : value) : nat :=
  match v with
  | unit_value => 1
  | abstraction t => S (term_size t)
  end
with term_size (t : term) : nat :=
  match t with
  | return_value v => S (value_size v)
  | application t1 t2 => S (term_size t1 + term_size t2)
  end.

Fixpoint value_dec (v1 v2 : value) : {v1 = v2} + {v1 <> v2}
with term_dec (t1 t2 : term) : {t1 = t2} + {t1 <> t2}.
Proof.
- decide equality; apply term_dec.
- decide equality; apply value_dec.
Defined.

#[local] Instance value_eq_decision : EqDecision value := value_dec.
#[local] Instance term_eq_decision : EqDecision term := term_dec.

Example value_dec_computes :
  (if value_dec unit_value (abstraction (return_value unit_value))
   then true else false) = false.
Proof. reflexivity. Qed.

(* Generalized parameters include proof dependencies. *)
Section Dependencies.
  Variable A : Type.
  Variable P : Prop.
  Variable witness : P.
  Definition identity (x : A) := x.
  Lemma proof_dependency : P.
  Proof. exact witness. Qed.
End Dependencies.
Check (@identity : forall A : Type, A -> A).
Check (@proof_dependency : forall P : Prop, P -> P).

(* The installed stdpp has a bundled PartialOrder as well. *)
#[local] Instance nat_equality_order : PartialOrder (@eq nat).
Proof.
  split.
  - split.
    + intros x. reflexivity.
    + intros x y z Hxy Hyz. now transitivity y.
  - intros x y Hxy Hyx. exact Hxy.
Qed.

(* Pointwise equality avoids dependence on map representation. *)
Example map_lookup_extensional (m1 m2 : gmap nat nat) :
  (forall x, m1 !! x = m2 !! x) -> m1 = m2.
Proof. intros H. apply map_eq. exact H. Qed.

(* Subtype equality can be proved with an explicit uniqueness premise. *)
Lemma subtype_eq {A : Type} (P : A -> Prop)
    (unique : forall x (p q : P x), p = q)
    (x : A) (p q : P x) : exist P x p = exist P x q.
Proof. rewrite (unique x p q). reflexivity. Qed.

Print Assumptions value_dec_computes.
Print Assumptions subtype_eq.
