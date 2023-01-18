    class UI.controls.Menu extends UI.core.events
    {
        var createEmptyMovieClip, rowSpace, UISpace, __open, outSideML, mListner, __data, __width, __height, children, rowMask, drawRect, _x, _y;
        function Menu () {
            super();
            this.createEmptyMovieClip("UISpace", 0);
            rowSpace = UISpace.createEmptyMovieClip("rowSpace", 1);
            this.createEmptyMovieClip("rowMask", 2);
            onKeyDown = this.onKeyDown();
            __open = false;
            outSideML = new Object ();
            mListner = new Object ();
            var owner = this;
            mListner.onMouseDown = function () {
                if (!owner.hitTest(_root._xmouse, _root._ymouse, false)) {
                    owner.__closedSelf = true;
                    owner.hide();
                }
            };
        }
        function onKillFocus() {
            this.hide();
        }
        function onKeyDown() {
            if (Key.isDown(38)) {
                navigate(-1);
            } else if (Key.isDown(40)) {
                navigate(1);
            }
        }
        function set dataProvider(data) {
            __data = data;
            draw();
            //return (dataProvider);
        }
        function get dataProvider() {
            return (__data);
        }
        function get open() {
            return (__open);
        }
        function get closedSelf() {
            return (__closedSelf);
        }
        function get width() {
            return (__width);
        }
        function get height() {
            return (__height);
        }
        function get headerLabel() {
            return (__headerText);
        }
        function set headerLabel(header) {
            __headerText = header;
            //return (headerLabel);
        }
        function draw() {
            var _local4 = 0;
            while (_local4 < children.length) {
                children[_local4].removeMovieClip();
                _local4++;
            }
            children = new Array ();
            var _local5 = __headerText.length;
            var _local2 = 0;
            while (_local2 < __data.length) {
                _local5 = ((_local5 < __data[_local2].label.length) ? (__data[_local2].label.length) : (_local5));
                _local2++;
            }
            __width = (_local5 * 6) + 20;
            __height = (__data.length * 16) + 5;// + 32;
			
            /*var _local8 = rowSpace.attachMovie("Label", "headerlabel", 10);
            _local8.setSize(__width - 5, 24);
            _local8.text = __headerText;
            _local8.setFormat("bold", true);
            _local8.setFormat("color", 3965372);
            _local8._y = 5;
            _local8._x = 5;
			*/
			
            if (__data[0].type == "check") {
                __width = __width + 10;
            }
            _local2 = 0;
            while (_local2 < __data.length) {
                if (__data[_local2].label != "spacer") {
                    if (__data[_local2].type != "check") {
                        var _local3 = rowSpace.attachMovie("Label", "label" + _local2, _local2 + 11);
                    } else {
                        var _local3 = rowSpace.attachMovie("Menu_CheckRender", "label" + _local2, _local2 + 11);
                        _local3.selected = __data[_local2].selected;
                     }
                    _local3.attachMovie("List_HighLight", "highlight", -1);
                    _local3.highlight._width = __width - 6;
                    _local3.highlight._height = 16;
                    _local3.highlight._x = -2;
                    _local3.highlight._y = 0;
                    _local3.highlight._visible = false;
                    _local3.setSize(__width - 5, 16);
                    _local3.text = __data[_local2].label;
					_local3.setFormat("color", __data[_local2].enabled == false ? 0x666666 : 0x000000);
                    _local3._y = (16 * _local2);// + 29;
                    _local3._x = 5;
                    _local3.owner = this;
                    children.push(_local3);
					_local3.enabled = __data[_local2].enabled == false ? false : true;
                    _local3.data = __data[_local2].data;
                    _local3.onPress = function () {
                        this.selected = !this.selected;
                        this.owner.dispatchEvent("click", {target:this, data:this.data});
                        this.owner.hide();
                    };
                    _local3.onRollOver = function () {
                        this.highlight._visible = true;
                    };
                    _local3.onRollOut = function () {
                        this.highlight._visible = false;
                    };
                } else {
                    rowSpace.createEmptyMovieClip("spacer" + _local2, _local2 + 11);
                    rowSpace["spacer" + _local2].lineStyle(1, 13421772, 100);
                    rowSpace["spacer" + _local2].moveTo(10, 0);
                    rowSpace["spacer" + _local2].lineTo(__width - 20, 0);
                    rowSpace["spacer" + _local2]._y = (16 * _local2) + 9;// + 38;
                    rowSpace["spacer" + _local2]._x = 5;
                 }
                _local2++;
            }
            UISpace.attachMovie("ShadowBox", "shadow", 0);
            UISpace.shadow.setSize(__width + 6, __height + 4);
            UISpace.shadow._x = -3;
            UISpace.shadow._y = 0;
            rowSpace.clear();
            rowMask.clear();
            drawRect(rowSpace, 0, 0, __width, __height, __border, 100);
            drawRect(rowSpace, 1, 1, __width - 2, __height - 2, 16777215, 100);
            //drawRect(rowSpace, 0, 0, __width, 27, __border, 100);
            //drawRect(rowSpace, 1, 1, __width - 2, 25, 13560318, 100);
            drawRect(rowMask, -5, (-__height) - 30, __width + 10, __height + 20, 16711680, 100);
            UISpace.setMask(rowMask);
        }
        function show(x, y) {
            _x = x;
            _y = y;
            Key.addListener(this);
            reveal();
            Mouse.addListener(mListner);
        }
        function reveal() {
            if (!__open) {
                var _local2 = new mx.transitions.Tween(rowMask, "_y", mx.transitions.easing.Strong.easeOut, 0, __height + 15, __transitionTime, true);
                __open = true;
                __closedSelf = false;
            }
        }
        function hide() {
            if (__open) {
                Mouse.removeListener(mListner);
                Key.removeListener(this);
                var _local2 = new mx.transitions.Tween(rowMask, "_y", mx.transitions.easing.Strong.easeOut, __height + 15, 0, __transitionTime, true);
                __open = false;
            }
        }
        function navigate(delta) {
            __selectedIndex = __selectedIndex + delta;
            __selectedIndex = ((__selectedIndex < 0) ? (__data.length - 1) : (__selectedIndex));
            __selectedIndex = ((__selectedIndex >= __data.length) ? 0 : (__selectedIndex));
            var _local2 = 0;
            while (_local2 < __data.length) {
                rowSpace["label" + _local2].highlight._visible = _local2 == __selectedIndex;
                _local2++;
            }
        }
        var __border = 8891341;
        var __backgroundAlpha = 100;
        var __headerText = "Header";
        var __transitionTime = 0.5;
        var __closedSelf = false;
        var __selectedIndex = 0;
    }
