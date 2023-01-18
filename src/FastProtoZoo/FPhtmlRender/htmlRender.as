//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
import FastProtoZoo.FPlib.FP_XMLutil;
import FastProtoZoo.FPlib.FP_LoadVarsutil;
import FastProtoZoo.FPlib.FP_CSSutil;
import FastProtoZoo.FPtoolTip.toolTipManager;
import FastProtoZoo.FPhtmlRender.*;
//
class FastProtoZoo.FPhtmlRender.htmlRender extends MovieClip {
	//############ ATTACH ON THE FLY ###############################################
	static var symbolName:String = "__Packages.FastProtoZoo.FPhtmlRender.htmlRender";
	static var symbolOwner:Function = FastProtoZoo.FPhtmlRender.htmlRender;
	static var symbolLinked:Object = Object.registerClass(symbolName, symbolOwner);
	//############ ATTACH ON THE FLY ###############################################
	private var style:TextField.StyleSheet;
	private var struct:FP_XMLutil;
	private var cssStyle:String;
	private var cssStyles:Array;
	private var stage:MovieClip;
	private var xmldocument:XML;
	private var pagetitle,cssName, pageparameters:String;
	private var callback, errcallback, HTFcallback, currentpage:String;
	private var target_mc, HTFtarget_mc:Object;
	private var useFix:Boolean;
	private var w,h,fusionCounter:Number;
	private var respath:String;
	///
	function htmlRender() {
		//init tooltip
		toolTipManager.init(1000);
		//set to off fix
		this.useFix=false;
		//callback
		this.callback = "";
		trace("[FPXHTMLRENDER::init]");
		//attach the layout
		this.attachMovie(htmlRender_layout.symbolName, "stage", 10,{mother:this});
		//init page parameters
		this.pageparameters=undefined;
		this.respath="";
	}
	//###########
	public function parseFile(file:String):Void {
		trace("[FPXHTMLRENDER::loadfile("+file+")]");
		//load page
		delete (this.struct);
		this.struct = new FP_XMLutil(this, "preparse", "errorPage");
		this.struct.load(this.respath+""+file);
		this.currentpage=file;
	}
	//##############
	public function preparse(structure:XML):Void {
		trace("[FPXHTMLRENDER::parse&render_XHTML_page]");
		//store the structure
		this.xmldocument = structure;
		//
		var doc = new Array();
		doc = this.xmldocument.childNodes;
		//check idf html exist
		var found=false;

		//search
		for (var k = 0; k<doc.length; k++) {
			//delete css container
			delete this.cssStyles;
			delete this.cssStyle;
			this.cssStyles=new Array();
			//used to check is all css are loaded
			this.fusionCounter=0;
			//css link and header information
			if (doc[k].nodeName == "html") {
				//store parameters if exist
				if (doc[k].attributes.parameters!=undefined){
					this.pageparameters=doc[k].attributes.parameters;
				}
				//find link css
				var docin = new Array();
				docin = doc[k].childNodes[0].childNodes;
				//
				for (var k = 0; k<docin.length; k++) {
					switch ((docin[k].nodeName).toLowerCase()) {
					case "link" :
						//*********multiple css
						var stylesheet = docin[k].attributes.href;
						//
						trace("[FPXHTMLRENDER::load_css]:"+stylesheet);
						var tempcss:FP_CSSutil=new FP_CSSutil(this, "fuser", "errorCss");
						this.cssStyles.push(tempcss);
						this.cssStyles[this.cssStyles.length-1].load(this.respath+""+stylesheet);
						break;
					case "title" :
						this.pagetitle = docin[k].childNodes;
						break;
					}
				}
				//
				found=true;
				//
				break;
			}
		}
		//chech if the stylesheet name is different
		if (this.cssStyles.length==0){
			//parse doc
			this.parseDoc();
		}
	}
	//check if all css are loaded
	private function fuser(style:TextField.StyleSheet):Void{
		this.fusionCounter++;
		//
		if (this.cssStyles.length==this.fusionCounter){
			//create a temp CSS and parse doc in it
			this.style=new TextField.StyleSheet();
			//*******fuser
			var temp=new htmlRender_cssFuser();
			this.style=temp.doFusion(this.cssStyles);
			//call the render
			this.parseDoc();
		}
	}
	//parse html
	private function parseDoc():Void {
		//call function to layout and passing the xml
		this.stage.render(this.xmldocument);
		//callbackRendering ended
		this.callBack();
	}
	//callBack
	public function setCallback(reference:Object, callback:String, errorcallback:String):Void {
		this.callback = callback;
		this.errcallback = errorcallback;
		this.target_mc = reference;
	}
	//callBack
	public function setHTFCallback(reference:Object, callback:String):Void {
		this.HTFcallback = callback;
		this.HTFtarget_mc = reference;
	}
	//execute callBack
	private function callBack():Void {
		trace("[FPXHTMLRENDER::page_rendered]");
		//
		if (this.callback != undefined) {
			this.target_mc[this.callback](this.pageparameters);
		}
	}
	//HTF callback execution
	private function HTFcallBack(value:String):Void {
		trace("[FPXHTMLRENDER::HTF_callBack: "+value+"]");
		//
		if (this.HTFcallback != undefined) {
			this.HTFtarget_mc[this.HTFcallback](value);
		}
	}
	//errors
	private function errorCss(src:String):Void{
		trace("[FPXHTMLRENDER::CSS_loading_error]:"+src);
		//load page
		this.errorPage(-20,src);
	}
	private function errorPage(err:Number,details:String):Void{
		//error
		var errorname="";
		switch (err){
			case -2:
				errorname="CDATA error";
			break;
			case -3:
				errorname="XML declaration error";
			break;
			case -4:
				errorname="DOCTYPE error";
			break;
			case -5:
				errorname="comment error";
			break;
			case -6:
				errorname="element error";
			break;
			case -7:
				errorname="out of memory";
			break;
			case -8:
				errorname="attribute_error";
			break;
			case -9:
				errorname="start-tag was not matched with an end-tag";
			break;
			case -10:
				errorname="end-tag was encountered without a matching start-tag";
			break;
			case -20:
				errorname="CSS error :"+details;
			break;
			default:
				errorname="page not found";
				err=404;
		}
		//
		trace("[FPXHTMLRENDER::Page_error: "+errorname+"]");
		this.stage.reset();
		//throw error
		if (this.errcallback != undefined) {
			this.target_mc[this.errcallback](errorname);
		}
	}
	//return page title
	public function getTitle():String {
		return (this.pagetitle);
	}
	//return page url
	public function getPage():String {
		return (this.respath+""+this.currentpage);
	}
	//return page parameters
	public function getParams():String {
		return (this.pageparameters);
	}
	//use text fix useful for pages written
	public function set useHTMLFix(val:Boolean):Void{
		this.useFix=val;
	}
	//
	public function get useHTMLFix():Boolean{
		return(this.useFix);
	}
	//pilot layers
	public function setLayerStyle(id:String,style:Object):Void{
		this.stage.setLayerStyle(id,style);
	}
	//set width and height
	public function setDims(w:Number,h:Number):Void{
		this.stage.setDims(w,h);
	}
	//return resources path
	public function getPath():String{
		return this.respath;
	}
	//set resources path
	public function setPath(ph:String):Void{
		this.respath=ph;
	}
}
