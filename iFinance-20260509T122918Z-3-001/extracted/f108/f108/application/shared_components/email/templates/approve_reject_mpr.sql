prompt --application/shared_components/email/templates/approve_reject_mpr
begin
--   Manifest
--     REPORT LAYOUT: Approve Reject MPR
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(22607945507635518)
,p_name=>'Approve Reject MPR'
,p_static_id=>'APPROVE_REJECT_MPR'
,p_subject=>'Action Required: Manual PR #REQUEST_NUMBER# , Amount #REQUESTED_AMOUNT# #CURRENCY#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Hello <b><span style="color: #0e6654;"><i>#APPROVER_EMP_NAME#,</i></span></b>',
'<br>',
'<br>',
'your kind attention is required to process Manual PR# <span style="color: #0e6654;"><i><b>#REQUEST_NUMBER#</b></i></span>.',
'',
'<p>Here is the request Details:</p>',
'',
'<table style="font-family: arial, sans-serif; border-collapse: collapse; width: 100%;">',
'  <tr>    ',
'  <td style="text-align: left;padding: 4px; background-color: #81d0b5; width: 30%;">Requestor Name </td>',
'  <td style="text-align: left;background-color: #81d0b5;padding: 8px;"> <span style="color: #0e6654;"><i>#REQUESTED_PERSON_NAME#</i></span> </td>',
'  </tr>',
'    ',
'  <tr>',
'    <td style="text-align:left; padding: 4px;width:20%;">Requested Amount </td>',
'    <td style="text-align:left; padding: 8px;"><span style="color: #0e6654;"><i>#REQUESTED_AMOUNT# #CURRENCY#</i></span></td>',
'  </tr>',
'',
'  <tr>',
'    <td style="text-align:left;padding: 4px;background-color:#81d0b5;width:20%;">DCT Project </td>',
'    <td style="text-align:left;padding: 8px;background-color: #81d0b5;"> <span style="color:#0e6654;"><i>#DCT_PROJECT_NAME#</i></span> </td>',
'  </tr>',
' ',
'<tr>',
'    <td style="text-align: left;padding: 4px; width: 20%;">Project Description </td>',
'    <td style="text-align: left;padding: 8px;"><span style="color:#0e6654;"><i>#DCT_PROJECT_DESC#</i></span></td>',
'</tr>',
'  ',
'<tr>',
'    <td style="text-align:left;padding: 4px;background-color:#81d0b5;width:20%;">Recommended Vendor </td>',
'    <td style="text-align:left;padding: 8px;background-color: #81d0b5;"> <span style="color:#0e6654;"><i>#VENDOR_NAME#</i></span> </td>',
'  </tr>',
'  ',
'</table>',
'',
'<br>',
'<br>',
'<table border="0" align="center">                      ',
'	<tbody><tr>',
'				<td style="padding:16px 24px;border-radius:4px;min-width:200px;" bgcolor="#0e6654" align="center">',
'                          <a rel="nofollow" target="_blank" href="#APPLICATION_LINK#" style="font-size:16px;line-height:16px;font-weight:700;color:#FCFBFA;text-decoration:none;display:inline-block;padding:16px 24px;"> Approve / Reject </a>           '
||'             ',
'				</td>                      ',
'			</tr>                    ',
'	</tbody>',
'</table>',
''))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Manual PR Management </h2>',
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
