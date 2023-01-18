/**
 * com.sekati.log.ConsoleStyle
 * @version 1.3.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.BaseClip;
import com.sekati.draw.Rectangle;
import com.sekati.draw.Triangle;
import com.sekati.geom.Point;
import com.sekati.utils.ClassUtils;
import com.sekati.utils.TextUtils; 

/**
 * Singleton class defining {@link com.sekati.log.Console} style and layout.
 */
class com.sekati.log.ConsoleStyle {

	private static var _instance:ConsoleStyle;
	public var CW:Number = 900; 
	// console width
	public var CH:Number = 500; 
	// console height
	public var IW:Number = 889; 
	// item width
	public var IH:Number = 12; 
	// item height
	public var TH:Number = 14; 
	// text height
	
	// style definition
	public var CSS:Object = {
		console:{
			n:"___Console", x:0, y:0, w:CW, h:CH, minW:450, minH:150, maxW:Stage.width, maxH:Stage.height, bg:{n:"bgMc", x:0, y:0, w:CW, h:CH, c:0x1D1D1D, a:95}, head:{
				n:"headMc", x:0, y:0, w:CW, h:IH, isDraggable:false, bg:{n:"bcMc", x:0, y:0, w:CW, h:IH, c:0xFFFFFF, a:100}, textfields:{
					head:{n:"headTf", t:"com.sekati.log.Console", url:"http://sasapi.googlecode.com/", x:5, y:-1, w:500, h:TH, c:0x6C8297, a:100}
				}, fps:{n:"fpsMc", x:CW - 120, y:0, w:110, h:TH, updateRate:10, bg:{n:"bgMc", x:0, y:0, w:110, h:TH - 2, c:0xFFFFFF, a:0}, textfields:{
						trend_colors:{up:"#009900", down:"#CC0000"}, current_label:{n:"currentLabelTf", t:"current", x:0, y:-1, w:42, h:TH, c:0x6C8297, a:100}, current_fps:{n:"currentFpsTf", t:"00", html:true, x:32, y:-1, w:25, h:TH, c:0x6C8297, a:100}, average_label:{n:"averageLabelTf", t:"average", x:55, y:-1, w:42, h:TH, c:0x6C8297, a:100}, average_fps:{n:"averageFpsTf", t:"00", html:true, x:91, y:-1, w:25, h:TH, c:0x6C8297, a:100}
					}
				}				
			}, holder:{
				n:"holderMc", x:0, y:IH, w:0, h:0, list:{n:"listMc", x:0, y:0, w:0, h:0}, mask:{n:"maskMc", x:0, y:0, w:IW, h:CH - IH, c:0x00ffff, a:100}, gutter:{n:"gutterMc", x:CW - 10, y:0, w:10, h:CH - IH, c:0x000000, a:100}, bar:{n:"barMc", x:CW - 10, y:0, w:10, h:165, c:0x6C8297, a:100} // c:0xCC3300, a:30
			}, resizer:{n:"resizerMc", x:CW - 10, y:CH - 10, w:10, h:10, c:0xFFFFFF, a:100}
		}, item:{
			n:"itemMc", x:0, y:0, w:IW, h:IH, bg:{n:"bgMc", x:0, y:0, w:IW, h:IH, c:[ 0x202020, 0x000000 ], cindex:1, a:50}, line:{n:"lineMc", x:0, y:0, w:IW, h:1, c:0xFFFFFF, a:50}, textfields:{
				id:{n:"idTf", t:"id", x:5, y:0, w:30, h:TH, c:0x999999, a:100}, type:{n:"typeTf", t:"type", x:40, y:0, w:40, h:TH, a:100, c:{
					trace:0xFF00FF, info:0x00FFFF, status:0x99FF00, warn:0xFFFF00, error:0xFF9900, fatal:0xFF0000, object:0x9900FF, custom:0x0066FF}
				}, origin:{n:"originTf", t:"origin", selectable:false, x:85, y:0, w:90, h:TH, c:0x6C8297, a:100}, message:{n:"messageTf", t:"message", selectable:true, x:180, y:0, w:650, h:TH, c:0xF7F7F7, a:100}, benchmark:{n:"benchmarkTf", t:"benchmark", x:835, y:0, w:51, h:TH, c:0x999999, a:100}					
			}
		}, meta_item:{
			n:"metaItemMc", x:0, y:0, w:IW, h:IH, bg:{n:"bgMc", x:0, y:0, w:IW, h:IH, c:0x000000, a:95}, line:{n:"lineMc", x:0, y:0, w:IW, h:1, c:0xFFFFFF, a:50}, textfields:{
				id:{n:"idTf", t:"id", x:5, y:0, w:30, h:TH, c:0x666666, a:100}, type:{n:"typeTf", t:"type", x:40, y:0, w:40, h:TH, c:0x666666, a:100}, origin:{n:"originTf", t:"origin", x:85, y:0, w:90, h:TH, c:0x666666, a:100}, message:{n:"messageTf", t:"message", x:180, y:0, w:650, h:TH, c:0x666666, a:100}, benchmark:{n:"benchmarkTf", t:"benchmark", x:835, y:0, w:51, h:TH, c:0x666666, a:100}					
			}
		}
	};	

