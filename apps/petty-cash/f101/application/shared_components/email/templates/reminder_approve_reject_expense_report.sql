prompt --application/shared_components/email/templates/reminder_approve_reject_expense_report
begin
--   Manifest
--     REPORT LAYOUT: Reminder Approve Reject Expense Report
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(7050914383274036)
,p_name=>'Reminder Approve Reject Expense Report'
,p_static_id=>'REMINDER_APPROVE_REJECT_EXPENSE_REPORT'
,p_subject=>'Reminder- Action Required: Expense Report for #EMP_NAME# , Amount #AMOUNT#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<h1 style="background-color:Red; color: white; text-align: center;">Reminder</h1>',
'<br>',
'Hello <b><span style="color: #0e6654;"><i>#APPROVER_EMP_NAME#,</i></span></b>',
'<br>',
'This is kind reminder for action required for expense report# <span style="color: #0e6654;"><i>#EXPENSE_REPORT_NUM#</i></span> for employee: <span style="color: #0e6654;"><i>#EMP_NAME#</i></span> with amount <span style="color: #0e6654;"><i>#AMOUNT#<'
||'/i></span><br>',
'',
'<p>Here is the request Details:</p>',
'',
'<table style="font-family: arial, sans-serif; border-collapse: collapse; width: 100%;">',
'  <tr>    <td style="border: 1px solid  #81d0b5; text-align: left; 	padding: 4px; background-color: #81d0b5; width: 30%;"> Expense Report Num </td>',
'          <td style="border: 1px solid #81d0b5;  				text-align: left; background-color: #81d0b5; 				padding: 8px;"> <span style="color: #0e6654;"><i>#EXPENSE_REPORT_NUM#</i></span> </td>',
'  </tr>',
'    ',
'  <tr>',
'    <td style="border: 1px solid #dddddd; 				text-align: left; padding: 4px; width: 20%;"> Employee Name </td>',
'    <td style="border: 1px solid #dddddd; 				text-align: left; 				padding: 8px;"><span style="color: #0e6654;"><i>#EMP_NAME#</i></span></td>',
'  </tr>',
'',
'  <tr>',
'    <td style="border: 1px solid #dddddd; 				text-align: left; padding: 4px;  background-color: #81d0b5; width: 20%;">Cost Center </td>',
'    <td style="border: 1px solid #dddddd; 				text-align: left; 				padding: 8px; background-color: #81d0b5; "> <span style="color: #0e6654;"><i>#COST_CENTER_CODE#</i></span> </td>',
'  </tr>',
' ',
'   <tr>',
'    <td style="border: 1px solid #81d0b5;				 text-align: left; 				padding: 4px; width: 20%;"> Justification </td>',
'    <td style="border: 1px solid #81d0b5;				 text-align: left;  				padding: 8px;"><span style="color: #0e6654;"><i>#JUSTIFICATION#</i></span></td>',
'  </tr>',
'    ',
'  <tr>',
'    <td style="border: 1px solid #dddddd; 				text-align: left; padding: 4px;  background-color: #81d0b5; width: 20%;"> Amount</td>',
'    <td style="border: 1px solid #dddddd; 				text-align: left; 				padding: 8px; background-color: #81d0b5; "><span style="color: #0e6654;"><i>#AMOUNT#</i></span></td>',
'  </tr>',
'</table>',
'<br>',
'<br>',
'For any assistance, please contact <a href="mailto:HSleiman@dctabudhabi.ae">Ms. Hiba Hassan</a> (Petty Cash Admin - Finance Department)',
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
'    <h2>Petty Cash Management </h2>',
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
