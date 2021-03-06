module LN.Router.Class.Routes (
  Routes (..),
  class HasCrumb,
  crumb
) where



import Data.Generic                (class Generic, gEq)
import Data.Map                    as M
import Data.Maybe                  (maybe)
import Data.Tuple                  (Tuple(..), fst)
import Optic.Core                  ((^.), (..))
import Prelude                     (class Eq, class Show, show, (<>), ($), (++), (==))

import LN.T
import LN.Router.Util              (slash)
import LN.Router.Class.CRUD
import LN.Router.Class.Params      (Params, emptyParams, fixParams)
import LN.Router.Class.Link
import LN.Router.Class.OrderBy
import LN.State.Internal.Types     (InternalState)
-- import LN.State.Types              (DriverCh)



data Routes
  = Home
  | About
  | Me
  | Errors
  | Portal
  | Organizations CRUD Params
  | OrganizationsForums String CRUD Params
  | OrganizationsForumsBoards String String CRUD Params
  | OrganizationsForumsBoardsThreads String String String CRUD Params
  | OrganizationsForumsBoardsThreadsPosts String String String String CRUD Params
  | OrganizationsTeams String CRUD Params
  | OrganizationsTeamsMembers String String CRUD Params
  | OrganizationsMembersOnly String
  | OrganizationsMembership String CRUD Params
  | Users CRUD Params
  | UsersProfile String Params
  | UsersSettings String Params
  | UsersPMs String Params
  | UsersThreads String Params
  | UsersThreadPosts String Params
  | UsersWorkouts String Params
  | UsersResources String Params
  | UsersLeurons String Params
  | UsersLikes String Params
  | Resources CRUD Params
  | ResourcesLeurons Int CRUD Params
  | ResourcesSiftLeurons Int Params
  | ResourcesSiftLeuronsLinear Int CRUD Params
  | ResourcesSiftLeuronsRandom Int Params
--  | Leurons CRUD Params
  | Login
  | Logout
  | NotFound



-- derive instance genericRoutes :: Generic Routes



-- instance eqRoute :: Eq Routes where eq = gEq



class HasCrumb a where
  crumb :: a -> InternalState Routes -> Array (Tuple Routes String)



