    class UI.controls.Button extends UI.core.events
    {
        var createEmptyMovieClip, createTextField, space4, UISpace, label_txt, hitSpace, __enable, __down, dispatchEvent, __waitForUp, __over, __get__enabled, __icon_holder, attachMovie, __width, __height, __get__icon, drawRect;
        function Button () {
            super();
            this.createEmptyMovieClip("UISpace", 0);
            this.createTextField("label_txt", 1, 0, 0, 50, 50);
            this.createEmptyMovieClip("hitSpace", 3);
            space4 = UISpace;
            space4.attachMovie("SB_S1", "p1", 10);
            space4.attachMovie("SB_S2", "p2", 11);
            space4.attachMovie("SB_S3", "p3", 12);
            space4.p1._x = (space4.p2._x = (space4.p3._x = 2));
            space4.p1._y = (space4.p2._y = (space4.p3._y = 2));
            space4.p2._x = 2 + space4.p1._width;
            space4.p1._yscale = 50;
            space4.p2._yscale = 50;
            space4.p3._yscale = 50;
            label_txt.autoSize = true;
            label_txt.selectable = false;
            label_txt.owner = this;
            var _local3 = new TextFormat ();
            _local3.font = "Verdana";
            _local3.size = 10;
            label_txt.setNewTextFormat(_local3);
            UISpace.attachMovie("Button_lower_left", "bll", 0);
            UISpace.attachMovie("Button_lower_right", "blr", 1);
            UISpace.attachMovie("Button_top_left", "btl", 2);
            UISpace.attachMovie("Button_top_right", "btr", 3);
            UISpace.attachMovie("Button_top_bar", "btb", 4);
            UISpace.attachMovie("Button_body", "body", 5);
            UISpace.attachMovie("Button_left_bar", "blb", 6);
            UISpace.attachMovie("Button_right_bar", "brb", 7);
            UISpace.attachMovie("Button_lower_bar", "blbb", 8);
            UISpace.btb._x = (UISpace.body._x = (UISpace.body._y = (UISpace.blb._y = (UISpace.brb._y = (UISpace.blbb._x = 5)))));
            var owner = this;
            hitSpace.onPress = (space4.onPress = function () {
                owner.doPress();
            });
            hitSpace.onRollOver = function () {
                owner.doRollOver();
            };
            hitSpace.onRelease = (space4.onRelease = function () {
                owner.doRelease();
            });
            hitSpace.onReleaseOutside = (space4.onReleaseOutside = function () {
                owner.doRollOut();
            });
            hitSpace.onRollOut = function () {
                owner.doRollOut();
            };
            hitSpace.useHandCursor = false;
            hitSpace._focusrect = false;
            hitSpace.tabEnabled = false;
            space4.useHandCursor = false;
            space4._focusrect = false;
            space4.tabEnabled = false;
            setSurface(1);
        }
        function onSetFocus(tab) {
            if (tab == true) {
                doRollOver();
            } else {
                doPress();
             }
        }
        function onKillFocus(tab) {
            if (tab != false) {
                if (__enable != false) {
                    __down = false;
                    setSurface(-1);
                }
            }
            dispatchEvent("onRollOut", {target:this});
        }
        function onKeyDown() {
            if (Key.isDown(13) || (Key.isDown(32))) {
                doPress();
                __waitForUp = true;
            }
        }
        function onKeyUp() {
            if (__waitForUp == true) {
                doRelease();
                __waitForUp = false;
            }
        }
        function doPress() {
            if (__enable != false) {
                __down = true;
                setSurface(3);
                dispatchEvent("onRollOut", {target:this});
            }
        }
        function doRelease() {
            if (__enable != false) {
                dispatchEvent("click", {target:this});
                __down = false;
                setSurface(-1);
            }
        }
        function doRollOver() {
            dispatchEvent("onRollOver", {target:this});
            if (__enable != false) {
                __over = false;
                setSurface(2);
            }
        }
        function doRollOut() {
            dispatchEvent("onRollOut", {target:this});
            if (__enable != false) {
                __over = false;
                setSurface(1);
            }
        }
        function set enabled(e) {
			label_txt.textColor = e ? 0x000000 : 0x666666;
			__icon_holder.gotoAndStop( e ? 1 : 2);
            __enable = e;
            if (e == false) {
                setSurface(0);
            } else {
                setSurface(-1);
             }
            //return (__get__enabled());
        }
        function set icon(i) {
            __icon_holder.removeMovieClip();
            this.attachMovie(i, "__icon_holder", 2);
            setSize(__width, __height);
            //return (__get__icon());
        }
        function get label() {
            return (label_txt.text);
        }
        function set label(l) {
            label_txt.text = l;
            setSize(__width, __height);
            //return (label);
        }
        function setSize(width, height) {
            UISpace.bll._y = (UISpace.blr._y = (UISpace.blbb._y = height - 5));
            UISpace.blr._x = (UISpace.btr._x = (UISpace.brb._x = width - 5));
            UISpace.btb._width = width - 10;
            UISpace.body._width = (UISpace.blbb._width = width - 10);
            UISpace.body._height = (UISpace.blb._height = (UISpace.brb._height = height - 10));
			label_txt._x = Math.round((width / 2) - (label_txt.textWidth / 2)) - 3;
            label_txt._y = Math.round((height / 2) - (label_txt.textHeight / 2)) - 2;
            __icon_holder._x = ((width / 2) - (__icon_holder._width / 2)) - label_txt.textWidth;
            __icon_holder._y = (height / 2) - (__icon_holder._height / 2);
            var _local4 = width - 4;
            space4.p2._width = _local4 - (space4.p1._width + space4.p3._width);
            space4.p3._x = (_local4 - space4.p3._width) + 2;
            hitSpace.clear();
            drawRect(hitSpace, 0, 0, width, height, 0, 0);
            __width = width;
            __height = height;
        }
		function move(x,y){
			this._x = x;
			this._y = y;
		}
        function setSurface(type) {
            if (type == -1) {
                type = 1;
                if (__over == true) {
                    type = 2;
                }
                if (__down == true) {
                    type = 3;
                }
            }
            var _local2 = type + 1;
            UISpace.bll.gotoAndStop(_local2);
            UISpace.blr.gotoAndStop(_local2);
            UISpace.btl.gotoAndStop(_local2);
            UISpace.btr.gotoAndStop(_local2);
            UISpace.btb.gotoAndStop(_local2);
            UISpace.body.gotoAndStop(_local2);
            UISpace.blb.gotoAndStop(_local2);
            UISpace.brb.gotoAndStop(_local2);
            UISpace.blbb.gotoAndStop(_local2);
        }
    }
