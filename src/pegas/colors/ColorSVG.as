/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.colors.ColorHTML;

import vegas.data.map.HashMap;
import vegas.util.TypeUtil;


/**
 * All SVG W3C standard colors. 
 * Basic HTML data types - W3C HTML 4 Specifications : <a href='http://www.w3.org/TR/html4/types.html (chap 6.5)'>http://www.w3.org/TR/html4/types.html</a> (chap 6.5).
 * Scalable Vector Graphics Color Names : <a href='http://www.december.com/html/spec/colorsvg.html'>http://www.december.com/html/spec/colorsvg.html</a>
 * @author eKameleon
 */
class pegas.colors.ColorSVG extends ColorHTML 
{
	
	/**
	 * Creates a new ColorSVG instance.
	 * @param n the value hex of the color.
	 * @param the name of the color.
	 */
	public function ColorSVG( n:Number , name:String) 
	{
		super(n, name) ;
		
		if ( ColorSVG.ELEMENTS == null )
		{
			ColorSVG.ELEMENTS = new HashMap() ;
		}
		
		ColorSVG.ELEMENTS.put( name.toLowerCase(), this) ;
		
	}

	/**
	 * The hashmap of all SVG colors.
	 */
	static public var ELEMENTS:HashMap = null ;

	static public var ALICE_BLUE:ColorSVG = new ColorSVG(0xF0F8FF , "AliceBlue") ;
	
	static public var ANTIQUE_WHITE:ColorSVG = new ColorSVG(0xFAEBD7 , "AntiqueWhite") ;
	
	static public var AQUA:ColorSVG = new ColorSVG(0x00FFFF , "Aqua") ;
	
	static public var AQUA_MARINE:ColorSVG = new ColorSVG(0x00FFFF , "AquaMarine") ;
	
	static public var AZURE:ColorSVG = new ColorSVG(0xF0FFFF, "Azure") ;
	
	static public var BEIGE:ColorSVG = new ColorSVG(0xF5F5DC, "Beige") ;
	
	static public var BISQUE:ColorSVG = new ColorSVG(0xFFE4C4, "Bisque") ;
	
	static public var BLACK:ColorSVG = new ColorSVG(0x000000 , "Black") ;

	static public var BLANCH_DALMOND = new ColorSVG(0xFFEBCD, "BlancheDalmond") ;

	static public var BLUE:ColorSVG = new ColorSVG(0x0000FF , "Blue") ;

	static public var BLUE_VIOLET:ColorSVG = new ColorSVG(0x8A2BE2 , "BlueViolet") ;

	static public var BROWN:ColorSVG = new ColorSVG(0xA52A2A, "Brown") ;

	static public var BURLY_WOOD:ColorSVG = new ColorSVG(0xDEB887, "BurlyWood") ;

	static public var CADET_BLUE:ColorSVG = new ColorSVG(0x5F9EA0, "CadetBlue") ;
	
	static public var CHARTREUSE:ColorSVG = new ColorSVG(0x7FFF00, "Chartreuse") ;

	static public var CHOCOLATE:ColorSVG = new ColorSVG(0xD2691E, "Chocolate") ;

	static public var CORAL:ColorSVG = new ColorSVG(0xFF7F50, "Coral") ;

	static public var CORN_FLOWER_BLUE:ColorSVG = new ColorSVG(0x6495ED , "CornFlowerBlue") ;
	
	static public var CORN_SILK:ColorSVG = new ColorSVG(0xFFF8DC, "CornSilk") ;
	
	static public var CRIMSON:ColorSVG = new ColorSVG(0xDC143C, "CrimSon") ;
	
	static public var CYAN:ColorSVG = new ColorSVG(0x00FFFF, "Cyan") ;
		
	static public var DARK_BLUE:ColorSVG = new ColorSVG(0x00008B, "Darkblue") ;

	static public var DARK_CYAN:ColorSVG = new ColorSVG(0x0008B8B , "DarkCyan") ;

