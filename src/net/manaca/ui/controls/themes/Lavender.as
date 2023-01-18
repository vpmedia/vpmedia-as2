import net.manaca.ui.controls.themes.Themes;

/**
 * 熏衣草
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
class net.manaca.ui.controls.themes.Lavender extends Themes {
	private var className : String = "net.manaca.ui.controls.themes.Lavender";
	function Lavender() {
		super();
		_name = "Lavender";
		focus_color = 0x00CCFF;						//具有焦点的颜色
		caption_button_size = 20;					//标题按钮大小
		
		border_color = 0x194391;					//边界颜色
		border_highlight_color = 0xEBF3FD;			//边框高亮颜色
		border_hight_color = 0xBDD8F9;				//边框内围颜色
		border_insidelight_color = 0xFFFFFF;		//边框内部高亮颜色
		border_corner_radius = 5;					//边框弯曲半径
		
		control_color = 0xE7EEF8;					//控件表面颜色
		control_text_font = "Tahoma,宋体";			//控件文本字体
		control_text_color = 0xff0000;				//控件文本颜色
		control_text_size = 12;						//控件文本小
		control_text_bold = false;					//控件文本粗体
		control_text_italic = false;				//控件文本斜体
		
		activeTitleBar_size = 25;						//活动的标题栏大小
		activeTitleBar_color1 = 0x1666CE;				//活动的标题栏颜色1
		activeTitleBar_color2 = 0x1666CE;				//活动的标题栏颜色2
		activeTitleBar_text_font = control_text_font;	//活动的标题栏文本字体
		activeTitleBar_text_color = 0xFFFF99;			//活动的标题栏文本颜色
		activeTitleBar_text_size = control_text_size;	//活动的标题栏文本大小
		activeTitleBar_text_bold = true;				//活动的标题栏文本粗体
		activeTitleBar_text_italic = false;				//活动的标题栏文本斜体
		
		inactiveTitleBar_size = activeTitleBar_size;	//不活动的标题栏大小
		inactiveTitleBar_color1 = 0x567DBE;				//不活动的标题栏颜色1
		inactiveTitleBar_color2 = 0x567DBE;				//不活动的标题栏颜色2
		inactiveTitleBar_text_font = control_text_font;	//不活动的标题栏文本字体
		inactiveTitleBar_text_color = 0xFFFFFF;			//不活动的标题栏文本颜色
		inactiveTitleBar_text_size = control_text_size;	//不活动的标题栏文本大小
		inactiveTitleBar_text_bold = true;				//不活动的标题栏文本粗体
		inactiveTitleBar_text_italic = false;			//不活动的标题栏文本斜体
		
		message_text_font = control_text_font;		//消息文本字体
		message_text_color = control_text_color;	//消息文本颜色
		message_text_size = control_text_size;		//消息文本大小
		message_text_bold = control_text_bold;		//消息文本粗体
		message_text_italic = control_text_italic;	//消息文本斜体
		
		window_color = 0xFFFFFF;		//窗体颜色
		window_text_color = 0x000000;	//窗体文本颜色
		
		desktop_color = 0x3A6EA5;		//桌面颜色
		
		fontName = "Tahoma,宋体";
		FocusColor=0x8465D6;
		TrackColor=0x00CCFF;
		cornerRadius =5;
		ApplicationWorkspace=0x3A6EA5;
		ApplicationWorkText=0xFFFFFF;
		
		WindowSpace=0xFFFFFF;
		WindowText=0x000000;
		WindowInsertBox=0x3C227D;
		
		WindowBorder=0x3C227D;
		WindowBack=0xE6DFF7;
		WindowHighLightBorder=0xCDBEEF;
		WindowHighDarkBorder=0xAA92E4;
		
		WindowInactiveCaption=0x7C6CC8;
		WindowActiveCaption=0x8E69D3;
		WindowInactiveCaptionText=0xB3B8FF;
		WindowActiveCaptionText=0xFFFFFF;
		
		WindowButtonBorder=0x194391;
		WindowButtonBack=0xCBE3FF;
		
		ControlBorder=0x502B95;
		ControlHighLight=0xE1D8F3;
		ControlLight=0xC4B3E8;
		ControlInsideLight = 0xFFFFFF;
		Control=0xF2EFFA;
		ControlText=0x291A53;
		GridRowSpec=0xF3F0FB;
		
		
		MenuColor=0xFFFFFF;
		MenuLeftColor=0xCDDDF1;
		MenuBorderColor=0x194391;
		MenuText=0x000000;
		
		haloControlBorder = [0x666666,0xCCCCCC]; // halo皮肤的控件边框颜色组
		haloControlBorderAlphas = [100,100]; 
		haloControlBorderRatios = [0, 255];
		haloControlBorderOverAndDown = [0x0099FF,0x0099FF];
		
		haloControl = [0xEEEEEE,0xffffff];	//	halo皮肤控件表面颜色
		haloControlAlphas = [100,100]; //halo皮肤控件表面的颜色透明值
		haloControlRatios = [0, 255]; //halo皮肤控件表面的颜色分布比率  0, 255/2,255/2,255
		haloControlOver = [0xF8F8F8,0xF8F8F8]; 
  		haloControlDown = [0xB3E1FB,0xE8F5FF]; 
  		
  		haloWindowTop = []; //窗口
	  	haloWindowTopAlphas = [];
	  	haloWindowTopRatios = [];
	  	
	  	haloWindowBottom = []; //窗口
	  	haloWindowBottomAlphas = [];
	  	haloWindowBottomRatios = [];
		
	}

}