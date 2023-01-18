import net.manaca.lang.BObject;
import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.awt.Graphics;
import net.manaca.ui.awt.SolidBrush;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.controls.themes.Themes;
import flash.geom.Matrix;
import net.manaca.ui.awt.GradientBrush;

/**
 * AbstractSkin 提供对 mnc 皮肤对象的基本绘制方法
 * @author Wersling
 * @version 1.0, 2006-5-30
 */
class net.manaca.ui.controls.skin.mnc.AbstractSkin extends BObject{
	private var className : String = "net.manaca.ui.controls.skin.mnc.AbstractSkin";
	private static var _DepthManager : Object;
	private var _component : UIComponent;
	private var _displayObject : MovieClip;
	private var _childComponent : Object;
	private var _solidBrush : SolidBrush;
	private var _gradientBrush : GradientBrush;
	private var _w : Number;
	private var _h : Number;
	private var _themes : Themes;
	private function AbstractSkin() {
		super();
		_solidBrush = new SolidBrush();
		_gradientBrush = new GradientBrush("linear", [], [], [], null, 
        "reflect", "linearRGB", 1);
		_childComponent = new Object();
	}
	/**
	 * 初始化对象，需要传递一个
	 * @param c:UIComponent - 指示一个组件对象
	 */
	public function initialize(c : UIComponent) : Void {
		if(c !=undefined) {
			_component = c;
			_displayObject = c.getDisplayObject();
		}else{
			throw new IllegalArgumentException("缺少必要参数",this,arguments);
		}
	}
	public function updateParameter():Void{
		_w = _component.getSize().getWidth();
		_h = _component.getSize().getHeight();
		_themes = _component.getThemes();
	}
	public function destroy() : Void {
		var _mc:MovieClip = _displayObject;
		for(var i in _mc){
			if(_mc[i].getDepth() < 100){
				_mc[i].removeMovieClip();
			}
		}
	}
	/**
	 * 绘制一个边框
	 * @param type:String - 有以下几种样式：
	 * <li>none：没有边框</li>
	 * <li>inset：具有插入样式的，一般用在 TextInput等具有内部内容的地方</li>
	 * <li>outset：突出的样式，一般用在Button等浮出物上</li>
	 * <li>solid：只有一个框的，一般用在Loader等用很多内部元素的</li>
	 * <li>window：特定的样式，适用于 窗口类组件</li>
	 * <li>alert：特定的样式，适用于 提示类组件</li>
	 * <li>dropDown：特定的样式，适用于 选择类组件，如ComboBox 和 DateField </li>
	 * <li>menuBorder：特定的样式，适用于 菜单类组件，如Menu 和 MenuBar </li>
	 * @param w:Number - 宽度
	 * @param h:Number - 高度 
	 * @param restrict:Array - 圆角限制参数，为四位数组[1,1,1,1]，此参数在 type 为dropDown \ menuBorder 无效
	 */
	private function drawBorder(type:String,w:Number,h:Number,restrict:Array,_mc:MovieClip){
		if(_mc ==undefined ) _mc = _displayObject;
		var _r:Number =_themes.border_corner_radius;
		switch (type) {
		    case "none":
		        break;
		    case "inset":
		    	drawFillRoundRect(createEmptyMc(_mc,"border"),_themes.border_color,0,0,w,h,_r - 0,restrict);
				drawFillRoundRect(createEmptyMc(_mc,"border_hight"),_themes.border_hight_color,1,1,w-2,h-2,_r - 1,restrict);
		        break;
		    case "outset":
				drawFillRoundRect(createEmptyMc(_mc,"border"),_themes.border_color,0,0,w,h,_r - 0,restrict);
				drawFillRoundRect(createEmptyMc(_mc,"border_highlight"),_themes.border_highlight_color,1,1,w-2,h-2,_r - 1,restrict);
				drawFillRoundRect(createEmptyMc(_mc,"border_hight"),_themes.border_hight_color,2,2,w-4,h-4,_r - 2,restrict);
				drawFillRoundRect(createEmptyMc(_mc,"border_insidelight"),_themes.border_insidelight_color,3,3,w-6,h-6,_r - 3,restrict);
		        break;
		    case "solid":
				drawFillRoundRect(createEmptyMc(_mc,"border"),_themes.border_color,0,0,w,h,_r - 0,restrict);
		        break;
		    case "window":
//				drawFillRoundRect(createEmptyMcByDepth(_mc,"border_shadow1",9),_themes.border_color,-1,1,_w+2,_h,_r - 0,restrict,50);
//				drawFillRoundRect(createEmptyMcByDepth(_mc,"border_shadow2",8),_themes.border_color,-2,2,_w+4,_h,_r - 0,restrict,20);
				drawFillRoundRect(createEmptyMc(_mc,"border"),_themes.border_color,0,0,w,h,_r - 0,restrict);
		       	drawFillRoundRect(createEmptyMc(_mc,"border_hight"),_themes.border_hight_color,1,1,w-2,h-2,_r - 1,restrict);
		        break;
		    case "alert":
				drawFillRoundRect(createEmptyMcByDepth(_mc,"border_shadow1",9),_themes.border_color,-1,1,w+2,h,_r - 0,restrict,50);
				drawFillRoundRect(createEmptyMcByDepth(_mc,"border_shadow2",8),_themes.border_color,-2,2,w+4,h,_r - 0,restrict,20);
				drawFillRoundRect(createEmptyMc(_mc,"border"),_themes.border_color,0,0,w,h,_r - 0,restrict);
		        break;
		    case "dropDown":
				drawFillRoundRect(createEmptyMc(_mc,"border"),_themes.border_color,0,0,w,h,_r - 0,[1,0,1,0]);
		        break;
		    case "menuBorder":
				drawFillRoundRect(createEmptyMcByDepth(_mc,"border_shadow1",9),_themes.border_color,1,1,w,h,_r - 0,[0,0,0,0],50);
				drawFillRoundRect(createEmptyMcByDepth(_mc,"border_shadow2",8),_themes.border_color,2,2,w,h,_r - 0,[0,0,0,0],20);
				drawFillRoundRect(createEmptyMc(_mc,"border"),_themes.border_color,0,0,w,h,_r - 0,[0,0,0,0]);
		        break;
		    default:
		        break;
		}
		
	}
	/**
	 * 绘制一个具有圆角的矩形
	 * @param mc:MovieClip - 绘制元件
	 * @param color:Number	- 颜色
	 * @param x:Number	- X位置
	 * @param y:Number	- Y位置
	 * @param width:Number	- 宽度
	 * @param height:Number	- 高度
	 * @param r:Number	- 半径
	 * @param restrict:Array - 例外
	 * @param alpha:Number - 透明值
	 */
	private function drawFillRoundRect(mc:MovieClip,color:Number, x:Number, y:Number, width:Number, height:Number,r:Number,restrict:Array,alpha:Number):Void{
		r = Math.max(r,0);
		var _ap = (alpha >= 0 && alpha != undefined) ? alpha : 100;
		var _g:Graphics = new Graphics(mc);
		_solidBrush.setColor(color);
		_solidBrush.setAlpha(_ap);
		_g.fillRoundRect(_solidBrush,x,y,width,height,restrict[0] ? r:0,restrict[1] ? r:0,restrict[2] ? r:0,restrict[3] ? r:0);
	}
	
