
/**
 * 提供基本的主题方法，接口不定义任何接口，但主题必须实现此接口
 * @author Wersling
 * @version 1.0, 2006-4-5
 */
class net.manaca.ui.controls.themes.Themes {
	private var className : String = "net.manaca.ui.controls.themes.Themes";
	//----new Themse---------------------------------------------------
	public var focus_color:Number;//具有焦点的颜色
	public var caption_button_size:Number;//标题按钮大小
	
	public var border_color:Number;//边界颜色
	public var border_highlight_color:Number;//边框高亮颜色
	public var border_hight_color:Number;//边框内围颜色
	public var border_insidelight_color:Number;//边框内部高亮颜色
	public var border_corner_radius:Number;//边框弯曲半径
	
	public var control_color:Number;//控件表面颜色
	public var control_text_font:String;//控件文本字体
	public var control_text_color:Number;//控件文本颜色
	public var control_text_size:Number;//控件文本小
	public var control_text_bold:Boolean;//控件文本粗体
	public var control_text_italic:Boolean;//控件文本斜体
	
	public var activeTitleBar_size:Number;//活动的标题栏大小
	public var activeTitleBar_color1:Number;//活动的标题栏颜色1
	public var activeTitleBar_color2:Number;//活动的标题栏颜色2
	public var activeTitleBar_text_font:String;//活动的标题栏文本字体
	public var activeTitleBar_text_color:Number;//活动的标题栏文本颜色
	public var activeTitleBar_text_size:Number;//活动的标题栏文本大小
	public var activeTitleBar_text_bold:Boolean;//活动的标题栏文本粗体
	public var activeTitleBar_text_italic:Boolean;//活动的标题栏文本斜体
	
	public var inactiveTitleBar_size:Number;//不活动的标题栏大小
	public var inactiveTitleBar_color1:Number;//不活动的标题栏颜色1
	public var inactiveTitleBar_color2:Number;//不活动的标题栏颜色2
	public var inactiveTitleBar_text_font:String;//不活动的标题栏文本字体
	public var inactiveTitleBar_text_color:Number;//不活动的标题栏文本颜色
	public var inactiveTitleBar_text_size:Number;//不活动的标题栏文本大小
	public var inactiveTitleBar_text_bold:Boolean;//不活动的标题栏文本粗体
	public var inactiveTitleBar_text_italic:Boolean;//不活动的标题栏文本斜体
	
	public var message_text_font:String;//消息文本字体
	public var message_text_color:Number;//消息文本颜色
	public var message_text_size:Number;//消息文本大小
	public var message_text_bold:Boolean;//消息文本粗体
	public var message_text_italic:Boolean;//消息文本斜体
	
	public var window_color:Number;//窗体颜色
	public var window_text_color:Number;//窗体文本颜色
	
	public var desktop_color:Number;//桌面颜色
	
	//---old Themes----------------------------------------------------
	public var fontName:String;
	//	颜色
	public var FocusColor:Number;			//	焦点图形
	public var TrackColor:Number;			//	辅助线图形
	public var cornerRadius:Number; //	转角弯曲度
	
	public var ApplicationWorkspace:Number;		//	工作区 / 桌面背景色
	public var ApplicationWorkText:Number;		//	工作区文本颜色
	
	public var WindowSpace:Number;				//	窗口背景色
	public var WindowText:Number;				//	窗口文本色
	public var WindowInsertBox:Number;			//	窗口内边框
	
	public var WindowBorder:Number;				//	窗体边框颜色
	public var WindowBack:Number;				//	窗体背景色
	public var WindowHighLightBorder:Number;	//	窗体高亮颜色
	public var WindowHighDarkBorder:Number;
	public var WindowInactiveCaption:Number;	//	非焦点窗体标题栏颜色
	public var WindowActiveCaption:Number;		//	焦点窗体标题栏颜色
	public var WindowInactiveCaptionText:Number;	//	非焦点标题栏文本颜色
	public var WindowActiveCaptionText:Number;	 	//	焦点标题栏文本颜色
	public var WindowButtonBorder:Number;			//窗体按钮边框颜色
	public var WindowButtonBack:Number;				//窗体按钮背景颜色
	
	public var ControlBorder:Number;		//	控件边框颜色
	public var ControlHighLight:Number;		//  控件高亮部分颜色
	public var ControlLight:Number;			//	控件亮度部分颜色
	public var ControlInsideLight:Number;	//	控件内部高亮部分颜色
	public var Control:Number;				//	控件表面颜色
	public var ControlText:Number;			//	控件文本颜色
		
	public var MenuColor:Number;			//	菜单背景颜色
	public var MenuLeftColor:Number;		//	菜单前缀颜色
	public var MenuBorderColor:Number;		//	菜单边框颜色
	public var MenuText:Number;				//	菜单文本颜色
		
	public var GridRowSpec:Number;			//	表格分隔行背景
	//--------------halo皮肤
	//边框
	public var haloControlBorder:Array = []; // halo皮肤的控件边框颜色组
    public var haloControlBorderAlphas:Array = [];	//halo皮肤控件边框颜色透明值
  	public var haloControlBorderRatios:Array = []; //halo皮肤控件边框颜色分布比率
	public var haloControlBorderOverAndDown:Array = [];
  	//表面
	public var haloControl:Array = [];			//	halo皮肤控件表面颜色
    public var haloControlAlphas:Array = [];	//halo皮肤控件表面的颜色透明值
  	public var haloControlRatios:Array = []; //halo皮肤控件表面的颜色分布比率
  	public var haloControlOver:Array = []; 
  	public var haloControlDown:Array = []; 
  	
  	public var haloWindowTop:Array = []; //窗口
  	public var haloWindowTopAlphas:Array = [];
  	public var haloWindowTopRatios:Array = [];
  	
  	public var haloWindowBottom:Array = []; //窗口
  	public var haloWindowBottomAlphas:Array = [];
  	public var haloWindowBottomRatios:Array = [];
  	
//	static public var FontCss:Object = {
//									size:12,
//									multiline:true,
//									selectable:false,
//									bold:false
//									//border:true
//									//wordWrap:true
//									};
	
	private var _name : String;
	/**
	 * 返回主题名称
	 * @param String 主题名称
	 */
	public function getName():String{
		return _name;
	}

}