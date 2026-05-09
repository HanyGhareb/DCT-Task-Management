prompt --application/shared_components/email/templates/test
begin
--   Manifest
--     REPORT LAYOUT: TEST
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(66951039401193443)
,p_name=>'TEST'
,p_static_id=>'TEST'
,p_subject=>'Order (#ORDER_NUMBER#) Confirmed!'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<b>Hello #CUSTOMER_NAME#</b>,<br>',
'<br>',
'Thank you for placing your order!<br>',
'<br>',
'<b>Order Details</b><br>',
'<br>',
'<table width="100%">',
'  <tr>',
'    <th align="left">Order Date</th>',
'    <td>#ORDER_DATE#</td>',
'  </tr>',
'  <tr>',
'    <th align="left">Order Number</th>',
'    <td>#ORDER_NUMBER#</td>',
'  </tr>',
'  <tr>',
'    <th align="left">Ship To</th>',
'    <td>#SHIP_TO#</td>',
'  </tr>',
'  <tr>',
'    <th align="left" valign="top">Shipping Address</th>',
'    <td>',
'      #SHIPPING_ADDRESS_LINE_1#<br>',
'      #SHIPPING_ADDRESS_LINE_2#',
'    </td>',
'  </tr>',
'  <tr>',
'    <th align="left" valign="top">Items Ordered</th>',
'    <td>#ITEMS_ORDERED#</td>',
'  </tr>',
'  <tr>',
'    <th align="left">Order Total</th>',
'    <td>#ORDER_TOTAL#</td>',
'  </tr>',
'</table>',
'<br>',
'<br>',
'Need to make a change to your order? <a href="#ORDER_URL#">Manage your order #ORDER_NUMBER# here.</a>'))
,p_html_header=>'<b style="font-size: 24px;">My Application</b>'
,p_html_footer=>'<a href="#MY_APPLICATION_LINK#">Visit My Application and manage your email preferences</a>.'
,p_text_template=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Hello #CUSTOMER_NAME#,',
'',
'Thank you for placing your order!',
'',
'Order Details',
'--------------------------------------------------------------------------------',
'  Order Date:       #ORDER_DATE#',
'  Order Number:     #ORDER_NUMBER#',
'  Ship To:          #SHIP_TO#',
'  Shipping Address: #SHIPPING_ADDRESS_LINE_1#',
'                    #SHIPPING_ADDRESS_LINE_2#',
'  Items Ordered:    #ITEMS_ORDERED#',
'  Order Total:      #ORDER_TOTAL#',
'--------------------------------------------------------------------------------',
'',
'Need to make a change to your order? Manage your order #ORDER_NUMBER# here: #ORDER_URL#'))
);
wwv_flow_api.component_end;
end;
/