	/**
	 * 绘制一个具有渐变的圆角矩形
	 * @param mc:MovieClip - 绘制元件
	 * @param colors:Array	- 颜色数组
	 * @param alphas:Array	- 透明值数组
	 * @param ratios:Array	- 颜色分配数组
	 * @param matrix:Matrix - 矩阵
	 * @param x:Number	- X位置
	 * @param y:Number	- Y位置
	 * @param width:Number	- 宽度
	 * @param height:Number - 高度
	 * @param r:Number	- 半径
	 * @param restrict:Array - 例外
	 */
	private function drawdrawFillRoundRectByGradient(mc:MovieClip,colors:Array,alphas:Array,ratios:Array, matrix:Matrix,x:Number, y:Number, width:Number, height:Number,r:Number,restrict:Array):Void{
		r = Math.max(r,0);
		var _g:Graphics = new Graphics(mc);
		_gradientBrush.setColors(colors);
		_gradientBrush.setAlphas(alphas);
		_gradientBrush.setRatios(ratios);
		_gradientBrush.setMatrix(matrix);
		_g.fillRoundRect(_gradientBrush,x,y,width,height,restrict[0] ? r:0,restrict[1] ? r:0,restrict[2] ? r:0,restrict[3] ? r:0);
	}
	
	/**
	 * 绘制一个矩形
	 * @param mc:MovieClip - 绘制元件
	 * @param color:Number	- 颜色
	 * @param x:Number	- X位置
	 * @param y:Number	- Y位置
	 * @param width:Number	- 宽度
	 * @param height:Number	- 高度
	 * @param alpha:Number - 透明值
	 */
	private function drawfillRectangle(mc:MovieClip,color:Number, x:Number, y:Number, width:Number, height:Number,alpha:Number):Void{
		var _ap = (alpha >= 0 && alpha != undefined) ? alpha : 100;
		var _g:Graphics = new Graphics(mc);
		_solidBrush.setColor(color);
		_solidBrush.setAlpha(_ap);
		_g.fillRectangle(_solidBrush,x,y,width,height);
	}
	
