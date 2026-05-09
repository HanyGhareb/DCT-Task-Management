prompt --application/shared_components/reports/report_layouts/upload_btf_lines_report
begin
--   Manifest
--     REPORT LAYOUT: UPLOAD_BTF_LINES_REPORT
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
    wwv_flow_api.g_varchar2_table(2) := '06\stshfbi31507\deflang1033\deflangfe1033\themelang1033\themelangfe0\themelangcs1025{\fonttbl{\f1\fb';
    wwv_flow_api.g_varchar2_table(3) := 'idi \fswiss\fcharset0\fprq2{\*\panose 00000000000000000000}Arial;}{\f34\fbidi \froman\fcharset0\fprq';
    wwv_flow_api.g_varchar2_table(4) := '2{\*\panose 02040503050406030204}Cambria Math;}'||wwv_flow.LF||
'{\f37\fbidi \fswiss\fcharset0\fprq2{\*\panose 00000';
    wwv_flow_api.g_varchar2_table(5) := '000000000000000}Calibri;}{\flomajor\f31500\fbidi \froman\fcharset0\fprq2{\*\panose 00000000000000000';
    wwv_flow_api.g_varchar2_table(6) := '000}Times New Roman;}'||wwv_flow.LF||
'{\fdbmajor\f31501\fbidi \froman\fcharset0\fprq2{\*\panose 0000000000000000000';
    wwv_flow_api.g_varchar2_table(7) := '0}Times New Roman;}{\fhimajor\f31502\fbidi \fswiss\fcharset0\fprq2{\*\panose 00000000000000000000}Ca';
    wwv_flow_api.g_varchar2_table(8) := 'libri Light;}'||wwv_flow.LF||
'{\fbimajor\f31503\fbidi \froman\fcharset0\fprq2{\*\panose 00000000000000000000}Times ';
    wwv_flow_api.g_varchar2_table(9) := 'New Roman;}{\flominor\f31504\fbidi \froman\fcharset0\fprq2{\*\panose 00000000000000000000}Times New ';
    wwv_flow_api.g_varchar2_table(10) := 'Roman;}'||wwv_flow.LF||
'{\fdbminor\f31505\fbidi \froman\fcharset0\fprq2{\*\panose 00000000000000000000}Times New Ro';
    wwv_flow_api.g_varchar2_table(11) := 'man;}{\fhiminor\f31506\fbidi \fswiss\fcharset0\fprq2{\*\panose 00000000000000000000}Calibri;}'||wwv_flow.LF||
'{\fbi';
    wwv_flow_api.g_varchar2_table(12) := 'minor\f31507\fbidi \fswiss\fcharset0\fprq2{\*\panose 00000000000000000000}Arial;}{\f52\fbidi \fswiss';
    wwv_flow_api.g_varchar2_table(13) := '\fcharset238\fprq2 Arial CE;}{\f53\fbidi \fswiss\fcharset204\fprq2 Arial Cyr;}{\f55\fbidi \fswiss\fc';
    wwv_flow_api.g_varchar2_table(14) := 'harset161\fprq2 Arial Greek;}'||wwv_flow.LF||
'{\f56\fbidi \fswiss\fcharset162\fprq2 Arial Tur;}{\f57\fbidi \fswiss\';
    wwv_flow_api.g_varchar2_table(15) := 'fcharset177\fprq2 Arial (Hebrew);}{\f58\fbidi \fswiss\fcharset178\fprq2 Arial (Arabic);}{\f59\fbidi ';
    wwv_flow_api.g_varchar2_table(16) := '\fswiss\fcharset186\fprq2 Arial Baltic;}'||wwv_flow.LF||
'{\f60\fbidi \fswiss\fcharset163\fprq2 Arial (Vietnamese);}';
    wwv_flow_api.g_varchar2_table(17) := '{\f412\fbidi \fswiss\fcharset238\fprq2 Calibri CE;}{\f413\fbidi \fswiss\fcharset204\fprq2 Calibri Cy';
    wwv_flow_api.g_varchar2_table(18) := 'r;}{\f415\fbidi \fswiss\fcharset161\fprq2 Calibri Greek;}'||wwv_flow.LF||
'{\f416\fbidi \fswiss\fcharset162\fprq2 Ca';
    wwv_flow_api.g_varchar2_table(19) := 'libri Tur;}{\f417\fbidi \fswiss\fcharset177\fprq2 Calibri (Hebrew);}{\f418\fbidi \fswiss\fcharset178';
    wwv_flow_api.g_varchar2_table(20) := '\fprq2 Calibri (Arabic);}{\f419\fbidi \fswiss\fcharset186\fprq2 Calibri Baltic;}'||wwv_flow.LF||
'{\f420\fbidi \fswi';
    wwv_flow_api.g_varchar2_table(21) := 'ss\fcharset163\fprq2 Calibri (Vietnamese);}{\flomajor\f31508\fbidi \froman\fcharset238\fprq2 Times N';
    wwv_flow_api.g_varchar2_table(22) := 'ew Roman CE;}{\flomajor\f31509\fbidi \froman\fcharset204\fprq2 Times New Roman Cyr;}'||wwv_flow.LF||
'{\flomajor\f31';
    wwv_flow_api.g_varchar2_table(23) := '511\fbidi \froman\fcharset161\fprq2 Times New Roman Greek;}{\flomajor\f31512\fbidi \froman\fcharset1';
    wwv_flow_api.g_varchar2_table(24) := '62\fprq2 Times New Roman Tur;}{\flomajor\f31513\fbidi \froman\fcharset177\fprq2 Times New Roman (Heb';
    wwv_flow_api.g_varchar2_table(25) := 'rew);}'||wwv_flow.LF||
'{\flomajor\f31514\fbidi \froman\fcharset178\fprq2 Times New Roman (Arabic);}{\flomajor\f3151';
    wwv_flow_api.g_varchar2_table(26) := '5\fbidi \froman\fcharset186\fprq2 Times New Roman Baltic;}{\flomajor\f31516\fbidi \froman\fcharset16';
    wwv_flow_api.g_varchar2_table(27) := '3\fprq2 Times New Roman (Vietnamese);}'||wwv_flow.LF||
'{\fdbmajor\f31518\fbidi \froman\fcharset238\fprq2 Times New ';
    wwv_flow_api.g_varchar2_table(28) := 'Roman CE;}{\fdbmajor\f31519\fbidi \froman\fcharset204\fprq2 Times New Roman Cyr;}{\fdbmajor\f31521\f';
    wwv_flow_api.g_varchar2_table(29) := 'bidi \froman\fcharset161\fprq2 Times New Roman Greek;}'||wwv_flow.LF||
'{\fdbmajor\f31522\fbidi \froman\fcharset162\';
    wwv_flow_api.g_varchar2_table(30) := 'fprq2 Times New Roman Tur;}{\fdbmajor\f31523\fbidi \froman\fcharset177\fprq2 Times New Roman (Hebrew';
    wwv_flow_api.g_varchar2_table(31) := ');}{\fdbmajor\f31524\fbidi \froman\fcharset178\fprq2 Times New Roman (Arabic);}'||wwv_flow.LF||
'{\fdbmajor\f31525\f';
    wwv_flow_api.g_varchar2_table(32) := 'bidi \froman\fcharset186\fprq2 Times New Roman Baltic;}{\fdbmajor\f31526\fbidi \froman\fcharset163\f';
    wwv_flow_api.g_varchar2_table(33) := 'prq2 Times New Roman (Vietnamese);}{\fhimajor\f31528\fbidi \fswiss\fcharset238\fprq2 Calibri Light C';
    wwv_flow_api.g_varchar2_table(34) := 'E;}'||wwv_flow.LF||
'{\fhimajor\f31529\fbidi \fswiss\fcharset204\fprq2 Calibri Light Cyr;}{\fhimajor\f31531\fbidi \f';
    wwv_flow_api.g_varchar2_table(35) := 'swiss\fcharset161\fprq2 Calibri Light Greek;}{\fhimajor\f31532\fbidi \fswiss\fcharset162\fprq2 Calib';
    wwv_flow_api.g_varchar2_table(36) := 'ri Light Tur;}'||wwv_flow.LF||
'{\fhimajor\f31533\fbidi \fswiss\fcharset177\fprq2 Calibri Light (Hebrew);}{\fhimajor';
    wwv_flow_api.g_varchar2_table(37) := '\f31534\fbidi \fswiss\fcharset178\fprq2 Calibri Light (Arabic);}{\fhimajor\f31535\fbidi \fswiss\fcha';
    wwv_flow_api.g_varchar2_table(38) := 'rset186\fprq2 Calibri Light Baltic;}'||wwv_flow.LF||
'{\fhimajor\f31536\fbidi \fswiss\fcharset163\fprq2 Calibri Ligh';
    wwv_flow_api.g_varchar2_table(39) := 't (Vietnamese);}{\fbimajor\f31538\fbidi \froman\fcharset238\fprq2 Times New Roman CE;}{\fbimajor\f31';
    wwv_flow_api.g_varchar2_table(40) := '539\fbidi \froman\fcharset204\fprq2 Times New Roman Cyr;}'||wwv_flow.LF||
'{\fbimajor\f31541\fbidi \froman\fcharset1';
    wwv_flow_api.g_varchar2_table(41) := '61\fprq2 Times New Roman Greek;}{\fbimajor\f31542\fbidi \froman\fcharset162\fprq2 Times New Roman Tu';
    wwv_flow_api.g_varchar2_table(42) := 'r;}{\fbimajor\f31543\fbidi \froman\fcharset177\fprq2 Times New Roman (Hebrew);}'||wwv_flow.LF||
'{\fbimajor\f31544\f';
    wwv_flow_api.g_varchar2_table(43) := 'bidi \froman\fcharset178\fprq2 Times New Roman (Arabic);}{\fbimajor\f31545\fbidi \froman\fcharset186';
    wwv_flow_api.g_varchar2_table(44) := '\fprq2 Times New Roman Baltic;}{\fbimajor\f31546\fbidi \froman\fcharset163\fprq2 Times New Roman (Vi';
    wwv_flow_api.g_varchar2_table(45) := 'etnamese);}'||wwv_flow.LF||
'{\flominor\f31548\fbidi \froman\fcharset238\fprq2 Times New Roman CE;}{\flominor\f31549';
    wwv_flow_api.g_varchar2_table(46) := '\fbidi \froman\fcharset204\fprq2 Times New Roman Cyr;}{\flominor\f31551\fbidi \froman\fcharset161\fp';
    wwv_flow_api.g_varchar2_table(47) := 'rq2 Times New Roman Greek;}'||wwv_flow.LF||
'{\flominor\f31552\fbidi \froman\fcharset162\fprq2 Times New Roman Tur;}';
    wwv_flow_api.g_varchar2_table(48) := '{\flominor\f31553\fbidi \froman\fcharset177\fprq2 Times New Roman (Hebrew);}{\flominor\f31554\fbidi ';
    wwv_flow_api.g_varchar2_table(49) := '\froman\fcharset178\fprq2 Times New Roman (Arabic);}'||wwv_flow.LF||
'{\flominor\f31555\fbidi \froman\fcharset186\fp';
    wwv_flow_api.g_varchar2_table(50) := 'rq2 Times New Roman Baltic;}{\flominor\f31556\fbidi \froman\fcharset163\fprq2 Times New Roman (Vietn';
    wwv_flow_api.g_varchar2_table(51) := 'amese);}{\fdbminor\f31558\fbidi \froman\fcharset238\fprq2 Times New Roman CE;}'||wwv_flow.LF||
'{\fdbminor\f31559\fb';
    wwv_flow_api.g_varchar2_table(52) := 'idi \froman\fcharset204\fprq2 Times New Roman Cyr;}{\fdbminor\f31561\fbidi \froman\fcharset161\fprq2';
    wwv_flow_api.g_varchar2_table(53) := ' Times New Roman Greek;}{\fdbminor\f31562\fbidi \froman\fcharset162\fprq2 Times New Roman Tur;}'||wwv_flow.LF||
'{\f';
    wwv_flow_api.g_varchar2_table(54) := 'dbminor\f31563\fbidi \froman\fcharset177\fprq2 Times New Roman (Hebrew);}{\fdbminor\f31564\fbidi \fr';
    wwv_flow_api.g_varchar2_table(55) := 'oman\fcharset178\fprq2 Times New Roman (Arabic);}{\fdbminor\f31565\fbidi \froman\fcharset186\fprq2 T';
    wwv_flow_api.g_varchar2_table(56) := 'imes New Roman Baltic;}'||wwv_flow.LF||
'{\fdbminor\f31566\fbidi \froman\fcharset163\fprq2 Times New Roman (Vietname';
    wwv_flow_api.g_varchar2_table(57) := 'se);}{\fhiminor\f31568\fbidi \fswiss\fcharset238\fprq2 Calibri CE;}{\fhiminor\f31569\fbidi \fswiss\f';
    wwv_flow_api.g_varchar2_table(58) := 'charset204\fprq2 Calibri Cyr;}'||wwv_flow.LF||
'{\fhiminor\f31571\fbidi \fswiss\fcharset161\fprq2 Calibri Greek;}{\f';
    wwv_flow_api.g_varchar2_table(59) := 'himinor\f31572\fbidi \fswiss\fcharset162\fprq2 Calibri Tur;}{\fhiminor\f31573\fbidi \fswiss\fcharset';
    wwv_flow_api.g_varchar2_table(60) := '177\fprq2 Calibri (Hebrew);}'||wwv_flow.LF||
'{\fhiminor\f31574\fbidi \fswiss\fcharset178\fprq2 Calibri (Arabic);}{\';
    wwv_flow_api.g_varchar2_table(61) := 'fhiminor\f31575\fbidi \fswiss\fcharset186\fprq2 Calibri Baltic;}{\fhiminor\f31576\fbidi \fswiss\fcha';
    wwv_flow_api.g_varchar2_table(62) := 'rset163\fprq2 Calibri (Vietnamese);}'||wwv_flow.LF||
'{\fbiminor\f31578\fbidi \fswiss\fcharset238\fprq2 Arial CE;}{\';
    wwv_flow_api.g_varchar2_table(63) := 'fbiminor\f31579\fbidi \fswiss\fcharset204\fprq2 Arial Cyr;}{\fbiminor\f31581\fbidi \fswiss\fcharset1';
    wwv_flow_api.g_varchar2_table(64) := '61\fprq2 Arial Greek;}{\fbiminor\f31582\fbidi \fswiss\fcharset162\fprq2 Arial Tur;}'||wwv_flow.LF||
'{\fbiminor\f315';
    wwv_flow_api.g_varchar2_table(65) := '83\fbidi \fswiss\fcharset177\fprq2 Arial (Hebrew);}{\fbiminor\f31584\fbidi \fswiss\fcharset178\fprq2';
    wwv_flow_api.g_varchar2_table(66) := ' Arial (Arabic);}{\fbiminor\f31585\fbidi \fswiss\fcharset186\fprq2 Arial Baltic;}'||wwv_flow.LF||
'{\fbiminor\f31586';
    wwv_flow_api.g_varchar2_table(67) := '\fbidi \fswiss\fcharset163\fprq2 Arial (Vietnamese);}{\f42\fbidi \froman\fcharset238\fprq2 Times New';
    wwv_flow_api.g_varchar2_table(68) := ' Roman CE;}{\f43\fbidi \froman\fcharset204\fprq2 Times New Roman Cyr;}{\f45\fbidi \froman\fcharset16';
    wwv_flow_api.g_varchar2_table(69) := '1\fprq2 Times New Roman Greek;}'||wwv_flow.LF||
'{\f46\fbidi \froman\fcharset162\fprq2 Times New Roman Tur;}{\f47\fb';
    wwv_flow_api.g_varchar2_table(70) := 'idi \froman\fcharset177\fprq2 Times New Roman (Hebrew);}{\f48\fbidi \froman\fcharset178\fprq2 Times ';
    wwv_flow_api.g_varchar2_table(71) := 'New Roman (Arabic);}{\f49\fbidi \froman\fcharset186\fprq2 Times New Roman Baltic;}'||wwv_flow.LF||
