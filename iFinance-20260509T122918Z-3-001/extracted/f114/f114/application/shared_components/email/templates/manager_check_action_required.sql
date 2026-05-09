prompt --application/shared_components/email/templates/manager_check_action_required
begin
--   Manifest
--     REPORT LAYOUT: Manager Check Action Required
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(53356607298735908)
,p_name=>'Manager Check Action Required'
,p_static_id=>'MANAGER_CHECK_ACTION_REQUIRED'
,p_subject=>'Action Required: Release Cheque #CHECK_NUM# Amount #AMOUNT#.'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear <span style="color: #ff0000;"><strong>#APPROVER_TITLE# #APPROVER_EMP_NAME#,</strong></span></p>',
'<p>your kind attention required to release cheque <strong><span style="color: #ff0000;">#CHECK_NUM#</span></strong> with amount <strong><span style="color: #ff0000;">#AMOUNT# #CURRENCY#</span></strong>.&nbsp;</p>',
'<p>Here is the cheque details:</p>',
'<table style="height: 226px; width: 100%; border-collapse: collapse;" border="1">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Vendor</strong></td>',
'<td style="width: 69.7849%; height: 18px;">#SUPPLIER_NAME#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Deliverable</strong></td>',
'<td style="width: 69.7849%; height: 18px;">#DESCRIPTIONS#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Business Owner</strong></td>',
'<td style="width: 69.7849%; height: 18px;">#FULL_NAME_EN#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Payment Type</strong></td>',
'<td style="width: 69.7849%; height: 18px;">#PAYMENT_TYPE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Milestone</strong></td>',
'<td style="width: 69.7849%; height: 18px;">#MILESTONE_DESC#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Due Date</strong></td>',
'<td style="width: 69.7849%; height: 18px;">#MILESTONE_DATE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Project</strong></td>',
'<td style="width: 69.7849%; height: 18px;">#PROJECT#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Task</strong></td>',
'<td style="width: 69.7849%; height: 18px;">#TASK#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Comment</strong></td>',
'<td style="width: 69.7849%; height: 18px;">#COMMENTS#</td>',
'</tr>',
'</tbody>',
'</table>',
'<p>&nbsp;</p>',
'<table style="border-collapse: collapse; width: 100%; height: 50px;" border="1">',
'<tbody>',
'<tr style="height: 50px;">',
'<td style="padding: 16px 24px; border-radius: 4px; min-width: 200px; height: 50px; width: 49.6994%;" align="center" bgcolor="red"><a style="font-size: 14px; line-height: 16px; font-weight: bold; color: #fcfbfa; text-decoration: none; display: inline-'
||'block; padding: 16px 24px;" href="#EXPRESS_LINK#" target="_blank" rel="nofollow"> OTP Approve/Reject </a></td>',
'<td style="width: 14.008%; border-style: hidden; height: 50px;">&nbsp;</td>',
'<td style="padding: 16px 24px; border-radius: 4px; min-width: 200px; width: 45.2652%; height: 50px;" align="center" bgcolor="#120E78"><a style="font-size: 16px; line-height: 14px; font-weight: bold; color: #fcfbfa; text-decoration: none; display: inl'
||'ine-block; padding: 16px 24px;" href="#APPLICATION_LINK#" target="_blank" rel="nofollow"> Approve/Reject </a></td>',
'</tr>',
'</tbody>',
'</table>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Manager Cheques </h2>',
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
