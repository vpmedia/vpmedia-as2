/**
 * @class       com.wis.types.Col
 * @author      Richard Wright
 * @version     1.7
 * @description Implements the behaviours of the Col Class.
 *              <p>
 *              This class isn't very user-friendly, requiring an instance of an mc
 *              with a 'Color' object already applied to it. However, the Col class
 *              supports the methods of the ColMC class, which is much more
 *              user-friendly. It can be instantiated dynamically with the use of
 *              the static methods of Ted Patrick's MCE class, which should be
 *              placed into the default-level folder of your classpath. MCE.as is
 *              included in the wisASLibrary bundle downloads .. thanks to Ted!
 *              [ted AT powersdk DOT com]
 *              <blockquote><pre>
 *              // MCE dynamic class instantiation:
 *              MCE.attach(scope,depth,name[,linkage][,initObj][,class][,classArguments]);
 *              </pre></blockquote>
 *              <p>
 *		        I've swayed from using '$' as a class-based variable identifier for
 *              this class due to the increased usage of UI-defined class variables
 *              for this group of classes: Point, Vector, Col, and ColMC classes
 *              all reflect this format.
 * @usage       <pre>
 *              // to initialize Col class and target without MCE ColMC class instantiation
 *              var targ:Color = new Color(clip);
 *              var inst:Col = new Col(targ,red,green,blue);
 *              </pre>
 * @param       target (Color)  -- color object passed from UI or ColMC class
 * @param       red (Number)  -- value for red portion of color (0-255)
 * @param       green (Number)  -- value for green portion of color (0-255)
 * @param       blue (Number)  -- value for blue portion of color (0-255)
 * -----------------------------------------------
 * Latest update: August 5, 2004
 * -----------------------------------------------
 * AS2 revision copyright ? 2004, Richard Wright [wisolutions2002@shaw.ca]
 * AS1 original copyright ? 2003, Robert Penner  [www.robertpenner.com]
 *                        ? 2002, Gary Fixler    [amf@garyfixler.com]
 *                        ? 2001, Branden Hall   [http://www.waxpraxis.org]
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
 *       Col(target,red,green,blue):
 *           1.  init(red,green,blue)
 *           2.  reset()
 *           3.  invert()
 *           4.  resetVal(red,green,blue)
 *           5.  copy()
 *           6.  clip()
 *           7.  twoChars(num)
 *           8.  toString()
 *           9.  difference(c2)
 *           10. neg()
 *           11. mult(c2)
 *           12. scalar(s)
 *           13. adds(c2)
 *        - getter/setters
 *           14. set _rgbStr(hexStr)
 *           15. get _rgbStr()
 *           16. set _rgb2(obj) //(r,g,b)
 *  	     17. get _rgb2()
 *           18. set _brightness(bright)
 *           19. get _brightness()
 *           20. set _brightOffset(offset)
 *           21. get _brightOffset()
 *           22. set _tint(obj) //(r,g,b,percent)
 *           23. get _tint()
 *           24. set _tint2(obj) //(rgb,percent)
 *           25. get _tint2()
 *           26. set _tintOffset(obj) //(r,g,b)
 *           27. get _tintOffset()
 *           28. set _negative(percent)
 *           29. get _negative()
 *           30. set _red(amount)
 *           31. get _red()
 *           32. set _green(amount)
 *           33. get _green()
 *           34. set _blue(amount)
 *           35. get _blue()
 *           36. set _redPercent(percent)
 *           37. get _redPercent()
 *           38. set _greenPercent(percent)
 *           39. get _greenPercent()
 *           40. set _bluePercent(percent)
 *           41. get _bluePercent()
 *           42. set _redOffset(offset)
 *           43. get _redOffset()
 *           44. set _greenOffset(offset)
 *           45. get _greenOffset()
 *           46. set _blueOffset(offset)
 *           47. get _blueOffset()
 *           48. get _htmlStr()
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

class com.wis.types.Col
{
	/**
	 * @property r (Number)  -- value for red portion of color (0-255).
	 * @property g (Number)  -- value for green portion of color (0-255).
	 * @property b (Number)  -- value for blue portion of color (0-255).
	 * @property ra (Number)  -- the percentage for the red component (-100 to 100).
	 * @property ga (Number)  -- the percentage for the green component (-100 to 100).
	 * @property ba (Number)  -- the percentage for the blue component (-100 to 100).
	 * @property rb (Number)  -- the offset for the red component (-255 to 255).
	 * @property gb (Number)  -- the offset for the green component (-255 to 255).
	 * @property bb (Number)  -- the offset for the blue component (-255 to 255).
	 * @property $target (Color)  -- private color object.
    **/
    var r:Number;
    var g:Number;
    var b:Number;
    var ra:Number;
    var ga:Number;
    var ba:Number;
    var rb:Number;
    var gb:Number;
    var bb:Number;
    private var $target:Color;

    // constructor
    function Col(target:Color,red:Number,green:Number,blue:Number)
    {
        //trace ("Col Class fired");
        $target = target;
        if (arguments.length>1) init(red,green,blue);
    }

