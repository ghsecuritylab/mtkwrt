<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> -CG加速</title>
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

var tinc_rulelist_array = [];
var add_ruleList_array = new Array();
var add_wanIp_array = new Array();
var add_lanIp_array = new Array();

$j(document).ready(function(){
	init_itoggle('tinc_enable');
});

function initial(){
	show_banner(0);
	show_menu(4, -1, 0);
	show_footer();

	//parse nvram to array
	var parseNvramToArray = function(oriNvram) {
		var parseArray = [];
		var oriNvramRow = decodeURIComponent(oriNvram).split('<');

		for(var i = 0; i < oriNvramRow.length; i += 1) {
			if(oriNvramRow[i] != "") {
				var oriNvramCol = oriNvramRow[i].split('>');
				var eachRuleArray = new Array();
				var action = oriNvramCol[0];
				eachRuleArray.push(action);
				var host = oriNvramCol[1];
				eachRuleArray.push(host);
				parseArray.push(eachRuleArray);
			}
		}
		return parseArray;
	};
	tinc_rulelist_array["tinc_rulelist_0"] = parseNvramToArray('<% nvram_char_to_ascii("","tinc_rulelist"); %>');
	gen_tinc_ruleTable_Block("tinc_rulelist_0");
	showtinc_rulelist(tinc_rulelist_array["tinc_rulelist_0"], "tinc_rulelist_0");

	tinc_rulelist_array["tinc_rulelist_1"] = parseNvramToArray('<% nvram_char_to_ascii("","tinc_wan_ip"); %>');
	gen_tinc_ruleTable_Block("tinc_rulelist_1");
	showtinc_rulelist(tinc_rulelist_array["tinc_rulelist_1"], "tinc_rulelist_1");

	tinc_rulelist_array["tinc_rulelist_2"] = parseNvramToArray('<% nvram_char_to_ascii("","tinc_lan_ip"); %>');
	gen_tinc_ruleTable_Block("tinc_rulelist_2");
	showtinc_rulelist(tinc_rulelist_array["tinc_rulelist_2"], "tinc_rulelist_2");
}

function validRuleForm(_tableID){
	if(_tableID == "tinc_rulelist_0") {
		add_ruleList_array = [];
		add_ruleList_array.push(document.getElementById("tinc_action_x_0" ).value);
		add_ruleList_array.push(document.getElementById("tinc_host_x_0").value);
	}
	if(_tableID == "tinc_rulelist_1") {
		add_wanIp_array = [];
		add_wanIp_array.push(document.getElementById("tinc_action_x_1" ).value);
		add_wanIp_array.push(document.getElementById("tinc_host_x_1").value);
	}
	if(_tableID == "tinc_rulelist_2") {
		add_lanIp_array = [];
		add_lanIp_array.push(document.getElementById("tinc_action_x_2" ).value);
		add_lanIp_array.push(document.getElementById("tinc_host_x_2").value);
	}

	return true;
}

function addRow_host(upper){
	if(validRuleForm("tinc_rulelist_0")){
		var rule_num = tinc_rulelist_array["tinc_rulelist_0"].length;
		if(rule_num >= upper){
			alert("<#JS_itemlimit1#> " + upper + " <#JS_itemlimit2#>");
			return false;
		}

		var tinc_rulelist_array_temp = tinc_rulelist_array["tinc_rulelist_0"].slice();
		var add_ruleList_array_temp = add_ruleList_array.slice();
		if(tinc_rulelist_array_temp.length > 0) {
			tinc_rulelist_array["tinc_rulelist_0"].push(add_ruleList_array);
		}
		else {
			tinc_rulelist_array["tinc_rulelist_0"].push(add_ruleList_array);
		}

		document.getElementById("tinc_action_x_0").value = "+";
		document.getElementById("tinc_host_x_0").value = "";
		showtinc_rulelist(tinc_rulelist_array["tinc_rulelist_0"], "tinc_rulelist_0");
		return true;
	}
}

function addRow_wanip(upper){
		if(validRuleForm("tinc_rulelist_1")){
			var rule_num = tinc_rulelist_array["tinc_rulelist_1"].length;
			if(rule_num >= upper){
				alert("<#JS_itemlimit1#> " + upper + " <#JS_itemlimit2#>");
				return false;
			}

			var tinc_rulelist_array_temp = tinc_rulelist_array["tinc_rulelist_1"].slice();
			var add_ruleList_array_temp = add_wanIp_array.slice();
			if(tinc_rulelist_array_temp.length > 0) {
				tinc_rulelist_array["tinc_rulelist_1"].push(add_wanIp_array);
			}
			else {
				tinc_rulelist_array["tinc_rulelist_1"].push(add_wanIp_array);
			}

			document.getElementById("tinc_action_x_1").value = "+";
			document.getElementById("tinc_host_x_1").value = "";
			showtinc_rulelist(tinc_rulelist_array["tinc_rulelist_1"], "tinc_rulelist_1");
			return true;
		}
}

