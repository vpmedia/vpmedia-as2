//****************************************************************************
// Html Cell Renderer
// by PhilFlash - http://philflash.inway.fr
// 
// version 1.25 : 12 Jan 2004
//   - style_sheet devient une variable statique pour optimisation 
//     sur chargement
// version 1.2 : 22 Dec 2003
//   - la sélection (highlight) apparait sur ce type de cellule
// version 1.1 : 7 Nov 2003
//   - correction d'un bug sur le scroll
// version 1.0 : 20 Oct 2003
//   - version initiale
//
// Dont't forget :
// - to create a new symbol in Flash MX2004
//   Insert > New Symbol
//   with properties :
//    Name : HtmlCellRenderer
//    Behavior : MovieClip : Checked
//   For Linkage:
//    Identifier: HtmlCellRenderer
//    AS 2.0 Class : HtmlCellRenderer
//    Export for Actionscript : Checked
//    Export for in first frame : Checked
//****************************************************************************

import mx.core.UIComponent;
import mx.controls.TextArea;
import TextField.StyleSheet;

class HtmlCellRenderer extends UIComponent
{

	static public var CssUrl : String;		// Global: URL for CSS stylesheet
	static public var style_sheet : StyleSheet = null;
	
	var htmlComponent : TextField;

	var listOwner : MovieClip;   // the reference we receive to the list
	var getCellIndex : Function; // the function we receive from the list
	var	getDataLabel : Function; // the function we receive from the list
	
	var previousLabel:String = null; // for optimization

	function HtmlCellRenderer()
	{
	}

	function createChildren(Void) : Void
	{
		if (CssUrl != undefined && style_sheet == null) 
		{
			style_sheet = new TextField.StyleSheet();
			style_sheet.load(CssUrl);
  		}
		if (htmlComponent == undefined)
		{
			createLabel("htmlComponent", 1);
		}
		htmlComponent.html = true;
		//htmlComponent.border = true;
		htmlComponent.multiline = true;
		htmlComponent.wordWrap = true;
		htmlComponent.selectable = false;
		htmlComponent.background = false;

		size();

	}

	// note that setSize is implemented by UIComponent and calls size(), after setting
	// __width and __height
	function size(Void) : Void
	{
		var h = __height;
		var w = __width;
		
		htmlComponent.setSize(w-4, Math.max(h, listOwner.rowHeight-4));
		htmlComponent._x = 1;
		htmlComponent._y = 1;
		
	}

	function setValue(str:String, item:Object, sel:Boolean) : Void
	{
		// On est sur des lignes non remplies
		if (item == undefined) 
		{
			if (htmlComponent != undefined) 
			{
				htmlComponent.text = "";
				htmlComponent._visible = false;
				previousLabel = null;
			}
			return;
		}
		
		htmlComponent._visible = true;
		var columnIndex = this["columnIndex"]; // private property (no access function)
		var columnName = listOwner.getColumnAt(columnIndex).columnName;
		var htmlFunction : Function = listOwner.getColumnAt(columnIndex).htmlFunction;
		if (htmlFunction != undefined) 
		{
			var label = htmlFunction(item, columnName);
			if (label != undefined) 
			{
				// Important pour optimisation
				// Empêche un flip-flop des images
				if (label != previousLabel) 
				{
					var oldStyleSheet = htmlComponent.styleSheet
					if (oldStyleSheet != style_sheet && style_sheet != null) 
					{
						htmlComponent.styleSheet = style_sheet;
					}
					htmlComponent.text = label;
					htmlComponent.invalidate();
					previousLabel = label;
				} 
			} else {
				htmlComponent.text = "";				
			}
		}
	}

	function getPreferredHeight(Void) : Number
	{
		return 16; 
	}

	function getPreferredWidth(Void) : Number
	{
		return 20;
	}
}

