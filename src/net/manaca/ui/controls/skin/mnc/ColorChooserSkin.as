import net.manaca.ui.controls.ColorChooser;
import net.manaca.ui.controls.skin.IColorChooserSkin;
import flash.geom.Matrix;
import net.manaca.ui.controls.TextInput;
import net.manaca.ui.controls.Panel;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.ui.awt.Graphics;
import net.manaca.ui.awt.Pen;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-26
 */
class net.manaca.ui.controls.skin.mnc.ColorChooserSkin extends AbstractSkin implements IColorChooserSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.ColorChooserSkin";
	private var _component:ColorChooser;
	private var matrix : Matrix;
	//显示选择颜色
	private var _selectedcolor_mc:MovieClip;
	//显示颜色颜色背景
	private var _selectedcolor_mc_bg : MovieClip;
	private var _panel : Panel;
	private var _input_text:TextInput;
	public function ColorChooserSkin() {
		super();
		matrix = new Matrix();
	}
	public function paint() : Void {
		this.updateParameter();
		this.drawBorder("window",_w,_h,_component.angle);
		
		matrix.createGradientBox(_w, _h,0, 0, 0);
		
		drawTitleBar(true);
		//绘制黑色颜色选择区域框
		drawFillRoundRect(createEmptyMc(_displayObject,"window_back"),_themes.window_color,1,2,_w-2,_h-3,_themes.border_corner_radius-1,_component.angle);
		drawFillRoundRect(createEmptyMc(_displayObject,"window_bottom"),0x000000,2,29,_w-4,_h-31,100);
		new Graphics(createEmptyMc(_displayObject,"window_insert_box")).drawLine(new Pen(_themes.border_color,1,100),1,27,_w-1,27);
	}
	public function paintAll() : Void {
		paint();
		//被选颜色框背景
		_selectedcolor_mc_bg = createEmptyMcByDepth(_displayObject,"_selectedcolor_mc_bg",1000);
		drawFillRoundRect(_selectedcolor_mc_bg.createEmptyMovieClip("color1",1),_themes.border_color,0,0,40,20,100);
		drawFillRoundRect(_selectedcolor_mc_bg.createEmptyMovieClip("color2",2),_themes.border_hight_color,1,1,38,18,100);
		
		//被选颜色
		_selectedcolor_mc = createEmptyMcByDepth(_displayObject,"_selectedcolor_mc",1001);
		drawFillRoundRect(_selectedcolor_mc,_themes.FocusColor,0,0,37,17,100);
		_childComponent["selectedcolor_mc"] = _selectedcolor_mc;
		
		_input_text = new TextInput(_displayObject,"input_text");
		_input_text.setSize(68,20);
		_input_text.getDisplayObject().swapDepths(1002);
		//_input_text.restrict = "-0123456789.";
		
		_panel = new Panel(_displayObject,"_panel");
		
		 adjustPlace();
	}
	//绘制窗口标题栏
	private function drawTitleBar(b:Boolean):Void{
		var tc:Number = b ? _themes.activeTitleBar_color1 : _themes.inactiveTitleBar_color1;
		var _bar_size:Number = 25;
		this.drawdrawFillRoundRectByGradient(
			createEmptyMc(_displayObject,"window_top"),
			[tc,tc,tc],
			[100,35,100],
			[0,255/2,255],
			matrix,
			1,2,_w-2,_bar_size,_themes.border_corner_radius-1,[1,1,0,0]
		);
	}
	/**
	 * 调整元素位置，一般在初始化和大小改变时执行
	 */
	private function adjustPlace(){
		_selectedcolor_mc_bg._x = 5;
		_selectedcolor_mc_bg._y = 5;
		_selectedcolor_mc._x = _selectedcolor_mc_bg._x + 2;
		_selectedcolor_mc._y = _selectedcolor_mc_bg._y + 2;
		_panel.setLocation(2,29);
		_panel.setSize(_w -4,_h-31);
		_input_text.setLocation(50,5);
	}
	
	public function getSelectedColorHoder() : MovieClip {
		return _selectedcolor_mc;
	}

	public function getPanel() : Panel {
		return _panel;
	}

	public function getInputText() : TextInput {
		return _input_text;
	}
	public function updateSize() : Void {
		paint();
		adjustPlace();
	}

	public function updateThemes() : Void {
		paint();
		updateTextFormat();
	}

	public function updateTextFormat() : Void {
		_input_text.setTextFormat(this.getControlTextFormat());
	}

	public function repaintAll() : Void {
		updateSize();
		updateThemes();
	}

	public function repaint() : Void {
		paint();
	}

}