    class UI.core.events extends UI.core.movieclip
    {
        var createEmptyMovieClip, __to, listners, focusEnabled, tabEnabled, _focusrect, forwardEvent;
        function events () {
            super();
            if (!_global.fm) {
                _global.fm = new UI.core.focusManager();
            }
            this.createEmptyMovieClip("__to", -7);
            var o = this;
            __to.onSetFocus = function () {
                _global.fm.initFocus(o);
            };
            listners = new Object ();
            focusEnabled = false;
            tabEnabled = false;
            _focusrect = false;
            _global.fm.registerMC(this);
        }
        function blockFocus() {
            _global.fm.blockFocus(this);
        }
        function tabOwner() {
            return (__to);
        }
        function getFocus() {
            var selFocus = Selection.getFocus();
            return (((selFocus === null) ? null : (eval (selFocus))));
        }
        function setFocus() {
            Selection.setFocus(this);
        }
        function notab(mc) {
            mc._focusrect = false;
            mc.focusEnabled = false;
            mc.tabEnabled = false;
        }
        function dispatchEvent(type, par) {
            var _local4 = new Array ();
            _local4.push(par);
            var _local3;
            if (!forwardEvent) {
                _local3 = listners[type];
            } else {
                _local3 = forwardEvent.listners[type];
             }
            var _local2 = 0;
            while (_local2 < _local3.length) {
                _local3[_local2].cb.apply(_local3[_local2].ct, _local4);
                _local2++;
            }
        }
        function addListener(type, callback, context) {
            var _local2 = listners[type];
            if (!_local2) {
                _local2 = (listners[type] = new Array ());
            }
            _local2.push({ct:context, cb:callback});
        }
        function removeListener(type, callback) {
            var _local3 = listners[type];
            var _local2 = 0;
            while (_local2 < _local3.length) {
                if (_local3[_local2].cb == callback) {
                    _local3.splice(_local2, 1);
                    break;
                }
                _local2++;
            }
        }
    }