	static public var DARK_GOLDEN_ROD:ColorSVG = new ColorSVG(0xB8860B, "DarkGoldenRod") ;

	static public var DARK_GRAY:ColorSVG = new ColorSVG(0xA9A9A9, "DarkGray") ;

	static public var DARK_GREEN:ColorSVG = new ColorSVG(0x006400, "DarkGreen") ;

	static public var DARK_GREY:ColorSVG = new ColorSVG(0xA9A9A9, "DarkGrey") ;

	static public var DARK_KHAKI:ColorSVG = new ColorSVG(0xBDB76B, "DarkKhaki") ;

	static public var DARK_MAGENTA:ColorSVG = new ColorSVG(0x8B008B, "DarkMagenta") ;
	
	static public var DARK_OLIVE_GREEN:ColorSVG = new ColorSVG(0x556B2F, "DarkOliveGreen") ;

	static public var DARK_ORANGE:ColorSVG = new ColorSVG(0xFF8C00, "DarkOrange") ;
	
	static public var DARK_ORCHID:ColorSVG = new ColorSVG(0x9932CC, "DarkOrchid") ;
	
	static public var DARK_RED:ColorSVG = new ColorSVG(0x8b0000, "DarkRed") ;

	static public var DARK_SALMON:ColorSVG = new ColorSVG(0xE9967A, "DarkSalmon") ;

	static public var DARK_SEA_GREEN:ColorSVG = new ColorSVG(0x8FBC8F, "DarkSeaGreen") ;

	static public var DARK_SLATE_BLUE:ColorSVG = new ColorSVG(0x483F8B, "DarkSlateBlue") ;
	
	static public var DARK_SLATE_GRAY:ColorSVG = new ColorSVG(0x2F4F4F, "DarkSlateGray") ;
	
	static public var DARK_SLATE_GREY:ColorSVG = new ColorSVG(0x2F4F4F, "DarkSlateGrey") ;
	
	static public var DARK_TURQUOISE:ColorSVG = new ColorSVG(0x00CED1, "DarkTurquoise") ;
	
	static public var DARK_VIOLET:ColorSVG = new ColorSVG(0x9400D3, "DarkViolet") ;
	
	static public var DEEP_PINK:ColorSVG = new ColorSVG(0xff1493, "DeepPink") ;
	
	static public var DEEP_SKY_BLUE:ColorSVG = new ColorSVG(0x00bfff, "DeepSkyBlue") ;
	
	static public var DIM_GRAY:ColorSVG = new ColorSVG(0x696969, "DimGray") ;
	
	static public var DIM_GREY:ColorSVG = new ColorSVG(0x696969, "DimGrey") ;
	
	static public var DODGER_BLUE:ColorSVG = new ColorSVG(0x1e90ff, "DodgerBlue") ;
	
	static public var FIRE_BRICK:ColorSVG = new ColorSVG(0xb22222, "FireBrick") ;
	
	static public var FLORAL_WHITE:ColorSVG = new ColorSVG(0xfffaf0, "FloralWhite") ;
	
	static public var FOREST_GREEN:ColorSVG = new ColorSVG(0x228b22, "ForestGreen") ;
	
	static public var FUCHSIA:ColorSVG = new ColorSVG(0xff00ff , "Fuchsia") ;
	
	static public var GAINSBORO:ColorSVG = new ColorSVG(0xdcdcdc, "Gainsboro") ;
	
	static public var GHOST_WHITE:ColorSVG = new ColorSVG(0xf8f8ff, "GhostWhite") ;
	
	static public var GOLD:ColorSVG = new ColorSVG(0xffd700, "Gold") ;
	
	static public var GOLD_EN_ROD:ColorSVG = new ColorSVG(0xdaa520, "GoldEnRod") ;
	
	static public var GRAY:ColorSVG = new ColorSVG(0x808080 , "Gray") ;
	
	static public var GREY:ColorSVG = new ColorSVG(0x808080, "Grey") ;
	
	static public var GREEN:ColorSVG = new ColorSVG(0x008000 , "Green") ;
	