function addRow_lanip(upper){
		if(validRuleForm("tinc_rulelist_2")){
			var rule_num = tinc_rulelist_array["tinc_rulelist_2"].length;
			if(rule_num >= upper){
				alert("<#JS_itemlimit1#> " + upper + " <#JS_itemlimit2#>");
				return false;
			}

			var tinc_rulelist_array_temp = tinc_rulelist_array["tinc_rulelist_2"].slice();
			var add_ruleList_array_temp = add_lanIp_array.slice();
			if(tinc_rulelist_array_temp.length > 0) {
				tinc_rulelist_array["tinc_rulelist_2"].push(add_lanIp_array);
			}
			else {
				tinc_rulelist_array["tinc_rulelist_2"].push(add_lanIp_array);
			}

			document.getElementById("tinc_action_x_2").value = "1";
			document.getElementById("tinc_host_x_2").value = "";
			showtinc_rulelist(tinc_rulelist_array["tinc_rulelist_2"], "tinc_rulelist_2");
			return true;
		}
}

function del_Row_host(row_idx){
	tinc_rulelist_array["tinc_rulelist_0"].splice(row_idx, 1);
	showtinc_rulelist(tinc_rulelist_array["tinc_rulelist_0"], "tinc_rulelist_0");
}

function del_Row_wanip(row_idx){
	tinc_rulelist_array["tinc_rulelist_1"].splice(row_idx, 1);
	showtinc_rulelist(tinc_rulelist_array["tinc_rulelist_1"], "tinc_rulelist_1");
}

function del_Row_lanip(row_idx){
	tinc_rulelist_array["tinc_rulelist_2"].splice(row_idx, 1);
	showtinc_rulelist(tinc_rulelist_array["tinc_rulelist_2"], "tinc_rulelist_2");
}

