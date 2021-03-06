module LN.Input.Types (
  Input (..),
  -- helpers
  cOrganization,
  cOrganizationMod,
  cOrganizationAct,
  cTeam,
  cTeamMod,
  cTeamAct,
  cTeamMember,
  cTeamMemberMod,
  cTeamMemberAct,
  cMembership,
  cMembershipMod,
  cMembershipAct,
  cForum,
  cForumMod,
  cForumAct,
  cBoard,
  cBoardMod,
  cBoardAct,
  cThread,
  cThreadMod,
  cThreadAct,
  cThreadPost,
  cThreadPostMod,
  cThreadPostAct,
  cResource,
  cResourceMod,
  cLeuron,
  cLeuronMod,
  cPm,
  cPmMod,
  cPmAct,
  cPmIn,
  cPmInMod,
  cPmInAct,
  cPmOut,
  cPmOutMod,
  cPmOutAct,
  cArrayString
) where



import Data.Foreign            (ForeignError)
import Purescript.Api.Helpers  (ApiError)

import LN.Input.ArrayString    (InputArrayString(..))
import LN.Input.Board          (InputBoard(..), Board_Act, Board_Mod)
import LN.Input.Forum          (InputForum(..), Forum_Act, Forum_Mod)
import LN.Input.Leuron         (InputLeuron(..), Leuron_Mod)
import LN.Input.Like           (InputLike)
import LN.Input.Star           (InputStar)
import LN.Input.Membership     (InputMembership(..), Membership_Act, Membership_Mod)
import LN.Input.OrderBy        (InputOrderBy)
import LN.Input.Organization   (InputOrganization(..), Organization_Act, Organization_Mod)
import LN.Input.Profile        (InputProfile)
import LN.Input.Resource       (InputResource(..), Resource_Mod)
import LN.Input.Team           (InputTeam(..), Team_Act, Team_Mod)
import LN.Input.TeamMember     (InputTeamMember(..), TeamMember_Act, TeamMember_Mod)
import LN.Input.Thread         (InputThread(..), Thread_Act, Thread_Mod)
import LN.Input.ThreadPost     (InputThreadPost(..), ThreadPost_Act, ThreadPost_Mod)
import LN.Input.Pm             (InputPm(..), Pm_Act, Pm_Mod)
import LN.Input.PmIn           (InputPmIn(..), PmIn_Act, PmIn_Mod)
import LN.Input.PmOut          (InputPmOut(..), PmOut_Act, PmOut_Mod)
import LN.Router.Class.Routes  (Routes)
import LN.T



data Input a
  = Goto Routes a

  | AddError String String a
  | AddErrorF String ForeignError a
  | AddErrorApi String ApiError a
  | DelError Int a
  | ClearErrors a

  | GetUser String a
  | GetMe a
  | GetUsers a
  | GetUsers_MergeMap_ByUser (Array UserSanitizedResponse) a
  | GetUsers_MergeMap_ByUserId (Array Int) a

  | GetThreadPostLikes a

  | GetResources a
  | GetResourceId Int a

  | GetResourcesLeurons Int a
  | GetResourceLeuronLinear Int Int a
  | GetResourceLeuronRandom Int a

  | GetResourcesSiftLeurons Int a

  | GetLeurons a
  | GetLeuronId Int a
  | GetLeuronRandom a

  | ConnectSocket a

  | CompArrayString    InputArrayString  a
  | CompOrderBy        InputOrderBy      a
  | CompOrganization   InputOrganization a
  | CompTeam           InputTeam         a
  | CompTeamMember     InputTeamMember   a
  | CompMembership     InputMembership   a
  | CompForum          InputForum        a
  | CompBoard          InputBoard        a
  | CompThread         InputThread       a
  | CompThreadPost     InputThreadPost   a
  | CompProfile        InputProfile      a
  | CompLike           InputLike         a
  | CompStar           InputStar         a
  | CompResource       InputResource     a
  | CompLeuron         InputLeuron       a
  | CompPm             InputPm           a
  | CompPmIn           InputPmIn         a
  | CompPmOut          InputPmOut        a

  | Nop a



-- | Helpers for "components" and "subcomponents"
--

cOrganization :: forall a. InputOrganization -> a -> Input a
cOrganization sub next = CompOrganization sub next

cOrganizationMod :: forall a. Organization_Mod -> a -> Input a
cOrganizationMod mod next = CompOrganization (InputOrganization_Mod mod) next

cOrganizationAct :: forall a. Organization_Act -> a -> Input a
cOrganizationAct act next = CompOrganization (InputOrganization_Act act) next



