//var dev_mode = "_dev";
var dev_mode = "";

function switch_mode(doi, mode){

			saveListAJaxHandle = new ajaxEngine("saveListAjax",{'killType':'killList',"killList":Array("saveListAjax")});
			saveListAJaxHandle.url = "/rte/joe/manage/include/Functions/employ/display_play_area.php";

			if(mode == "edit"){
			
				saveListAJaxHandle.url = "/content/articles/articles_edit.php";
				saveListAJaxHandle.variableString = "doi="+doi;
				
			}else{
			
				saveListAJaxHandle.url = "/content/articles/articles_detail.php";
				saveListAJaxHandle.variableString = "doi="+doi+"&user_view_mode=t";
				
			}
			
			
			saveListAJaxHandle.dataType = "html";
			saveListAJaxHandle.callBackFunction = function(ajaxData){ 
				
			if(ajaxData != "notmodified" && ajaxData != "error" && ajaxData != "timeout" && ajaxData != "abort" && ajaxData != "parsererror"){
			alert(ajaxData);
				$("#content_switch").html(ajaxData);
			}

			};
			
			saveListAJaxHandle.runAjax();

}

function setCookie(key, value) {  
   var expires = new Date();  
   expires.setTime(expires.getTime() + 31536000000); //1 year  
   document.cookie = key + '=' + value + ';expires=' + expires.toUTCString();  
   }  
  
function getCookie(key) {  
   var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');  
   return keyValue ? keyValue[2] : null;  
}  
function deleteCookie(c_name) {
    document.cookie = encodeURIComponent(c_name) + "=deleted; expires=" + new Date(0).toUTCString();
}

function show_setting(display_num){
	if(display_num == 0){
		document.getElementById("settings_hover").style.display="inline";
	}

	if(display_num == 1){
		document.getElementById("settings_hover").style.display="none";
	}
}
   function loadDialog(title, destination){
	$('#dialog').load(destination);
	$('#dialog').dialog({
		title: title,
		width: 600,
		height: 'auto',
		resizable: false,
		modal: true
	});
}
	function loadDialog_2(title, destination, size){
		$('#dialog_2').load(destination);
				$('#dialog_2').dialog({
					position: 'top',
					title: title,
					minWidth: size,
					modal: true,
					resizable: false,
					buttons: {
								"Close" : function(){  $(this).dialog("close"); }
					}
				});
		}
		
	function loadDialog_5(title, destination, size){
		$('#dialog_5').load(destination);
				$('#dialog_5').dialog({
					position: 'top',
					title: title,
					minWidth: size,
					modal: true,
					resizable: false,
					buttons: {
								"Search" :function(){  process_search(); },
								"Close" : function(){  $(this).dialog("close"); }
					}
				});
		}
		
		function expand_right_col(){
			var d = $("#dialog_3").dialog();
			d.dialog("option", "width", 500);
			$('#art_right_col').show(400);
			$('#expand_right_col').hide(400);
			$('.sub_head_dialog').css('width', 230);
			$('.sub_head_info').css('width', 230);
			$('#dialog_h2').css('width', 230);
			$('.comment').css('width', 230);
		}
/*		
var rtime = new Date(1, 1, 2000, 12,00,00);
var timeout = false;
var delta = 200;
$(window).resize(function() {
    rtime = new Date();
    if (timeout === false) {
        timeout = true;
        setTimeout(resizeend, delta);
    }
});

function resizeend() {
    if (new Date() - rtime < delta) {
        setTimeout(resizeend, delta);
    } else {
        timeout = false;
        				$('#w').text(ui.size.width());
						$('#h').text(ui.size.height());
						var new_width = ui.size.width();
						var new_height = ui.size.height();
						var difference_size = 950 - new_width+20;
						$('#d').text(difference_size);
					//	alert("DONE");
    }               
}*/

		
		function loadDialog_3_direct(title, destination, size){
		$('#single_load').load(destination);
			/*	$('#single_load').dialog({
					position: 'top',
					title: title,
					minWidth: size,
					modal: true,
					resizable: false,
					buttons: {
								"Close" : function(){  $(this).dialog("close"); }
					}
				});*/
		}
		
		function loadDialog_4(title, destination, size){
		$('#dialog_4').load(destination);
				$('#dialog_4').dialog({
					title: title,
					minWidth: size,
					modal: true,
					resizable: false,
					buttons: {
								"Close" : function(){  $(this).dialog("close"); }
					}
				});
		}
		
		   function showHideItems_2(myItem, myButton){

    //this is the ID of the hidden item
    var myItem = document.getElementById(myItem);

    //this is the ID of the plus/minus button image

        if (myItem.style.display != "none") {
            //items are currently displayed, so hide them
            myItem.style.display = "none";

        }
        else {

            //items are currently hidden, so display them
            myItem.style.display = "block";
      
        }

    }

