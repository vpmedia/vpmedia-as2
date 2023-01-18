    class UI.controls.UIList.ExpandRender extends UI.core.events
    {
        var createTextField, attachMovie, createEmptyMovieClip, notab, expander, ExpandedDataHolder, label_txt, hl, List, __get__data, __icon, iconSpace, __width, __height, hitSpace, drawRect;
        function ExpandRender () {
            super();
            this.createTextField("label_txt", 0, 0, 0, 50, 50);
            this.attachMovie("ExpandRenderDataHolder", "ExpandedDataHolder", 1);
            this.createEmptyMovieClip("hitSpace", 2);
            this.attachMovie("TreeExpand", "expander", 3);
            notab(expander);
            var owner = this;
            ExpandedDataHolder._y = 19;
            ExpandedDataHolder._visible = false;
            label_txt.autoSize = true;
            label_txt.selectable = false;
            label_txt.owner = this;
            expander._y = 6;
            expander._x = 2;
            expander.onPress = function () {
                var _local2 = this._currentframe;
                if (_local2 == 1) {
                    this.gotoAndStop(2);
                    owner.ExpandedDataHolder._visible = true;
                } else {
                    this.gotoAndStop(1);
                    owner.ExpandedDataHolder._visible = false;
                 }
                owner.List.onChangeHeight(owner, owner.getBestHeight());
            };
            var _local3 = new TextFormat ();
            _local3.font = "verdana";
            _local3.size = 10;
            label_txt._y = 1;
            label_txt.setNewTextFormat(_local3);
        }
        function onKeyDown() {
            if (Key.isDown(13)) {
                var _local2 = expander._currentframe;
                if (_local2 == 1) {
                    expander.gotoAndStop(2);
                    ExpandedDataHolder._visible = true;
                } else {
                    expander.gotoAndStop(1);
                    ExpandedDataHolder._visible = false;
                 }
                hl._height = getBestHeight();
                List.onChangeHeight(this, getBestHeight());
            }
        }
        function set label(l) {
            label_txt.text = l;
            //return (label);
        }
        function get label() {
            return (label_txt.text);
        }
        function set data(data) {
            var _local2 = 0;
            while (_local2 < data.length) {
                var _local3 = data[_local2];
                ExpandedDataHolder.addItem(_local3.label, _local3.data);
                _local2++;
            }
            //return (__get__data());
        }
        function set icon(i) {
            __icon = i;
            iconSpace.removeMovieClip();
            this.attachMovie(i, "iconSpace", 3);
            setSize(__width, __height);
            //return (icon);
        }
        function get icon() {
            return (__icon);
        }
        function getBestHeight() {
            if (ExpandedDataHolder._visible == false) {
                return (List.__rowHeight);
            } else {
                return (List.__rowHeight + ExpandedDataHolder._height);
             }
        }
        function getWidth() {
            return (label_txt._x + label_txt.textWidth);
        }
        function setSize(width, height, trueWidth) {
            if (iconSpace) {
                label_txt._x = (14 + iconSpace._width) + 2;
            } else {
                label_txt._x = 14;
             }
            label_txt._width = width - iconSpace._width;
            label_txt._height = height;
            iconSpace._y = (height / 2) - (iconSpace._height / 2);
            hitSpace.clear();
            drawRect(hitSpace, 0, 0, width, height, 16777215, 0);
            __width = width;
            __height = height;
            ExpandedDataHolder.width = trueWidth - 6;
        }
    }
