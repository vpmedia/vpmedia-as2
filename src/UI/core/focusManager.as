    class UI.core.focusManager extends UI.core.movieclip
    {
        var tabOrders, tabs, __index, __indexRef, hitList, tm, fr, __isFocused;
        function focusManager () {
            super();
            _global.fm = this;
            tabOrders = new Object ();
            tabs = new Array ();
            __index = 0;
            __indexRef = new Object ();
            hitList = new Array ();
            tm = new UI.core.tabManager(this);
            _global.tabs.registerContext("main");
            Mouse.addListener(this);
            Key.addListener(this);
            fr = _root.createEmptyMovieClip("fcm_focusrect", 20);
        }
        function onMouseDown() {
            var mcFocus = false;
            if ((eval (Selection.getFocus()) instanceof TextField) == true) {
                mcFocus = true;
            }
            var i = 0;
            while (i < hitList.length) {
                var mc = hitList[i];
                var mcHit = mc;
                if (mc.hitClip) {
                    mcHit = mc.hitClip;
                }
                if (mcHit.hitTest(_root._xmouse, _root._ymouse, false)) {
                    if ((_global.form_manager.whiteSpace._visible == true) && (mc.inForm != true)) {
                    } else if (isVisible(mc) != false) {
                        doFocus(mc);
                        return;
                    }
                }
                i++;
            }
        }
        function isVisible(mc) {
            var _local2 = mc;
            while (_local2 != _root) {
                if (_local2._visible == false) {
                    return (false);
                } else {
                    _local2 = _local2._parent;
                 }
            }
            return (true);
        }
        function doFocus(mc) {
            _global.tabs.onFocusMC(mc);
            fr.clear();
            __isFocused.isFocused = false;
            __isFocused.dispatchEvent("focusOut", {target:__isFocused});
            __isFocused.onKillFocus(false);
            mc.isFocused = true;
            mc.onSetFocus(false);
            __isFocused = mc;
            mc.dispatchEvent("focusIn", {target:mc});
            fr.clear();
        }
        function initFocus(mc) {
            __isFocused.isFocused = false;
            __isFocused.onKillFocus(true);
            mc.isFocused = true;
            mc.onSetFocus(true);
            __isFocused = mc;
            fr.clear();
            if (mc.focusRect == true) {
                drawFocusRect(mc);
            }
        }
        function removeAll() {
            tabOrders = new Array ();
        }
        function drawFocusRect(mc) {
            var _local6 = {x:0, y:0};
            mc.localToGlobal(_local6);
            fr.lineStyle(1, 1270433, 100);
            var _local3 = _local6.x - 1;
            var _local2 = _local6.y;
            var _local4 = mc.width + 2;
            var _local5 = mc.height + 1;
            dashTo(fr, _local3, _local2, _local3, _local2 + _local5, 4, 8);
            dashTo(fr, _local3, _local2 + _local5, _local3 + _local4, _local2 + _local5, 4, 8);
            dashTo(fr, _local3 + _local4, _local2 + _local5, _local3 + _local4, _local2, 4, 8);
            dashTo(fr, _local3 + _local4, _local2, _local3, _local2, 4, 8);
        }
        function registerMC(mc) {
            hitList.push(mc);
        }
        function blockFocus(mc) {
            var _local2 = 0;
            while (_local2 < hitList.length) {
                if (mc == hitList[_local2]) {
                    hitList.splice(_local2, 1);
                    break;
                }
                _local2++;
            }
        }
        function onKeyDown() {
            __isFocused.onKeyDown();
        }
        function onKeyUp() {
            __isFocused.onKeyUp();
        }
        function dashTo(mc, startx, starty, endx, endy, len, gap) {
            var _local11;
            var _local8;
            var _local7;
            var _local9;
            var _local2;
            var _local1;
            _local11 = len + gap;
            _local8 = endx - startx;
            _local7 = endy - starty;
            var _local10 = Math.sqrt((_local8 * _local8) + (_local7 * _local7));
            _local9 = Math.floor(Math.abs(_local10 / _local11));
            var _local4 = Math.atan2(_local7, _local8);
            _local2 = startx;
            _local1 = starty;
            _local8 = Math.cos(_local4) * _local11;
            _local7 = Math.sin(_local4) * _local11;
            var _local3 = 0;
            while (_local3 < _local9) {
                mc.moveTo(_local2, _local1);
                mc.lineTo(_local2 + (Math.cos(_local4) * len), _local1 + (Math.sin(_local4) * len));
                _local2 = _local2 + _local8;
                _local1 = _local1 + _local7;
                _local3++;
            }
            mc.moveTo(_local2, _local1);
            _local10 = Math.sqrt(((endx - _local2) * (endx - _local2)) + ((endy - _local1) * (endy - _local1)));
            if (_local10 > len) {
                mc.lineTo(_local2 + (Math.cos(_local4) * len), _local1 + (Math.sin(_local4) * len));
            } else if (_local10 > 0) {
                mc.lineTo(_local2 + (Math.cos(_local4) * _local10), _local1 + (Math.sin(_local4) * _local10));
            }
            mc.moveTo(endx, endy);
        }
    }