'{\f50\fbidi \fro';
    wwv_flow_api.g_varchar2_table(72) := 'man\fcharset163\fprq2 Times New Roman (Vietnamese);}}{\colortbl;\red0\green0\blue0;\red0\green0\blue';
    wwv_flow_api.g_varchar2_table(73) := '255;\red0\green255\blue255;\red0\green255\blue0;\red255\green0\blue255;\red255\green0\blue0;\red255\';
    wwv_flow_api.g_varchar2_table(74) := 'green255\blue0;'||wwv_flow.LF||
'\red255\green255\blue255;\red0\green0\blue128;\red0\green128\blue128;\red0\green128';
    wwv_flow_api.g_varchar2_table(75) := '\blue0;\red128\green0\blue128;\red128\green0\blue0;\red128\green128\blue0;\red128\green128\blue128;\';
    wwv_flow_api.g_varchar2_table(76) := 'red192\green192\blue192;\red0\green0\blue0;\red0\green0\blue0;'||wwv_flow.LF||
'\cbackgroundone\ctint255\cshade255\r';
    wwv_flow_api.g_varchar2_table(77) := 'ed255\green255\blue255;}{\*\defchp \f31506\fs22 }{\*\defpap \ql \li0\ri0\sa160\sl259\slmult1\widctlp';
    wwv_flow_api.g_varchar2_table(78) := 'ar\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 }\noqfpromote {\stylesheet{'||wwv_flow.LF||
'\ql \';
    wwv_flow_api.g_varchar2_table(79) := 'li0\ri0\sa160\sl259\slmult1\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0';
    wwv_flow_api.g_varchar2_table(80) := ' \rtlch\fcs1 \af31507\afs22\alang1025 \ltrch\fcs0 \f31506\fs22\lang1033\langfe1033\cgrid\langnp1033\';
    wwv_flow_api.g_varchar2_table(81) := 'langfenp1033 \snext0 \sqformat \spriority0 '||wwv_flow.LF||
'Normal;}{\*\cs10 \additive \ssemihidden \sunhideused \s';
    wwv_flow_api.g_varchar2_table(82) := 'priority1 Default Paragraph Font;}{\*'||wwv_flow.LF||
'\ts11\tsrowd\trftsWidthB3\trpaddl108\trpaddr108\trpaddfl3\trp';
    wwv_flow_api.g_varchar2_table(83) := 'addft3\trpaddfb3\trpaddfr3\tblind0\tblindtype3\tsvertalt\tsbrdrt\tsbrdrl\tsbrdrb\tsbrdrr\tsbrdrdgl\t';
    wwv_flow_api.g_varchar2_table(84) := 'sbrdrdgr\tsbrdrh\tsbrdrv \ql \li0\ri0\sa160\sl259\slmult1'||wwv_flow.LF||
'\widctlpar\wrapdefault\aspalpha\aspnum\fa';
    wwv_flow_api.g_varchar2_table(85) := 'auto\adjustright\rin0\lin0\itap0 \rtlch\fcs1 \af31507\afs22\alang1025 \ltrch\fcs0 \f31506\fs22\lang1';
    wwv_flow_api.g_varchar2_table(86) := '033\langfe1033\cgrid\langnp1033\langfenp1033 \snext11 \ssemihidden \sunhideused Normal Table;}{\*\ts';
    wwv_flow_api.g_varchar2_table(87) := '15\tsrowd'||wwv_flow.LF||
'\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw';
    wwv_flow_api.g_varchar2_table(88) := '10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 '||wwv_flow.LF||
'\trftsWidthB3\trpaddl108\trpaddr108\trpaddfl3\trp';
    wwv_flow_api.g_varchar2_table(89) := 'addft3\trpaddfb3\trpaddfr3\tblind0\tblindtype3\tsvertalt\tsbrdrt\tsbrdrl\tsbrdrb\tsbrdrr\tsbrdrdgl\t';
    wwv_flow_api.g_varchar2_table(90) := 'sbrdrdgr\tsbrdrh\tsbrdrv '||wwv_flow.LF||
'\ql \li0\ri0\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin';
    wwv_flow_api.g_varchar2_table(91) := '0\lin0\itap0 \rtlch\fcs1 \af31507\afs22\alang1025 \ltrch\fcs0 \f31506\fs22\lang1033\langfe1033\cgrid';
    wwv_flow_api.g_varchar2_table(92) := '\langnp1033\langfenp1033 \sbasedon11 \snext15 \spriority39 \styrsid275237 '||wwv_flow.LF||
'Table Grid;}}{\*\rsidtbl';
    wwv_flow_api.g_varchar2_table(93) := ' \rsid91571\rsid275237\rsid535924\rsid816405\rsid1315653\rsid1339818\rsid1715606\rsid1728812\rsid177';
    wwv_flow_api.g_varchar2_table(94) := '8647\rsid2502627\rsid2516404\rsid3212505\rsid3351606\rsid4407781\rsid4459971\rsid4548179\rsid4666254';
    wwv_flow_api.g_varchar2_table(95) := '\rsid4725872\rsid4801324'||wwv_flow.LF||
'\rsid4869424\rsid6111628\rsid6488322\rsid6505266\rsid6979285\rsid7019040\r';
    wwv_flow_api.g_varchar2_table(96) := 'sid7286595\rsid7429375\rsid7803984\rsid7817153\rsid7869381\rsid8328744\rsid8333047\rsid8862518\rsid9';
    wwv_flow_api.g_varchar2_table(97) := '258855\rsid9776363\rsid10095675\rsid10183755\rsid10898819\rsid11020367'||wwv_flow.LF||
'\rsid11427737\rsid11428772\r';
    wwv_flow_api.g_varchar2_table(98) := 'sid11551036\rsid11800713\rsid12329576\rsid12790319\rsid12869998\rsid13370026\rsid13596424\rsid137157';
    wwv_flow_api.g_varchar2_table(99) := '67\rsid13770370\rsid14515664\rsid14700697\rsid15093284\rsid15668796\rsid15674213\rsid15891060\rsid15';
    wwv_flow_api.g_varchar2_table(100) := '943195\rsid15999906'||wwv_flow.LF||
'\rsid16196166\rsid16278804\rsid16718282\rsid16736327}{\mmathPr\mmathFont34\mbrk';
    wwv_flow_api.g_varchar2_table(101) := 'Bin0\mbrkBinSub0\msmallFrac0\mdispDef1\mlMargin0\mrMargin0\mdefJc1\mwrapIndent1440\mintLim0\mnaryLim';
    wwv_flow_api.g_varchar2_table(102) := '1}{\info{\author Haney Ghareb Abdela Al Ghareb}'||wwv_flow.LF||
'{\operator Haney Ghareb Abdela Al Ghareb}{\creatim\';
    wwv_flow_api.g_varchar2_table(103) := 'yr2022\mo7\dy21\min43}{\revtim\yr2022\mo7\dy21\hr1\min3}{\version18}{\edmins20}{\nofpages1}{\nofword';
    wwv_flow_api.g_varchar2_table(104) := 's62}{\nofchars360}{\nofcharsws421}{\vern31}}{\*\xmlnstbl {\xmlns1 http://schemas.microsoft.com/offic';
    wwv_flow_api.g_varchar2_table(105) := 'e/wo'||wwv_flow.LF||
'rd/2003/wordml}}\paperw31680\paperh16834\margl1440\margr1440\margt1440\margb1440\gutter0\ltrse';
    wwv_flow_api.g_varchar2_table(106) := 'ct '||wwv_flow.LF||
'\widowctrl\ftnbj\aenddoc\trackmoves0\trackformatting1\donotembedsysfont1\relyonvml0\donotembedl';
    wwv_flow_api.g_varchar2_table(107) := 'ingdata0\grfdocevents0\validatexml1\showplaceholdtext0\ignoremixedcontent0\saveinvalidxml0\showxmler';
    wwv_flow_api.g_varchar2_table(108) := 'rors1\noxlattoyen'||wwv_flow.LF||
'\expshrtn\noultrlspc\dntblnsbdb\nospaceforul\formshade\horzdoc\dgmargin\dghspace1';
    wwv_flow_api.g_varchar2_table(109) := '80\dgvspace180\dghorigin1440\dgvorigin1440\dghshow1\dgvshow1'||wwv_flow.LF||
'\jexpand\viewkind1\viewscale70\pgbrdrh';
    wwv_flow_api.g_varchar2_table(110) := 'ead\pgbrdrfoot\splytwnine\ftnlytwnine\htmautsp\nolnhtadjtbl\useltbaln\alntblind\lytcalctblwd\lyttblr';
    wwv_flow_api.g_varchar2_table(111) := 'tgr\lnbrkrule\nobrkwrptbl\snaptogridincell\allowfieldendsel\wrppunct'||wwv_flow.LF||
'\asianbrkrule\rsidroot13770370';
    wwv_flow_api.g_varchar2_table(112) := '\newtblstyruls\nogrowautofit\usenormstyforlist\noindnmbrts\felnbrelev\nocxsptable\indrlsweleven\noaf';
    wwv_flow_api.g_varchar2_table(113) := 'cnsttbl\afelev\utinl\hwelev\spltpgpar\notcvasp\notbrkcnstfrctbl\notvatxbx\krnprsnet\cachedcolbal \no';
    wwv_flow_api.g_varchar2_table(114) := 'uicompat \fet0'||wwv_flow.LF||
'{\*\wgrffmtfilter 2450}\nofeaturethrottle1\ilfomacatclnup0{\*\docvar {xdo0001}{PD9mb';
    wwv_flow_api.g_varchar2_table(115) := '3ItZWFjaDpST1c/Pg==}}{\*\docvar {xdo0002}{PD9MSU5FX1RZRVA/Pg==}}{\*\docvar {xdo0003}{PD9QUk9KRUNUX05';
    wwv_flow_api.g_varchar2_table(116) := 'VTUJFUj8+}}{\*\docvar {xdo0004}{PD9UQVNLX05VTUJFUj8+}}'||wwv_flow.LF||
'{\*\docvar {xdo0005}{PD9DT1NUX0NFTlRFUj8+}}{';
    wwv_flow_api.g_varchar2_table(117) := '\*\docvar {xdo0006}{PD9FWFBFTkRJVFVSRV9UWVBFPz4=}}{\*\docvar {xdo0007}{PD9CVURHRVQ/Pg==}}'||wwv_flow.LF||
'{\*\docva';
    wwv_flow_api.g_varchar2_table(118) := 'r {xdo0008}{PGZvOmJpZGktb3ZlcnJpZGUgZGlyZWN0aW9uPSJsdHIiIHVuaWNvZGUtYmlkaT0iYmlkaS1vdmVycmlkZSI+PD9B';
    wwv_flow_api.g_varchar2_table(119) := 'Q1RVQUw/PjwvZm86YmlkaS1vdmVycmlkZT4=}}{\*\docvar {xdo0009}{PD9FTkNVTUJFUkFOQ0U/Pg==}}{\*\docvar {xdo';
    wwv_flow_api.g_varchar2_table(120) := '0010}{PD9GVU5EX0FWQUlMQUJMRT8+}}'||wwv_flow.LF||
'{\*\docvar {xdo0011}{PD9lbmQgZm9yLWVhY2g/Pg==}}'||wwv_flow.LF||
'{\*\docvar {xdo00';
    wwv_flow_api.g_varchar2_table(121) := '12}{PD9pZjpMSU5FX1RZRVA9J0ZST00nPz48P2F0dHJpYnV0ZUBpbmNvbnRleHQ6YmFja2dyb3VuZC1jb2xvcjsnUmVkJz8+PD9h';
    wwv_flow_api.g_varchar2_table(122) := 'dHRyaWJ1dGVAaW5jb250ZXh0OmNvbG9yOydXaGl0ZSc/Pjw/YXR0cmlidXRlQGluY29udGV4dDpmb250LXdlaWdodDsnYm9sZCc/';
    wwv_flow_api.g_varchar2_table(123) := 'Pjw/ZW5kIGlmPz48P2lmOkxJTkVfVFlFUD0nVE8nPz48P2F0dHJpYnV0ZUB'||wwv_flow.LF||
'pbmNvbnRleHQ6YmFja2dyb3VuZC1jb2xvcjsnR3';
    wwv_flow_api.g_varchar2_table(124) := 'JlZW4nPz48P2F0dHJpYnV0ZUBpbmNvbnRleHQ6Y29sb3I7J1doaXRlJz8+PD9hdHRyaWJ1dGVAaW5jb250ZXh0OmZvbnQtd2VpZ2';
    wwv_flow_api.g_varchar2_table(125) := 'h0Oydib2xkJz8+PD9lbmQgaWY/Pg==}}'||wwv_flow.LF||
'{\*\docvar {xdo0013}{PD9pZkByb3c6TElORV9UWUVQPSdGUk9NJz8+PD9hdHRya';
    wwv_flow_api.g_varchar2_table(126) := 'WJ1dGVAaW5jb250ZXh0OmJhY2tncm91bmQtY29sb3I7JyNGRkE4QzcnPz48P2F0dHJpYnV0ZUBpbmNvbnRleHQ6Y29sb3I7J3JlZ';
    wwv_flow_api.g_varchar2_table(127) := 'Cc/Pjw/YXR0cmlidXRlQGluY29udGV4dDpmb250LXdlaWdodDsnYm9sZCc/Pjw/ZW5kIGlmPz48P2lmQHJvdzpMSU5FX1RZRVA9J';
    wwv_flow_api.g_varchar2_table(128) := '1RPJz8+PD9'||wwv_flow.LF||
'hdHRyaWJ1dGVAaW5jb250ZXh0OmJhY2tncm91bmQtY29sb3I7JyM5NkZBQUMnPz48P2F0dHJpYnV0ZUBpbmNvbnR';
    wwv_flow_api.g_varchar2_table(129) := 'leHQ6Y29sb3I7J2dyZWVuJz8+PD9hdHRyaWJ1dGVAaW5jb250ZXh0OmZvbnQtd2VpZ2h0Oydib2xkJz8+PD9lbmQgaWY/Pg==}}\';
    wwv_flow_api.g_varchar2_table(130) := 'ltrpar \sectd \ltrsect'||wwv_flow.LF||
'\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid114277';
    wwv_flow_api.g_varchar2_table(131) := '37\sftnbj {\*\pnseclvl1\pnucrm\pnqc\pnstart1\pnindent720\pnhang {\pntxta .}}{\*\pnseclvl2\pnucltr\pn';
    wwv_flow_api.g_varchar2_table(132) := 'qc\pnstart1\pnindent720\pnhang {\pntxta .}}{\*\pnseclvl3'||wwv_flow.LF||
'\pndec\pnqc\pnstart1\pnindent720\pnhang {\';
    wwv_flow_api.g_varchar2_table(133) := 'pntxta .}}{\*\pnseclvl4\pnlcltr\pnqc\pnstart1\pnindent720\pnhang {\pntxta )}}{\*\pnseclvl5\pndec\pnq';
    wwv_flow_api.g_varchar2_table(134) := 'c\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta )}}{\*\pnseclvl6\pnlcltr\pnqc\pnstart1\pnindent720';
    wwv_flow_api.g_varchar2_table(135) := '\pnhang '||wwv_flow.LF||
'{\pntxtb (}{\pntxta )}}{\*\pnseclvl7\pnlcrm\pnqc\pnstart1\pnindent720\pnhang {\pntxtb (}{\';
    wwv_flow_api.g_varchar2_table(136) := 'pntxta )}}{\*\pnseclvl8\pnlcltr\pnqc\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta )}}{\*\pnseclvl';
    wwv_flow_api.g_varchar2_table(137) := '9\pnlcrm\pnqc\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta )}}'||wwv_flow.LF||
'\pard\plain \ltrpar\ql \li0\ri0\s';
    wwv_flow_api.g_varchar2_table(138) := 'a160\sl259\slmult1\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \rtlch\f';
    wwv_flow_api.g_varchar2_table(139) := 'cs1 \af31507\afs22\alang1025 \ltrch\fcs0 \f31506\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1';
    wwv_flow_api.g_varchar2_table(140) := '033 {\rtlch\fcs1 '||wwv_flow.LF||