// 1. init ---------------------------------------

    /**
     * @method  init
     * @description If arguments are passed, initializes r, g, and b properties,
     *              then calls the setter _rgb2 to populate the private $target.
     * @usage  <pre>inst.init(red,green,blue);</pre>
     * @param   red   (Number)   -- value for red portion of color (0-255).
     * @param   green   (Number)   -- value for green portion of color (0-255).
     * @param   blue   (Number)   -- value for blue portion of color (0-255).
     * @return  (Void)
    **/
    function init(red:Number,green:Number,blue:Number):Void
    {
        r = red;
		g = green;
        b = blue;
        _rgb2({r:r,g:g,b:b});
    }

// 2. reset --------------------------------------

    /**
     * @method  reset
     * @description  Resets the color object to normal; 100 percent and 0 offset.
     * @usage  <pre>inst.reset()</pre>
     * @return  (Void)
    **/
    function reset():Void
    {
    	$target.setTransform({ra:100,ga:100,ba:100,rb:0,gb:0,bb:0});
    }

// 3. invert -----------------------------------

    /**
     * @method  invert
     * @description  Invert the current color values.
     * @usage  <pre>inst.invert();</pre>
     * @return  (Void)
    **/
    function invert():Void
    {
    	var trans:Object = $target.getTransform();

    	trans.ra = -trans.ra;
		trans.ga = -trans.ga;
		trans.ba = -trans.ba;
		trans.rb = 255-trans.rb;
		trans.gb = 255-trans.gb;
        trans.bb = 255-trans.bb;
    	$target.setTransform(trans);
    }

// 4. resetVal --------------------------------

    /**
     * @method  resetVal
     * @description  Resets r, g, and b properties, then calls the setter
     *               _rgb2 to re-populate the private $target.
     * @usage  <pre>inst.resetVal(red,green,blue);</pre>
     * @param   red   (Number)   -- value for red portion of color (0-255).
     * @param   green   (Number)   -- value for green portion of color (0-255).
     * @param   blue   (Number)   -- value for blue portion of color (0-255).
     * @return  (Void)
    **/
    function resetVal(red:Number,green:Number,blue:Number):Void
    {
        r = red;
        g = green;
        b = blue;
        _rgb2({r:r,g:g,b:b});
    }

// 5. copy ------------------------------------

    /**
     * @method  copy
     * @description Copies the class instance.
     * @usage  <pre>inst.copy();</pre>
     * @return  (Col)  -- returns a copy of the class instance.
    **/
    function copy():Col
    {
        return new Col($target,r,g,b);
    }

// 6. clip ------------------------------------

    /**
     * @method  clip
     * @description  Clips r, g, and b values to a range (0 - 1).
     * @usage  <pre>inst.clip();</pre>
     * @return  (Void)
    **/
    function clip():Void
    {
        var allLight:Number = r+g+b;
        var excessLight:Number = allLight-3;

        if (excessLight>0)
        {
            r += excessLight*(r/allLight);
            g += excessLight*(g/allLight);
			b += excessLight*(b/allLight);
        }
        if (r>1) r = 1;
        if (g>1) g = 1;
        if (b>1) b = 1;
        if (r<0) r = 0;
        if (g<0) g = 0;
        if (b<0) b = 0;
    }

