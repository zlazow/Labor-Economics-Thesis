loadingOverlays = {};

function loadingOverlayEngine(args){

	loadingOverlays[args["name"]] = this;

	this.name = args["name"];
	this.target = args["target"];
	this.hideTimer = null;
	this.hideTime = 500;
	this.resizeTimer = null;
	
}

loadingOverlayEngine.prototype.showOverlay = function(){

	this.cancelHideOverlayTimer();
	this.removeOverlay();
	this.createOverlay();
	this.positionOverlay();
	this.resizeByTimer();

};

loadingOverlayEngine.prototype.cancelHideOverlayTimer = function(){

	if(this.hideTimer !== null){

	clearTimeout(this.hideTimer);
	this.hideTimer = null;
	
	};

}

loadingOverlayEngine.prototype.resizeByTimer = function(){

	var obj = this;
	
	this.resizeTimer = setInterval(function(){ obj.positionOverlay(); },10);

};

loadingOverlayEngine.prototype.removeOverlay = function(){

	clearInterval(this.resizeTimer);
	this.resizeTimer = null;
	
	this.cancelHideOverlayTimer();

	if($(this.target).find('#overlay_wrapper_'+this.name).length > 0){
	
	$(this.target).find('#overlay_wrapper_'+this.name).remove();
	
	};

};

loadingOverlayEngine.prototype.hideOverlay = function(){

	var obj = this;
	
	this.hideTimer = setTimeout(function(){ obj.removeOverlay(); },this.hideTime);

};

loadingOverlayEngine.prototype.createOverlay = function(){

	$(this.target).prepend('<div class="loadingOverlayWrapper" id="overlay_wrapper_'+this.name+'"></div>');
	$(this.target).find('#overlay_wrapper_'+this.name).prepend('<div id="message_wrapper"></div>');
	$(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").prepend('<div id="message">Please wait...</div>');
	
	$(this.target).find('#overlay_wrapper_'+this.name).css("position","absolute");
	$(this.target).find('#overlay_wrapper_'+this.name).css("z-index","999999999999999999999999");
	$(this.target).find('#overlay_wrapper_'+this.name).css("background-image","url(/images/white-background-70-percent.png)");
	$(this.target).find('#overlay_wrapper_'+this.name).css("width","100%");
	$(this.target).find('#overlay_wrapper_'+this.name).css("height","100%");
	
	$(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").css("position","absolute");	
	$(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").css("background-image","url(/images/my_loading.gif)");
	$(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").css("background-repeat","no-repeat");
	$(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").css("background-position","5px center");
	$(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").css("background-color","#FFFFFF");
	$(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").css("padding","10px");
	$(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").css("padding-left","38px");
	$(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").css("border","#CCCCCC 1px solid");
	$(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").css("font-size","18px");
	$(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").css("font-weight","bold");

};

loadingOverlayEngine.prototype.positionOverlay = function(){

	var targetWidth = $(document).outerWidth(true);
	var targetHeight = $(document).outerHeight(true);
	var htmlScrollTop = $(document).scrollTop();
	var messageWidth = $(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").outerWidth(true);
	
	$(this.target).find('#overlay_wrapper_'+this.name).css("width",targetWidth+"px");
	$(this.target).find('#overlay_wrapper_'+this.name).css("height",targetHeight+"px");
	$(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").css("left",((targetWidth / 2) - (messageWidth / 2))+"px");
	$(this.target).find('#overlay_wrapper_'+this.name).find("#message_wrapper").css("top",(htmlScrollTop+50)+"px")
	
};