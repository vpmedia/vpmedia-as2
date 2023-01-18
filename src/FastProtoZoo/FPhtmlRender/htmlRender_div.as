//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
import FastProtoZoo.FPlib.FP_imageLoader;
import FastProtoZoo.FPhtmlRender.*;
//
class FastProtoZoo.FPhtmlRender.htmlRender_div extends MovieClip {
	//############ ATTACH ON THE FLY ###############################################
	static var symbolName:String = "__Packages.FastProtoZoo.FPhtmlRender.htmlRender_div";
	static var symbolOwner:Function = FastProtoZoo.FPhtmlRender.htmlRender_div;
	static var symbolLinked:Object = Object.registerClass(symbolName, symbolOwner);
	//############ ATTACH ON THE FLY ###############################################
	private var struct:Array;
	private var loader:FP_imageLoader;
	private var counter:Number;
	private var bg:MovieClip;
	private var mother:Object;
	//
	function htmlRender_div() {
		this.counter = 0;
		//create an instance of the class
		this.loader = new FP_imageLoader (this.bg);
		//set current style passed
		//extract x,y coordinates
		var extracted=new Array();
		extracted=this.struct.attributes.style.split(';');
		for (var w=0;w<extracted.length;w++){
			if (extracted[w].indexOf("top")!=-1){
				var tempa=extracted[w].split(':');
				this._y=Number(tempb[0]);
			}else if (extracted[w].indexOf("left")!=-1){
				var tempa=extracted[w].split(':');
				var tempb=tempa[1].split('px');
				this._x=Number(tempb[0]);
			}else if (extracted[w].indexOf("visibility")!=-1){
				var tempa=extracted[w].split(':');
				//set visibility status
				if (tempa[1].toLowerCase().indexOf("hidden")!=-1){
					this._visible=false;
				}
			}
		}
		//parse
		var b:Array = new Array ();
		b = this.struct.childNodes;
		//relative y position
		var relh=0;
		//iterate
		for (var j = 0; j < b.length; j++) {
			//attach elements
			if (b[j].nodeName.toLowerCase()== "table") {
				var init = new Object ();
				init.struct = new Array();
				init.struct = b[j];
				init.mother=this.mother;
				init._y=relh;
				//attach element
				this.attachMovie (htmlRender_table.symbolName, "t" + this.counter, this.counter, init);
				//store h and add 2 px spacer
				relh=Math.round(this["t"+this.counter]._height);
				//
				this.counter++;
			}
		}
	}
	//set style at runtime
	public function setStyle(style:Object):Void{
		for (var i in style){
			//dispatch supported props
			switch (i){
				case "visibility":
					if (style[i]){
						this._visible=true;
					}else{
						this._visible=false;
					}
				break;
				case "top":
					this._y=Math.round(style[i]);
				break;
				case "left":
					this._x=Math.round(style[i]);
				break;
					case "rotation":
					this._rotation=Math.round(style[i]);
				break;
			}
		}
	}
}