// 7. twoChars --------------------------------

    /**
     * @method  twoChars
     * @description  Formats input by padding single characters with a preceding '0'.
     * @usage  <pre>inst.twoChars(sNum)</pre>
     * @param   sNum   (String)  -- hexadecimal string representation.
     * @return  (String)  -- returns a 2 character string, padding single characters with a preceding '0'.
    **/
    function twoChars(sNum:String):String
    {
        sNum = ""+sNum;
        if (sNum.length==1) sNum = "0"+sNum;

        return sNum;
    }

// 8. toString -------------------------------

    /**
     * @method  toString
     * @description  Overrides UIObject.toString() method.
     * @usage  <pre>inst.toString();</pre>
     * @return  (String)  -- returns an html string representation of the color object.
    **/
    function toString():String
    {
        return _htmlStr();
    }

// 9. difference -----------------------------

    /**
     * @method  difference
     * @description  Creates a new class instance for the existing target.
     * @usage  <pre>inst.difference(c2);</pre>
     * @param   c2   (Col)  -- object to compare with the existing class instance.
     * @return  (Col)  -- returns a new class instance based on the difference between input and present class instance r, g, and b values.
    **/
    function difference(c2:Col):Col
    {
        return new Col($target,Math.abs(r-c2.r),Math.abs(g-c2.g),Math.abs(b-c2.b));
    }

// 10. neg ------------------------------------

    /**
     * @method  neg
     * @description  Creates a new class instance for the existing target.
     * @usage  <pre>inst.neg();</pre>
     * @return  (Col)  -- returns a new class instance based on the negatives of the existing r, g, and b values.
    **/
    function neg():Col
    {
        return new Col($target,-r,-g,-b);
    }

// 11. mult -----------------------------------

    /**
     * @method  mult
     * @description  Creates a new class instance for the existing target.
     * @usage  <pre>inst.mult(c2);</pre>
     * @param   c2   (Col)  -- object to compare with the existing class instance.
     * @return  (Col)  -- returns a new class instance based on the multiplication of the existing r, g, and b values and the input object.
    **/
    function mult(c2:Col):Col
    {
        return new Col($target,r*c2.r,g*c2.g,b*c2.b);
    }

// 12. scalar ---------------------------------

    /**
     * @method  scalar
     * @description  Creates a new class instance for the existing target.
     * @usage  <pre>inst.scalar(s);</pre>
     * @param   s   (Number)   -- a value to scale class instance properties.
     * @return  (Col)  -- returns a new class instance based on the multiplication of the existing r, g, and b values by the scalar value.
    **/
    function scalar(s:Number):Col
    {
        return new Col($target,r*s,g*s,b*s);
    }

// 13. adds -----------------------------------

    /**
     * @method  adds
     * @description  Creates a new class instance for the existing target.
     * @usage  <pre>inst.adds(c2);</pre>
     * @param   c2   (Col)  -- object to compare with the existing class instance.
     * @return  (Col)  -- returns a new class instance based on the addition of the existing r, g, and b values and the input object.
    **/
    function adds(c2:Col):Col
    {
        return new Col($target,r+c2.r,g+c2.g,b+c2.b);
    }

////////////////////////////////
// Getter/Setters
////////////////////////////////

// 14. set _rgbStr --------------------------------

    /**
     * @method  set _rgbStr
     * @description  Sets the class instance color using a hexadecimal string.
     * @usage  <pre>inst._rgbStr = hexStr;</pre>
     * @param   hexStr   (String)  -- a string representation of a hexadecimal value.
     * @return  (Void)
    **/
    function set _rgbStr(hexStr:String):Void
    {
    	// grab the last six characters of the string
    	hexStr = hexStr.substr(-6,6);
    	$target.setRGB(parseInt(hexStr,16));
    }

