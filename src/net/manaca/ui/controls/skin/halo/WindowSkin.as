import net.manaca.ui.controls.skin.IWindowSkin;
import net.manaca.ui.controls.skin.Skin;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.themes.Themes;
import net.manaca.ui.awt.Graphics;
import net.manaca.ui.awt.SolidBrush;
import flash.geom.Matrix;
import net.manaca.ui.awt.GradientBrush;
import net.manaca.ui.controls.Panel;
import net.manaca.ui.controls.Label;
import net.manaca.ui.awt.Dimension;

/**
 * Window 皮肤
 * @author Wersling
 * @version 1.0, 2006-5-15
 */
class net.manaca.ui.controls.skin.halo.WindowSkin extends Skin implements IWindowSkin {
	private var className : String = "net.manaca.ui.controls.skin.halo.WindowSkin";
	private var _w : Number;
	private var _h : Number;
	private var _themes : Themes;
	private var _cornerRadius : Object;
	private var matrix : Matrix;
	private var _solidBrush : SolidBrush;
	private var _gradientBrush : GradientBrush;
	public function WindowSkin() {
		super();
		_solidBrush = new SolidBrush();
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
	}

	public function updateDisplay(name : String) : Void {
		_w = _component.getSize().getWidth();
		_h = _component.getSize().getHeight();
		_themes = _component.getThemes();
		_cornerRadius = _themes.cornerRadius;
		matrix.createGradientBox(_w, _h,0, 0, 0);
		switch (name) {
		    case "disabledSkin":
		   		break;
		    default:
		    	drawFillRoundRect(createEmptyMc("ControlBorder"),_themes.ControlBorder,0,0,_w,_h,0);
		    	drawFillRoundRect(createEmptyMc("ControlHighLight"),_themes.ControlHighLight,1,1,_w-2,_h-2,1);
		    	
		    	drawFillRoundRect2(createEmptyMc("WindowTop"),
					_themes.haloWindowTop,
					_themes.haloWindowTopAlphas,
					_themes.haloWindowTopRatios,
					1,2,_w-2,20,2,[1,1,0,0]
				);
		    	drawFillRoundRect2(createEmptyMc("WindowBottom"),
					_themes.haloWindowBottom,
					_themes.haloWindowBottomAlphas,
					_themes.haloWindowBottomRatios,
					1,_h-21,_w-2,20,2,[0,0,1,1]
				);
//				ControlBorder();
//				Control();
//				SelectedSkin();
//				Label();
//				Icon();
//				updataLableAndIcon();
				break;
		}
	}
	private function drawFillRoundRect(mc:MovieClip,color:Number, x:Number, y:Number, width:Number, height:Number,cr:Number):Void{
		var _g:Graphics = new Graphics(mc);
		_solidBrush.setColor(color);
		var a1 = _cornerRadius - cr>0 ? _cornerRadius-cr : 0;
		_g.fillRoundRect(_solidBrush,x,y,width,height,a1,a1,a1,a1);
		new Color(mc).setRGB(color);
	}
	
	private function drawFillRoundRect2(mc:MovieClip,color:Array,alphas:Array,ratios:Array, x:Number, y:Number, width:Number, height:Number,cr:Number,_angle:Array):Void{
		var _g:Graphics = new Graphics(mc);
		_gradientBrush.setColors(color);
		_gradientBrush.setAlphas(alphas);
		_gradientBrush.setRatios(ratios);
		var a1 = _cornerRadius - cr>0 ? _cornerRadius-cr : 0;
		_g.fillRoundRect(_gradientBrush,x,y,width,height,_angle[0] ? a1:0 ,_angle[1] ? a1:0,_angle[2] ? a1:0,_angle[3] ? a1:0);
	}
	public function getCloseButton() : net.manaca.ui.controls.Button {
		return null;
	}

	public function getMinButton() : net.manaca.ui.controls.Button {
		return null;
	}

	public function getMaxButton() : net.manaca.ui.controls.Button {
		return null;
	}

	public function getSizeButton() : net.manaca.ui.controls.Button {
		return null;
	}

	public function getDragButton() : MovieClip {
		return null;
	}

	public function getPanel() : Panel {
		return null;
	}

	public function getLabel() : Label {
		return null;
	}

	public function getUsableArea() : Dimension {
		return null;
	}

	public function getMinimumSize() : Dimension {
		return null;
	}

	public function updateChildComponent() : Void {
	}

	public function updateFocus(f : Boolean) : Void {
	}

	public function getBack() : MovieClip {
		return null;
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