//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
import FastProtoZoo.FPlib.FP_drawPrimitives;
//
class FastProtoZoo.FPhtmlRender.htmlRender_errorFrame extends MovieClip{
 	//############ ATTACH ON THE FLY ###############################################
	static var symbolName:String = "__Packages.FastProtoZoo.FPhtmlRender.htmlRender_errorFrame";
	static var symbolOwner:Function = FastProtoZoo.FPhtmlRender.htmlRender_errorFrame;
	static var symbolLinked:Object = Object.registerClass(symbolName, symbolOwner);
	//############ ATTACH ON THE FLY ###############################################
	private var texto:TextField;
	private var x:Number=150;
	private var y:Number=50;
	//
	function htmlRender_errorFrame(){
		//
		this.createTextField("texto",2,0,0,x,y);
		this.texto.html = true;
		this.texto.multiline = true;
		this.texto.wordWrap = true;
		this.texto.condenseWhite = true;
		//
		var drawer=new FP_drawPrimitives(this);
		drawer.drawSquare(2, 2, x, y, 0xaaaaaa, 100, 0, 0xe7e7e7, 0);
		drawer.drawSquare(0, 0, x, y, 0xe7e7e7, 100, 0, 0xe7e7e7, 0);
		//
		this.hide();
	}
	//
	public function setText(texto:String):Void{
		this.texto.htmlText="<p align='center'><font size='9' face='Verdana,Arial'><b>ERROR</b><br/>"+texto+"</font></p>";
		this.show();
	}
	//
	public function show():Void{
		this._visible=true;
	}
	public function hide():Void{
		this._visible=false;
	}
	public function center(x:Number,y:Number):Void{
		this._x=x-Math.round(this.x/2);
		this._y=y-Math.round(this.y/2);
	}
}