// 15. get _rgbStr --------------------------------

    /**
     * @method  get _rgbStr
     * @description  Gets the class instance color.
     * @usage  <pre>inst._rgbStr;</pre>
     * @return  (String)  -- returns a hexadecimal string representation of the class instance color.
    **/
    function get _rgbStr():String
    {
    	var hexStr = $target.getRGB().toString(16);
    	var toFill = 6-hexStr.length;

       	while (toFill--) hexStr = "0"+hexStr;

    	return hexStr.toUpperCase();
    }

// 16. set _rgb2 ----------------------------------

    /**
     * @method  set _rgb2
     * @description  Sets red, green, and blue with normal numbers
     *               r, g, b between 0 and 255.
     * @usage  <pre>inst._rgb2 = obj;</pre>
     * @param   obj   (Object)  -- an object with r, g, and b properties.
     * @return  (Void)
    **/
    function set _rgb2(obj:Object):Void
    {
    	$target.setRGB(obj.r<<16 | obj.g<<8 | obj.b);
    } // Branden Hall - www.figleaf.com

// 17. get _rgb2 ----------------------------------

    /**
     * @method  get _rgb2
     * @description  Gets an object with r, g, and b properties.
     * @usage  <pre>inst._rgb2;</pre>
     * @return  (Object)  -- returns an object with r, g, and b properties.
    **/
    function get _rgb2():Object
    {
    	var t = $target.getTransform();

    	return {r:t.rb,g:t.gb,b:t.bb};
    }

// 18. set _brightness ----------------------------

    /**
     * @method  set _brightness
     * @description  Brighten just like Property Inspector bright (-100 and 100).
     * @usage  <pre>inst._brightness = bright;</pre>
     * @param   bright   (Number)  -- a number between -100 and 100.
     * @return  (Void)
    **/
    function set _brightness(bright:Number):Void
    {
    	var trans:Object = $target.getTransform();

    	trans.ra = trans.ga = trans.ba = 100-Math.abs(bright); // color percent
        trans.rb = trans.gb = trans.bb = (bright>0) ? bright*(256/100) : 0; // color offset
    	$target.setTransform(trans);
    }

// 19. get _brightness ----------------------------

    /**
     * @method  get _brightness
     * @description  Gets brightness setting of the class instance color object.
     * @usage  <pre>inst._brightness;</pre>
     * @return  (Number)  -- returns the persentage of the brightness setting.
    **/
    function get _brightness():Number
    {
    	var trans:Object = $target.getTransform();

    	return trans.rb ? 100-trans.ra : trans.ra-100;
    }

// 20. set _brightOffset --------------------------

    /**
     * @method  set _brightOffset
     * @description  Sets offset of the class instance target between -255 and 255.
     * @usage  <pre>inst._brightOffset = offset;</pre>
     * @param   offset   (Number)  -- a number between -255 and 255.
     * @return  (Void)
    **/
    function set _brightOffset(offset:Number):Void
    {
    	var trans:Object = $target.getTransform();

    	trans.rb = trans.gb = trans.bb = offset;
    	$target.setTransform(trans);
    }

// 21. get _brightOffset -------------------------

    /**
     * @method  get _brightOffset
     * @description  Gets the offset of the class instance target.
     * @usage  <pre>inst._brightOffset;</pre>
     * @return  (Number)  -- returns the target's brightness offset (-255 - 255).
    **/
    function get _brightOffset():Number
    {
    	return $target.getTransform().rb;
    }

// 22. set _tint ---------------------------------

    /**
     * @method  set _tint
     * @description  Tint with a color just like Property Inspector --
     *               r, g, b between 0 and 255; percent between 0 and 100.
     * @usage  <pre>inst._tint = obj;</pre>
     * @param   obj   (Object)  -- an object containing r, g, b, and percent values.
     * @return  (Void)
    **/
    function set _tint(obj:Object):Void
    {
    	var ratio:Number = obj.percent/100;
    	var trans:Object = {rb:obj.r*ratio,gb:obj.g*ratio,bb:obj.b*ratio};

    	trans.ra = trans.ga = trans.ba = 100-obj.percent;
    	$target.setTransform(trans);
    }

