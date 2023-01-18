import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.ui.controls.skin.IWindowSkin;
import flash.geom.Matrix;
import net.manaca.ui.controls.Panel;
import net.manaca.ui.controls.Label;
import net.manaca.ui.controls.Button;
import net.manaca.ui.awt.Graphics;
import net.manaca.ui.awt.Pen;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.skin.mnc.IconSkin;
import net.manaca.ui.controls.Window;

/**
 * Window 皮肤
 * @author Wersling
 * @version 1.0, 2006-5-15
 */
class net.manaca.ui.controls.skin.mnc.WindowSkin extends AbstractSkin implements IWindowSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.WindowSkin";
//	private var _component:Window;
	private var matrix : Matrix;
	private var _close_but:net.manaca.ui.controls.Button;
	private var _min_but:net.manaca.ui.controls.Button;
	private var _max_but:net.manaca.ui.controls.Button;
	private var _size_but : Button;
	private var _drag_but:MovieClip;
	private var _panel : Panel;
	private var _label : Label;
	public function WindowSkin() {
		super();
		matrix = new Matrix();
	}
	public function paint() : Void {
		this.updateParameter();
		this.drawBorder("window",_w,_h,[1,1,1,1]);
		
		matrix.createGradientBox(_w, _h,0, 0, 0);
		
		_drag_but = createEmptyMc(_displayObject,"window_top");
		_drag_but.tabEnabled = false;
		var _bar_size:Number = _themes.activeTitleBar_size;
		drawTitleBar(true);
		if(_h > _bar_size +2){
			drawFillRoundRect(createEmptyMc(_displayObject,"window_back"),_themes.window_color,1,2,_w-2,_h-3,_themes.border_corner_radius-1,[1,1,1,1]);
			drawBottomBar(true);
			new Graphics(createEmptyMc(_displayObject,"window_insert_box")).drawLine(new Pen(_themes.border_color,1,100),1,_bar_size+2,_w-1,_bar_size+2);
			new Graphics(createEmptyMc(_displayObject,"window_insert_box1")).drawLine(new Pen(_themes.border_color,1,100),1,_h-21,_w-1,_h-21);
			new Graphics(createEmptyMc(_displayObject,"window_insert_box2")).drawLine(new Pen(_themes.window_color,1,50),1,_h-20,_w-1,_h-20);
			
		}else{
			createEmptyMc(_displayObject,"window_back");
			createEmptyMc(_displayObject,"window_bottom");
			createEmptyMc(_displayObject,"window_insert_box");
			createEmptyMc(_displayObject,"window_insert_box1");
			createEmptyMc(_displayObject,"window_insert_box2");
		}
		
	}
	//绘制窗口标题栏
	private function drawTitleBar(b:Boolean):Void{
		var tc:Number = b ? _themes.activeTitleBar_color1 : _themes.inactiveTitleBar_color1;
		var _bar_size:Number = _themes.activeTitleBar_size;
		this.drawdrawFillRoundRectByGradient(
			createEmptyMc(_displayObject,"window_top"),
			[tc,tc,tc],
			[100,35,100],
			[0,255/2,255],
			matrix,
			1,2,_w-2,_bar_size,_themes.border_corner_radius-1,[1,1,0,0]
		);
	}
	
	//绘制窗口状态栏
	private function drawBottomBar(b:Boolean):Void{
		var tc:Number = b ? _themes.activeTitleBar_color1 : _themes.inactiveTitleBar_color1;
		this.drawdrawFillRoundRectByGradient(
				createEmptyMc(_displayObject,"window_bottom"),
				[tc,tc,tc],
				[100,35,100],
				[0,255/2,255],
				matrix,
				1,_h-21,_w-2,20,_themes.border_corner_radius-1,[0,0,1,1]
			);
	}
	
	public function paintAll() : Void {
		paint();
		//关闭按钮
		_close_but = new net.manaca.ui.controls.Button(_displayObject,"close_but");
		_close_but.setSize(18,18);
		_close_but.label = "";
		_close_but.getDisplayObject().swapDepths(1000);
		_close_but.getDisplayObject().tabEnabled = false;
		//最小化按钮
		_min_but = new net.manaca.ui.controls.Button(_displayObject,"min_but");
		_min_but.setSize(18,18);
		_min_but.label = "";
		_min_but.getDisplayObject().tabEnabled = false;
		_min_but.getDisplayObject().swapDepths(1001);
		//最大化按钮
		_max_but = new net.manaca.ui.controls.Button(_displayObject,"max_but");
		_max_but.setSize(18,18);
		_max_but.label = "";
		_max_but.getDisplayObject().tabEnabled = false;
		_max_but.getDisplayObject().swapDepths(1002);
		//调整大小按钮
		_size_but = new net.manaca.ui.controls.Button(_displayObject,"drag_but");
		_size_but.setSize(12,18);
		_size_but.label = "";
		_size_but.angle = [0,0,0,1];
		_size_but.getDisplayObject().tabEnabled = false;
		_size_but.getDisplayObject().swapDepths(1003);
		
		//存发内容元件
		_panel = new Panel(_displayObject,"_panel");
		_panel.getDisplayObject().swapDepths(1004);
		_panel.getDisplayObject().tabEnabled = false;
		//标题
		_label = new Label(_displayObject,"_label");
		_label.getDisplayObject().swapDepths(1005);
		_label.getDisplayObject().tabEnabled = false;
		
		updateSize();
		UpdateIconThemes();
		updateFocus();
	}
	
	public function updateSize() : Void {
		paint();
		updateChildComponent();
	}
	
	//绘制按钮图标
	private function UpdateIconThemes():Void{
		var _icon_skin:IconSkin = new IconSkin();
		var mc:MovieClip = _close_but.getIconPanel();
		_icon_skin.drawCloseIcon(mc,_themes.border_color,10,10);
		_close_but.repaintAll();
		
		
		var mc:MovieClip = _min_but.getIconPanel();
		_icon_skin.drawMinIcon(mc,_themes.border_color,10,10);
		_min_but.repaintAll();
		
		var mc:MovieClip = _max_but.getIconPanel();
		_icon_skin.drawMaxIcon(mc,_themes.border_color,10,10);
		_max_but.repaintAll();
	}

	public function UpdateChildComponent() : Void {
    	_close_but.setLocation(_w-17-4,3);
		_max_but.setLocation(_w-17*2-4,3);
		_min_but.setLocation(_w-17*3-4,3);
		_drag_but.setLocation(_w-16,_h-19);
		
		_panel.setLocation(1,23);
		_panel.setSize(_w-2,_h-44);
		_label.setLocation(5,3);
		_label.setSize(_w-60,22);
	}
	
	public function updateFocus(f : Boolean) : Void {
		if(f){
			_label.setTextFormat(this.getActiveTitleBarTextFormat());
//			drawTitleBar(true);
//			drawBottomBar(true);
		}else{
			_label.setTextFormat(this.getInactiveTitleBarTextFormat());
//			drawTitleBar(false);
//			drawBottomBar(false);
		}
		
		
	}
	
	public function updateChildComponent() : Void {
		var _top_size =  _themes.activeTitleBar_size;
		_close_but.setLocation(_w-17-4,int((_top_size-18)/2)+2);
		_max_but.setLocation(_w-17*2-4,int((_top_size-18)/2)+2);
		_min_but.setLocation(_w-17*3-4,int((_top_size-18)/2)+2);
		
		_size_but.setLocation(_w-16,_h-19);
		
		_panel.setLocation(1,_top_size+3);
		_panel.setSize(getUsableArea().getWidth(),getUsableArea().getHeight());
		_label.setLocation(5,int((_top_size-20)/2)+2);
		_label.setSize(_w-60,20);
	}

	public function updateThemes() : Void {
		paint();
	}

	public function updateTextFormat() : Void {
		_label.setTextFormat(this.getActiveTitleBarTextFormat());
	}

	public function repaintAll() : Void {
		paint();
	}

	public function repaint() : Void {
		paint();
	}

	public function getUsableArea() : Dimension {
		return new Dimension(_w-2,_h-20-4-_themes.activeTitleBar_size);
	}
	
	public function getMinimumSize() : Dimension {
		return new Dimension(120,_themes.activeTitleBar_size+2);
	}

	public function getCloseButton() : Button {
		return _close_but;
	}

	public function getMinButton() : Button {
		return _min_but;
	}

	public function getMaxButton() : Button {
		return _max_but;
	}

	public function getSizeButton() : Button {
		return _size_but;
	}

	public function getDragButton() : MovieClip {
		return _drag_but;
	}

	public function getPanel() : Panel {
		return _panel;
	}

	public function getLabel() : Label {
		return _label;
	}

	public function getBack() : MovieClip {
		return _displayObject["border"];
	}

}