prompt --application/shared_components/reports/report_layouts/budget_proposal_cost_centers_plan_list
begin
--   Manifest
--     REPORT LAYOUT: Budget Proposal Cost Centers Plan List
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
    wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
    wwv_flow_api.g_varchar2_table(1) := '{\rtf1\adeflang1025\ansi\ansicpg1252\uc1\adeff31507\deff0\stshfdbch31506\stshfloch31506\stshfhich315';
    wwv_flow_api.g_varchar2_table(2) := '06\stshfbi31507\deflang1033\deflangfe1033\themelang1033\themelangfe0\themelangcs1025{\fonttbl{\f0\fb';
    wwv_flow_api.g_varchar2_table(3) := 'idi \froman\fcharset0\fprq2{\*\panose 02020603050405020304}Times New Roman;}{\f1\fbidi \fswiss\fchar';
    wwv_flow_api.g_varchar2_table(4) := 'set0\fprq2{\*\panose 020b0604020202020204}Arial;}'||wwv_flow.LF||
'{\f34\fbidi \froman\fcharset0\fprq2{\*\panose 020';
    wwv_flow_api.g_varchar2_table(5) := '40503050406030204}Cambria Math;}{\f37\fbidi \fswiss\fcharset0\fprq2{\*\panose 020f0502020204030204}C';
    wwv_flow_api.g_varchar2_table(6) := 'alibri;}{\f38\fbidi \fswiss\fcharset0\fprq2{\*\panose 020f0302020204030204}Calibri Light;}'||wwv_flow.LF||
'{\flomaj';
    wwv_flow_api.g_varchar2_table(7) := 'or\f31500\fbidi \froman\fcharset0\fprq2{\*\panose 02020603050405020304}Times New Roman;}{\fdbmajor\f';
    wwv_flow_api.g_varchar2_table(8) := '31501\fbidi \froman\fcharset0\fprq2{\*\panose 02020603050405020304}Times New Roman;}'||wwv_flow.LF||
'{\fhimajor\f31';
    wwv_flow_api.g_varchar2_table(9) := '502\fbidi \fswiss\fcharset0\fprq2{\*\panose 020f0302020204030204}Calibri Light;}{\fbimajor\f31503\fb';
    wwv_flow_api.g_varchar2_table(10) := 'idi \froman\fcharset0\fprq2{\*\panose 02020603050405020304}Times New Roman;}'||wwv_flow.LF||
'{\flominor\f31504\fbid';
    wwv_flow_api.g_varchar2_table(11) := 'i \froman\fcharset0\fprq2{\*\panose 02020603050405020304}Times New Roman;}{\fdbminor\f31505\fbidi \f';
    wwv_flow_api.g_varchar2_table(12) := 'roman\fcharset0\fprq2{\*\panose 02020603050405020304}Times New Roman;}'||wwv_flow.LF||
'{\fhiminor\f31506\fbidi \fsw';
    wwv_flow_api.g_varchar2_table(13) := 'iss\fcharset0\fprq2{\*\panose 020f0502020204030204}Calibri;}{\fbiminor\f31507\fbidi \fswiss\fcharset';
    wwv_flow_api.g_varchar2_table(14) := '0\fprq2{\*\panose 020b0604020202020204}Arial;}{\f45\fbidi \froman\fcharset238\fprq2 Times New Roman ';
    wwv_flow_api.g_varchar2_table(15) := 'CE;}'||wwv_flow.LF||
'{\f46\fbidi \froman\fcharset204\fprq2 Times New Roman Cyr;}{\f48\fbidi \froman\fcharset161\fpr';
    wwv_flow_api.g_varchar2_table(16) := 'q2 Times New Roman Greek;}{\f49\fbidi \froman\fcharset162\fprq2 Times New Roman Tur;}{\f50\fbidi \fr';
    wwv_flow_api.g_varchar2_table(17) := 'oman\fcharset177\fprq2 Times New Roman (Hebrew);}'||wwv_flow.LF||
'{\f51\fbidi \froman\fcharset178\fprq2 Times New R';
    wwv_flow_api.g_varchar2_table(18) := 'oman (Arabic);}{\f52\fbidi \froman\fcharset186\fprq2 Times New Roman Baltic;}{\f53\fbidi \froman\fch';
    wwv_flow_api.g_varchar2_table(19) := 'arset163\fprq2 Times New Roman (Vietnamese);}{\f55\fbidi \fswiss\fcharset238\fprq2 Arial CE;}'||wwv_flow.LF||
'{\f56';
    wwv_flow_api.g_varchar2_table(20) := '\fbidi \fswiss\fcharset204\fprq2 Arial Cyr;}{\f58\fbidi \fswiss\fcharset161\fprq2 Arial Greek;}{\f59';
    wwv_flow_api.g_varchar2_table(21) := '\fbidi \fswiss\fcharset162\fprq2 Arial Tur;}{\f60\fbidi \fswiss\fcharset177\fprq2 Arial (Hebrew);}'||wwv_flow.LF||
'';
    wwv_flow_api.g_varchar2_table(22) := '{\f61\fbidi \fswiss\fcharset178\fprq2 Arial (Arabic);}{\f62\fbidi \fswiss\fcharset186\fprq2 Arial Ba';
    wwv_flow_api.g_varchar2_table(23) := 'ltic;}{\f63\fbidi \fswiss\fcharset163\fprq2 Arial (Vietnamese);}{\f415\fbidi \fswiss\fcharset238\fpr';
    wwv_flow_api.g_varchar2_table(24) := 'q2 Calibri CE;}'||wwv_flow.LF||
'{\f416\fbidi \fswiss\fcharset204\fprq2 Calibri Cyr;}{\f418\fbidi \fswiss\fcharset16';
    wwv_flow_api.g_varchar2_table(25) := '1\fprq2 Calibri Greek;}{\f419\fbidi \fswiss\fcharset162\fprq2 Calibri Tur;}{\f420\fbidi \fswiss\fcha';
    wwv_flow_api.g_varchar2_table(26) := 'rset177\fprq2 Calibri (Hebrew);}'||wwv_flow.LF||
'{\f421\fbidi \fswiss\fcharset178\fprq2 Calibri (Arabic);}{\f422\fb';
    wwv_flow_api.g_varchar2_table(27) := 'idi \fswiss\fcharset186\fprq2 Calibri Baltic;}{\f423\fbidi \fswiss\fcharset163\fprq2 Calibri (Vietna';
    wwv_flow_api.g_varchar2_table(28) := 'mese);}{\f425\fbidi \fswiss\fcharset238\fprq2 Calibri Light CE;}'||wwv_flow.LF||
'{\f426\fbidi \fswiss\fcharset204\f';
    wwv_flow_api.g_varchar2_table(29) := 'prq2 Calibri Light Cyr;}{\f428\fbidi \fswiss\fcharset161\fprq2 Calibri Light Greek;}{\f429\fbidi \fs';
    wwv_flow_api.g_varchar2_table(30) := 'wiss\fcharset162\fprq2 Calibri Light Tur;}{\f430\fbidi \fswiss\fcharset177\fprq2 Calibri Light (Hebr';
    wwv_flow_api.g_varchar2_table(31) := 'ew);}'||wwv_flow.LF||
'{\f431\fbidi \fswiss\fcharset178\fprq2 Calibri Light (Arabic);}{\f432\fbidi \fswiss\fcharset1';
    wwv_flow_api.g_varchar2_table(32) := '86\fprq2 Calibri Light Baltic;}{\f433\fbidi \fswiss\fcharset163\fprq2 Calibri Light (Vietnamese);}'||wwv_flow.LF||
'';
    wwv_flow_api.g_varchar2_table(33) := '{\flomajor\f31508\fbidi \froman\fcharset238\fprq2 Times New Roman CE;}{\flomajor\f31509\fbidi \froma';
    wwv_flow_api.g_varchar2_table(34) := 'n\fcharset204\fprq2 Times New Roman Cyr;}{\flomajor\f31511\fbidi \froman\fcharset161\fprq2 Times New';
    wwv_flow_api.g_varchar2_table(35) := ' Roman Greek;}'||wwv_flow.LF||
'{\flomajor\f31512\fbidi \froman\fcharset162\fprq2 Times New Roman Tur;}{\flomajor\f3';
    wwv_flow_api.g_varchar2_table(36) := '1513\fbidi \froman\fcharset177\fprq2 Times New Roman (Hebrew);}{\flomajor\f31514\fbidi \froman\fchar';
    wwv_flow_api.g_varchar2_table(37) := 'set178\fprq2 Times New Roman (Arabic);}'||wwv_flow.LF||
'{\flomajor\f31515\fbidi \froman\fcharset186\fprq2 Times New';
    wwv_flow_api.g_varchar2_table(38) := ' Roman Baltic;}{\flomajor\f31516\fbidi \froman\fcharset163\fprq2 Times New Roman (Vietnamese);}{\fdb';
    wwv_flow_api.g_varchar2_table(39) := 'major\f31518\fbidi \froman\fcharset238\fprq2 Times New Roman CE;}'||wwv_flow.LF||
'{\fdbmajor\f31519\fbidi \froman\f';
    wwv_flow_api.g_varchar2_table(40) := 'charset204\fprq2 Times New Roman Cyr;}{\fdbmajor\f31521\fbidi \froman\fcharset161\fprq2 Times New Ro';
    wwv_flow_api.g_varchar2_table(41) := 'man Greek;}{\fdbmajor\f31522\fbidi \froman\fcharset162\fprq2 Times New Roman Tur;}'||wwv_flow.LF||
'{\fdbmajor\f3152';
    wwv_flow_api.g_varchar2_table(42) := '3\fbidi \froman\fcharset177\fprq2 Times New Roman (Hebrew);}{\fdbmajor\f31524\fbidi \froman\fcharset';
    wwv_flow_api.g_varchar2_table(43) := '178\fprq2 Times New Roman (Arabic);}{\fdbmajor\f31525\fbidi \froman\fcharset186\fprq2 Times New Roma';
    wwv_flow_api.g_varchar2_table(44) := 'n Baltic;}'||wwv_flow.LF||
'{\fdbmajor\f31526\fbidi \froman\fcharset163\fprq2 Times New Roman (Vietnamese);}{\fhimaj';
    wwv_flow_api.g_varchar2_table(45) := 'or\f31528\fbidi \fswiss\fcharset238\fprq2 Calibri Light CE;}{\fhimajor\f31529\fbidi \fswiss\fcharset';
    wwv_flow_api.g_varchar2_table(46) := '204\fprq2 Calibri Light Cyr;}'||wwv_flow.LF||
'{\fhimajor\f31531\fbidi \fswiss\fcharset161\fprq2 Calibri Light Greek';
    wwv_flow_api.g_varchar2_table(47) := ';}{\fhimajor\f31532\fbidi \fswiss\fcharset162\fprq2 Calibri Light Tur;}{\fhimajor\f31533\fbidi \fswi';
    wwv_flow_api.g_varchar2_table(48) := 'ss\fcharset177\fprq2 Calibri Light (Hebrew);}'||wwv_flow.LF||
'{\fhimajor\f31534\fbidi \fswiss\fcharset178\fprq2 Cal';
    wwv_flow_api.g_varchar2_table(49) := 'ibri Light (Arabic);}{\fhimajor\f31535\fbidi \fswiss\fcharset186\fprq2 Calibri Light Baltic;}{\fhima';
    wwv_flow_api.g_varchar2_table(50) := 'jor\f31536\fbidi \fswiss\fcharset163\fprq2 Calibri Light (Vietnamese);}'||wwv_flow.LF||
'{\fbimajor\f31538\fbidi \fr';
    wwv_flow_api.g_varchar2_table(51) := 'oman\fcharset238\fprq2 Times New Roman CE;}{\fbimajor\f31539\fbidi \froman\fcharset204\fprq2 Times N';
    wwv_flow_api.g_varchar2_table(52) := 'ew Roman Cyr;}{\fbimajor\f31541\fbidi \froman\fcharset161\fprq2 Times New Roman Greek;}'||wwv_flow.LF||
'{\fbimajor\';
    wwv_flow_api.g_varchar2_table(53) := 'f31542\fbidi \froman\fcharset162\fprq2 Times New Roman Tur;}{\fbimajor\f31543\fbidi \froman\fcharset';
    wwv_flow_api.g_varchar2_table(54) := '177\fprq2 Times New Roman (Hebrew);}{\fbimajor\f31544\fbidi \froman\fcharset178\fprq2 Times New Roma';
    wwv_flow_api.g_varchar2_table(55) := 'n (Arabic);}'||wwv_flow.LF||
'{\fbimajor\f31545\fbidi \froman\fcharset186\fprq2 Times New Roman Baltic;}{\fbimajor\f';
    wwv_flow_api.g_varchar2_table(56) := '31546\fbidi \froman\fcharset163\fprq2 Times New Roman (Vietnamese);}{\flominor\f31548\fbidi \froman\';
    wwv_flow_api.g_varchar2_table(57) := 'fcharset238\fprq2 Times New Roman CE;}'||wwv_flow.LF||
'{\flominor\f31549\fbidi \froman\fcharset204\fprq2 Times New ';
    wwv_flow_api.g_varchar2_table(58) := 'Roman Cyr;}{\flominor\f31551\fbidi \froman\fcharset161\fprq2 Times New Roman Greek;}{\flominor\f3155';
    wwv_flow_api.g_varchar2_table(59) := '2\fbidi \froman\fcharset162\fprq2 Times New Roman Tur;}'||wwv_flow.LF||
'{\flominor\f31553\fbidi \froman\fcharset177';
    wwv_flow_api.g_varchar2_table(60) := '\fprq2 Times New Roman (Hebrew);}{\flominor\f31554\fbidi \froman\fcharset178\fprq2 Times New Roman (';
    wwv_flow_api.g_varchar2_table(61) := 'Arabic);}{\flominor\f31555\fbidi \froman\fcharset186\fprq2 Times New Roman Baltic;}'||wwv_flow.LF||
'{\flominor\f315';
    wwv_flow_api.g_varchar2_table(62) := '56\fbidi \froman\fcharset163\fprq2 Times New Roman (Vietnamese);}{\fdbminor\f31558\fbidi \froman\fch';
    wwv_flow_api.g_varchar2_table(63) := 'arset238\fprq2 Times New Roman CE;}{\fdbminor\f31559\fbidi \froman\fcharset204\fprq2 Times New Roman';
    wwv_flow_api.g_varchar2_table(64) := ' Cyr;}'||wwv_flow.LF||
'{\fdbminor\f31561\fbidi \froman\fcharset161\fprq2 Times New Roman Greek;}{\fdbminor\f31562\f';
    wwv_flow_api.g_varchar2_table(65) := 'bidi \froman\fcharset162\fprq2 Times New Roman Tur;}{\fdbminor\f31563\fbidi \froman\fcharset177\fprq';
    wwv_flow_api.g_varchar2_table(66) := '2 Times New Roman (Hebrew);}'||wwv_flow.LF||
'{\fdbminor\f31564\fbidi \froman\fcharset178\fprq2 Times New Roman (Ara';
    wwv_flow_api.g_varchar2_table(67) := 'bic);}{\fdbminor\f31565\fbidi \froman\fcharset186\fprq2 Times New Roman Baltic;}{\fdbminor\f31566\fb';
    wwv_flow_api.g_varchar2_table(68) := 'idi \froman\fcharset163\fprq2 Times New Roman (Vietnamese);}'||wwv_flow.LF||
'{\fhiminor\f31568\fbidi \fswiss\fchars';
    wwv_flow_api.g_varchar2_table(69) := 'et238\fprq2 Calibri CE;}{\fhiminor\f31569\fbidi \fswiss\fcharset204\fprq2 Calibri Cyr;}{\fhiminor\f3';
    wwv_flow_api.g_varchar2_table(70) := '1571\fbidi \fswiss\fcharset161\fprq2 Calibri Greek;}{\fhiminor\f31572\fbidi \fswiss\fcharset162\fprq';
    wwv_flow_api.g_varchar2_table(71) := '2 Calibri Tur;}'||wwv_flow.LF||
'{\fhiminor\f31573\fbidi \fswiss\fcharset177\fprq2 Calibri (Hebrew);}{\fhiminor\f315';
    wwv_flow_api.g_varchar2_table(72) := '74\fbidi \fswiss\fcharset178\fprq2 Calibri (Arabic);}{\fhiminor\f31575\fbidi \fswiss\fcharset186\fpr';
    wwv_flow_api.g_varchar2_table(73) := 'q2 Calibri Baltic;}'||wwv_flow.LF||
'{\fhiminor\f31576\fbidi \fswiss\fcharset163\fprq2 Calibri (Vietnamese);}{\fbimi';
    wwv_flow_api.g_varchar2_table(74) := 'nor\f31578\fbidi \fswiss\fcharset238\fprq2 Arial CE;}{\fbiminor\f31579\fbidi \fswiss\fcharset204\fpr';
    wwv_flow_api.g_varchar2_table(75) := 'q2 Arial Cyr;}'||wwv_flow.LF||
