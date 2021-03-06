module LN.View.ThreadPosts.Show (
  renderView_ThreadPosts_Show,
  renderView_ThreadPosts_Show',
  renderView_ThreadPosts_Show_Single'
) where



import Data.Either                     (Either(..))
import Data.Map                        as M
import Data.Maybe                      (Maybe(..), maybe)
import CSS                             as CSS
import Halogen.HTML.CSS.Indexed        as HCSS
import Halogen                         (ComponentHTML, HTML)
import Halogen.HTML.Indexed            as H
import Halogen.HTML.Properties.Indexed as P
import Halogen.HTML.Events.Indexed     as E
import Halogen.Themes.Bootstrap3       as B
import Optic.Core                      ((^.), (..))
import Prelude                         (id, show, map, ($), (<>), (-), (<<<), (||), (==), (&&))

import LN.ArrayList           (listToArray)

import Data.BBCode.HTML
import Data.BBCode.Parser
import Data.BBCode.Types

import LN.Access
import LN.Input.Types                  (Input(..), cThreadPostMod)
import LN.Input.ThreadPost             (InputThreadPost(..), ThreadPost_Mod(..))
import LN.Router.Link                  (linkTo, linkToP)
import LN.Router.Class.CRUD            (CRUD(..), TyCRUD(..))
import LN.Router.Class.Routes          (Routes(..))
import LN.Router.Class.Params          (emptyParams)
import LN.State.ThreadPost             (ThreadPostRequestState)
import LN.State.PageInfo               (PageInfo)
import LN.State.Types                  (State)
import LN.State.User                   (usersMapLookup', usersMapLookup_ToNick', usersMapLookup_ToUser')
import LN.View.Helpers
import LN.View.ThreadPosts.Shared      (displayUserStats, displayPostStats, displayPostData)
import LN.View.ThreadPosts.Mod         (renderView_ThreadPosts_Mod')
import LN.View.Module.Gravatar         (renderGravatarForUser)
import LN.View.Module.Loading          (renderLoading)
import LN.View.Module.Like             (renderLike)
import LN.View.Module.PageNumbers      (renderPageNumbers)
import LN.T                            ( Ent(..)
                                       , UserSanitizedPackResponse, ThreadPackResponse, BoardPackResponse
                                       , ForumPackResponse, OrganizationPackResponse, PostData(PostDataBBCode)
                                       , ThreadPostPackResponse, ThreadPostRequest
                                       , Size(Medium), ThreadPostStatResponse(ThreadPostStatResponse)
                                       , _UserSanitizedStatResponse, stat_, _UserSanitizedPackResponse
                                       , signature_, _ProfileResponse, profile_, _ThreadPostStatResponse
                                       , _ThreadPostPackResponse, _ThreadPostResponse, threadPost_, body_
                                       , _ThreadPostRequest, _ThreadResponse, thread_, _ThreadPackResponse
                                       , _BoardResponse, board_, _BoardPackResponse, _ForumResponse, forum_
                                       , _ForumPackResponse, _OrganizationResponse, organization_
                                       , _OrganizationPackResponse
                                       , like_, star_)



renderView_ThreadPosts_Show :: State -> ComponentHTML Input
renderView_ThreadPosts_Show st =

  case st.currentOrganization, st.currentForum, st.currentBoard, st.currentThread, st.currentThreadPostRequest, st.currentThreadPostRequestSt of

       Just org_pack, Just forum_pack, Just board_pack, Just thread_pack, Just post_req, Just post_req_st ->
         renderView_ThreadPosts_Show' st.meId org_pack forum_pack board_pack thread_pack st.threadPosts st.threadPostsPageInfo st.currentPage st.usersMap post_req post_req_st

       _, _, _, _, _, _                 -> renderLoading



renderView_ThreadPosts_Show'
  :: Int
  -> OrganizationPackResponse
  -> ForumPackResponse
  -> BoardPackResponse
  -> ThreadPackResponse
  -> M.Map Int ThreadPostPackResponse
  -> PageInfo
  -> Routes
  -> M.Map Int UserSanitizedPackResponse
  -> ThreadPostRequest
  -> ThreadPostRequestState
  -> ComponentHTML Input
renderView_ThreadPosts_Show' me_id org_pack forum_pack board_pack thread_pack post_packs posts_page_info posts_route users_map post_req post_req_st =
  H.div_ [
      renderPageNumbers posts_page_info posts_route
    , H.ul [P.class_ B.listUnstyled] (
        (map (\post_pack ->
          H.li_ [renderView_ThreadPosts_Show_Single' me_id org_pack forum_pack board_pack thread_pack post_pack users_map]
        ) $ listToArray $ M.values post_packs)
        <>
        -- INPUT FORM AT THE BOTTOM
        -- ACCESS: Thread
        -- * Create: post within a thread
        --
        [permissionsMatchCreateHTML
          thread_pack'.permissions
          (\_ -> renderView_ThreadPosts_Mod' TyCreate thread_pack Nothing post_req post_req_st)
          unitDiv]
      )
  , renderPageNumbers posts_page_info posts_route
  ]
  where
  org          = org_pack ^. _OrganizationPackResponse .. organization_ ^. _OrganizationResponse
  forum        = forum_pack ^. _ForumPackResponse .. forum_ ^. _ForumResponse
  board        = board_pack ^. _BoardPackResponse .. board_ ^. _BoardResponse
  thread       = thread_pack ^. _ThreadPackResponse .. thread_ ^. _ThreadResponse
  thread_pack' = thread_pack ^. _ThreadPackResponse




renderView_ThreadPosts_Show_Single'
  :: Int
  -> OrganizationPackResponse
  -> ForumPackResponse
  -> BoardPackResponse
  -> ThreadPackResponse
  -> ThreadPostPackResponse
  -> M.Map Int UserSanitizedPackResponse
  -> ComponentHTML Input
renderView_ThreadPosts_Show_Single' me_id org_pack forum_pack board_pack thread_pack post_pack users_map =
  H.div_ [
    H.div [P.class_ B.row] [
        H.div [P.class_ B.colXs2] [
            H.p_ [linkTo (Users (Show (usersMapLookup_ToNick' users_map post.userId)) emptyParams) (usersMapLookup_ToNick' users_map post.userId)]
          , renderGravatarForUser Medium (usersMapLookup_ToUser' users_map post.userId)
          , displayUserStats (usersMapLookup' users_map post.userId)
        ]
      , H.div [P.class_ B.colXs8] [
            linkTo (OrganizationsForumsBoardsThreadsPosts org.name forum.name board.name thread.name (ShowI post.id) emptyParams) (thread.name <> "/" <> show post.id)
          , H.p_ [H.text $ show post.createdAt]
          , H.p_ [H.text "quote / reply"]

          -- white-space: pre ... for proper output of multiple spaces etc.
          , H.div [HCSS.style $ CSS.textWhitespace CSS.whitespacePre] [displayPostData post.body]

          , H.p_ [H.text $ maybe "" (\user -> maybe "" id $ user ^. _UserSanitizedPackResponse .. profile_ ^. _ProfileResponse .. signature_) (usersMapLookup' users_map post.userId)]
          , H.p_ $ showTags post.tags
        ]
      , H.div [P.class_ B.colXs1] [
        buttonGroup_VerticalSm1 [
          -- ACCESS: ThreadPost
          -- * Update: edit thread post
          -- * Delete: delete thread post
          --
          permissionsHTML'
            post_pack'.permissions
            permCreateEmpty
            permReadEmpty
            (\_ -> button_editThreadPost $ OrganizationsForumsBoardsThreadsPosts org.name forum.name board.name thread.name (EditI post.id) emptyParams)
            (\_ -> button_deleteThreadPost $ OrganizationsForumsBoardsThreadsPosts org.name forum.name board.name thread.name (DeleteI post.id) emptyParams)
            permExecuteEmpty
        ]
      ]
      , H.div [P.class_ B.colXs1] [
        -- ACCESS: Member & Not self
        -- Member: must be a member to like/star
        -- Not Self: can't like/star your own posts
        if (orgMember org_pack && notSelf me_id post.userId)
               then renderLike Ent_ThreadPost post.id like star
               else H.div_ []
        , displayPostStats stats
        ]
    ]
  ]
  where
  org       = org_pack ^. _OrganizationPackResponse .. organization_ ^. _OrganizationResponse
  forum     = forum_pack ^. _ForumPackResponse .. forum_ ^. _ForumResponse
  board     = board_pack ^. _BoardPackResponse .. board_ ^. _BoardResponse
  thread    = thread_pack ^. _ThreadPackResponse .. thread_ ^. _ThreadResponse
  post      = post_pack ^. _ThreadPostPackResponse .. threadPost_ ^. _ThreadPostResponse
  like      = post_pack ^. _ThreadPostPackResponse .. like_
  star      = post_pack ^. _ThreadPostPackResponse .. star_
  stats     = post_pack ^. _ThreadPostPackResponse .. stat_
  post_pack'= post_pack ^. _ThreadPostPackResponse
