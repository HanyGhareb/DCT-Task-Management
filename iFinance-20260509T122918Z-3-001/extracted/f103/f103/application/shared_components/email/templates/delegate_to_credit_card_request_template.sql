prompt --application/shared_components/email/templates/delegate_to_credit_card_request_template
begin
--   Manifest
--     REPORT LAYOUT: Delegate To Credit Card Request Template
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(38644514865579250)
,p_name=>'Delegate To Credit Card Request Template'
,p_static_id=>'DELEGATE_TO_CREDIT_CARD_REQUEST_TEMPLATE'
,p_subject=>'Delegate - Credit Card Request for #EMP_TITLE# #EMP_NAME#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Hello  <b><span style="color: #0e6654;"><i>#APPROVER_TITL# #APPROVER_EMP_NAME#,</i></span></b>',
'<br>',
'<br>',
'Please note that Credit card Request for employee: <span style="color: #0e6654;"><i><b>#EMP_TITLE# #EMP_NAME#</b></i></span> for <span style="color: #0e6654;"><i><b>#AMOUNT#</b></i></span> AED has been delegated to you by <span style="color: #0e6654;'
||'"><i><b>#DELEGATED_FROM_TITLE# #DELEGATED_FROM_EMP_NAME# </b></i></span>  for your kind action.',
'<br>',
'',
'<br>',
'<table border="0" align="center">                      ',
'	<tbody><tr>',
'				<td style="padding:16px 24px;border-radius:4px;min-width:200px;" bgcolor="#0e6654" align="center">',
'                          <a rel="nofollow" target="_blank" href="#APPLICATION_LINK#" style="font-size:16px;line-height:16px;font-weight:700;color:#FCFBFA;text-decoration:none;display:inline-block;padding:16px 24px;"> Approve / Reject </a>           '
||'             ',
'				</td>                      ',
'			</tr>                    ',
'	</tbody>',
'</table>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Credit Card Management </h2>',
'</div>    '))
);
wwv_flow_api.component_end;
end;
/