instance routesHasLink :: HasLink Routes where

  link Home   = Tuple "#/"       emptyParams

  link About  = Tuple "#/about"  emptyParams

  link Me     = Tuple "#/me"     emptyParams

  link Errors = Tuple "#/errors" emptyParams

  link Portal = Tuple "#/portal" emptyParams

  link (Organizations Index params)                  = Tuple "#/organizations" (fixParams params)
  link (Organizations crud@(New) params)             = Tuple ("#/organizations" <> (fst $ link crud)) (fixParams params)
  link (Organizations crud@(Edit org_name) params)   = Tuple ("#/organizations" <> (fst $ link crud)) (fixParams params)
  link (Organizations crud@(Delete org_name) params) = Tuple ("#/organizations" <> (fst $ link crud)) (fixParams params)
  link (Organizations crud@(Show org_name) params)   = Tuple ("#" ++ (fst $ link crud)) (fixParams params)

  link (OrganizationsForums org Index params) =
    Tuple ("#/" <> org <> "/f") (fixParams params)
  link (OrganizationsForums org crud params) =
    Tuple ("#/" <> org <> "/f" <> (fst $ link crud)) (fixParams params)

  link (OrganizationsForumsBoards org forum crud params) =
    Tuple ("#/" <> org <> "/f/" <> forum <> (fst $ link crud)) (fixParams params)

  link (OrganizationsForumsBoardsThreads org forum board crud params) =
    Tuple ("#/" <> org <> "/f/" <> forum <> "/" <> board <> (fst $ link crud)) (fixParams params)

  link (OrganizationsForumsBoardsThreadsPosts org forum board thread crud params) =
    Tuple ("#/" <> org <> "/f/" <> forum <> "/" <> board <> "/" <> thread <> (fst $ link crud)) (fixParams params)

  link (OrganizationsTeams org crud params) =
    Tuple ("#/" <> org <> "/teams" <> (fst $ link crud)) (fixParams params)

  link (OrganizationsTeamsMembers org team crud params) =
    Tuple ("#/" <> org <> "/teams/" <> team <> (fst $ link crud)) (fixParams params)

  link (OrganizationsMembersOnly org) =
    Tuple ("#/" <> org <> "/_members_only") emptyParams

  link (OrganizationsMembership org crud params) =
    Tuple ("#/" <> org <> "/membership" <> (fst $ link crud)) (fixParams params)

  link (Users Index params)           = Tuple "#/u" (fixParams params)
  link (Users crud params)            = Tuple ("#/u" ++ (fst $ link crud)) (fixParams params)
  link (UsersProfile user params)     = Tuple ("#/u/" <> user <> "/profile") (fixParams params)
  link (UsersSettings user params)    = Tuple ("#/u/" <> user <> "/settings") (fixParams params)
  link (UsersPMs user params)         = Tuple ("#/u/" <> user <> "/pms") (fixParams params)
  link (UsersThreads user params)     = Tuple ("#/u/" <> user <> "/threads") (fixParams params)
  link (UsersThreadPosts user params) = Tuple ("#/u/" <> user <> "/thread_posts") (fixParams params)
  link (UsersWorkouts user params)    = Tuple ("#/u/" <> user <> "/workouts") (fixParams params)
  link (UsersResources user params)   = Tuple ("#/u/" <> user <> "/resources") (fixParams params)
  link (UsersLeurons user params)     = Tuple ("#/u/" <> user <> "/leurons") (fixParams params)
  link (UsersLikes user params)       = Tuple ("#/u/" <> user <> "/likes") (fixParams params)

  link (Resources crud params)                              = Tuple ("#/resources" ++ (fst $ link crud)) (fixParams params)

  link (ResourcesLeurons resource_id crud params)           = Tuple ("#/resources/" <> show resource_id <> "/leurons" <> (fst $ link crud)) (fixParams params)
  link (ResourcesSiftLeurons resource_id params) = Tuple ("#/resources/" <> show resource_id <> "/sift") (fixParams params)
  link (ResourcesSiftLeuronsLinear resource_id crud params) = Tuple ("#/resources/" <> show resource_id <> "/sift/linear" <> (fst $ link crud)) (fixParams params)
  link (ResourcesSiftLeuronsRandom resource_id params)      = Tuple ("#/resources/" <> show resource_id <> "/sift/random") (fixParams params)

--  link (Leurons crud params) = Tuple ("#/leurons" ++ (fst $ link crud)) (fixParams params)

  link Login    = Tuple "/auth/login" emptyParams
  link Logout   = Tuple "/auth/logout" emptyParams

  link NotFound = Tuple "#/404" emptyParams