'\af31507 \ltrch\fcs0 \insrsid275237 '||wwv_flow.LF||
'\par \ltrrow}\trowd \irow0\irowband0\ltrrow';
    wwv_flow_api.g_varchar2_table(141) := '\ts15\trgaph108\trrh306\trleft-990\trhdr\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs';
    wwv_flow_api.g_varchar2_table(142) := '\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 '||wwv_flow.LF||
'\trftsWidth3\trwWidt';
    wwv_flow_api.g_varchar2_table(143) := 'h30595\trftsWidthB3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid4407781\tbl';
    wwv_flow_api.g_varchar2_table(144) := 'lkhdrrows\tbllkhdrcols\tbllknocolband\tblind-882\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrd';
    wwv_flow_api.g_varchar2_table(145) := 'rl\brdrs\brdrw10 \clbrdrb'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwW';
    wwv_flow_api.g_varchar2_table(146) := 'idth1762\clcbpatraw6 \cellx772\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs';
    wwv_flow_api.g_varchar2_table(147) := '\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\clcbpat6\cltxlrtb\clftsWidth3\clwWidth3278\clcbpatraw6 \cellx4050';
    wwv_flow_api.g_varchar2_table(148) := '\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw1';
    wwv_flow_api.g_varchar2_table(149) := '0 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth2917\clcbpatraw6 \cellx6967\clvertalt\clbrdrt'||wwv_flow.LF||
'\brdrs\brdrw';
    wwv_flow_api.g_varchar2_table(150) := '10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidt';
    wwv_flow_api.g_varchar2_table(151) := 'h3\clwWidth2033\clcbpatraw6 \cellx9000\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrd';
    wwv_flow_api.g_varchar2_table(152) := 'rb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\clcbpat6\cltxlrtb\clftsWidth3\clwWidth6536\clcbpatraw6 \c';
    wwv_flow_api.g_varchar2_table(153) := 'ellx15536\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brd';
    wwv_flow_api.g_varchar2_table(154) := 'rs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth2284\clcbpatraw6 \cellx17820\clvertalt\clbrdrt'||wwv_flow.LF||
'\b';
    wwv_flow_api.g_varchar2_table(155) := 'rdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb';
    wwv_flow_api.g_varchar2_table(156) := '\clftsWidth3\clwWidth2430\clcbpatraw6 \cellx20250\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brd';
    wwv_flow_api.g_varchar2_table(157) := 'rw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\clcbpat6\cltxlrtb\clftsWidth3\clwWidth3150\clc';
    wwv_flow_api.g_varchar2_table(158) := 'bpatraw6 \cellx23400\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \';
    wwv_flow_api.g_varchar2_table(159) := 'clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth3600\clcbpatraw6 \cellx27000\clvertalt\';
    wwv_flow_api.g_varchar2_table(160) := 'clbrdrt'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpa';
    wwv_flow_api.g_varchar2_table(161) := 't6\cltxlrtb\clftsWidth3\clwWidth2605\clcbpatraw6 \cellx29605\pard\plain \ltrpar'||wwv_flow.LF||
'\qc \li0\ri0\widctl';
    wwv_flow_api.g_varchar2_table(162) := 'par\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid15891060\yts15 \rtlch\fcs';
    wwv_flow_api.g_varchar2_table(163) := '1 \af31507\afs22\alang1025 \ltrch\fcs0 \f31506\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp103';
    wwv_flow_api.g_varchar2_table(164) := '3 {\rtlch\fcs1 \af31507\afs24 '||wwv_flow.LF||
'\ltrch\fcs0 \b\fs24\cf19\insrsid15891060\charrsid4407781 LINE_TYEP}{';
    wwv_flow_api.g_varchar2_table(165) := '\rtlch\fcs1 \af31507\afs24 \ltrch\fcs0 \fs24\cf19\insrsid15891060\charrsid4407781 \cell }{\rtlch\fcs';
    wwv_flow_api.g_varchar2_table(166) := '1 \af31507\afs24 \ltrch\fcs0 \b\fs24\cf19\insrsid15891060\charrsid4407781 '||wwv_flow.LF||
'PROJECT_NUMBER}{\rtlch\f';
    wwv_flow_api.g_varchar2_table(167) := 'cs1 \af31507\afs24 \ltrch\fcs0 \fs24\cf19\insrsid15891060\charrsid4407781 \cell }{\rtlch\fcs1 \af315';
    wwv_flow_api.g_varchar2_table(168) := '07\afs24 \ltrch\fcs0 \b\fs24\cf19\insrsid15891060\charrsid4407781 TASK_NUMBER}{\rtlch\fcs1 \af31507\';
    wwv_flow_api.g_varchar2_table(169) := 'afs24 \ltrch\fcs0 '||wwv_flow.LF||
'\fs24\cf19\insrsid15891060\charrsid4407781 \cell }{\rtlch\fcs1 \af31507\afs24 \l';
    wwv_flow_api.g_varchar2_table(170) := 'trch\fcs0 \b\fs24\cf19\insrsid15891060\charrsid4407781 COST_CENTER}{\rtlch\fcs1 \af31507\afs24 \ltrc';
    wwv_flow_api.g_varchar2_table(171) := 'h\fcs0 \fs24\cf19\insrsid15891060\charrsid4407781 \cell }{\rtlch\fcs1 '||wwv_flow.LF||
'\af31507\afs24 \ltrch\fcs0 \';
    wwv_flow_api.g_varchar2_table(172) := 'b\fs24\cf19\insrsid15891060\charrsid4407781 EXPENDITURE_TYPE}{\rtlch\fcs1 \af31507\afs24 \ltrch\fcs0';
    wwv_flow_api.g_varchar2_table(173) := ' \fs24\cf19\insrsid15891060\charrsid4407781 \cell }{\rtlch\fcs1 \af31507\afs24 \ltrch\fcs0 '||wwv_flow.LF||
'\b\fs24';
    wwv_flow_api.g_varchar2_table(174) := '\cf19\insrsid15891060\charrsid4407781 BUDGET}{\rtlch\fcs1 \af31507\afs24 \ltrch\fcs0 \fs24\cf19\insr';
    wwv_flow_api.g_varchar2_table(175) := 'sid15891060\charrsid4407781 \cell }{\rtlch\fcs1 \af31507\afs24 \ltrch\fcs0 \b\fs24\cf19\insrsid15891';
    wwv_flow_api.g_varchar2_table(176) := '060\charrsid4407781 ACTUAL}{\rtlch\fcs1 '||wwv_flow.LF||
'\af31507\afs24 \ltrch\fcs0 \fs24\cf19\insrsid15891060\char';
    wwv_flow_api.g_varchar2_table(177) := 'rsid4407781 \cell }{\rtlch\fcs1 \af31507\afs24 \ltrch\fcs0 \b\fs24\cf19\insrsid15891060\charrsid4407';
    wwv_flow_api.g_varchar2_table(178) := '781 ENCUMBERANCE}{\rtlch\fcs1 \af31507\afs24 \ltrch\fcs0 '||wwv_flow.LF||
'\fs24\cf19\insrsid15891060\charrsid440778';
    wwv_flow_api.g_varchar2_table(179) := '1 \cell }{\rtlch\fcs1 \af31507\afs24 \ltrch\fcs0 \b\fs24\cf19\insrsid15891060\charrsid4407781 FUND_A';
    wwv_flow_api.g_varchar2_table(180) := 'VAILABLE}{\rtlch\fcs1 \af31507\afs24 \ltrch\fcs0 \fs24\cf19\insrsid15891060\charrsid4407781 \cell }{';
    wwv_flow_api.g_varchar2_table(181) := '\rtlch\fcs1 '||wwv_flow.LF||
'\af31507\afs24 \ltrch\fcs0 \b\fs24\cf19\insrsid15891060\charrsid4407781 REQUESTED_AMOU';
    wwv_flow_api.g_varchar2_table(182) := 'NT\cell }\pard\plain \ltrpar\ql \li0\ri0\sa160\sl259\slmult1\widctlpar\intbl\wrapdefault\aspalpha\as';
    wwv_flow_api.g_varchar2_table(183) := 'pnum\faauto\adjustright\rin0\lin0 \rtlch\fcs1 '||wwv_flow.LF||
'\af31507\afs22\alang1025 \ltrch\fcs0 \f31506\fs22\la';
    wwv_flow_api.g_varchar2_table(184) := 'ng1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af31507\afs24 \ltrch\fcs0 \fs24\cf19\i';
    wwv_flow_api.g_varchar2_table(185) := 'nsrsid4407781\charrsid4407781 \trowd \irow0\irowband0\ltrrow\ts15\trgaph108\trrh306\trleft-990\trhdr';
    wwv_flow_api.g_varchar2_table(186) := ''||wwv_flow.LF||
'\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrd';
    wwv_flow_api.g_varchar2_table(187) := 'rh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 '||wwv_flow.LF||
'\trftsWidth3\trwWidth30595\trftsWidthB3\trpaddl108\trpaddr';
    wwv_flow_api.g_varchar2_table(188) := '108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid4407781\tbllkhdrrows\tbllkhdrcols\tbllknocolband\';
    wwv_flow_api.g_varchar2_table(189) := 'tblind-882\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb'||wwv_flow.LF||
'\brdrs\brdr';
    wwv_flow_api.g_varchar2_table(190) := 'w10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth1762\clcbpatraw6 \cellx772\clverta';
    wwv_flow_api.g_varchar2_table(191) := 'lt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\clc';
    wwv_flow_api.g_varchar2_table(192) := 'bpat6\cltxlrtb\clftsWidth3\clwWidth3278\clcbpatraw6 \cellx4050\clvertalt\clbrdrt\brdrs\brdrw10 \clbr';
    wwv_flow_api.g_varchar2_table(193) := 'drl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWi';
    wwv_flow_api.g_varchar2_table(194) := 'dth2917\clcbpatraw6 \cellx6967\clvertalt\clbrdrt'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brd';
    wwv_flow_api.g_varchar2_table(195) := 'rs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth2033\clcbpatraw6 \cellx9000';
    wwv_flow_api.g_varchar2_table(196) := '\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw1';
    wwv_flow_api.g_varchar2_table(197) := '0 '||wwv_flow.LF||
'\clcbpat6\cltxlrtb\clftsWidth3\clwWidth6536\clcbpatraw6 \cellx15536\clvertalt\clbrdrt\brdrs\brdr';
    wwv_flow_api.g_varchar2_table(198) := 'w10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWid';
    wwv_flow_api.g_varchar2_table(199) := 'th3\clwWidth2284\clcbpatraw6 \cellx17820\clvertalt\clbrdrt'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \c';
    wwv_flow_api.g_varchar2_table(200) := 'lbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth2430\clcbpatraw6 ';
    wwv_flow_api.g_varchar2_table(201) := '\cellx20250\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\b';
    wwv_flow_api.g_varchar2_table(202) := 'rdrs\brdrw10 '||wwv_flow.LF||
'\clcbpat6\cltxlrtb\clftsWidth3\clwWidth3150\clcbpatraw6 \cellx23400\clvertalt\clbrdrt';
    wwv_flow_api.g_varchar2_table(203) := '\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlr';
    wwv_flow_api.g_varchar2_table(204) := 'tb\clftsWidth3\clwWidth3600\clcbpatraw6 \cellx27000\clvertalt\clbrdrt'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrl\brdrs';
    wwv_flow_api.g_varchar2_table(205) := '\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat6\cltxlrtb\clftsWidth3\clwWidth2605\c';
    wwv_flow_api.g_varchar2_table(206) := 'lcbpatraw6 \cellx29605\row \ltrrow}\trowd \irow1\irowband1\lastrow \ltrrow\ts15\trgaph108\trrh306\tr';
    wwv_flow_api.g_varchar2_table(207) := 'left-990\trbrdrt'||wwv_flow.LF||
'\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw1';
    wwv_flow_api.g_varchar2_table(208) := '0 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 '||wwv_flow.LF||
'\trftsWidth3\trwWidth30595\trftsWidthB3\trpaddl108';
    wwv_flow_api.g_varchar2_table(209) := '\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11427737\tbllkhdrrows\tbllkhdrcols\tbllkn';
    wwv_flow_api.g_varchar2_table(210) := 'ocolband\tblind-882\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb'||wwv_flow.LF||
'\b';
    wwv_flow_api.g_varchar2_table(211) := 'rdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1762\clshdrawnil \cellx772\clverta';
    wwv_flow_api.g_varchar2_table(212) := 'lt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxl';
    wwv_flow_api.g_varchar2_table(213) := 'rtb\clftsWidth3\clwWidth3278\clshdrawnil \cellx4050'||wwv_flow.LF||
'\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs';
    wwv_flow_api.g_varchar2_table(214) := '\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth2917\clshdrawni';
    wwv_flow_api.g_varchar2_table(215) := 'l \cellx6967\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr';
    wwv_flow_api.g_varchar2_table(216) := ''||wwv_flow.LF||
'\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth2033\clshdrawnil \cellx9000\clvertalt\clbrdrt\brdrs\br';
    wwv_flow_api.g_varchar2_table(217) := 'drw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clw';
    wwv_flow_api.g_varchar2_table(218) := 'Width6536\clshdrawnil \cellx15536\clvertalt\clbrdrt'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\';
    wwv_flow_api.g_varchar2_table(219) := 'brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth2284\clshdrawnil \cellx17820\clve';
    wwv_flow_api.g_varchar2_table(220) := 'rtalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\';
    wwv_flow_api.g_varchar2_table(221) := 'cltxlrtb\clftsWidth3\clwWidth2430\clshdrawnil \cellx20250\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\b';
    wwv_flow_api.g_varchar2_table(222) := 'rdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth3150\clshdr';
    wwv_flow_api.g_varchar2_table(223) := 'awnil \cellx23400\clvertalt\clbrdrt\brdrs\brdrw10 '||wwv_flow.LF||
'\clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \c';
    wwv_flow_api.g_varchar2_table(224) := 'lbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth3600\clshdrawnil \cellx27000\clvertalt\clbrdrt\br';
    wwv_flow_api.g_varchar2_table(225) := 'drs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\cltxlrtb\clftsWi';
    wwv_flow_api.g_varchar2_table(226) := 'dth3\clwWidth2605\clshdrawnil \cellx29605\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault';
    wwv_flow_api.g_varchar2_table(227) := '\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts15 \rtlch\fcs1 \af31507\afs22\alang1025 \ltrch\fcs0';
    wwv_flow_api.g_varchar2_table(228) := ' '||wwv_flow.LF||
'\f31506\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\field\fldedit{\*\fldinst {\rtlch';
    wwv_flow_api.g_varchar2_table(229) := '\fcs1 \af31507 \ltrch\fcs0 \cf9\insrsid15891060\charrsid275237 {\*\bkmkstart Text1} FORMTEXT }{\rtlc';
    wwv_flow_api.g_varchar2_table(230) := 'h\fcs1 \af31507 \ltrch\fcs0 '||wwv_flow.LF||
'\cf9\insrsid15891060\charrsid275237 {\*\datafield 80010000000000000554';
    wwv_flow_api.g_varchar2_table(231) := '657874310002462000000000000f3c3f7265663a78646f303030313f3e0000000000}{\*\formfield{\fftype0\ffownhel';
    wwv_flow_api.g_varchar2_table(232) := 'p\ffownstat\fftypetxt0{\*\ffname Text1}{\*\ffdeftext F }{\*\ffstattext '||wwv_flow.LF||
'<?ref:xdo0001?>}}}}}{\fldrs';
    wwv_flow_api.g_varchar2_table(233) := 'lt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \cf9\lang1024\langfe1024\noproof\insrsid15891060\charrsid275237';
    wwv_flow_api.g_varchar2_table(234) := ' F}}}\sectd \ltrsect\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid11427737\s';
    wwv_flow_api.g_varchar2_table(235) := 'ftnbj {\*\bkmkend Text1}'||wwv_flow.LF||
