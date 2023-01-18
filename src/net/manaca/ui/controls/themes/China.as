import net.manaca.ui.controls.themes.Themes;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
class net.manaca.ui.controls.themes.China extends Themes {
	private var className : String = "net.manaca.ui.controls.themes.China";
	function China() {
		super();
		_name = "China";
		fontName = "Tahoma,宋体";
		FocusColor=0xFF0000;
		TrackColor=0x00CCFF;
		cornerRadius =5;
		ApplicationWorkspace=0x3A6EA5;
		ApplicationWorkText=0xFFFFFF;
		
		WindowSpace=0xFFFFFF;
		WindowText=0x000000;
		WindowInsertBox=0x8F1B1B;
		
		WindowBorder=0x8F1B1E;
		WindowBack=0xFEECEB;
		WindowHighLightBorder=0xFB7B7B;
		WindowHighDarkBorder=0xEE4444;
		
		WindowInactiveCaption=0xC74E4E;
		WindowActiveCaption=0xD21111;
		WindowInactiveCaptionText=0xFFFFFF;
		WindowActiveCaptionText=0xFFFF00;
		
		WindowButtonBorder=0x194391;
		WindowButtonBack=0xCBE3FF;
		
		ControlBorder=0x8F1B1E;
		ControlHighLight=0xFEECEB;
		ControlLight=0xFABCBC;
		ControlInsideLight = 0xFFFFFF;
		Control=0xF8E7E7;
		ControlText=0x333333;
		GridRowSpec=0xEBF3FD;
		
		
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