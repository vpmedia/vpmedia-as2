class am.comp.PageFlip extends MovieClip {

	//-- COMPONENT PARAMETER
	var symbolId: String;
	var page_width: Number;
	var page_height: Number;
	var mouseAreaDim: Number;
	var startPage: Number;
	var gradientWidth: Number;
	var highlight: Number;
	var highlightStrength: Number;
	var shadow: Number;
	var shadowStrength: Number;
	var blendOffset: Number;
	var dampMouse: Number;

	//-- PRECOMPUTE VALUES
	var diagonal: Number;
	var totalPages: Number;

	//-- MOUSE SENSITIV AREAS
	var rightMouseArea: MovieClip;
	var leftMouseArea: MovieClip;

	//-- PHYSICS HANDLER
	var handler: MovieClip;

	//-- MASK
	var mask0: MovieClip;
	var mask1: MovieClip;
	var gradient0_mask: MovieClip;
	var gradient1_mask: MovieClip;
	var gradient0: MovieClip;
	var gradient1: MovieClip;
	var pageL: MovieClip;
	var pageR: MovieClip;
	var subjacentPage: MovieClip;
	var dragPage: MovieClip;

	var dragDirection: String;

	function PageFlip ()
	{
		totalPages = getTotalPages();
		startPage -= startPage % 2;
		diagonal = Math.sqrt( page_width * page_width + page_height * page_height );
		//drawBorder();
		attachPages();
		createMouseSensitivArea();
		checkMouseAreaEnabled();
	}

	function getTotalPages(): Number
	{
		var getPage = attachMovie( symbolId , "getPage" , 0 );
		var frames = getPage._totalframes;
		getPage.removeMovieClip();
		return frames;
	}

	function attachPages () {

		//-- ATTACH VISIBLE PAGES
		pageL = attachMovie( symbolId , "pageL" , 20 , { _x:-page_width, _y: page_height } );
		pageR = attachMovie( symbolId , "pageR" , 21 , { _y: page_height } );

		pageL.gotoAndStop( startPage + 1 );
		pageR.gotoAndStop( startPage + 2 );

	}

	function createHandler ( d )
	{
		attachMovie( "pt" , "handler" , 100001 , { _visible: 0 } );
		handler._x = page_width * d;
		handler._y = page_height;
	}

	function switchPage( direction ):Void
	{
		if ( direction == 'left' && dragDirection == 'right' )
			startPage += 2
		else if ( direction == 'right' && dragDirection == 'left' )
			startPage -= 2
		removeAssembly();
		attachPages();
		checkMouseAreaEnabled();
	}

	function checkMouseAreaEnabled(): Void
	{
		leftMouseArea.enabled = ( startPage > 0 )
		rightMouseArea.enabled = ( startPage < totalPages - 2 );
	}

	function startDragging ( direction )
	{
		_root.helper._visible = 0;
		dragDirection = direction;
		subjacentPage = attachMovie( symbolId , "subjacentPage" , 11 , { _y: page_height } );
		dragPage = attachMovie( symbolId , "dragPage" , 30 );
		if ( dragDirection == 'right' )
		{
			//-- FORWARD
			subjacentPage.gotoAndStop( startPage + 4 );
			createHandler( 1 );
			dragPage.gotoAndStop( startPage + 3 );
		}
		else
		{
			//-- BACKWARDS
			subjacentPage.gotoAndStop( startPage + 2 );
			dragPage.gotoAndStop( startPage + 1 );
			pageL.gotoAndStop( startPage - 1 );
			pageR.gotoAndStop( startPage );
			createHandler( -1 );
		}
		createAssembly();
		onEnterFrame = dragging;
		onEnterFrame();
	}

	function stopDragging () {
		rightMouseArea.enabled = leftMouseArea.enabled = false;
		onEnterFrame = ( _xmouse > 0 ) ? rewind : forward;
	}

	function dragging():Void
	{
		handler._x += ( _xmouse - handler._x ) / dampMouse;
		handler._y += ( _ymouse - handler._y ) / dampMouse;
		movePage( handler._x , handler._y );
	}

	function rewind():Void
	{
		handler._x += ( page_width - handler._x ) / dampMouse;
		handler._y += ( page_height - handler._y ) / dampMouse;
		movePage( handler._x , handler._y );
		if ( Math.abs( handler._x - page_width ) + Math.abs( handler._y - page_height ) < 1 )
		{
			handler._x = page_width;
			handler._y = page_height;
			delete onEnterFrame;
			switchPage( 'right' );
		}
	}

	function forward():Void
	{
		handler._x += ( -page_width - handler._x ) / dampMouse;
		handler._y += ( page_height - handler._y ) / dampMouse;
		movePage( handler._x , handler._y );
		if ( Math.abs( handler._x + page_width ) + Math.abs( handler._y - page_height ) < 1 )
		{
			handler._x = page_width;
			handler._y = page_height;
			delete onEnterFrame;
			switchPage( 'left' );
		}
	}

	function createMouseSensitivArea () {

		rightMouseArea = createEmptyMovieClip( "rightMouseArea" , 0 );
		rightMouseArea.side = 'right';
		rightMouseArea.beginFill( 0xffcc00 , 0 );
		rightMouseArea.moveTo( page_width - mouseAreaDim , page_height );
		rightMouseArea.lineTo( page_width , page_height );
		rightMouseArea.lineTo( page_width , page_height - mouseAreaDim );
		rightMouseArea.lineTo( page_width - mouseAreaDim , page_height );
		rightMouseArea.endFill();

		leftMouseArea = createEmptyMovieClip( "leftMouseArea" , 1 );
		leftMouseArea.side = 'left';
		leftMouseArea.beginFill( 0xffcc00 , 0 );
		leftMouseArea.moveTo( -page_width + mouseAreaDim , page_height );
		leftMouseArea.lineTo( -page_width , page_height );
		leftMouseArea.lineTo( -page_width , page_height - mouseAreaDim );
		leftMouseArea.lineTo( -page_width + mouseAreaDim , page_height );
		leftMouseArea.endFill();

		rightMouseArea.PageFlip = leftMouseArea.PageFlip = this;

		rightMouseArea.onPress = leftMouseArea.onPress = function ()
		{
			this.PageFlip.startDragging( this.side );
		}

		rightMouseArea.onRelease = rightMouseArea.onReleaseOutside = leftMouseArea.onRelease = leftMouseArea.onReleaseOutside = function ()
		{
			this.PageFlip.stopDragging();
		}

	}

	function createAssembly()
	{
		var ratios, colors, alphas, matrix;
		ratios = [ 0 , 0xff ];

		colors = [ shadow, shadow ];
		alphas = [ 0, shadowStrength ];
		matrix = { matrixType:"box", x:-gradientWidth, y:0, w:gradientWidth, h:diagonal, r:0 };
		gradient0 = createEmptyMovieClip( "gradient0" , 25 );
		gradient0.beginGradientFill( "linear", colors, alphas, ratios, matrix );
		gradient0.moveTo ( -gradientWidth , -page_width );
		gradient0.lineTo( 0 , -page_width );
		gradient0.lineTo( 0 , diagonal );
		gradient0.lineTo( -gradientWidth , diagonal );
		gradient0.lineTo ( -gradientWidth , -page_width );
		gradient0.endFill();

		colors = [ highlight, highlight ];
		alphas = [ highlightStrength , 0 ];
		matrix = { matrixType:"box", x:0, y:0, w:gradientWidth, h:diagonal, r:0 };

		gradient0.beginGradientFill( "linear", colors, alphas, ratios, matrix );
		gradient0.moveTo ( 0 , -page_width );
		gradient0.lineTo( gradientWidth , -page_width );
		gradient0.lineTo( gradientWidth , diagonal );
		gradient0.lineTo( 0 , diagonal );
		gradient0.lineTo ( 0 , -page_width );
		gradient0.endFill();

		//-- GRADIENT PAGE SHADOW
		gradient1 = createEmptyMovieClip( "gradient1" , 50 );

		colors = [ shadow, shadow ];
		alphas = [ 0, shadowStrength ];
		matrix = { matrixType:"box", x:0, y:0, w:gradientWidth, h:diagonal, r: Math.PI };

		gradient1.beginGradientFill( "linear", colors, alphas, ratios, matrix );
		gradient1.moveTo ( 0 , -page_width );
		gradient1.lineTo( gradientWidth , -page_width );
		gradient1.lineTo( gradientWidth , diagonal );
		gradient1.lineTo( 0 , diagonal );
		gradient1.lineTo ( 0 , -page_width );
		gradient1.endFill();

		mask0 = createEmptyMovieClip( "mask0" , 100 );
		mask0.beginFill( 0xffcc00 );
		mask0.moveTo ( 0 , -page_width );
		mask0.lineTo( diagonal , -page_width );
		mask0.lineTo( diagonal , diagonal );
		mask0.lineTo( 0 , diagonal );
		mask0.lineTo ( 0 , -page_width );
		mask0.endFill();

		mask1 = createEmptyMovieClip( "mask1" , 101 );
		mask1.beginFill( 0xffcc00 );
		mask1.moveTo ( 0 , -page_width );
		mask1.lineTo( diagonal , -page_width );
		mask1.lineTo( diagonal , diagonal );
		mask1.lineTo( 0 , diagonal );
		mask1.lineTo ( 0 , -page_width );
		mask1.endFill();

		gradient0_mask = createEmptyMovieClip( "gradient0_mask" , 200 );
		gradient0_mask.beginFill( 0xffff00 );
		gradient0_mask.moveTo( -page_width , 0 );
		gradient0_mask.lineTo(  page_width , 0 );
		gradient0_mask.lineTo(  page_width , page_height );
		gradient0_mask.lineTo( -page_width , page_height );
		gradient0_mask.lineTo( -page_width , 0 );
		gradient0_mask.endFill();

		gradient1_mask = createEmptyMovieClip( "gradient1_mask" , 201 );
		gradient1_mask.beginFill( 0xffcc00 );
		gradient1_mask.moveTo ( 0 , 0 );
		gradient1_mask.lineTo( page_width , 0 );
		gradient1_mask.lineTo( page_width , -page_height );
		gradient1_mask.lineTo( 0 , -page_height );
		gradient1_mask.lineTo ( 0 , 0 );
		gradient1_mask.endFill();

		dragPage.setMask( mask0 );
		pageR.setMask( mask1 );
		gradient0.setMask( gradient0_mask );
		gradient1.setMask( gradient1_mask );

	}

	function removeAssembly():Void
	{
		pageL.removeMovieClip();
		pageR.removeMovieClip();
		mask0.removeMovieClip();
		mask1.removeMovieClip();
		gradient0.removeMovieClip();
		gradient1.removeMovieClip();
		dragPage.removeMovieClip();
		subjacentPage.removeMovieClip();
		gradient0_mask.removeMovieClip();
		gradient1_mask.removeMovieClip();
		handler.removeMovieClip();

		delete pageL;
		delete pageR;
		delete mask0;
		delete mask1;
		delete gradient0;
		delete gradient1;
		delete dragPage;
		delete subjacentPage;
		delete gradient0_mask;
		delete gradient1_mask;
		delete handler;
	}

	function movePage ( cx , cy )
	{
		if ( cx < -page_width ) cx = -page_width
		else if ( cx > page_width ) cx = page_width;
		var dx,dy,len, cx2, ldw, ldh, alpha;
		len = Math.sqrt( ( cx2 = cx * cx ) + ( dy = cy - page_height ) * dy );
		//-- UPPER CONSTRAIN
		if ( len > page_width )
		{
			cx /= ( ldw = len / page_width );
			cy = page_height + dy / ldw;
		}
		//-- LOWER CONSTRAIN
		len = Math.sqrt( cx2 + cy * cy );
		if ( len > diagonal )
		{
			cx /= ( ldh = len / diagonal );
			cy /= ldh;
		}
		dragPage._x = gradient1_mask._x = cx;
		dragPage._y = gradient1_mask._y = cy;
		dx = page_width - cx;
		dy = page_height - cy;
		alpha = Math.atan2( dy , dx );
		var bx = mask0._x = mask1._x = gradient0._x = gradient1._x = page_width - ( Math.sqrt( dx * dx + dy * dy ) / 2 ) / Math.cos( alpha );
		var by = mask0._y = mask1._y = gradient0._y = gradient1._y = page_height;
		mask0._rotation = mask1._rotation = gradient0._rotation = gradient1._rotation = ( alpha + Math.PI ) * 180 / Math.PI;
		alpha = Math.atan2( by - cy , bx - cx );
		dragPage._rotation = gradient1_mask._rotation = alpha * 180 / Math.PI;
		var dx = -page_width - cx;
		var dy = page_height - cy;
		var len = Math.sqrt( dx * dx + dy * dy );
		var range = page_width / 50 * blendOffset;
		//-- Fadeout Gradients
		if ( len < range )
		{
			gradient0._xscale = gradient1._xscale = gradient0._alpha = gradient1._alpha = len / range * 100;
		} else {
			gradient0._xscale = gradient1._xscale = gradient0._alpha = gradient1._alpha = 100;
		}
	}

	function drawBorder () {

		lineStyle( 0 );
		moveTo( -page_width , 0 );
		lineTo(  page_width , 0 );
		lineTo(  page_width , page_height );
		lineTo( -page_width , page_height );
		lineTo( -page_width , 0 );

		moveTo( 0 , 0 );
		lineTo( 0 , page_height );

	}

}