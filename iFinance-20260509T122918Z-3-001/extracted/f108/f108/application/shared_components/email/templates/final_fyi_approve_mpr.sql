prompt --application/shared_components/email/templates/final_fyi_approve_mpr
begin
--   Manifest
--     REPORT LAYOUT: Final FYI  Approve MPR
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
 p_id=>wwv_flow_api.id(23090430433986404)
,p_name=>'Final FYI  Approve MPR'
,p_static_id=>'FINAL_FYI_APPROVE_MPR'
,p_subject=>'FYI - Manual PR #REQUEST_NUMBER# has been Approved'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Hi <b><span style="color: #0e6654;"><i>#FYI_EMP_NAME#,</i></span></b>',
'<br>',
'<br>',
'Please note that Manual PR# <span style="color: #0e6654;"><i><b>#REQUEST_NUMBER#</b></i></span> for Employee <span style="color: #0e6654;"><i><b>#REQUESTED_PERSON_NAME# </b></i></span> has been <span style="color:green;"><b>finally approved</b></span'
||'>.',
'',
'',
'Here is the request Details:',
'<br>',
'<br>',
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
'                          <a rel="nofollow" target="_blank" href="#APPLICATION_LINK#" style="font-size:16px;line-height:16px;font-weight:700;color:#FCFBFA;text-decoration:none;display:inline-block;padding:16px 24px;"> i-Finance </a>                  '
||'      ',
'				</td>                      ',
'			</tr>                    ',
'	</tbody>',
'</table>'))
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