'{\fbiminor\f31581\fbidi \fswiss\fcharset161\fprq2 Arial Greek;}{\fbiminor\f31582\fbi';
    wwv_flow_api.g_varchar2_table(76) := 'di \fswiss\fcharset162\fprq2 Arial Tur;}{\fbiminor\f31583\fbidi \fswiss\fcharset177\fprq2 Arial (Heb';
    wwv_flow_api.g_varchar2_table(77) := 'rew);}'||wwv_flow.LF||
'{\fbiminor\f31584\fbidi \fswiss\fcharset178\fprq2 Arial (Arabic);}{\fbiminor\f31585\fbidi \f';
    wwv_flow_api.g_varchar2_table(78) := 'swiss\fcharset186\fprq2 Arial Baltic;}{\fbiminor\f31586\fbidi \fswiss\fcharset163\fprq2 Arial (Vietn';
    wwv_flow_api.g_varchar2_table(79) := 'amese);}}{\colortbl;\red0\green0\blue0;\red0\green0\blue255;'||wwv_flow.LF||
'\red0\green255\blue255;\red0\green255\';
    wwv_flow_api.g_varchar2_table(80) := 'blue0;\red255\green0\blue255;\red255\green0\blue0;\red255\green255\blue0;\red255\green255\blue255;\r';
    wwv_flow_api.g_varchar2_table(81) := 'ed0\green0\blue128;\red0\green128\blue128;\red0\green128\blue0;\red128\green0\blue128;\red128\green0';
    wwv_flow_api.g_varchar2_table(82) := '\blue0;'||wwv_flow.LF||
'\red128\green128\blue0;\red128\green128\blue128;\red192\green192\blue192;\red0\green0\blue0';
    wwv_flow_api.g_varchar2_table(83) := ';\red0\green0\blue0;\cbackgroundone\ctint255\cshade255\red255\green255\blue255;}{\*\defchp \f31506\f';
    wwv_flow_api.g_varchar2_table(84) := 's22 }{\*\defpap \ql \li0\ri0\sa160\sl259\slmult1'||wwv_flow.LF||
'\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adju';
    wwv_flow_api.g_varchar2_table(85) := 'stright\rin0\lin0\itap0 }\noqfpromote {\stylesheet{\ql \li0\ri0\sa160\sl259\slmult1\widctlpar\wrapde';
    wwv_flow_api.g_varchar2_table(86) := 'fault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \rtlch\fcs1 \af31507\afs22\alang1025 '||wwv_flow.LF||
'\ltr';
    wwv_flow_api.g_varchar2_table(87) := 'ch\fcs0 \f31506\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \snext0 \sqformat \spriority0';
    wwv_flow_api.g_varchar2_table(88) := ' Normal;}{\*\cs10 \additive \ssemihidden \sunhideused \spriority1 Default Paragraph Font;}{\*'||wwv_flow.LF||
'\ts11';
    wwv_flow_api.g_varchar2_table(89) := '\tsrowd\trftsWidthB3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblind0\tblindtyp';
    wwv_flow_api.g_varchar2_table(90) := 'e3\tsvertalt\tsbrdrt\tsbrdrl\tsbrdrb\tsbrdrr\tsbrdrdgl\tsbrdrdgr\tsbrdrh\tsbrdrv \ql \li0\ri0\sa160\';
    wwv_flow_api.g_varchar2_table(91) := 'sl259\slmult1'||wwv_flow.LF||
'\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \rtlch\fcs1';
    wwv_flow_api.g_varchar2_table(92) := ' \af31507\afs22\alang1025 \ltrch\fcs0 \f31506\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
    wwv_flow_api.g_varchar2_table(93) := ' \snext11 \ssemihidden \sunhideused Normal Table;}{\*\ts15\tsrowd'||wwv_flow.LF||
'\trbrdrt\brdrs\brdrw10 \trbrdrl\b';
    wwv_flow_api.g_varchar2_table(94) := 'rdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brd';
    wwv_flow_api.g_varchar2_table(95) := 'rw10 '||wwv_flow.LF||
'\trftsWidthB3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblind0\tblindtyp';
    wwv_flow_api.g_varchar2_table(96) := 'e3\tsvertalt\tsbrdrt\tsbrdrl\tsbrdrb\tsbrdrr\tsbrdrdgl\tsbrdrdgr\tsbrdrh\tsbrdrv '||wwv_flow.LF||
'\ql \li0\ri0\widc';
    wwv_flow_api.g_varchar2_table(97) := 'tlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \rtlch\fcs1 \af31507\afs22\alan';
    wwv_flow_api.g_varchar2_table(98) := 'g1025 \ltrch\fcs0 \f31506\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \sbasedon11 \snext1';
    wwv_flow_api.g_varchar2_table(99) := '5 \spriority39 \styrsid5510251 '||wwv_flow.LF||
'Table Grid;}{\s16\ql \li0\ri0\widctlpar\wrapdefault\aspalpha\aspnum';
    wwv_flow_api.g_varchar2_table(100) := '\faauto\adjustright\rin0\lin0\itap0\contextualspace \rtlch\fcs1 \af31503\afs56\alang1025 \ltrch\fcs0';
    wwv_flow_api.g_varchar2_table(101) := ' '||wwv_flow.LF||
'\fs56\expnd-2\expndtw-10\lang1033\langfe1033\kerning28\loch\f31502\hich\af31502\dbch\af31501\cgri';
    wwv_flow_api.g_varchar2_table(102) := 'd\langnp1033\langfenp1033 \sbasedon0 \snext0 \slink17 \sqformat \spriority10 \styrsid16743769 Title;';
    wwv_flow_api.g_varchar2_table(103) := '}{\*\cs17 \additive \rtlch\fcs1 \af31503\afs56 '||wwv_flow.LF||
'\ltrch\fcs0 \fs56\expnd-2\expndtw-10\kerning28\loch';
    wwv_flow_api.g_varchar2_table(104) := '\f31502\hich\af31502\dbch\af31501 \sbasedon10 \slink16 \slocked \spriority10 \styrsid16743769 Title ';
    wwv_flow_api.g_varchar2_table(105) := 'Char;}}{\*\rsidtbl \rsid91571\rsid678381\rsid816405\rsid1339818\rsid1715606\rsid1728812\rsid1778647';
    wwv_flow_api.g_varchar2_table(106) := ''||wwv_flow.LF||
'\rsid2502627\rsid3351606\rsid3502159\rsid4089413\rsid4459971\rsid4548179\rsid4666254\rsid4725872\rs';
    wwv_flow_api.g_varchar2_table(107) := 'id4869424\rsid5510251\rsid6111628\rsid6505266\rsid6979285\rsid7019040\rsid7286595\rsid7429375\rsid78';
    wwv_flow_api.g_varchar2_table(108) := '03984\rsid7817153\rsid7869381\rsid8328744\rsid8333047'||wwv_flow.LF||
'\rsid8459132\rsid8597123\rsid9257487\rsid9258';
    wwv_flow_api.g_varchar2_table(109) := '855\rsid9776363\rsid10095675\rsid10183755\rsid11428772\rsid11551036\rsid11733902\rsid11800713\rsid12';
    wwv_flow_api.g_varchar2_table(110) := '267274\rsid12790319\rsid12869998\rsid13370026\rsid13596424\rsid14515664\rsid14700697\rsid15674213\rs';
    wwv_flow_api.g_varchar2_table(111) := 'id15730918'||wwv_flow.LF||
'\rsid15943195\rsid15999906\rsid16196166\rsid16278804\rsid16718282\rsid16736327\rsid16743';
    wwv_flow_api.g_varchar2_table(112) := '769}{\mmathPr\mmathFont34\mbrkBin0\mbrkBinSub0\msmallFrac0\mdispDef1\mlMargin0\mrMargin0\mdefJc1\mwr';
    wwv_flow_api.g_varchar2_table(113) := 'apIndent1440\mintLim0\mnaryLim1}{\info'||wwv_flow.LF||
'{\author Haney Ghareb Abdela Al Ghareb}{\operator Haney Ghar';
    wwv_flow_api.g_varchar2_table(114) := 'eb Abdela Al Ghareb}{\creatim\yr2023\mo5\dy17\hr10\min19}{\revtim\yr2023\mo5\dy17\hr10\min48}{\versi';
    wwv_flow_api.g_varchar2_table(115) := 'on10}{\edmins29}{\nofpages1}{\nofwords72}{\nofchars413}{\nofcharsws484}{\vern57}}'||wwv_flow.LF||
'{\*\xmlnstbl {\xm';
    wwv_flow_api.g_varchar2_table(116) := 'lns1 http://schemas.microsoft.com/office/word/2003/wordml}}\paperw31680\paperh16834\margl720\margr72';
    wwv_flow_api.g_varchar2_table(117) := '0\margt576\margb1440\gutter0\ltrsect '||wwv_flow.LF||
'\widowctrl\ftnbj\aenddoc\trackmoves0\trackformatting1\donotem';
    wwv_flow_api.g_varchar2_table(118) := 'bedsysfont1\relyonvml0\donotembedlingdata0\grfdocevents0\validatexml1\showplaceholdtext0\ignoremixed';
    wwv_flow_api.g_varchar2_table(119) := 'content0\saveinvalidxml0\showxmlerrors1\noxlattoyen'||wwv_flow.LF||
'\expshrtn\noultrlspc\dntblnsbdb\nospaceforul\fo';
    wwv_flow_api.g_varchar2_table(120) := 'rmshade\horzdoc\dgmargin\dghspace180\dgvspace180\dghorigin720\dgvorigin576\dghshow1\dgvshow1'||wwv_flow.LF||
'\jexpa';
    wwv_flow_api.g_varchar2_table(121) := 'nd\viewkind1\viewscale90\pgbrdrhead\pgbrdrfoot\splytwnine\ftnlytwnine\htmautsp\nolnhtadjtbl\useltbal';
    wwv_flow_api.g_varchar2_table(122) := 'n\alntblind\lytcalctblwd\lyttblrtgr\lnbrkrule\nobrkwrptbl\snaptogridincell\allowfieldendsel\wrppunct';
    wwv_flow_api.g_varchar2_table(123) := ''||wwv_flow.LF||
'\asianbrkrule\rsidroot4089413\newtblstyruls\nogrowautofit\usenormstyforlist\noindnmbrts\felnbrelev';
    wwv_flow_api.g_varchar2_table(124) := '\nocxsptable\indrlsweleven\noafcnsttbl\afelev\utinl\hwelev\spltpgpar\notcvasp\notbrkcnstfrctbl\notva';
    wwv_flow_api.g_varchar2_table(125) := 'txbx\krnprsnet\cachedcolbal \nouicompat \fet0'||wwv_flow.LF||
'{\*\wgrffmtfilter 2450}\nofeaturethrottle1\ilfomacatc';
    wwv_flow_api.g_varchar2_table(126) := 'lnup0{\*\docvar {xdo0001}{PD9mb3ItZWFjaDpST1c/Pjw/c29ydDpDT1NUX0NFTlRFUjsnYXNjZW5kaW5nJztkYXRhLXR5cG';
    wwv_flow_api.g_varchar2_table(127) := 'U9J3RleHQnPz4=}}{\*\docvar {xdo0002}{PD9TRUNUT1JfTkFNRT8+}}{\*\docvar {xdo0003}{PD9DT1NUX0NFTlRFUj8+';
    wwv_flow_api.g_varchar2_table(128) := '}}'||wwv_flow.LF||
'{\*\docvar {xdo0004}{PD9DT1NUX0NFTlRFUl9OQU1FPz4=}}{\*\docvar {xdo0005}{PD9ESVJFQ1RPUl9OQU1FPz4=';
    wwv_flow_api.g_varchar2_table(129) := '}}{\*\docvar {xdo0006}{PD9FRF9OQU1FPz4=}}{\*\docvar {xdo0007}{PD9DRUlMSU5HX0NIMl9BTU9VTlQ/Pg==}}{\*\';
    wwv_flow_api.g_varchar2_table(130) := 'docvar {xdo0008}{PD9DSDJfQUxMT0NBVElPTj8+}}'||wwv_flow.LF||
'{\*\docvar {xdo0009}{PD9DRUlMSU5HX0NIM19BTU9VTlQ/Pg==}}';
    wwv_flow_api.g_varchar2_table(131) := '{\*\docvar {xdo0010}{PD9DSDNfQUxMT0NBVElPTj8+}}{\*\docvar {xdo0011}{PD9TVEFUVVM/Pg==}}{\*\docvar {xd';
    wwv_flow_api.g_varchar2_table(132) := 'o0012}{PD9DT01NRU5UUz8+}}{\*\docvar {xdo0013}{PD9lbmQgZm9yLWVhY2g/Pg==}}'||wwv_flow.LF||
'{\*\docvar {xdo0014}{PD9DT';
    wwv_flow_api.g_varchar2_table(133) := '1NUX0NFTlRFUl9JTlNUUlVDVElPTlM/Pg==}}\ltrpar \sectd \ltrsect\lndscpsxn\psz8\linex0\endnhere\sectline';
    wwv_flow_api.g_varchar2_table(134) := 'grid360\sectdefaultcl\sectrsid12267274\sftnbj {\*\pnseclvl1\pnucrm\pnqc\pnstart1\pnindent720\pnhang ';
    wwv_flow_api.g_varchar2_table(135) := '{\pntxta .}}{\*\pnseclvl2'||wwv_flow.LF||
'\pnucltr\pnqc\pnstart1\pnindent720\pnhang {\pntxta .}}{\*\pnseclvl3\pndec';
    wwv_flow_api.g_varchar2_table(136) := '\pnqc\pnstart1\pnindent720\pnhang {\pntxta .}}{\*\pnseclvl4\pnlcltr\pnqc\pnstart1\pnindent720\pnhang';
    wwv_flow_api.g_varchar2_table(137) := ' {\pntxta )}}{\*\pnseclvl5\pndec\pnqc\pnstart1\pnindent720\pnhang {\pntxtb (}'||wwv_flow.LF||
'{\pntxta )}}{\*\pnsec';
    wwv_flow_api.g_varchar2_table(138) := 'lvl6\pnlcltr\pnqc\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta )}}{\*\pnseclvl7\pnlcrm\pnqc\pnsta';
    wwv_flow_api.g_varchar2_table(139) := 'rt1\pnindent720\pnhang {\pntxtb (}{\pntxta )}}{\*\pnseclvl8\pnlcltr\pnqc\pnstart1\pnindent720\pnhang';
    wwv_flow_api.g_varchar2_table(140) := ' {\pntxtb (}{\pntxta )}}'||wwv_flow.LF||
'{\*\pnseclvl9\pnlcrm\pnqc\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta ';
    wwv_flow_api.g_varchar2_table(141) := ')}}\pard\plain \ltrpar\s16\qc \li0\ri0\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0';
    wwv_flow_api.g_varchar2_table(142) := '\lin0\itap0\pararsid16743769\contextualspace \rtlch\fcs1 '||wwv_flow.LF||
'\af31503\afs56\alang1025 \ltrch\fcs0 \fs5';
    wwv_flow_api.g_varchar2_table(143) := '6\expnd-2\expndtw-10\lang1033\langfe1033\kerning28\loch\af31502\hich\af31502\dbch\af31501\cgrid\lang';
    wwv_flow_api.g_varchar2_table(144) := 'np1033\langfenp1033 {\rtlch\fcs1 \af31503 \ltrch\fcs0 \insrsid16743769 \hich\af31502\dbch\af31501\lo';
    wwv_flow_api.g_varchar2_table(145) := 'ch\f31502 '||wwv_flow.LF||
'Budget\hich\af31502\dbch\af31501\loch\f31502  \hich\af31502\dbch\af31501\loch\f31502 Pro';
    wwv_flow_api.g_varchar2_table(146) := 'posal \hich\af31502\dbch\af31501\loch\f31502 Cost Centers \hich\af31502\dbch\af31501\loch\f31502 P\h';
    wwv_flow_api.g_varchar2_table(147) := 'ich\af31502\dbch\af31501\loch\f31502 l'||wwv_flow.LF||
'\hich\af31502\dbch\af31501\loch\f31502 an\hich\af31502\dbch\';
    wwv_flow_api.g_varchar2_table(148) := 'af31501\loch\f31502 s}{\rtlch\fcs1 \af31503 \ltrch\fcs0 \insrsid10318050 '||wwv_flow.LF||
'\par }\pard\plain \ltrpar';
    wwv_flow_api.g_varchar2_table(149) := '\ql \li0\ri0\sa160\sl259\slmult1\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\';
    wwv_flow_api.g_varchar2_table(150) := 'itap0 \rtlch\fcs1 \af31507\afs22\alang1025 \ltrch\fcs0 \f31506\fs22\lang1033\langfe1033\cgrid\langnp';
    wwv_flow_api.g_varchar2_table(151) := '1033\langfenp1033 {\rtlch\fcs1 '||wwv_flow.LF||
