//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
import FastProtoZoo.FPlib.FP_drawPrimitives;
//
class FastProtoZoo.FPtoolTip.toolTip extends MovieClip{
	//############ ATTACH ON THE FLY ###############################################
	static var symbolName:String = "__Packages.FastProtoZoo.FPtoolTip.toolTip";
	static var symbolOwner:Function = FastProtoZoo.FPtoolTip.toolTip;
	static var symbolLinked:Object = Object.registerClass(symbolName, symbolOwner);
	//############ ATTACH ON THE FLY ###############################################
	//vars
	private var fader,fadertime,deltax,deltay:Number;
	private var current:String;
	private var tipShadow:FP_drawPrimitives;
	private var base:MovieClip;
	private var tipLabel:TextField;
	private var style:TextField.StyleSheet;
	private var block:Boolean;
	//vars
	function toolTip(){
		//set style
		this.style=new TextField.StyleSheet();
		this.style=undefined;
		//block style changes
		this.block=false;
		//fader time
		if (fadertime!=undefined){
			this.fadertime=fadertime;
		}else{
			this.fadertime=1000;
		}
		//delta
		this.deltax=15;
		this.deltay=3;
		//
		this.current="";
		//
		this.createEmptyMovieClip("base",1);
		this.base._x=3;
		this.base._y=3;
		this.tipShadow=new FP_drawPrimitives(this.base);
		//
		this.createTextField("tipLabel",2,0,0,10,12);
		//
		this.tipLabel.autoSize="left";
		this.tipLabel.html=true;
		this.tipLabel.multiline=true;
		this.tipLabel.background=true;
		this.tipLabel.backgroundColor=0xffcc00;
		this.tipLabel.selectable=false;
		//hide
		this.hideTip();
	}
	//
	public function showTip(message:String):Void{
		//check if is a differnt one
		this.current=message;
		this.hideTip();
		//init fader
		clearInterval(this.fader);
		this.fader=setInterval(this,"show",this.fadertime);
	}
	//apply format
	private function show():Void{
		//stop fader
		clearInterval(this.fader);
		//set style
		if (this.style["_css"].alt!=undefined){
			//Set if font is embedded
			if (this.style["_css"].alt.embeded=="true"){
				this.tipLabel.embedFonts=true;
			}else{
				this.tipLabel.embedFonts=false;
			}
			//
			this.tipLabel.styleSheet=this.style;
			this.tipLabel.htmlText="<p><alt>"+this.current+"</alt></p>";
		}else{
			this.tipLabel.htmlText="<p><font face='arial' size='11'>"+this.current+"</font></p>";
		}
		//adjust shadow
		this.tipShadow.clear();
		this.tipShadow.drawSquare(0,0,this.tipLabel.textWidth+3,this.tipLabel.textHeight+3,0x000000,30,0,0x000000,0);
		//show
		this._x=_root._xmouse+this.deltax;
		this._y=_root._ymouse-(this.tipLabel.textHeight+3+this.deltay);
		//check if the label is inside the stage else move it
		if ((this._x+this.tipLabel.textWidth+3+this.deltax)>Stage.width){
			this._x-=(this.tipLabel.textWidth+3+(2*this.deltax));
		}
		//
		if ((this._y)<0){
			this._y+=(this.tipLabel.textHeight+3+(2*this.deltay));
		}
		//
		this._visible=true;
	}
	//
	public function hideTip():Void{
		this._visible=false;
		//stop fader
		clearInterval(this.fader);
	}
	//set style
	public function setStyle(style:TextField.StyleSheet):Void{
		if (!this.block){
			//set style
			this.style=style;
		}
	}
	//set block
	public function setStyleBlock(block:Boolean):Void{
		this.block=block;
	}
	public function getStyleBlock():Boolean{
		return(this.block);
	}
}