'{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid1589';
    wwv_flow_api.g_varchar2_table(236) := '1060\charrsid275237 {\*\bkmkstart Text2} FORMTEXT }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid1589106';
    wwv_flow_api.g_varchar2_table(237) := '0\charrsid275237 {\*\datafield '||wwv_flow.LF||
'800100000000000005546578743200094c494e455f5459455000000000000f3c3f7';
    wwv_flow_api.g_varchar2_table(238) := '265663a78646f303030323f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname ';
    wwv_flow_api.g_varchar2_table(239) := 'Text2}{\*\ffdeftext LINE_TYEP}{\*\ffstattext <?ref:xdo0002?>}}}}}{\fldrslt {\rtlch\fcs1 '||wwv_flow.LF||
'\af31507 \';
    wwv_flow_api.g_varchar2_table(240) := 'ltrch\fcs0 \lang1024\langfe1024\noproof\insrsid15891060\charrsid275237 LINE_TYEP}}}\sectd \ltrsect\l';
    wwv_flow_api.g_varchar2_table(241) := 'ndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid11427737\sftnbj {\rtlch\fcs1 \af';
    wwv_flow_api.g_varchar2_table(242) := '31507 \ltrch\fcs0 \insrsid15891060 '||wwv_flow.LF||
'{\*\bkmkend Text2}\cell }{\field\flddirty{\*\fldinst {\rtlch\fc';
    wwv_flow_api.g_varchar2_table(243) := 's1 \af31507 \ltrch\fcs0 \insrsid15891060\charrsid275237 {\*\bkmkstart Text3} FORMTEXT }{\rtlch\fcs1 ';
    wwv_flow_api.g_varchar2_table(244) := '\af31507 \ltrch\fcs0 \insrsid15891060\charrsid275237 {\*\datafield '||wwv_flow.LF||
'8001000000000000055465787433000';
    wwv_flow_api.g_varchar2_table(245) := 'e50524f4a4543545f4e554d42455200000000000f3c3f7265663a78646f303030333f3e0000000000}{\*\formfield{\fft';
    wwv_flow_api.g_varchar2_table(246) := 'ype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text3}{\*\ffdeftext PROJECT_NUMBER}{\*\ffstattext <?re';
    wwv_flow_api.g_varchar2_table(247) := 'f:xdo0003?>}}}}'||wwv_flow.LF||
'}{\fldrslt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \lang1024\langfe1024\noproof\insrsid15';
    wwv_flow_api.g_varchar2_table(248) := '891060\charrsid275237 PROJECT_NUMBER}}}\sectd \ltrsect\lndscpsxn\psz8\linex0\endnhere\sectlinegrid36';
    wwv_flow_api.g_varchar2_table(249) := '0\sectdefaultcl\sectrsid11427737\sftnbj {\rtlch\fcs1 \af31507 '||wwv_flow.LF||
'\ltrch\fcs0 \insrsid15891060 {\*\bkm';
    wwv_flow_api.g_varchar2_table(250) := 'kend Text3}\cell }{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid15891060\cha';
    wwv_flow_api.g_varchar2_table(251) := 'rrsid275237 {\*\bkmkstart Text4} FORMTEXT }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid15891060\charrs';
    wwv_flow_api.g_varchar2_table(252) := 'id275237 '||wwv_flow.LF||
'{\*\datafield 8001000000000000055465787434000b5441534b5f4e554d42455200000000000f3c3f72656';
    wwv_flow_api.g_varchar2_table(253) := '63a78646f303030343f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text';
    wwv_flow_api.g_varchar2_table(254) := '4}{\*\ffdeftext TASK_NUMBER}{\*\ffstattext <?ref:xdo0004?>}}}}'||wwv_flow.LF||
'}{\fldrslt {\rtlch\fcs1 \af31507 \lt';
    wwv_flow_api.g_varchar2_table(255) := 'rch\fcs0 \lang1024\langfe1024\noproof\insrsid15891060\charrsid275237 TASK_NUMBER}}}\sectd \ltrsect\l';
    wwv_flow_api.g_varchar2_table(256) := 'ndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid11427737\sftnbj {\rtlch\fcs1 \af';
    wwv_flow_api.g_varchar2_table(257) := '31507 \ltrch\fcs0 '||wwv_flow.LF||
'\insrsid15891060 {\*\bkmkend Text4}\cell }{\field\flddirty{\*\fldinst {\rtlch\fc';
    wwv_flow_api.g_varchar2_table(258) := 's1 \af31507 \ltrch\fcs0 \insrsid15891060\charrsid275237 {\*\bkmkstart Text5} FORMTEXT }{\rtlch\fcs1 ';
    wwv_flow_api.g_varchar2_table(259) := '\af31507 \ltrch\fcs0 \insrsid15891060\charrsid275237 {\*\datafield '||wwv_flow.LF||
'8001000000000000055465787435000';
    wwv_flow_api.g_varchar2_table(260) := 'b434f53545f43454e54455200000000000f3c3f7265663a78646f303030353f3e0000000000}{\*\formfield{\fftype0\f';
    wwv_flow_api.g_varchar2_table(261) := 'fownhelp\ffownstat\fftypetxt0{\*\ffname Text5}{\*\ffdeftext COST_CENTER}{\*\ffstattext <?ref:xdo0005';
    wwv_flow_api.g_varchar2_table(262) := '?>}}}}}{\fldrslt {'||wwv_flow.LF||
'\rtlch\fcs1 \af31507 \ltrch\fcs0 \lang1024\langfe1024\noproof\insrsid15891060\ch';
    wwv_flow_api.g_varchar2_table(263) := 'arrsid275237 COST_CENTER}}}\sectd \ltrsect\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaul';
    wwv_flow_api.g_varchar2_table(264) := 'tcl\sectrsid11427737\sftnbj {\rtlch\fcs1 \af31507 \ltrch\fcs0 '||wwv_flow.LF||
'\insrsid15891060 {\*\bkmkend Text5}\';
    wwv_flow_api.g_varchar2_table(265) := 'cell }{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid15891060\charrsid275237 ';
    wwv_flow_api.g_varchar2_table(266) := '{\*\bkmkstart Text6} FORMTEXT }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid15891060\charrsid275237 {\*';
    wwv_flow_api.g_varchar2_table(267) := '\datafield '||wwv_flow.LF||
'80010000000000000554657874360010455850454e4449545552455f5459504500000000000f3c3f7265663';
    wwv_flow_api.g_varchar2_table(268) := 'a78646f303030363f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text6}';
    wwv_flow_api.g_varchar2_table(269) := '{\*\ffdeftext EXPENDITURE_TYPE}{\*\ffstattext <?ref:xdo0006?>}}}}'||wwv_flow.LF||
'}{\fldrslt {\rtlch\fcs1 \af31507 ';
    wwv_flow_api.g_varchar2_table(270) := '\ltrch\fcs0 \lang1024\langfe1024\noproof\insrsid15891060\charrsid275237 EXPENDITURE_TYPE}}}\sectd \l';
    wwv_flow_api.g_varchar2_table(271) := 'trsect\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid11427737\sftnbj {\rtlch\';
    wwv_flow_api.g_varchar2_table(272) := 'fcs1 \af31507 '||wwv_flow.LF||
'\ltrch\fcs0 \insrsid15891060 {\*\bkmkend Text6}\cell }\pard \ltrpar\qr \li0\ri0\widc';
    wwv_flow_api.g_varchar2_table(273) := 'tlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid2516404\yts15 {\field{\';
    wwv_flow_api.g_varchar2_table(274) := '*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid13715767 '||wwv_flow.LF||
'{\*\bkmkstart Text15} FORMTEXT }{\rtl';
    wwv_flow_api.g_varchar2_table(275) := 'ch\fcs1 \af31507 \ltrch\fcs0 \insrsid13715767 {\*\datafield 800b000000000000065465787431350008392c39';
    wwv_flow_api.g_varchar2_table(276) := '39392e30300008232c2323302e30300000000f3c3f7265663a78646f303030373f3e0000000000}'||wwv_flow.LF||
'{\*\formfield{\ffty';
    wwv_flow_api.g_varchar2_table(277) := 'pe0\ffownhelp\ffownstat\ffprot\fftypetxt1{\*\ffname Text15}{\*\ffdeftext 9,999.00}{\*\ffformat #,##0';
    wwv_flow_api.g_varchar2_table(278) := '.00}{\*\ffstattext <?ref:xdo0007?>}}}}}{\fldrslt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \lang1024\langfe1';
    wwv_flow_api.g_varchar2_table(279) := '024\noproof\insrsid13715767 9,999.00'||wwv_flow.LF||
'}}}\sectd \ltrsect\lndscpsxn\psz8\linex0\endnhere\sectlinegrid';
    wwv_flow_api.g_varchar2_table(280) := '360\sectdefaultcl\sectrsid11427737\sftnbj {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid15891060 {\*\bkm';
    wwv_flow_api.g_varchar2_table(281) := 'kend Text15}\cell }{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 '||wwv_flow.LF||
'\insrsid10898819 ';
    wwv_flow_api.g_varchar2_table(282) := '{\*\bkmkstart Text17} FORMTEXT }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid10898819 {\*\datafield 800';
    wwv_flow_api.g_varchar2_table(283) := 'b000000000000065465787431370008392c3939392e30300008232c2323302e30300000000f3c3f7265663a78646f3030303';
    wwv_flow_api.g_varchar2_table(284) := '83f3e0000000000}'||wwv_flow.LF||
'{\*\formfield{\fftype0\ffownhelp\ffownstat\ffprot\fftypetxt1{\*\ffname Text17}{\*\';
    wwv_flow_api.g_varchar2_table(285) := 'ffdeftext 9,999.00}{\*\ffformat #,##0.00}{\*\ffstattext <?ref:xdo0008?>}}}}}{\fldrslt {\rtlch\fcs1 \';
    wwv_flow_api.g_varchar2_table(286) := 'af31507 \ltrch\fcs0 \lang1024\langfe1024\noproof\insrsid10898819 9,999.00'||wwv_flow.LF||
'}}}\sectd \ltrsect\lndscp';
    wwv_flow_api.g_varchar2_table(287) := 'sxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid11427737\sftnbj {\rtlch\fcs1 \af31507';
    wwv_flow_api.g_varchar2_table(288) := ' \ltrch\fcs0 \insrsid15891060 {\*\bkmkend Text17}\cell }{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af';
    wwv_flow_api.g_varchar2_table(289) := '31507 \ltrch\fcs0 '||wwv_flow.LF||
'\insrsid10898819 {\*\bkmkstart Text18} FORMTEXT }{\rtlch\fcs1 \af31507 \ltrch\fc';
    wwv_flow_api.g_varchar2_table(290) := 's0 \insrsid10898819 {\*\datafield 800b000000000000065465787431380008392c3939392e30300008232c2323302e';
    wwv_flow_api.g_varchar2_table(291) := '30300000000f3c3f7265663a78646f303030393f3e0000000000}'||wwv_flow.LF||
'{\*\formfield{\fftype0\ffownhelp\ffownstat\ff';
    wwv_flow_api.g_varchar2_table(292) := 'prot\fftypetxt1{\*\ffname Text18}{\*\ffdeftext 9,999.00}{\*\ffformat #,##0.00}{\*\ffstattext <?ref:x';
    wwv_flow_api.g_varchar2_table(293) := 'do0009?>}}}}}{\fldrslt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \lang1024\langfe1024\noproof\insrsid1089881';
    wwv_flow_api.g_varchar2_table(294) := '9 9,999.00'||wwv_flow.LF||
'}}}\sectd \ltrsect\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid';
    wwv_flow_api.g_varchar2_table(295) := '11427737\sftnbj {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid15891060 {\*\bkmkend Text18}\cell }{\field';
    wwv_flow_api.g_varchar2_table(296) := '\flddirty{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 '||wwv_flow.LF||
'\insrsid10898819 {\*\bkmkstart Text19} FORM';
    wwv_flow_api.g_varchar2_table(297) := 'TEXT }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid10898819 {\*\datafield 800b0000000000000654657874313';
    wwv_flow_api.g_varchar2_table(298) := '90008392c3939392e30300008232c2323302e30300000000f3c3f7265663a78646f303031303f3e0000000000}'||wwv_flow.LF||
'{\*\form';
    wwv_flow_api.g_varchar2_table(299) := 'field{\fftype0\ffownhelp\ffownstat\ffprot\fftypetxt1{\*\ffname Text19}{\*\ffdeftext 9,999.00}{\*\fff';
    wwv_flow_api.g_varchar2_table(300) := 'ormat #,##0.00}{\*\ffstattext <?ref:xdo0010?>}}}}}{\fldrslt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \lang1';
    wwv_flow_api.g_varchar2_table(301) := '024\langfe1024\noproof\insrsid10898819 9,999.00'||wwv_flow.LF||
'}}}\sectd \ltrsect\lndscpsxn\psz8\linex0\endnhere\s';
    wwv_flow_api.g_varchar2_table(302) := 'ectlinegrid360\sectdefaultcl\sectrsid11427737\sftnbj {\*\bkmkend Text19}{\field\flddirty{\*\fldinst ';
    wwv_flow_api.g_varchar2_table(303) := '{\rtlch\fcs1 \af31507 \ltrch\fcs0 \cf9\insrsid15891060\charrsid275237 {\*\bkmkstart Text11} FORMTEXT';
    wwv_flow_api.g_varchar2_table(304) := ' }{'||wwv_flow.LF||
'\rtlch\fcs1 \af31507 \ltrch\fcs0 \cf9\insrsid15891060\charrsid275237 {\*\datafield 800100000000';
    wwv_flow_api.g_varchar2_table(305) := '0000065465787431310002204500000000000f3c3f7265663a78646f303031313f3e0000000000}{\*\formfield{\fftype';
    wwv_flow_api.g_varchar2_table(306) := '0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text11}'||wwv_flow.LF||
'{\*\ffdeftext  E}{\*\ffstattext <?ref:xdo0011?>}';
    wwv_flow_api.g_varchar2_table(307) := '}}}}{\fldrslt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \cf9\lang1024\langfe1024\noproof\insrsid15891060\cha';
    wwv_flow_api.g_varchar2_table(308) := 'rrsid275237  E}}}\sectd \ltrsect'||wwv_flow.LF||
'\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sect';
    wwv_flow_api.g_varchar2_table(309) := 'rsid11427737\sftnbj {\*\bkmkend Text11}{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0';
    wwv_flow_api.g_varchar2_table(310) := ' \cf9\insrsid535924 {\*\bkmkstart Text13} FORMTEXT }{\rtlch\fcs1 \af31507 \ltrch\fcs0 '||wwv_flow.LF||
'\cf9\insrsid';
    wwv_flow_api.g_varchar2_table(311) := '535924 {\*\datafield 8001000000000000065465787431330002432000000000000f3c3f7265663a78646f303031333f3';
    wwv_flow_api.g_varchar2_table(312) := 'e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text13}{\*\ffdeftext C }';
    wwv_flow_api.g_varchar2_table(313) := '{\*\ffstattext <?ref:xdo0013?>}}}}'||wwv_flow.LF||
'}{\fldrslt {\rtlch\fcs1 \af31507 \ltrch\fcs0 \cf9\lang1024\langf';
    wwv_flow_api.g_varchar2_table(314) := 'e1024\noproof\insrsid535924 C }}}\sectd \ltrsect\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sect';
    wwv_flow_api.g_varchar2_table(315) := 'defaultcl\sectrsid11427737\sftnbj {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid15891060 '||wwv_flow.LF||
'{\*\bkmkend T';
    wwv_flow_api.g_varchar2_table(316) := 'ext13}\cell }{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid11020367 {\*\bkmk';
    wwv_flow_api.g_varchar2_table(317) := 'start Text12} FORMTEXT }{\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid11020367 {\*\datafield '||wwv_flow.LF||