'\af31507 \ltrch\fcs0 \insrsid5510251 '||wwv_flow.LF||
'\par '||wwv_flow.LF||
'\par \ltrrow}\trowd \';
    wwv_flow_api.g_varchar2_table(152) := 'irow0\irowband0\ltrrow\ts15\trgaph108\trleft-108\trhdr\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 ';
    wwv_flow_api.g_varchar2_table(153) := '\trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 '||wwv_flow.LF||
'\trfts';
    wwv_flow_api.g_varchar2_table(154) := 'Width3\trwWidth29628\trftsWidthB3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblr';
    wwv_flow_api.g_varchar2_table(155) := 'sid3502159\tbllkhdrrows\tbllkhdrcols\tbllknocolband\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brd';
    wwv_flow_api.g_varchar2_table(156) := 'rw10 \clbrdrl\brdrs\brdrw10 \clbrdrb'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clfts';
    wwv_flow_api.g_varchar2_table(157) := 'Width3\clwWidth3168\clcbpatraw6 \cellx3060\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \c';
    wwv_flow_api.g_varchar2_table(158) := 'lbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\clcbpat6\cltxlrtb\clftsWidth3\clwWidth1440\clcbpatraw';
    wwv_flow_api.g_varchar2_table(159) := '6 \cellx4500\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\';
    wwv_flow_api.g_varchar2_table(160) := 'brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth3600\clcbpatraw6 \cellx8100\clvertalt\clbrdrt'||wwv_flow.LF||
'';
    wwv_flow_api.g_varchar2_table(161) := '\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlr';
    wwv_flow_api.g_varchar2_table(162) := 'tb\clftsWidth3\clwWidth2070\clcbpatraw6 \cellx10170\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\b';
    wwv_flow_api.g_varchar2_table(163) := 'rdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\clcbpat6\cltxlrtb\clftsWidth3\clwWidth2160\c';
    wwv_flow_api.g_varchar2_table(164) := 'lcbpatraw6 \cellx12330\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10';
    wwv_flow_api.g_varchar2_table(165) := ' \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth2070\clcbpatraw6 \cellx14400\clvertal';
    wwv_flow_api.g_varchar2_table(166) := 't\clbrdrt'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcb';
    wwv_flow_api.g_varchar2_table(167) := 'pat6\cltxlrtb\clftsWidth3\clwWidth1890\clcbpatraw6 \cellx16290\clvertalt\clbrdrt\brdrs\brdrw10 \clbr';
    wwv_flow_api.g_varchar2_table(168) := 'drl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\clcbpat6\cltxlrtb\clftsWidth3\clw';
    wwv_flow_api.g_varchar2_table(169) := 'Width2430\clcbpatraw6 \cellx18720\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\br';
    wwv_flow_api.g_varchar2_table(170) := 'drs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth2880\clcbpatraw6 \cellx216';
    wwv_flow_api.g_varchar2_table(171) := '00\clvertalt\clbrdrt'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\br';
    wwv_flow_api.g_varchar2_table(172) := 'drw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth1710\clcbpatraw6 \cellx23310\clvertalt\clbrdrt\brdrs\br';
    wwv_flow_api.g_varchar2_table(173) := 'drw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\clcbpat6\cltxlrtb\clft';
    wwv_flow_api.g_varchar2_table(174) := 'sWidth3\clwWidth6210\clcbpatraw6 \cellx29520\pard\plain \ltrpar\qc \li0\ri0\widctlpar\intbl\wrapdefa';
    wwv_flow_api.g_varchar2_table(175) := 'ult\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid678381\yts15 \rtlch\fcs1 \af31507\afs22\ala';
    wwv_flow_api.g_varchar2_table(176) := 'ng1025 \ltrch\fcs0 '||wwv_flow.LF||
'\f31506\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af';
    wwv_flow_api.g_varchar2_table(177) := '31507 \ltrch\fcs0 \b\cf19\insrsid678381\charrsid11733902 Sector}{\rtlch\fcs1 \af31507 \ltrch\fcs0 \c';
    wwv_flow_api.g_varchar2_table(178) := 'f19\insrsid5510251\charrsid11733902 \cell }{\rtlch\fcs1 \af31507 '||wwv_flow.LF||
'\ltrch\fcs0 \b\cf19\insrsid678381';
    wwv_flow_api.g_varchar2_table(179) := '\charrsid11733902 Cost Center}{\rtlch\fcs1 \af31507 \ltrch\fcs0 \cf19\insrsid5510251\charrsid1173390';
    wwv_flow_api.g_varchar2_table(180) := '2 \cell }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \b\cf19\insrsid678381\charrsid11733902 Cost Center Name}{';
    wwv_flow_api.g_varchar2_table(181) := '\rtlch\fcs1 \af31507 '||wwv_flow.LF||
'\ltrch\fcs0 \cf19\insrsid5510251\charrsid11733902 \cell }{\rtlch\fcs1 \af3150';
    wwv_flow_api.g_varchar2_table(182) := '7 \ltrch\fcs0 \b\cf19\insrsid678381\charrsid11733902 Director}{\rtlch\fcs1 \af31507 \ltrch\fcs0 \cf1';
    wwv_flow_api.g_varchar2_table(183) := '9\insrsid5510251\charrsid11733902 \cell }{\rtlch\fcs1 \af31507 \ltrch\fcs0 '||wwv_flow.LF||
'\b\cf19\insrsid678381\c';
    wwv_flow_api.g_varchar2_table(184) := 'harrsid11733902 Executive Director}{\rtlch\fcs1 \af31507 \ltrch\fcs0 \cf19\insrsid5510251\charrsid11';
    wwv_flow_api.g_varchar2_table(185) := '733902 \cell }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \b\cf19\insrsid678381\charrsid11733902 Opex Ceiling}';
    wwv_flow_api.g_varchar2_table(186) := '{\rtlch\fcs1 \af31507 '||wwv_flow.LF||
'\ltrch\fcs0 \cf19\insrsid5510251\charrsid11733902 \cell }{\rtlch\fcs1 \af315';
    wwv_flow_api.g_varchar2_table(187) := '07 \ltrch\fcs0 \b\cf19\insrsid678381\charrsid11733902 Opex Allocated}{\rtlch\fcs1 \af31507 \ltrch\fc';
    wwv_flow_api.g_varchar2_table(188) := 's0 \cf19\insrsid5510251\charrsid11733902 \cell }{\rtlch\fcs1 \af31507 '||wwv_flow.LF||
'\ltrch\fcs0 \b\cf19\insrsid6';
    wwv_flow_api.g_varchar2_table(189) := '78381\charrsid11733902 Capex Ceiling}{\rtlch\fcs1 \af31507 \ltrch\fcs0 \cf19\insrsid5510251\charrsid';
    wwv_flow_api.g_varchar2_table(190) := '11733902 \cell }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \b\cf19\insrsid678381\charrsid11733902 Capex Ceili';
    wwv_flow_api.g_varchar2_table(191) := 'ng}{\rtlch\fcs1 \af31507 '||wwv_flow.LF||
'\ltrch\fcs0 \cf19\insrsid5510251\charrsid11733902 \cell }{\rtlch\fcs1 \af';
    wwv_flow_api.g_varchar2_table(192) := '31507 \ltrch\fcs0 \b\cf19\insrsid678381\charrsid11733902 Status}{\rtlch\fcs1 \af31507 \ltrch\fcs0 \c';
    wwv_flow_api.g_varchar2_table(193) := 'f19\insrsid5510251\charrsid11733902 \cell }{\rtlch\fcs1 \af31507 \ltrch\fcs0 '||wwv_flow.LF||
'\b\cf19\insrsid678381';
    wwv_flow_api.g_varchar2_table(194) := '\charrsid11733902 Instruction}{\rtlch\fcs1 \af31507 \ltrch\fcs0 \cf19\insrsid5510251\charrsid1173390';
    wwv_flow_api.g_varchar2_table(195) := '2 \cell }\pard\plain \ltrpar\ql \li0\ri0\sa160\sl259\slmult1\widctlpar\intbl\wrapdefault\aspalpha\as';
    wwv_flow_api.g_varchar2_table(196) := 'pnum\faauto\adjustright\rin0\lin0 '||wwv_flow.LF||
'\rtlch\fcs1 \af31507\afs22\alang1025 \ltrch\fcs0 \f31506\fs22\la';
    wwv_flow_api.g_varchar2_table(197) := 'ng1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid3502159 \t';
    wwv_flow_api.g_varchar2_table(198) := 'rowd \irow0\irowband0\ltrrow\ts15\trgaph108\trleft-108\trhdr\trbrdrt\brdrs\brdrw10 \trbrdrl'||wwv_flow.LF||
'\brdrs\';
    wwv_flow_api.g_varchar2_table(199) := 'brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 ';
    wwv_flow_api.g_varchar2_table(200) := ''||wwv_flow.LF||
'\trftsWidth3\trwWidth29628\trftsWidthB3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpadd';
    wwv_flow_api.g_varchar2_table(201) := 'fr3\tblrsid3502159\tbllkhdrrows\tbllkhdrcols\tbllknocolband\tblind0\tblindtype3 \clvertalt\clbrdrt\b';
    wwv_flow_api.g_varchar2_table(202) := 'rdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlr';
    wwv_flow_api.g_varchar2_table(203) := 'tb\clftsWidth3\clwWidth3168\clcbpatraw6 \cellx3060\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\br';
    wwv_flow_api.g_varchar2_table(204) := 'drw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\clcbpat6\cltxlrtb\clftsWidth3\clwWidth1440\cl';
    wwv_flow_api.g_varchar2_table(205) := 'cbpatraw6 \cellx4500\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \';
    wwv_flow_api.g_varchar2_table(206) := 'clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth3600\clcbpatraw6 \cellx8100\clvertalt\c';
    wwv_flow_api.g_varchar2_table(207) := 'lbrdrt'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat';
    wwv_flow_api.g_varchar2_table(208) := '6\cltxlrtb\clftsWidth3\clwWidth2070\clcbpatraw6 \cellx10170\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl';
    wwv_flow_api.g_varchar2_table(209) := '\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\clcbpat6\cltxlrtb\clftsWidth3\clwWid';
    wwv_flow_api.g_varchar2_table(210) := 'th2160\clcbpatraw6 \cellx12330\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs';
    wwv_flow_api.g_varchar2_table(211) := '\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth2070\clcbpatraw6 \cellx14400\';
    wwv_flow_api.g_varchar2_table(212) := 'clvertalt\clbrdrt'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw';
    wwv_flow_api.g_varchar2_table(213) := '10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth1890\clcbpatraw6 \cellx16290\clvertalt\clbrdrt\brdrs\brdrw';
    wwv_flow_api.g_varchar2_table(214) := '10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\clcbpat6\cltxlrtb\clftsWi';
    wwv_flow_api.g_varchar2_table(215) := 'dth3\clwWidth2430\clcbpatraw6 \cellx18720\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \cl';
    wwv_flow_api.g_varchar2_table(216) := 'brdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth2880\clcbpatraw6 \';
    wwv_flow_api.g_varchar2_table(217) := 'cellx21600\clvertalt\clbrdrt'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\';
    wwv_flow_api.g_varchar2_table(218) := 'brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth1710\clcbpatraw6 \cellx23310\clvertalt\clbrdrt\';
    wwv_flow_api.g_varchar2_table(219) := 'brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\clcbpat6\cltxl';
    wwv_flow_api.g_varchar2_table(220) := 'rtb\clftsWidth3\clwWidth6210\clcbpatraw6 \cellx29520\row \ltrrow}\trowd \irow1\irowband1\lastrow \lt';
    wwv_flow_api.g_varchar2_table(221) := 'rrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \';
    wwv_flow_api.g_varchar2_table(222) := 'trbrdrr\brdrs\brdrw10 \trbrdrh'||wwv_flow.LF||
'\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 \trftsWidth3\trwWidth29628\trf';
    wwv_flow_api.g_varchar2_table(223) := 'tsWidthB3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid3502159\tbllkhdrrows\';
    wwv_flow_api.g_varchar2_table(224) := 'tbllkhdrcols\tbllknocolband\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10 '||wwv_flow.LF||
'\clbrdrl\brdrs\br';
    wwv_flow_api.g_varchar2_table(225) := 'drw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth3168\clshdrawnil \';
    wwv_flow_api.g_varchar2_table(226) := 'cellx3060\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brd';
    wwv_flow_api.g_varchar2_table(227) := 'rs\brdrw10 '||wwv_flow.LF||
'\cltxlrtb\clftsWidth3\clwWidth1440\clshdrawnil \cellx4500\clvertalt\clbrdrt\brdrs\brdrw';
    wwv_flow_api.g_varchar2_table(228) := '10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWid';
    wwv_flow_api.g_varchar2_table(229) := 'th3600\clshdrawnil \cellx8100\clvertalt\clbrdrt\brdrs\brdrw10 '||wwv_flow.LF||
'\clbrdrl\brdrs\brdrw10 \clbrdrb\brdr';
    wwv_flow_api.g_varchar2_table(230) := 's\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth2070\clshdrawnil \cellx10170\clvertal';
    wwv_flow_api.g_varchar2_table(231) := 't\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\cltx';
    wwv_flow_api.g_varchar2_table(232) := 'lrtb\clftsWidth3\clwWidth2160\clshdrawnil \cellx12330\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs';
    wwv_flow_api.g_varchar2_table(233) := '\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth2070\clshdrawni';
    wwv_flow_api.g_varchar2_table(234) := 'l \cellx14400\clvertalt\clbrdrt\brdrs\brdrw10 '||wwv_flow.LF||
'\clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrd';
    wwv_flow_api.g_varchar2_table(235) := 'rr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1890\clshdrawnil \cellx16290\clvertalt\clbrdrt\brdrs\';
    wwv_flow_api.g_varchar2_table(236) := 'brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\cltxlrtb\clftsWidth3';
    wwv_flow_api.g_varchar2_table(237) := '\clwWidth2430\clshdrawnil \cellx18720\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdr';
    wwv_flow_api.g_varchar2_table(238) := 'b\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth2880\clshdrawnil \cellx21600\cl';
    wwv_flow_api.g_varchar2_table(239) := 'vertalt\clbrdrt\brdrs\brdrw10 '||wwv_flow.LF||
'\clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
    wwv_flow_api.g_varchar2_table(240) := ' \cltxlrtb\clftsWidth3\clwWidth1710\clshdrawnil \cellx23310\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl';
    wwv_flow_api.g_varchar2_table(241) := '\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\cltxlrtb\clftsWidth3\clwWidth6210\cl';
    wwv_flow_api.g_varchar2_table(242) := 'shdrawnil \cellx29520\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faa';
    wwv_flow_api.g_varchar2_table(243) := 'uto\adjustright\rin0\lin0\yts15 \rtlch\fcs1 \af31507\afs22\alang1025 \ltrch\fcs0 '||wwv_flow.LF||
'\f31506\fs22\lang';
    wwv_flow_api.g_varchar2_table(244) := '1033\langfe1033\cgrid\langnp1033\langfenp1033 {\field\flddirty{\*\fldinst {\rtlch\fcs1 \af31507 \ltr';
    wwv_flow_api.g_varchar2_table(245) := 'ch\fcs0 \cf9\insrsid5510251\charrsid5510251 {\*\bkmkstart Text1} FORMTEXT }{\rtlch\fcs1 \af31507 \lt';
    wwv_flow_api.g_varchar2_table(246) := 'rch\fcs0 '||wwv_flow.LF||
'\cf9\insrsid5510251\charrsid5510251 {\*\datafield 800100000000000005546578743100024620000';
    wwv_flow_api.g_varchar2_table(247) := '00000000f3c3f7265663a78646f303030313f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\fftypet';
    wwv_flow_api.g_varchar2_table(248) := 'xt0{\*\ffname Text1}{\*\ffdeftext F }{\*\ffstattext '||wwv_flow.LF||
'<?ref:xdo0001?>}}}}}{\fldrslt {\rtlch\fcs1 \af';
    wwv_flow_api.g_varchar2_table(249) := '31507 \ltrch\fcs0 \cf9\lang1024\langfe1024\noproof\insrsid5510251\charrsid5510251 F }}}\sectd \ltrse';
    wwv_flow_api.g_varchar2_table(250) := 'ct\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid12267274\sftnbj {\*\bkmkend ';
    wwv_flow_api.g_varchar2_table(251) := 'Text1}'||wwv_flow.LF||
'{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid5510251\charrsid551025';
    wwv_flow_api.g_varchar2_table(252) := '1 {\*\bkmkstart Text2} FORMTEXT }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid5510251\charrsid5510251 {';
    wwv_flow_api.g_varchar2_table(253) := '\*\datafield '||wwv_flow.LF||
'8001000000000000055465787432000b534543544f525f4e414d4500000000000f3c3f7265663a78646f3';
    wwv_flow_api.g_varchar2_table(254) := '03030323f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text2}{\*\ffde';
    wwv_flow_api.g_varchar2_table(255) := 'ftext SECTOR_NAME}{\*\ffstattext <?ref:xdo0002?>}}}}}{\fldrslt {'||wwv_flow.LF||
