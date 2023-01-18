    class UI.controls.TextArea extends UI.core.events
    {
        var createEmptyMovieClip, createTextField, attachMovie, vScroll, __text, format, mListener, dispatchEvent, __width, __height, __get__background, __get__border, UISpace, drawRect;
        function TextArea () {
            super();
            this.createEmptyMovieClip("UISpace", 0);
            this.createTextField("__text", 1, 1, 1, 1, 1);
            this.attachMovie("ScrollBar", "vScroll", 2);
            vScroll._y = 2;
            vScroll.addListener("scroll", onVScroll, this);
            vScroll.blockFocus();
            __text.addListener(this);
            __text.tabEnabled = true;
            format = new TextFormat ();
            format.font = "verdana";
            format.size = 10;
            __text.setNewTextFormat(format);
            __text.editable = false;
            __text.multiline = true;
            __text.wordWrap = true;
            __text.html = false;
            var owner = this;
            __text.onSetFocus = function () {
                if ((this.text == owner.__holder) && (owner.__holder != "")) {
                    this.text = "";
                }
                owner.dispatchEvent("focusIn", {target:owner});
            };
            __text.onKillFocus = function () {
                if ((this.text == "") && (owner.__holder != "")) {
                    this.text = owner.__holder;
                }
                owner.dispatchEvent("focusOut", {target:owner});
            };
            __text.onChanged = function () {
                owner.dispatchEvent("change", {target:owner});
            };
            var owner = this;
            __text.onScroller = function () {
                owner.vScroll.scrollPosition = this.scroll;
            };
            mListener = new Object ();
            mListener.onMouseWheel = function (delta) {
                owner.doWheel(delta);
            };
        }
        function doWheel(delta) {
            vScroll.scrollPosition = vScroll.scrollPosition - delta;
        }
        function onSetFocus() {
            Mouse.addListener(mListener);
        }
        function onKillFocus() {
            Mouse.removeListener(mListener);
        }
        function onVScroll() {
            __text.scroll = vScroll.scrollPosition;
        }
        function set holder(h) {
            if (__text.text == __holder) {
                __text.text = h;
            }
            if (__text.text == "") {
                __text.text = h;
            }
            __holder = h;
            //return (holder);
        }
        function set text(t) {
            __text.htmlText = t;
            dispatchEvent("change", {target:this});
            refresh();
            //return (text);
        }
		function set html(t){
			__text.html = t;
		}
        function get holder() {
            return (__holder);
        }
        function get text() {
            return (__text.htmlText);
        }
        function getText() {
            return (__text);
        }
        function set editable(b) {
            if (b == true) {
                __text.type = "input";
            } else {
                __text.type = "dynamic";
             }
            __text.editable = b;
            //return (editable);
        }
        function get editable() {
            if (__text.type == "input") {
                return (true);
            } else {
                return (false);
             }
        }
        function set selectable(s) {
            __text.selectable = s;
            //return (selectable);
        }
        function get selectable() {
            return (__text.selectable);
        }
        function get multiline() {
            return (__text.multiline);
        }
        function set multiline(m) {
            __text.multiline = m;
            //return (multiline);
        }
        function set background(b) {
            __background = b;
            setSize(__width, __height);
            //return (__get__background());
        }
        function set border(b) {
            __border = b;
            setSize(__width, __height);
            //return (__get__border());
        }
        function setFormat(prop, val) {
            format[prop] = val;
            __text.setTextFormat(format);
            __text.setNewTextFormat(format);
            refresh();
        }
        function setSize(width, height) {
            __width = width;
            __height = height;
            UISpace.clear();
            drawRect(UISpace, 0, 0, width, height, __border, 100);
            drawRect(UISpace, 1, 1, width - 2, height - 2, __background, 100);
            __text._width = width - 2;
            __text._height = height - 2;
            vScroll._x = width - 15;
            vScroll.setSize(height - 4);
            refresh();
        }
        function refresh() {
            __text._width = __width - 14;
            if (__text.textHeight > __height) {
                vScroll._visible = true;
            } else {
                vScroll._visible = false;
             }
            var _local2 = __text.maxscroll;
            var _local3 = __height / 14;
            vScroll.setScrollProperties(_local3, 1, _local2);
            vScroll.scrollPosition = __text.scroll;
            if (vScroll._visible == true) {
                __text._width = __width - 14;
            } else {
                __text._width = __width - 2;
             }
        }
        function setVScrollPosition(position) {
            vScroll.scrollPosition = position;
        }
        function getVScrollPosition(position) {
            return (Math.ceil(vScroll.scrollPosition));
        }
        function getMaxVScrollPosition() {
            return (__text.maxscroll);
        }
        var __background = 0xFFFFFF;
        var __border = 0xCCCCCC;
        var __holder = "";
    }
