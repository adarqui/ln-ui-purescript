module LN.View.Boards.Mod (
  renderView_Boards_Delete,
  renderView_Boards_New,
  renderView_Boards_Edit,
  renderView_Boards_Mod,

  renderView_Boards_NewS,
  renderView_Boards_EditS,
  renderView_Boards_DeleteS
) where



import Data.Maybe                      (Maybe(..), maybe)
import Data.Tuple                      (Tuple(..))
import Halogen                         (ComponentHTML)
import Halogen.HTML.Indexed            as H
import Halogen.HTML.Events             as E
import Halogen.HTML.Properties.Indexed as P
import Halogen.Themes.Bootstrap3       as B
import Optic.Core                      ((^.), (..))
import Prelude                         (id, map, show, const, ($), (<<<), (<>))

import LN.Halogen.Util
import LN.Helpers.Array                (seqArrayFrom)
import LN.Helpers.JSON                 (decodeString)
import LN.Input.Board                  (Board_Mod(..))
import LN.Input.Types                  (Input(..), cBoardMod)
import LN.Router.Class.CRUD            (TyCRUD(..))
import LN.Router.Class.Routes          (Routes(..))
import LN.State.Loading                (getLoading, l_currentBoard)
import LN.State.Board                  (BoardRequestState)
import LN.State.Types                  (State)
import LN.View.Fields                  ( mandatoryNameField, optionalDescriptionField, mandatoryBooleanYesNoField
                                       , suggestedTagsField, tagsField)
import LN.View.Helpers                 (buttons_CreateEditCancel)
import LN.View.Module.Loading          (renderLoading)
import LN.T



renderView_Boards_Delete :: State -> ComponentHTML Input
renderView_Boards_Delete st =

  case st.currentBoard, getLoading l_currentBoard st.loading of
       _, true          -> renderLoading
       Nothing, false   -> H.div_ [H.p_ [H.text "board unavailable."]]
       Just pack, false -> renderView_Boards_Delete' pack st



renderView_Boards_Delete' :: BoardPackResponse -> State -> ComponentHTML Input
renderView_Boards_Delete' pack st =
  H.div_ [H.p_ [H.text "Delete? <yes/no>"]]
 where
 board = pack ^. _BoardPackResponse .. board_ ^. _BoardResponse



renderView_Boards_New :: State -> ComponentHTML Input
renderView_Boards_New = renderView_Boards_Mod TyCreate Nothing



renderView_Boards_Edit :: Int -> State -> ComponentHTML Input
renderView_Boards_Edit board_id = renderView_Boards_Mod TyEdit (Just board_id)



renderView_Boards_Mod :: TyCRUD -> Maybe Int -> State -> ComponentHTML Input
renderView_Boards_Mod crud m_board_id st =
  case st.currentForum, st.currentBoardRequest, st.currentBoardRequestSt, getLoading l_currentBoard st.loading of
    _, _, _, true                                             -> renderLoading
    Just forum_pack, Just board_req, Just board_req_st, false -> renderView_Boards_Mod' crud forum_pack m_board_id board_req board_req_st
    _, _, _, false                                            -> H.div_ [H.p_ [H.text "Boards_Mod: unexpected error."]]



renderView_Boards_Mod' :: TyCRUD -> ForumPackResponse -> Maybe Int -> BoardRequest -> BoardRequestState -> ComponentHTML Input
renderView_Boards_Mod' crud forum_pack m_board_id board_req board_req_st =
  H.div_ [

    H.h1_ [ H.text $ show crud <> " Board" ]

  , mandatoryNameField board.displayName (cBoardMod <<< SetDisplayName)

  , optionalDescriptionField board.description (cBoardMod <<< SetDescription) (cBoardMod RemoveDescription)

  , mandatoryBooleanYesNoField "Anonymous" board.isAnonymous false (cBoardMod <<< SetIsAnonymous)

  , mandatoryBooleanYesNoField "Can create sub boards" board.canCreateSubBoards true (cBoardMod <<< SetCanCreateSubBoards)

  , mandatoryBooleanYesNoField "Can create threads" board.canCreateThreads true (cBoardMod <<< SetCanCreateThreads)

  , suggestedTagsField
      board.suggestedTags
      (maybe "" id board_req_st.currentSuggestedTag)
      (cBoardMod <<< SetSuggestedTag)
      (cBoardMod AddSuggestedTag)
      (cBoardMod <<< DeleteSuggestedTag)
      (cBoardMod ClearSuggestedTags)

  , tagsField
      board.tags
      (maybe "" id board_req_st.currentTag)
      (cBoardMod <<< SetTag)
      (cBoardMod AddTag)
      (cBoardMod <<< DeleteTag)
      (cBoardMod ClearTags)

  , buttons_CreateEditCancel m_board_id (cBoardMod $ Create forum.id) (cBoardMod <<< EditP) About

  ]
  where
  board    = unwrapBoardRequest board_req
  forum    = forum_pack ^. _ForumPackResponse .. forum_ ^. _ForumResponse



renderView_Boards_DeleteS :: State -> ComponentHTML Input
renderView_Boards_DeleteS = renderView_Boards_Delete



renderView_Boards_NewS :: State -> ComponentHTML Input
renderView_Boards_NewS = renderView_Boards_New



renderView_Boards_EditS :: State -> ComponentHTML Input
renderView_Boards_EditS st =

  case st.currentOrganization, st.currentBoard of

    Just org_pack, Just board_pack ->
      renderView_Boards_Edit
        (board_pack ^. _BoardPackResponse .. board_ ^. _BoardResponse .. id_)
        st

    _, _       -> H.div_ [H.text "error"]