// 23. get _tint ---------------------------------

    /**
     * @method  get _tint
     * @description  Get a tint object containing r, g, b, and percent values.
     * @usage  <pre>inst._tint;</pre>
     * @return  (Object) -- returns a tint object containing r, g, b, and percent values.
    **/
    function get _tint():Object
    {
    	var trans:Object = $target.getTransform();
    	var tint:Object = {percent:100-trans.ra};
    	var ratio:Number = 100/tint.percent;

    	tint.r = trans.rb*ratio;
    	tint.g = trans.gb*ratio;
    	tint.b = trans.bb*ratio;

    	return tint;
    }

// 24. set _tint2 --------------------------------

    /**
     * @method  set _tint2
     * @description  Tint with a color - alternate approach rgb a color number
     *               between 0 and 0xFFFFFF; percent between 0 and 100
     * @usage  <pre>inst._tint2 = obj;</pre>
     * @param   obj   (Object)  -- contains rgb and percent values.
     * @return  (Void)
    **/
    function set _tint2(obj:Object):Void
    {
    	var r:Number = (obj.rgb>>16);
    	var g:Number = (obj.rgb>>8) & 0xFF;
    	var b:Number = obj.rgb & 0xFF;
    	var ratio:Number = obj.percent/100;
    	var trans:Object = {rb:r*ratio,gb:g*ratio,bb:b*ratio};

    	trans.ra = trans.ga = trans.ba = 100-obj.percent;
    	$target.setTransform(trans);
    }

// 25. get _tint2 -------------------------------

    /**
     * @method  get _tint2
     * @description  returns a tint object containing rgb (a 0xFFFFFF number's
     *               digital equivalent) and percent properties.
     * @usage  <pre>inst._tint2;</pre>
     * @return  (Object) -- returns an object containing rgb and percent value.
    **/
    function get _tint2():Object
    {
    	var trans:Object = $target.getTransform();
    	var tint:Object = {percent:100-trans.ra};
    	var ratio:Number = 100/tint.percent;

    	tint.rgb = (trans.rb*ratio)<<16 | (trans.gb*ratio)<<8 | trans.bb*ratio;

    	return tint;
    }

// 26. set _tintOffset --------------------------

    /**
     * @method  set _tintOffset
     * @description  Sets r, g, b between -255 and 255.
     * @usage  <pre>inst._tintOffset = obj;</pre>
     * @param   obj   (Object)  -- contains offset r, g, and b values.
     * @return  (Void)
    **/
    function set _tintOffset(obj:Object):Void
    {
    	var trans:Object = $target.getTransform();

    	trans.rb = obj.r;
    	trans.gb = obj.g;
    	trans.bb = obj.b;
    	$target.setTransform(trans);
    }

// 27. get _tintOffset --------------------------

    /**
     * @method  get _tintOffset
     * @description  Gets the offset r, g, and b values.
     * @usage  <pre>inst._tintOffset;</pre>
     * @return  (Object) -- returns an object showing offset r, g, and b values.
    **/
    function get _tintOffset():Object
    {
    	var t:Object = $target.getTransform();

    	return {r:t.rb,g:t.gb,b:t.bb};
    }

// 28. set _negative ---------------------------

    /**
     * @method  set _negative
     * @description  Produce a negative image of the normal appearance.
     * @usage  <pre>inst._negative = percent;</pre>
     * @param   percent   (Number)  -- percent of the strength of negative transform.
     * @return  (Void)
    **/
    function set _negative(percent:Number):Void
    {
        var t:Object = {};

        t.ra = t.ga = t.ba = 100-2*percent;
        t.rb = t.gb = t.bb = percent*(255/100);
        $target.setTransform(t);
    }

// 29. get _negative ---------------------------

    /**
     * @method  get _negative
     * @description  Gets the negative of color transform.
     * @usage  <pre>inst._negative;</pre>
     * @return  (Number)  -- returns negative of color transform, offset(rb) * (100/255).
    **/
    function get _negative():Number
    {
        return $target.getTransform().rb*(100/255);
    }

