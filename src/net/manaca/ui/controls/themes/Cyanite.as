import net.manaca.ui.controls.themes.Themes;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-4-7
 */
class net.manaca.ui.controls.themes.Cyanite extends Themes {
	private var className : String = "net.manaca.ui.controls.themes.Cyanite";
	public function Cyanite() {
		super();
		_name = "Cyanite";
		//----new Themse---------------------------------------------------
		border_color = 0x194391;//边界颜色
		border_highlight_color = 0xEBF3FD;//边框高亮颜色
		border_hight_color = 0xBDD8F9;//边框内围颜色
		border_insidelight_color = 0xFFFFFF;//边框内部高亮颜色
		
		FocusColor=0x00CCFF;
		TrackColor=0x00CCFF;
		cornerRadius =5;
		ApplicationWorkspace=0x3A6EA5;
		ApplicationWorkText=0xFFFFFF;
		
		WindowSpace=0xFFFFFF;
		WindowText=0x000000;
		WindowInsertBox=0x194391;
		
		WindowBorder=0x194391;
		WindowBack=0xD3E5FA;
		WindowHighLightBorder=0x7DB8FA;
		WindowHighDarkBorder=0x4792EC;
		
		WindowInactiveCaption=0x567DBE;
		WindowActiveCaption=0x1666CE;
		WindowInactiveCaptionText=0xFFFFFF;
		WindowActiveCaptionText=0xFFFF99;
		
		WindowButtonBorder=0x194391;
		WindowButtonBack=0xCBE3FF;
		
		ControlBorder=0x194391;
		ControlHighLight=0xEBF3FD;
		ControlLight=0xBDD8F9;
		ControlInsideLight = 0xFFFFFF;
		Control=0xE7EEF8;
		ControlText=0x333333;
		GridRowSpec=0xEBF3FD;
		
		
		MenuColor=0xFFFFFF;
		MenuLeftColor=0xCDDDF1;
		MenuBorderColor=0x194391;
		MenuText=0x000000;
		fontName = "Tahoma,宋体";
		//DefaultTextFormat = new TextFormat("Tahoma",12,ControlText,null,null,null,null,null,"left");
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