instance routesHasCrumb :: HasCrumb Routes where

  crumb route st =

    case route of



      Home   -> [Tuple Home "Home"]



      About  -> [Tuple About "About"]



      Me     -> [Tuple Me "Me"]



      Errors -> [Tuple Errors "Errors"]



      Portal -> [Tuple Portal "Portal"]



      Organizations Index params ->
        [
          Tuple (Organizations Index params) "Organizations"
        ]

      Organizations New params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations"
        ]

      Organizations (Edit org_name) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org_name) emptyParams) org_name
        ]

      Organizations (Delete org_name) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org_name) emptyParams) org_name
        ]

      Organizations (Show org) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) params) org
        ]



      OrganizationsForums org Index params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org
        ]

      OrganizationsForums org New params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org
        ]

      OrganizationsForums org (Edit forum) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum
        ]

      OrganizationsForums org (Delete forum) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum
        ]

      OrganizationsForums org (Show forum) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) params) forum
        ]



      OrganizationsForumsBoards org forum Index params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum
        ]

      OrganizationsForumsBoards org forum New params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum
        ]

      OrganizationsForumsBoards org forum (Edit board) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum,
          Tuple (OrganizationsForumsBoards org forum (Show board) emptyParams) board
        ]

      OrganizationsForumsBoards org forum (Delete board) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum,
          Tuple (OrganizationsForumsBoards org forum (Show board) emptyParams) board
        ]

      OrganizationsForumsBoards org forum (Show board) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum,
          Tuple (OrganizationsForumsBoards org forum (Show board) params) board
        ]



      OrganizationsForumsBoardsThreads org forum board Index params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum,
          Tuple (OrganizationsForumsBoards org forum (Show board) emptyParams) board
        ]

      OrganizationsForumsBoardsThreads org forum board New params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum,
          Tuple (OrganizationsForumsBoards org forum (Show board) emptyParams) board
        ]

      OrganizationsForumsBoardsThreads org forum board (Edit thread) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum,
          Tuple (OrganizationsForumsBoards org forum (Show board) emptyParams) board,
          Tuple (OrganizationsForumsBoardsThreads org forum board (Show thread) emptyParams) thread
        ]

      OrganizationsForumsBoardsThreads org forum board (Delete thread) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum,
          Tuple (OrganizationsForumsBoards org forum (Show board) emptyParams) board,
          Tuple (OrganizationsForumsBoardsThreads org forum board (Show thread) emptyParams) thread
        ]

      OrganizationsForumsBoardsThreads org forum board (Show thread) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum,
          Tuple (OrganizationsForumsBoards org forum (Show board) emptyParams) board,
          Tuple (OrganizationsForumsBoardsThreads org forum board (Show thread) params) thread
        ]



      OrganizationsForumsBoardsThreadsPosts org forum board thread Index params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum,
          Tuple (OrganizationsForumsBoards org forum (Show board) emptyParams) board,
          Tuple (OrganizationsForumsBoardsThreads org forum board (Show thread) emptyParams) thread
        ]

      OrganizationsForumsBoardsThreadsPosts org forum board thread New params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum,
          Tuple (OrganizationsForumsBoards org forum (Show board) emptyParams) board,
          Tuple (OrganizationsForumsBoardsThreads org forum board (Show thread) emptyParams) thread
        ]

      OrganizationsForumsBoardsThreadsPosts org forum board thread (EditI post) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum,
          Tuple (OrganizationsForumsBoards org forum (Show board) emptyParams) board,
          Tuple (OrganizationsForumsBoardsThreads org forum board (Show thread) emptyParams) thread,
          Tuple (OrganizationsForumsBoardsThreadsPosts org forum board thread (ShowI post) emptyParams) (show post)
        ]

      OrganizationsForumsBoardsThreadsPosts org forum board thread (DeleteI post) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum,
          Tuple (OrganizationsForumsBoards org forum (Show board) emptyParams) board,
          Tuple (OrganizationsForumsBoardsThreads org forum board (Show thread) emptyParams) thread,
          Tuple (OrganizationsForumsBoardsThreadsPosts org forum board thread (ShowI post) emptyParams) (show post)
        ]

      OrganizationsForumsBoardsThreadsPosts org forum board thread (ShowI post) params ->
        [
          Tuple (Organizations Index emptyParams) "Organizations",
          Tuple (Organizations (Show org) emptyParams) org,
          Tuple (OrganizationsForums org (Show forum) emptyParams) forum,
          Tuple (OrganizationsForumsBoards org forum (Show board) emptyParams) board,
          Tuple (OrganizationsForumsBoardsThreads org forum board (Show thread) emptyParams) thread,
          Tuple (OrganizationsForumsBoardsThreadsPosts org forum board thread (ShowI post) params) (show post)
        ]



      Users Index params ->
        [
          Tuple (Users Index params) "Users"
        ]

      Users (Show user) params ->
        [
          Tuple (Users Index emptyParams) "Users",
          Tuple (Users (Show user) params) user
        ]



      UsersProfile user params ->
        [
          Tuple (Users Index emptyParams) "Users",
          Tuple (Users (Show user) emptyParams) user,
          Tuple (UsersProfile (slash user) params) "Profile"
        ]

      UsersSettings user params ->
        [
          Tuple (Users Index emptyParams) "Users",
          Tuple (Users (Show user) emptyParams) user,
          Tuple (UsersSettings (slash user) params) "Settings"
        ]

      UsersPMs user params ->
        [
          Tuple (Users Index emptyParams) "Users",
          Tuple (Users (Show user) emptyParams) user,
          Tuple (UsersPMs (slash user) params) "PMs"
        ]

      UsersThreads user params ->
        [
          Tuple (Users Index emptyParams) "Users",
          Tuple (Users (Show user) emptyParams) user,
          Tuple (UsersThreads (slash user) params) "Threads"
        ]

      UsersThreadPosts user params ->
        [
          Tuple (Users Index emptyParams) "Users",
          Tuple (Users (Show user) emptyParams) user,
          Tuple (UsersThreadPosts (slash user) params) "ThreadPosts"
        ]

      UsersWorkouts user params ->
        [
          Tuple (Users Index emptyParams) "Users",
          Tuple (Users (Show user) emptyParams) user,
          Tuple (UsersWorkouts (slash user) params) "Workouts"
        ]

      UsersResources user params ->
        [
          Tuple (Users Index emptyParams) "Users",
          Tuple (Users (Show user) emptyParams) user,
          Tuple (UsersResources (slash user) params) "Resources"
        ]

      UsersLeurons user params ->
        [
          Tuple (Users Index emptyParams) "Users",
          Tuple (Users (Show user) emptyParams) user,
          Tuple (UsersLeurons (slash user) params) "Leurons"
        ]

      UsersLikes user params ->
        [
          Tuple (Users Index emptyParams) "Users",
          Tuple (Users (Show user) emptyParams) user,
          Tuple (UsersLikes (slash user) params) "Likes"
        ]



      Resources Index params ->
        [Tuple (Resources Index params) "Resources"]

      Resources New params ->
        [Tuple (Resources Index params) "Resources"]

      Resources (EditI resource_id) params ->
        [
          Tuple (Resources Index emptyParams) "Resources",
          resource_pretty resource_id params
        ]

      Resources (DeleteI resource_id) params ->
        [
          Tuple (Resources Index emptyParams) "Resources",
          resource_pretty resource_id params
        ]

      Resources (ShowI resource_id) params ->
        [
          Tuple (Resources Index emptyParams) "Resources",
          resource_pretty resource_id params
        ]



      ResourcesLeurons resource_id Index params ->
        [
          Tuple (Resources Index emptyParams) "Resources",
          resource_pretty resource_id emptyParams,
          Tuple (ResourcesLeurons resource_id Index params) "Leurons"
        ]

      ResourcesLeurons resource_id New params ->
        [
          Tuple (Resources Index emptyParams) "Resources",
          resource_pretty resource_id emptyParams,
          Tuple (ResourcesLeurons resource_id Index params) "Leurons"
        ]

      ResourcesLeurons resource_id (EditI leuron_id) params ->
        [
          Tuple (Resources Index emptyParams) "Resources",
          resource_pretty resource_id emptyParams,
          Tuple (ResourcesLeurons resource_id Index emptyParams) "Leurons",
          Tuple (ResourcesLeurons resource_id (ShowI leuron_id) emptyParams) (show leuron_id)
        ]

      ResourcesLeurons resource_id (DeleteI leuron_id) params ->
        [
          Tuple (Resources Index emptyParams) "Resources",
          resource_pretty resource_id emptyParams,
          Tuple (ResourcesLeurons resource_id Index emptyParams) "Leurons",
          Tuple (ResourcesLeurons resource_id (ShowI leuron_id) emptyParams) (show leuron_id)
        ]

      ResourcesLeurons resource_id (ShowI leuron_id) params ->
        [
          Tuple (Resources Index emptyParams) "Resources",
          resource_pretty resource_id emptyParams,
          Tuple (ResourcesLeurons resource_id Index emptyParams) "Leurons",
          Tuple (ResourcesLeurons resource_id (ShowI leuron_id) params) (show leuron_id)
        ]



      ResourcesSiftLeurons resource_id params ->
        [
          Tuple (Resources Index emptyParams) "Resources",
          resource_pretty resource_id emptyParams,
          Tuple (ResourcesSiftLeurons resource_id params) "Sift"
        ]

      ResourcesSiftLeuronsRandom resource_id params ->
        [
          Tuple (Resources Index emptyParams) "Resources",
          resource_pretty resource_id emptyParams,
          Tuple (ResourcesSiftLeurons resource_id params) "Sift"
        ]

      ResourcesSiftLeuronsLinear resource_id _ params ->
        [
          Tuple (Resources Index emptyParams) "Resources",
          resource_pretty resource_id emptyParams,
          Tuple (ResourcesSiftLeurons resource_id emptyParams) "Sift",
          Tuple (ResourcesSiftLeuronsLinear resource_id Index params) "Linear"
        ]


      _ -> [Tuple NotFound "Error"]

    where
    resource_pretty resource_id params =
      Tuple (Resources (ShowI resource_id) params)
        $ maybe (show resource_id) (\pack -> pack ^. _ResourcePackResponse .. resource_ ^. _ResourceResponse .. displayName_) st.currentResource