cTeam :: forall a. InputTeam -> a -> Input a
cTeam sub next = CompTeam sub next

cTeamMod :: forall a. Team_Mod -> a -> Input a
cTeamMod mod next = CompTeam (InputTeam_Mod mod) next

cTeamAct :: forall a. Team_Act -> a -> Input a
cTeamAct act next = CompTeam (InputTeam_Act act) next



cTeamMember :: forall a. InputTeamMember -> a -> Input a
cTeamMember sub next = CompTeamMember sub next

cTeamMemberMod :: forall a. TeamMember_Mod -> a -> Input a
cTeamMemberMod mod next = CompTeamMember (InputTeamMember_Mod mod) next

cTeamMemberAct :: forall a. TeamMember_Act -> a -> Input a
cTeamMemberAct act next = CompTeamMember (InputTeamMember_Act act) next



cMembership :: forall a. InputMembership -> a -> Input a
cMembership sub next = CompMembership sub next

cMembershipMod :: forall a. Membership_Mod -> a -> Input a
cMembershipMod mod next = CompMembership (InputMembership_Mod mod) next

cMembershipAct :: forall a. Membership_Act -> a -> Input a
cMembershipAct act next = CompMembership (InputMembership_Act act) next



cForum :: forall a. InputForum -> a -> Input a
cForum sub next = CompForum sub next

cForumMod :: forall a. Forum_Mod -> a -> Input a
cForumMod mod next = CompForum (InputForum_Mod mod) next

cForumAct :: forall a. Forum_Act -> a -> Input a
cForumAct act next = CompForum (InputForum_Act act) next



cBoard :: forall a. InputBoard -> a -> Input a
cBoard sub next = CompBoard sub next

cBoardMod :: forall a. Board_Mod -> a -> Input a
cBoardMod mod next = CompBoard (InputBoard_Mod mod) next

cBoardAct :: forall a. Board_Act -> a -> Input a
cBoardAct act next = CompBoard (InputBoard_Act act) next



cThread :: forall a. InputThread -> a -> Input a
cThread sub next = CompThread sub next

cThreadMod :: forall a. Thread_Mod -> a -> Input a
cThreadMod mod next = CompThread (InputThread_Mod mod) next

cThreadAct :: forall a. Thread_Act -> a -> Input a
cThreadAct act next = CompThread (InputThread_Act act) next



cThreadPost :: forall a. InputThreadPost -> a -> Input a
cThreadPost sub next = CompThreadPost sub next

cThreadPostMod :: forall a. ThreadPost_Mod -> a -> Input a
cThreadPostMod mod next = CompThreadPost (InputThreadPost_Mod mod) next

cThreadPostAct :: forall a. ThreadPost_Act -> a -> Input a
cThreadPostAct act next = CompThreadPost (InputThreadPost_Act act) next



cResource :: forall a. InputResource -> a -> Input a
cResource ir next = CompResource ir next

cResourceMod :: forall a. Resource_Mod -> a -> Input a
cResourceMod rm next = CompResource (InputResource_Mod rm) next



cLeuron :: forall a. InputLeuron -> a -> Input a
cLeuron sub next = CompLeuron sub next

cLeuronMod :: forall a. Leuron_Mod -> a -> Input a
cLeuronMod mod next = CompLeuron (InputLeuron_Mod mod) next



cPm :: forall a. InputPm -> a -> Input a
cPm sub next = CompPm sub next

cPmMod :: forall a. Pm_Mod -> a -> Input a
cPmMod mod next = CompPm (InputPm_Mod mod) next

cPmAct :: forall a. Pm_Act -> a -> Input a
cPmAct act next = CompPm (InputPm_Act act) next



cPmIn :: forall a. InputPmIn -> a -> Input a
cPmIn sub next = CompPmIn sub next

cPmInMod :: forall a. PmIn_Mod -> a -> Input a
cPmInMod mod next = CompPmIn (InputPmIn_Mod mod) next

cPmInAct :: forall a. PmIn_Act -> a -> Input a
cPmInAct act next = CompPmIn (InputPmIn_Act act) next



cPmOut :: forall a. InputPmOut -> a -> Input a
cPmOut sub next = CompPmOut sub next

cPmOutMod :: forall a. PmOut_Mod -> a -> Input a
cPmOutMod mod next = CompPmOut (InputPmOut_Mod mod) next

cPmOutAct :: forall a. PmOut_Act -> a -> Input a
cPmOutAct act next = CompPmOut (InputPmOut_Act act) next



cArrayString :: forall a. InputArrayString -> a -> Input a
cArrayString sub next = CompArrayString sub next
