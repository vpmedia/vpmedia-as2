//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
import FastProtoZoo.FPlib.FP_imageLoader;
import FastProtoZoo.FPhtmlRender.htmlRender_cssExtractor;
import FastProtoZoo.FPtoolTip.toolTipManager;
import FastProtoZoo.FPlib.FP_drawPrimitives;
//
class FastProtoZoo.FPhtmlRender.htmlRender_img extends MovieClip{
	//############ ATTACH ON THE FLY ###############################################
	static var symbolName:String = "__Packages.FastProtoZoo.FPhtmlRender.htmlRender_img";
	static var symbolOwner:Function = FastProtoZoo.FPhtmlRender.htmlRender_img;
	static var symbolLinked:Object = Object.registerClass(symbolName, symbolOwner);
	//############ ATTACH ON THE FLY ###############################################
	private var img, border:MovieClip;
	private var struct:Array;
	private var loader:FP_imageLoader;
	private var w,h:Number;
	private var mother:Object;
	private var cssExtractor:htmlRender_cssExtractor;
	//
	function htmlRender_img(){
		//apply offset (left-top align default)
		this._x=this._y=this.mother.offset;
		//cssExtractor
		this.cssExtractor = new htmlRender_cssExtractor(this.mother.style);
		//
		this.createEmptyMovieClip("img", 1);
		//override image attributes from css
		//css tag
		var extracted=this.cssExtractor.getCSSItem("img",this.struct);
		//css class
		var extracted=this.cssExtractor.getCSSItem("."+this.struct.attributes["class"],this.struct);
		//css class
		var extracted=this.cssExtractor.getCSSItem("#"+this.struct.attributes["id"],this.struct);
		//conversions
		if (this.struct.attributes.bordercolor!=undefined){
			this.struct.attributes.bordercolor=Number("0x"+(this.struct.attributes.bordercolor).substr(1, 7));
		}else{
			this.struct.attributes.bordercolor=0x333333;
		}
		if (this.struct.attributes.bgcolor!=undefined){
			this.struct.attributes.bgcolor=Number("0x"+(this.struct.attributes.bordercolor).substr(1, 7));
		}else{
			this.struct.attributes.bgcolor=0xE9E9E9;
		}
		//draw border if exist
		var drawer=new FP_drawPrimitives(this);
		drawer.drawSquare(0, 0, Number(this.struct.attributes.width), Number(this.struct.attributes.height), this.struct.attributes.bgcolor, 100, this.struct.attributes.border, this.struct.attributes.bordercolor, 100, this.struct.attributes.style);
		//--------------------------------loader
		this.loader = new FP_imageLoader(this.img);
		if (Number(this.struct.attributes.width)>100){
			this.loader.viewLoader(this.struct.attributes.bordercolor, 10, 10, 30, "loading...");
		}
		this.loader.setCallback(this,"clearImageBack");
		//load res
		this.loader.loadClip(this.mother.getPath()+""+this.struct.attributes.src);
	}
	//clearImageBack
	private function clearImageBack():Void{
		this.img.clear();
	}
	//tooltips
	private function onRollOver():Void{
		if (this.struct.attributes.alt!=undefined && this.struct.attributes.alt!=""){
			//set also the css props
			//var extracted={_css:{alt:this.mother.style._css["alt"]},_styles:{alt:this.mother.style._styles["alt"]}};
			//set tooltip style
			toolTipManager.setStyle(this.mother.style);
			toolTipManager.showTip(this.struct.attributes.alt);
		}
	}
	//
	private function onRollOut():Void{
		toolTipManager.hideTip();
	}
	private function onReleaseOutside():Void{
		toolTipManager.hideTip();
	}
}
