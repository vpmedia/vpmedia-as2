/**
 * @class       com.wis.types.ColMC
 * @author      Richard Wright
 * @version     1.7
 * @description Implements the behaviours of the ColMC Class.
 *              <p>
 *              The Col class, which supports the methods of this class, isn't
 *              very user-friendly, requiring an instance of an mc with a 'Color'
 *              object already applied to it. ColMC can be instantiated dynamically
 *              with the use of the static methods of Ted Patrick's MCE class, which
 *              should be placed into the default-level folder of your classpath.
 *              MCE.as is included in the wisASLibrary bundle downloads .. thanks
 *              to Ted! [ted AT powersdk DOT com]
 *              <blockquote><pre>
 *              // MCE dynamic class instantiation:
 *              MCE.attach(scope,depth,name[,linkage][,initObj][,class][,classArguments]);
 *              </pre></blockquote>
 *              <p>
 *		        I've swayed from using '$' as a class-based variable identifier for
 *              this class due to the increased usage of UI-defined class variables
 *              for this group of classes: Point, Vector, Col, and ColMC classes
 *              all reflect this format.
 * @usage       <blockquote>var inst:ColMC = new ColMC()</pre>
 * @param       none  -- no class input parameters, uses setters instead.
 * -----------------------------------------------
 * Latest update: August 5, 2004
 * -----------------------------------------------
 * Dependency:  com.wis.types.Col
 * -----------------------------------------------
 * AS2 revision copyright © 2004, Richard Wright [wisolutions2002@shaw.ca]
 * AS1 original copyright © 2003, Robert Penner  [www.robertpenner.com]
 * -----------------------------------------------
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     - Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *
 *     - Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 *     - Neither the name of this software nor the names of its contributors
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * -----------------------------------------------
 *   Functions:
 *       ColMC()
 *       - getter/setters
 *           1.  set _rgb(col)
 *           2.  get _rgb()
 *           3.  set _rgbStr(hexStr)
 *           4.  get _rgbStr()
 *           5.  set _rgb2(obj) //(r,g,b)
 *           6.  get _rgb2()
 *           7.  set _colTransform(trans)
 *           8.  get _colTransform()
 *           9.  set _brightness(bright)
 *           10. get _brightness()
 *           11. set _brightOffset(offset)
 *           12. get _brightOffset()
 *           13. set _tint(obj) //(r,g,b,percent)
 *           14. get _tint()
 *           15. set _tint2(obj) //(rgb,percent)
 *           16. get _tint2()
 *           17. set _tintOffset(obj) //(r,g,b)
 *           18. get _tintOffset()
 *           19. set _negColor(percent)
 *           20. get _negColor()
 *           21. set _red(amount)
 *           22. get _red()
 *           23. set _green(amount)
 *           24. get _green()
 *           25. set _blue(amount)
 *           26. get _blue()
 *           27. set _redPercent(percent)
 *           28. get _redPercent()
 *           29. set _greenPercent(percent)
 *           30. get _greenPercent()
 *           31. set _bluePercent(percent)
 *           32. get _bluePercent()
 *           33. set _redOffset(offset)
 *           34. get _redOffset()
 *           35. set _greenOffset(offset)
 *           36. get _greenOffset()
 *           37. set _blueOffset(offset)
 *           38. get _blueOffset()
 *           39. resetColor()
 *           40. invertColor()
 * -----------------------------------------------
 * Discussed in Chapter 9 of
 * Robert Penner's Programming Macromedia Flash MX
 * http://www.robertpenner.com/profmx
 * http://www.amazon.com/exec/obidos/ASIN/0072223561/robertpennerc-20
 * -----------------------------------------------
 * Updates may be available at:
 *              http://members.shaw.ca/flashprogramming/wisASLibrary/wis/
 * -----------------------------------------------
**/

import com.wis.types.Col;

class com.wis.types.ColMC extends MovieClip
{
	/**
	 * @property $target (Color) private
    **/
    private var $target:Color;