'\rtlch\fcs1 \af31507 \ltrch\fcs0 \';
    wwv_flow_api.g_varchar2_table(256) := 'lang1024\langfe1024\noproof\insrsid5510251\charrsid5510251 SECTOR_NAME}}}\sectd \ltrsect\lndscpsxn\p';
    wwv_flow_api.g_varchar2_table(257) := 'sz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid12267274\sftnbj {\rtlch\fcs1 \af31507 \ltr';
    wwv_flow_api.g_varchar2_table(258) := 'ch\fcs0 '||wwv_flow.LF||
'\insrsid5510251 {\*\bkmkend Text2}\cell }{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af31507';
    wwv_flow_api.g_varchar2_table(259) := ' \ltrch\fcs0 \insrsid5510251\charrsid5510251 {\*\bkmkstart Text3} FORMTEXT }{\rtlch\fcs1 \af31507 \l';
    wwv_flow_api.g_varchar2_table(260) := 'trch\fcs0 \insrsid5510251\charrsid5510251 {\*\datafield '||wwv_flow.LF||
'8001000000000000055465787433000b434f53545f';
    wwv_flow_api.g_varchar2_table(261) := '43454e54455200000000000f3c3f7265663a78646f303030333f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ff';
    wwv_flow_api.g_varchar2_table(262) := 'ownstat\fftypetxt0{\*\ffname Text3}{\*\ffdeftext COST_CENTER}{\*\ffstattext <?ref:xdo0003?>}}}}}{\fl';
    wwv_flow_api.g_varchar2_table(263) := 'drslt {'||wwv_flow.LF||
'\rtlch\fcs1 \af31507 \ltrch\fcs0 \lang1024\langfe1024\noproof\insrsid5510251\charrsid551025';
    wwv_flow_api.g_varchar2_table(264) := '1 COST_CENTER}}}\sectd \ltrsect\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsi';
    wwv_flow_api.g_varchar2_table(265) := 'd12267274\sftnbj {\rtlch\fcs1 \af31507 \ltrch\fcs0 '||wwv_flow.LF||
'\insrsid5510251 {\*\bkmkend Text3}\cell }{\fiel';
    wwv_flow_api.g_varchar2_table(266) := 'd\flddirty{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid5510251\charrsid5510251 {\*\bkmkstar';
    wwv_flow_api.g_varchar2_table(267) := 't Text4} FORMTEXT }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid5510251\charrsid5510251 {\*\datafield ';
    wwv_flow_api.g_varchar2_table(268) := ''||wwv_flow.LF||
'80010000000000000554657874340010434f53545f43454e5445525f4e414d4500000000000f3c3f7265663a78646f30303';
    wwv_flow_api.g_varchar2_table(269) := '0343f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text4}{\*\ffdeftex';
    wwv_flow_api.g_varchar2_table(270) := 't COST_CENTER_NAME}{\*\ffstattext <?ref:xdo0004?>}}}}'||wwv_flow.LF||
'}{\fldrslt {\rtlch\fcs1 \af31507 \ltrch\fcs0 ';
    wwv_flow_api.g_varchar2_table(271) := '\lang1024\langfe1024\noproof\insrsid5510251\charrsid5510251 COST_CENTER_NAME}}}\sectd \ltrsect\lndsc';
    wwv_flow_api.g_varchar2_table(272) := 'psxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid12267274\sftnbj {\rtlch\fcs1 \af3150';
    wwv_flow_api.g_varchar2_table(273) := '7 '||wwv_flow.LF||
'\ltrch\fcs0 \insrsid5510251 {\*\bkmkend Text4}\cell }{\field\flddirty{\*\fldinst {\rtlch\fcs1 \a';
    wwv_flow_api.g_varchar2_table(274) := 'f31507 \ltrch\fcs0 \insrsid5510251\charrsid5510251 {\*\bkmkstart Text5} FORMTEXT }{\rtlch\fcs1 \af31';
    wwv_flow_api.g_varchar2_table(275) := '507 \ltrch\fcs0 \insrsid5510251\charrsid5510251 '||wwv_flow.LF||
'{\*\datafield 8001000000000000055465787435000d4449';
    wwv_flow_api.g_varchar2_table(276) := '524543544f525f4e414d4500000000000f3c3f7265663a78646f303030353f3e0000000000}{\*\formfield{\fftype0\ff';
    wwv_flow_api.g_varchar2_table(277) := 'ownhelp\ffownstat\fftypetxt0{\*\ffname Text5}{\*\ffdeftext DIRECTOR_NAME}{\*\ffstattext <?ref:xdo000';
    wwv_flow_api.g_varchar2_table(278) := '5?>}'||wwv_flow.LF||
'}}}}{\fldrslt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \lang1024\langfe1024\noproof\insrsid5510251\ch';
    wwv_flow_api.g_varchar2_table(279) := 'arrsid5510251 DIRECTOR_NAME}}}\sectd \ltrsect\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdef';
    wwv_flow_api.g_varchar2_table(280) := 'aultcl\sectrsid12267274\sftnbj {\rtlch\fcs1 \af31507 '||wwv_flow.LF||
'\ltrch\fcs0 \insrsid5510251 {\*\bkmkend Text5';
    wwv_flow_api.g_varchar2_table(281) := '}\cell }{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid5510251\charrsid551025';
    wwv_flow_api.g_varchar2_table(282) := '1 {\*\bkmkstart Text6} FORMTEXT }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid5510251\charrsid5510251 ';
    wwv_flow_api.g_varchar2_table(283) := ''||wwv_flow.LF||
'{\*\datafield 8001000000000000055465787436000745445f4e414d4500000000000f3c3f7265663a78646f303030363';
    wwv_flow_api.g_varchar2_table(284) := 'f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text6}{\*\ffdeftext ED';
    wwv_flow_api.g_varchar2_table(285) := '_NAME}{\*\ffstattext <?ref:xdo0006?>}}}}}{\fldrslt {'||wwv_flow.LF||
'\rtlch\fcs1 \af31507 \ltrch\fcs0 \lang1024\lan';
    wwv_flow_api.g_varchar2_table(286) := 'gfe1024\noproof\insrsid5510251\charrsid5510251 ED_NAME}}}\sectd \ltrsect\lndscpsxn\psz8\linex0\endnh';
    wwv_flow_api.g_varchar2_table(287) := 'ere\sectlinegrid360\sectdefaultcl\sectrsid12267274\sftnbj {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid';
    wwv_flow_api.g_varchar2_table(288) := '5510251 '||wwv_flow.LF||
'{\*\bkmkend Text6}\cell }\pard \ltrpar\qr \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\as';
    wwv_flow_api.g_varchar2_table(289) := 'pnum\faauto\adjustright\rin0\lin0\pararsid12267274\yts15 {\field{\*\fldinst {\rtlch\fcs1 \af31507 \l';
    wwv_flow_api.g_varchar2_table(290) := 'trch\fcs0 \insrsid9257487 {\*\bkmkstart Text14} FORMTEXT }{'||wwv_flow.LF||
'\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrs';
    wwv_flow_api.g_varchar2_table(291) := 'id9257487 {\*\datafield 800b0000000000000654657874313400000008232c2323302e30300000000f3c3f7265663a78';
    wwv_flow_api.g_varchar2_table(292) := '646f303030373f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\ffprot\fftypetxt1{\*\ffname Te';
    wwv_flow_api.g_varchar2_table(293) := 'xt14}'||wwv_flow.LF||
