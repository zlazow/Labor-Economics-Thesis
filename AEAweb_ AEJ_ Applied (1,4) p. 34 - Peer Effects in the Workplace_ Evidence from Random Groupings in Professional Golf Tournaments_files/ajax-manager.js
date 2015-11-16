var ajaxObjects = {};

// ******************************
// Ajax Engine: Class Constructor
// ******************************
function ajaxEngine(fmly,args){

	this.familyName = fmly;
	this.args = {};
	
	try{
		
		if(typeof(args) != "undefined" && typeof(args) == "object"){
		this.args = args;
		};

	}catch(e){};
	
	this.killLiveSessions(this.args);	

	ajaxObjects[this.familyName] = this;
	this.ajaxHandle = null;
	this.dataType = 'json';
	this.cache = false;
	this.type = 'post';
	this.url = null;
	this.contentType = 'application/x-www-form-urlencoded; charset=UTF-8';
	this.processData = true;
	this.variableString = null;
	this.ajaxTimeout = 60000;
	this.callBackFunction = "";
	this.checkAjaxVarsMethod = 'checkAll';
	this.formDataSwitch = false;
	this.formData = null;
	this.overlay = null;
	this.hasLoadingOverlay = true;

	try{
	
		if(this.args["showLoadingOverlay"] === true || this.args["showLoadingOverlay"] === false){
		
		this.hasLoadingOverlay = this.args["showLoadingOverlay"];
		
		};

	}catch(e){};
	
	try{
	
		if(this.hasLoadingOverlay === true && typeof(loadingOverlayEngine) === "function"){

		this.cancelAllHideOverlayTimers();
		
		this.overlay = new loadingOverlayEngine({"name":"ajaxLoadingOverlay","target":$("body")});
	
		};
	
	}catch(e){};

};

// *******************************
// Ajax Engine: Kill Live Sessions
// *******************************
ajaxEngine.prototype.killLiveSessions = function(args){

	var killType = null;
	var killList = Array();
	
	try{

		if(typeof(args) != "undefined" && typeof(args) == "object"){
	
			if(typeof(args['killType']) != "undefined"){
			killType = args['killType'];	
			};
		
			if(typeof(args['killList']) != "undefined"){
			killList = args['killList'];	
			};
			
			if(killType == "killAll"){

			this.killAllLiveSessions();
			
			}else if(killType == "killList" && killList.length > 0){
			
			this.killListLiveSessions(killList);
				
			};

		};
	
	}catch(e){};
	
};

// ***********************************
// Ajax Engine: Kill All Live Sessions
// ***********************************
ajaxEngine.prototype.killAllLiveSessions = function(){

	try{

		for(name in ajaxObjects){
		
			try{
			ajaxObjects[name].ajaxHandle.abort();
			}catch(e){};
			
		};
	
	}catch(e){};

};

// ************************************
// Ajax Engine: Kill List Live Sessions
// ************************************
ajaxEngine.prototype.killListLiveSessions = function(killList){

	if(killList.length > 0){
	
		for(i=0;i<killList.length;i++){
	
			try{
			
			ajaxObjects[killList[i]].abort();	
			
			}catch(e){};
	
		};
	
	};

};

// *******************************************
// Ajax Engine: Cancel All Hide Overlay Timers
// *******************************************
ajaxEngine.prototype.cancelAllHideOverlayTimers = function(){

	var overlayCount = 0;

	if(loadingOverlays === null || typeof(loadingOverlays) !== "object"){
	
	return;
	
	};
	
	for(overlayName in loadingOverlays){
	
	overlayCount++;
	
	};
	
	if(overlayCount <= 0){
	
	return;
	
	};
	
	for(overlayName in loadingOverlays){
	
	loadingOverlays[overlayName].cancelHideOverlayTimer();
	
	};

};

// *********************
// Ajax Engine: Run Ajax
// *********************
ajaxEngine.prototype.runAjax = function(){
	
	var result = null;

	if(this.checkRequiredAjaxVars()){
		
	this.makeAjaxCall();

	};
	
	return result;

};

// ******************************************
// Ajax Engine: Check Required Ajax Variables
// ******************************************
ajaxEngine.prototype.checkRequiredAjaxVars = function(){
	
	var status = false;

	if(this.checkAjaxVarsMethod === 'checkAll'){
	status = this.analyzeCheckAll();
	};
	
	if(this.checkAjaxVarsMethod === 'checkForJs'){
	status = this.checkForJs();
	};
	
	if(this.checkAjaxVarsMethod === 'checkNone'){
	status = true;
	};
	
	return status;
	
};

