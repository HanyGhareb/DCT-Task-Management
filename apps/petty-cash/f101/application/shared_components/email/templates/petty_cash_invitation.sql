prompt --application/shared_components/email/templates/petty_cash_invitation
begin
--   Manifest
--     REPORT LAYOUT: Petty Cash Invitation
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
 p_id=>wwv_flow_api.id(564072631356834)
,p_name=>'Petty Cash Invitation'
,p_static_id=>'PETTY_CASH_INVITATION'
,p_subject=>'i-Finance: Petty Cash Management Invitation'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Hello <b><span style="color: #0e6654;"><i>#TITLE# #EMP_NAME#,</i></span></b>',
'<br>',
'',
'you are invited to use Petty Cash Management in <span style="color: #0e6654;"><i>i-Finance System</i></span> where you can create, submit and follow-up your petty cash requests, clearing requests and reimbursement requests. ',
'<br>',
'',
'',
'Here is your i-finance account Details:',
'<br>',
'<table style="font-family: arial, sans-serif; border-collapse: collapse; width: 100%;">',
'  <tr>    ',
'  <td style="border: 1px solid  #81d0b5; text-align: left; 	padding: 4px; background-color: #81d0b5; width: 30%;font-size:14px;"> User Name ',
'  </td>',
'  <td style="border: 1px solid #81d0b5;text-align: left; background-color: #81d0b5; padding: 8px;"> ',
'  		<span style="color: #0e6654;font-size:12px;"><i>#USER_NAME#</i></span> ',
'  </td>',
'  </tr>',
'    ',
'  <tr>',
'    <td style="border: 0px solid #c8f7f1;text-align: left; padding: 4px;background-color: #c8f7f1; width: 20%;font-size:12px;">Temporary Password </td>',
'    <td style="border: 0px solid #c8f7f1; text-align: left; padding: 8px; background-color: #c8f7f1;">',
'    		<span style="color: #0e6654;font-size:12px;"><i>#PASSWORD# &nbsp;&nbsp;&nbsp;  [you will be asking to change it]</i></span>',
'    </td>',
'  </tr>',
'</table>',
'<br>',
'<span style="color: #0e6654;"><i>#NOTES!RAW#</i></span>',
'<br>',
'',
'<table border="0" align="center">                      ',
'	<tbody><tr>',
'				<td style="padding:16px 24px;border-radius:4px;min-width:200px;" bgcolor="#0e6654" align="center">',
'       <a rel="nofollow" target="_blank" href="#MY_APPLICATION_LINK#" style="font-size:16px;line-height:16px;font-weight:700;color:#FCFBFA;text-decoration:none;display:inline-block;padding:16px 24px;"> i-Finance System </a>                        ',
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