function showtinc_rulelist(_arrayData, _tableID) {
	if(_tableID == "tinc_rulelist_0") {
		var width_array = [18, 70, 12];
		var handle_long_text = function(_len, _text, _width) {
			var html = "";
			if(_text.length > _len) {
				var display_text = "";
				display_text = _text.substring(0, (_len - 2)) + "...";
				html +='<td style="text-align: center;" width="' +_width + '%" title="' + _text + '">' + display_text + '</td>';
			}
			else
				html +='<td style="text-align: center;" width="' + _width + '%">' + _text + '</td>';
			return html;
		};
		var code = "";
		code +='<table width="100%" cellspacing="0" cellpadding="4" align="center" class="table table-list">';
		if(_arrayData.length == 0) {
			code +='<tr><td colspan="3" style="text-align: center;"><div class="alert alert-info"><#IPConnection_VSList_Norule#></div></td></tr>';
		}
		else {
			for(var i = 0; i < _arrayData.length; i += 1) {
				var eachValue = _arrayData[i];
				if(eachValue.length != 0) {
					code +='<tr row_tr_idx="' + i + '">';
					for(var j = 0; j < eachValue.length; j += 1) {
						switch(j) {
							case 0 :
							case 1 :
								code += handle_long_text(64, eachValue[j], width_array[j]);
								break;
							case 2 :
								code += handle_long_text(14, eachValue[j], width_array[j]);
								break;
							default :
								code +='<td style="text-align: center;" width="' + width_array[j] + '%">' + eachValue[j] + '</td>';
								break;
						}
					}

					code +='<td width="14%"><input type="button" class="btn btn-danger" type="submit" onclick="del_Row_host(' + i + ');" value="<#CTL_del#>"></td></tr>';
					code +='</tr>';
				}
			}
		}
			code +='</table>';
			document.getElementById("tinc_rulelist_Block_0").innerHTML = code;
	}

	if(_tableID == "tinc_rulelist_1") {
		var width_array = [18, 70, 12];
		var handle_long_text = function(_len, _text, _width) {
			var html = "";
			if(_text == "+") _text = "启用加速";
			if(_text == "-") _text = "禁用加速";
			if(_text.length > _len) {
				var display_text = "";
				display_text = _text.substring(0, (_len - 2)) + "...";
				html +='<td style="text-align: center;" width="' +_width + '%" title="' + _text + '">' + display_text + '</td>';
			}
			else
				html +='<td style="text-align: center;" width="' + _width + '%">' + _text + '</td>';
			return html;
		};
		var code = "";
		code +='<table width="100%" cellspacing="0" cellpadding="4" align="center" class="table table-list">';
		if(_arrayData.length == 0) {
			code +='<tr><td colspan="3" style="text-align: center;"><div class="alert alert-info"><#IPConnection_VSList_Norule#></div></td></tr>';
		}
		else {
			for(var i = 0; i < _arrayData.length; i += 1) {
				var eachValue = _arrayData[i];
				if(eachValue.length != 0) {
					code +='<tr row_tr_idx="' + i + '">';
					for(var j = 0; j < eachValue.length; j += 1) {
						switch(j) {
							case 0 :
							case 1 :
								code += handle_long_text(64, eachValue[j], width_array[j]);
								break;
							case 2 :
								code += handle_long_text(14, eachValue[j], width_array[j]);
								break;
							default :
								code +='<td style="text-align: center;" width="' + width_array[j] + '%">' + eachValue[j] + '</td>';
								break;
						}
					}

					code +='<td width="14%"><input type="button" class="btn btn-danger" type="submit" onclick="del_Row_wanip(' + i + ');" value="<#CTL_del#>"></td></tr>';
					code +='</tr>';
				}
			}
		}
			code +='</table>';
			document.getElementById("tinc_rulelist_Block_1").innerHTML = code;
	}

	if(_tableID == "tinc_rulelist_2") {
		var width_array = [18, 70, 12];
		var handle_long_text = function(_len, _text, _width) {
			var html = "";
			if(_text == "1") _text = "启用全局";
			if(_text == "2") _text = "禁用加速";
			if(_text.length > _len) {
				var display_text = "";
				display_text = _text.substring(0, (_len - 2)) + "...";
				html +='<td style="text-align: center;" width="' +_width + '%" title="' + _text + '">' + display_text + '</td>';
			}
			else
				html +='<td style="text-align: center;" width="' + _width + '%">' + _text + '</td>';
			return html;
		};
		var code = "";
		code +='<table width="100%" cellspacing="0" cellpadding="4" align="center" class="table table-list">';
		if(_arrayData.length == 0) {
			code +='<tr><td colspan="3" style="text-align: center;"><div class="alert alert-info"><#IPConnection_VSList_Norule#></div></td></tr>';
		}
		else {
			for(var i = 0; i < _arrayData.length; i += 1) {
				var eachValue = _arrayData[i];
				if(eachValue.length != 0) {
					code +='<tr row_tr_idx="' + i + '">';
					for(var j = 0; j < eachValue.length; j += 1) {
						switch(j) {
							case 0 :
							case 1 :
								code += handle_long_text(64, eachValue[j], width_array[j]);
								break;
							case 2 :
								code += handle_long_text(14, eachValue[j], width_array[j]);
								break;
							default :
								code +='<td style="text-align: center;" width="' + width_array[j] + '%">' + eachValue[j] + '</td>';
								break;
						}
					}

					code +='<td width="14%"><input type="button" class="btn btn-danger" type="submit" onclick="del_Row_lanip(' + i + ');" value="<#CTL_del#>"></td></tr>';
					code +='</tr>';
				}
			}
		}
			code +='</table>';
			document.getElementById("tinc_rulelist_Block_2").innerHTML = code;
	}
}