	/**
	 * 绘制一个具有渐变的矩形
	 * @param mc:MovieClip - 绘制元件
	 * @param colors:Array	- 颜色数组
	 * @param alphas:Array	- 透明值数组
	 * @param ratios:Array	- 颜色分配数组
	 * @param matrix:Matrix - 矩阵
	 * @param x:Number	- X位置
	 * @param y:Number	- Y位置
	 * @param width:Number	- 宽度
	 * @param height:Number - 高度
	 */
	private function drawfillRectangleByGradient(mc:MovieClip,colors:Array,alphas:Array,ratios:Array, matrix:Matrix,x:Number, y:Number, width:Number, height:Number):Void{
		var _g:Graphics = new Graphics(mc);
		_gradientBrush.setColors(colors);
		_gradientBrush.setAlphas(alphas);
		_gradientBrush.setRatios(ratios);
		_gradientBrush.setMatrix(matrix);
		_g.fillRectangle(_gradientBrush,x,y,width,height);
	}
	/**
	 * 绘制一个圆
	 * @param mc:MovieClip - 绘制元件
	 * @param colors:Array	- 颜色数组
	 * @param alphas:Array	- 透明值数组
	 * @param ratios:Array	- 颜色分配数组
	 * @param matrix:Matrix - 矩阵
	 * @param x:Number	- X位置
	 * @param y:Number	- Y位置
	 * @param radius:Number	- 半径
	 * @param alpha:Number - 透明值
	 */
	private function drawfillCircleByGradient(mc:MovieClip,colors:Array,alphas:Array,ratios:Array, matrix:Matrix,x:Number, y:Number, radius:Number):Void{
		var _g:Graphics = new Graphics(mc);
		_gradientBrush.setColors(colors);
		_gradientBrush.setAlphas(alphas);
		_gradientBrush.setRatios(ratios);
		_gradientBrush.setMatrix(matrix);
		_g.fillCircle(_gradientBrush,x,y,radius);
	}
	/**
	 * 绘制一个圆
	 * @param mc:MovieClip - 绘制元件
	 * @param color:Number	- 颜色
	 * @param x:Number	- X位置
	 * @param y:Number	- Y位置
	 * @param radius:Number	- 半径
	 * @param alpha:Number - 透明值
	 */
	private function drawfillCircle(mc:MovieClip,color:Number, x:Number, y:Number, radius:Number,alpha:Number):Void{
		var _ap = (alpha >= 0 && alpha != undefined) ? alpha : 100;
		var _g:Graphics = new Graphics(mc);
		_solidBrush.setColor(color);
		_solidBrush.setAlpha(_ap);
		_g.fillCircle(_solidBrush,x,y,radius);
	}
	/**
	 * 获取控件文本格式化对象
	 */
	private function getControlTextFormat():TextFormat{
		var _ft:TextFormat = new TextFormat(_themes.control_text_font,_themes.control_text_size,_themes.control_text_color,_themes.control_text_bold,_themes.control_text_italic);;
		return uniteTextFormat(_ft);
	}
	
