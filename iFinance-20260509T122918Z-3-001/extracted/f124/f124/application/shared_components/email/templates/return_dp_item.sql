prompt --application/shared_components/email/templates/return_dp_item
begin
--   Manifest
--     REPORT LAYOUT: Return DP Item
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(129946440637481657)
,p_name=>'Return DP Item'
,p_static_id=>'RETURN_DP_ITEM'
,p_subject=>'#SUBJECT#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p style="display: none;"><code>iFinanceCode</code></p>',
'<p>Dear <span style="color: #008000;"><strong>#APPROVER_TITLE# <em>#APPROVER_NAME#,</em></strong></span></p>',
'<pre>Kindly not that the below <strong>#PLANNING_STATUS#</strong> Demand Planning Item <strong>#REQUEST_NO#</strong> returned.<br /><br />Comment: <span style="color: #ff0000;">#COMMENT#</span></pre>',
'<table style="height: 226px; width: 100%; border-collapse: collapse; border-style: none;" border="1">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 29.6696%; height: 18px; background-color: #0e6654;"><span style="color: #ffffff;">Initiative</span></td>',
'<td style="width: 70.263%; height: 18px;">',
'<pre>#INITIATIVE#</pre>',
'</td>',
'</tr>',
'<tr style="height: 66px;">',
'<td style="width: 29.6696%; height: 10px; background-color: #0e6654;"><span style="color: #ffffff;">Project</span></td>',
'<td style="width: 70.263%; height: 10px;">',
'<pre>#PROJECT#</pre>',
'</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.6696%; height: 18px; background-color: #0e6654;"><span style="color: #ffffff;">Category</span></td>',
'<td style="width: 70.263%; height: 18px;">',
'<pre>#CATEGORY#</pre>',
'</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.6696%; height: 18px; background-color: #0e6654;"><span style="color: #ffffff;">Description</span></td>',
'<td style="width: 70.263%; height: 18px;">',
'<pre>#DESCRIPTION#</pre>',
'</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.6696%; height: 18px; background-color: #0e6654;"><span style="color: #ffffff;">Sector/Department</span></td>',
'<td style="width: 70.263%; height: 18px;">',
'<pre>#SECTOR# - #DEPARTMENT#</pre>',
'</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.6696%; height: 18px; background-color: #0e6654;"><span style="color: #ffffff;">Cost Center</span></td>',
'<td style="width: 70.263%; height: 18px;">',
'<pre>#COST_CENTER#</pre>',
'</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.6696%; height: 18px; background-color: #0e6654;"><span style="color: #ffffff;">Estimated Date</span></td>',
'<td style="width: 70.263%; height: 18px;">',
'<pre>#ESTIMATED_DATE#</pre>',
'</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.6696%; height: 18px; background-color: #0e6654;"><span style="color: #ffffff;">Estimated Budget</span></td>',
'<td style="width: 70.263%; height: 18px;">',
'<pre>#ESTIMATED_BUDGET#</pre>',
'</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.6696%; height: 18px; background-color: #0e6654;"><span style="color: #ffffff;">Item Type</span></td>',
'<td style="width: 70.263%; height: 18px;">',
'<pre>#ITEM_TYPE#</pre>',
'</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.6696%; height: 18px; background-color: #0e6654;"><span style="color: #ffffff;">Risk</span></td>',
'<td style="width: 70.263%; height: 18px;">',
'<pre>#RISK#</pre>',
'</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.6696%; height: 18px; background-color: #0e6654;"><span style="color: #ffffff;">Priority</span></td>',
'<td style="width: 70.263%; height: 18px;">',
'<pre>#PRIORITY#</pre>',
'</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.6696%; height: 18px; background-color: #0e6654;"><span style="color: #ffffff;">Procurement Method</span></td>',
'<td style="width: 70.263%; height: 18px;">',
'<pre>#PROC_METHOD#</pre>',
'</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.6696%; height: 18px; background-color: #0e6654;"><span style="color: #ffffff;">Note</span></td>',
'<td style="width: 70.263%; height: 18px;">',
'<pre>#NOTE#</pre>',
'</td>',
'</tr>',
'</tbody>',
'</table>',
'<p>&nbsp;</p>',
'<p>please check attached for the full details.</p>',
'<table border="0" align="center">',
'<tbody>',
'<tr>',
'<td style="padding: 16px 24px; border-radius: 4px; min-width: 200px;" align="center" bgcolor="#0e6654"><a style="font-size: 16px; line-height: 16px; font-weight: bold; color: #fcfbfa; text-decoration: none; display: inline-block; padding: 16px 24px;"'
||' href="#APPLICATION_LINK#" target="_blank" rel="nofollow"> Access i-Finance </a></td>',
'</tr>',
'</tbody>',
'</table>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Supply Managment Department </h2>',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #f5f5f5; text-align: left; color: black;">',
'<h4>Best Regards</h4>',
'<h5><em>MIS Team</em>,</h5>',
'DPI0004',
'</div>'))
);
wwv_flow_api.component_end;
end;
/
