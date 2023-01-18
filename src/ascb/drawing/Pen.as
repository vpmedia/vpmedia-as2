import ascb.drawing.FillMatrix;

/**
Use the Pen class as an abstracted drawing utility without having
to use the MovieClip drawing methods directly.
*/

class ascb.drawing.Pen {

  private var _mTarget:MovieClip;
  private var _bLineStyleSet:Boolean;

  /**
   *  Get or set the target movie clip. You can also set the target
   *  movie clip when calling the constructor. When calling the
   *  constructor you can also have the Pen automatically create a
   *  new empty movie clip in a parent.
   *  @example
   *  <pre>
   *  import ascb.drawing.Pen;
   *  
   *  // Have the Pen create a new empty movie clip in this.
   *  var pCircle:Pen = new Pen(this, true);
   *  pCircle.drawCircle(10);
   *  trace(pCircle.target);
   */
  public function set target(mTarget:MovieClip):Void {
    _mTarget = mTarget;
  }

  public function get target():MovieClip {
    return _mTarget;
  }

  function Pen(mTarget:MovieClip, bMakeNew:Boolean) {
    if(bMakeNew) {
      var nDepth:Number = mTarget.getNextHighestDepth();
      mTarget = mTarget.createEmptyMovieClip("__PenClip" + nDepth, nDepth);
    }
    _mTarget = mTarget;
  }

  /**
   *  The lineStyle() method is optional. The Pen class uses a default
   *  line style of you don't call the method.
   *  @param  thickness   (optional) The point thickness of the line (default 0)
   *  @param  rgb         (optional) The RGB value of the line (default 0)
   *  @param  alpha       (optional) The alpha of the line (default 100)
   */
  public function lineStyle(nThickness:Number, nRGB:Number, nAlpha:Number):Void {
    nThickness = (nThickness == undefined) ? 0 : nThickness;
    nRGB = (nRGB == undefined) ? 0 : nRGB;
    nAlpha = (nAlpha == undefined) ? 100 : nAlpha;
    _mTarget.lineStyle(nThickness, nRGB, nAlpha);
    _bLineStyleSet = true;
  }

  public function beginFill(nRGB:Number, nAlpha:Number):Void {
    nAlpha = (nAlpha == undefined) ? 100 : nAlpha;
trace("fill alpha - " + nAlpha);
    _mTarget.beginFill(nRGB, nAlpha);
  }

  public function beginGradientFill(sFillType:String, aColors:Array, nAlphas:Array, nRatios:Array, fmMatrix:Object):Void {
    _mTarget.beginGradientFill(sFillType, aColors, nAlphas, nRatios, fmMatrix);
  }

  public function endFill():Void {
    _mTarget.endFill();
  }

  public function clear():Void {
    _mTarget.clear();
    _bLineStyleSet = false;
  }

  public function moveTo(nX:Number, nY:Number):Void {
    _mTarget.moveTo(nX, nY);
  }

  public function lineTo():Void {
    // Make sure the line style is set. Otherwise, use the default values.
    if(!_bLineStyleSet) {
      lineStyle(0, 0, 100);
    }
    _mTarget.lineTo(arguments[0], arguments[1]);
  }

  public function curveTo(nCtrlX:Number, nCtrlY:Number, nAnchorX:Number, nAnchorY:Number):Void {
    // Make sure the line style is set. Otherwise, use the default values.
    if(!_bLineStyleSet) {
      lineStyle(0, 0, 100);
    }
    _mTarget.curveTo(nCtrlX, nCtrlY, nAnchorX, nAnchorY);
  }

  /**
   *  Draw a line from one point to another.
   */
  public function drawLine(nX0:Number, nY0:Number, nX1:Number, nY1:Number):Void {
    // Make sure the line style is set. Otherwise, use the default values.
    if(!_bLineStyleSet) {
      lineStyle(0, 0, 100);
    }
    _mTarget.moveTo(nX0, nY0);
    _mTarget.lineTo(nX1, nY1);
  }

