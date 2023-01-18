import net.manaca.ui.controls.themes.Themes;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-4-7
 */
class net.manaca.ui.controls.themes.Darkness extends Themes {
	private var className : String = "net.manaca.ui.controls.themes.Darkness";
	public function Darkness() {
		super();
		_name = "Darkness";
	
		FocusColor=0xFFCC00;
		TrackColor=0xFFCC00;
		cornerRadius =0;
		ApplicationWorkspace=0x333333;
		ApplicationWorkText=0xFFFFFF;
		
		WindowSpace=0x555555;
		WindowText=0xFFFFFF;
		WindowInsertBox=0x000000;
		
		WindowBorder=0x000000;
		WindowBack=0x555555;
		WindowHighLightBorder=0x999999;
		WindowHighDarkBorder=0x666666;
		GridRowSpec=0x666666;
		
		WindowInactiveCaption=0xCCCCCC;
		WindowActiveCaption=0x333333;
		WindowInactiveCaptionText=0xFFFFFF;
		WindowActiveCaptionText=0xFFFF99;
		
		WindowButtonBorder=0x000000;
		WindowButtonBack=0xAAAAAA;
		
		ControlBorder=0x000000;
		ControlHighLight=0xcccccc;
		ControlLight=0x999999;
		ControlInsideLight = 0xffffff;
		Control=0xEFEFEF;
		ControlText=0x000000;
		
		
		MenuColor=0xFFFFFF;
		MenuLeftColor=0xCDDDF1;
		MenuBorderColor=0x000000;
		MenuText=0x000000;
		fontName = "Tahoma,宋体";
//		DefaultTextFormat = new TextFormat("Arial,宋体",12,ControlText,null,null,null,null,null,"center");
		
		haloControlBorder = [0x666666,0xCCCCCC]; // halo皮肤的控件边框颜色组
		haloControlBorderAlphas = [100,100]; 
		haloControlBorderRatios = [0, 255];
		
		haloControl = [0xEEEEEE,0xffffff];	//	halo皮肤控件表面颜色
		haloControlAlphas = [100,100]; //halo皮肤控件表面的颜色透明值
		haloControlRatios = [0, 255]; //halo皮肤控件表面的颜色分布比率  0, 255/2,255/2,255
	}

}