	static public var GREEN_YELLOW:ColorSVG = new ColorSVG(0xadff2f, "GreenYellow") ;
	
	static public var HONEY_DEW:ColorSVG = new ColorSVG(0xf0fff0, "HoneyDew") ;
	
	static public var HOT_PINK:ColorSVG = new ColorSVG(0xff69b4, "HotPink") ;
	
	static public var INDIAN_RED:ColorSVG = new ColorSVG(0xcd5c5c, "IndianRed") ;
	
	static public var INDIGO:ColorSVG = new ColorSVG(0x4b0082, "Indigo") ;
	
	static public var IVORY:ColorSVG = new ColorSVG(0xfffff0, "Ivory") ;
	
	static public var KHAKI:ColorSVG = new ColorSVG(0xf0e68c, "Khaki") ;
	
	static public var LAVENDER:ColorSVG = new ColorSVG(0xe6e6fa, "Lavender") ;
	
	static public var LAVENDER_BLUSH:ColorSVG = new ColorSVG(0xfff0f5, "LavenderBlush") ;
	
	static public var LAWN_GREEN:ColorSVG = new ColorSVG(0x7cfc00, "LawnGreen") ;
	
	static public var LEMON_CHIFFON:ColorSVG = new ColorSVG(0xfffacd, "LemonChiffon") ;
	
	static public var LIGHT_BLUE:ColorSVG = new ColorSVG(0xadd8e6, "LightBlue") ;
	
	static public var LIGHT_CORAL:ColorSVG = new ColorSVG(0xf08080, "LightCoral") ;
	
	static public var LIGHT_CYAN:ColorSVG = new ColorSVG(0xe0ffff, "LightCyan") ;
	
	static public var LIGHT_GOLDEN_ROD_YELLOW:ColorSVG = new ColorSVG(0xfafad2, "LightGoldenRodYellow") ;
		
	static public var LIGHT_GRAY:ColorSVG = new ColorSVG(0xd3d3d3, "LightGray") ;
	
	static public var LIGHT_GREEN:ColorSVG = new ColorSVG(0x90ee90, "LightGreen") ;
	
	static public var LIGHT_GREY:ColorSVG = new ColorSVG(0xd3d3d3, "LightGrey") ;
	
	static public var LIGHT_PINK:ColorSVG = new ColorSVG(0xffb6c1, "LightPink") ;
	
	static public var LIGHT_SALMON:ColorSVG = new ColorSVG(0xffa07a, "LightSalmon") ;
	
	static public var LIGHT_SEA_GREEN:ColorSVG = new ColorSVG(0x20b2aa, "LightSeaGreen") ;
	
	static public var LIGHT_SKY_BLUE:ColorSVG = new ColorSVG(0x87cefa, "LightSkyBlue") ;
	
	static public var LIGHT_SLATE_GRAY:ColorSVG = new ColorSVG(0x778899, "LightSlateGray") ;
	
	static public var LIGHT_SLATE_GREY:ColorSVG = new ColorSVG(0x778899, "LightSlateGrey") ;
	
	static public var LIGHT_STEEL_BLUE:ColorSVG = new ColorSVG(0xb0c4de, "LightSteelBlue") ;
	
	static public var LIGHT_YELLOW:ColorSVG = new ColorSVG(0xffffe0, "LightYellow") ;
	
	static public var LIME:ColorSVG = new ColorSVG(0x00FF00 , "Lime") ;
	
	static public var LIME_GREEN:ColorSVG = new ColorSVG(0x32cd32, "LimeGreen") ;
	
	static public var LINEN:ColorSVG = new ColorSVG(0xfaf0e6, "Linen") ;
	
	static public var MAGENTA:ColorSVG = new ColorSVG(0xff00ff, "Magenta") ;
	
	static public var MAROON:ColorSVG = new ColorSVG(0x800000 , "Maroon") ;
	
	static public var MEDIUM_AQUA_MARINE:ColorSVG = new ColorSVG(0x66cdaa, "MediumAquaMarine") ;
	