  /**
   *  Draw a curve from one point to another.
   */
  public function drawCurve(nX:Number, nY:Number, nCtrlX:Number, nCtrlY:Number, nAnchorX:Number, nAnchorY:Number):Void {
    // Make sure the line style is set. Otherwise, use the default values.
    if(!_bLineStyleSet) {
      lineStyle(0, 0, 100);
    }
    _mTarget.moveTo(nX, nY);
    _mTarget.curveTo(nCtrlX, nCtrlY, nAnchorX, nAnchorY);
  }

  /**
   *  Draw a rectangle.
   *  @param  width    The width of the rectangle
   *  @param  height   The height of the rectangle
   *  @param  round    (optional) The number of pixels to round the corners
   *  @param  rotation (optional) The amount to rotate the rectangle in degrees
   *  @param  x        (optional) The x coordinate at which to draw the rectangle
   *  @param  y        (optional) The y coordinate at which to draw the rectangle
   *  @param  align    (optional) The alignment of the rectangle relative to the x and y
   *                   coordinates. Can be upperleft, upperright, left, right, upper, lower,
   *                   lowerleft, lowerright.
   */
  public function drawRectangle (nWidth:Number, nHeight:Number, nRound:Number, nRotation:Number, nX:Number, nY:Number, sAlign:String):Void {

    nRound = (nRound == undefined) ? 0 : nRound;

    nRotation = (nRotation == undefined) ? 0 : nRotation;

    nX = (nX == undefined) ? 0 : nX;

    nY = (nY == undefined) ? 0 : nY;

    switch(sAlign) {
      case "upperleft":
        nX += nWidth/2;
        nY += nHeight/2;
        break;
      case "upperright":
        nX += -nWidth/2;
        nY += nHeight/2;
        break;
      case "left":
        nX += nWidth/2;
        break;
      case "right":
        nX += -nWidth/2;
        break;
      case "upper":
        nY += nHeight/2;
        break;
      case "lower":
        nY += -nHeight/2;
        break;
      case "lowerleft":
        nX += nWidth/2;
        nY += -nHeight/2;
        break;
      case "lowerright":
        nX += -nWidth/2;
        nY += -nHeight/2;
        break;
    }

    // Make sure the rectangle is at least as wide and tall as the rounded corners
    if (nWidth < (nRound * 2)) {
      nWidth = nRound * 2;
    }
    if (nHeight < (nRound * 2)) {
      nHeight = nRound * 2;
    }

    // Convert the nRotation from degrees to radians
    nRotation = nRotation * Math.PI / 180;

    // Calculate the distance from the rectangle's center to one of the corners
    // (or where the corner would be in rounded-cornered rectangles).
    // See the line labeled r in Figure 4-2.
    var nR:Number = Math.sqrt(Math.pow(nWidth/2, 2) + Math.pow(nHeight/2, 2));

    // Calculate the distance from the rectangle's center to the upper edge of
    // the bottom-right rounded corner. See the line labeled rx in Figure 4-2. 
    // When round is 0, rx is equal to r.
    var nRx:Number = Math.sqrt(Math.pow(nWidth/2, 2) + Math.pow((nHeight/2) - nRound, 2));

    // Calculate the distance from the rectangle's center to the lower edge of
    // the bottom-right rounded corner. See the line labeled ry in Figure 4-2.
    // When round is 0, ry is equal to r.
    var nRy:Number = Math.sqrt(Math.pow((nWidth/2) - nRound, 2) + Math.pow(nHeight/2, 2));

    // Calculate angles. nR1Angle is the angle between the X axis that runs through
    // the center of the rectangle and the line rx. nR2Angle is the angle between rx
    // and r. nR3Angle is the angle between r and ry. And nR4Angle is the angle
    // between ry and the Y axis that runs through the center of the rectangle.
    var nR1Angle:Number = Math.atan( ((nHeight/2) - nRound) /( nWidth/2) );
    var nR2Angle:Number = Math.atan( (nHeight/2) / (nWidth/2) ) - nR1Angle;
    var nR4Angle:Number = Math.atan( ((nWidth/2) - nRound) / (nHeight/2) );
    var nR3Angle:Number = (Math.PI/2) - nR1Angle - nR2Angle - nR4Angle;

    // Calculate the distance of the control point from the arc center for the
    // rounded corners.
    var nCtrlDist:Number = Math.sqrt(2 * Math.pow(nRound, 2));

    // Declare the local variables used to calculate the control point.
    var nCtrlX:Number;
    var nCtrlY:Number;

    // Calculate where to begin drawing the first side segment, and then draw it.
    nRotation += nR1Angle + nR2Angle + nR3Angle;
    var nX1:Number = nX + nRy * Math.cos(nRotation);
    var nY1:Number = nY + nRy * Math.sin(nRotation);
    moveTo(nX1, nY1);
    nRotation += 2 * nR4Angle;
    nX1 = nX + nRy * Math.cos(nRotation);
    nY1 = nY + nRy * Math.sin(nRotation);
    lineTo(nX1, nY1);

    // Set nRotation to the starting point for the next side segment and calculate
    // the x and y coordinates.
    nRotation += nR3Angle + nR2Angle;
    nX1 = nX + nRx * Math.cos(nRotation);
    nY1 = nY + nRx * Math.sin(nRotation);

    // If the corners are rounded, calculate the control point for the corner's
    // curve and draw it.
    if (nRound > 0) {
      nCtrlX = nX + nR * Math.cos(nRotation - nR2Angle);
      nCtrlY = nY + nR * Math.sin(nRotation - nR2Angle);
      curveTo(nCtrlX, nCtrlY, nX1, nY1);
    }

    // Calculate the end point of the second side segment and draw the line.
    nRotation += 2 * nR1Angle;
    nX1 = nX + nRx * Math.cos(nRotation);
    nY1 = nY + nRx * Math.sin(nRotation);
    lineTo(nX1, nY1);

    // Calculate the next line segment's starting point.
    nRotation += nR2Angle + nR3Angle;
    nX1 = nX + nRy * Math.cos(nRotation);
    nY1 = nY + nRy * Math.sin(nRotation);

    // Draw the rounded corner, if applicable.
    if (nRound > 0) {
      nCtrlX = nX + nR * Math.cos(nRotation - nR3Angle);
      nCtrlY = nY + nR * Math.sin(nRotation - nR3Angle);
      curveTo(nCtrlX, nCtrlY, nX1, nY1);
    }

    // Calculate the end point of the third segment and draw the line.
    nRotation += 2 * nR4Angle;
    nX1 = nX + nRy * Math.cos(nRotation);
    nY1 = nY + nRy * Math.sin(nRotation);
    lineTo(nX1, nY1);

    // Calculate the starting point of the next segment.
    nRotation += nR3Angle + nR2Angle;
    nX1 = nX + nRx * Math.cos(nRotation);
    nY1 = nY + nRx * Math.sin(nRotation);

    // If applicable, draw the rounded corner.
    if (nRound > 0) {
      nCtrlX = nX + nR * Math.cos(nRotation - nR2Angle);
      nCtrlY = nY + nR * Math.sin(nRotation - nR2Angle);
      curveTo(nCtrlX, nCtrlY, nX1, nY1);
    }

    // Calculate the end point for the fourth segment, and draw it.
    nRotation += 2 * nR1Angle;
    nX1 = nX + nRx * Math.cos(nRotation);
    nY1 = nY + nRx * Math.sin(nRotation);
    lineTo(nX1, nY1);

    // Calculate the end point for the next corner arc, and if applicable, draw it.
    nRotation += nR3Angle + nR2Angle;
    nX1 = nX + nRy * Math.cos(nRotation);
    nY1 = nY + nRy * Math.sin(nRotation);
    if (nRound > 0) {
      nCtrlX = nX + nR * Math.cos(nRotation - nR3Angle);
      nCtrlY = nY + nR * Math.sin(nRotation - nR3Angle);
      curveTo(nCtrlX, nCtrlY, nX1, nY1);
    }
  }