	/**
	 * Singleton Private Constructor
	 */
	private function ConsoleStyle() {
	}

	/**
	 * Singleton Accessor
	 * @return ConsoleStyle
	 */	
	public static function getInstance():ConsoleStyle {
		if (!_instance) _instance = new ConsoleStyle( );
		return _instance;
	}

	/**
	 * Shorthand Singleton Accessor Getter
	 */
	public static function get $():ConsoleStyle {
		return ConsoleStyle.getInstance( );	
	}	

	/**
	 * Create an empty BaseClip - but do not inherit x,y,w,h from 'style' arg.
	 * @param target (MovieClip)
	 * @param style (Object) ConsoleStyle.CSS reference obj
	 * @return MovieClip
	 * {@code Usage:
	 * 	ar e:MovieClip = ConsoleStyle.$.createClip(_root, ConsoleStyle.$.CSS.console.item.bg);
	 * }
	 */
	public function createClip(target:MovieClip, style:Object):MovieClip {
		return ClassUtils.createEmptyMovieClip( com.sekati.display.BaseClip, target, style.n );
	}

	/**
	 * Create an empty BaseClip which inherits x,y from 'style' arg.
	 * @param target (MovieClip)
	 * @param style (Object) ConsoleStyle.CSS reference obj
	 * @return MovieClip
	 * {@code Usage:
	 * 	ar e:MovieClip = ConsoleStyle.$.createPositionClip(_root, ConsoleStyle.$.CSS.console.container);
	 * }
	 */
	public function createPositionClip(target:MovieClip, style:Object):MovieClip {
		return ClassUtils.createEmptyMovieClip( com.sekati.display.BaseClip, target, style.n, {_x:style.x, _y:style.y, _alpha:style.a} );
	}

	/**
	 * Create a styled rectangle BaseClip
	 * @param target (MovieClip)
	 * @param style (Object) ConsoleStyle.CSS reference obj
	 * @return MovieClip
	 * {@code Usage:
	 * 	var r:MovieClip = ConsoleStyle.$.createStyledRectangle (_this, ConsoleStyle.$.CSS.item.bg);
	 * }
	 */
	public function createStyledRectangle(target:MovieClip, style:Object):MovieClip {
		// create the shape container clip
		var r:MovieClip = createClip( target, style );	
		// sanitize style.c - if it is an array (instead of a number) it means we need to alternate colors with style.cindex
		var c:Number = (style.c instanceof Array) ? alternateItemBgColor( ) : style.c;
		//trace("drawing rect: "+style.n+": "+c);
		Rectangle.draw( r, new Point( 0, 0 ), new Point( style.w, style.h ), c, style.a );
		r._x = style.x;
		r._y = style.y;
		return r;
	}

