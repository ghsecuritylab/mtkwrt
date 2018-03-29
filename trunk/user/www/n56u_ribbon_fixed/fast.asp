<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - 快速设置</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/itoggle.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script>
var $j = jQuery.noConflict();

$j(document).ready(function() {
});
</script>

<script>
<% login_state_hook(); %>

function initial(){
	show_banner(0);
	show_menu(0,-1,0);
	show_footer();

	change_wan_type(document.form.wan_proto.value, 0);
	fixed_change_wan_type(document.form.wan_proto.value);

	document.form.rt_ssid.value = decodeURIComponent(document.form.rt_ssid2.value);

	document.form.rt_wpa_psk.value = decodeURIComponent(document.form.rt_wpa_psk_org.value);
	if(document.form.rt_auth_mode.value == "open") {
		$("row_wpa2").style.display = "none";
	}
}

function applyRule(){
	if(validForm()){
		showLoading();

		document.form.current_page.value = "/fast.asp";
		document.form.next_page.value = "";
		document.form.action_mode.value = " Apply ";

		inputCtrl(document.form.rt_crypto, 1);
		inputCtrl(document.form.rt_wpa_psk, 1);

		document.form.submit();
	}
}

function validForm(){
	var wan_proto = document.form.wan_proto.value;

	if(wan_proto == "pppoe"){
		if(!validate_string(document.form.wan_pppoe_username)
				|| !validate_string(document.form.wan_pppoe_passwd))
			return false;
	}

	var auth_mode = document.form.rt_auth_mode.value;
	if(auth_mode == "psk"){
		if(!validate_psk(document.form.rt_wpa_psk))
			return false;
	}

	if(!validate_string_ssid(document.form.rt_ssid))
		return false;

	if(document.form.rt_ssid.value == "")
		document.form.rt_ssid.value = "ZHTEL";

	return true;
}

function change_wan_type(wan_type, flag){
	var is_pppoe = (wan_type == "pppoe") ? 1 : 0;

	showhide_div("tbl_vpn_control", is_pppoe);
}

function fixed_change_wan_type(wan_type){

}

function change_rt_auth_mode(_this) {
        if (_this.value == "psk") {			//WPA2-Personal + AES
            document.form.rt_auth_mode.value = "psk";
            document.form.rt_wpa_mode.value = "2";
            document.form.rt_crypto.value = "aes";

            $("row_wpa2").style.display = "";

            document.form.rt_wpa_psk.focus();
            document.form.rt_wpa_psk.select();
        }
        else {
            document.form.rt_auth_mode.value = "open";
            $("row_wpa2").style.display = "none";
        }

    return true;
}

</script>
</head>

<body onload="initial();" onunLoad="return unload_body();">

<div class="wrapper">
    <div class="container-fluid" style="padding-right: 0px">
        <div class="row-fluid">
            <div class="span3"><center><div id="logo"></div></center></div>
            <div class="span9">
                <div id="TopBanner"></div>
            </div>
        </div>
    </div>

    <div id="Loading" class="popup_bg"></div>

    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

    <form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
    <input type="hidden" name="current_page" value="fast.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="Layer3Forwarding;LANHostConfig;IPConnection;PPPConnection;WLANConfig11b;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="">
    <input type="hidden" name="rt_wpa_mode" value="<% nvram_get_x("","rt_wpa_mode"); %>">
    <input type="hidden" name="rt_crypto" value="<% nvram_get_x("","rt_crypto"); %>">
    <input type="hidden" name="rt_wpa_psk_org" value="<% nvram_char_to_ascii("", "rt_wpa_psk"); %>">
    <input type="hidden" name="rt_ssid2" value="<% nvram_char_to_ascii("",  "rt_ssid"); %>">

    <div class="container-fluid">
        <div class="row-fluid">
            <div class="span3">
                <!--Sidebar content-->
                <!--=====Beginning of Main Menu=====-->
                <div class="well sidebar-nav side_nav" style="padding: 0px;">
                    <ul id="mainMenu" class="clearfix"></ul>
                    <ul class="clearfix">
                        <li>
                            <div id="subMenu" class="accordion"></div>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="span9">
                <!--Body content-->
                <div class="row-fluid">
                    <div class="span12">
                        <div class="box well grad_colour_dark_blue">
                            <h2 class="box_head round_top">快速设置</h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>

                                    <table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th width="50%"><#Layer3Forwarding_x_ConnectionType_itemname#></th>
                                            <td align="left">
                                                <select class="input" name="wan_proto" onchange="change_wan_type(this.value);fixed_change_wan_type(this.value);">
                                                    <option value="dhcp" <% nvram_match_x("", "wan_proto", "dhcp", "selected"); %>>IPoE: <#BOP_ctype_title1#></option>
                                                    <option value="pppoe" <% nvram_match_x("", "wan_proto", "pppoe", "selected"); %>>PPPoE</option>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>

                                    <table width="100%" align="center" cellpadding="4" cellspacing="0" class="table" id="tbl_vpn_control">
                                        <tr>
                                            <th width="50%"><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this,7,4);"><#PPPConnection_UserName_itemname#></a></th>
                                            <td>
                                               <input type="text" maxlength="64" class="input" size="32" name="wan_pppoe_username" value="<% nvram_get_x("","wan_pppoe_username"); %>" onkeypress="return is_string(this,event);"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this,7,5);"><#PPPConnection_Password_itemname#></a></th>
                                            <td>
                                                <div class="input-append">
                                                    <input type="password" maxlength="64" class="input" size="32" name="wan_pppoe_passwd" id="wan_pppoe_passwd" style="width: 175px;" value="<% nvram_get_x("","wan_pppoe_passwd"); %>"/>
                                                    <button style="margin-left: -5px;" class="btn" type="button" onclick="passwordShowHide('wan_pppoe_passwd')"><i class="icon-eye-close"></i></button>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                    <table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th width="50%"><a class="help_tooltip" href="javascript: void(0)" onmouseover="openTooltip(this, 0, 1);"><#WLANConfig11b_SSID_itemname#></a></th>
                                            <td><input type="text" maxlength="32" class="input" size="32" name="rt_ssid" value="" onkeypress="return is_string(this,event);"></td>
                                        </tr>
                                        <tr>
                                            <th width="50%">无线加密</th>
                                            <td>
                                                <select name="rt_auth_mode" class="input" onChange="return change_rt_auth_mode(this);">
                                                    <option value="open" <% nvram_match_x("", "rt_auth_mode", "open", "selected"); %>>不加密</option>
                                                    <option value="psk" <% nvram_double_match_x("", "rt_auth_mode", "psk", "", "rt_wpa_mode", "2", "selected"); %>>WPA2加密</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="row_wpa2">
                                            <th><#WLANConfig11b_x_PSKKey_itemname#></th>
                                            <td>
                                                <div class="input-append">
                                                    <input type="password" name="rt_wpa_psk" id="rt_wpa_psk" maxlength="64" size="32" value="" style="width: 175px;">
                                                    <button style="margin-left: -5px;" class="btn" type="button" onclick="passwordShowHide('rt_wpa_psk')"><i class="icon-eye-close"></i></button>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;"><center><input name="button" type="button" class="btn btn-primary" style="width: 219px" onclick="applyRule();" value="<#CTL_apply#>"/></center></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    </form>

    <div id="footer"></div>
</div>
</body>
</html>