  public function drawCircle (nRadius:Number, nX:Number, nY:Number, sAlign:String):Void  {
    drawArc(360, nRadius, 0, nX, nY, sAlign);
  }

  public function drawSlice (nArc:Number, nRadius:Number, nStartingAngle:Number, nX:Number, nY:Number, sAlign:String):Void {
    drawArc(nArc, nRadius, nStartingAngle, nX, nY, sAlign, true);
  }

  public function drawArc (nArc:Number, nRadius:Number, nStartingAngle:Number, nX:Number, nY:Number, sAlign:String, bRadialLines:Boolean):Void  {

    nX = (nX == undefined) ? 0 : nX;
    nY = (nY == undefined) ? 0 : nY;

    switch(sAlign) {
      case "upperleft":
        nX += nRadius;
        nY += nRadius;
        break;
      case "upperright":
        nX += -nRadius;
        nY += nRadius;
        break;
      case "left":
        nX += nRadius;
        break;
      case "right":
        nX += -nRadius;
        break;
      case "upper":
        nY += nRadius;
        break;
      case "lower":
        nY += -nRadius;
        break;
      case "lowerleft":
        nX += nRadius;
        nY += -nRadius;
        break;
      case "lowerright":
        nX += -nRadius;
        nY += -nRadius;
        break;
    }

    // The angle of each of the eight segments is 45 degrees (360 divided by eight),
    // which equals p/4 radians.
    if(nArc > 360) {
      nArc = 360;
    }
    nArc = Math.PI/180 * nArc;
    var nAngleDelta:Number = nArc/8;

    // Find the distance from the circle's center to the control points
    // for the curves.
    var nCtrlDist:Number = nRadius/Math.cos(nAngleDelta/2);

    // Initialize the angle to 0 and define local variables that are used for the
    // control and ending points. 

    if(nStartingAngle == undefined) {
      nStartingAngle = 0;
    }

    nStartingAngle *= Math.PI / 180;

    var nAngle:Number = nStartingAngle;
    var nCtrlX:Number;
    var nCtrlY:Number;
    var nAnchorX:Number;
    var nAnchorY:Number;

    var nStartingX:Number = nX + Math.cos(nStartingAngle) * nRadius;
    var nStartingY:Number = nY + Math.sin(nStartingAngle) * nRadius;

    if(bRadialLines) {
      moveTo(nX, nY);
      lineTo(nStartingX, nStartingY);
    }
    else {
      // Move to the starting point, one radius to the right of the circle's center.
      moveTo(nStartingX, nStartingY);
    }

    // Repeat eight times to create eight segments.
    for (var i:Number = 0; i < 8; i++) {

      // Increment the angle by angleDelta (p/4) to create the whole circle (2p).
      nAngle += nAngleDelta;

      // The control points are derived using sine and cosine.
      nCtrlX = nX + Math.cos(nAngle-(nAngleDelta/2))*(nCtrlDist);
      nCtrlY = nY + Math.sin(nAngle-(nAngleDelta/2))*(nCtrlDist);

      // The anchor points (end points of the curve) can be found similarly to the
      // control points.
      nAnchorX = nX + Math.cos(nAngle) * nRadius;
      nAnchorY = nY + Math.sin(nAngle) * nRadius;

      // Draw the segment.
      curveTo(nCtrlX, nCtrlY, nAnchorX, nAnchorY);
    }
    if(bRadialLines) {
      lineTo(nX, nY);
    }
  }


