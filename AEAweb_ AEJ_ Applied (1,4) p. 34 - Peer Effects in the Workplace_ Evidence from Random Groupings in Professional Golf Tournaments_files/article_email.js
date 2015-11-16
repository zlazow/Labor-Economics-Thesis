function check_form_email() {
document.email_article_form.email_to_email.style.backgroundColor = '#FFFFFF';


	if (!(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(document.email_article_form.email_to_email.value))) {
		// something is wrong
		alert('You must enter a valid email address to send to.');
		document.email_article_form.email_to_email.focus(); 
		document.email_article_form.email_to_email.style.backgroundColor = '#FFFF66'; 
		return false;
	}
	else if (!(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(document.email_article_form.email_from_email.value))) {
		// something else is wrong
		alert('You must enter a valid email address to send from.');
		document.email_article_form.email_from_email.focus(); 
		document.email_article_form.email_from_email.style.backgroundColor = '#FFFF66'; 
		return false;
	}
	
<!--	else if (another value is/is not something) { -->
		// something else is wrong
<!--		alert('No article has been chosen. Error 1'); -->
		<!--document.email_article_form.email_from_email.focus(); --> 
		<!-- document.email_article_form.email_from_email.style.backgroundColor = '#FFFF66'; -->
<!--		return false; -->
<!--	} -->

	return true;
}
