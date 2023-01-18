    class UI.controls.Label extends UI.core.events
    {
        var createEmptyMovieClip, createTextField, __text, format, UISpace, notab, blockFocus, __link, __image, getURL, dispatchEvent, __width, __height, __get__link, drawRect, _x;
        function Label () {
            super();
            this.createEmptyMovieClip("UISpace", 0);
            this.createTextField("__text", 1, 0, 0, 1, 1);
            __text.type = "dynamic";
            __text.tabEnabled = false;
            __text.selectable = false;
            format = new TextFormat ();
            format.font = "Verdana";
            format["color"] = 0;
            format.size = 10;
            __text.setNewTextFormat(format);
            var owner = this;
            UISpace.onRollOver = function () {
                if (owner.__link || (owner.__image)) {
                    owner.setFormat("underline", true);
                }
            };
            UISpace.onRollOut = (UISpace.onReleaseOutside = function () {
                if (owner.__link || (owner.__image)) {
                    owner.setFormat("underline", false);
                }
            });
            UISpace.onRelease = function () {
                if (owner.__link) {
                    if (typeof (owner.__link) == "string") {
                        (this.getURL(owner.__link, "_blank"));// not popped
                    } else {
                        owner.dispatchEvent("click", {target:owner});
                     }
                }
                if (owner.__image) {
                    if (typeof (owner.__image) == "string") {
                        owner.dispatchEvent("click", {target:owner});
                    }
                }
            };
            UISpace.useHandCursor = false;
            notab(UISpace);
            blockFocus();
        }
        function setAlpha(alpha) {
            __text._alpha = alpha;
        }
        function onSetFocus() {
            if (__link || (__image)) {
                setFormat("underline", true);
            }
        }
        function onKillFocus() {
            if (__link || (__image)) {
                setFormat("underline", false);
            }
        }
        function onKeyDown() {
            if (Key.isDown(13)) {
                if (__link) {
                    if (typeof (__link) == "string") {
                        (this.getURL(__link, "_blank"));// not popped
                    } else {
                        dispatchEvent("click", {target:this});
                     }
                }
                if (__image) {
                    if (typeof (__image) == "string") {
                        dispatchEvent("click", {target:this});
                    }
                }
            }
        }
        function set text(t) {
            __text.text = t;
            adjustForAutoSize();
            dispatchEvent("change", {target:this});
            //return (text);
        }
        function get text() {
            return (__text.text);
        }
        function get width() {
            return (__width);
        }
        function get height() {
            return (__height);
        }
        function set link(l) {
            __link = l;
            UISpace.useHandCursor = true;
            //return (__get__link());
        }
        function getText() {
            return (__text);
        }
        function set image(image) {
            __image = image;
            UISpace.useHandCursor = true;
            //return (this.image);
        }
        function getImage() {
            return (__image);
        }
        function get image() {
            return (__image);
        }
        function setEmbedFonts(embed) {
            __text.embedFonts = embed;
        }
        function setFormat(prop, val) {
            format[prop] = val;
            __text.setTextFormat(format);
            __text.setNewTextFormat(format);
            if (__autoSize != "none") {
                adjustForAutoSize();
            }
        }
        function get autoSize() {
            return (__autoSize);
        }
        function set autoSize(v) {
            __autoSize = v;
            adjustForAutoSize();
            //return (autoSize);
        }
        function setSize(width, height) {
            __width = width;
            __height = height;
            UISpace.clear();
            drawRect(UISpace, 0, 0, width, height, 0, 0);
            __text._width = width;
            __text._height = height;
        }
        function adjustForAutoSize() {
            var _local2 = __text;
            var _local3 = __autoSize;
            if ((_local3 != undefined) && (_local3 != "none")) {
                var _local5 = _local2.textHeight + 6;
                if (format.underline == true) {
                    _local5 = _local5 + 5;
                }
                _local2._height = _local5;
                var _local4 = __width;
                setSize(_local2.textWidth + 5, _local2._height);
                if (_local3 == "right") {
                    _x = _x + (_local4 - __width);
                } else if (_local3 == "center") {
                    _x = _x + ((_local4 - __width) / 2);
                } else if (_local3 == "left") {
                    _x = _x + 0;
                }
            } else {
                _local2._x = 0;
                _local2._width = __width;
                _local2._height = __height;
             }
        }
        var __autoSize = "none";
    }