'800100000';
    wwv_flow_api.g_varchar2_table(318) := '0000000065465787431320002432000000000000f3c3f7265663a78646f303031323f3e0000000000}{\*\formfield{\fft';
    wwv_flow_api.g_varchar2_table(319) := 'ype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text12}{\*\ffdeftext C }{\*\ffstattext <?ref:xdo0012?>';
    wwv_flow_api.g_varchar2_table(320) := '}}}}}{\fldrslt {\rtlch\fcs1 \af31507 '||wwv_flow.LF||
'\ltrch\fcs0 \lang1024\langfe1024\noproof\insrsid11020367 C }}';
    wwv_flow_api.g_varchar2_table(321) := '}\sectd \ltrsect\lndscpsxn\psz8\linex0\endnhere\sectlinegrid360\sectdefaultcl\sectrsid11427737\sftnb';
    wwv_flow_api.g_varchar2_table(322) := 'j {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid15891060\charrsid275237 {\*\bkmkend Text12}\cell '||wwv_flow.LF||
'}\par';
    wwv_flow_api.g_varchar2_table(323) := 'd\plain \ltrpar\ql \li0\ri0\sa160\sl259\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\a';
    wwv_flow_api.g_varchar2_table(324) := 'djustright\rin0\lin0 \rtlch\fcs1 \af31507\afs22\alang1025 \ltrch\fcs0 \f31506\fs22\lang1033\langfe10';
    wwv_flow_api.g_varchar2_table(325) := '33\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 '||wwv_flow.LF||
'\af31507 \ltrch\fcs0 \insrsid11427737 \trowd \irow1\';
    wwv_flow_api.g_varchar2_table(326) := 'irowband1\lastrow \ltrrow\ts15\trgaph108\trrh306\trleft-990\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brd';
    wwv_flow_api.g_varchar2_table(327) := 'rw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 '||wwv_flow.LF||
'\';
    wwv_flow_api.g_varchar2_table(328) := 'trftsWidth3\trwWidth30595\trftsWidthB3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3';
    wwv_flow_api.g_varchar2_table(329) := '\tblrsid11427737\tbllkhdrrows\tbllkhdrcols\tbllknocolband\tblind-882\tblindtype3 \clvertalt\clbrdrt\';
    wwv_flow_api.g_varchar2_table(330) := 'brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb'||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clfts';
    wwv_flow_api.g_varchar2_table(331) := 'Width3\clwWidth1762\clshdrawnil \cellx772\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \cl';
    wwv_flow_api.g_varchar2_table(332) := 'brdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth3278\clshdrawnil \cellx4050';
    wwv_flow_api.g_varchar2_table(333) := ''||wwv_flow.LF||
'\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdr';
    wwv_flow_api.g_varchar2_table(334) := 'w10 \cltxlrtb\clftsWidth3\clwWidth2917\clshdrawnil \cellx6967\clvertalt\clbrdrt\brdrs\brdrw10 \clbrd';
    wwv_flow_api.g_varchar2_table(335) := 'rl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr'||wwv_flow.LF||
'\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth2033\';
    wwv_flow_api.g_varchar2_table(336) := 'clshdrawnil \cellx9000\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10';
    wwv_flow_api.g_varchar2_table(337) := ' \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth6536\clshdrawnil \cellx15536\clvertalt\clbrdrt';
    wwv_flow_api.g_varchar2_table(338) := ''||wwv_flow.LF||
'\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clft';
    wwv_flow_api.g_varchar2_table(339) := 'sWidth3\clwWidth2284\clshdrawnil \cellx17820\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 ';
    wwv_flow_api.g_varchar2_table(340) := '\clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\cltxlrtb\clftsWidth3\clwWidth2430\clshdrawnil \cell';
    wwv_flow_api.g_varchar2_table(341) := 'x20250\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\';
    wwv_flow_api.g_varchar2_table(342) := 'brdrw10 \cltxlrtb\clftsWidth3\clwWidth3150\clshdrawnil \cellx23400\clvertalt\clbrdrt\brdrs\brdrw10 ';
    wwv_flow_api.g_varchar2_table(343) := ''||wwv_flow.LF||
'\clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth';
    wwv_flow_api.g_varchar2_table(344) := '3600\clshdrawnil \cellx27000\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\b';
    wwv_flow_api.g_varchar2_table(345) := 'rdrw10 \clbrdrr\brdrs\brdrw10 '||wwv_flow.LF||
'\cltxlrtb\clftsWidth3\clwWidth2605\clshdrawnil \cellx29605\row }\par';
    wwv_flow_api.g_varchar2_table(346) := 'd \ltrpar\ql \li0\ri0\sa160\sl259\slmult1\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright\r';
    wwv_flow_api.g_varchar2_table(347) := 'in0\lin0\itap0 {\rtlch\fcs1 \af31507 \ltrch\fcs0 \insrsid10318050 '||wwv_flow.LF||
'\par }{\rtlch\fcs1 \af31507 \ltr';
    wwv_flow_api.g_varchar2_table(348) := 'ch\fcs0 \insrsid275237 '||wwv_flow.LF||
'\par }{\*\themedata 504b030414000600080000002100e9de0fbfff0000001c020000130';
    wwv_flow_api.g_varchar2_table(349) := '000005b436f6e74656e745f54797065735d2e786d6cac91cb4ec3301045f748fc83e52d4a'||wwv_flow.LF||
'9cb2400825e982c78ec7a27cc';
    wwv_flow_api.g_varchar2_table(350) := '0c8992416c9d8b2a755fbf74cd25442a820166c2cd933f79e3be372bd1f07b5c3989ca74aaff2422b24eb1b475da5df374fd';
    wwv_flow_api.g_varchar2_table(351) := '9ad'||wwv_flow.LF||
'5689811a183c61a50f98f4babebc2837878049899a52a57be670674cb23d8e90721f90a4d2fa3802cb35762680fd800';
    wwv_flow_api.g_varchar2_table(352) := 'ecd7551dc18eb899138e3c943d7e503b6'||wwv_flow.LF||
'b01d583deee5f99824e290b4ba3f364eac4a430883b3c092d4eca8f946c916422';
    wwv_flow_api.g_varchar2_table(353) := 'ecab927f52ea42b89a1cd59c254f919b0e85e6535d135a8de20f20b8c12c3b0'||wwv_flow.LF||
'0c895fcf6720192de6bf3b9e89ecdbd6596';
    wwv_flow_api.g_varchar2_table(354) := 'cbcdd8eb28e7c365ecc4ec1ff1460f53fe813d3cc7f5b7f020000ffff0300504b030414000600080000002100a5d6'||wwv_flow.LF||
'a7e7c';
    wwv_flow_api.g_varchar2_table(355) := '0000000360100000b0000005f72656c732f2e72656c73848fcf6ac3300c87ef85bd83d17d51d2c31825762fa590432fa37d0';
    wwv_flow_api.g_varchar2_table(356) := '0e1287f68221bdb1bebdb4f'||wwv_flow.LF||
'c7060abb0884a4eff7a93dfeae8bf9e194e720169aaa06c3e2433fcb68e1763dbf7f82c985a';
    wwv_flow_api.g_varchar2_table(357) := '4a725085b787086a37bdbb55fbc50d1a33ccd311ba548b6309512'||wwv_flow.LF||
'0f88d94fbc52ae4264d1c910d24a45db3462247fa7917';
    wwv_flow_api.g_varchar2_table(358) := '15fd71f989e19e0364cd3f51652d73760ae8fa8c9ffb3c330cc9e4fc17faf2ce545046e37944c69e462'||wwv_flow.LF||
'a1a82fe353bd90a';
    wwv_flow_api.g_varchar2_table(359) := '865aad41ed0b5b8f9d6fd010000ffff0300504b0304140006000800000021006b799616830000008a0000001c00000074686';
    wwv_flow_api.g_varchar2_table(360) := '56d652f746865'||wwv_flow.LF||
'6d652f7468656d654d616e616765722e786d6c0ccc4d0ac3201040e17da17790d93763bb284562b2cbaeb';
    wwv_flow_api.g_varchar2_table(361) := 'bf600439c1a41c7a0d29fdbd7e5e38337cedf14d59b'||wwv_flow.LF||
'4b0d592c9c070d8a65cd2e88b7f07c2ca71ba8da481cc52c6ce1c71';
    wwv_flow_api.g_varchar2_table(362) := '5e6e97818c9b48d13df49c873517d23d59085adb5dd20d6b52bd521ef2cdd5eb9246a3d8b'||wwv_flow.LF||
'4757e8d3f729e245eb2b260a0';
    wwv_flow_api.g_varchar2_table(363) := '238fd010000ffff0300504b030414000600080000002100d3130843c40600008b1a0000160000007468656d652f7468656d6';
    wwv_flow_api.g_varchar2_table(364) := '52f'||wwv_flow.LF||
'7468656d65312e786d6cec595d8bdb46147d2ff43f08bd3bfe92fcb1c41b6cd9ceb6d94d42eca4e4716c8fadc98e344';
    wwv_flow_api.g_varchar2_table(365) := '633de8d0981923c160aa569e943037deb'||wwv_flow.LF||
'43691b48a02fe9afd936a54d217fa17746b63c638fbb9b2585a5640d8b343af7c';
    wwv_flow_api.g_varchar2_table(366) := 'e997bafce1d4997afdc8fa87384134e58dc708b970aae83e3211b9178d2706f'||wwv_flow.LF||
'f7bbb99aeb7081e211a22cc60d778eb97b6';
    wwv_flow_api.g_varchar2_table(367) := '5f7c30f2ea31d11e2083b601ff31dd4704321a63bf93c1fc230e297d814c7706dcc920809384d26f951828ec16f44'||wwv_flow.LF||
'f3a54';
    wwv_flow_api.g_varchar2_table(368) := '2a1928f10895d274611b8bd311e932176fad2a5bbbb74dea1701a0b2e078634e949d7d8b050d8d1615122f89c0734718e106';
    wwv_flow_api.g_varchar2_table(369) := 'db830cf881df7f17de13a14'||wwv_flow.LF||
'7101171a6e41fdb9f9ddcb79b4b330a2628bad66d7557f0bbb85c1e8b0a4e64c26836c52cff';
    wwv_flow_api.g_varchar2_table(370) := '3bd4a33f3af00546ce23ad54ea553c9fc29001a0e61a52917d367'||wwv_flow.LF||
'b514780bac064a0f2dbedbd576b968e035ffe50dce4d5';
    wwv_flow_api.g_varchar2_table(371) := 'ffe0cbc02a5febd0d7cb71b40140dbc02a5787f03efb7eaadb6e95f81527c65035f2d34db5ed5f0af40'||wwv_flow.LF||
'2125f1e106bae05';
    wwv_flow_api.g_varchar2_table(372) := '7cac172b51964cce89e155ef7bd6eb5b470be42413564d525a718b3586cabb508dd6349170012489120b123e6533c4643a8e';
    wwv_flow_api.g_varchar2_table(373) := '20051324888b3'||wwv_flow.LF||
'4f262114de14c58cc370a154e816caf05ffe3c75a4328a7630d2ac252f60c23786241f870f1332150df76';
    wwv_flow_api.g_varchar2_table(374) := '3f0ea6a90372f7f7cf3f2b973f2e8c5c9a35f4e1e3f'||wwv_flow.LF||
'3e79f473eac8b0da43f144b77afdfd177f3ffdd4f9ebf977af9f7c6';
    wwv_flow_api.g_varchar2_table(375) := '5c7731dfffb4f9ffdf6eb977620ac741582575f3ffbe3c5b357df7cfee70f4f2cf0668206'||wwv_flow.LF||
'3abc4f22cc9debf8d8b9c5225';
    wwv_flow_api.g_varchar2_table(376) := '8980a81c91c0f92b7b3e88788e816cd78c2518ce42c16ff1d111ae8eb73449105d7c26604ef24203136e0d5d93d83702f4c6';
    wwv_flow_api.g_varchar2_table(377) := '682'||wwv_flow.LF||
'583c5e0b230378c0186db1c41a856b722e2dccfd593cb14f9ecc74dc2d848e6c73072836f2db994d415b89cd6510628';
    wwv_flow_api.g_varchar2_table(378) := '3e64d8a62812638c6c291d7d821c696d5'||wwv_flow.LF||
'dd25c488eb0119268cb3b170ee12a7858835247d3230aa6965b44722c8cbdc461';
    wwv_flow_api.g_varchar2_table(379) := '0f26dc4e6e08ed362d4b6ea363e32917057206a21dfc7d408e355341328b2b9'||wwv_flow.LF||
'eca388ea01df4722b491eccd93a18eeb700';
    wwv_flow_api.g_varchar2_table(380) := '1999e60ca9cce08736eb3b991c07ab5a45f0379b1a7fd80ce231399087268f3b98f18d3916d761884289adab03d12'||wwv_flow.LF||
'873af';
    wwv_flow_api.g_varchar2_table(381) := '6237e08258a9c9b4cd8e007ccbc43e439e401c55bd37d876023dda7abc16d50569dd2aa40e4955962c9e555cc8cfaedcde91';
    wwv_flow_api.g_varchar2_table(382) := '861253520fc869e47243e55'||wwv_flow.LF||
'dcd764ddff6f651d84f4d5b74f2dabbaa882de4c88f58eda5b93f16db875f10e583222175fb';
    wwv_flow_api.g_varchar2_table(383) := 'bdb6816dfc470bb6c36b0f7d2fd5ebaddffbd746fbb9fdfbd60af'||wwv_flow.LF||
'341ae45b6e15d3adbadab8475bf7ed6342694fcc29dee';
    wwv_flow_api.g_varchar2_table(384) := '76aebcea1338dba3028edd4332bce9ee3a6211cca3b192630709304291b2761e21322c25e88a6b0bf2f'||wwv_flow.LF||
'bad2c9842f5c4fb';
    wwv_flow_api.g_varchar2_table(385) := '833651cb6fd6ad8ea5be2e92c3a60a3f471b558948fa6a978702456e3053f1b87470d91a22bd5d52358e65eb19da847e5250';
    wwv_flow_api.g_varchar2_table(386) := '169fb3624b4c9'||wwv_flow.LF||
'4c12650b89ea725006493d9843d02c24d4cade098bba85454dba5fa66a830550cbb2025b2707365c0dd7f';
    wwv_flow_api.g_varchar2_table(387) := '7c0048ce0890a513c92794a53bdccae4ae6bbccf4b6'||wwv_flow.LF||
'601a1500fb886505ac325d975cb72e4fae2e2db53364da20a1959b4';
    wwv_flow_api.g_varchar2_table(388) := '9424546f5301ea2115e54a71c3d0b8db7cd757d9552839e0c859a0f4a6b45a35afb3716e7'||wwv_flow.LF||
'cd35d8ad6b038d75a5a0b173d';
    wwv_flow_api.g_varchar2_table(389) := 'c702b651f4a6688a60d770c8ffd70184da176b8dcf2223a8177674391a437fc7994659a70d1463c4c03ae4427558388089c3';
    wwv_flow_api.g_varchar2_table(390) := '894'||wwv_flow.LF||
'440d572e3f4b038d9586286ec51208c28525570759b968e420e96692f1788c87424fbb3622239d9e82c2a75a61bdaac';
    wwv_flow_api.g_varchar2_table(391) := 'ccf0f96966c06e9ee85a363674067c92d'||wwv_flow.LF||
'0425e6578b328023c2e1ed4f318de688c0ebcc4cc856f5b7d69816b2abbf4f543';
    wwv_flow_api.g_varchar2_table(392) := '5948e233a0dd1a2a3e8629ec295946774d4591603ed6cb16608a8169245231c'||wwv_flow.LF||
'4c6483d5836a74d3ac6ba41cb676ddd38d6';
    wwv_flow_api.g_varchar2_table(393) := '4e434d15cf54c435564d7b4ab9831c3b20dacc5f27c4d5e63b50c31689adee153e95e97dcfa52ebd6f60959978080'||wwv_flow.LF||
'67f1b';
    wwv_flow_api.g_varchar2_table(394) := '374dd3334048dda6a32839a64bc29c352b317a366ef582ef0146a6769129aea57966ed7e296f508eb743078aece0f76eb550';
    wwv_flow_api.g_varchar2_table(395) := 'b43e3e5be52455a7df7d03f'||wwv_flow.LF||
