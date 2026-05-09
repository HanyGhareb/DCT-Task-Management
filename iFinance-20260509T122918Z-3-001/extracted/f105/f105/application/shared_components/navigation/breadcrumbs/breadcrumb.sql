prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(99703488427410717)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(105314719097748264)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Manage Projects Access'
,p_link=>'f?p=&APP_ID.:26:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>26
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(105313480901748266)
,p_parent_id=>wwv_flow_api.id(105314719097748264)
,p_short_name=>'Project Access Details'
,p_link=>'f?p=&APP_ID.:27:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>27
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(104971542674139199)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Tasks Approvers'
,p_link=>'f?p=&APP_ID.:28:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>28
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(104970372575139204)
,p_parent_id=>wwv_flow_api.id(104971542674139199)
,p_short_name=>'Task Approvers Details'
,p_link=>'f?p=&APP_ID.:29:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>29
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(104398981567195026)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Delegation Management'
,p_link=>'f?p=&APP_ID.:30:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>30
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(100748134337135491)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Projects Approvers'
,p_link=>'f?p=&APP_ID.:32:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>32
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(99869471186894355)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Budget Transfer Request By Lines'
,p_link=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.:::'
,p_page_id=>34
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(99687988623371645)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'BTF Requests Drill-down'
,p_link=>'f?p=&APP_ID.:35:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>35
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(98858458719953337)
,p_short_name=>'End User - Access Request Approve / Reject'
,p_link=>'f?p=&APP_ID.:36:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>36
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(95371128261252358)
,p_parent_id=>wwv_flow_api.id(1184636481265145)
,p_short_name=>'Projects Data Load'
,p_link=>'f?p=&APP_ID.:37:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>37
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(95337950297259796)
,p_parent_id=>wwv_flow_api.id(95371128261252358)
,p_short_name=>'Mapping'
,p_link=>'f?p=&APP_ID.:38:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>38
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(95312234372265631)
,p_parent_id=>wwv_flow_api.id(95337950297259796)
,p_short_name=>'Data Validation'
,p_link=>'f?p=&APP_ID.:39:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>39
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(95265175013272856)
,p_parent_id=>wwv_flow_api.id(95312234372265631)
,p_short_name=>'Data Load Result'
,p_link=>'f?p=&APP_ID.:40:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>40
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(95250644520426826)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Projects Balances'
,p_link=>'f?p=&APP_ID.:41:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>41
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(88296927473047869)
,p_short_name=>'Initiatives With Projects '
,p_link=>'f?p=&APP_ID.:45:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>45
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(82746257375219926)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'BTF Setting'
,p_link=>'f?p=&APP_ID.:51:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>51
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(82745079812219927)
,p_parent_id=>wwv_flow_api.id(82746257375219926)
,p_short_name=>'BTF Setting details'
,p_link=>'f?p=&APP_ID.:52:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>52
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(81293828635746171)
,p_short_name=>'Add Tasks from previous years'
,p_link=>'f?p=&APP_ID.:46:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>46
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(71094647550163599)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Budget Allocation Roles'
,p_link=>'f?p=&APP_ID.:54:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>54
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(71093448436163601)
,p_parent_id=>wwv_flow_api.id(71094647550163599)
,p_short_name=>'Budget Allocation Role Details'
,p_link=>'f?p=&APP_ID.:55:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>55
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(71069832274421847)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'GL Chart of Accounts'
,p_link=>'f?p=&APP_ID.:56:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>56
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(70936803927791707)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Budget Allocation Plans'
,p_link=>'f?p=&APP_ID.:58:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>58
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(70935601798791708)
,p_parent_id=>wwv_flow_api.id(70936803927791707)
,p_short_name=>'Budget Allocation Plan Details'
,p_link=>'f?p=&APP_ID.:59:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>59
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(70903437635432127)
,p_short_name=>'Submit Budget Allocation Plans to Sectors'
,p_link=>'f?p=&APP_ID.:60:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>60
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(64834516538013119)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Sector Planners'
,p_link=>'f?p=&APP_ID.:63:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>63
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(64755207498493658)
,p_parent_id=>wwv_flow_api.id(64834516538013119)
,p_short_name=>'&P64_SECTOR. Sector Budget Allocation Plan Details'
,p_link=>'f?p=&APP_ID.:64:&SESSION.::&DEBUG.:::'
,p_page_id=>64
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(64666126095592901)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Cost Centers Planners'
,p_link=>'f?p=&APP_ID.:66:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>66
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(64632523559536704)
,p_parent_id=>wwv_flow_api.id(64666126095592901)
,p_short_name=>'Cost Center Budget Allocation Plan Details (&P67_COST_CENTER.)'
,p_link=>'f?p=&APP_ID.:67:&SESSION.::&DEBUG.:::'
,p_page_id=>67
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(64422755094911848)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'&CURRENT_YEAR. Projects Cashflow'
,p_link=>'f?p=&APP_ID.:68:&SESSION.::&DEBUG.:::'
,p_page_id=>68
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(64396581003815833)
,p_parent_id=>wwv_flow_api.id(64422755094911848)
,p_short_name=>'Project Cashflow Details'
,p_link=>'f?p=&APP_ID.:69:&SESSION.::&DEBUG.:::'
,p_page_id=>69
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(63628345391251628)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Projects Planners'
,p_link=>'f?p=&APP_ID.:73:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>73
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(63579081204149311)
,p_parent_id=>wwv_flow_api.id(63628345391251628)
,p_short_name=>'Project Budget Allocation Plan Details (&P74_PROJECT.)'
,p_link=>'f?p=&APP_ID.:74:&SESSION.::&DEBUG.:::'
,p_page_id=>74
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(63369166300055677)
,p_parent_id=>wwv_flow_api.id(71094647550163599)
,p_short_name=>'Sectors Planners'
,p_link=>'f?p=&APP_ID.:75:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>75
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(63367987071055675)
,p_parent_id=>wwv_flow_api.id(63369166300055677)
,p_short_name=>'Sector Planner Details'
,p_link=>'f?p=&APP_ID.:76:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>76
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(63342669158501916)
,p_parent_id=>wwv_flow_api.id(71094647550163599)
,p_short_name=>'Cost Centers Planners'
,p_link=>'f?p=&APP_ID.:77:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>77
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(63318381004493119)
,p_parent_id=>wwv_flow_api.id(71094647550163599)
,p_short_name=>'Projects Planners'
,p_link=>'f?p=&APP_ID.:79:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>79
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(63171334279379364)
,p_parent_id=>wwv_flow_api.id(64632523559536704)
,p_short_name=>'Projects Budget Allocation: &P81_PROJECT_NUMBER. (&P81_PROJECT_NAME.)'
,p_link=>'f?p=&APP_ID.:81:&SESSION.::&DEBUG.:::'
,p_page_id=>81
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(61612958282335897)
,p_parent_id=>wwv_flow_api.id(70935601798791708)
,p_short_name=>'Budget Allocation Plan Scope'
,p_link=>'f?p=&APP_ID.:83:&SESSION.::&DEBUG.:::'
,p_page_id=>83
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(58459121978454771)
,p_short_name=>'DP Item Details'
,p_link=>'f?p=&APP_ID.:90:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>90
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(54339856814888305)
,p_parent_id=>wwv_flow_api.id(54293183706658904)
,p_short_name=>'Budget Proposal Plan Details'
,p_link=>'f?p=&APP_ID.:85:&SESSION.::&DEBUG.:::'
,p_page_id=>85
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(54293183706658904)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Budget Proposal Plans'
,p_link=>'f?p=&APP_ID.:84:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>84
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(51818470560925794)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'GL Cashflow'
,p_link=>'f?p=&APP_ID.:86:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>86
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(51647077002727584)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Chart of Accounts'
,p_link=>'f?p=&APP_ID.:87:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>87
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(50593548011653286)
,p_short_name=>'Budget Proposal Plan Scope'
,p_link=>'f?p=&APP_ID.:93:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>93
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(49958492369921151)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Programs'
,p_link=>'f?p=&APP_ID.:91:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>91
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(49957318229921151)
,p_parent_id=>wwv_flow_api.id(54339856814888305)
,p_short_name=>'Sector Plan Details'
,p_link=>'f?p=&APP_ID.:92:&SESSION.::&DEBUG.:::'
,p_page_id=>92
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(49948676545882540)
,p_parent_id=>wwv_flow_api.id(49958492369921151)
,p_short_name=>'Program Details'
,p_link=>'f?p=&APP_ID.:89:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>89
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(49721432151526589)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Sector Planner'
,p_link=>'f?p=&APP_ID.:95:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>95
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(49705866703512178)
,p_parent_id=>0
,p_short_name=>'Budget Proposal \ Cost Center (Department) Plans'
,p_link=>'f?p=&APP_ID.:96:&SESSION.::&DEBUG.:::'
,p_page_id=>96
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(49346961718265038)
,p_parent_id=>wwv_flow_api.id(49705866703512178)
,p_short_name=>'Department Plan Details &P97_COST_CENTER.'
,p_link=>'f?p=&APP_ID.:97:&SESSION.::&DEBUG.:::'
,p_page_id=>97
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(49345768423265037)
,p_parent_id=>wwv_flow_api.id(49346961718265038)
,p_short_name=>'Budget Proposal - Project'
,p_link=>'f?p=&APP_ID.:98:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>98
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(48500248055360681)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Strategy Planning Approvers'
,p_link=>'f?p=&APP_ID.:94:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>94
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(48489003251287983)
,p_parent_id=>wwv_flow_api.id(49346961718265038)
,p_short_name=>'Projects Planner Update'
,p_link=>'f?p=&APP_ID.:101:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>101
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(47032599385334443)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Budget Proposal Cost Center Approve&#x2F;Reject'
,p_link=>'f?p=&APP_ID.:110:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>110
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(38455368986166144)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Budget Proposal Line Details'
,p_link=>'f?p=&APP_ID.:121:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>121
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(38386116449743506)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Budget Proposal Plan By Cost Center'
,p_link=>'f?p=&APP_ID.:122:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>122
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(37679663217248285)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Budget Proposal Plan Documents '
,p_link=>'f?p=&APP_ID.:117:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>117
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(30955087578820694)
,p_parent_id=>wwv_flow_api.id(49346961718265038)
,p_short_name=>'Projects Budget Revise'
,p_link=>'f?p=&APP_ID.:118:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>118
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(15937677697522513)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Manage Cost Centers'
,p_link=>'f?p=&APP_ID.:119:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>119
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(15936460402522511)
,p_parent_id=>wwv_flow_api.id(15937677697522513)
,p_short_name=>'Cost Center Details'
,p_link=>'f?p=&APP_ID.:120:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>120
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(47167291784519)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Project access Requests'
,p_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(74350912792802)
,p_parent_id=>wwv_flow_api.id(47167291784519)
,p_short_name=>'Request Details'
,p_link=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(121464212245614)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Approve / Reject'
,p_link=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(154122897667685)
,p_parent_id=>wwv_flow_api.id(121464212245614)
,p_short_name=>'Delegate'
,p_link=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(205980757680115)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Budget Transfer requests'
,p_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(242978828418406)
,p_parent_id=>wwv_flow_api.id(47167291784519)
,p_short_name=>'BTF End User Details'
,p_link=>'f?p=&APP_ID.:8:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(292146005940410)
,p_parent_id=>wwv_flow_api.id(242978828418406)
,p_short_name=>'BTF End User Line'
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(419366236801822)
,p_parent_id=>wwv_flow_api.id(242978828418406)
,p_short_name=>'BTF End User Documents'
,p_link=>'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(642429333759010)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'BTF End User Transfer Approve&#x2F;Reject'
,p_link=>'f?p=&APP_ID.:12:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>12
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(771917075088066)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Initiatives List &CURRENT_YEAR.'
,p_link=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:::'
,p_page_id=>14
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(773102018088068)
,p_parent_id=>wwv_flow_api.id(771917075088066)
,p_short_name=>'Initiative Details'
,p_link=>'f?p=&APP_ID.:15:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>15
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(816254290211910)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Objectives'
,p_link=>'f?p=&APP_ID.:16:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>16
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(817467643211911)
,p_parent_id=>wwv_flow_api.id(816254290211910)
,p_short_name=>'Objective Details'
,p_link=>'f?p=&APP_ID.:17:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>17
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(897668704991214)
,p_parent_id=>wwv_flow_api.id(773102018088068)
,p_short_name=>'Project/Task Initiative Assignment'
,p_link=>'f?p=&APP_ID.:18:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>18
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1184636481265145)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Projects'
,p_link=>'f?p=&APP_ID.:19:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>19
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1214406519294940)
,p_parent_id=>wwv_flow_api.id(1184636481265145)
,p_short_name=>'Update Projects'
,p_link=>'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>20
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(1276634661315478)
,p_parent_id=>wwv_flow_api.id(1184636481265145)
,p_short_name=>'Project Details'
,p_link=>'f?p=&APP_ID.:21:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2005532152432997)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Cost Centers By FBP'
,p_link=>'f?p=&APP_ID.:22:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>22
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2016257604424364)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Cost Centers Directors'
,p_link=>'f?p=&APP_ID.:23:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>23
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(2028613817418791)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Cost Centers Exec Directors'
,p_link=>'f?p=&APP_ID.:24:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>24
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10217072655683168)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Manage Ceiling'
,p_link=>'f?p=&APP_ID.:123:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>123
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10218303622683173)
,p_parent_id=>wwv_flow_api.id(10217072655683168)
,p_short_name=>'Cost Center Ceiling Details'
,p_link=>'f?p=&APP_ID.:124:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>124
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10293318929719821)
,p_parent_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Manage Cost Centers Ceiling'
,p_link=>'f?p=&APP_ID.:125:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>125
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10294548703719822)
,p_parent_id=>wwv_flow_api.id(10293318929719821)
,p_short_name=>'Cost Center Ceiling Details'
,p_link=>'f?p=&APP_ID.:126:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>126
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10369123075613936)
,p_parent_id=>wwv_flow_api.id(10293318929719821)
,p_short_name=>'Budget Allocation - Cost Center Projects'
,p_link=>'f?p=&APP_ID.:127:&SESSION.::&DEBUG.:::'
,p_page_id=>127
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(10370355450613937)
,p_parent_id=>wwv_flow_api.id(10369123075613936)
,p_short_name=>'Budget Allocation - Project Details'
,p_link=>'f?p=&APP_ID.:128:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>128
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(16780715719233343)
,p_short_name=>'Cashflow All'
,p_link=>'f?p=&APP_ID.:138:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>138
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(99703628875410717)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(99997737932411051)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_api.component_end;
end;
/