// ============== solid color - Col methods ===================

// 30. set _red --------------------------------

    /**
     * @method  set _red
     * @description  Sets the red portion of color object.
     * @usage  <pre>inst._red = amount;</pre>
     * @param   amount   (Number)  -- value of red portion of color object (0 - 255).
     * @return  (Void)
    **/
    function set _red(amount:Number):Void
    {
    	var t:Object = $target.getTransform();

    	$target.setRGB (amount<<16 | t.gb<<8 | t.bb);
    }

// 31. get _red --------------------------------

    /**
     * @method  get _red
     * @description  Gets the red portion of the color object.
     * @usage  <pre>inst._red;</pre>
     * @return  (Number) -- returns the red offset value of the color object (-255 - 255).
    **/
    function get _red():Number
    {
    	return $target.getTransform().rb;
    }

// 32. set _green ------------------------------

    /**
     * @method  set _green
     * @description  Sets the green portion of the color object.
     * @usage  <pre>inst._green = amount;</pre>
     * @param   amount   (Number)  -- value of green portion of color object (0 - 255).
     * @return (Void)
    **/
    function set _green(amount:Number):Void
    {
    	var t:Object = $target.getTransform();

    	$target.setRGB(t.rb<<16 | amount<<8 | t.bb);
    }

// 33. get _green ------------------------------

    /**
     * @method  get _green
     * @description  Gets the green portion of the color object.
     * @usage  <pre>inst._green;</pre>
     * @return  (Number) -- returns the green offset value of the color object (-255 - 255).
    **/
    function get _green():Number
    {
    	return $target.getTransform().gb;
    }

// 34. set _blue -------------------------------

    /**
     * @method  set _blue
     * @description  Sets the blue portion of the color object.
     * @usage  <pre>inst._blue = amount;</pre>
     * @param   amount   (Number)  -- value of blue portion of color object (0 - 255).
     * @return  (Void)
    **/
    function set _blue(amount:Number):Void
    {
    	var t:Object = $target.getTransform();

    	$target.setRGB(t.rb<<16 | t.gb<<8 | amount);
    }

// 35. get _blue -------------------------------

    /**
     * @method  get _blue
     * @description  Gets the blue portion of the color object.
     * @usage  <pre>inst._blue;</pre>
     * @return  (Number) -- returns the blue offset value of the color object (-255 - 255).
    **/
    function get _blue():Number
    {
    	return $target.getTransform().bb;
    }

// 36. set _redPercent -------------------------

    /**
     * @method  set _redPercent
     * @description  Sets the red percentage of the color object.
     * @usage  <pre>inst._redPercent = percent;</pre>
     * @param   percent   (Number)  -- a percentage value (0 - 100).
     * @return  (Void)
    **/
    function set _redPercent(percent:Number):Void
    {
    	var trans:Object = $target.getTransform();

    	trans.ra = percent;
    	$target.setTransform(trans);
    }

// 37. get _redPercent -------------------------

    /**
     * @method  get _redPercent
     * @description  Gets the red percentage of the color object.
     * @usage  <pre>inst._redPercent;</pre>
     * @return  (Number) -- returns the red percentage value of the color object (0 - 100).
    **/
    function get _redPercent():Number
    {
    	return $target.getTransform().ra;
    }

// 38. set _greenPercent -----------------------

    /**
     * @method  set _greenPercent
     * @description  Sets the green percentage of the color object.
     * @usage  <pre>inst._greenPercent = percent;</pre>
     * @param   percent   (Number)  -- a percentage value (0 - 100).
     * @return  (Void)
    **/
    function set _greenPercent(percent:Number):Void
    {
    	var trans:Object = $target.getTransform();


    	trans.ga = percent;
    	$target.setTransform(trans);
    }

// 39. get _greenPercent -----------------------

    /**
     * @method  get _greenPercent
     * @description  Gets the green percentage of the color object.
     * @usage  <pre>inst._greenPercent;</pre>
     * @return  (Number) -- returns the green percentage value of the color object (0 - 100).
    **/
    function get _greenPercent():Number
    {
    	return $target.getTransform().ga;
    }