// ***********************************
// Ajax Engine: Check Variables For JS
// ***********************************
ajaxEngine.prototype.checkForJs = function(){

	var status = false;
	var dataTypeStatus = false;
	var cacheStatus = false;
	var typeStatus = false;
	var urlStatus = false;
	var variableStringStatus = false;
	var ajaxTimeoutStatus = false;

	dataTypeStatus = this.checkDataType();
	cacheStatus = this.checkCache();
	typeStatus = this.checkType();
	urlStatus = this.checkUrl();
	variableStringStatus = this.checkVariableString();
	ajaxTimeoutStatus = this.checkTimeOut();
	
	if(dataTypeStatus == true && cacheStatus == true && typeStatus == true && urlStatus == true && variableStringStatus == false && ajaxTimeoutStatus == true){
	status = true;
	};

	return status;
	
};

// ********************************
// Ajax Engine: Check All Variables
// ********************************
ajaxEngine.prototype.analyzeCheckAll = function(){
	
	var status = false;
	var dataTypeStatus = false;
	var cacheStatus = false;
	var typeStatus = false;
	var urlStatus = false;
	var variableStringStatus = false;
	var ajaxTimeoutStatus = false;

	dataTypeStatus = this.checkDataType();
	cacheStatus = this.checkCache();
	typeStatus = this.checkType();
	urlStatus = this.checkUrl();
	variableStringStatus = this.checkVariableString();
	ajaxTimeoutStatus = this.checkTimeOut();

	if(dataTypeStatus == true && cacheStatus == true && typeStatus == true && urlStatus == true && variableStringStatus == true && ajaxTimeoutStatus == true){
	status = true;
	};

	return status;
	
};

// **************************
// Ajax Engine: Check TimeOut
// **************************
ajaxEngine.prototype.checkTimeOut = function(){

	if(this.ajaxTimeout > 0){
	return true;
	}else{
	return false;
	};	
	
};

// **********************************
// Ajax Engine: Check Variable String
// **********************************
ajaxEngine.prototype.checkVariableString = function(){

	if(this.variableString != null){
	return true;
	}else{
	return false;
	};	
	
};

// **********************
// Ajax Engine: Check URL
// **********************
ajaxEngine.prototype.checkUrl = function(){

	if(this.url != ""){
	return true;
	}else{
	return false;
	};	
	
};

// ***********************
// Ajax Engine: Check Type
// ***********************
ajaxEngine.prototype.checkType = function(){

	if(this.type == 'post' || this.type === 'get'){
	return true;
	}else{
	return false;
	};	
	
};

// ************************
// Ajax Engine: Check Cache
// ************************
ajaxEngine.prototype.checkCache = function(){

	if(this.cache == true || this.cache === false){
	return true;
	}else{
	return false;
	};	
	
};

// ****************************
// Ajax Engine: Check Data Type
// ****************************
ajaxEngine.prototype.checkDataType = function(){

	if(this.dataType === 'json' || this.dataType === 'html' || this.dataType === 'script'){
	return true;
	}else{
	return false;
	};	
	
};

// *********************************
// Ajax Engine: Show Loading Overlay
// *********************************
ajaxEngine.prototype.showLoadingOverlay = function(){

	if(this.overlay !== null){
	
	this.overlay.showOverlay();

	};

};

// *********************************
// Ajax Engine: Show Loading Overlay
// *********************************
ajaxEngine.prototype.hideLoadingOverlay = function(){

	if(this.overlay !== null){
	
	this.overlay.hideOverlay();

	};

};

// *********************
// Ajax Engine: Run Ajax
// *********************
ajaxEngine.prototype.makeAjaxCall = function(){
	
	var obj = null;
	obj = ajaxObjects[this.familyName];
	
	var data = null;
	
		if(this.formDataSwitch === true){
		
		data = this.formData;
		
		}else{
		
		data = this.variableString;
		
		};
		
	this.showLoadingOverlay();
	
	this.ajaxHandle = $.ajax({
	
	dataType: this.dataType,
	cache: this.cache,
	type: this.type,
	contentType: this.contentType,
    processData: this.processData,
	url: this.url,
	data: data,
	timeout: this.ajaxTimeout,
	
		// If Success
		success: function(msg,t,jxh){
	
			if(jxh['status'] == 200 && jxh['readyState'] == 4){

			obj.hideLoadingOverlay();
			obj.callBackFunction(msg);
			
			};
		
		},
	
		// If Error
		error: function(x,t,m){
		
			obj.hideLoadingOverlay();
		
			if(t === "timeout"){
			
			obj.callBackFunction('timeOut');
			
			}else{
			
				if(!x['abort']){
				
				obj.callBackFunction('error');
				
				}else if(x['abort']){
					
				obj.callBackFunction('abort');
					
				};
			
			};
		
		}
	
	});

};