'{\*\ffformat #,##0.00}{\*\ffstattext <?ref:xdo0007?>}}}}}{\fldrslt {\rtlch\fcs1 \af31507 \ltr';
    wwv_flow_api.g_varchar2_table(294) := 'ch\fcs0 \lang1024\langfe1024\noproof\insrsid9257487 \u8194\''20\u8194\''20\u8194\''20\u8194\''20\u8194\''';
    wwv_flow_api.g_varchar2_table(295) := '20}}}\sectd \ltrsect'||wwv_flow.LF||
'\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid12267274';
    wwv_flow_api.g_varchar2_table(296) := '\sftnbj {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid5510251 {\*\bkmkend Text14}\cell }{\field{\*\fldin';
    wwv_flow_api.g_varchar2_table(297) := 'st {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid15730918 {\*\bkmkstart Text16} '||wwv_flow.LF||
'FORMTEXT }{\rtlch\fcs1';
    wwv_flow_api.g_varchar2_table(298) := ' \af31507 \ltrch\fcs0 \insrsid15730918 {\*\datafield 800b0000000000000654657874313600000008232c23233';
    wwv_flow_api.g_varchar2_table(299) := '02e30300000000f3c3f7265663a78646f303030383f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\f';
    wwv_flow_api.g_varchar2_table(300) := 'fprot\fftypetxt1{\*\ffname Text16'||wwv_flow.LF||
'}{\*\ffformat #,##0.00}{\*\ffstattext <?ref:xdo0008?>}}}}}{\fldrs';
    wwv_flow_api.g_varchar2_table(301) := 'lt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \lang1024\langfe1024\noproof\insrsid15730918 \u8194\''20\u8194\''';
    wwv_flow_api.g_varchar2_table(302) := '20\u8194\''20\u8194\''20\u8194\''20}}}\sectd \ltrsect'||wwv_flow.LF||
'\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\';
    wwv_flow_api.g_varchar2_table(303) := 'sectdefaultcl\sectrsid12267274\sftnbj {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid5510251 {\*\bkmkend ';
    wwv_flow_api.g_varchar2_table(304) := 'Text16}\cell }{\field{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid15730918 {\*\bkmkstart Te';
    wwv_flow_api.g_varchar2_table(305) := 'xt17} '||wwv_flow.LF||
'FORMTEXT }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid15730918 {\*\datafield 800b0000000000000';
    wwv_flow_api.g_varchar2_table(306) := '654657874313700000008232c2323302e30300000000f3c3f7265663a78646f303030393f3e0000000000}{\*\formfield{';
    wwv_flow_api.g_varchar2_table(307) := '\fftype0\ffownhelp\ffownstat\ffprot\fftypetxt1{\*\ffname Text17'||wwv_flow.LF||
'}{\*\ffformat #,##0.00}{\*\ffstatte';
    wwv_flow_api.g_varchar2_table(308) := 'xt <?ref:xdo0009?>}}}}}{\fldrslt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \lang1024\langfe1024\noproof\insr';
    wwv_flow_api.g_varchar2_table(309) := 'sid15730918 \u8194\''20\u8194\''20\u8194\''20\u8194\''20\u8194\''20}}}\sectd \ltrsect'||wwv_flow.LF||
'\lndscpsxn\psz8\li';
    wwv_flow_api.g_varchar2_table(310) := 'nex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid12267274\sftnbj {\rtlch\fcs1 \af31507 \ltrch\fcs';
    wwv_flow_api.g_varchar2_table(311) := '0 \insrsid5510251 {\*\bkmkend Text17}\cell }{\field{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 \in';
    wwv_flow_api.g_varchar2_table(312) := 'srsid15730918 {\*\bkmkstart Text18} '||wwv_flow.LF||
'FORMTEXT }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid15730918 {';
    wwv_flow_api.g_varchar2_table(313) := '\*\datafield 800b0000000000000654657874313800000008232c2323302e30300000000f3c3f7265663a78646f3030313';
    wwv_flow_api.g_varchar2_table(314) := '03f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\ffprot\fftypetxt1{\*\ffname Text18'||wwv_flow.LF||
'}{\*\';
    wwv_flow_api.g_varchar2_table(315) := 'ffformat #,##0.00}{\*\ffstattext <?ref:xdo0010?>}}}}}{\fldrslt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \la';
    wwv_flow_api.g_varchar2_table(316) := 'ng1024\langfe1024\noproof\insrsid15730918 \u8194\''20\u8194\''20\u8194\''20\u8194\''20\u8194\''20}}}\sect';
    wwv_flow_api.g_varchar2_table(317) := 'd \ltrsect'||wwv_flow.LF||
'\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid12267274\sftnbj {\';
    wwv_flow_api.g_varchar2_table(318) := 'rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid5510251 {\*\bkmkend Text18}\cell }\pard \ltrpar'||wwv_flow.LF||
'\qc \li0\ri';
    wwv_flow_api.g_varchar2_table(319) := '0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid12267274\yts15 {\';
    wwv_flow_api.g_varchar2_table(320) := 'field\flddirty{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid5510251\charrsid5510251 {\*\bkmk';
    wwv_flow_api.g_varchar2_table(321) := 'start Text11} FORMTEXT }{\rtlch\fcs1 '||wwv_flow.LF||
'\af31507 \ltrch\fcs0 \insrsid5510251\charrsid5510251 {\*\data';
    wwv_flow_api.g_varchar2_table(322) := 'field 800100000000000006546578743131000653544154555300000000000f3c3f7265663a78646f303031313f3e000000';
    wwv_flow_api.g_varchar2_table(323) := '0000}{\*\formfield{\fftype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text11}{\*\ffdeftext '||wwv_flow.LF||
'STATUS}{';
    wwv_flow_api.g_varchar2_table(324) := '\*\ffstattext <?ref:xdo0011?>}}}}}{\fldrslt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \lang1024\langfe1024\n';
    wwv_flow_api.g_varchar2_table(325) := 'oproof\insrsid5510251\charrsid5510251 STATUS}}}\sectd \ltrsect'||wwv_flow.LF||
'\lndscpsxn\psz8\linex0\endnhere\sect';
    wwv_flow_api.g_varchar2_table(326) := 'linegrid360\sectdefaultcl\sectrsid12267274\sftnbj {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid5510251 ';
    wwv_flow_api.g_varchar2_table(327) := '{\*\bkmkend Text11}\cell }\pard \ltrpar'||wwv_flow.LF||
'\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\fa';
    wwv_flow_api.g_varchar2_table(328) := 'auto\adjustright\rin0\lin0\yts15 {\field\flddirty{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insr';
    wwv_flow_api.g_varchar2_table(329) := 'sid678381\charrsid678381 {\*\bkmkstart Text15} FORMTEXT }{\rtlch\fcs1 \af31507 \ltrch\fcs0 '||wwv_flow.LF||
'\insrsi';
    wwv_flow_api.g_varchar2_table(330) := 'd678381\charrsid678381 {\*\datafield 8001000000000000065465787431350018434f53545f43454e5445525f494e5';
    wwv_flow_api.g_varchar2_table(331) := '35452554354494f4e5300000000000f3c3f7265663a78646f303031343f3e0000000000}{\*\formfield{\fftype0\ffown';
    wwv_flow_api.g_varchar2_table(332) := 'help\ffownstat\fftypetxt0{\*\ffname Text15}'||wwv_flow.LF||
'{\*\ffdeftext COST_CENTER_INSTRUCTIONS}{\*\ffstattext <';
    wwv_flow_api.g_varchar2_table(333) := '?ref:xdo0014?>}}}}}{\fldrslt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \lang1024\langfe1024\noproof\insrsid6';
    wwv_flow_api.g_varchar2_table(334) := '78381\charrsid678381 COST_CENTER_INSTRUCTIONS}}}\sectd \ltrsect'||wwv_flow.LF||
'\lndscpsxn\psz8\linex0\endnhere\sec';
    wwv_flow_api.g_varchar2_table(335) := 'tlinegrid360\sectdefaultcl\sectrsid12267274\sftnbj {\*\bkmkend Text15}{\field\flddirty{\*\fldinst {\';
    wwv_flow_api.g_varchar2_table(336) := 'rtlch\fcs1 \af31507 \ltrch\fcs0 \cf9\insrsid5510251\charrsid5510251 {\*\bkmkstart Text13} FORMTEXT }';
    wwv_flow_api.g_varchar2_table(337) := '{\rtlch\fcs1 '||wwv_flow.LF||
'\af31507 \ltrch\fcs0 \cf9\insrsid5510251\charrsid5510251 {\*\datafield 80010000000000';
    wwv_flow_api.g_varchar2_table(338) := '00065465787431330002204500000000000f3c3f7265663a78646f303031333f3e0000000000}{\*\formfield{\fftype0\';
    wwv_flow_api.g_varchar2_table(339) := 'ffownhelp\ffownstat\fftypetxt0{\*\ffname Text13}{\*\ffdeftext  E}'||wwv_flow.LF||
'{\*\ffstattext <?ref:xdo0013?>}}}';
    wwv_flow_api.g_varchar2_table(340) := '}}{\fldrslt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \cf9\lang1024\langfe1024\noproof\insrsid5510251\charrs';
    wwv_flow_api.g_varchar2_table(341) := 'id5510251  E}}}\sectd \ltrsect\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid';
    wwv_flow_api.g_varchar2_table(342) := '12267274\sftnbj {'||wwv_flow.LF||
'\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid5510251 {\*\bkmkend Text13}\cell }\pard\';
    wwv_flow_api.g_varchar2_table(343) := 'plain \ltrpar\ql \li0\ri0\sa160\sl259\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adj';
    wwv_flow_api.g_varchar2_table(344) := 'ustright\rin0\lin0 \rtlch\fcs1 \af31507\afs22\alang1025 \ltrch\fcs0 '||wwv_flow.LF||
'\f31506\fs22\lang1033\langfe10';
    wwv_flow_api.g_varchar2_table(345) := '33\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid12267274 \trowd \irow1\ir';
    wwv_flow_api.g_varchar2_table(346) := 'owband1\lastrow \ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbr';
    wwv_flow_api.g_varchar2_table(347) := 'drb\brdrs\brdrw10 '||wwv_flow.LF||
'\trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 \trftsWidth';
    wwv_flow_api.g_varchar2_table(348) := '3\trwWidth29628\trftsWidthB3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid35';
    wwv_flow_api.g_varchar2_table(349) := '02159\tbllkhdrrows\tbllkhdrcols\tbllknocolband\tblind0\tblindtype3 '||wwv_flow.LF||
'\clvertalt\clbrdrt\brdrs\brdrw1';
    wwv_flow_api.g_varchar2_table(350) := '0 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidt';
    wwv_flow_api.g_varchar2_table(351) := 'h3168\clshdrawnil \cellx3060\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\b';
    wwv_flow_api.g_varchar2_table(352) := 'rdrw10 \clbrdrr'||wwv_flow.LF||
'\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1440\clshdrawnil \cellx4500\clvertalt\';
    wwv_flow_api.g_varchar2_table(353) := 'clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb';
    wwv_flow_api.g_varchar2_table(354) := '\clftsWidth3\clwWidth3600\clshdrawnil \cellx8100\clvertalt\clbrdrt'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrl\brdrs\br';
    wwv_flow_api.g_varchar2_table(355) := 'drw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth2070\clshdrawnil \';
    wwv_flow_api.g_varchar2_table(356) := 'cellx10170\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\br';
    wwv_flow_api.g_varchar2_table(357) := 'drs\brdrw10 '||wwv_flow.LF||
'\cltxlrtb\clftsWidth3\clwWidth2160\clshdrawnil \cellx12330\clvertalt\clbrdrt\brdrs\brd';
    wwv_flow_api.g_varchar2_table(358) := 'rw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwW';
    wwv_flow_api.g_varchar2_table(359) := 'idth2070\clshdrawnil \cellx14400\clvertalt\clbrdrt\brdrs\brdrw10 '||wwv_flow.LF||
'\clbrdrl\brdrs\brdrw10 \clbrdrb\b';
    wwv_flow_api.g_varchar2_table(360) := 'rdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1890\clshdrawnil \cellx16290\clver';
    wwv_flow_api.g_varchar2_table(361) := 'talt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\c';
    wwv_flow_api.g_varchar2_table(362) := 'ltxlrtb\clftsWidth3\clwWidth2430\clshdrawnil \cellx18720\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\br';
    wwv_flow_api.g_varchar2_table(363) := 'drs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth2880\clshdra';
    wwv_flow_api.g_varchar2_table(364) := 'wnil \cellx21600\clvertalt\clbrdrt\brdrs\brdrw10 '||wwv_flow.LF||
'\clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \cl';
    wwv_flow_api.g_varchar2_table(365) := 'brdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1710\clshdrawnil \cellx23310\clvertalt\clbrdrt\brd';
    wwv_flow_api.g_varchar2_table(366) := 'rs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\cltxlrtb\clftsWid';
    wwv_flow_api.g_varchar2_table(367) := 'th3\clwWidth6210\clshdrawnil \cellx29520\row }\pard \ltrpar\ql \li0\ri0\sa160\sl259\slmult1\widctlpa';
    wwv_flow_api.g_varchar2_table(368) := 'r\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 {\rtlch\fcs1 \af31507 \ltrch\fcs0 \';
    wwv_flow_api.g_varchar2_table(369) := 'insrsid5510251 '||wwv_flow.LF||
'\par '||wwv_flow.LF||
'\par }{\*\themedata 504b030414000600080000002100e9de0fbfff0000001c0200001300';
    wwv_flow_api.g_varchar2_table(370) := '00005b436f6e74656e745f54797065735d2e786d6cac91cb4ec3301045f748fc83e52d4a'||wwv_flow.LF||
'9cb2400825e982c78ec7a27cc0';
    wwv_flow_api.g_varchar2_table(371) := 'c8992416c9d8b2a755fbf74cd25442a820166c2cd933f79e3be372bd1f07b5c3989ca74aaff2422b24eb1b475da5df374fd9';
    wwv_flow_api.g_varchar2_table(372) := 'ad'||wwv_flow.LF||
'5689811a183c61a50f98f4babebc2837878049899a52a57be670674cb23d8e90721f90a4d2fa3802cb35762680fd800e';
    wwv_flow_api.g_varchar2_table(373) := 'cd7551dc18eb899138e3c943d7e503b6'||wwv_flow.LF||
'b01d583deee5f99824e290b4ba3f364eac4a430883b3c092d4eca8f946c916422e';
    wwv_flow_api.g_varchar2_table(374) := 'cab927f52ea42b89a1cd59c254f919b0e85e6535d135a8de20f20b8c12c3b0'||wwv_flow.LF||
'0c895fcf6720192de6bf3b9e89ecdbd6596c';
    wwv_flow_api.g_varchar2_table(375) := 'bcdd8eb28e7c365ecc4ec1ff1460f53fe813d3cc7f5b7f020000ffff0300504b030414000600080000002100a5d6'||wwv_flow.LF||
'a7e7c0';
    wwv_flow_api.g_varchar2_table(376) := '000000360100000b0000005f72656c732f2e72656c73848fcf6ac3300c87ef85bd83d17d51d2c31825762fa590432fa37d00';
    wwv_flow_api.g_varchar2_table(377) := 'e1287f68221bdb1bebdb4f'||wwv_flow.LF||
'c7060abb0884a4eff7a93dfeae8bf9e194e720169aaa06c3e2433fcb68e1763dbf7f82c985a4';
    wwv_flow_api.g_varchar2_table(378) := 'a725085b787086a37bdbb55fbc50d1a33ccd311ba548b6309512'||wwv_flow.LF||
'0f88d94fbc52ae4264d1c910d24a45db3462247fa79171';
    wwv_flow_api.g_varchar2_table(379) := '5fd71f989e19e0364cd3f51652d73760ae8fa8c9ffb3c330cc9e4fc17faf2ce545046e37944c69e462'||wwv_flow.LF||
'a1a82fe353bd90a8';
    wwv_flow_api.g_varchar2_table(380) := '65aad41ed0b5b8f9d6fd010000ffff0300504b0304140006000800000021006b799616830000008a0000001c000000746865';
    wwv_flow_api.g_varchar2_table(381) := '6d652f746865'||wwv_flow.LF||
'6d652f7468656d654d616e616765722e786d6c0ccc4d0ac3201040e17da17790d93763bb284562b2cbaebb';
    wwv_flow_api.g_varchar2_table(382) := 'f600439c1a41c7a0d29fdbd7e5e38337cedf14d59b'||wwv_flow.LF||
'4b0d592c9c070d8a65cd2e88b7f07c2ca71ba8da481cc52c6ce1c715';
    wwv_flow_api.g_varchar2_table(383) := 'e6e97818c9b48d13df49c873517d23d59085adb5dd20d6b52bd521ef2cdd5eb9246a3d8b'||wwv_flow.LF||
'4757e8d3f729e245eb2b260a02';
    wwv_flow_api.g_varchar2_table(384) := '38fd010000ffff0300504b030414000600080000002100d3130843c40600008b1a0000160000007468656d652f7468656d65';
    wwv_flow_api.g_varchar2_table(385) := '2f'||wwv_flow.LF||
'7468656d65312e786d6cec595d8bdb46147d2ff43f08bd3bfe92fcb1c41b6cd9ceb6d94d42eca4e4716c8fadc98e3446';
    wwv_flow_api.g_varchar2_table(386) := '33de8d0981923c160aa569e943037deb'||wwv_flow.LF||
'43691b48a02fe9afd936a54d217fa17746b63c638fbb9b2585a5640d8b343af7ce';
    wwv_flow_api.g_varchar2_table(387) := '997bafce1d4997afdc8fa87384134e58dc708b970aae83e3211b9178d2706f'||wwv_flow.LF||
'f7bbb99aeb7081e211a22cc60d778eb97b65';
    wwv_flow_api.g_varchar2_table(388) := 'f7c30f2ea31d11e2083b601ff31dd4704321a63bf93c1fc230e297d814c7706dcc920809384d26f951828ec16f44'||wwv_flow.LF||
'f3a542';
    wwv_flow_api.g_varchar2_table(389) := 'a1928f10895d274611b8bd311e932176fad2a5bbbb74dea1701a0b2e078634e949d7d8b050d8d1615122f89c0734718e106d';
    wwv_flow_api.g_varchar2_table(390) := 'b830cf881df7f17de13a14'||wwv_flow.LF||
'7101171a6e41fdb9f9ddcb79b4b330a2628bad66d7557f0bbb85c1e8b0a4e64c26836c52cff3';
    wwv_flow_api.g_varchar2_table(391) := 'bd4a33f3af00546ce23ad54ea553c9fc29001a0e61a52917d367'||wwv_flow.LF||
'b514780bac064a0f2dbedbd576b968e035ffe50dce4d5f';
    wwv_flow_api.g_varchar2_table(392) := 'fe0cbc02a5febd0d7cb71b40140dbc02a5787f03efb7eaadb6e95f81527c65035f2d34db5ed5f0af40'||wwv_flow.LF||
'2125f1e106bae057';
    wwv_flow_api.g_varchar2_table(393) := 'cac172b51964cce89e155ef7bd6eb5b470be42413564d525a718b3586cabb508dd6349170012489120b123e6533c4643a8e2';
    wwv_flow_api.g_varchar2_table(394) := '0051324888b3'||wwv_flow.LF||
'4f262114de14c58cc370a154e816caf05ffe3c75a4328a7630d2ac252f60c23786241f870f1332150df763';
    wwv_flow_api.g_varchar2_table(395) := 'f0ea6a90372f7f7cf3f2b973f2e8c5c9a35f4e1e3f'||wwv_flow.LF||
'3e79f473eac8b0da43f144b77afdfd177f3ffdd4f9ebf977af9f7c65';
    wwv_flow_api.g_varchar2_table(396) := 'c7731dfffb4f9ffdf6eb977620ac741582575f3ffbe3c5b357df7cfee70f4f2cf0668206'||wwv_flow.LF||
'3abc4f22cc9debf8d8b9c52258';
    wwv_flow_api.g_varchar2_table(397) := '980a81c91c0f92b7b3e88788e816cd78c2518ce42c16ff1d111ae8eb73449105d7c26604ef24203136e0d5d93d83702f4c66';
    wwv_flow_api.g_varchar2_table(398) := '82'||wwv_flow.LF||
'583c5e0b230378c0186db1c41a856b722e2dccfd593cb14f9ecc74dc2d848e6c73072836f2db994d415b89cd65106283';
    wwv_flow_api.g_varchar2_table(399) := 'e64d8a62812638c6c291d7d821c696d5'||wwv_flow.LF||
'dd25c488eb0119268cb3b170ee12a7858835247d3230aa6965b44722c8cbdc4610';
    wwv_flow_api.g_varchar2_table(400) := 'f26dc4e6e08ed362d4b6ea363e32917057206a21dfc7d408e355341328b2b9'||wwv_flow.LF||
'eca388ea01df4722b491eccd93a18eeb7001';
    wwv_flow_api.g_varchar2_table(401) := '999e60ca9cce08736eb3b991c07ab5a45f0379b1a7fd80ce231399087268f3b98f18d3916d761884289adab03d12'||wwv_flow.LF||
'873af6';
    wwv_flow_api.g_varchar2_table(402) := '237e08258a9c9b4cd8e007ccbc43e439e401c55bd37d876023dda7abc16d50569dd2aa40e4955962c9e555cc8cfaedcde918';
    wwv_flow_api.g_varchar2_table(403) := '61253520fc869e47243e55'||wwv_flow.LF||
'dcd764ddff6f651d84f4d5b74f2dabbaa882de4c88f58eda5b93f16db875f10e583222175fbb';
    wwv_flow_api.g_varchar2_table(404) := 'db6816dfc470bb6c36b0f7d2fd5ebaddffbd746fbb9fdfbd60af'||wwv_flow.LF||
'341ae45b6e15d3adbadab8475bf7ed6342694fcc29dee7';
    wwv_flow_api.g_varchar2_table(405) := '6aebcea1338dba3028edd4332bce9ee3a6211cca3b192630709304291b2761e21322c25e88a6b0bf2f'||wwv_flow.LF||
'bad2c9842f5c4fb8';
    wwv_flow_api.g_varchar2_table(406) := '33651cb6fd6ad8ea5be2e92c3a60a3f471b558948fa6a978702456e3053f1b87470d91a22bd5d52358e65eb19da847e52501';
    wwv_flow_api.g_varchar2_table(407) := '69fb3624b4c9'||wwv_flow.LF||
'4c12650b89ea725006493d9843d02c24d4cade098bba85454dba5fa66a830550cbb2025b2707365c0dd7f7';
    wwv_flow_api.g_varchar2_table(408) := 'c0048ce0890a513c92794a53bdccae4ae6bbccf4b6'||wwv_flow.LF||
'601a1500fb886505ac325d975cb72e4fae2e2db53364da20a1959b49';
    wwv_flow_api.g_varchar2_table(409) := '424546f5301ea2115e54a71c3d0b8db7cd757d9552839e0c859a0f4a6b45a35afb3716e7'||wwv_flow.LF||
'cd35d8ad6b038d75a5a0b173dc';
    wwv_flow_api.g_varchar2_table(410) := '702b651f4a6688a60d770c8ffd70184da176b8dcf2223a8177674391a437fc7994659a70d1463c4c03ae4427558388089c38';
    wwv_flow_api.g_varchar2_table(411) := '94'||wwv_flow.LF||
'440d572e3f4b038d9586286ec51208c28525570759b968e420e96692f1788c87424fbb3622239d9e82c2a75a61bdaacc';
    wwv_flow_api.g_varchar2_table(412) := 'cf0f96966c06e9ee85a363674067c92d'||wwv_flow.LF||
'0425e6578b328023c2e1ed4f318de688c0ebcc4cc856f5b7d69816b2abbf4f5435';
    wwv_flow_api.g_varchar2_table(413) := '948e233a0dd1a2a3e8629ec295946774d4591603ed6cb16608a8169245231c'||wwv_flow.LF||
'4c6483d5836a74d3ac6ba41cb676ddd38d64';
    wwv_flow_api.g_varchar2_table(414) := 'e434d15cf54c435564d7b4ab9831c3b20dacc5f27c4d5e63b50c31689adee153e95e97dcfa52ebd6f60959978080'||wwv_flow.LF||
'67f1b3';
    wwv_flow_api.g_varchar2_table(415) := '74dd3334048dda6a32839a64bc29c352b317a366ef582ef0146a6769129aea57966ed7e296f508eb743078aece0f76eb550b';
    wwv_flow_api.g_varchar2_table(416) := '43e3e5be52455a7df7d03f'||wwv_flow.LF||
'4db0c13d108f36bc049e51c1552ae1c343826043d4537b925436e016b92f16b7061c39b38434';
    wwv_flow_api.g_varchar2_table(417) := 'dc0705bfe905253fc8156a7e27e795bd42aee637cbb9a6ef978b'||wwv_flow.LF||
'1dbf5868b74a0fa1b188302afae937972ebc8aa2f3c597';
    wwv_flow_api.g_varchar2_table(418) := '1735bef1f5255abe6dbb3464519ea9af2b79455c7d7d2996b67f7d710888ce834aa95b2fd75b955cbd'||wwv_flow.LF||
'dcece6bc76ab96ab';
    wwv_flow_api.g_varchar2_table(419) := '079556ae5d09aaed6e3bf06bf5ee43d7395260af590ebc4aa796ab148320e7550a927ead9eab7aa552d3ab366b1daff970b1';
    wwv_flow_api.g_varchar2_table(420) := '8d8195a7f2b1'||wwv_flow.LF||
'88058457f1dafd070000ffff0300504b0304140006000800000021000dd1909fb60000001b010000270000';
    wwv_flow_api.g_varchar2_table(421) := '007468656d652f7468656d652f5f72656c732f7468'||wwv_flow.LF||
'656d654d616e616765722e786d6c2e72656c73848f4d0ac2301484f7';
    wwv_flow_api.g_varchar2_table(422) := '8277086f6fd3ba109126dd88d0add40384e4350d363f2451eced0dae2c082e8761be9969'||wwv_flow.LF||
'bb979dc9136332de3168aa1a08';
    wwv_flow_api.g_varchar2_table(423) := '3ae995719ac16db8ec8e4052164e89d93b64b060828e6f37ed1567914b284d262452282e3198720e274a939cd08a54f980ae';
    wwv_flow_api.g_varchar2_table(424) := '38'||wwv_flow.LF||
'a38f56e422a3a641c8bbd048f7757da0f19b017cc524bd62107bd5001996509affb3fd381a89672f1f165dfe514173d9';
    wwv_flow_api.g_varchar2_table(425) := '850528a2c6cce0239baa4c04ca5bbaba'||wwv_flow.LF||
'c4df000000ffff0300504b01022d0014000600080000002100e9de0fbfff000000';
    wwv_flow_api.g_varchar2_table(426) := '1c0200001300000000000000000000000000000000005b436f6e74656e745f'||wwv_flow.LF||
'54797065735d2e786d6c504b01022d001400';
    wwv_flow_api.g_varchar2_table(427) := '0600080000002100a5d6a7e7c0000000360100000b00000000000000000000000000300100005f72656c732f2e72'||wwv_flow.LF||
'656c73';
    wwv_flow_api.g_varchar2_table(428) := '504b01022d00140006000800000021006b799616830000008a0000001c00000000000000000000000000190200007468656d';
    wwv_flow_api.g_varchar2_table(429) := '652f7468656d652f746865'||wwv_flow.LF||
'6d654d616e616765722e786d6c504b01022d0014000600080000002100d3130843c40600008b';
    wwv_flow_api.g_varchar2_table(430) := '1a00001600000000000000000000000000d60200007468656d65'||wwv_flow.LF||
'2f7468656d652f7468656d65312e786d6c504b01022d00';
    wwv_flow_api.g_varchar2_table(431) := '140006000800000021000dd1909fb60000001b0100002700000000000000000000000000ce0900007468656d652f7468656d';
    wwv_flow_api.g_varchar2_table(432) := '652f5f72656c732f7468656d654d616e616765722e786d6c2e72656c73504b050600000000050005005d010000c90a000000';
    wwv_flow_api.g_varchar2_table(433) := '00}'||wwv_flow.LF||
'{\*\colorschememapping 3c3f786d6c2076657273696f6e3d22312e302220656e636f64696e673d225554462d3822';
    wwv_flow_api.g_varchar2_table(434) := '207374616e64616c6f6e653d22796573223f3e0d0a3c613a636c724d'||wwv_flow.LF||
'617020786d6c6e733a613d22687474703a2f2f7363';
    wwv_flow_api.g_varchar2_table(435) := '68656d61732e6f70656e786d6c666f726d6174732e6f72672f64726177696e676d6c2f323030362f6d6169'||wwv_flow.LF||
'6e2220626731';
    wwv_flow_api.g_varchar2_table(436) := '3d226c743122207478313d22646b3122206267323d226c743222207478323d22646b322220616363656e74313d2261636365';
    wwv_flow_api.g_varchar2_table(437) := '6e74312220616363'||wwv_flow.LF||
'656e74323d22616363656e74322220616363656e74333d22616363656e74332220616363656e74343d';
    wwv_flow_api.g_varchar2_table(438) := '22616363656e74342220616363656e74353d22616363656e74352220616363656e74363d22616363656e74362220686c696e';
    wwv_flow_api.g_varchar2_table(439) := '6b3d22686c696e6b2220666f6c486c696e6b3d22666f6c486c696e6b222f3e}'||wwv_flow.LF||
'{\*\latentstyles\lsdstimax376\lsdlo';
    wwv_flow_api.g_varchar2_table(440) := 'ckeddef0\lsdsemihiddendef0\lsdunhideuseddef0\lsdqformatdef0\lsdprioritydef99{\lsdlockedexcept \lsdqf';
    wwv_flow_api.g_varchar2_table(441) := 'ormat1 \lsdpriority0 \lsdlocked0 Normal;\lsdqformat1 \lsdpriority9 \lsdlocked0 heading 1;'||wwv_flow.LF||
'\lsdsemih';
    wwv_flow_api.g_varchar2_table(442) := 'idden1 \lsdunhideused1 \lsdqformat1 \lsdpriority9 \lsdlocked0 heading 2;\lsdsemihidden1 \lsdunhideus';
    wwv_flow_api.g_varchar2_table(443) := 'ed1 \lsdqformat1 \lsdpriority9 \lsdlocked0 heading 3;\lsdsemihidden1 \lsdunhideused1 \lsdqformat1 \l';
    wwv_flow_api.g_varchar2_table(444) := 'sdpriority9 \lsdlocked0 heading 4;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdqformat1 \lsdpriority9 \lsdl';
    wwv_flow_api.g_varchar2_table(445) := 'ocked0 heading 5;\lsdsemihidden1 \lsdunhideused1 \lsdqformat1 \lsdpriority9 \lsdlocked0 heading 6;\l';
    wwv_flow_api.g_varchar2_table(446) := 'sdsemihidden1 \lsdunhideused1 \lsdqformat1 \lsdpriority9 \lsdlocked0 heading 7;'||wwv_flow.LF||
'\lsdsemihidden1 \ls';
    wwv_flow_api.g_varchar2_table(447) := 'dunhideused1 \lsdqformat1 \lsdpriority9 \lsdlocked0 heading 8;\lsdsemihidden1 \lsdunhideused1 \lsdqf';
    wwv_flow_api.g_varchar2_table(448) := 'ormat1 \lsdpriority9 \lsdlocked0 heading 9;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 index 1;'||wwv_flow.LF||
'\ls';
    wwv_flow_api.g_varchar2_table(449) := 'dsemihidden1 \lsdunhideused1 \lsdlocked0 index 2;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 index 3';
    wwv_flow_api.g_varchar2_table(450) := ';\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 index 4;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 ind';
    wwv_flow_api.g_varchar2_table(451) := 'ex 5;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 index 6;\lsdsemihidden1 \lsdunhideused1 \lsdlocke';
    wwv_flow_api.g_varchar2_table(452) := 'd0 index 7;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 index 8;\lsdsemihidden1 \lsdunhideused1 \lsdl';
    wwv_flow_api.g_varchar2_table(453) := 'ocked0 index 9;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdpriority39 \lsdlocked0 toc 1;\lsdsemihidden1 \l';
    wwv_flow_api.g_varchar2_table(454) := 'sdunhideused1 \lsdpriority39 \lsdlocked0 toc 2;\lsdsemihidden1 \lsdunhideused1 \lsdpriority39 \lsdlo';
    wwv_flow_api.g_varchar2_table(455) := 'cked0 toc 3;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdpriority39 \lsdlocked0 toc 4;\lsdsemihidden1 \lsdu';
    wwv_flow_api.g_varchar2_table(456) := 'nhideused1 \lsdpriority39 \lsdlocked0 toc 5;\lsdsemihidden1 \lsdunhideused1 \lsdpriority39 \lsdlocke';
    wwv_flow_api.g_varchar2_table(457) := 'd0 toc 6;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdpriority39 \lsdlocked0 toc 7;\lsdsemihidden1 \lsdunhi';
    wwv_flow_api.g_varchar2_table(458) := 'deused1 \lsdpriority39 \lsdlocked0 toc 8;\lsdsemihidden1 \lsdunhideused1 \lsdpriority39 \lsdlocked0 ';
    wwv_flow_api.g_varchar2_table(459) := 'toc 9;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Normal Indent;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \l';
    wwv_flow_api.g_varchar2_table(460) := 'sdlocked0 footnote text;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 annotation text;\lsdsemihidden1 ';
    wwv_flow_api.g_varchar2_table(461) := '\lsdunhideused1 \lsdlocked0 header;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 footer;'||wwv_flow.LF||
'\lsdsemihidd';
    wwv_flow_api.g_varchar2_table(462) := 'en1 \lsdunhideused1 \lsdlocked0 index heading;\lsdsemihidden1 \lsdunhideused1 \lsdqformat1 \lsdprior';
    wwv_flow_api.g_varchar2_table(463) := 'ity35 \lsdlocked0 caption;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 table of figures;'||wwv_flow.LF||
'\lsdsemihid';
    wwv_flow_api.g_varchar2_table(464) := 'den1 \lsdunhideused1 \lsdlocked0 envelope address;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 envelo';
    wwv_flow_api.g_varchar2_table(465) := 'pe return;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 footnote reference;\lsdsemihidden1 \lsdunhideu';
    wwv_flow_api.g_varchar2_table(466) := 'sed1 \lsdlocked0 annotation reference;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 line number;\lsd';
    wwv_flow_api.g_varchar2_table(467) := 'semihidden1 \lsdunhideused1 \lsdlocked0 page number;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 endn';
    wwv_flow_api.g_varchar2_table(468) := 'ote reference;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 endnote text;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideu';
    wwv_flow_api.g_varchar2_table(469) := 'sed1 \lsdlocked0 table of authorities;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 macro;\lsdsemihidd';
    wwv_flow_api.g_varchar2_table(470) := 'en1 \lsdunhideused1 \lsdlocked0 toa heading;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List;'||wwv_flow.LF||
'\lsds';
    wwv_flow_api.g_varchar2_table(471) := 'emihidden1 \lsdunhideused1 \lsdlocked0 List Bullet;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List ';
    wwv_flow_api.g_varchar2_table(472) := 'Number;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List 2;\lsdsemihidden1 \lsdunhideused1 \lsdlocked';
    wwv_flow_api.g_varchar2_table(473) := '0 List 3;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List 4;\lsdsemihidden1 \lsdunhideused1 \lsdlo';
    wwv_flow_api.g_varchar2_table(474) := 'cked0 List 5;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Bullet 2;\lsdsemihidden1 \lsdunhideuse';
    wwv_flow_api.g_varchar2_table(475) := 'd1 \lsdlocked0 List Bullet 3;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Bullet 4;\lsdsemihid';
    wwv_flow_api.g_varchar2_table(476) := 'den1 \lsdunhideused1 \lsdlocked0 List Bullet 5;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Numb';
    wwv_flow_api.g_varchar2_table(477) := 'er 2;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Number 3;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \ls';
    wwv_flow_api.g_varchar2_table(478) := 'dlocked0 List Number 4;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Number 5;\lsdqformat1 \lsdpr';
    wwv_flow_api.g_varchar2_table(479) := 'iority10 \lsdlocked0 Title;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Closing;'||wwv_flow.LF||
'\lsdsemihidden1 \ls';
    wwv_flow_api.g_varchar2_table(480) := 'dunhideused1 \lsdlocked0 Signature;\lsdsemihidden1 \lsdunhideused1 \lsdpriority1 \lsdlocked0 Default';
    wwv_flow_api.g_varchar2_table(481) := ' Paragraph Font;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Body Text;\lsdsemihidden1 \lsdunhideused';
    wwv_flow_api.g_varchar2_table(482) := '1 \lsdlocked0 Body Text Indent;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Continue;\lsdsemih';
    wwv_flow_api.g_varchar2_table(483) := 'idden1 \lsdunhideused1 \lsdlocked0 List Continue 2;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List ';
    wwv_flow_api.g_varchar2_table(484) := 'Continue 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Continue 4;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideu';
    wwv_flow_api.g_varchar2_table(485) := 'sed1 \lsdlocked0 List Continue 5;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Message Header;\lsdqfor';
    wwv_flow_api.g_varchar2_table(486) := 'mat1 \lsdpriority11 \lsdlocked0 Subtitle;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Salutation;'||wwv_flow.LF||
'\l';
    wwv_flow_api.g_varchar2_table(487) := 'sdsemihidden1 \lsdunhideused1 \lsdlocked0 Date;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Body Text';
    wwv_flow_api.g_varchar2_table(488) := ' First Indent;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Body Text First Indent 2;\lsdsemihidden1 \';
    wwv_flow_api.g_varchar2_table(489) := 'lsdunhideused1 \lsdlocked0 Note Heading;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Body Text 2;\l';
    wwv_flow_api.g_varchar2_table(490) := 'sdsemihidden1 \lsdunhideused1 \lsdlocked0 Body Text 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Bo';
    wwv_flow_api.g_varchar2_table(491) := 'dy Text Indent 2;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Body Text Indent 3;'||wwv_flow.LF||
'\lsdsemihidden1 \l';
    wwv_flow_api.g_varchar2_table(492) := 'sdunhideused1 \lsdlocked0 Block Text;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Hyperlink;\lsdsemih';
    wwv_flow_api.g_varchar2_table(493) := 'idden1 \lsdunhideused1 \lsdlocked0 FollowedHyperlink;\lsdqformat1 \lsdpriority22 \lsdlocked0 Strong;';
    wwv_flow_api.g_varchar2_table(494) := ''||wwv_flow.LF||
'\lsdqformat1 \lsdpriority20 \lsdlocked0 Emphasis;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Docum';
    wwv_flow_api.g_varchar2_table(495) := 'ent Map;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Plain Text;\lsdsemihidden1 \lsdunhideused1 \lsdl';
    wwv_flow_api.g_varchar2_table(496) := 'ocked0 E-mail Signature;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTML Top of Form;\lsdsemihidde';
    wwv_flow_api.g_varchar2_table(497) := 'n1 \lsdunhideused1 \lsdlocked0 HTML Bottom of Form;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Norma';
    wwv_flow_api.g_varchar2_table(498) := 'l (Web);\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTML Acronym;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \';
    wwv_flow_api.g_varchar2_table(499) := 'lsdlocked0 HTML Address;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTML Cite;\lsdsemihidden1 \lsdun';
    wwv_flow_api.g_varchar2_table(500) := 'hideused1 \lsdlocked0 HTML Code;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTML Definition;'||wwv_flow.LF||
'\lsdse';
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
    wwv_flow_api.g_varchar2_table(501) := 'mihidden1 \lsdunhideused1 \lsdlocked0 HTML Keyboard;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTML';
    wwv_flow_api.g_varchar2_table(502) := ' Preformatted;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTML Sample;\lsdsemihidden1 \lsdunhideused';
    wwv_flow_api.g_varchar2_table(503) := '1 \lsdlocked0 HTML Typewriter;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTML Variable;\lsdsemihi';
    wwv_flow_api.g_varchar2_table(504) := 'dden1 \lsdunhideused1 \lsdlocked0 Normal Table;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 annotatio';
    wwv_flow_api.g_varchar2_table(505) := 'n subject;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 No List;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsd';
    wwv_flow_api.g_varchar2_table(506) := 'locked0 Outline List 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Outline List 2;\lsdsemihidden1 \l';
    wwv_flow_api.g_varchar2_table(507) := 'sdunhideused1 \lsdlocked0 Outline List 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Simple 1;';
    wwv_flow_api.g_varchar2_table(508) := ''||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Simple 2;\lsdsemihidden1 \lsdunhideused1 \lsdloc';
    wwv_flow_api.g_varchar2_table(509) := 'ked0 Table Simple 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Classic 1;\lsdsemihidden1 \lsd';
    wwv_flow_api.g_varchar2_table(510) := 'unhideused1 \lsdlocked0 Table Classic 2;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Classic ';
    wwv_flow_api.g_varchar2_table(511) := '3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Classic 4;\lsdsemihidden1 \lsdunhideused1 \lsdlo';
    wwv_flow_api.g_varchar2_table(512) := 'cked0 Table Colorful 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Colorful 2;'||wwv_flow.LF||
'\lsdsemihidden';
    wwv_flow_api.g_varchar2_table(513) := '1 \lsdunhideused1 \lsdlocked0 Table Colorful 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Col';
    wwv_flow_api.g_varchar2_table(514) := 'umns 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Columns 2;\lsdsemihidden1 \lsdunhideused1 \';
    wwv_flow_api.g_varchar2_table(515) := 'lsdlocked0 Table Columns 3;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Columns 4;\lsdsemihid';
    wwv_flow_api.g_varchar2_table(516) := 'den1 \lsdunhideused1 \lsdlocked0 Table Columns 5;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table G';
    wwv_flow_api.g_varchar2_table(517) := 'rid 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Grid 2;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \ls';
    wwv_flow_api.g_varchar2_table(518) := 'dlocked0 Table Grid 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Grid 4;\lsdsemihidden1 \lsdu';
    wwv_flow_api.g_varchar2_table(519) := 'nhideused1 \lsdlocked0 Table Grid 5;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Grid 6;'||wwv_flow.LF||
'\lsds';
    wwv_flow_api.g_varchar2_table(520) := 'emihidden1 \lsdunhideused1 \lsdlocked0 Table Grid 7;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Tabl';
    wwv_flow_api.g_varchar2_table(521) := 'e Grid 8;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table List 1;\lsdsemihidden1 \lsdunhideused1 \l';
    wwv_flow_api.g_varchar2_table(522) := 'sdlocked0 Table List 2;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table List 3;\lsdsemihidden1 \l';
    wwv_flow_api.g_varchar2_table(523) := 'sdunhideused1 \lsdlocked0 Table List 4;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table List 5;\lsd';
    wwv_flow_api.g_varchar2_table(524) := 'semihidden1 \lsdunhideused1 \lsdlocked0 Table List 6;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 T';
    wwv_flow_api.g_varchar2_table(525) := 'able List 7;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table List 8;\lsdsemihidden1 \lsdunhideused1';
    wwv_flow_api.g_varchar2_table(526) := ' \lsdlocked0 Table 3D effects 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table 3D effects 2;'||wwv_flow.LF||
'\ls';
    wwv_flow_api.g_varchar2_table(527) := 'dsemihidden1 \lsdunhideused1 \lsdlocked0 Table 3D effects 3;\lsdsemihidden1 \lsdunhideused1 \lsdlock';
    wwv_flow_api.g_varchar2_table(528) := 'ed0 Table Contemporary;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Elegant;\lsdsemihidden1 \ls';
    wwv_flow_api.g_varchar2_table(529) := 'dunhideused1 \lsdlocked0 Table Professional;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Subt';
    wwv_flow_api.g_varchar2_table(530) := 'le 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Subtle 2;\lsdsemihidden1 \lsdunhideused1 \lsd';
    wwv_flow_api.g_varchar2_table(531) := 'locked0 Table Web 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Web 2;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdun';
    wwv_flow_api.g_varchar2_table(532) := 'hideused1 \lsdlocked0 Table Web 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Balloon Text;\lsdprior';
    wwv_flow_api.g_varchar2_table(533) := 'ity39 \lsdlocked0 Table Grid;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Theme;\lsdsemihidden1';
    wwv_flow_api.g_varchar2_table(534) := ' \lsdlocked0 Placeholder Text;'||wwv_flow.LF||
'\lsdqformat1 \lsdpriority1 \lsdlocked0 No Spacing;\lsdpriority60 \ls';
    wwv_flow_api.g_varchar2_table(535) := 'dlocked0 Light Shading;\lsdpriority61 \lsdlocked0 Light List;\lsdpriority62 \lsdlocked0 Light Grid;\';
    wwv_flow_api.g_varchar2_table(536) := 'lsdpriority63 \lsdlocked0 Medium Shading 1;\lsdpriority64 \lsdlocked0 Medium Shading 2;'||wwv_flow.LF||
'\lsdpriorit';
    wwv_flow_api.g_varchar2_table(537) := 'y65 \lsdlocked0 Medium List 1;\lsdpriority66 \lsdlocked0 Medium List 2;\lsdpriority67 \lsdlocked0 Me';
    wwv_flow_api.g_varchar2_table(538) := 'dium Grid 1;\lsdpriority68 \lsdlocked0 Medium Grid 2;\lsdpriority69 \lsdlocked0 Medium Grid 3;\lsdpr';
    wwv_flow_api.g_varchar2_table(539) := 'iority70 \lsdlocked0 Dark List;'||wwv_flow.LF||
'\lsdpriority71 \lsdlocked0 Colorful Shading;\lsdpriority72 \lsdlock';
    wwv_flow_api.g_varchar2_table(540) := 'ed0 Colorful List;\lsdpriority73 \lsdlocked0 Colorful Grid;\lsdpriority60 \lsdlocked0 Light Shading ';
    wwv_flow_api.g_varchar2_table(541) := 'Accent 1;\lsdpriority61 \lsdlocked0 Light List Accent 1;'||wwv_flow.LF||
'\lsdpriority62 \lsdlocked0 Light Grid Acce';
    wwv_flow_api.g_varchar2_table(542) := 'nt 1;\lsdpriority63 \lsdlocked0 Medium Shading 1 Accent 1;\lsdpriority64 \lsdlocked0 Medium Shading ';
    wwv_flow_api.g_varchar2_table(543) := '2 Accent 1;\lsdpriority65 \lsdlocked0 Medium List 1 Accent 1;\lsdsemihidden1 \lsdlocked0 Revision;'||wwv_flow.LF||
'';
    wwv_flow_api.g_varchar2_table(544) := '\lsdqformat1 \lsdpriority34 \lsdlocked0 List Paragraph;\lsdqformat1 \lsdpriority29 \lsdlocked0 Quote';
    wwv_flow_api.g_varchar2_table(545) := ';\lsdqformat1 \lsdpriority30 \lsdlocked0 Intense Quote;\lsdpriority66 \lsdlocked0 Medium List 2 Acce';
    wwv_flow_api.g_varchar2_table(546) := 'nt 1;\lsdpriority67 \lsdlocked0 Medium Grid 1 Accent 1;'||wwv_flow.LF||
'\lsdpriority68 \lsdlocked0 Medium Grid 2 Ac';
    wwv_flow_api.g_varchar2_table(547) := 'cent 1;\lsdpriority69 \lsdlocked0 Medium Grid 3 Accent 1;\lsdpriority70 \lsdlocked0 Dark List Accent';
    wwv_flow_api.g_varchar2_table(548) := ' 1;\lsdpriority71 \lsdlocked0 Colorful Shading Accent 1;\lsdpriority72 \lsdlocked0 Colorful List Acc';
    wwv_flow_api.g_varchar2_table(549) := 'ent 1;'||wwv_flow.LF||
'\lsdpriority73 \lsdlocked0 Colorful Grid Accent 1;\lsdpriority60 \lsdlocked0 Light Shading A';
    wwv_flow_api.g_varchar2_table(550) := 'ccent 2;\lsdpriority61 \lsdlocked0 Light List Accent 2;\lsdpriority62 \lsdlocked0 Light Grid Accent ';
    wwv_flow_api.g_varchar2_table(551) := '2;\lsdpriority63 \lsdlocked0 Medium Shading 1 Accent 2;'||wwv_flow.LF||
'\lsdpriority64 \lsdlocked0 Medium Shading 2';
    wwv_flow_api.g_varchar2_table(552) := ' Accent 2;\lsdpriority65 \lsdlocked0 Medium List 1 Accent 2;\lsdpriority66 \lsdlocked0 Medium List 2';
    wwv_flow_api.g_varchar2_table(553) := ' Accent 2;\lsdpriority67 \lsdlocked0 Medium Grid 1 Accent 2;\lsdpriority68 \lsdlocked0 Medium Grid 2';
    wwv_flow_api.g_varchar2_table(554) := ' Accent 2;'||wwv_flow.LF||
'\lsdpriority69 \lsdlocked0 Medium Grid 3 Accent 2;\lsdpriority70 \lsdlocked0 Dark List A';
    wwv_flow_api.g_varchar2_table(555) := 'ccent 2;\lsdpriority71 \lsdlocked0 Colorful Shading Accent 2;\lsdpriority72 \lsdlocked0 Colorful Lis';
    wwv_flow_api.g_varchar2_table(556) := 't Accent 2;\lsdpriority73 \lsdlocked0 Colorful Grid Accent 2;'||wwv_flow.LF||
'\lsdpriority60 \lsdlocked0 Light Shad';
    wwv_flow_api.g_varchar2_table(557) := 'ing Accent 3;\lsdpriority61 \lsdlocked0 Light List Accent 3;\lsdpriority62 \lsdlocked0 Light Grid Ac';
    wwv_flow_api.g_varchar2_table(558) := 'cent 3;\lsdpriority63 \lsdlocked0 Medium Shading 1 Accent 3;\lsdpriority64 \lsdlocked0 Medium Shadin';
    wwv_flow_api.g_varchar2_table(559) := 'g 2 Accent 3;'||wwv_flow.LF||
'\lsdpriority65 \lsdlocked0 Medium List 1 Accent 3;\lsdpriority66 \lsdlocked0 Medium L';
    wwv_flow_api.g_varchar2_table(560) := 'ist 2 Accent 3;\lsdpriority67 \lsdlocked0 Medium Grid 1 Accent 3;\lsdpriority68 \lsdlocked0 Medium G';
    wwv_flow_api.g_varchar2_table(561) := 'rid 2 Accent 3;\lsdpriority69 \lsdlocked0 Medium Grid 3 Accent 3;'||wwv_flow.LF||
'\lsdpriority70 \lsdlocked0 Dark L';
    wwv_flow_api.g_varchar2_table(562) := 'ist Accent 3;\lsdpriority71 \lsdlocked0 Colorful Shading Accent 3;\lsdpriority72 \lsdlocked0 Colorfu';
    wwv_flow_api.g_varchar2_table(563) := 'l List Accent 3;\lsdpriority73 \lsdlocked0 Colorful Grid Accent 3;\lsdpriority60 \lsdlocked0 Light S';
    wwv_flow_api.g_varchar2_table(564) := 'hading Accent 4;'||wwv_flow.LF||
'\lsdpriority61 \lsdlocked0 Light List Accent 4;\lsdpriority62 \lsdlocked0 Light Gr';
    wwv_flow_api.g_varchar2_table(565) := 'id Accent 4;\lsdpriority63 \lsdlocked0 Medium Shading 1 Accent 4;\lsdpriority64 \lsdlocked0 Medium S';
    wwv_flow_api.g_varchar2_table(566) := 'hading 2 Accent 4;\lsdpriority65 \lsdlocked0 Medium List 1 Accent 4;'||wwv_flow.LF||
'\lsdpriority66 \lsdlocked0 Med';
    wwv_flow_api.g_varchar2_table(567) := 'ium List 2 Accent 4;\lsdpriority67 \lsdlocked0 Medium Grid 1 Accent 4;\lsdpriority68 \lsdlocked0 Med';
    wwv_flow_api.g_varchar2_table(568) := 'ium Grid 2 Accent 4;\lsdpriority69 \lsdlocked0 Medium Grid 3 Accent 4;\lsdpriority70 \lsdlocked0 Dar';
    wwv_flow_api.g_varchar2_table(569) := 'k List Accent 4;'||wwv_flow.LF||
'\lsdpriority71 \lsdlocked0 Colorful Shading Accent 4;\lsdpriority72 \lsdlocked0 Co';
    wwv_flow_api.g_varchar2_table(570) := 'lorful List Accent 4;\lsdpriority73 \lsdlocked0 Colorful Grid Accent 4;\lsdpriority60 \lsdlocked0 Li';
    wwv_flow_api.g_varchar2_table(571) := 'ght Shading Accent 5;\lsdpriority61 \lsdlocked0 Light List Accent 5;'||wwv_flow.LF||
'\lsdpriority62 \lsdlocked0 Lig';
    wwv_flow_api.g_varchar2_table(572) := 'ht Grid Accent 5;\lsdpriority63 \lsdlocked0 Medium Shading 1 Accent 5;\lsdpriority64 \lsdlocked0 Med';
    wwv_flow_api.g_varchar2_table(573) := 'ium Shading 2 Accent 5;\lsdpriority65 \lsdlocked0 Medium List 1 Accent 5;\lsdpriority66 \lsdlocked0 ';
    wwv_flow_api.g_varchar2_table(574) := 'Medium List 2 Accent 5;'||wwv_flow.LF||
'\lsdpriority67 \lsdlocked0 Medium Grid 1 Accent 5;\lsdpriority68 \lsdlocked';
    wwv_flow_api.g_varchar2_table(575) := '0 Medium Grid 2 Accent 5;\lsdpriority69 \lsdlocked0 Medium Grid 3 Accent 5;\lsdpriority70 \lsdlocked';
    wwv_flow_api.g_varchar2_table(576) := '0 Dark List Accent 5;\lsdpriority71 \lsdlocked0 Colorful Shading Accent 5;'||wwv_flow.LF||
'\lsdpriority72 \lsdlocke';
    wwv_flow_api.g_varchar2_table(577) := 'd0 Colorful List Accent 5;\lsdpriority73 \lsdlocked0 Colorful Grid Accent 5;\lsdpriority60 \lsdlocke';
    wwv_flow_api.g_varchar2_table(578) := 'd0 Light Shading Accent 6;\lsdpriority61 \lsdlocked0 Light List Accent 6;\lsdpriority62 \lsdlocked0 ';
    wwv_flow_api.g_varchar2_table(579) := 'Light Grid Accent 6;'||wwv_flow.LF||
'\lsdpriority63 \lsdlocked0 Medium Shading 1 Accent 6;\lsdpriority64 \lsdlocked';
    wwv_flow_api.g_varchar2_table(580) := '0 Medium Shading 2 Accent 6;\lsdpriority65 \lsdlocked0 Medium List 1 Accent 6;\lsdpriority66 \lsdloc';
    wwv_flow_api.g_varchar2_table(581) := 'ked0 Medium List 2 Accent 6;'||wwv_flow.LF||
'\lsdpriority67 \lsdlocked0 Medium Grid 1 Accent 6;\lsdpriority68 \lsdl';
    wwv_flow_api.g_varchar2_table(582) := 'ocked0 Medium Grid 2 Accent 6;\lsdpriority69 \lsdlocked0 Medium Grid 3 Accent 6;\lsdpriority70 \lsdl';
    wwv_flow_api.g_varchar2_table(583) := 'ocked0 Dark List Accent 6;\lsdpriority71 \lsdlocked0 Colorful Shading Accent 6;'||wwv_flow.LF||
'\lsdpriority72 \lsd';
    wwv_flow_api.g_varchar2_table(584) := 'locked0 Colorful List Accent 6;\lsdpriority73 \lsdlocked0 Colorful Grid Accent 6;\lsdqformat1 \lsdpr';
    wwv_flow_api.g_varchar2_table(585) := 'iority19 \lsdlocked0 Subtle Emphasis;\lsdqformat1 \lsdpriority21 \lsdlocked0 Intense Emphasis;'||wwv_flow.LF||
'\lsd';
    wwv_flow_api.g_varchar2_table(586) := 'qformat1 \lsdpriority31 \lsdlocked0 Subtle Reference;\lsdqformat1 \lsdpriority32 \lsdlocked0 Intense';
    wwv_flow_api.g_varchar2_table(587) := ' Reference;\lsdqformat1 \lsdpriority33 \lsdlocked0 Book Title;\lsdsemihidden1 \lsdunhideused1 \lsdpr';
    wwv_flow_api.g_varchar2_table(588) := 'iority37 \lsdlocked0 Bibliography;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdqformat1 \lsdpriority39 \lsd';
    wwv_flow_api.g_varchar2_table(589) := 'locked0 TOC Heading;\lsdpriority41 \lsdlocked0 Plain Table 1;\lsdpriority42 \lsdlocked0 Plain Table ';
    wwv_flow_api.g_varchar2_table(590) := '2;\lsdpriority43 \lsdlocked0 Plain Table 3;\lsdpriority44 \lsdlocked0 Plain Table 4;'||wwv_flow.LF||
'\lsdpriority45';
    wwv_flow_api.g_varchar2_table(591) := ' \lsdlocked0 Plain Table 5;\lsdpriority40 \lsdlocked0 Grid Table Light;\lsdpriority46 \lsdlocked0 Gr';
    wwv_flow_api.g_varchar2_table(592) := 'id Table 1 Light;\lsdpriority47 \lsdlocked0 Grid Table 2;\lsdpriority48 \lsdlocked0 Grid Table 3;\ls';
    wwv_flow_api.g_varchar2_table(593) := 'dpriority49 \lsdlocked0 Grid Table 4;'||wwv_flow.LF||
'\lsdpriority50 \lsdlocked0 Grid Table 5 Dark;\lsdpriority51 \';
    wwv_flow_api.g_varchar2_table(594) := 'lsdlocked0 Grid Table 6 Colorful;\lsdpriority52 \lsdlocked0 Grid Table 7 Colorful;\lsdpriority46 \ls';
    wwv_flow_api.g_varchar2_table(595) := 'dlocked0 Grid Table 1 Light Accent 1;\lsdpriority47 \lsdlocked0 Grid Table 2 Accent 1;'||wwv_flow.LF||
'\lsdpriority';
    wwv_flow_api.g_varchar2_table(596) := '48 \lsdlocked0 Grid Table 3 Accent 1;\lsdpriority49 \lsdlocked0 Grid Table 4 Accent 1;\lsdpriority50';
    wwv_flow_api.g_varchar2_table(597) := ' \lsdlocked0 Grid Table 5 Dark Accent 1;\lsdpriority51 \lsdlocked0 Grid Table 6 Colorful Accent 1;'||wwv_flow.LF||
'';
    wwv_flow_api.g_varchar2_table(598) := '\lsdpriority52 \lsdlocked0 Grid Table 7 Colorful Accent 1;\lsdpriority46 \lsdlocked0 Grid Table 1 Li';
    wwv_flow_api.g_varchar2_table(599) := 'ght Accent 2;\lsdpriority47 \lsdlocked0 Grid Table 2 Accent 2;\lsdpriority48 \lsdlocked0 Grid Table ';
    wwv_flow_api.g_varchar2_table(600) := '3 Accent 2;'||wwv_flow.LF||
'\lsdpriority49 \lsdlocked0 Grid Table 4 Accent 2;\lsdpriority50 \lsdlocked0 Grid Table ';
    wwv_flow_api.g_varchar2_table(601) := '5 Dark Accent 2;\lsdpriority51 \lsdlocked0 Grid Table 6 Colorful Accent 2;\lsdpriority52 \lsdlocked0';
    wwv_flow_api.g_varchar2_table(602) := ' Grid Table 7 Colorful Accent 2;'||wwv_flow.LF||
'\lsdpriority46 \lsdlocked0 Grid Table 1 Light Accent 3;\lsdpriorit';
    wwv_flow_api.g_varchar2_table(603) := 'y47 \lsdlocked0 Grid Table 2 Accent 3;\lsdpriority48 \lsdlocked0 Grid Table 3 Accent 3;\lsdpriority4';
    wwv_flow_api.g_varchar2_table(604) := '9 \lsdlocked0 Grid Table 4 Accent 3;'||wwv_flow.LF||
'\lsdpriority50 \lsdlocked0 Grid Table 5 Dark Accent 3;\lsdprio';
    wwv_flow_api.g_varchar2_table(605) := 'rity51 \lsdlocked0 Grid Table 6 Colorful Accent 3;\lsdpriority52 \lsdlocked0 Grid Table 7 Colorful A';
    wwv_flow_api.g_varchar2_table(606) := 'ccent 3;\lsdpriority46 \lsdlocked0 Grid Table 1 Light Accent 4;'||wwv_flow.LF||
'\lsdpriority47 \lsdlocked0 Grid Tab';
    wwv_flow_api.g_varchar2_table(607) := 'le 2 Accent 4;\lsdpriority48 \lsdlocked0 Grid Table 3 Accent 4;\lsdpriority49 \lsdlocked0 Grid Table';
    wwv_flow_api.g_varchar2_table(608) := ' 4 Accent 4;\lsdpriority50 \lsdlocked0 Grid Table 5 Dark Accent 4;'||wwv_flow.LF||
'\lsdpriority51 \lsdlocked0 Grid ';
    wwv_flow_api.g_varchar2_table(609) := 'Table 6 Colorful Accent 4;\lsdpriority52 \lsdlocked0 Grid Table 7 Colorful Accent 4;\lsdpriority46 \';
    wwv_flow_api.g_varchar2_table(610) := 'lsdlocked0 Grid Table 1 Light Accent 5;\lsdpriority47 \lsdlocked0 Grid Table 2 Accent 5;'||wwv_flow.LF||
'\lsdpriori';
    wwv_flow_api.g_varchar2_table(611) := 'ty48 \lsdlocked0 Grid Table 3 Accent 5;\lsdpriority49 \lsdlocked0 Grid Table 4 Accent 5;\lsdpriority';
    wwv_flow_api.g_varchar2_table(612) := '50 \lsdlocked0 Grid Table 5 Dark Accent 5;\lsdpriority51 \lsdlocked0 Grid Table 6 Colorful Accent 5;';
    wwv_flow_api.g_varchar2_table(613) := ''||wwv_flow.LF||
'\lsdpriority52 \lsdlocked0 Grid Table 7 Colorful Accent 5;\lsdpriority46 \lsdlocked0 Grid Table 1 ';
    wwv_flow_api.g_varchar2_table(614) := 'Light Accent 6;\lsdpriority47 \lsdlocked0 Grid Table 2 Accent 6;\lsdpriority48 \lsdlocked0 Grid Tabl';
    wwv_flow_api.g_varchar2_table(615) := 'e 3 Accent 6;'||wwv_flow.LF||
'\lsdpriority49 \lsdlocked0 Grid Table 4 Accent 6;\lsdpriority50 \lsdlocked0 Grid Tabl';
    wwv_flow_api.g_varchar2_table(616) := 'e 5 Dark Accent 6;\lsdpriority51 \lsdlocked0 Grid Table 6 Colorful Accent 6;\lsdpriority52 \lsdlocke';
    wwv_flow_api.g_varchar2_table(617) := 'd0 Grid Table 7 Colorful Accent 6;'||wwv_flow.LF||
'\lsdpriority46 \lsdlocked0 List Table 1 Light;\lsdpriority47 \ls';
    wwv_flow_api.g_varchar2_table(618) := 'dlocked0 List Table 2;\lsdpriority48 \lsdlocked0 List Table 3;\lsdpriority49 \lsdlocked0 List Table ';
    wwv_flow_api.g_varchar2_table(619) := '4;\lsdpriority50 \lsdlocked0 List Table 5 Dark;'||wwv_flow.LF||
'\lsdpriority51 \lsdlocked0 List Table 6 Colorful;\l';
    wwv_flow_api.g_varchar2_table(620) := 'sdpriority52 \lsdlocked0 List Table 7 Colorful;\lsdpriority46 \lsdlocked0 List Table 1 Light Accent ';
    wwv_flow_api.g_varchar2_table(621) := '1;\lsdpriority47 \lsdlocked0 List Table 2 Accent 1;\lsdpriority48 \lsdlocked0 List Table 3 Accent 1;';
    wwv_flow_api.g_varchar2_table(622) := ''||wwv_flow.LF||
'\lsdpriority49 \lsdlocked0 List Table 4 Accent 1;\lsdpriority50 \lsdlocked0 List Table 5 Dark Acce';
    wwv_flow_api.g_varchar2_table(623) := 'nt 1;\lsdpriority51 \lsdlocked0 List Table 6 Colorful Accent 1;\lsdpriority52 \lsdlocked0 List Table';
    wwv_flow_api.g_varchar2_table(624) := ' 7 Colorful Accent 1;'||wwv_flow.LF||
'\lsdpriority46 \lsdlocked0 List Table 1 Light Accent 2;\lsdpriority47 \lsdloc';
    wwv_flow_api.g_varchar2_table(625) := 'ked0 List Table 2 Accent 2;\lsdpriority48 \lsdlocked0 List Table 3 Accent 2;\lsdpriority49 \lsdlocke';
    wwv_flow_api.g_varchar2_table(626) := 'd0 List Table 4 Accent 2;'||wwv_flow.LF||
'\lsdpriority50 \lsdlocked0 List Table 5 Dark Accent 2;\lsdpriority51 \lsd';
    wwv_flow_api.g_varchar2_table(627) := 'locked0 List Table 6 Colorful Accent 2;\lsdpriority52 \lsdlocked0 List Table 7 Colorful Accent 2;\ls';
    wwv_flow_api.g_varchar2_table(628) := 'dpriority46 \lsdlocked0 List Table 1 Light Accent 3;'||wwv_flow.LF||
'\lsdpriority47 \lsdlocked0 List Table 2 Accent';
    wwv_flow_api.g_varchar2_table(629) := ' 3;\lsdpriority48 \lsdlocked0 List Table 3 Accent 3;\lsdpriority49 \lsdlocked0 List Table 4 Accent 3';
    wwv_flow_api.g_varchar2_table(630) := ';\lsdpriority50 \lsdlocked0 List Table 5 Dark Accent 3;'||wwv_flow.LF||
'\lsdpriority51 \lsdlocked0 List Table 6 Col';
    wwv_flow_api.g_varchar2_table(631) := 'orful Accent 3;\lsdpriority52 \lsdlocked0 List Table 7 Colorful Accent 3;\lsdpriority46 \lsdlocked0 ';
    wwv_flow_api.g_varchar2_table(632) := 'List Table 1 Light Accent 4;\lsdpriority47 \lsdlocked0 List Table 2 Accent 4;'||wwv_flow.LF||
'\lsdpriority48 \lsdlo';
    wwv_flow_api.g_varchar2_table(633) := 'cked0 List Table 3 Accent 4;\lsdpriority49 \lsdlocked0 List Table 4 Accent 4;\lsdpriority50 \lsdlock';
    wwv_flow_api.g_varchar2_table(634) := 'ed0 List Table 5 Dark Accent 4;\lsdpriority51 \lsdlocked0 List Table 6 Colorful Accent 4;'||wwv_flow.LF||
'\lsdprior';
    wwv_flow_api.g_varchar2_table(635) := 'ity52 \lsdlocked0 List Table 7 Colorful Accent 4;\lsdpriority46 \lsdlocked0 List Table 1 Light Accen';
    wwv_flow_api.g_varchar2_table(636) := 't 5;\lsdpriority47 \lsdlocked0 List Table 2 Accent 5;\lsdpriority48 \lsdlocked0 List Table 3 Accent ';
    wwv_flow_api.g_varchar2_table(637) := '5;'||wwv_flow.LF||
'\lsdpriority49 \lsdlocked0 List Table 4 Accent 5;\lsdpriority50 \lsdlocked0 List Table 5 Dark Ac';
    wwv_flow_api.g_varchar2_table(638) := 'cent 5;\lsdpriority51 \lsdlocked0 List Table 6 Colorful Accent 5;\lsdpriority52 \lsdlocked0 List Tab';
    wwv_flow_api.g_varchar2_table(639) := 'le 7 Colorful Accent 5;'||wwv_flow.LF||
'\lsdpriority46 \lsdlocked0 List Table 1 Light Accent 6;\lsdpriority47 \lsdl';
    wwv_flow_api.g_varchar2_table(640) := 'ocked0 List Table 2 Accent 6;\lsdpriority48 \lsdlocked0 List Table 3 Accent 6;\lsdpriority49 \lsdloc';
    wwv_flow_api.g_varchar2_table(641) := 'ked0 List Table 4 Accent 6;'||wwv_flow.LF||
'\lsdpriority50 \lsdlocked0 List Table 5 Dark Accent 6;\lsdpriority51 \l';
    wwv_flow_api.g_varchar2_table(642) := 'sdlocked0 List Table 6 Colorful Accent 6;\lsdpriority52 \lsdlocked0 List Table 7 Colorful Accent 6;\';
    wwv_flow_api.g_varchar2_table(643) := 'lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Mention;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Sma';
    wwv_flow_api.g_varchar2_table(644) := 'rt Hyperlink;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Hashtag;\lsdsemihidden1 \lsdunhideused1 \ls';
    wwv_flow_api.g_varchar2_table(645) := 'dlocked0 Unresolved Mention;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Smart Link;}}{\*\datastore 0';
    wwv_flow_api.g_varchar2_table(646) := '1050000'||wwv_flow.LF||
'02000000180000004d73786d6c322e534158584d4c5265616465722e362e30000000000000000000000e0000'||wwv_flow.LF||
'd';
    wwv_flow_api.g_varchar2_table(647) := '0cf11e0a1b11ae1000000000000000000000000000000003e000300feff09000600000000000000000000000100000001000';
    wwv_flow_api.g_varchar2_table(648) := '00000000000001000000200000001000000feffffff0000000000000000fffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(649) := 'fffffffffffffffffffffffffffffffffffffffffffffffffff'||wwv_flow.LF||
'fffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(650) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(651) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(652) := 'fffff'||wwv_flow.LF||
'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(653) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(654) := 'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'||wwv_flow.LF||
'fffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(655) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(656) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(657) := 'fffffffffffff'||wwv_flow.LF||
'fffffffffffffffffdffffff04000000feffffff05000000fefffffffefffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(658) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(659) := 'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'||wwv_flow.LF||
'fffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(660) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(661) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(662) := 'fffffffffffffffffffff'||wwv_flow.LF||
'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(663) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(664) := 'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'||wwv_flow.LF||
'fffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(665) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(666) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(667) := 'fffffffffffffffffffffffffffff'||wwv_flow.LF||
'ffffffffffffffffffffffffffffffff52006f006f007400200045006e00740072007';
    wwv_flow_api.g_varchar2_table(668) := '900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000016000500f';
    wwv_flow_api.g_varchar2_table(669) := 'fffffffffffffff010000000c6ad98892f1d411a65f0040963251e50000000000000000000000008089'||wwv_flow.LF||
'24928b88d901030';
    wwv_flow_api.g_varchar2_table(670) := '00000c0020000000000004d0073006f004400610074006100530074006f00720065000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(671) := '00000000000000000000000000000000000000000000000001a000101ffffffffffffffff020000000000000000000000000';
    wwv_flow_api.g_varchar2_table(672) := '000000000000000000000808924928b88d901'||wwv_flow.LF||
'808924928b88d901000000000000000000000000c000df004800cb005200c';
    wwv_flow_api.g_varchar2_table(673) := '600c00043005a005500da00cd005900340057004400c800c9004800d400cc0041003d003d000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(674) := '000000032000101ffffffffffffffff030000000000000000000000000000000000000000000000808924928b88'||wwv_flow.LF||
'd901808';
    wwv_flow_api.g_varchar2_table(675) := '924928b88d9010000000000000000000000004900740065006d0000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(676) := '000000000000000000000000000000000000000000000000000000000000000000a000201ffffffff04000000ffffffff000';
    wwv_flow_api.g_varchar2_table(677) := '000000000000000000000000000000000000000000000'||wwv_flow.LF||
'00000000000000000000000000000000210100000000000001000';
    wwv_flow_api.g_varchar2_table(678) := '000020000000300000004000000feffffff060000000700000008000000090000000a000000fefffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(679) := 'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(680) := ''||wwv_flow.LF||
'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(681) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(682) := 'fffffffffffffffffffffffffffffffffffffffffffffffffffff'||wwv_flow.LF||
'fffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(683) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(684) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(685) := 'fffffff'||wwv_flow.LF||
'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(686) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(687) := 'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'||wwv_flow.LF||
'fffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(688) := 'fffffffffffffffffffffffffff3c3f786d6c2076657273696f6e3d22312e3022207374616e64616c6f6e653d226e6f223f3';
    wwv_flow_api.g_varchar2_table(689) := 'e3c623a536f757263657320786d6c6e733a623d22687474703a2f2f736368656d61732e6f70656e786d6c666f726d6174732';
    wwv_flow_api.g_varchar2_table(690) := 'e6f72672f6f6666'||wwv_flow.LF||
'696365446f63756d656e742f323030362f6269626c696f6772617068792220786d6c6e733d226874747';
    wwv_flow_api.g_varchar2_table(691) := '03a2f2f736368656d61732e6f70656e786d6c666f726d6174732e6f72672f6f6666696365446f63756d656e742f323030362';
    wwv_flow_api.g_varchar2_table(692) := 'f6269626c696f677261706879222053656c65637465645374796c653d225c41504153'||wwv_flow.LF||
'6978746845646974696f6e4f66666';
    wwv_flow_api.g_varchar2_table(693) := '963654f6e6c696e652e78736c22205374796c654e616d653d22415041222056657273696f6e3d2236223e3c2f623a536f757';
    wwv_flow_api.g_varchar2_table(694) := '26365733e000000000000000000000000000000000000000000000000000000000000003c3f786d6c2076657273696f6e3d2';
    wwv_flow_api.g_varchar2_table(695) := '2312e302220656e636f6469'||wwv_flow.LF||
'6e673d225554462d3822207374616e64616c6f6e653d226e6f223f3e0d0a3c64733a6461746';
    wwv_flow_api.g_varchar2_table(696) := '173746f72654974656d2064733a6974656d49443d227b34364542463138332d303236382d344536352d414436312d4535383';
    wwv_flow_api.g_varchar2_table(697) := '341323931463442307d2220786d6c6e733a64733d22687474703a2f2f736368656d61732e6f70'||wwv_flow.LF||
'656e786d6c666f726d617';
    wwv_flow_api.g_varchar2_table(698) := '4732e6f72672f6f6666696365446f63756d656e742f323030362f637573500072006f0070006500720074006900650073000';
    wwv_flow_api.g_varchar2_table(699) := '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000016000200fffff';
    wwv_flow_api.g_varchar2_table(700) := 'fffffffffffffffffff000000000000'||wwv_flow.LF||
'0000000000000000000000000000000000000000000000000000000000000500000';
    wwv_flow_api.g_varchar2_table(701) := '0550100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(702) := '00000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000'||wwv_flow.LF||
'0000000000000';
    wwv_flow_api.g_varchar2_table(703) := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(704) := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(705) := '00000000000ffffffffffffffffffffffff0000'||wwv_flow.LF||
'00000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(706) := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(707) := '000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff'||wwv_flow.LF||
'00000';
    wwv_flow_api.g_varchar2_table(708) := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000746f6d586';
    wwv_flow_api.g_varchar2_table(709) := 'd6c223e3c64733a736368656d61526566733e3c64733a736368656d615265662064733a7572693d22687474703a2f2f73636';
    wwv_flow_api.g_varchar2_table(710) := '8656d61732e6f70656e786d6c666f726d6174732e6f7267'||wwv_flow.LF||
'2f6f6666696365446f63756d656e742f323030362f6269626c6';
    wwv_flow_api.g_varchar2_table(711) := '96f677261706879222f3e3c2f64733a736368656d61526566733e3c2f64733a6461746173746f72654974656d3e000000000';
    wwv_flow_api.g_varchar2_table(712) := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(713) := '0'||wwv_flow.LF||
'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(714) := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(715) := '0000000000000000000000000000000000000000000000000000000'||wwv_flow.LF||
'0000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(716) := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(717) := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(718) := '000000000'||wwv_flow.LF||
'00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(719) := '000000000000000000000000105000000000000}}';
null;
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_report_layout(
 p_id=>wwv_flow_api.id(45545837772799994)
,p_report_layout_name=>'Budget Proposal Cost Centers Plan List'
,p_report_layout_type=>'RTF_FILE'
,p_varchar2_table=>wwv_flow_api.g_varchar2_table
);
null;
wwv_flow_api.component_end;
end;
/
