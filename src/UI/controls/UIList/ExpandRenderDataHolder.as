    class UI.controls.UIList.ExpandRenderDataHolder extends UI.core.events
    {
        var createEmptyMovieClip, __count, __children, format, longestChar, __width, __get__width, createTextField, back, drawRect;
        function ExpandRenderDataHolder () {
            super();
            this.createEmptyMovieClip("back", -1);
            __count = 0;
            __children = new Array ();
            format = new TextFormat ();
            format.font = "verdana";
            format.size = 10;
            format.bold = true;
        }
        function addItem(label1, label2) {
            var _local2 = createLabel(label1);
            var _local4 = createLabel(label2);
            __children.push({t1:_local2, t2:_local4});
            if (!longestChar) {
                longestChar = _local2;
            }
            if (label1.length > longestChar.text.length) {
                longestChar = _local2;
            }
            redraw();
        }
        function set width(w) {
            __width = w;
            redraw();
            //return (__get__width());
        }
        function createLabel(label) {
            this.createTextField("txt" + __count, __count, 0, 0, 0, 0);
            var _local2 = this["txt" + __count];
            __count++;
            _local2.setNewTextFormat(format);
            _local2.text = label;
            _local2.autoSize = true;
            _local2.selectable = false;
            return (_local2);
        }
        function redraw() {
            back.clear();
            drawRect(back, 0, 0, __width, __children.length * 18, 15595519, 100);
            var _local3 = 0;
            while (_local3 < __children.length) {
                var _local2 = __children[_local3];
                var _local4 = (_local3 * 16) + 1;
                _local2.t1._y = (_local2.t2._y = _local4);
                _local2.t1._x = 15;
                _local2.t2._x = 20 + longestChar.textWidth;
                _local3++;
            }
        }
    }