    function ColMC()
    {
        //trace ("ColMC Class loaded");
        $target = new Color(this);
    }

////////////////////////////////
// Getter/Setters
////////////////////////////////

// 1. set _rgb -----------------------------------

    /**
     * @method  set _rgb
     * @description  Sets class instance Color object using rgb number.
     * @usage  <pre>inst._rgb = rgbNum;</pre>
     * @param   rgb   (Number)  -- decimal or hexadecimal color value input.
     * @return  (Void)
    **/
    function set _rgb(rgb:Number):Void
    {
    	//(new Col($target)).setRGB(col);
    	$target.setRGB(rgb);
    }

// 2. get _rgb -----------------------------------

    /**
     * @method  get _rgb
     * @description  Gets value of class instance Color object.
     * @usage  <pre>inst._rgb;</pre>
     * @return  (Number)  -- returns decimal color value.
    **/
    function get _rgb():Number
    {
    	//return (new Col(this)).getRGB();
    	return $target.getRGB();
    }

// 3. set _rgbStr --------------------------------

    /**
     * @method  set _rgbStr
     * @description  Sets class instance Color object using hex string.
     * @usage  <pre>inst._rgbStr = hexStr;</pre>
     * @param   hexStr   (String)   -- html hex string ("#------").
     * @return  (Void)
    **/
    function set _rgbStr(hexStr:String):Void
    {
    	(new Col($target))._rgbStr = hexStr;
    }

// 4. get _rgbStr --------------------------------

    /**
     * @method  get _rgbStr
     * @description  Gets value of class instance Color object.
     * @usage  <pre>inst._rgbStr;</pre>
     * @return  (String)  -- returns string representation of color object value.
    **/
    function get _rgbStr():String
    {
    	return (new Col($target))._rgbStr;
    }

// 5. set _rgb2 ----------------------------------

    /**
     * @method  set _rgb2
     * @description  Sets red, green, and blue with normal numbers contained
     *               in an object.
     * @usage  <pre>inst._rgb2 = rgbObj;</pre>
     * @param   obj   (Object)   object: r, g, b between 0 and 255
     * @return  (Void)
    **/
    function set _rgb2(obj:Object):Void
    {
    	(new Col($target))._rgb2 = {r:obj.r,g:obj.g,b:obj.b};
    }

// 6. get _rgb2 ----------------------------------

    /**
     * @method  get _rgb2
     * @description  Gets the class instance r, g, and b properties.
     * @usage  <pre>inst._rgb2;</pre>
     * @return  (Object)  -- returns an object with r, g, and b properties.
    **/
    function get _rgb2():Object
    {
    	return (new Col($target))._rgb2;
    }

// 7. set _colTransform --------------------------

    /**
     * @method  set _colTransform
     * @description  Sets the class instance target's color transform.
     * @usage  <pre>inst._colTransform = transObj;</pre>
     * @param   trans   (Object)  -- an object containing color transform properties.
     * @return  (Void)
    **/
    function set _colTransform(trans:Object):Void
    {
    	$target.setTransform(trans);
    }

// 8. get _colTransform --------------------------

    /**
     * @method  get _colTransform
     * @description  Gets the class instance target's color transform.
     * @usage  <pre>inst._colTransform;</pre>
     * @return  (Object)  -- returns an object containing color transform properties.
    **/
    function get _colTransform():Object
    {
    	return $target.getTransform();
    }

// 9. set brightness -----------------------------

    /**
     * @method  set _brightness
     * @description  Sets brightness percent just like Property Inspector.
     * @usage  <pre>inst._brightness = brightNum;</pre>
     * @param   bright   (Number)  -- a percent value between -100 and 100.
     * @return  (Void)
    **/
    function set _brightness(bright:Number):Void
    {
    	(new Col($target))._brightness = bright;
    }

// 10. get _brightness ---------------------------

    /**
     * @method  get _brightness
     * @description  Gets brightness percent just like Property Inspector.
     * @usage  <pre>inst._brightness;</pre>
     * @return  (Number)  -- returns brightness percent between -100 and 100.
    **/
    function get _brightness():Number
    {
    	return (new Col($target))._brightness;
    }

// 11. set _brightOffset -------------------------

