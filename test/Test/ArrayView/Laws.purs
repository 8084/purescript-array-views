module Test.ArrayView.Laws (checkLaws) where

import Data.ArrayView.Internal

import Control.Apply (lift2)
import Data.ArrayView.NonEmpty as NEAV
import Data.Newtype (class Newtype)
import Data.Traversable (class Foldable, class Traversable)
import Effect (Effect)
import Effect.Console (log)
import Prelude (class Applicative, class Apply, class Bind, class Eq, class Functor, class Monad, class Monoid, class Semigroup, Unit, discard, (<$>))
import Test.QuickCheck.Arbitrary (class Arbitrary, arbitrary)
import Test.QuickCheck.Laws.Control (checkApplicative, checkApply, checkBind, checkMonad)
import Test.QuickCheck.Laws.Data (checkEq, checkFoldable, checkFunctor, checkMonoid, checkSemigroup)
import Type.Proxy (Proxy(..), Proxy2(..))


-- * some boilerplate required to bypass OrphanInstances.

newtype ArbitraryAV a = ArbitraryAV (ArrayView a)

instance arbitraryArbitraryAV :: Arbitrary a => Arbitrary (ArbitraryAV a) where
   arbitrary = ArbitraryAV <$> (fromArray <$> arbitrary)

derive instance newtypeArbitraryAV :: Newtype (ArbitraryAV a) _
derive newtype instance semigroupArbitraryAV :: Semigroup (ArbitraryAV a)
derive newtype instance monoidArbitraryAV :: Monoid (ArbitraryAV a)
derive newtype instance eqArbitraryAV :: Eq a => Eq (ArbitraryAV a)
derive newtype instance foldableArbitraryAV :: Foldable ArbitraryAV
derive newtype instance functorArbitraryAV :: Functor ArbitraryAV
derive newtype instance applyArbitraryAV :: Apply ArbitraryAV
derive newtype instance bindArbitraryAV :: Bind ArbitraryAV
derive newtype instance applicativeArbitraryAV :: Applicative ArbitraryAV
derive newtype instance monadArbitraryAV :: Monad ArbitraryAV
derive newtype instance traversableArbitraryAV :: Traversable ArbitraryAV

newtype ArbitraryNEAV a = ArbitraryNEAV (NonEmptyArrayView a)

instance arbitraryArbitraryNEAV :: Arbitrary a => Arbitrary (ArbitraryNEAV a) where
   arbitrary = ArbitraryNEAV <$> (lift2 NEAV.cons' arbitrary (fromArray <$> arbitrary))

derive instance newtypeArbitraryNEAV :: Newtype (ArbitraryNEAV a) _
derive newtype instance semigroupArbitraryNEAV :: Semigroup (ArbitraryNEAV a)
derive newtype instance eqArbitraryNEAV :: Eq a => Eq (ArbitraryNEAV a)
derive newtype instance foldableArbitraryNEAV :: Foldable ArbitraryNEAV
derive newtype instance functorArbitraryNEAV :: Functor ArbitraryNEAV
derive newtype instance applyArbitraryNEAV :: Apply ArbitraryNEAV
derive newtype instance bindArbitraryNEAV :: Bind ArbitraryNEAV
derive newtype instance applicativeArbitraryNEAV :: Applicative ArbitraryNEAV
derive newtype instance monadArbitraryNEAV :: Monad ArbitraryNEAV
derive newtype instance traversableArbitraryNEAV :: Traversable ArbitraryNEAV


checkLaws :: Effect Unit
checkLaws = do
  log "checking ArrayView instances"
  checkLawsArrayView
  log "checking NonEmptyArrayView instances"
  checkLawsNonEmptyArrayView

checkLawsArrayView :: Effect Unit
checkLawsArrayView = do
  let prx1 = Proxy :: Proxy (ArbitraryAV Int)
      prx2 = Proxy2 :: Proxy2 ArbitraryAV
  checkSemigroup prx1
  checkMonoid prx1
  checkEq prx1
  checkFoldable prx2
  checkFunctor prx2
  checkApply prx2
  checkBind prx2
  checkMonad prx2
  checkApplicative prx2

checkLawsNonEmptyArrayView :: Effect Unit
checkLawsNonEmptyArrayView = do
  let prx1 = Proxy :: Proxy (ArbitraryNEAV Int)
      prx2 = Proxy2 :: Proxy2 ArbitraryNEAV
  checkSemigroup prx1
  checkEq prx1
  checkFoldable prx2
  checkFunctor prx2
  checkApply prx2
  checkBind prx2
  checkMonad prx2
  checkApplicative prx2
