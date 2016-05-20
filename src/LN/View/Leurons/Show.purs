module LN.View.Leurons.Show (
  renderView_Leurons_Show
) where



import Data.Maybe                      (Maybe(..))
import Halogen                         (ComponentHTML)
import Halogen.HTML.Indexed            as H
import Halogen.HTML.Properties.Indexed as P
import Halogen.Themes.Bootstrap3       as B
import Optic.Core                      ((^.), (..))
import Prelude                         (show, ($))

import LN.Input.Types                  (Input)
import LN.Router.Internal              (linkToP)
import LN.Router.Types                 (Routes(..), CRUD(..))
import LN.State.Types                  (State)
import LN.T



renderView_Leurons_Show :: String -> State -> ComponentHTML Input
renderView_Leurons_Show leuron_sid st =

  case st.currentLeuron of
       Nothing   -> H.div_ [H.text "Leuron Unavailable"]
       Just pack -> renderView_Leurons_Show' pack st



renderView_Leurons_Show' :: LeuronPackResponse -> State -> ComponentHTML Input
renderView_Leurons_Show' pack st =

  H.div [P.class_ B.containerFluid] [
    H.div [P.class_ B.pageHeader] [
      H.h1 [P.class_ B.textCenter] [H.text $ show leuron.id]
--      H.p [P.class_ B.textCenter] [H.text (leuron.description)]
    ],
    H.div [P.class_ B.container] [
      renderLeuron leuron'
    ]
  ]

 where
 leuron  = pack ^. _LeuronPackResponse .. leuron_ ^. _LeuronResponse
 leuron' = pack ^. _LeuronPackResponse .. leuron_




renderLeuron :: LeuronResponse -> ComponentHTML Input
renderLeuron ln =
  case leuron.dataP of
    LnFact _ -> renderLeuron_Fact ln
    _        -> renderLeuron_Unknown ln
  where
  leuron = ln ^. _LeuronResponse



renderLeuron_Fact :: LeuronResponse -> ComponentHTML Input
renderLeuron_Fact ln =
  H.div_ [H.text "fact"]
  where
  leuron = ln ^. _LeuronResponse



renderLeuron_Unknown :: LeuronResponse -> ComponentHTML Input
renderLeuron_Unknown ln =
  H.div_ [H.text "unknown"]
  where
  leuron = ln ^. _LeuronResponse