    /**
     * @method  set _brightOffset
     * @description  Sets brightness offset just like Property Inspector.
     * @usage  <pre>inst._brightOffset = offsetNum;</pre>
     * @param   offset   (Number)  -- an offset value between -255 and 255.
     * @return  (Void)
    **/
    function set _brightOffset(offset:Number):Void
    {
    	//return (new Col(this)).set _brightOffset(offset);
    	(new Col($target))._brightOffset = offset;
    }

// 12. get _brightOffset --------------------------

    /**
     * @method  get _brightOffset
     * @description  Gets brightness offset just like Property Inspector.
     * @usage  <pre>inst._brightOffset;</pre>
     * @return  (Number)  -- returns brightness offset between -255 and 255.
    **/
    function get _brightOffset():Number
    {
        return (new Col($target))._brightOffset;
    }

// 13. set _tint ----------------------------------

    // - tint with a color just like Property Inspector
    // r, g, b between 0 and 255; percent between 0 and 100

    /**
     * @method  set _tint
     * @description  Sets tint with r, g, b, percent values.
     * @usage  <pre>inst._tint = tintObj;</pre>
     * @param   obj   (Object)  -- contains r, g, b, percent values.
     * @return  (Void)
    **/
    //function set _tint({r:Number,g:Number,b:Number,percent:Number}):Void
    function set _tint(obj:Object):Void
    {
    	(new Col($target))._tint = {r:obj.r,g:obj.g,b:obj.b,percent:obj.percent};
    }

// 14. get _tint ----------------------------------

    /**
     * @method  get _tint
     * @description  Gets tint with r, g, b, and percent values.
     * @usage  <pre>inst._tint;</pre>
     * @return  (Object)  -- returns an object with r, g, b, and percent properties.
    **/
    function get _tint():Object
    {
    	return (new Col($target))._tint;
    }

// 15. set _tint2 ---------------------------------

    /**
     * @method  set _tint2
     * @description  Sets tint with a color with rgb and percent values.
     * @usage  <pre>inst._tint2 = tint2Obj;</pre>
     * @param   obj   (Object)  -- a color number between 0 and 0xFFFFFF; percent between 0 and 100
     * @return  (Void)
    **/
    //function set _tint2(rgb:Number,percent:Number):Void
    function set _tint2(obj:Object):Void
    {
    	(new Col($target))._tint2 = {rgb:obj.rgb,percent:obj.percent};
    }

// 16. get _tint2  --------------------------------

    /**
     * @method  get _tint2
     * @description  Gets tint with a color with rgb and percent values.
     * @usage  <pre>inst._tint2;</pre>
     * @return  (Object) -- returns a tint object containing rgb (a 0xFFFFFF
     *                      number) and percent properties.
    **/
    function get _tint2():Object
    {
    	return (new Col($target))._tint2;
    }

// 17. set _tintOffset ----------------------------

    /**
     * @method  set _tintOffset
     * @description  Sets tint offset with r, g, and b between -255 and 255.
     * @usage  <pre>inst._tintOffset = rgbObj;</pre>
     * @param   obj   (Object)  -- contains r, g, and b  values.
     * @return  (Void)
    **/
    //function set _tintOffset(r:Number,g:Number,b:Number):Void
    function set _tintOffset(obj:Object):Void
    {
    	(new Col($target))._tintOffset = {r:obj.r,g:obj.g,b:obj.b};
    }

// 18. get _tintOffset ----------------------------

    // - returns a tint offset object containing r, g, and b properties

    /**
     * @method  get _tintOffset
     * @description  Gets tint offset with r, g, and b properties.
     * @usage  <pre>inst._tintOffset;</pre>
     * @return  (Object)  -- returns an object with r, g, and b between -255 and 255.
    **/
    function get _tintOffset():Object
    {
    	return (new Col($target))._tintOffset;
    }

// 19. set _negColor ------------------------------