function gen_tinc_ruleTable_Block(_tableID) {
	if(_tableID == "tinc_rulelist_0") {
		var html = "";
		html += '<table width="100%" align="center" cellpadding="4" cellspacing="0" class="table table-list" id="ACLList_Block">';

		html += '<tr><th colspan="3" style="background-color: #E3E3E3;">自定义域名规则</th></tr>';

		html += '<tr>';
		html += '<th width="18%">动作</th>';
		html += '<th width="70%" >域名</th>';
		html += '<th width="12%">添加/移除</th>';
		html += '</tr>';

		html += '<tr>';
		html += '<td width="18%">';
		html += '<select name="tinc_action_x_0" id="tinc_action_x_0" class="span12">';
		html += '<option value="+">增加到列表</option>';
		html += '<option value="-">从列表删除</option>';
		html += '</select>';
		html += '</td>';

		html += '<td width="70%">';
		html += '<input type="text" maxlength="128" class="span12" name="tinc_host_x_0" id="tinc_host_x_0" onKeyPress="return is_string(this,event);" />';
		html += '</td>';

		html += '<td width="12%">';
		html += '<input type="button" class="btn" style="max-width: 219px" onClick="addRow_host(128);" name="tinc_rulelist_0" id="tinc_rulelist_0" value="<#CTL_add#>">';
		html += '</td>';

		html += '</tr>';
		html += '</table>';

		document.getElementById("tinc_rulelist_Table_0").innerHTML = html;
	}
	if(_tableID == "tinc_rulelist_1") {
		var html = "";
		html += '<table width="100%" align="center" cellpadding="4" cellspacing="0" class="table table-list" id="ACLList_Block">';

		html += '<tr><th colspan="3" style="background-color: #E3E3E3;">自定义广域网IP规则</th></tr>';

		html += '<tr>';
		html += '<th width="18%">动作</th>';
		html += '<th width="70%" >IP地址</th>';
		html += '<th width="12%">添加/移除</th>';
		html += '</tr>';

		html += '<tr>';
		html += '<td width="18%">';
		html += '<select name="tinc_action_x_1" id="tinc_action_x_1" class="span12">';
		html += '<option value="+">启用加速</option>';
		html += '<option value="-">禁用加速</option>';
		html += '</select>';
		html += '</td>';

		html += '<td width="70%">';
		html += '<input type="text" maxlength="128" class="span12" name="tinc_host_x_1" id="tinc_host_x_1" onKeyPress="return is_string(this,event);" />';
		html += '</td>';

		html += '<td width="12%">';
		html += '<input type="button" class="btn" style="max-width: 219px" onClick="addRow_wanip(128);" name="tinc_rulelist_1" id="tinc_rulelist_1" value="<#CTL_add#>">';
		html += '</td>';

		html += '</tr>';
		html += '</table>';

		document.getElementById("tinc_rulelist_Table_1").innerHTML = html;
	}
	if(_tableID == "tinc_rulelist_2") {
		var html = "";
		html += '<table width="100%" align="center" cellpadding="4" cellspacing="0" class="table table-list" id="ACLList_Block">';

		html += '<tr><th colspan="3" style="background-color: #E3E3E3;">自定义局域网IP规则</th></tr>';

		html += '<tr>';
		html += '<th width="18%">动作</th>';
		html += '<th width="70%" >IP地址</th>';
		html += '<th width="12%">添加/移除</th>';
		html += '</tr>';

		html += '<tr>';
		html += '<td width="18%">';
		html += '<select name="tinc_action_x_2" id="tinc_action_x_2" class="span12">';
		html += '<option value="1">启用全局模式</option>';
		html += '<option value="2">禁用加速模式</option>';
		html += '</select>';
		html += '</td>';

		html += '<td width="70%">';
		html += '<input type="text" maxlength="128" class="span12" name="tinc_host_x_2" id="tinc_host_x_2" onKeyPress="return is_string(this,event);" />';
		html += '</td>';

		html += '<td width="12%">';
		html += '<input type="button" class="btn" style="max-width: 219px" onClick="addRow_lanip(128);" name="tinc_rulelist_2" id="tinc_rulelist_2" value="<#CTL_add#>">';
		html += '</td>';

		html += '</tr>';
		html += '</table>';

		document.getElementById("tinc_rulelist_Table_2").innerHTML = html;
	}
}

function applyRule(){
	if(validForm()){
		showLoading();
		
		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "cli.asp";
		document.form.next_page.value = "";
		
		//parse array to nvram
		var parseArrayToNvram = function(_dataArray) {
			var tmp_value = "";
			for(var i = 0; i < _dataArray.length; i += 1) {
				if(_dataArray[i].length != 0) {
					tmp_value += "<";
					var action = _dataArray[i][0];
					tmp_value += action + ">";
					var host = _dataArray[i][1];
					tmp_value += host;
				}
			}
			return tmp_value;
		};

		document.form.tinc_rulelist.value = parseArrayToNvram(tinc_rulelist_array["tinc_rulelist_0"]);
//		alert(document.form.tinc_rulelist.value);

		document.form.tinc_wan_ip.value = parseArrayToNvram(tinc_rulelist_array["tinc_rulelist_1"]);
//		alert(document.form.tinc_wan_ip.value);

		document.form.tinc_lan_ip.value = parseArrayToNvram(tinc_rulelist_array["tinc_rulelist_2"]);
//		alert(document.form.tinc_lan_ip.value);

		document.form.submit();
	}
	else
		return false;
}