	/**
	 * 获取获得焦点的文本格式化对象
	 */
	private function getActiveTitleBarTextFormat():TextFormat{
		var _ft:TextFormat = new TextFormat(_themes.activeTitleBar_text_font,_themes.activeTitleBar_text_size,_themes.activeTitleBar_text_color,_themes.activeTitleBar_text_bold,_themes.activeTitleBar_text_italic);;
		return uniteTextFormat(_ft);
	}
	
	/**
	 * 获取失去焦点的文本格式化对象
	 */
	private function getInactiveTitleBarTextFormat():TextFormat{
		var _ft:TextFormat = new TextFormat(_themes.inactiveTitleBar_text_font,_themes.inactiveTitleBar_text_size,_themes.inactiveTitleBar_text_color,_themes.inactiveTitleBar_text_bold,_themes.inactiveTitleBar_text_italic);;
		return uniteTextFormat(_ft);
	}
	
	/**
	 * 获取信息窗口文本格式化对象
	 */
	private function getMessageTextFormat():TextFormat{
		var _ft:TextFormat = new TextFormat(_themes.message_text_font,_themes.message_text_size,_themes.message_text_color,_themes.message_text_bold,_themes.message_text_italic);;
		return uniteTextFormat(_ft);
	}
	
	//将指定 TextFormat 与 组件自带的 TextFormat 合并，优先组件自带的元素
	private function uniteTextFormat(_ft:TextFormat):TextFormat{
		if(_component.getTextFormat() != undefined){
			var _cft:TextFormat = _component.getTextFormat();
			for(var i in _cft){
				if(_cft[i] != null) _ft[i] = _cft[i];
			}
//			if(_cft.font != null) _ft.font = _cft.font;
//			if(_cft.size != null) _ft.size = _cft.size;
//			if(_cft.color != null) _ft.color = _cft.color;
//			if(_cft.bold != null) _ft.bold = _cft.bold;
//			if(_cft.italic != null) _ft.italic = _cft.italic;
		}
		return _ft;
	}
	/**
	 * 构造一个指定名称的元素
	 */
	static private function createEmptyMc(target:MovieClip,name:String):MovieClip{
		return createEmptyMcByDepth(target,name,getDepth(name));
	}
	
	/**
	 * 构造一个指定名称和深度的元素
	 */
	static private function createEmptyMcByDepth(target:MovieClip,name:String,depth:Number):MovieClip{
		if(target[name] == undefined){
			target[name] = target.createEmptyMovieClip(name,depth);
			target[name].focusEnabled = false;
			target[name].tabEnabled = false;
		}else{
			target[name].clear();
		}
		return target[name];
	}
	
	static private function getDepth(mcName:String):Number{
		if(_DepthManager == undefined){
			_DepthManager = new Object();
			_DepthManager["ControlBackground"] = 5;
			_DepthManager["border"] = 10;
			
			_DepthManager["selected"] = 25;
			
			_DepthManager["border_highlight"] = 20;
			_DepthManager["border_hight"] = 30;
			_DepthManager["border_insidelight"] = 40;
			
			_DepthManager["control"] = 50;
			
//			_DepthManager["WindowBorder"] = 10;
//			_DepthManager["WindowHighLightBorder"] = 20;
			_DepthManager["window_back"] = 55;
			_DepthManager["window_top"] = 60;
			_DepthManager["window_bottom"] = 61;
			_DepthManager["window_insert_box"] = 70;
			_DepthManager["window_insert_box1"] = 71;
			_DepthManager["window_insert_box2"] = 72;
			
		}
		return _DepthManager[mcName];
	}
}