import net.manaca.ui.controls.themes.Themes;

/**
 * 蓝宝石主题
 * @author Wersling
 * @version 1.0, 2006-5-30
 */
class net.manaca.ui.controls.themes.Sapphire extends Themes {
	private var className : String = "net.manaca.ui.controls.themes.Sapphire";
	private var _name : String = "Sapphire";
	public function Sapphire() {
		super();
		focus_color = 0x00CCFF;						//具有焦点的颜色
		caption_button_size = 20;					//标题按钮大小
		
		border_color = 0x194391;					//边界颜色
		border_highlight_color = 0xEBF3FD;			//边框高亮颜色
		border_hight_color = 0xBDD8F9;				//边框内围颜色
		border_insidelight_color = 0xFFFFFF;		//边框内部高亮颜色
		border_corner_radius = 5;					//边框弯曲半径
		
		control_color = 0xE7EEF8;					//控件表面颜色
		control_text_font = "Tahoma,宋体";			//控件文本字体
		control_text_color = 0x333333;				//控件文本颜色
		control_text_size = 12;						//控件文本小
		control_text_bold = false;					//控件文本粗体
		control_text_italic = false;				//控件文本斜体
		
		activeTitleBar_size = 22;						//活动的标题栏大小
		activeTitleBar_color1 = 0x1666CE;				//活动的标题栏颜色1
		activeTitleBar_color2 = 0x1666CE;				//活动的标题栏颜色2
		activeTitleBar_text_font = control_text_font;	//活动的标题栏文本字体
		activeTitleBar_text_color = 0xFFFF99;			//活动的标题栏文本颜色
		activeTitleBar_text_size = control_text_size;	//活动的标题栏文本大小
		activeTitleBar_text_bold = true;				//活动的标题栏文本粗体
		activeTitleBar_text_italic = false;				//活动的标题栏文本斜体
		
		inactiveTitleBar_size = activeTitleBar_size;	//不活动的标题栏大小
		inactiveTitleBar_color1 = 0x93B6E1;				//不活动的标题栏颜色1
		inactiveTitleBar_color2 = 0x567DBE;				//不活动的标题栏颜色2
		inactiveTitleBar_text_font = control_text_font;	//不活动的标题栏文本字体
		inactiveTitleBar_text_color = 0xE4E1AD;			//不活动的标题栏文本颜色
		inactiveTitleBar_text_size = control_text_size;	//不活动的标题栏文本大小
		inactiveTitleBar_text_bold = true;				//不活动的标题栏文本粗体
		inactiveTitleBar_text_italic = false;			//不活动的标题栏文本斜体
		
		message_text_font = control_text_font;		//消息文本字体
		message_text_color = control_text_color;	//消息文本颜色
		message_text_size = control_text_size;		//消息文本大小
		message_text_bold = control_text_bold;		//消息文本粗体
		message_text_italic = control_text_italic;	//消息文本斜体
		
		window_color = 0xE7EEF8;		//窗体颜色
		window_text_color = 0x000000;	//窗体文本颜色
		desktop_color = 0x3A6EA5;		//桌面颜色
	}

}