module LN.View.Resources.Mod (
  renderView_Resources_Mod
) where



import Data.Maybe                      (Maybe(..))
import Data.Tuple                      (Tuple(..))
import Halogen                         (ComponentHTML)
import Halogen.HTML.Indexed            as H
import Halogen.HTML.Events             as E
import Halogen.HTML.Properties.Indexed as P
import Halogen.Themes.Bootstrap3       as B
import Prelude                         (map, show, ($), (<<<))

import LN.Halogen.Util
import LN.Helpers.Array                (seqArrayFrom)
import LN.Helpers.JSON                 (decodeString)
import LN.Internal.Resource            (RType(..), resourceTypeToRType)
import LN.Input.Resource
import LN.Input.Types                  (Input(..))
import LN.State.Resource               (ResourceRequestState)
import LN.State.Types                  (State)
import LN.View.Module.Loading          (renderLoading)
import LN.T



renderView_Resources_Mod :: Maybe Int -> State -> ComponentHTML Input
renderView_Resources_Mod m_resource_id st =
  case st.currentResourceRequest, st.currentResourceRequestSt of
    Nothing, _                  -> renderLoading
    Just resource_req, Just rst -> renderView_Resources_Mod' m_resource_id resource_req rst st



renderView_Resources_Mod' :: Maybe Int -> ResourceRequest -> ResourceRequestState -> State -> ComponentHTML Input
renderView_Resources_Mod' m_resource_id resource_req rst st =
  H.div_ [
    H.h1_
      [ H.text "Add Resource" ]

  , input_Label "Title" "Title" resource.title P.InputText  (E.input (CompResource <<< InputResource_Mod_SetTitle))

  , textArea_Label "Description" "Description" resource.description (E.input (CompResource <<< InputResource_Mod_SetDescription))

  --
  -- ResourceSource
  --

    , radioMenu "Resource Type" "resource-type" [RTypeNONE, RTypeURL, RTypeISBN] (CompResource <<< InputResource_ModState_SetRType) rst.rtype

    , case rst.rtype of
           RTypeNONE -> H.p_ [H.text "NONE"]
           RTypeURL  -> H.p_ [input_Label "URL" "url" (show resource.source) P.InputUrl (E.input (\url -> CompResource $ InputResource_Mod_SetSource (URL url)))]
           RTypeISBN -> H.p_ [input_Label "ISBN" "isbn" (show resource.source) P.InputText (E.input (\isbn -> CompResource $ InputResource_Mod_SetSource (ISBN isbn)))]

  --
  -- ResourceAuthor
  --

  , input_Label "Author" "Author" "" P.InputText  (E.input (CompResource <<< InputResource_Mod_AddAuthor))

  , case resource.author of
         Nothing -> H.div_ []
         (Just authors) -> H.div_ $
            map (\(Tuple idx author) ->
              input_DeleteEdit
                P.InputText
                author
                (E.input (\new -> (CompResource $ InputResource_Mod_EditAuthor idx new)))
                (E.input_ (CompResource $ InputResource_Mod_DelAuthor idx))
              ) $ seqArrayFrom authors

  --
  -- ResourceCategories
  --

  , input_Label "Categories" "Category" "" P.InputText  (E.input (CompResource <<< InputResource_Mod_AddCategory <<< decodeString))

  , H.div_ $
      map (\(Tuple idx category) ->
        input_DeleteEdit
          P.InputText
          (show category)
          (E.input (\new -> CompResource $ InputResource_Mod_EditCategory idx (decodeString new)))
          (E.input_ (CompResource $ InputResource_Mod_DelCategory idx))
      ) $ seqArrayFrom resource.categories

  --
  -- ResourceVisibility
  --

  , radioMenu "Visibility" "resource-viz" [Public, Private] (CompResource <<< InputResource_Mod_SetVisibility) resource.visibility

  , case resource.visibility of
         Public  -> H.p_ [H.text "Public"]
         Private -> H.p_ [H.text "Private"]

  --
  -- ResourceUrls
  --

  , input_Label "Urls" "Url" "" P.InputText  (E.input (CompResource <<< InputResource_Mod_AddUrl))

  , case resource.urls of
         Nothing -> H.div_ []
         (Just urls) -> H.div_ $
            map (\(Tuple idx url) ->
              input_DeleteEdit
                P.InputUrl
                url
                (E.input (\new -> CompResource $ InputResource_Mod_EditUrl idx new))
                (E.input_ (CompResource $ InputResource_Mod_DelUrl idx))
              ) $ seqArrayFrom urls

 , simpleInfoButton "Create!" (CompResource $ InputResource_Mod_Save m_resource_id)

  ]
  where
  resource = unwrapResourceRequest resource_req