	/**
	 * Create a styled triangle BaseClip
	 * @param target (MovieClip)
	 * @param style (Object) ConsoleStyle.CSS reference obj
	 * @return MovieClip
	 */
	public function createStyledTriangle(target:MovieClip, style:Object):MovieClip {
		var t:MovieClip = createClip( target, style );
		Triangle.draw( t, new Point( style.w, style.h ), new Point( 0, style.h ), new Point( style.w, 0 ), style.c, style.a, 0 );
		t._x = style.x;
		t._y = style.y;
		return t;	
	}

	/**
	 * Alternate the item bg color to create "zebra striped" item entries.
	 * @return Number - item bg color
	 */
	private function alternateItemBgColor():Number {
		CSS.item.bg.cindex = (CSS.item.bg.cindex == 1) ? 0 : 1;
		//trace("alternateColor ["+CSS.item.bg.cindex+"] called: "+CSS.item.bg.c[CSS.item.bg.cindex]);
		return CSS.item.bg.c[CSS.item.bg.cindex];
	}	

	/**
	 * Create a styled textfield
	 * @param target (MovieClip)
	 * @param style (Object) ConsoleStyle.CSS reference obj
	 * @param str (String) contents of textfield [i.e. "trace"]
	 * @return TextField
	 * {@code Usage:
	 * 	var tf:TextField = ConsoleStyle.$.createStyledTextField(_this, ConsoleStyle.$.CSS.item.textfields.origin, "hello world");
	 * }
	 */
	public function createStyledTextField(target:MovieClip, style:Object, str:String):TextField {
		// if no 'str' arg was passed use default style.t text
		var s:String = (str != undefined) ? str : style.t;
		// if style.c is an Object (instead of number) assume we are a message type and resolve the color based on 'str' arg.
		var c:Number = (!isNaN( style.c )) ? style.c : resolveTypeColor( str );
		// if 'messageTf' || 'originTf' then make autoSize, multiLine, wordWrap, selectable true; else default to false.
		var isSizable:Boolean = (style.n == CSS.item.textfields.message.n || style.n == CSS.item.textfields.origin.n);
		// see if we want to be an html textfield
		var isHtml:Boolean = (style.html == true) ? true : false;
		// see if we want a selectable textfield
		var isSelectable:Boolean = (style.selectable == true) ? true : false;
		// build properties and format objects
		var props:Object = {type:"dynamic", html:isHtml, autoSize:isSizable, wordWrap:isSizable, multiline:isSizable, selectable:isSelectable, mouseWheelEnabled:false, embedFonts:false, _alpha:style.a, htmlText:s};		
		var format:Object = {font:"Arial", size:9, color:c};
		// create the TextField now that we have good properties, formats and string.
		var t:TextField = TextUtils.create( target, style.n, style.x, style.y, style.w, style.h, props, format );
		return t;
	}		

	/**
	 * Compare the type string argument to those existing in the ConsoleStyle.COLOR.item.textfields.type style,
	 * if one matches return it, else default to the 'custom' style.
	 * @param type (String) type as string
	 * @return Number
	 * {@code Usage:
	 * 	var c:Number = resolveTypeColor("trace"); // returns CSS.item.textfields.type.c.trace
	 * 	var c:Number = resolveTypeColor("sekati"); // returns CSS.item.textfields.type.c.custom
	 * }
	 */
	private function resolveTypeColor(type:String):Number {
		var t:String = type.toLowerCase( );
		var c:Number = (!CSS.item.textfields.type.c[t]) ? CSS.item.textfields.type.c.custom : CSS.item.textfields.type.c[t];
		//trace("resolveTypeColor: "+t+": "+ c);
		return c;
	}
}