function submit_comment(){
	var first_name = document.comment_form.first_name_2;
	var last_name = document.comment_form.last_name_2;
	var comment = document.comment_form.comment;
	var url1 = document.comment_form.url1;
	var url1_desc = document.comment_form.url1_desc;
	var url2 = document.comment_form.url2;
	var url2_desc = document.comment_form.url2_desc;
	var url3 = document.comment_form.url3;
	var url3_desc = document.comment_form.url3_desc;
	
	if(first_name.value ==""){
	document.getElementById("error_message").style.display="block";
	document.getElementById("error_message").innerHTML="Please enter your first name.";
	return false;
		}
	if(last_name.value ==""){
	document.getElementById("error_message").style.display="block";
	document.getElementById("error_message").innerHTML="Please enter your last name.";
	return false;
		}
	if(comment.value ==""){
	document.getElementById("error_message").style.display="block";
	document.getElementById("error_message").innerHTML="Please enter a comment.";
	return false;
		}
		
	if(url1_desc.value == "" && url1.value != ""){
	document.getElementById("error_message").style.display="block";
	document.getElementById("error_message").innerHTML="Please enter a description for URL #1.";
	return false;
	}
	
	if(url1.value == "" && url1_desc.value != ""){
	document.getElementById("error_message").style.display="block";
	document.getElementById("error_message").innerHTML="Please enter a URL for URL #1.";
	return false;
	}
	
	if(url2_desc.value == "" && url2.value != ""){
	document.getElementById("error_message").style.display="block";
	document.getElementById("error_message").innerHTML="Please enter a description for URL #2.";
	return false;
	}
	
	if(url2.value == "" && url2_desc.value != ""){
	document.getElementById("error_message").style.display="block";
	document.getElementById("error_message").innerHTML="Please enter a URL for URL #2.";
	return false;
	}
	
	if(url3_desc.value == "" && url3.value != ""){
	document.getElementById("error_message").style.display="block";
	document.getElementById("error_message").innerHTML="Please enter a description for URL #3.";
	return false;
	}
	
	if(url3.value == "" && url3_desc.value != ""){
	document.getElementById("error_message").style.display="block";
	document.getElementById("error_message").innerHTML="Please enter a URL for URL #3.";
	return false;
	}
	
			// we want to store the values from the form input box, then send via ajax below
			var str = $("form#comment_update").serialize();
			var doi = document.comment_form.doi;
			var title = document.comment_form.title;
				$.ajax({
					type: "POST",
					url: "/content/articles"+dev_mode+"/add_comment_process.php",
					data: "success=yes&"+str,
					success: function(){
					$('#dialog_3').load('/content/articles'+dev_mode+'/articles_detail.php?doi='+doi.value);
					$('#dialog_3').dialog({
					title: title.value,
					minWidth: 950,
					modal: true,
					resizable: false,
					buttons: {
								"Close" : function(){  $(this).dialog("close"); }
					}
				});
					}
				});
			return false; 
	}




function load_interface(){
  $('#admin_interface').dialog({
					title: 'Admin Interface',
					minWidth: 400,
					modal: true,
					resizable: false,
					buttons: {
								"Close" : function(){  $(this).dialog("close"); }
					}
				});
}

function search_issue_load(doi){
/*document.getElementById("search_btn_2").value = "Update Search";
document.getElementById("right_col_2").style.display="block";
document.getElementById("bottom_col").style.display="none";
var search_form = $("form#search_boxes").serialize();
$('#right_col_2').load('include/articles/search_articles_right_col.php?'+search_form+'&doi='+doi);*/

}

function next_page(page, requested_amount, session_tab){
//$('#bottom_col').load('test_page.php?page='+page);
$("#bottom_col").empty().html('<img alt="loading" src="/content/articles'+dev_mode+'/images/loading.gif" /> Loading...');
$('#bottom_col').load('/content/articles'+dev_mode+'/include/articles/search_algorithm.php?page='+page+"&limit_per_page="+requested_amount+"&hidden_session="+session_tab);
}

/*
$(document).keydown(function(e){
    if (e.keyCode == 37) { 
var page = document.page_number_minus.page_num.value;
var requested_amount = document.search_boxes.limit_per_page.value;
var session_tab = document.search_boxes.hidden_session.value;
var search_box_field = document.search_boxes.search_box.value;
search_box_field = search_box_field.replace(/\s/g, '%20')
var phrase_select = $('.search_phrase:checked').val();
$("#bottom_col").empty().html('<img alt="loading" src="../../../content/articles/images/loading.gif" /> Loading...');
$('#bottom_col').load('../../../content/articles/include/articles/search_algorithm_new.php?page='+page+"&limit_per_page="+requested_amount+"&hidden_session="+session_tab+"&phrase="+phrase_select+"&search_box="+search_box_field);
       return false;
    }

 if (e.keyCode == 39) { 
var page = document.page_number_plus.page_num.value
var requested_amount = document.search_boxes.limit_per_page.value;
var session_tab = document.search_boxes.hidden_session.value;
var search_box_field = document.search_boxes.search_box.value;
search_box_field = search_box_field.replace(/\s/g, '%20')
var phrase_select = $('.search_phrase:checked').val();
$("#bottom_col").empty().html('<img alt="loading" src="../../../content/articles/images/loading.gif" /> Loading...');
$('#bottom_col').load('../../../content/articles/include/articles/search_algorithm_new.php?page='+page+"&limit_per_page="+requested_amount+"&hidden_session="+session_tab+"&phrase="+phrase_select+"&search_box="+search_box_field);
       return false;
    }
});*/