instance routesHasOrderBy :: HasOrderBy Routes where
  orderBy (OrganizationsForumsBoards org forum (Show board) params) = [OrderBy_CreatedAt, OrderBy_ActivityAt]
  orderBy _                   = []



instance routesShow :: Show Routes where
  show Home   = "Home"
  show About  = "About"
  show Me     = "Me"
  show Errors = "Errors"
  show Portal = "Portal"
  show (Organizations crud params) =
    "Organizations " <> show crud
  show (OrganizationsForums org crud params) =
    "OrganizationsForums " <> org <> sp <> show crud
  show (OrganizationsForumsBoards org forum crud params) =
    "OrganizationsForumsBoards " <> org <> sp <> forum <> sp <> show crud
  show (OrganizationsForumsBoardsThreads org forum board crud params) =
    "OrganizationsForumsBoardsThreads " <> org <> sp <> forum <> sp <> board <> sp <> show crud
  show (OrganizationsForumsBoardsThreadsPosts org forum board thread crud params) =
    "OrganizationsForumsBoardsThreads " <> org <> sp <> forum <> sp <> board <> sp <> thread <> sp <> show crud
  show (OrganizationsTeams org crud params) =
    "OrganizationsTeams " <> org <> sp <> show crud
  show (OrganizationsTeamsMembers org team crud params) =
    "OrganizationsTeamsMembers " <> org <> sp <> team <> sp <> show crud
  show (OrganizationsMembersOnly org) =
    "OrganizationsMembersOnly " <> org
  show (OrganizationsMembership org crud params) =
    "OrganizationsMembership " <> org <> sp <> show crud
  show (Users crud params)            = "Users " <> show crud
  show (UsersProfile user params)     = "UsersProfile " <> user
  show (UsersSettings user params)    = "UsersSettings " <> user
  show (UsersPMs user params)         = "UsersPMs " <> user
  show (UsersThreads user params)     = "UsersThreads " <> user
  show (UsersThreadPosts user params) = "UsersThreadPosts " <> user
  show (UsersWorkouts user params)    = "UsersWorkouts " <> user
  show (UsersResources user params)   = "UsersResources " <> user
  show (UsersLeurons user params)     = "UsersLeurons " <> user
  show (UsersLikes user params)       = "UsersLikes " <> user
  show (Resources crud params)        = "Resources " <> show crud
  show (ResourcesLeurons resource_id crud params)           = "ResourcesLeurons " <> show resource_id <> sp <> show crud
  show (ResourcesSiftLeurons resource_id params)            = "ResourcesSiftLeurons " <> show resource_id
  show (ResourcesSiftLeuronsLinear resource_id crud params) = "ResourcesSiftLeuronsLinear " <> show resource_id <> sp <> show crud
  show (ResourcesSiftLeuronsRandom resource_id params)      = "ResourcesSiftLeuronsRandom " <> show resource_id
  show Login    = "Login"
  show Logout   = "Logout"
  show NotFound = "NotFound"
  show _ = "make sure Show covers all Routes"



sp :: String
sp = " "