	static public var MEDIUM_BLUE:ColorSVG = new ColorSVG(0x0000cd, "MediumBlue") ;
	
	static public var MEDIUM_ORCHID:ColorSVG = new ColorSVG(0xba55d3, "MediumOrchid") ;
	
	static public var MEDIUM_PURPLE:ColorSVG = new ColorSVG(0x9370db, "MediumPurple") ;
	
	static public var MEDIUM_SEA_GREEN:ColorSVG = new ColorSVG(0x3cb371, "MediumSeaGreen") ;

	static public var MEDIUM_SLATE_BLUE:ColorSVG = new ColorSVG(0x7b68ee, "MediumSlateBlue") ;

	static public var MEDIUM_SPRING_GREEN:ColorSVG = new ColorSVG(0x00fa9a, "MediumSpringGreen") ;

	static public var MEDIUM_TURQUOISE:ColorSVG = new ColorSVG(0x48d1cc, "MediumTurquoise") ;

	static public var MEDIUM_VIOLET_RED:ColorSVG = new ColorSVG(0xc71585, "MediumVioletRed") ;

	static public var MIDNIGHT_BLUE:ColorSVG = new ColorSVG(0x191970, "MidnightBlue") ;

	static public var MINT_CREAM:ColorSVG = new ColorSVG(0xf5fffa, "MintCream") ;

	static public var MISTY_ROSE:ColorSVG = new ColorSVG(0xffe4e1, "MistyRose") ;

	static public var MOCCASIN:ColorSVG = new ColorSVG(0xffe4b5, "Moccasin") ;

	static public var NAVAJO_WHITE:ColorSVG = new ColorSVG(0xffdead, "NavajoWhite") ;
		
	static public var NAVY:ColorSVG = new ColorSVG(0x000080 , "Navy") ;
	
	static public var NONE:ColorSVG = new ColorSVG(null , "None") ;
	
	static public var OLD_LACE:ColorSVG = new ColorSVG(0xfdf5e6, "LodLace") ;
	
	static public var OLIVE:ColorSVG = new ColorSVG(0x808000 , "Olive") ;
	
	static public var OLIVE_DRAB:ColorSVG = new ColorSVG(0x6b8e23, "OliveDrab") ;
	
	static public var ORANGE:ColorSVG = new ColorSVG(0xffa500, "Orange") ;
	
	static public var ORANGE_RED:ColorSVG = new ColorSVG(0xff4500, "OrangeRed") ;
	
	static public var ORCHID:ColorSVG = new ColorSVG(0xda70d6, "Orchid") ;
	
	static public var PALE_GOLDEN_ROD:ColorSVG = new ColorSVG(0xeee8aa, "PaleGoldenRod") ;
	
	static public var PALE_GREEN:ColorSVG = new ColorSVG(0x98fb98, "PaleGreen") ;
	
	static public var PALE_TURQUOISE:ColorSVG = new ColorSVG(0xafeeee, "PaleTurquoise") ;
	
	static public var PALE_VIOLET_RED:ColorSVG = new ColorSVG(0xdb7093, "PaleVioletRed") ;
	
	static public var PAPAYA_WHIP:ColorSVG = new ColorSVG(0xffefd5, "PapayaWhip") ;
	
	static public var PEACHPUFF:ColorSVG = new ColorSVG(0xffdab9, "PeachPuff") ;
	
	static public var PERU:ColorSVG = new ColorSVG(0xcd853f, "Peru") ;
	
	static public var PINK:ColorSVG = new ColorSVG(0xffc0cb, "Pink") ;
	
	static public var PLUM:ColorSVG = new ColorSVG(0xdda0dd, "Plum") ;
	
	static public var POWDER_BLUE:ColorSVG = new ColorSVG(0xb0e0e6, "PowderBlue") ;
	
	static public var PURPLE:ColorSVG = new ColorSVG(0x800080 , "Purple") ;
	
	static public var RED:ColorSVG = new ColorSVG(0xFF0000 , "Red") ;
	