    /**
     * @method  set _negColor
     * @description  Sets a negative image of the normal appearance.
     * @usage  <pre>inst._negColor = percentNum;</pre>
     * @param   percent   (Number)  -- a value between -100 and 100.
     * @return  (Void)
    **/
    function set _negColor(percent:Number):Void
    {
        (new Col($target))._negative = percent;
    }

// 20. get _negColor ------------------------------

    /**
     * @method  get _negColor
     * @description  Gets a negative image of the normal appearance.
     * @usage  <pre>inst._negColor;</pre>
     * @return  (Number)  -- returns a negative image of the normal appearance.
    **/
    function get _negColor():Number
    {
        return (new Col($target))._negative;
    }

// 21. set _red -----------------------------------

    /**
     * @method  set _red
     * @description  Sets red portion of the color object.
     * @usage  <pre>inst._red = amtNum;</pre>
     * @param   amount   (Number)  -- a value between 0 and 255.
     * @return  (Void)
    **/
    function set _red(amount:Number):Void
    {
    	(new Col($target))._red = amount;
    }

// 22. get _red -----------------------------------

    /**
     * @method  get _red
     * @description  Gets red portion of the color object.
     * @usage  <pre>inst._red;</pre>
     * @return  (Number)  -- returns a value between 0 and 255.
    **/
    function get _red():Number
    {
    	return (new Col($target))._red;
    }

// 23. set _green ---------------------------------

    /**
     * @method  set _green
     * @description  Sets green portion of the color object.
     * @usage  <pre>inst._green = amtNum;</pre>
     * @param   amount   (Number)  -- a value between 0 and 255.
     * @return  (Void)
    **/
    function set _green(amount:Number):Void
    {
    	(new Col($target))._green = amount;
    }

// 24. get _green ---------------------------------

    /**
     * @method  get _green
     * @description  Gets green portion of the color object.
     * @usage  <pre>inst._green;</pre>
     * @return  (Number)  -- returns a value between 0 and 255.
    **/
    function get _green():Number
    {
    	return (new Col($target))._green;
    }

// 25. set _blue ----------------------------------

    /**
     * @method  set _blue
     * @description  Sets blue portion of the color object.
     * @usage  <pre>inst._blue = amtNum;</pre>
     * @param   amount   (Number)  -- a value between 0 and 255.
     * @return  (Void)  -- returns a value between 0 and 255.
    **/
    function set _blue(amount:Number):Void
    {
    	(new Col($target))._blue = amount;
    }

// 26. get _blue ----------------------------------

    /**
     * @method  get _blue
     * @description  Sets blue portion of the color object.
     * @usage  <pre>inst._blue;</pre>
     * @return  (Number)  -- returns a value between 0 and 255.
    **/
    function get _blue():Number
    {
    	return (new Col($target))._blue;
    }

// 27. set _redPercent ----------------------------

    /**
     * @method  set _redPercent
     * @description  Sets red percentage of the color object.
     * @usage  <pre>inst._redPercent = percentNum;</pre>
     * @param   percent   (Number)  -- a value between -100 and 100.
     * @return  (Void)
    **/
    function set _redPercent(percent:Number):Void
    {
    	(new Col($target))._redPercent = percent;
    }

// 28. get _redPercent ----------------------------

    /**
     * @method  get _redPercent
     * @description  Gets red percentage of the color object.
     * @usage  <pre>inst._redPercent;</pre>
     * @return  (Number)  -- returns a value between -100 and 100.
    **/
    function get _redPercent():Number
    {
    	return (new Col($target))._redPercent;
    }

// 29. set _greenPercent --------------------------

    /**
     * @method  set _greenPercent
     * @description  Sets green percentage of the color object.
     * @usage  <pre>inst._greenPercent = percentNum;</pre>
     * @param   percent   (Number)  -- a value between -100 and 100.
     * @return  (Void)
    **/
    function set _greenPercent(percent:Number):Void
    {
    	(new Col($target))._greenPercent = percent;
    }

// 30. get _greenPercent --------------------------