function validHost(enDomain){
	var checkOK = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-0123456789. "
	var ch;
	var i, j;
	if(enDomain=="" || enDomain==" " || enDomain.length < 4) {
//		alert("请输入合法的域名");
		return false;
	}

	for (i = 0; i < enDomain.length;  i++) {
		ch = enDomain.charAt(i);
		for (j = 0; j < checkOK.length; j++) {
			if (ch == checkOK.charAt(j)) break;
		}
		if (j == checkOK.length) {
//			alert("请输入合法的域名");
			return false;
		}
	}
	return true;
}

function validForm(){
	var i;
	var host_dataArray = tinc_rulelist_array["tinc_rulelist_0"];
	for(i = 0; i < host_dataArray.length; i += 1) {
		if(!validHost(host_dataArray[i][1])) {
			alert("请输入合法的域名")
			return false;
		}
	}

	var wanip_dataArray = tinc_rulelist_array["tinc_rulelist_1"];
	for(i = 0; i < wanip_dataArray.length; i += 1) {
		if(parse_ipv4_addr(wanip_dataArray[i][1]) == null) {
			alert("请输入合法的IP地址")
			return false;
		}
	}

	var lanip_dataArray = tinc_rulelist_array["tinc_rulelist_2"];
	for(i = 0; i < lanip_dataArray.length; i += 1) {
		if(parse_ipv4_addr(lanip_dataArray[i][1]) == null) {
			alert("请输入合法的IP地址")
			return false;
		}
	}
	
	if(!validate_range(document.form.tinc_recon_seconds, 300, 864000))
		return false;

	return true;
}
</script>
<style>
#tabs {margin-bottom: 0px;}
.table-stat td {padding: 4px 8px;}
</style>
</head>

<body onload="initial();" >

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
    <input type="hidden" name="current_page" value="cli.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="tinc;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="">
	<input type="hidden" name="tinc_rulelist" value=''>
	<input type="hidden" name="tinc_wan_ip" value=''>
	<input type="hidden" name="tinc_lan_ip" value=''>
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
                            <h2 class="box_head round_top">CG加速 - 设置</h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
									<div>
										<ul class="nav nav-tabs" style="margin-bottom: 10px;">
                                            <li class="active"><a href="javascript:void(0)" id="tab_bw_rt">基本设置</a></li>
                                        </ul>
									</div>

                                    <table width="100%" align="center" cellpadding="4" cellspacing="0" class="table table-stat">
                                        <tr>
                                            <th>开启</th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="tinc_enable_on_of">
                                                        <input type="checkbox" id="tinc_enable_fake" <% nvram_match_x("", "tinc_enable", "1", "value=1 checked"); %><% nvram_match_x("", "tinc_enable", "0", "value=0"); %>>
                                                    </div>
                                                </div>

                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" value="1" name="tinc_enable" id="tinc_enable_1" <% nvram_match_x("", "tinc_enable", "1", "checked"); %>><#checkbox_Yes#>
                                                    <input type="radio" value="0" name="tinc_enable" id="tinc_enable_0" <% nvram_match_x("", "tinc_enable", "0", "checked"); %>><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>访客网络全局模式</th>
                                            <td>
                                                <select name="tinc_guest_enable" class="input">
                                                    <option value="0" <% nvram_match_x("","tinc_guest_enable", "0","selected"); %>><#btn_Disable#></option>
                                                    <option value="1" <% nvram_match_x("","tinc_guest_enable", "1","selected"); %>><#btn_Enable#></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>设备ID</th>
                                            <td>
                                                <input type="text" name="tinc_id" class="input" readonly="1" maxlength="32" size="32" value="<% nvram_get_x("","tinc_id"); %>" onkeypress="return is_string(this,event);"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>主动重连时间间隔（秒，默认3600）</th>
                                            <td>
                                                <input type="text" maxlength="6" size="6" name="tinc_recon_seconds" class="input" value="<% nvram_get_x("", "tinc_recon_seconds"); %>" onKeyPress="return is_number(this,event);">
                                                &nbsp;<span style="color:#888;">[300..864000]</span>
                                            </td>
                                        </tr>
                                    </table>

									<div id="tinc_rulelist_Table_0"></div>
									<div id="tinc_rulelist_Block_0"></div>

									<div id="tinc_rulelist_Table_1"></div>
									<div id="tinc_rulelist_Block_1"></div>

									<div id="tinc_rulelist_Table_2"></div>
									<div id="tinc_rulelist_Block_2"></div>

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
