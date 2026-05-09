prompt --application/shared_components/email/templates/comment_on_payment_recommendation
begin
--   Manifest
--     REPORT LAYOUT: Comment ON Payment Recommendation
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(40309446683389713)
,p_name=>'Comment ON Payment Recommendation'
,p_static_id=>'COMMENT_ON_PAYMENT_RECOMMENDATION'
,p_subject=>'Updates on Payment no #PAYMENT_NUMBER#, Contract: #CONTRACT_REFERENCE#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear #APPROVER_TITLE# #APPROVER_NAME#, <br /><br />Collaboration on Recommendation Payment &nbsp;#PAYMENT_NUMBER# for Contract #CONTRACT_REFERENCE# from <span style="color: #529fec;"><em><strong>#EMP_TITLE# #EMP_NAME# </strong></em></span>as below'
||':</p>',
'<p><br /><span style="color: #529fec;"><em><strong> #COMMENT#</strong></em></span> <br /><br /><br /><br /></p>',
'<table border="0" align="center">',
'<tbody>',
'<tr>',
'<td style="padding: 16px 24px; border-radius: 4px; min-width: 200px;" align="center" bgcolor="#120E78"><a style="font-size: 16px; line-height: 16px; font-weight: bold; color: #fcfbfa; text-decoration: none; display: inline-block; padding: 16px 24px;"'
||' href="#APPLICATION_LINK#" target="_blank" rel="nofollow"> Access iFinance </a></td>',
'</tr>',
'</tbody>',
'</table>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #120E78; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>CWIP Payments</h2>',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #F5F5F5; text-align: left; color:black"> ',
'<h4>Best Regards</h4>',
'<h5><i>MIS Team</i>,</h5>',
'</div>'))
);
wwv_flow_api.component_end;
end;
/
