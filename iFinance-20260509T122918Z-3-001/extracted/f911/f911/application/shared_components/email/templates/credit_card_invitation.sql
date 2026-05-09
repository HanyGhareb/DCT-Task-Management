prompt --application/shared_components/email/templates/credit_card_invitation
begin
--   Manifest
--     REPORT LAYOUT: Credit Card Invitation
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
 p_id=>wwv_flow_api.id(33813098681400549)
,p_name=>'Credit Card Invitation'
,p_static_id=>'CREDIT_CARD_INVITATION'
,p_subject=>'i-Finance: Credit Cards Management Invitation'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Hi <b><span style="color: #0e6654;"><i><b>#TITLE# #EMP_NAME#,</b></i></span></b>',
'<br>',
'<br>',
'you are invited to use <span style="color: #0e6654;"><i><b>Credit Cards Management module </b></i></span>in <span style="color: #0e6654;"><i><b>i-Finance System </b></i></span> where you can easily submit and follow-up your Credit Cards requests to f'
||'inance department. ',
'<br>',
'<br>',
'',
'Here is your i-finance account Details:',
'<br>',
'<br>',
'<table style="font-family: arial, sans-serif; border-collapse: collapse; width: 80%;">',
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
'<br>',
'<h2>Need Help ?</h2>',
'',
'<ul>',
'  <li><a href="https://ifinance.dct.gov.ae:8004/dct/prod/r/files/static/v19/login.pdf">How to access i-Finance system</a></li>',
'  <li><a href="https://ifinance.dct.gov.ae:8004/dct/prod/r/files/static/v19/New%20Credit%20Card%20Request.pdf#">How to submit new Credit Card request</a></li>',
'</ul>',
'<br>',
'<br>',
'<table border="0" align="center">                      ',
'	<tbody><tr>',
'				<td style="padding:16px 24px;border-radius:4px;min-width:200px;" bgcolor="#0e6654" align="center">',
'       <a rel="nofollow" target="_blank" href="#MY_APPLICATION_LINK#" style="font-size:16px;line-height:16px;font-weight:700;color:#FCFBFA;text-decoration:none;display:inline-block;padding:16px 24px;"> Access  &nbsp;i-Finance</a>                     '
||'   ',
'				</td>                      ',
'			</tr>                    ',
'	</tbody>',
'</table>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Credit Cards Management </h2>',
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