	static public var ROSY_BROWN:ColorSVG = new ColorSVG(0xbc8f8f, "RosyBrown") ;
	
	static public var ROYAL_BLUE:ColorSVG = new ColorSVG(0x4169e1, "RoyalBlue") ;
	
	static public var SADDLE_BROWN:ColorSVG = new ColorSVG(0x8b4513, "SaddleBrown") ;
	
	static public var SALMON:ColorSVG = new ColorSVG(0xfa8072, "Salmon") ;
	
	static public var SANDY_BROWN:ColorSVG = new ColorSVG(0xf4a460, "SandyBrown") ;
	
	static public var SEA_GREEN:ColorSVG = new ColorSVG(0x2e8b57, "SeaGreen") ;
	
	static public var SEA_SHELL:ColorSVG = new ColorSVG(0xfff5ee, "SeaShell") ;
	
	static public var SIENNA:ColorSVG = new ColorSVG(0xa0522d, "Sienna") ;
	
	static public var SILVER:ColorSVG = new ColorSVG(0xC0C0C0 , "Silver") ;
	
	static public var SKY_BLUE:ColorSVG = new ColorSVG(0x87ceeb, "SkyBlue") ;
	
	static public var SLATE_BLUE:ColorSVG = new ColorSVG(0x6a5acd, "SlateBlue") ;
	
	static public var SLATE_GRAY:ColorSVG = new ColorSVG(0x708090, "SlateGray") ;
	
	static public var SLATE_GREY:ColorSVG = new ColorSVG(0x708090, "SlateGrey") ;
	
	static public var SNOW:ColorSVG = new ColorSVG(0xFFFAFA, "Snow") ;

	static public var SPRING_GREEN:ColorSVG = new ColorSVG(0x00FF7F, "SpringGreen") ;

	static public var STEEL_BLUE:ColorSVG = new ColorSVG(0x4682b4, "SteelBlue") ;

	static public var TAN:ColorSVG = new ColorSVG(0xD2B48C, "Tan") ;

	static public var TEAL:ColorSVG = new ColorSVG(0x008080 , "Teal") ;

	static public var THISTLE:ColorSVG = new ColorSVG(0xD8BFD8, "Thistle") ;

	static public var TOMATO:ColorSVG = new ColorSVG(0xFF6347 , "Tomato") ;

	static public var TURQUOISE:ColorSVG = new ColorSVG(0x40E0D0 , "Turquoise") ;

	static public var VIOLET:ColorSVG = new ColorSVG(0xEE82EE, "Violet") ;

	static public var WHEAT:ColorSVG = new ColorSVG(0xF5DEB3, "Wheat") ;

	static public var WHITE:ColorSVG = new ColorSVG(0xFFFFFF , "White") ;
	
	static public var WHITE_SMOKE:ColorSVG = new ColorSVG(0xF5F5F5, "WhiteSmoke") ;
	
	static public var YELLOW:ColorSVG = new ColorSVG(0xFFFF00 , "Yellow") ;
	
	static public var YELLOW_GREEN:ColorSVG = new ColorSVG(0x9ACD32 , "YellowGreen") ;
	
	/**
	 * Returns true if the object passed in argument is in the map of ColorSVG elements.
	 * @return true if the object passed in argument is in the map of ColorSVG elements.
	 */
	static public function contains( o ):Boolean
	{
		if (o instanceof ColorSVG)
		{
			return ColorSVG.ELEMENTS.containsKey( o.name.toLowerCase() ) ;
		}
		else if (TypeUtil.typesMatch(o, String))
		{
			return ColorSVG.ELEMENTS.containsKey(o.toLowerCase()) ;
		}
		else
		{
			return false ;	
		}
	}
	
	/**
	 * Returns the current ColorSVG reference specified with the name passed in parameter.
	 * @return the current ColorSVG reference specified with the name passed in parameter.
	 */
	static public function get( name:String ):ColorSVG 
	{
		return ColorSVG.ELEMENTS.get(name.toLowerCase()) ;
	}

}