  public function drawEllipse (nRadiusX:Number, nRadiusY:Number, nX:Number, nY:Number, sAlign:String):Void {

    nX = (nX == undefined) ? 0 : nX;
    nY = (nY == undefined) ? 0 : nY;

    switch(sAlign) {
      case "upperleft":
        nX += nRadiusX;
        nY += nRadiusY;
        break;
      case "upperright":
        nX += -nRadiusX;
        nY += nRadiusY;
        break;
      case "left":
        nX += nRadiusX;
        break;
      case "right":
        nX += -nRadiusX;
        break;
      case "upper":
        nY += nRadiusY;
        break;
      case "lower":
        nY += -nRadiusY;
        break;
      case "lowerleft":
        nX += nRadiusX;
        nY += -nRadiusY;
        break;
      case "lowerright":
        nX += -nRadiusX;
        nY += -nRadiusY;
        break;
    }

    var nAngleDelta:Number = Math.PI / 4;

    var nAngle:Number = 0;

    // Whereas the circle has only one distance to the control point 
    // for each segment, the ellipse has two distances: one that 
    // corresponds to xRadius and another that corresponds to yRadius.
    var nCtrlDistX:Number = nRadiusX / Math.cos(nAngleDelta/2);
    var nCtrlDistY:Number = nRadiusY / Math.cos(nAngleDelta/2);
    var nCtrlX:Number;
    var nCtrlY:Number;
    var nAnchorX:Number;
    var nAnchorY:Number;

    moveTo(nX + nRadiusX, nY);

    for (var i:Number = 0; i < 8; i++) {
      nAngle += nAngleDelta;
      nCtrlX = nX + Math.cos(nAngle-(nAngleDelta/2))*(nCtrlDistX);
      nCtrlY = nY + Math.sin(nAngle-(nAngleDelta/2))*(nCtrlDistY);
      nAnchorX = nX + Math.cos(nAngle) * nRadiusX;
      nAnchorY = nY + Math.sin(nAngle) * nRadiusY;
      this.curveTo(nCtrlX, nCtrlY, nAnchorX, nAnchorY);
    }
  }

