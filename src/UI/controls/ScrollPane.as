    class UI.controls.ScrollPane extends UI.core.events
    {
        var attachMovie, createEmptyMovieClip, __hScroll, __vScroll, __content, dispatchEvent, __mask, drawRect;
        function ScrollPane () {
            super();
            this.attachMovie("ScrollBar", "__vScroll", 1);
            this.attachMovie("ScrollBar", "__hScroll", 2);
            this.createEmptyMovieClip("__mask", 3);
            __hScroll.direction = "Horizontal";
            __vScroll._visible = (__hScroll._visible = false);
            __vScroll.addListener("scroll", onVScroll, this);
            __hScroll.addListener("scroll", onHScroll, this);
        }
        function onVScroll() {
            __content._y = -__vScroll.scrollPosition;
            dispatchEvent("scroll", {target:this, vPosition:__vScroll.scrollPosition, hPosition:__hScroll.scrollPosition});
        }
        function onHScroll() {
            __content._x = -__hScroll.scrollPosition;
            dispatchEvent("scroll", {target:this, vPosition:__vScroll.scrollPosition, hPosition:__hScroll.scrollPosition});
        }
        function set content(c) {
            __content.removeMovieClip();
            this.attachMovie(c, "__content", 0);
            __content.setMask(__mask);
            refresh();
            //return (content);
        }
        function get content() {
            return (__content);
        }
        function get vPosition() {
            return (__vScroll.scrollPosition);
        }
        function get hPosition() {
            return (__hScroll.scrollPosition);
        }
        function set vPosition(p) {
            __vScroll.scrollPosition = p;
            //return (vPosition);
        }
        function set hPosition(p) {
            __hScroll.scrollPosition = p;
            //return (hPosition);
        }
        function refresh() {
			//trace("scrollPane refresh");
            if (__content._height > __height) {
                __vScroll._visible = true;
                _xoffset = 16;
            } else {
                __vScroll._visible = false;
                _xoffset = 0;
             }
            if (__content._width > __width) {
                __hScroll._visible = true;
                _yoffset = 16;
            } else {
                __hScroll._visible = false;
                _yoffset = 0;
             }
            var _local2 = (__content._height - __height) + _yoffset;
            __vScroll.setScrollProperties(_local2, 0, _local2);
            _local2 = (__content._width - __width) + _xoffset;
            __hScroll.setScrollProperties(_local2, 0, _local2);
            reposition();
        }
        function setSize(width, height) {
            __width = width;
            __height = height;
            __mask.clear();
            drawRect(__mask, 0, 0, width - _xoffset, height - _yoffset, 16777215, 100);
            __content.setMask(__mask);
			__content.setSize(width, height);
            reposition();
            refresh();
        }
		function get width(){
			return __width;
		}
		function get height(){
			return __height;
		}
        function reposition() {
            __vScroll._x = __width - 16;
            __vScroll.setSize(__height);
            __hScroll._y = __height - 16;
            if (__vScroll._visible == true) {
                __hScroll.setSize(__width - 16);
            } else {
                __hScroll.setSize(__width);
             }
        }
        var _yoffset = 0;
        var _xoffset = 0;
        var __width = 0;
        var __height = 0;
        var isContainer = true;
    }
