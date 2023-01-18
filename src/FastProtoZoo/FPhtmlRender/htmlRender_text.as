//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
import FastProtoZoo.FPhtmlRender.htmlRender_htmlFix;
//
class FastProtoZoo.FPhtmlRender.htmlRender_text extends MovieClip{
	//############ ATTACH ON THE FLY ###############################################
	static var symbolName:String = "__Packages.FastProtoZoo.FPhtmlRender.htmlRender_text";
	static var symbolOwner:Function = FastProtoZoo.FPhtmlRender.htmlRender_text;
	static var symbolLinked:Object = Object.registerClass(symbolName, symbolOwner);
	//############ ATTACH ON THE FLY ###############################################
	private var texto:TextField;
	private var h,w:Number;
	private var struct:Array;
	private var mother:Object;
	//
	function htmlRender_text(){
		//modify structure
		var temptext=this.struct.toString();
		//manipulate tags
		if (this.mother.useFix){
			temptext=htmlRender_htmlFix.fix(temptext);
		}
		//check height
		if (this.h == undefined) {
			this.h = 10;
		}
		this.createTextField("texto", 1, 0, 0, this.w, this.h);
		this.texto.html = true;
		this.texto.multiline = true;
		this.texto.wordWrap = true;
		this.texto.condenseWhite = true;
		//check if embeded prop is declared
		var sindex=temptext.indexOf("class=");
		var tempstring=temptext.substr(sindex,temptext.length);
		var temp=new Array();
		temp=tempstring.split('"');
		var classname=temp[1];
		//
		if (this.mother.style._css["."+classname].embeded=="true"){
			this.texto.embedFonts=true;
		}
		//set the style sheet
		this.texto.styleSheet = this.mother.style;
		//fix the child issue
		this.texto.htmlText = temptext;
		this.texto.selectable = false;
		//check and set
		if (this.texto.textHeight+4>this.h) {
			this.texto._height = this.texto.textHeight+4;
			//recheck for jumping text bug
			var bugfix=this.texto.textHeight;
			while(this.texto.maxscroll>1) {
				this.texto._height+=2;
				//BUG!!! do not remove this trace!!!! loop will continue at infinite
				bugfix=this.texto.textHeight;
			}
		}
	}
	//callback function <A HREF="asfunction:htmlToFlash,1">Click Me!</A>
	private function HTF(param:String):Void {
		this.mother.HTFcallBack(param);
	}
	//set new box dimension
	public function setDim(w:Number,h:Number):Void{
		this.texto._width=w;
		//do not change h
	}
}