'4db0c13d108f36bc049e51c1552ae1c343826043d4537b925436e016b92f16b7061c39b3843';
    wwv_flow_api.g_varchar2_table(396) := '4dc0705bfe905253fc8156a7e27e795bd42aee637cbb9a6ef978b'||wwv_flow.LF||
'1dbf5868b74a0fa1b188302afae937972ebc8aa2f3c59';
    wwv_flow_api.g_varchar2_table(397) := '71735bef1f5255abe6dbb3464519ea9af2b79455c7d7d2996b67f7d710888ce834aa95b2fd75b955cbd'||wwv_flow.LF||
'dcece6bc76ab96a';
    wwv_flow_api.g_varchar2_table(398) := 'b079556ae5d09aaed6e3bf06bf5ee43d7395260af590ebc4aa796ab148320e7550a927ead9eab7aa552d3ab366b1daff970b';
    wwv_flow_api.g_varchar2_table(399) := '18d8195a7f2b1'||wwv_flow.LF||
'88058457f1dafd070000ffff0300504b0304140006000800000021000dd1909fb60000001b01000027000';
    wwv_flow_api.g_varchar2_table(400) := '0007468656d652f7468656d652f5f72656c732f7468'||wwv_flow.LF||
'656d654d616e616765722e786d6c2e72656c73848f4d0ac2301484f';
    wwv_flow_api.g_varchar2_table(401) := '78277086f6fd3ba109126dd88d0add40384e4350d363f2451eced0dae2c082e8761be9969'||wwv_flow.LF||
'bb979dc9136332de3168aa1a0';
    wwv_flow_api.g_varchar2_table(402) := '83ae995719ac16db8ec8e4052164e89d93b64b060828e6f37ed1567914b284d262452282e3198720e274a939cd08a54f980a';
    wwv_flow_api.g_varchar2_table(403) := 'e38'||wwv_flow.LF||
'a38f56e422a3a641c8bbd048f7757da0f19b017cc524bd62107bd5001996509affb3fd381a89672f1f165dfe514173d';
    wwv_flow_api.g_varchar2_table(404) := '9850528a2c6cce0239baa4c04ca5bbaba'||wwv_flow.LF||
'c4df000000ffff0300504b01022d0014000600080000002100e9de0fbfff00000';
    wwv_flow_api.g_varchar2_table(405) := '01c0200001300000000000000000000000000000000005b436f6e74656e745f'||wwv_flow.LF||
'54797065735d2e786d6c504b01022d00140';
    wwv_flow_api.g_varchar2_table(406) := '00600080000002100a5d6a7e7c0000000360100000b00000000000000000000000000300100005f72656c732f2e72'||wwv_flow.LF||
'656c7';
    wwv_flow_api.g_varchar2_table(407) := '3504b01022d00140006000800000021006b799616830000008a0000001c00000000000000000000000000190200007468656';
    wwv_flow_api.g_varchar2_table(408) := 'd652f7468656d652f746865'||wwv_flow.LF||
'6d654d616e616765722e786d6c504b01022d0014000600080000002100d3130843c40600008';
    wwv_flow_api.g_varchar2_table(409) := 'b1a00001600000000000000000000000000d60200007468656d65'||wwv_flow.LF||
'2f7468656d652f7468656d65312e786d6c504b01022d0';
    wwv_flow_api.g_varchar2_table(410) := '0140006000800000021000dd1909fb60000001b0100002700000000000000000000000000ce0900007468656d652f7468656';
    wwv_flow_api.g_varchar2_table(411) := 'd652f5f72656c732f7468656d654d616e616765722e786d6c2e72656c73504b050600000000050005005d010000c90a00000';
    wwv_flow_api.g_varchar2_table(412) := '000}'||wwv_flow.LF||
'{\*\colorschememapping 3c3f786d6c2076657273696f6e3d22312e302220656e636f64696e673d225554462d382';
    wwv_flow_api.g_varchar2_table(413) := '2207374616e64616c6f6e653d22796573223f3e0d0a3c613a636c724d'||wwv_flow.LF||
'617020786d6c6e733a613d22687474703a2f2f736';
    wwv_flow_api.g_varchar2_table(414) := '368656d61732e6f70656e786d6c666f726d6174732e6f72672f64726177696e676d6c2f323030362f6d6169'||wwv_flow.LF||
'6e222062673';
    wwv_flow_api.g_varchar2_table(415) := '13d226c743122207478313d22646b3122206267323d226c743222207478323d22646b322220616363656e74313d226163636';
    wwv_flow_api.g_varchar2_table(416) := '56e74312220616363'||wwv_flow.LF||
'656e74323d22616363656e74322220616363656e74333d22616363656e74332220616363656e74343';
    wwv_flow_api.g_varchar2_table(417) := 'd22616363656e74342220616363656e74353d22616363656e74352220616363656e74363d22616363656e74362220686c696';
    wwv_flow_api.g_varchar2_table(418) := 'e6b3d22686c696e6b2220666f6c486c696e6b3d22666f6c486c696e6b222f3e}'||wwv_flow.LF||
'{\*\latentstyles\lsdstimax376\lsdl';
    wwv_flow_api.g_varchar2_table(419) := 'ockeddef0\lsdsemihiddendef0\lsdunhideuseddef0\lsdqformatdef0\lsdprioritydef99{\lsdlockedexcept \lsdq';
    wwv_flow_api.g_varchar2_table(420) := 'format1 \lsdpriority0 \lsdlocked0 Normal;\lsdqformat1 \lsdpriority9 \lsdlocked0 heading 1;'||wwv_flow.LF||
'\lsdsemi';
    wwv_flow_api.g_varchar2_table(421) := 'hidden1 \lsdunhideused1 \lsdqformat1 \lsdpriority9 \lsdlocked0 heading 2;\lsdsemihidden1 \lsdunhideu';
    wwv_flow_api.g_varchar2_table(422) := 'sed1 \lsdqformat1 \lsdpriority9 \lsdlocked0 heading 3;\lsdsemihidden1 \lsdunhideused1 \lsdqformat1 \';
    wwv_flow_api.g_varchar2_table(423) := 'lsdpriority9 \lsdlocked0 heading 4;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdqformat1 \lsdpriority9 \lsd';
    wwv_flow_api.g_varchar2_table(424) := 'locked0 heading 5;\lsdsemihidden1 \lsdunhideused1 \lsdqformat1 \lsdpriority9 \lsdlocked0 heading 6;\';
    wwv_flow_api.g_varchar2_table(425) := 'lsdsemihidden1 \lsdunhideused1 \lsdqformat1 \lsdpriority9 \lsdlocked0 heading 7;'||wwv_flow.LF||
'\lsdsemihidden1 \l';
    wwv_flow_api.g_varchar2_table(426) := 'sdunhideused1 \lsdqformat1 \lsdpriority9 \lsdlocked0 heading 8;\lsdsemihidden1 \lsdunhideused1 \lsdq';
    wwv_flow_api.g_varchar2_table(427) := 'format1 \lsdpriority9 \lsdlocked0 heading 9;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 index 1;'||wwv_flow.LF||
'\l';
    wwv_flow_api.g_varchar2_table(428) := 'sdsemihidden1 \lsdunhideused1 \lsdlocked0 index 2;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 index ';
    wwv_flow_api.g_varchar2_table(429) := '3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 index 4;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 in';
    wwv_flow_api.g_varchar2_table(430) := 'dex 5;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 index 6;\lsdsemihidden1 \lsdunhideused1 \lsdlock';
    wwv_flow_api.g_varchar2_table(431) := 'ed0 index 7;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 index 8;\lsdsemihidden1 \lsdunhideused1 \lsd';
    wwv_flow_api.g_varchar2_table(432) := 'locked0 index 9;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdpriority39 \lsdlocked0 toc 1;\lsdsemihidden1 \';
    wwv_flow_api.g_varchar2_table(433) := 'lsdunhideused1 \lsdpriority39 \lsdlocked0 toc 2;\lsdsemihidden1 \lsdunhideused1 \lsdpriority39 \lsdl';
    wwv_flow_api.g_varchar2_table(434) := 'ocked0 toc 3;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdpriority39 \lsdlocked0 toc 4;\lsdsemihidden1 \lsd';
    wwv_flow_api.g_varchar2_table(435) := 'unhideused1 \lsdpriority39 \lsdlocked0 toc 5;\lsdsemihidden1 \lsdunhideused1 \lsdpriority39 \lsdlock';
    wwv_flow_api.g_varchar2_table(436) := 'ed0 toc 6;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdpriority39 \lsdlocked0 toc 7;\lsdsemihidden1 \lsdunh';
    wwv_flow_api.g_varchar2_table(437) := 'ideused1 \lsdpriority39 \lsdlocked0 toc 8;\lsdsemihidden1 \lsdunhideused1 \lsdpriority39 \lsdlocked0';
    wwv_flow_api.g_varchar2_table(438) := ' toc 9;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Normal Indent;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \';
    wwv_flow_api.g_varchar2_table(439) := 'lsdlocked0 footnote text;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 annotation text;\lsdsemihidden1';
    wwv_flow_api.g_varchar2_table(440) := ' \lsdunhideused1 \lsdlocked0 header;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 footer;'||wwv_flow.LF||
'\lsdsemihid';
    wwv_flow_api.g_varchar2_table(441) := 'den1 \lsdunhideused1 \lsdlocked0 index heading;\lsdsemihidden1 \lsdunhideused1 \lsdqformat1 \lsdprio';
    wwv_flow_api.g_varchar2_table(442) := 'rity35 \lsdlocked0 caption;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 table of figures;'||wwv_flow.LF||
'\lsdsemihi';
    wwv_flow_api.g_varchar2_table(443) := 'dden1 \lsdunhideused1 \lsdlocked0 envelope address;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 envel';
    wwv_flow_api.g_varchar2_table(444) := 'ope return;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 footnote reference;\lsdsemihidden1 \lsdunhide';
    wwv_flow_api.g_varchar2_table(445) := 'used1 \lsdlocked0 annotation reference;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 line number;\ls';
    wwv_flow_api.g_varchar2_table(446) := 'dsemihidden1 \lsdunhideused1 \lsdlocked0 page number;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 end';
    wwv_flow_api.g_varchar2_table(447) := 'note reference;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 endnote text;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhide';
    wwv_flow_api.g_varchar2_table(448) := 'used1 \lsdlocked0 table of authorities;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 macro;\lsdsemihid';
    wwv_flow_api.g_varchar2_table(449) := 'den1 \lsdunhideused1 \lsdlocked0 toa heading;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List;'||wwv_flow.LF||
'\lsd';
    wwv_flow_api.g_varchar2_table(450) := 'semihidden1 \lsdunhideused1 \lsdlocked0 List Bullet;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List';
    wwv_flow_api.g_varchar2_table(451) := ' Number;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List 2;\lsdsemihidden1 \lsdunhideused1 \lsdlocke';
    wwv_flow_api.g_varchar2_table(452) := 'd0 List 3;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List 4;\lsdsemihidden1 \lsdunhideused1 \lsdl';
    wwv_flow_api.g_varchar2_table(453) := 'ocked0 List 5;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Bullet 2;\lsdsemihidden1 \lsdunhideus';
    wwv_flow_api.g_varchar2_table(454) := 'ed1 \lsdlocked0 List Bullet 3;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Bullet 4;\lsdsemihi';
    wwv_flow_api.g_varchar2_table(455) := 'dden1 \lsdunhideused1 \lsdlocked0 List Bullet 5;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Num';
    wwv_flow_api.g_varchar2_table(456) := 'ber 2;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Number 3;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \l';
    wwv_flow_api.g_varchar2_table(457) := 'sdlocked0 List Number 4;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Number 5;\lsdqformat1 \lsdp';
    wwv_flow_api.g_varchar2_table(458) := 'riority10 \lsdlocked0 Title;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Closing;'||wwv_flow.LF||
'\lsdsemihidden1 \l';
    wwv_flow_api.g_varchar2_table(459) := 'sdunhideused1 \lsdlocked0 Signature;\lsdsemihidden1 \lsdunhideused1 \lsdpriority1 \lsdlocked0 Defaul';
    wwv_flow_api.g_varchar2_table(460) := 't Paragraph Font;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Body Text;\lsdsemihidden1 \lsdunhideuse';
    wwv_flow_api.g_varchar2_table(461) := 'd1 \lsdlocked0 Body Text Indent;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Continue;\lsdsemi';
    wwv_flow_api.g_varchar2_table(462) := 'hidden1 \lsdunhideused1 \lsdlocked0 List Continue 2;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List';
    wwv_flow_api.g_varchar2_table(463) := ' Continue 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 List Continue 4;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhide';
    wwv_flow_api.g_varchar2_table(464) := 'used1 \lsdlocked0 List Continue 5;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Message Header;\lsdqfo';
    wwv_flow_api.g_varchar2_table(465) := 'rmat1 \lsdpriority11 \lsdlocked0 Subtitle;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Salutation;'||wwv_flow.LF||
'\';
    wwv_flow_api.g_varchar2_table(466) := 'lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Date;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Body Tex';
    wwv_flow_api.g_varchar2_table(467) := 't First Indent;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Body Text First Indent 2;\lsdsemihidden1 ';
    wwv_flow_api.g_varchar2_table(468) := '\lsdunhideused1 \lsdlocked0 Note Heading;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Body Text 2;\';
    wwv_flow_api.g_varchar2_table(469) := 'lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Body Text 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 B';
    wwv_flow_api.g_varchar2_table(470) := 'ody Text Indent 2;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Body Text Indent 3;'||wwv_flow.LF||
'\lsdsemihidden1 \';
    wwv_flow_api.g_varchar2_table(471) := 'lsdunhideused1 \lsdlocked0 Block Text;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Hyperlink;\lsdsemi';
    wwv_flow_api.g_varchar2_table(472) := 'hidden1 \lsdunhideused1 \lsdlocked0 FollowedHyperlink;\lsdqformat1 \lsdpriority22 \lsdlocked0 Strong';
    wwv_flow_api.g_varchar2_table(473) := ';'||wwv_flow.LF||
'\lsdqformat1 \lsdpriority20 \lsdlocked0 Emphasis;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Docu';
    wwv_flow_api.g_varchar2_table(474) := 'ment Map;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Plain Text;\lsdsemihidden1 \lsdunhideused1 \lsd';
    wwv_flow_api.g_varchar2_table(475) := 'locked0 E-mail Signature;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTML Top of Form;\lsdsemihidd';
    wwv_flow_api.g_varchar2_table(476) := 'en1 \lsdunhideused1 \lsdlocked0 HTML Bottom of Form;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Norm';
    wwv_flow_api.g_varchar2_table(477) := 'al (Web);\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTML Acronym;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 ';
    wwv_flow_api.g_varchar2_table(478) := '\lsdlocked0 HTML Address;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTML Cite;\lsdsemihidden1 \lsdu';
    wwv_flow_api.g_varchar2_table(479) := 'nhideused1 \lsdlocked0 HTML Code;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTML Definition;'||wwv_flow.LF||
'\lsds';
    wwv_flow_api.g_varchar2_table(480) := 'emihidden1 \lsdunhideused1 \lsdlocked0 HTML Keyboard;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTM';
    wwv_flow_api.g_varchar2_table(481) := 'L Preformatted;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTML Sample;\lsdsemihidden1 \lsdunhideuse';
    wwv_flow_api.g_varchar2_table(482) := 'd1 \lsdlocked0 HTML Typewriter;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 HTML Variable;\lsdsemih';
    wwv_flow_api.g_varchar2_table(483) := 'idden1 \lsdunhideused1 \lsdlocked0 Normal Table;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 annotati';
    wwv_flow_api.g_varchar2_table(484) := 'on subject;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 No List;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \ls';
    wwv_flow_api.g_varchar2_table(485) := 'dlocked0 Outline List 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Outline List 2;\lsdsemihidden1 \';
    wwv_flow_api.g_varchar2_table(486) := 'lsdunhideused1 \lsdlocked0 Outline List 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Simple 1';
    wwv_flow_api.g_varchar2_table(487) := ';'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Simple 2;\lsdsemihidden1 \lsdunhideused1 \lsdlo';
    wwv_flow_api.g_varchar2_table(488) := 'cked0 Table Simple 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Classic 1;\lsdsemihidden1 \ls';
    wwv_flow_api.g_varchar2_table(489) := 'dunhideused1 \lsdlocked0 Table Classic 2;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Classic';
    wwv_flow_api.g_varchar2_table(490) := ' 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Classic 4;\lsdsemihidden1 \lsdunhideused1 \lsdl';
    wwv_flow_api.g_varchar2_table(491) := 'ocked0 Table Colorful 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Colorful 2;'||wwv_flow.LF||
