import flash.geom.Matrix;

import net.manaca.ui.awt.GradientBrush;
import net.manaca.ui.awt.Graphics;
import net.manaca.ui.controls.skin.IButtonSkin;
import net.manaca.ui.controls.skin.Skin;
import net.manaca.ui.controls.themes.Themes;
import net.manaca.ui.controls.UIComponent;

/**
 * 按钮
 * @author Wersling
 * @version 1.0, 2006-5-11
 */
class net.manaca.ui.controls.skin.halo.ButtonSkin extends Skin implements IButtonSkin{
	private var className : String = "net.manaca.ui.controls.skin.halo.ButtonSkin";
	private var _gradientBrush : GradientBrush;
	private var _w : Number;
	private var _h : Number;
	private var _themes : Themes;
	private var _component:net.manaca.ui.controls.Button;
	private var matrix : Matrix;
	private var _cornerRadius : Number;

	private var _angle : Array;

	private var _childComponent : Object;
	
	public function ButtonSkin() {
		super();
		var fillType:String = "linear";
		var colors = [];
		var alphas = [100, 100,100,100];
		var ratios = [0, 255];
		var spreadMethod = "reflect";
		var interpolationMethod = "linearRGB";
		var focalPointRatio = 1;
		matrix = new Matrix();
		_gradientBrush = new GradientBrush(fillType, colors, alphas, ratios, matrix, 
        spreadMethod, interpolationMethod, focalPointRatio);
        
        _childComponent = new Object();
		
	}
	
	public function updateDisplay(name : String) : Void {
		_w = _component.getSize().getWidth();
		_h = _component.getSize().getHeight();
		matrix.createGradientBox(_w, _h,270 * Math.PI/180, 0, 0);
		_themes = _component.getThemes();
		_angle = _component.angle;
		_cornerRadius = _themes.cornerRadius;
		if(_cornerRadius > _h/2) _cornerRadius = _h/2;
		switch (name) {
			case "TextFormat":
		        UpdateChildComponent();
		        break;
		    case "upSkin":
		    	onUp();
		        break;
		    case "overSkin":
		    	onOver();
		        break;
			case "selectedSkin":
				MovieClip(this.getElement("SelectedSkin"))._alpha = 50;
				break;
			case "unselectedSkin":
				MovieClip(this.getElement("SelectedSkin"))._alpha = 0;
				break;
		    case "downSkin":
		    	onDown();
		        break;
		    case "disabledSkin":
		   		break;
		    default:
		    	//for(var i in _displayObject) _displayObject[i].clear();
				ControlBorder();
				Control();
				SelectedSkin();
				UpdateChildComponent();
				if(_component.selected) updateDisplay("selectedSkin");
					else updateDisplay("unselectedSkin");
				break;
		}
		
	}
	private function drawFillRoundRect(mc:MovieClip,color:Array,alphas:Array,ratios:Array, x:Number, y:Number, width:Number, height:Number,cr:Number):Void{
		var _g:Graphics = new Graphics(mc);
		_gradientBrush.setColors(color);
		_gradientBrush.setAlphas(alphas);
		_gradientBrush.setRatios(ratios);
		var a1 = _cornerRadius - cr>0 ? _cornerRadius-cr : 0;
		_g.fillRoundRect(_gradientBrush,x,y,width,height,_angle[0] ? a1:0 ,_angle[1] ? a1:0,_angle[2] ? a1:0,_angle[3] ? a1:0);
	}
	//控件边框
	private function ControlBorder():Void{
		drawFillRoundRect(createEmptyMc("ControlBorder"),
				_themes.haloControlBorder,
				_themes.haloControlBorderAlphas,
				_themes.haloControlBorderRatios,
				0,0,_w,_h,0
				);

	}
	//控件表面
	private function Control():Void{
		drawFillRoundRect(createEmptyMc("Control"),
				_themes.haloControl,
				_themes.haloControlAlphas,
				_themes.haloControlRatios,
				1,1,_w-2,_h-2,1
				);

	}
	
	//控件被选择
	private function SelectedSkin():Void{
		drawFillRoundRect(createEmptyMc("SelectedSkin"),
				[_themes.FocusColor,_themes.FocusColor],
				[100,100],
				[0,255],
				0,0,_w,_h,0
				);
	}
	
	private function onUp():Void{
		ControlBorder();
		Control();
	}
	
	private function onOver():Void{
		drawFillRoundRect(createEmptyMc("ControlBorder"),
				_themes.haloControlBorderOverAndDown,
				_themes.haloControlBorderAlphas,
				_themes.haloControlBorderRatios,
				0,0,_w,_h,0
				);

		drawFillRoundRect(createEmptyMc("Control"),
				_themes.haloControlOver,
				_themes.haloControlAlphas,
				_themes.haloControlRatios,
				1,1,_w-2,_h-2,1
				);

	}
	
	private function onDown():Void{
		drawFillRoundRect(createEmptyMc("ControlBorder"),
				_themes.haloControlBorderOverAndDown,
				_themes.haloControlBorderAlphas,
				_themes.haloControlBorderRatios,
				0,0,_w,_h,0
				);

		drawFillRoundRect(createEmptyMc("Control"),
				_themes.haloControlDown,
				_themes.haloControlAlphas,
				_themes.haloControlRatios,
				1,1,_w-2,_h-2,1
				);

	}
	public function createChildComponent(o : net.manaca.ui.controls.Button) : Void {
		_childComponent["icon"] = _displayObject.createEmptyMovieClip("Icon",getDepth("Icon"));
		_childComponent["label"] = _displayObject.createTextField("Label", getDepth("Label"), 3, 2, 0, 0);
	}

	public function UpdateChildComponent(o : net.manaca.ui.controls.Button) : Void {
		var minx:Number = 4;
		var miny:Number = 4;
		var manw:Number = _w - minx*2;
		var manh:Number = _h - miny*2+1;;
		var f:TextField = TextField(this.getElement("Label"));
		var icon:MovieClip = MovieClip(this.getElement("Icon"));
		f.setTextFormat(_component.getTextFormat());
		
		f.autoSize = true;
		var fw = f._width;
		var fh = f._height;
		var iw = icon._width;
		var ih = icon._height;
		f.autoSize = false;
		
		if(iw > 0 && ih >0 && fw >4){
			icon._x = Math.max((int((manw-(fw+iw))/2))+minx,minx);
			f._x = int(icon._x + iw);
		}else if(iw > 0 && ih >0){
			icon._x = Math.max((int((manw-iw)/2))+minx,minx);
			
		}else{
			f._width = Math.min(manw,fw);
			f._x =  Math.max((int((manw-fw)/2))+minx,minx);
		}
		f._y =  Math.max((int((manh-fh)/2))+miny,miny-2);
		icon._y = Math.max((int((manh-ih)/2))+miny,miny);
	}

	public function getChildComponent(name : String) : Object {
		return _childComponent[name];
	}

	public function getIconHolder() : MovieClip {
		return null;
	}

	public function getTextHolder() : TextField {
		return null;
	}

	public function onOut() : Void {
	}

	public function setSelected(n : Boolean) : Void {
	}

	public function updateChildComponent() : Void {
	}

	public function initialize(c : UIComponent) : Void {
	}

	public function paint() : Void {
	}

	public function paintAll() : Void {
	}

	public function updateSize() : Void {
	}

	public function updateThemes() : Void {
	}

	public function updateTextFormat() : Void {
	}

	public function destroy() : Void {
	}

	public function repaintAll() : Void {
	}

	public function repaint() : Void {
	}

}