  /**
   *  Draw a triangle given the lengths of two sides and the angle between them.
   */
  public function drawTriangle (nAB:Number, nAC:Number, nAngle:Number, nRotation:Number, nX:Number, nY:Number, sAlign:String):Void {

    nX = (nX == undefined) ? 0 : nX;
    nY = (nY == undefined) ? 0 : nY;

    nRotation = (nRotation == undefined) ? 0 : nRotation * Math.PI / 180;

    // Convert the angle between the sides from degrees to radians.
    nAngle = nAngle * Math.PI / 180;


    // Calculate the coordinates of points b and c.
    var nBx:Number = Math.cos(nAngle - nRotation) * nAB;
    var nBy:Number = Math.sin(nAngle - nRotation) * nAB;
    var nCx:Number = Math.cos(-nRotation) * nAC;
    var nCy:Number = Math.sin(-nRotation) * nAC;

    // Calculate the centroid's coordinates.
    var nCentroidX:Number = 0;
    var nCentroidY:Number = 0;

    /*if(bAlignUpperLeft) {
      nCentroidX = (nCx + nBx)/3 - nX;
      nCentroidY = (nCy + nBy)/3 - nY;
    }*/

    switch(sAlign) {
      case "upperleft":
        break;
      case "upperright":
        nCentroidX = nAB;
        break;
      case "left":
        nCentroidY = (nCy + nBy)/3;
        break;
      case "right":
        nCentroidX = nAB;
        nCentroidY = (nCy + nBy)/3;
        break;
      case "upper":
        nCentroidX = (nCx + nBx)/3;
        break;
      case "lower":
        nCentroidX = (nCx + nBx)/3;
        nCentroidY = nBy - nCentroidY;
        break;
      case "lowerleft":
        nCentroidY = nBy - nCentroidY;
        break;
      case "lowerright":
        nCentroidX = nAB;
        nCentroidY = nBy - nCentroidY;
        break;
      default:
        nCentroidX = (nCx + nBx)/3;
        nCentroidY = (nCy + nBy)/3;
    }
  // Move to point a, then draw line ac, then line cb, and finally ba (ab).
    drawLine(-nCentroidX + nX, -nCentroidY + nY, nCx - nCentroidX + nX, nCy - nCentroidY + nY);
    lineTo(nBx - nCentroidX + nX, nBy - nCentroidY + nY);
    lineTo(-nCentroidX + nX, -nCentroidY + nY);
  }

