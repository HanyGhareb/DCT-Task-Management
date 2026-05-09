prompt --application/shared_components/email/templates/notify_credit_card_requestor_doa_approved
begin
--   Manifest
--     REPORT LAYOUT: Notify credit card requestor DOA approved
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(38665881335385457)
,p_name=>'Notify credit card requestor DOA approved'
,p_static_id=>'NOTIFY_CREDIT_CARD_REQUESTOR_DOA_APPROVED'
,p_subject=>'FYI - your credit card request for #AMOUNT# AED Finally Approved.'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Hello  <b><span style="color: #0e6654;"><i>#EMP_TITLE# #EMP_NAME#,</i></span></b>',
'<br>',
'<br>',
'Kindly note that your credit card request for for <span><i><b>#AMOUNT#</b></i></span> AED has been <span style="color: green;"><i><b>finally approved.</b></i></span>',
'<br>',
'<br>',
'',
'<span style="color: red; font-size:14px"> Purpose: </span> ',
'<br>',
'<span style="color: #0e6654;"><i> #PURPOSE#</i></span>',
'',
'<br>',
'<br>',
'<table border="0" align="center">                      ',
'	<tbody><tr>',
'				<td style="padding:16px 24px;border-radius:4px;min-width:200px;" bgcolor="#0e6654" align="center">',
'                          <a rel="nofollow" target="_blank" href="#APPLICATION_LINK#" style="font-size:16px;line-height:16px;font-weight:700;color:#FCFBFA;text-decoration:none;display:inline-block;padding:16px 24px;"> Access iFinance </a>            '
||'            ',
'				</td>                      ',
'			</tr>                    ',
'	</tbody>',
'</table>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Credit Card Management </h2>',
'</div>    '))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #F5F5F5; text-align: left; color:black"> ',
'<h4>Best Regards</h4>',
'<h5><i>MIS Team</i>,</h5>',
'</div>'))
);
wwv_flow_api.component_end;
end;
/