    /**
     * @method  get _greenPercent
     * @description  Gets green percentage of the color object.
     * @usage  <pre>inst._greenPercent;</pre>
     * @return  (Number)  -- returns a value between -100 and 100.
    **/
    function get _greenPercent():Number
    {
    	return (new Col($target))._greenPercent;
    }

// 31. set _bluePercent ---------------------------

    /**
     * @method  set _bluePercent
     * @description  Sets blue percentage of the color object.
     * @usage  <pre>inst._bluePercent = percentNum;</pre>
     * @param   percent   (Number)-- a value between -100 and 100.
     * @return  (Void)
    **/
    function set _bluePercent(percent:Number):Void
    {
    	(new Col($target))._bluePercent = percent;
    }

// 32. get _bluePercent ---------------------------

    /**
     * @method  get _bluePercent
     * @description  Gets blue percentage of the color object.
     * @usage  <pre>inst._bluePercent;</pre>
     * @return  (Number)  -- returns a value between -100 and 100.
    **/
    function get _bluePercent():Number
    {
    	return (new Col($target))._bluePercent;
    }

// 33. set _redOffset -----------------------------

    /**
     * @method  set _redOffset
     * @description  Sets red offset of the color object.
     * @usage  <pre>inst._redOffset = offsetNum;</pre>
     * @param   offset   (Number)  -- a value between -255 and 255.
     * @return  (Void)
    **/
    function set _redOffset(offset:Number):Void
    {
    	(new Col($target))._redOffset = offset;
    }

// 34. get _redOffset -----------------------------

    /**
     * @method  get _redOffset
     * @description  Gets red offset of the color object.
     * @usage  <pre>inst._redOffset;</pre>
     * @return  (Number)  -- returns a value between -255 and 255.
    **/
    function get _redOffset():Number
    {
    	return (new Col($target))._redOffset;
    }

// 35. set _greenOffset ---------------------------

    /**
     * @method  set _greenOffset
     * @description  Sets green offset of the color object.
     * @usage  <pre>inst._greenOffset = offsetNum;</pre>
     * @param   offset   (Number)  -- a value between -255 and 255.
     * @return  (Void)
    **/
    function set _greenOffset(offset:Number):Void
    {
    	(new Col($target))._greenOffset = offset;
    }

// 36. get _greenOffset ---------------------------

    /**
     * @method  get _greenOffset
     * @description  Gets green offset of the color object.
     * @usage  <pre>inst._greenOffset;</pre>
     * @return  (Number)  -- returns a value between -255 and 255.
    **/
    function get _greenOffset():Number
    {
    	return (new Col($target))._greenOffset;
    }

// 37. set _blueOffset ----------------------------

    /**
     * @method  set _blueOffset
     * @description  Sets blue offset of the color object.
     * @usage  <pre>inst._blueOffset = offsetNum;</pre>
     * @param   offset   (Number)  -- a value between -255 and 255.
     * @return  (Void)
    **/
    function set _blueOffset(offset:Number):Void
    {
    	(new Col($target))._blueOffset = offset;
    }

// 38. get _blueOffset ----------------------------

    /**
     * @method  get _blueOffset
     * @description  Gets blue offset of the color object.
     * @usage  <pre>inst._blueOffset;</pre>
     * @return  (Number)  -- returns a value between -255 and 255.
    **/
    function get _blueOffset():Number
    {
    	return (new Col($target))._blueOffset;
    }

// 39. resetColor ---------------------------------

    /**
     * @method  resetColor
     * @description  Reset current color values.
     * @usage  <pre>inst.resetColor();</pre>
     * @return  (Void)
    **/
    function resetColor():Void
    {
    	(new Col($target)).reset();
    }

//  40. invertColor -------------------------------

    // - invert current color values

    /**
     * @method  invertColor
     * @description  Invert current color values.
     * @usage  <pre>inst.invertColor();</pre>
     * @return  (Void)
    **/
    function invertColor():Void
    {
    	(new Col($target)).invert();
    }

}