'\lsdsemihidde';
    wwv_flow_api.g_varchar2_table(492) := 'n1 \lsdunhideused1 \lsdlocked0 Table Colorful 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Co';
    wwv_flow_api.g_varchar2_table(493) := 'lumns 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Columns 2;\lsdsemihidden1 \lsdunhideused1 ';
    wwv_flow_api.g_varchar2_table(494) := '\lsdlocked0 Table Columns 3;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Columns 4;\lsdsemihi';
    wwv_flow_api.g_varchar2_table(495) := 'dden1 \lsdunhideused1 \lsdlocked0 Table Columns 5;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table ';
    wwv_flow_api.g_varchar2_table(496) := 'Grid 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Grid 2;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \l';
    wwv_flow_api.g_varchar2_table(497) := 'sdlocked0 Table Grid 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Grid 4;\lsdsemihidden1 \lsd';
    wwv_flow_api.g_varchar2_table(498) := 'unhideused1 \lsdlocked0 Table Grid 5;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Grid 6;'||wwv_flow.LF||
'\lsd';
    wwv_flow_api.g_varchar2_table(499) := 'semihidden1 \lsdunhideused1 \lsdlocked0 Table Grid 7;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Tab';
    wwv_flow_api.g_varchar2_table(500) := 'le Grid 8;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table List 1;\lsdsemihidden1 \lsdunhideused1 \';
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
    wwv_flow_api.g_varchar2_table(501) := 'lsdlocked0 Table List 2;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table List 3;\lsdsemihidden1 \';
    wwv_flow_api.g_varchar2_table(502) := 'lsdunhideused1 \lsdlocked0 Table List 4;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table List 5;\ls';
    wwv_flow_api.g_varchar2_table(503) := 'dsemihidden1 \lsdunhideused1 \lsdlocked0 Table List 6;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 ';
    wwv_flow_api.g_varchar2_table(504) := 'Table List 7;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table List 8;\lsdsemihidden1 \lsdunhideused';
    wwv_flow_api.g_varchar2_table(505) := '1 \lsdlocked0 Table 3D effects 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table 3D effects 2;'||wwv_flow.LF||
'\l';
    wwv_flow_api.g_varchar2_table(506) := 'sdsemihidden1 \lsdunhideused1 \lsdlocked0 Table 3D effects 3;\lsdsemihidden1 \lsdunhideused1 \lsdloc';
    wwv_flow_api.g_varchar2_table(507) := 'ked0 Table Contemporary;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Elegant;\lsdsemihidden1 \l';
    wwv_flow_api.g_varchar2_table(508) := 'sdunhideused1 \lsdlocked0 Table Professional;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Sub';
    wwv_flow_api.g_varchar2_table(509) := 'tle 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Subtle 2;\lsdsemihidden1 \lsdunhideused1 \ls';
    wwv_flow_api.g_varchar2_table(510) := 'dlocked0 Table Web 1;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Web 2;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdu';
    wwv_flow_api.g_varchar2_table(511) := 'nhideused1 \lsdlocked0 Table Web 3;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Balloon Text;\lsdprio';
    wwv_flow_api.g_varchar2_table(512) := 'rity39 \lsdlocked0 Table Grid;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Table Theme;\lsdsemihidden';
    wwv_flow_api.g_varchar2_table(513) := '1 \lsdlocked0 Placeholder Text;'||wwv_flow.LF||
'\lsdqformat1 \lsdpriority1 \lsdlocked0 No Spacing;\lsdpriority60 \l';
    wwv_flow_api.g_varchar2_table(514) := 'sdlocked0 Light Shading;\lsdpriority61 \lsdlocked0 Light List;\lsdpriority62 \lsdlocked0 Light Grid;';
    wwv_flow_api.g_varchar2_table(515) := '\lsdpriority63 \lsdlocked0 Medium Shading 1;\lsdpriority64 \lsdlocked0 Medium Shading 2;'||wwv_flow.LF||
'\lsdpriori';
    wwv_flow_api.g_varchar2_table(516) := 'ty65 \lsdlocked0 Medium List 1;\lsdpriority66 \lsdlocked0 Medium List 2;\lsdpriority67 \lsdlocked0 M';
    wwv_flow_api.g_varchar2_table(517) := 'edium Grid 1;\lsdpriority68 \lsdlocked0 Medium Grid 2;\lsdpriority69 \lsdlocked0 Medium Grid 3;\lsdp';
    wwv_flow_api.g_varchar2_table(518) := 'riority70 \lsdlocked0 Dark List;'||wwv_flow.LF||
'\lsdpriority71 \lsdlocked0 Colorful Shading;\lsdpriority72 \lsdloc';
    wwv_flow_api.g_varchar2_table(519) := 'ked0 Colorful List;\lsdpriority73 \lsdlocked0 Colorful Grid;\lsdpriority60 \lsdlocked0 Light Shading';
    wwv_flow_api.g_varchar2_table(520) := ' Accent 1;\lsdpriority61 \lsdlocked0 Light List Accent 1;'||wwv_flow.LF||
'\lsdpriority62 \lsdlocked0 Light Grid Acc';
    wwv_flow_api.g_varchar2_table(521) := 'ent 1;\lsdpriority63 \lsdlocked0 Medium Shading 1 Accent 1;\lsdpriority64 \lsdlocked0 Medium Shading';
    wwv_flow_api.g_varchar2_table(522) := ' 2 Accent 1;\lsdpriority65 \lsdlocked0 Medium List 1 Accent 1;\lsdsemihidden1 \lsdlocked0 Revision;';
    wwv_flow_api.g_varchar2_table(523) := ''||wwv_flow.LF||
'\lsdqformat1 \lsdpriority34 \lsdlocked0 List Paragraph;\lsdqformat1 \lsdpriority29 \lsdlocked0 Quot';
    wwv_flow_api.g_varchar2_table(524) := 'e;\lsdqformat1 \lsdpriority30 \lsdlocked0 Intense Quote;\lsdpriority66 \lsdlocked0 Medium List 2 Acc';
    wwv_flow_api.g_varchar2_table(525) := 'ent 1;\lsdpriority67 \lsdlocked0 Medium Grid 1 Accent 1;'||wwv_flow.LF||
'\lsdpriority68 \lsdlocked0 Medium Grid 2 A';
    wwv_flow_api.g_varchar2_table(526) := 'ccent 1;\lsdpriority69 \lsdlocked0 Medium Grid 3 Accent 1;\lsdpriority70 \lsdlocked0 Dark List Accen';
    wwv_flow_api.g_varchar2_table(527) := 't 1;\lsdpriority71 \lsdlocked0 Colorful Shading Accent 1;\lsdpriority72 \lsdlocked0 Colorful List Ac';
    wwv_flow_api.g_varchar2_table(528) := 'cent 1;'||wwv_flow.LF||
'\lsdpriority73 \lsdlocked0 Colorful Grid Accent 1;\lsdpriority60 \lsdlocked0 Light Shading ';
    wwv_flow_api.g_varchar2_table(529) := 'Accent 2;\lsdpriority61 \lsdlocked0 Light List Accent 2;\lsdpriority62 \lsdlocked0 Light Grid Accent';
    wwv_flow_api.g_varchar2_table(530) := ' 2;\lsdpriority63 \lsdlocked0 Medium Shading 1 Accent 2;'||wwv_flow.LF||
'\lsdpriority64 \lsdlocked0 Medium Shading ';
    wwv_flow_api.g_varchar2_table(531) := '2 Accent 2;\lsdpriority65 \lsdlocked0 Medium List 1 Accent 2;\lsdpriority66 \lsdlocked0 Medium List ';
    wwv_flow_api.g_varchar2_table(532) := '2 Accent 2;\lsdpriority67 \lsdlocked0 Medium Grid 1 Accent 2;\lsdpriority68 \lsdlocked0 Medium Grid ';
    wwv_flow_api.g_varchar2_table(533) := '2 Accent 2;'||wwv_flow.LF||
'\lsdpriority69 \lsdlocked0 Medium Grid 3 Accent 2;\lsdpriority70 \lsdlocked0 Dark List ';
    wwv_flow_api.g_varchar2_table(534) := 'Accent 2;\lsdpriority71 \lsdlocked0 Colorful Shading Accent 2;\lsdpriority72 \lsdlocked0 Colorful Li';
    wwv_flow_api.g_varchar2_table(535) := 'st Accent 2;\lsdpriority73 \lsdlocked0 Colorful Grid Accent 2;'||wwv_flow.LF||
'\lsdpriority60 \lsdlocked0 Light Sha';
    wwv_flow_api.g_varchar2_table(536) := 'ding Accent 3;\lsdpriority61 \lsdlocked0 Light List Accent 3;\lsdpriority62 \lsdlocked0 Light Grid A';
    wwv_flow_api.g_varchar2_table(537) := 'ccent 3;\lsdpriority63 \lsdlocked0 Medium Shading 1 Accent 3;\lsdpriority64 \lsdlocked0 Medium Shadi';
    wwv_flow_api.g_varchar2_table(538) := 'ng 2 Accent 3;'||wwv_flow.LF||
'\lsdpriority65 \lsdlocked0 Medium List 1 Accent 3;\lsdpriority66 \lsdlocked0 Medium ';
    wwv_flow_api.g_varchar2_table(539) := 'List 2 Accent 3;\lsdpriority67 \lsdlocked0 Medium Grid 1 Accent 3;\lsdpriority68 \lsdlocked0 Medium ';
    wwv_flow_api.g_varchar2_table(540) := 'Grid 2 Accent 3;\lsdpriority69 \lsdlocked0 Medium Grid 3 Accent 3;'||wwv_flow.LF||
'\lsdpriority70 \lsdlocked0 Dark ';
    wwv_flow_api.g_varchar2_table(541) := 'List Accent 3;\lsdpriority71 \lsdlocked0 Colorful Shading Accent 3;\lsdpriority72 \lsdlocked0 Colorf';
    wwv_flow_api.g_varchar2_table(542) := 'ul List Accent 3;\lsdpriority73 \lsdlocked0 Colorful Grid Accent 3;\lsdpriority60 \lsdlocked0 Light ';
    wwv_flow_api.g_varchar2_table(543) := 'Shading Accent 4;'||wwv_flow.LF||
'\lsdpriority61 \lsdlocked0 Light List Accent 4;\lsdpriority62 \lsdlocked0 Light G';
    wwv_flow_api.g_varchar2_table(544) := 'rid Accent 4;\lsdpriority63 \lsdlocked0 Medium Shading 1 Accent 4;\lsdpriority64 \lsdlocked0 Medium ';
    wwv_flow_api.g_varchar2_table(545) := 'Shading 2 Accent 4;\lsdpriority65 \lsdlocked0 Medium List 1 Accent 4;'||wwv_flow.LF||
'\lsdpriority66 \lsdlocked0 Me';
    wwv_flow_api.g_varchar2_table(546) := 'dium List 2 Accent 4;\lsdpriority67 \lsdlocked0 Medium Grid 1 Accent 4;\lsdpriority68 \lsdlocked0 Me';
    wwv_flow_api.g_varchar2_table(547) := 'dium Grid 2 Accent 4;\lsdpriority69 \lsdlocked0 Medium Grid 3 Accent 4;\lsdpriority70 \lsdlocked0 Da';
    wwv_flow_api.g_varchar2_table(548) := 'rk List Accent 4;'||wwv_flow.LF||
'\lsdpriority71 \lsdlocked0 Colorful Shading Accent 4;\lsdpriority72 \lsdlocked0 C';
    wwv_flow_api.g_varchar2_table(549) := 'olorful List Accent 4;\lsdpriority73 \lsdlocked0 Colorful Grid Accent 4;\lsdpriority60 \lsdlocked0 L';
    wwv_flow_api.g_varchar2_table(550) := 'ight Shading Accent 5;\lsdpriority61 \lsdlocked0 Light List Accent 5;'||wwv_flow.LF||
'\lsdpriority62 \lsdlocked0 Li';
    wwv_flow_api.g_varchar2_table(551) := 'ght Grid Accent 5;\lsdpriority63 \lsdlocked0 Medium Shading 1 Accent 5;\lsdpriority64 \lsdlocked0 Me';
    wwv_flow_api.g_varchar2_table(552) := 'dium Shading 2 Accent 5;\lsdpriority65 \lsdlocked0 Medium List 1 Accent 5;\lsdpriority66 \lsdlocked0';
    wwv_flow_api.g_varchar2_table(553) := ' Medium List 2 Accent 5;'||wwv_flow.LF||
'\lsdpriority67 \lsdlocked0 Medium Grid 1 Accent 5;\lsdpriority68 \lsdlocke';
    wwv_flow_api.g_varchar2_table(554) := 'd0 Medium Grid 2 Accent 5;\lsdpriority69 \lsdlocked0 Medium Grid 3 Accent 5;\lsdpriority70 \lsdlocke';
    wwv_flow_api.g_varchar2_table(555) := 'd0 Dark List Accent 5;\lsdpriority71 \lsdlocked0 Colorful Shading Accent 5;'||wwv_flow.LF||
'\lsdpriority72 \lsdlock';
    wwv_flow_api.g_varchar2_table(556) := 'ed0 Colorful List Accent 5;\lsdpriority73 \lsdlocked0 Colorful Grid Accent 5;\lsdpriority60 \lsdlock';
    wwv_flow_api.g_varchar2_table(557) := 'ed0 Light Shading Accent 6;\lsdpriority61 \lsdlocked0 Light List Accent 6;\lsdpriority62 \lsdlocked0';
    wwv_flow_api.g_varchar2_table(558) := ' Light Grid Accent 6;'||wwv_flow.LF||
'\lsdpriority63 \lsdlocked0 Medium Shading 1 Accent 6;\lsdpriority64 \lsdlocke';
    wwv_flow_api.g_varchar2_table(559) := 'd0 Medium Shading 2 Accent 6;\lsdpriority65 \lsdlocked0 Medium List 1 Accent 6;\lsdpriority66 \lsdlo';
    wwv_flow_api.g_varchar2_table(560) := 'cked0 Medium List 2 Accent 6;'||wwv_flow.LF||
'\lsdpriority67 \lsdlocked0 Medium Grid 1 Accent 6;\lsdpriority68 \lsd';
    wwv_flow_api.g_varchar2_table(561) := 'locked0 Medium Grid 2 Accent 6;\lsdpriority69 \lsdlocked0 Medium Grid 3 Accent 6;\lsdpriority70 \lsd';
    wwv_flow_api.g_varchar2_table(562) := 'locked0 Dark List Accent 6;\lsdpriority71 \lsdlocked0 Colorful Shading Accent 6;'||wwv_flow.LF||
'\lsdpriority72 \ls';
    wwv_flow_api.g_varchar2_table(563) := 'dlocked0 Colorful List Accent 6;\lsdpriority73 \lsdlocked0 Colorful Grid Accent 6;\lsdqformat1 \lsdp';
    wwv_flow_api.g_varchar2_table(564) := 'riority19 \lsdlocked0 Subtle Emphasis;\lsdqformat1 \lsdpriority21 \lsdlocked0 Intense Emphasis;'||wwv_flow.LF||
