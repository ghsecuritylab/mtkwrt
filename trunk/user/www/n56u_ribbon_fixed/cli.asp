<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - 出国加速</title>
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

$j(document).ready(function(){
	init_itoggle('tinc_enable');
});

function initial(){
	show_banner(0);
	show_menu(4, -1, 0);
	show_footer();
}

function applyRule(){
	if(validForm()){
		showLoading();
		
		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "cli.asp";
		document.form.next_page.value = "";
		
		document.form.submit();
	}
}

function validForm(){
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
                            <h2 class="box_head round_top">出国加速 - 设置</h2>
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
                                            <td colspan="2" style="border-top: 0 none;">
                                                <br />
                                                <center><input class="btn btn-primary" style="width: 219px" type="button" value="<#CTL_apply#>" onclick="applyRule()" /></center>
                                            </td>
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