  public function drawRegularPolygon (nSides:Number, nLength:Number, nRotation:Number, nX:Number, nY:Number, sAlign:String):Void {

    nX = (nX == undefined) ? 0 : nX;
    nY = (nY == undefined) ? 0 : nY;

    // Convert nRotation from degrees to radians
    nRotation = (nRotation == undefined) ? 0 : nRotation * Math.PI / 180;

    // The angle formed between the segments from the polygon's center as shown in 
    // Figure 4-5. Since the total angle in the center is 360 degrees (2p radians),
    // each segment's angle is 2p divided by the number of sides.
    var nAngle:Number = (2 * Math.PI) / nSides;

    // Calculate the length of the radius that circumscribes the polygon (which is
    // also the distance from the center to any of the vertices).
    var nRadius:Number = (nLength/2)/Math.sin(nAngle/2);

    switch(sAlign) {
      case "upperleft":
        nX += nRadius;
        nY += nRadius;
        break;
      case "upperright":
        nX += -nRadius;
        nY += nRadius;
        break;
      case "left":
        nX += nRadius;
        break;
      case "right":
        nX += -nRadius;
        break;
      case "upper":
        nY += nRadius;
        break;
      case "lower":
        nY += -nRadius;
        break;
      case "lowerleft":
        nX += nRadius;
        nY += -nRadius;
        break;
      case "lowerright":
        nX += -nRadius;
        nY += -nRadius;
        break;
    }

    // The starting point of the polygon is calculated using trigonometry where 
    // radius is the hypotenuse and nRotation is the angle.
    var nPx:Number = (Math.cos(nRotation) * nRadius) + nX;
    var nPy:Number = (Math.sin(nRotation) * nRadius) + nY;

    // Move to the starting point without yet drawing a line.
    moveTo(nPx, nPy);

    // Draw each side. Calculate the vertex coordinates using the same trigonometric
    // ratios used to calculate px and py earlier.
    for (var i:Number = 1; i <= nSides; i++) {
      nPx = (Math.cos((nAngle * i) + nRotation) * nRadius) + nX;
      nPy = (Math.sin((nAngle * i) + nRotation) * nRadius) + nY;
      lineTo(nPx, nPy);
    }
  }

  public function drawStar(nPoints:Number, nInnerRadius:Number, nOuterRadius:Number, nRotation:Number, nX:Number, nY:Number, sAlign:Number):Void {

    if(nPoints < 3) {
      return;
    }

    var nAngleDelta:Number = (Math.PI * 2) / nPoints;
    if(nRotation == undefined) {
      nRotation = 0;
    }
    nRotation = Math.PI * (nRotation - 90) / 180;

    if(nX == undefined) {
      nX = 0;
    }
    if(nY == undefined) {
      nY = 0;
    }

    var nAngle:Number = nRotation;

    var nPenX:Number = nX + Math.cos(nAngle + nAngleDelta / 2) * nInnerRadius;
    var nPenY:Number = nY + Math.sin(nAngle + nAngleDelta / 2) * nInnerRadius;

    moveTo(nPenX, nPenY);

    nAngle += nAngleDelta;

    for(var i:Number = 0; i < nPoints; i++) {
      nPenX = nX + Math.cos(nAngle) * nOuterRadius;
      nPenY = nY + Math.sin(nAngle) * nOuterRadius;
      lineTo(nPenX, nPenY);
      nPenX = nX + Math.cos(nAngle + nAngleDelta / 2) * nInnerRadius;
      nPenY = nY + Math.sin(nAngle + nAngleDelta / 2) * nInnerRadius;
      lineTo(nPenX, nPenY);
      nAngle += nAngleDelta;
    }

  }

}