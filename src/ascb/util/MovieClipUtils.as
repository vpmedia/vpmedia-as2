class ascb.util.MovieClipUtils {

  private static var _oDraggableIntervals:Object;
  private static var _oOutlines:Object;

  public static function makeDraggable(mcClip:MovieClip, bSnapTo:Boolean):Void {
    if(_oDraggableIntervals == undefined) {
      _oDraggableIntervals = new Object();
    }
    mcClip.onPressB = mcClip.onPress;
    mcClip.onPress = function():Void {
      var nXOffset:Number = (bSnapTo) ? 0 : -this._xmouse;
      var nYOffset:Number = (bSnapTo) ? 0 : -this._ymouse;
      _oDraggableIntervals[this._name] = setInterval(moveWithMouse, 10, this, nXOffset, nYOffset);
     this.onPressB();
    };
    mcClip.onReleaseB = mcClip.onRelease;
    mcClip.onRelease = function():Void {
      clearInterval(_oDraggableIntervals[this._name]);
      this.onReleaseB();
    };
  }

  private static function moveWithMouse(mcClip:MovieClip, nXOffset:Number, nYOffset:Number):Void {
    mcClip._x = mcClip._parent._xmouse + nXOffset;
    mcClip._y = mcClip._parent._ymouse + nYOffset;
    updateAfterEvent();
  }

  public static function getMovieClips(mcClip:MovieClip, bRecurse:Boolean):Array {
    var aMovieClips:Array = new Array();
    for(var sItem:String in mcClip) {
      if(mcClip[sItem] instanceof MovieClip) {
        if(bRecurse) {
          aMovieClips.push({movieclip: mcClip[sItem], nested: getMovieClips(mcClip[sItem], true)});
        }
        else {
          aMovieClips.push(mcClip[sItem]);
        }
      }
    }
    return aMovieClips;
  }

  public static function reverse(mcClip:MovieClip, bLoop:Boolean):Void {
    mcClip.stop();
    if(!bLoop) {
      mcClip.gotoAndStop(mcClip._totalframes);
    }
    mcClip.onEnterFrame = function():Void {
      if(this._currentframe > 1) {
        this.prevFrame();
      }
      else {
        if(bLoop) {
          this.gotoAndStop(this._totalframes);
        }
        else {
          delete this.onEnterFrame;
        }
      }
    };
  }

  public static function stop(mcClip:MovieClip):Void {
    mcClip.stop();
    delete mcClip.onEnterFrame;
  }

  public static function remove(mcClip:MovieClip):Void {
    mcClip.removeMovieClip();
    if(mcClip != undefined) {
      var mcTemp:MovieClip = mcClip._parent.getInstanceAtDepth(0);
      mcClip.swapDepths(0);
      mcClip.removeMovieClip();
      if(mcTemp != undefined) {
        mcTemp.swapDepths(0);
      }
    }
  }

  public static function duplicate(mcClip:MovieClip, sName:Object, nDepth:Object, oInit:Object, bDuplicateProperties:Boolean):MovieClip {
    if(nDepth == undefined) {
      nDepth = mcClip._parent.getNextHighestDepth();
    }
    if(sName == undefined) {
      sName = mcClip._name + String(nDepth);
    }
    if(oInit == undefined || oInit == null) {
      oInit = new Object();
    }
    if(bDuplicateProperties) {
      for(var sItem:String in mcClip) {
        oInit[sItem] = mcClip[sItem];
      }
    }
    return mcClip.duplicateMovieClip(String(sName), Number(nDepth), oInit);
  }

  public static function outline(mcClip:MovieClip, nCircleRadius:Number, bShow:Boolean):Void  {
    if(_oOutlines == undefined) {
      _oOutlines = new Object();
    }
    // Use a default radius of 2 pixels.
    if (nCircleRadius == undefined) {
      nCircleRadius = 2;
    }

    // Create an array for holding the references to the outline circles.
    _oOutlines[mcClip._name] = new Array();

    // Get the coordinates of the bounding box, and set the x and y variables
    // accordingly. The x variable must be more than the minimum x boundary because
    // otherwise the method will not be able to locate the shape.
    var oBounds:Object = mcClip.getBounds(mcClip);
    var nX:Number = oBounds.xMin + nCircleRadius;
    var nY:Number = oBounds.yMin;

    // Begin by outlining the shape from the top, left corner and  moving to the right
    // as x increases.
    var sDirection:String = "incX";
    var bDrawing:Boolean = true;
    var oPoints:Object;
    var nIndex:Number = 0;
    var mcCircle:MovieClip;
    var pCircle:ascb.drawing.Pen;

    // The bDrawing variable is true until the last circle is drawn.
    while (bDrawing) {
      nIndex++;

      // Create the new circle outline movie clip and draw a circle in it.
      pCircle = new ascb.drawing.Pen(mcClip, true);
      pCircle.drawCircle(nCircleRadius);

      // Set the circle visibility to false unless show is true.
      pCircle.target._visible = bShow ? true : false;

      // Add the circle movie clip to the outlines array for use during the hit test.
      _oOutlines[mcClip._name].push(pCircle.target);

      // Check to see in which direction the outline is being drawn.
      switch (sDirection) {
        case "incX":
           // Increment the x value by the width of one of the circles to move
          // the next circle just to the right of the previous one.
          nX += pCircle.target._width;

          // Create a point object and call localToGlobal() to convert
          // the values to the global equivalents.
          oPoints = {x: nX, y: nY};
          mcClip.localToGlobal(oPoints);

          // If the center of the circle does not touch the shape within the
          //  movie clip, increment y and calculate the new global equivalents 
          // for another hit test. This moves the circle down until it touches
          // the shape.
          while (!mcClip.hitTest(oPoints.x, oPoints.y, true)) {
            nY += pCircle.target._width;
            oPoints = {x: nX, y: nY};
            mcClip.localToGlobal(oPoints);
          }

          // If the maximum x boundary has been reached, set the new direction to
          // begin moving in the increasing y direction.
          if (nX >= oBounds.xMax - (pCircle.target._width)) {
            sDirection = "incY";
          }

          // Set the coordinates of the circle movie clip.
          pCircle.target._x = nX;
          pCircle.target._y = nY;

          // Reset y to the minimum y boundary, so that you can move the 
          // next circle down from the top until it touches the shape.
          nY = oBounds.yMin;
          break;

        case "incY":
          // The remaining cases are much like the first, but they 
          // move in different directions.
          nY += pCircle.target._width;
          oPoints = {x: nX, y: nY};
          mcClip.localToGlobal(oPoints);
          while (!mcClip.hitTest(oPoints.x, oPoints.y, true)) {
            nX -= pCircle.target._width;
            oPoints = {x: nX, y: nY};
            mcClip.localToGlobal(oPoints);
          }
          if (nY >= oBounds.yMax - (pCircle.target._width)) {
            sDirection = "decX";
          }
          pCircle.target._x = nX;
          pCircle.target._y = nY;
          nX = oBounds.xMax;
          break;

        case "decX":
          nX -= pCircle.target._width;
          oPoints = {x: nX, y: nY};
          mcClip.localToGlobal(oPoints);
          while (!mcClip.hitTest(oPoints.x, oPoints.y, true)) {
            nY -= pCircle.target._width;
            oPoints = {x: nX, y: nY};
            mcClip.localToGlobal(oPoints);
          }
          if (nX <= oBounds.xMin + (pCircle.target._width)) {
            sDirection = "decY";
          }
          pCircle.target._x = nX;
          pCircle.target._y = nY;
          nY = oBounds.yMax;
          break;

        case "decY":
          nY -= pCircle.target._width;
          oPoints = {x: nX, y: nY};
          mcClip.localToGlobal(oPoints);
          while (!mcClip.hitTest(oPoints.x, oPoints.y, true)) {
            nX += pCircle.target._width;
            oPoints = {x: nX, y: nY};
            mcClip.localToGlobal(oPoints);
          }
          if (nY <= oBounds.yMin + (pCircle.target._width)) {
            bDrawing = false;
          }
          pCircle.target._x = nX;
          pCircle.target._y = nY;
          nX = oBounds.xMin;
          break;
      }
    }
  }

  public static function hitTestOutline(mcClipA:MovieClip, mcClipB:MovieClip):Boolean {

    var oPoints:Object;
    var aOutlines:Array = _oOutlines[mcClipA._name];
    // Loop through all the elements of the outlines array.
    for (var i:Number = 0; i < aOutlines.length; i++) {
      // Create a point object and get the global equivalents.
      oPoints = {x: aOutlines[i]._x, y: aOutlines[i]._y};
      mcClipA.localToGlobal(oPoints);

      // If the mc movie clip tests true for overlapping with any of the outline
      // circles, then return true. Otherwise, the method returns false.
      if (mcClipB.hitTest(oPoints.x, oPoints.y, true)) {
        return true;
      }
    }
    return false;
  }

  public static function createTextField(mcClip:MovieClip, sInstanceName:String, nDepth:Number, nX:Number, nY:Number, nWidth:Number, nHeight:Number, oInit:Object):TextField {
    if(nDepth == undefined) {
      nDepth = mcClip.getNextHighestDepth();
    }
    if(sInstanceName == undefined) {
      sInstanceName = "__TextField" + nDepth;
    }
    if(nX == undefined) {
      nX = 0;
    }
    if(nY == undefined) {
      nY = 0;
    }
    if(nWidth == undefined) {
      nWidth = 100;
    }
    if(nHeight == undefined) {
      nHeight = 20;
    }
    mcClip.createTextField(sInstanceName, nDepth, nX, nY, nWidth, nHeight);
    for(var sItem:String in oInit) {
      mcClip[sInstanceName][sItem] = oInit[sItem];
    }
    return mcClip[sInstanceName];
  }

  public static function createAutoTextField(mcClip:MovieClip, sAlign:String, sInstanceName:String, nDepth:Number, nX:Number, nY:Number, nWidth:Number, nHeight:Number, oInit:Object):TextField {
    if(oInit == undefined) {
      oInit = new Object();
    }
    if(sAlign == undefined) {
      sAlign = "left";
    }
    oInit.autoSize = sAlign;
    return createTextField(mcClip, sInstanceName, nDepth, nX, nY, nWidth, nHeight, oInit);
  }

  public static function createInputTextField(mcClip:MovieClip, sInstanceName:String, nDepth:Number, nX:Number, nY:Number, nWidth:Number, nHeight:Number, oInit:Object):TextField {
    if(oInit == undefined) {
      oInit = new Object();
    }
    oInit.type = "input";
    oInit.border = true;
    oInit.background = true;
    return createTextField(mcClip, sInstanceName, nDepth, nX, nY, nWidth, nHeight, oInit);
  }

  public static function createNestedTextField(mcClip:MovieClip, sInstanceName:String, nDepth:Number, nX:Number, nY:Number, nWidth:Number, nHeight:Number, oInit:Object):MovieClip {
    if(nDepth == undefined) {
      nDepth = mcClip.getNextHighestDepth();
    }
    if(sInstanceName == undefined) {
      sInstanceName = "__TextHolder" + nDepth;
    }
    var mcTextHolder:MovieClip = mcClip.createEmptyMovieClip(sInstanceName, nDepth);
    createTextField(mcTextHolder, "textfield", 0, nX, nY, nWidth, nHeight, oInit);
    return mcTextHolder;

  }

}