function next_page_test(page, requested_amount, session_tab){

var search_box_field = document.search_boxes.search_box.value;
search_box_field = search_box_field.replace(/\s/g, '%20')
var phrase_select = $('.search_phrase:checked').val();
//$('#bottom_col').load('test_page.php?page='+page);
$("#bottom_col").empty().html('<img alt="loading" src="/content/articles'+dev_mode+'/images/loading.gif" /> Loading...');
$('#bottom_col').load('/content/articles'+dev_mode+'/include/articles/search_algorithm_new.php?page='+page+"&limit_per_page="+requested_amount+"&hidden_session="+session_tab+"&phrase="+phrase_select+"&search_box="+search_box_field);
//$('#bottom_col').load('../../../content/articles/include/articles/search_algorithm_new.php?page='+page+"&limit_per_page="+requested_amount+"&hidden_session="+session_tab);
}
function show_jel(){
  if (document.search_boxes.search_jel.checked == true)
        {
            document.getElementById("window").style.display="block";
        } else {
			$('select option:first-child').attr("selected", "selected");
            document.getElementById("window").style.display="none";
        }


}



function jel_subscription_query(){
var form_data = $('form#jel_subscription').serialize();

$.ajax({
            type: "POST",
            url: "/content/articles"+dev_mode+"/include/articles/virtual_subscriptions.php",
            data: form_data,
            success: function(){
				alert("Your subscription has been updated");
                $('#d2').load('/content/articles'+dev_mode+'/include/articles/vfj_subscription.php');
				/*$('#dialog_2').dialog({
					title: 'Virtual Field Subscriptions',
					minWidth: 800,
					modal: true,
					resizable: false,
					buttons: {
								"Close" : function(){  $(this).dialog("close"); }
					}
				});*/
            }
        });
    return false;

}


function show_options(){
	if($('#article_functions').is(":visible")){
		$('#article_functions').hide(500);
	}else{
		$('#article_functions').show(500);
	}
}

function setting_opt(switch_img){

	if(switch_img == 1){
	document.getElementById('hover_field').innerHTML = "<img src='/content/articles"+dev_mode+"/images/dialog.png' />";
	}
	if(switch_img == 2){
	document.getElementById('hover_field').innerHTML = "<img src='/content/articles"+dev_mode+"/images/tab.png' />";
	}
	if(switch_img == 3){
	document.getElementById('hover_field').innerHTML = "<img src='/content/articles"+dev_mode+"/images/direct.png' />";
	}
}

$(document).mouseup(function (e)
{
    var container = $("#article_functions");

    if (container.has(e.target).length === 0)
    {
        container.hide(500);
    }
});


/*
$(".ui-resizable-handle ui-resizable-n")
$(".ui-resizable-handle ui-resizable-s")
$(".ui-resizable-handle ui-resizable-e")
$(".ui-resizable-handle ui-resizable-w")
$(".ui-resizable-handle ui-resizable-sw")
$(".ui-resizable-handle ui-resizable-ne")
$(".ui-resizable-handle ui-resizable-nw")
$(".ui-resizable-handle ui-resizable-se ui-icon ui-icon-gripsmall-diagonal-se ui-icon-grip-diagonal-se").click(function () {
alert("F");
//$(".ui-resizable-handle ui-resizable-se ui-icon ui-icon-gripsmall-diagonal-se ui-icon-grip-diagonal-se").off("click", save_size);
});
*/

/*
$(document).ready(function() {
addthis.init();
addthis.counter(".addthis_counter");
addthis.toolbox('.addthis_toolbox');
});
*/

/*
(function() {
    var beforePrint_articles = function() {
	$("#article_functionality").css("display", "none");
	$("#art_right_col").css("display", "none");
	$("#dialog_upper_content").css("display", "none");
	$("#expand_right_col").css("display", "none");
    };
    var afterPrint_articles = function() {
	$("#article_functionality").css("display", "block");
	$("#art_right_col").css("display", "block");
	$("#dialog_upper_content").css("display", "block");
    };

    if (window.matchMedia) {
        var mediaQueryList_2 = window.matchMedia('print');
        mediaQueryList_2.addListener(function(mql) {
            if (mql.matches) {
                beforePrint_articles();
            } else {
                afterPrint_articles();
            }
        });
    }

    window.onbeforeprint = beforePrint_articles;
    window.onafterprint = afterPrint_articles;
}());*/