'\ls';
    wwv_flow_api.g_varchar2_table(565) := 'dqformat1 \lsdpriority31 \lsdlocked0 Subtle Reference;\lsdqformat1 \lsdpriority32 \lsdlocked0 Intens';
    wwv_flow_api.g_varchar2_table(566) := 'e Reference;\lsdqformat1 \lsdpriority33 \lsdlocked0 Book Title;\lsdsemihidden1 \lsdunhideused1 \lsdp';
    wwv_flow_api.g_varchar2_table(567) := 'riority37 \lsdlocked0 Bibliography;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdqformat1 \lsdpriority39 \ls';
    wwv_flow_api.g_varchar2_table(568) := 'dlocked0 TOC Heading;\lsdpriority41 \lsdlocked0 Plain Table 1;\lsdpriority42 \lsdlocked0 Plain Table';
    wwv_flow_api.g_varchar2_table(569) := ' 2;\lsdpriority43 \lsdlocked0 Plain Table 3;\lsdpriority44 \lsdlocked0 Plain Table 4;'||wwv_flow.LF||
'\lsdpriority4';
    wwv_flow_api.g_varchar2_table(570) := '5 \lsdlocked0 Plain Table 5;\lsdpriority40 \lsdlocked0 Grid Table Light;\lsdpriority46 \lsdlocked0 G';
    wwv_flow_api.g_varchar2_table(571) := 'rid Table 1 Light;\lsdpriority47 \lsdlocked0 Grid Table 2;\lsdpriority48 \lsdlocked0 Grid Table 3;\l';
    wwv_flow_api.g_varchar2_table(572) := 'sdpriority49 \lsdlocked0 Grid Table 4;'||wwv_flow.LF||
'\lsdpriority50 \lsdlocked0 Grid Table 5 Dark;\lsdpriority51 ';
    wwv_flow_api.g_varchar2_table(573) := '\lsdlocked0 Grid Table 6 Colorful;\lsdpriority52 \lsdlocked0 Grid Table 7 Colorful;\lsdpriority46 \l';
    wwv_flow_api.g_varchar2_table(574) := 'sdlocked0 Grid Table 1 Light Accent 1;\lsdpriority47 \lsdlocked0 Grid Table 2 Accent 1;'||wwv_flow.LF||
'\lsdpriorit';
    wwv_flow_api.g_varchar2_table(575) := 'y48 \lsdlocked0 Grid Table 3 Accent 1;\lsdpriority49 \lsdlocked0 Grid Table 4 Accent 1;\lsdpriority5';
    wwv_flow_api.g_varchar2_table(576) := '0 \lsdlocked0 Grid Table 5 Dark Accent 1;\lsdpriority51 \lsdlocked0 Grid Table 6 Colorful Accent 1;';
    wwv_flow_api.g_varchar2_table(577) := ''||wwv_flow.LF||
'\lsdpriority52 \lsdlocked0 Grid Table 7 Colorful Accent 1;\lsdpriority46 \lsdlocked0 Grid Table 1 L';
    wwv_flow_api.g_varchar2_table(578) := 'ight Accent 2;\lsdpriority47 \lsdlocked0 Grid Table 2 Accent 2;\lsdpriority48 \lsdlocked0 Grid Table';
    wwv_flow_api.g_varchar2_table(579) := ' 3 Accent 2;'||wwv_flow.LF||
'\lsdpriority49 \lsdlocked0 Grid Table 4 Accent 2;\lsdpriority50 \lsdlocked0 Grid Table';
    wwv_flow_api.g_varchar2_table(580) := ' 5 Dark Accent 2;\lsdpriority51 \lsdlocked0 Grid Table 6 Colorful Accent 2;\lsdpriority52 \lsdlocked';
    wwv_flow_api.g_varchar2_table(581) := '0 Grid Table 7 Colorful Accent 2;'||wwv_flow.LF||
'\lsdpriority46 \lsdlocked0 Grid Table 1 Light Accent 3;\lsdpriori';
    wwv_flow_api.g_varchar2_table(582) := 'ty47 \lsdlocked0 Grid Table 2 Accent 3;\lsdpriority48 \lsdlocked0 Grid Table 3 Accent 3;\lsdpriority';
    wwv_flow_api.g_varchar2_table(583) := '49 \lsdlocked0 Grid Table 4 Accent 3;'||wwv_flow.LF||
'\lsdpriority50 \lsdlocked0 Grid Table 5 Dark Accent 3;\lsdpri';
    wwv_flow_api.g_varchar2_table(584) := 'ority51 \lsdlocked0 Grid Table 6 Colorful Accent 3;\lsdpriority52 \lsdlocked0 Grid Table 7 Colorful ';
    wwv_flow_api.g_varchar2_table(585) := 'Accent 3;\lsdpriority46 \lsdlocked0 Grid Table 1 Light Accent 4;'||wwv_flow.LF||
'\lsdpriority47 \lsdlocked0 Grid Ta';
    wwv_flow_api.g_varchar2_table(586) := 'ble 2 Accent 4;\lsdpriority48 \lsdlocked0 Grid Table 3 Accent 4;\lsdpriority49 \lsdlocked0 Grid Tabl';
    wwv_flow_api.g_varchar2_table(587) := 'e 4 Accent 4;\lsdpriority50 \lsdlocked0 Grid Table 5 Dark Accent 4;'||wwv_flow.LF||
'\lsdpriority51 \lsdlocked0 Grid';
    wwv_flow_api.g_varchar2_table(588) := ' Table 6 Colorful Accent 4;\lsdpriority52 \lsdlocked0 Grid Table 7 Colorful Accent 4;\lsdpriority46 ';
    wwv_flow_api.g_varchar2_table(589) := '\lsdlocked0 Grid Table 1 Light Accent 5;\lsdpriority47 \lsdlocked0 Grid Table 2 Accent 5;'||wwv_flow.LF||
'\lsdprior';
    wwv_flow_api.g_varchar2_table(590) := 'ity48 \lsdlocked0 Grid Table 3 Accent 5;\lsdpriority49 \lsdlocked0 Grid Table 4 Accent 5;\lsdpriorit';
    wwv_flow_api.g_varchar2_table(591) := 'y50 \lsdlocked0 Grid Table 5 Dark Accent 5;\lsdpriority51 \lsdlocked0 Grid Table 6 Colorful Accent 5';
    wwv_flow_api.g_varchar2_table(592) := ';'||wwv_flow.LF||
'\lsdpriority52 \lsdlocked0 Grid Table 7 Colorful Accent 5;\lsdpriority46 \lsdlocked0 Grid Table 1';
    wwv_flow_api.g_varchar2_table(593) := ' Light Accent 6;\lsdpriority47 \lsdlocked0 Grid Table 2 Accent 6;\lsdpriority48 \lsdlocked0 Grid Tab';
    wwv_flow_api.g_varchar2_table(594) := 'le 3 Accent 6;'||wwv_flow.LF||
'\lsdpriority49 \lsdlocked0 Grid Table 4 Accent 6;\lsdpriority50 \lsdlocked0 Grid Tab';
    wwv_flow_api.g_varchar2_table(595) := 'le 5 Dark Accent 6;\lsdpriority51 \lsdlocked0 Grid Table 6 Colorful Accent 6;\lsdpriority52 \lsdlock';
    wwv_flow_api.g_varchar2_table(596) := 'ed0 Grid Table 7 Colorful Accent 6;'||wwv_flow.LF||
'\lsdpriority46 \lsdlocked0 List Table 1 Light;\lsdpriority47 \l';
    wwv_flow_api.g_varchar2_table(597) := 'sdlocked0 List Table 2;\lsdpriority48 \lsdlocked0 List Table 3;\lsdpriority49 \lsdlocked0 List Table';
    wwv_flow_api.g_varchar2_table(598) := ' 4;\lsdpriority50 \lsdlocked0 List Table 5 Dark;'||wwv_flow.LF||
'\lsdpriority51 \lsdlocked0 List Table 6 Colorful;\';
    wwv_flow_api.g_varchar2_table(599) := 'lsdpriority52 \lsdlocked0 List Table 7 Colorful;\lsdpriority46 \lsdlocked0 List Table 1 Light Accent';
    wwv_flow_api.g_varchar2_table(600) := ' 1;\lsdpriority47 \lsdlocked0 List Table 2 Accent 1;\lsdpriority48 \lsdlocked0 List Table 3 Accent 1';
    wwv_flow_api.g_varchar2_table(601) := ';'||wwv_flow.LF||
'\lsdpriority49 \lsdlocked0 List Table 4 Accent 1;\lsdpriority50 \lsdlocked0 List Table 5 Dark Acc';
    wwv_flow_api.g_varchar2_table(602) := 'ent 1;\lsdpriority51 \lsdlocked0 List Table 6 Colorful Accent 1;\lsdpriority52 \lsdlocked0 List Tabl';
    wwv_flow_api.g_varchar2_table(603) := 'e 7 Colorful Accent 1;'||wwv_flow.LF||
'\lsdpriority46 \lsdlocked0 List Table 1 Light Accent 2;\lsdpriority47 \lsdlo';
    wwv_flow_api.g_varchar2_table(604) := 'cked0 List Table 2 Accent 2;\lsdpriority48 \lsdlocked0 List Table 3 Accent 2;\lsdpriority49 \lsdlock';
    wwv_flow_api.g_varchar2_table(605) := 'ed0 List Table 4 Accent 2;'||wwv_flow.LF||
'\lsdpriority50 \lsdlocked0 List Table 5 Dark Accent 2;\lsdpriority51 \ls';
    wwv_flow_api.g_varchar2_table(606) := 'dlocked0 List Table 6 Colorful Accent 2;\lsdpriority52 \lsdlocked0 List Table 7 Colorful Accent 2;\l';
    wwv_flow_api.g_varchar2_table(607) := 'sdpriority46 \lsdlocked0 List Table 1 Light Accent 3;'||wwv_flow.LF||
'\lsdpriority47 \lsdlocked0 List Table 2 Accen';
    wwv_flow_api.g_varchar2_table(608) := 't 3;\lsdpriority48 \lsdlocked0 List Table 3 Accent 3;\lsdpriority49 \lsdlocked0 List Table 4 Accent ';
    wwv_flow_api.g_varchar2_table(609) := '3;\lsdpriority50 \lsdlocked0 List Table 5 Dark Accent 3;'||wwv_flow.LF||
'\lsdpriority51 \lsdlocked0 List Table 6 Co';
    wwv_flow_api.g_varchar2_table(610) := 'lorful Accent 3;\lsdpriority52 \lsdlocked0 List Table 7 Colorful Accent 3;\lsdpriority46 \lsdlocked0';
    wwv_flow_api.g_varchar2_table(611) := ' List Table 1 Light Accent 4;\lsdpriority47 \lsdlocked0 List Table 2 Accent 4;'||wwv_flow.LF||
'\lsdpriority48 \lsdl';
    wwv_flow_api.g_varchar2_table(612) := 'ocked0 List Table 3 Accent 4;\lsdpriority49 \lsdlocked0 List Table 4 Accent 4;\lsdpriority50 \lsdloc';
    wwv_flow_api.g_varchar2_table(613) := 'ked0 List Table 5 Dark Accent 4;\lsdpriority51 \lsdlocked0 List Table 6 Colorful Accent 4;'||wwv_flow.LF||
'\lsdprio';
    wwv_flow_api.g_varchar2_table(614) := 'rity52 \lsdlocked0 List Table 7 Colorful Accent 4;\lsdpriority46 \lsdlocked0 List Table 1 Light Acce';
    wwv_flow_api.g_varchar2_table(615) := 'nt 5;\lsdpriority47 \lsdlocked0 List Table 2 Accent 5;\lsdpriority48 \lsdlocked0 List Table 3 Accent';
    wwv_flow_api.g_varchar2_table(616) := ' 5;'||wwv_flow.LF||
'\lsdpriority49 \lsdlocked0 List Table 4 Accent 5;\lsdpriority50 \lsdlocked0 List Table 5 Dark A';
    wwv_flow_api.g_varchar2_table(617) := 'ccent 5;\lsdpriority51 \lsdlocked0 List Table 6 Colorful Accent 5;\lsdpriority52 \lsdlocked0 List Ta';
    wwv_flow_api.g_varchar2_table(618) := 'ble 7 Colorful Accent 5;'||wwv_flow.LF||
'\lsdpriority46 \lsdlocked0 List Table 1 Light Accent 6;\lsdpriority47 \lsd';
    wwv_flow_api.g_varchar2_table(619) := 'locked0 List Table 2 Accent 6;\lsdpriority48 \lsdlocked0 List Table 3 Accent 6;\lsdpriority49 \lsdlo';
    wwv_flow_api.g_varchar2_table(620) := 'cked0 List Table 4 Accent 6;'||wwv_flow.LF||
'\lsdpriority50 \lsdlocked0 List Table 5 Dark Accent 6;\lsdpriority51 \';
    wwv_flow_api.g_varchar2_table(621) := 'lsdlocked0 List Table 6 Colorful Accent 6;\lsdpriority52 \lsdlocked0 List Table 7 Colorful Accent 6;';
    wwv_flow_api.g_varchar2_table(622) := '\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Mention;'||wwv_flow.LF||
'\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Sm';
    wwv_flow_api.g_varchar2_table(623) := 'art Hyperlink;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Hashtag;\lsdsemihidden1 \lsdunhideused1 \l';
    wwv_flow_api.g_varchar2_table(624) := 'sdlocked0 Unresolved Mention;\lsdsemihidden1 \lsdunhideused1 \lsdlocked0 Smart Link;}}{\*\datastore ';
    wwv_flow_api.g_varchar2_table(625) := '01050000'||wwv_flow.LF||
'02000000180000004d73786d6c322e534158584d4c5265616465722e362e3000000000000000000000060000'||wwv_flow.LF||
'';
    wwv_flow_api.g_varchar2_table(626) := 'd0cf11e0a1b11ae1000000000000000000000000000000003e000300feff0900060000000000000000000000010000000100';
    wwv_flow_api.g_varchar2_table(627) := '00000000000000100000feffffff00000000feffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(628) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffff'||wwv_flow.LF||
'ffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(629) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(630) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(631) := 'ffffff'||wwv_flow.LF||
'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(632) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(633) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'||wwv_flow.LF||
'ffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(634) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(635) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(636) := 'ffffffffffffff'||wwv_flow.LF||
'fffffffffffffffffdfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(637) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(638) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'||wwv_flow.LF||
'ffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(639) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(640) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(641) := 'ffffffffffffffffffffff'||wwv_flow.LF||
'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(642) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(643) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'||wwv_flow.LF||
'ffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(644) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(645) := 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    wwv_flow_api.g_varchar2_table(646) := 'ffffffffffffffffffffffffffffff'||wwv_flow.LF||
'ffffffffffffffffffffffffffffffff52006f006f007400200045006e0074007200';
    wwv_flow_api.g_varchar2_table(647) := '7900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000016000500';
    wwv_flow_api.g_varchar2_table(648) := 'ffffffffffffffffffffffff0c6ad98892f1d411a65f0040963251e5000000000000000000000000f0a3'||wwv_flow.LF||
'41327c9cd801fe';
    wwv_flow_api.g_varchar2_table(649) := 'ffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(650) := '0000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000';
    wwv_flow_api.g_varchar2_table(651) := '00000000000000000000000000000000000000'||wwv_flow.LF||
'000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(652) := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(653) := '0000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000'||wwv_flow.LF||
'000000';
    wwv_flow_api.g_varchar2_table(654) := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(655) := '00000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00';
    wwv_flow_api.g_varchar2_table(656) := '0000000000000000000000000000000000000000000000'||wwv_flow.LF||
'0000000000000000000000000000000000000000000000000105';
    wwv_flow_api.g_varchar2_table(657) := '000000000000}}';
wwv_flow_api.create_report_layout(
 p_id=>wwv_flow_api.id(97238992194114108)
,p_report_layout_name=>'UPLOAD_BTF_LINES_REPORT'
,p_report_layout_type=>'RTF_FILE'
,p_varchar2_table=>wwv_flow_api.g_varchar2_table
);
wwv_flow_api.component_end;
end;
/