// 40. set _bluePercent ------------------------

    /**
     * @method  set _bluePercent
     * @description  Sets the blue percentage of the color object.
     * @usage  <pre>inst._bluePercent = percent;</pre>
     * @param   percent   (Number)  -- a percentage value (0 - 100).
     * @return  (Void)
    **/
    function set _bluePercent(percent:Number):Void
    {
    	var trans:Object = $target.getTransform();

    	trans.ba = percent;
    	$target.setTransform(trans);
    }

// 41. get _bluePercent ------------------------

    /**
     * @method  get _bluePercent
     * @description  Gets the blue percentage of the color object.
     * @usage  <pre>inst._bluePercent;</pre>
     * @return  (Number) -- returns the blue percentage value of the color object (0 - 100).
    **/
    function get _bluePercent():Number
    {
    	return $target.getTransform().ba;
    }

// 42. set _redOffset --------------------------

    /**
     * @method  set _redOffset
     * @description  Sets the red offset of the color object.
     * @usage  <pre>inst._redOffset = offset;</pre>
     * @param   offset   (Number)  -- an offset value (-255 - 255).
     * @return  (Void)
    **/
    function set _redOffset(offset:Number):Void
    {
    	var trans:Object = $target.getTransform();

    	trans.rb = offset;
    	$target.setTransform(trans);
    }

// 43. get _redOffset --------------------------

    /**
     * @method  get _redOffset
     * @description  Gets the red offset of the color object.
     * @usage  <pre>inst._redOffset;</pre>
     * @return  (Number) -- returns the red offset value of the color object (-255 - 255).
    **/
    function get _redOffset():Number
    {
    	return $target.getTransform().rb;
    }

// 44. set _greenOffset ------------------------

    /**
     * @method  set _greenOffset
     * @description  Sets the green offset of the color object.
     * @usage  <pre>inst._greenOffset = offset;</pre>
     * @param   offset   (Number)  -- an offset value (-255 - 255).
     * @return  (Void)
    **/
    function set _greenOffset(offset:Number):Void
    {
    	var trans:Object = $target.getTransform();

    	trans.gb = offset;
    	$target.setTransform(trans);
    }

// 45. get _greenOffset ------------------------

    /**
     * @method  get _greenOffset
     * @description  Gets the green offset of the color object.
     * @usage  <pre>inst._greenOffset;</pre>
     * @return  (Number) -- returns the green offset value of the color object (-255 - 255).
    **/
    function get _greenOffset():Number
    {
    	return $target.getTransform().gb;
    }

// 46. set _blueOffset -------------------------

    /**
     * @method  set _blueOffset
     * @description  Sets the blue offset of the color object.
     * @usage  <pre>inst._blueOffset = offset;</pre>
     * @param   offset   (Number)  -- an offset value (-255 - 255).
     * @return  (Void)
    **/
    function set _blueOffset(offset:Number):Void
    {
    	var trans:Object = $target.getTransform();

    	trans.bb = offset;
    	$target.setTransform(trans);
    }

// 47. get _blueOffset -------------------------

    /**
     * @method  get _blueOffset
     * @description  Gets the blue offset of the color object.
     * @usage  <pre>inst._blueOffset;</pre>
     * @return  (Number) -- returns the blue offset value of the color object (-255 - 255).
    **/
    function get _blueOffset():Number
    {
    	return $target.getTransform().bb;
    }

// 48. get _htmlStr ---------------------------------

    /**
     * @method  get _htmlStr
     * @description  Creates an html string representation of the color object.
     * @usage  <pre>inst._htmlStr;</pre>
     * @return  (String)  -- returns the color object value as an html string.
    **/
    function get _htmlStr():String
    {
        var red:Number = Math.round(r);
		var green:Number  = Math.round(g);
        var blue:Number  = Math.round(b);

        return '#'+twoChars(red.toString(16).toUpperCase())+twoChars(green.toString(16).toUpperCase())+twoChars(blue.toString(16).toUpperCase());
    }

}

