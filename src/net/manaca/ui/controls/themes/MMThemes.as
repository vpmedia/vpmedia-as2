import net.manaca.ui.controls.themes.Themes;

/**
 * V2组件主题
 * @author Wersling
 * @version 1.0, 2006-4-5
 */
class net.manaca.ui.controls.themes.MMThemes extends Themes {
	private var className : String = "net.manaca.ui.controls.themes.MMThemes";
	//	字体

	public function MMThemes() {
		super();
		_name = "MMThemes";
		
//		FontName="Tahoma";
//		FontSize=11;
		
		
		FocusColor=0x4EFF00;	
		TrackColor=0x4EFF00;
		cornerRadius =5;
//		TrackColor=0x56B61D;
		
		ApplicationWorkspace=0xFFFFFF;
		ApplicationWorkText=0x333333;
		
		WindowSpace=0xFFFFFF;
		WindowText=0x000000;
		WindowInsertBox=0x444444;
		
		WindowBorder=0x444444;
		WindowBack=0xFFFFFF;
		WindowHighLightBorder=0xFFFFFF;
		WindowHighDarkBorder=0xECECEC;
		
		GridRowSpec=0xECECEC;
		
		WindowInactiveCaption=0xCCCCCC;
		WindowActiveCaption=0xDADADA;
		WindowInactiveCaptionText=0x999999;
		WindowActiveCaptionText=0x0B333C;
		
		WindowButtonBorder=0xA4ACAC;
		WindowButtonBack=0xF6F6F6;
		
		ControlBorder=0x444444;
		ControlHighLight=0xF7F7F7;
		ControlLight=0xD2DADA;
		ControlInsideLight = 0xffffff;
		Control=0xF8F8F8;
		ControlText=0x303030;
		
		
		MenuColor=0xFFFFFF;
		MenuLeftColor=0xEAEAEA;
		MenuBorderColor=0xA4ACAC;
		MenuText=0x0B333C;
		fontName = "Tahoma,宋体";
//		DefaultTextFormat = new TextFormat("Arial,宋体",12,ControlText,null,null,null,null,null,"left");
		haloControlBorder = [0x666666,0xCCCCCC]; // halo皮肤的控件边框颜色组
		haloControlBorderAlphas = [100,100]; 
		haloControlBorderRatios = [0, 255];
		haloControlBorderOverAndDown = [0x4EFF00,0x4EFF00];
		
		haloControl = [0xEEEEEE,0xffffff];	//	halo皮肤控件表面颜色
		haloControlAlphas = [100,100]; //halo皮肤控件表面的颜色透明值
		haloControlRatios = [0, 255]; //halo皮肤控件表面的颜色分布比率  0, 255/2,255/2,255
		haloControlOver = [0xffffff,0xffffff]; 
  		haloControlDown = [0xD2FFBF,0xffffff]; 
	}
}