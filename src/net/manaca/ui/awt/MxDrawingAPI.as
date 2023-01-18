/**
 * Flash MX Drawing API commands
 */
interface net.manaca.ui.awt.MxDrawingAPI {
	/**
	 * Method; removes all the graphics created during runtime using the movie clip draw methods,
	 * including line styles specified with MovieClip.lineStyle(). Shapes and lines that are manually
	 * drawn during authoring time (with the Flash drawing tools) are unaffected.
	 * @return nothing
	 */
	function clear(Void):Void;
	/**
	 * Method; specifies a line style that Flash uses for subsequent calls to lineTo() and curveTo()
	 * until you call lineStyle() with different parameters. You can call lineStyle() in the middle of
	 * drawing a path to specify different styles for different line segments within a path. 
	 * <br />
	 * <b>Note:</b> Calls to clear() will set the line style back to undefined.
	 * @param thickness An integer that indicates the thickness of the line in points; valid values
	 * are 0 to 255. If a number is not specified, or if the parameter is undefined, a line is not
	 * drawn. If a value of less than 0 is passed, Flash uses 0. The value 0 indicates hairline
	 * thickness; the maximum thickness is 255. If a value greater than 255 is passed, the Flash
	 * interpreter uses 255.
	 * @param rgb A hex color value (for example, red is 0xFF0000, blue is 0x0000FF, and so on) of
	 * the line. If a value isn�t indicated, Flash uses 0x000000 (black).
	 * @param alpha An integer that indicates the alpha value of the line�s color; valid values are
	 * 0�100. If a value isn�t indicated, Flash uses 100 (solid). If the value is less than 0, Flash
	 * uses 0; if the value is greater than 100, Flash uses 100.
	 * @return nothing
	 */
	function lineStyle(thickness:Number, rgb:Number, alpha:Number):Void;
	/**
	 * Method; indicates the beginning of a new drawing path. If an open path exists (that is, if the
	 * current drawing position does not equal the previous position specified in a MovieClip.moveTo()
	 * method) and it has a fill associated with it, that path is closed with a line and then filled. This
	 * is similar to what happens when MovieClip.endFill() is called.
	 * @param rgb A hex color value (for example, red is 0xFF0000, blue is 0x0000FF, and so on). If
	 * this value is not provided or is undefined, a fill is not created.
	 * @param alpha An integer between 0�100 that specifies the alpha value of the fill. If this value
	 * is not provided, 100 (solid) is used. If the value is less than 0, Flash uses 0. If the value is
	 * greater than 100, Flash uses 100.
	 * @return nothing
	 */
	function beginFill(rgb:Number,alpha:Number):Void;
	/**
	 * Method; indicates the beginning of a new drawing path. If the first parameter is undefined, or
	 * if no parameters are passed, the path has no fill. If an open path exists (that is if the current
	 * drawing position does not equal the previous position specified in a MovieClip.moveTo() method),
	 * and it has a fill associated with it, that path is closed with a line and then filled. This is
	 * similar to what happens when you call MovieClip.endFill().
	 * @param fillType Either the string "linear" or the string "radial".
	 * @param colors An array of RGB hex color values to be used in the gradient (for example, red is
	 * 0xFF0000, blue is 0x0000FF, and so on).
	 * @param alphas An array of alpha values for the corresponding colors in the colors array; valid
	 * values are 0�100. If the value is less than 0, Flash uses 0. If the value is greater than 100,
	 * Flash uses 100.
	 * @param ratios An array of color distribution ratios; valid values are 0�255. This value defines
	 * the percentage of the width where the color is sampled at 100 percent.
	 * @param matrix A transformation matrix that is an object with one of two sets of properties.
	 * @return nothing
	 */
	function beginGradientFill(fillType:String, colors:Array, alphas:Array, ratios:Array, matrix:Object):Void;
	/**
	 * Method; moves the current drawing position to (x, y). If any of the parameters are missing,
	 * this method fails and the current drawing position is not changed.
	 * @param x An integer indicating the horizontal position relative to the registration point of
	 * the parent movie clip.
	 * @param An integer indicating the vertical position relative to the registration point of the
	 * parent movie clip.
	 * @return nothing
	 */
	function moveTo(x:Number, y:Number):Void;
	/**
	 * Method; draws a line using the current line style from the current drawing position to (x, y);
	 * the current drawing position is then set to (x, y). If the movie clip that you are drawing in
	 * contains content that was created with the Flash drawing tools, calls to lineTo() are drawn
	 * underneath the content. If you call lineTo() before any calls to the moveTo() method, the
	 * current drawing position defaults to (0, 0). If any of the parameters are missing, this method
	 * fails and the current drawing position is not changed.
	 * @param x An integer indicating the horizontal position relative to the registration point of
	 * the parent movie clip.
	 * @param An integer indicating the vertical position relative to the registration point of the
	 * parent movie clip.
	 * @return nothing
	 */
	function lineTo(x:Number, y:Number):Void;
	/**
	 * Method; draws a curve using the current line style from the current drawing position to
	 * (x, y) using the control point specified by (cx, cy). The current  drawing position is then set
	 * to (x, y). If the movie clip you are drawing in contains content created with the Flash drawing
	 * tools, calls to curveTo() are drawn underneath this content. If you call curveTo() before any
	 * calls to moveTo(), the current drawing position defaults to (0, 0). If any of the parameters
	 * are missing, this method fails and the current drawing position is not changed.
	 * @param cx An integer that specifies the horizontal position of the control point relative to
	 * the registration point of the parent movie clip.
	 * @param cy An integer that specifies the vertical position of the control point relative to the
	 * registration point of the parent movie clip.
	 * @param x An integer that specifies the horizontal position of the next anchor point relative
	 * to the registration. point of the parent movie clip.
	 * @param y An integer that specifies the vertical position of the next anchor point relative to
	 * the registration point of the parent movie clip.
	 * @return nothing
	 */
	function curveTo(cx:Number, cy:Number, x:Number, y:Number):Void;
	/**
	 * Method; applies a fill to the lines and curves added since the last call to beginFill() or
	 * beginGradientFill(). Flash uses the fill that was specified in the previous call to beginFill() or
	 * beginGradientFill(). If the current drawing position does not equal the previous position
	 * specified in a moveTo() method and a fill is defined, the path is closed with a line and then filled.
	 * @return nothing
	 */
	function endFill(Void):Void;
}