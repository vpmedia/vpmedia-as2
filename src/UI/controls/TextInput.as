    class UI.controls.TextInput extends UI.core.events
    {
        var createEmptyMovieClip, createTextField, __text, format, rolloverDetect, __get__password, dispatchEvent, __width, __height, __get__background, __get__border, UISpace, drawRect, __textFocus;
        function TextInput () {
            super();
            this.createEmptyMovieClip("UISpace", 0);
            this.createEmptyMovieClip("__textFocus", 1);
            this.createTextField("__text", 2, 1, 1, 1, 1);
            __text.type = "input";
            __text.tabEnabled = false;
            format = new TextFormat ();
            format.font = "Verdana";
            format.size = 10;
            __text.setNewTextFormat(format);
            rolloverDetect.owner = this;
            rolloverDetect.onRollOver = function () {
                this._visible = false;
                owner.dispatchEvent("onRollOver", {target:owner});
            };
            rolloverDetect.onRollOut = function () {
                this._visible = true;
                owner.dispatchEvent("onRollOut", {target:owner});
            };
            var owner = this;
            __text.onSetFocus = function () {
                _global.fm.fr.clear();
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
                if (owner.noEvent != true) {
                    owner.dispatchEvent("change", {target:owner});
                } else {
                    owner.noEvent = false;
                 }
            };
        }
        function set password(p) {
            __text.password = p;
            //return (__get__password());
        }
        function onSetFocus(tabbed) {
        }
        function onKillFocus() {
        }
        function onKeyDown() {
            if (Key.isDown(13) == true) {
                dispatchEvent("enter", {target:this});
            }
        }
        function tabOwner() {
            return (__text);
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
            __text.text = t;
            dispatchEvent("change", {target:this});
            //return (text);
        }
        function setText(t) {
            __text.text = t;
        }
        function get holder() {
            return (__holder);
        }
        function get text() {
            return (__text.text);
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
            //return (editable);
        }
        function set enabled(b) {
            editable = (b);
            //return (enabled);
        }
        function get enabled() {
            return (editable);
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
        }
        function setSize(width, height) {
            __width = width;
            __height = height;
            UISpace.clear();
            drawRect(UISpace, 0, 0, width, height, __border, 100);
            drawRect(UISpace, 1, 1, width - 2, height - 2, __background, 100);
            __text._width = width - 2;
            __text._height = height - 2;
            __textFocus.clear();
            drawRect(__textFocus, 0, 0, __text._width, __text._height, 0, 0);
        }
        var __background = 0xFFFFFF;
        var __border = 0xCCCCCC;
        var __holder = "";
    }
