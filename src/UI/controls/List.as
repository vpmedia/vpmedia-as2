    class UI.controls.List extends UI.core.events
    {
        var ignoreRedraw, focusRect, setterEvent, multipleSelection, pRender, selItems, __scrollSelection, __width, __maxWidth, createEmptyMovieClip, attachMovie, rowColHold, rowColMask, rowHolder, rowMask, vScroll, hScroll, __render, __data, __idInc, __rowCols, __selectedIndex, mWheelListner, listBase, notab, __mDown, _xmouse, dispatchEvent, __height, __get__rowColors, __get__background, __get__border, __get__backgroundAlpha, __get__borderAlpha, __get__render, __lastselectedIndex, sInt, fromWidth, drawRect;
        function List () {
            super();
            ignoreRedraw = false;
            focusRect = true;
            setterEvent = false;
            multipleSelection = false;
            pRender = new Object ();
            selItems = new Array ();
            __scrollSelection = false;
            __width = 0;
            __maxWidth = 0;
            pRender["0"] = 2;
            this.createEmptyMovieClip("listBase", 0);
            this.createEmptyMovieClip("rowColHold", 1);
            this.createEmptyMovieClip("rowHolder", 2);
            this.createEmptyMovieClip("rowMask", 3);
            this.createEmptyMovieClip("lineSpace", 4);
            this.attachMovie("ScrollBar", "vScroll", 5);
            this.attachMovie("ScrollBar", "hScroll", 6);
            this.createEmptyMovieClip("hitSpace", 7);
            this.createEmptyMovieClip("rowColMask", 8);
            rowColHold.setMask(rowColMask);
            rowHolder.setMask(rowMask);
            vScroll.addListener("scroll", doVScroll, this);
            hScroll.addListener("scroll", doHScroll, this);
            vScroll._visible = (hScroll._visible = false);
            vScroll._y = 2;
            hScroll.direction = "Horizontal";
            hScroll._x = 2;
            rowColHold._x = 1;
            vScroll.blockFocus();
            hScroll.blockFocus();
            __render = "defaultListRender";
			//__render = "iconListRender";
            __data = new Array ();
            __idInc = 0;
            rowMask._x = (rowMask._y = 1);
            __rowCols = [16777215];
            __selectedIndex = -1;
            var owner = this;
            mWheelListner = new Object ();
            mWheelListner.onMouseWheel = function (delta) {
                owner.vPosition = owner.vPosition - (delta * 2);
            };
            mWheelListner.onMouseMove = function () {
                owner.mouseNav();
            };
            Mouse.addListener(this);
            listBase.onPress = function () {
            };
            listBase.useHandCursor = false;
            notab(listBase);
            removeAll();
        }
        function mouseNav() {
            if ((((((__scrollSelection && (__mDown == true)) && (_xmouse <= (__width - offset))) && (focusRect == true)) && (vScroll.isScrolling != true)) && (hScroll.isScrolling != true)) && (!Key.isDown(17))) {
                if (rowHolder._ymouse < getY(selectedIndex)) {
                    selectedIndex = ((selectedIndex-1));
                    dispatchEvent("change", {target:this});
                } else if (rowHolder._ymouse > (getY(selectedIndex) + getHeight(selectedIndex))) {
                    selectedIndex = ((selectedIndex+1));
                    dispatchEvent("change", {target:this});
                }
            }
        }
        function onMouseDown() {
            __mDown = true;
        }
        function onMouseUp() {
            __mDown = false;
        }
        function onKeyDown() {
            if (Key.isDown(38)) {
                var _local2 = -1;
                if (getItemAt(selectedIndex - 1).type == "spacer") {
                    _local2 = -2;
                }
                selectedIndex = (selectedIndex + _local2);
                dispatchEvent("change", {target:this, key:true});
            } else if (Key.isDown(40)) {
                var _local2 = 1;
                if (getItemAt(selectedIndex + 1).type == "spacer") {
                    _local2 = 2;
                }
                selectedIndex = (selectedIndex + _local2);
                dispatchEvent("change", {target:this, key:true});
            }
            if (Key.isDown(39)) {
                hPosition = ((hPosition+1));
            }
            if (Key.isDown(37)) {
                hPosition = ((hPosition-1));
            }
            if (Key.isDown(33)) {
                vPosition = ((vPosition-1));
            }
            if (Key.isDown(34)) {
                vPosition = ((vPosition+1));
            }
            if (Key.isDown(13)) {
                dispatchEvent("enter", {target:this});
            }
            if (Key.isDown(46)) {
                dispatchEvent("delete", {target:this});
            }
            selectedItem.onKeyDown();
        }
        function doVScroll() {
            rowHolder._y = -vScroll.scrollPosition;
            rowColHold._y = -vScroll.scrollPosition;
        }
        function doHScroll() {
            rowHolder._x = -hScroll.scrollPosition;
        }
        function setScrollSelection(state) {
            __scrollSelection = state;
        }
        function get width() {
            return (__width);
        }
        function get height() {
            return (__height);
        }
        function get vPosition() {
            return (vScroll.scrollPosition);
        }
        function get hPosition() {
            return (hScroll.scrollPosition);
        }
        function set vPosition(s) {
            if (vScroll._visible != false) {
                vScroll.scrollPosition = s;
                doVScroll();
            }
            //return (vPosition);
        }
        function set hPosition(s) {
            if (hScroll._visible != false) {
                hScroll.scrollPosition = s;
                doHScroll();
            }
            //return (hPosition);
        }
        function get maxVPosition() {
            if (vScroll._visible == false) {
                return (0);
            } else {
                return (vScroll.max);
             }
        }
        function get maxHPosition() {
            if (hScroll._visible == false) {
                return (0);
            } else {
                return (hScroll.max);
             }
        }
        function set rowColors(c) {
            __rowCols = c;
            redraw(0);
            //return (__get__rowColors());
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
        function set backgroundAlpha(a) {
            __backgroundAlpha = a;
            setSize(__width, __height);
            //return (__get__backgroundAlpha());
        }
        function set borderAlpha(a) {
            __borderAlpha = a;
            setSize(__width, __height);
            //return (__get__borderAlpha());
        }
        function set render(r) {
            __render = r;
            var _local3 = new Array ();
            var _local2 = 0;
            while (_local2 < __data.length) {
                _local3.push(__data[_local2]);
                _local2++;
            }
            removeAll();
            _local2 = 0;
            while (_local2 < _local3.length) {
                addItem(_local3[_local2].data);
                _local2++;
            }
            //return (__get__render());
        }
        function get length() {
            return (__data.length);
        }
        function set selectedIndex(i) {
            if (i == undefined) {
                return;
            }
            if (i > (__data.length - 1)) {
                i = __data.length - 1;
            }
            if (i < 0) {
                i = 0;
            }
            __data[__selectedIndex].mc.onDeselect();
            var _local3 = __data[i].mc;
            __lastselectedIndex = __selectedIndex;
            __selectedIndex = i;
            var _local4 = pRender[i] - 2;
            var _local6 = Math.abs(rowHolder._y);
            if (_local4 < _local6) {
                vPosition = (_local4);
            }
            var _local5 = _local3.getBestHeight();
            var _local7 = (pRender[i] + _local5) + yofs;
            if (_local7 > (_local6 + __height)) {
                vPosition = (((_local4 - (__height - _local5)) + 4) + yofs);
            }
            if ((!Key.isDown(17)) || (multipleSelection == false)) {
                deselectAll();
            }
            selItems.push(_local3);
            highlightMC(_local3, 2);
            if (setterEvent == true) {
                dispatchEvent("change", {target:this, row:_local3});
            }
            //return (selectedIndex);
        }
        function get selectedIndex() {
            return (selItems[0].id);
        }
        function get selectedItems() {
            return (selItems);
        }
        function get lastSelectedIndex() {
            return (__lastselectedIndex);
        }
        function get selectedItem() {
            if (__selectedIndex == -1) {
                return (null);
            }
            return (__data[__selectedIndex].mc);
        }
        function getItemAt(index) {
            return (__data[index].mc);
        }
        function removeItemAt(index) {
            var _local3 = __data[index];
            _local3.mc.removeMovieClip();
            __data.splice(index, 1);
            redraw(index);
            if (__selectedIndex == index) {
                selectedIndex = (-1);
            }
            if (__selectedIndex > index) {
                selectedIndex = (__selectedIndex - 1);
            }
            onChangeWidth(this, __width);
        }
        function clearSelection() {
            __selectedIndex = -1;
            deselectAll();
        }
        function removeAll() {
            var _local2 = 0;
            while (_local2 < __data.length) {
                __data[_local2].mc.removeMovieClip();
                _local2++;
            }
            rowHolder._y = 0;
            __data = new Array ();
            pRender = new Object ();
            __maxWidth = __width;
            pRender["0"] = 2;
            __selectedIndex = -1;
            onChangeWidth(this, __width);
        }
        function addItemAt(index, data, rd) {
            var _local3;
            if (rd == false) {
                ignoreRedraw = true;
            }
            if (data.type == "spacer") {
                _local3 = rowHolder.attachMovie("List_spacer", "row" + __idInc, __idInc);
            } else {
                _local3 = rowHolder.attachMovie(__render, "row" + __idInc, __idInc);
             }
            __idInc++;
            _local3.id = index;
            _local3._x = __padding;
            for (var _local4 in data) {
                _local3[_local4] = data[_local4];
            }
            __data.splice(index, 0, {mc:_local3});
            if (data.type != "spacer") {
                setupRow(_local3, data);
                var _local6 = _local3.getBestHeight();
                insertAt(index, _local6);
                _local3.setSize(__maxWidth, _local6, __width);
            } else {
                var _local6 = 3;
                insertAt(index, 3);
                _local3.setSize(__maxWidth, _local6, __width);
             }
            if (rd != false) {
                redraw(index);
            }
            ignoreRedraw = false;
            return (_local3);
        }
        function insertAt(i, h) {
            var _local2 = __data.length;
            while (_local2 > i) {
                pRender[_local2] = pRender[_local2 - 1] + h;
                _local2--;
            }
            pRender[i + 1] = pRender[i] + h;
        }
        function addItem(data, rd) {
            var _local2;
            if (rd == false) {
                ignoreRedraw = true;
            }
            if (data.type == "spacer") {
                _local2 = rowHolder.attachMovie("List_spacer", "row" + __idInc, __idInc);
            } else {
                _local2 = rowHolder.attachMovie(__render, "row" + __idInc, __idInc);
             }
            __idInc++;
            _local2.id = __data.length;
            _local2._x = __padding;
            __data.push({mc:_local2});
            if (data.type != "spacer") {
                setupRow(_local2, data);
                var _local3 = _local2.getBestHeight();
                setHeight(__data.length - 1, _local3);
                _local2.setSize(__maxWidth, _local3, __width);
            } else {
                var _local3 = 3;
                setHeight(__data.length - 1, _local3);
                _local2.setSize(__maxWidth, _local3, __width);
             }
            if (rd != false) {
                redraw(__data.length - 1);
            }
            ignoreRedraw = false;
            return (_local2);
        }
        function setHeight(i, h) {
            if (pRender[i + 1]) {
                var _local4 = h - getHeight(i);
                var _local2 = i;
                while (_local2 < __data.length) {
                    saveHeight(_local2, getHeight(_local2) + _local4);
                    _local2++;
                }
            } else {
                saveHeight(i, h);
             }
        }
        function saveHeight(i, h) {
            pRender[i + 1] = pRender[i] + h;
        }
        function getHeight(i) {
            return (pRender[i + 1] - pRender[i]);
        }
        function getY(i) {
            return (pRender[i]);
        }
        function getColors(ind) {
            return (__rowCols[ind % __rowCols.length]);
        }
        function setupRow(mc, data) {
            mc.List = this;
            for (var _local4 in data) {
                mc[_local4] = data[_local4];
            }
            mc.onData(data);
            mc.attachMovie("List_HighLight", "hl", -1);
            mc.hl._visible = false;
            mc.hitSpace.List = this;
            notab(mc.hitSpace);
            mc.hitSpace.onPress = function () {
                this.List.onSetFocus();
            };
            mc.hitSpace.onPress = function () {
                this.List.onClick(this._parent);
            };
            mc.hitSpace.onRollOver = function () {
                this.List.RollOver(this._parent);
            };
            mc.hitSpace.onRollOut = function () {
                this.List.RollOut(this._parent);
            };
            mc.hitSpace.onReleaseOutside = function () {
                this.List.RollOut(this._parent);
            };
            mc.hitSpace.useHandCursor = false;
        }
        function doNav(o) {
            o.mouseNav();
        }
        function onSetFocus() {
            sInt = setInterval(doNav, 50, this);
            Mouse.addListener(mWheelListner);
        }
        function onKillFocus() {
            clearInterval(sInt);
            Mouse.removeListener(mWheelListner);
        }
        function deselectAll() {
            var _local2 = 0;
            while (_local2 < __data.length) {
                var _local3 = __data[_local2].mc;
                _local3.hl._visible = false;
                _local2++;
            }
            selItems.splice(0, selItems.length);
        }
        function onClick(mc) {
            selectedIndex = (mc.id);
            dispatchEvent("change", {target:this, row:mc});
        }
        function RollOver(mc) {
            if ((mc.hl._visible == true) && (mc.hl._currentframe == 2)) {
            } else {
                highlightMC(mc, 1);
                dispatchEvent("rollOver", {target:this, row:mc});
             }
        }
        function RollOut(mc) {
            if ((mc.hl._visible == true) && (mc.hl._currentframe == 2)) {
            } else {
                mc.hl._visible = false;
                dispatchEvent("rollOut", {target:this, row:mc});
             }
        }
        function highlightMC(mc, type) {
            mc.hl._visible = true;
            mc.hl.gotoAndStop(type);
            var _local3 = __maxWidth + 2;
            mc.hl._width = _local3;
            mc.hl._x = -__padding;
            mc.hl._height = getHeight(mc.id);
            if (type == 2) {
                mc.onSelect();
            }
        }
        function redraw(from) {
            _relocate(from);
        }
        function onChangeWidth(mc, w) {
            if (mc != this) {
                __data[mc.id].width = w;
            }
            if (ignoreRedraw != true) {
                var _local3 = 0;
                var _local2 = 0;
                while (_local2 < __data.length) {
                    if (__data[_local2].width > _local3) {
                        _local3 = __data[_local2].width;
                    }
                    _local2++;
                }
                if (_local3 < __width) {
                    _local3 = __width;
                    fromWidth = true;
                } else {
                    fromWidth = false;
                 }
                __maxWidth = _local3;
                _resize(0, _local3);
                _checkScroll();
            }
        }
        function onChangeHeight(mc, h) {
            sizeRow(mc, __maxWidth, h);
            if (ignoreRedraw != true) {
                setHeight(mc.id, mc.getBestHeight());
                _relocate(mc.id);
            }
        }
        function delimFrom(from, delta, delta2) {
            var _local2 = from;
            while (_local2 < __data.length) {
                pRender[_local2] = pRender[_local2] + delta;
                _local2++;
            }
        }
        function _drawBackground() {
            rowColHold.clear();
            if (__rowCols.length == 1) {
                drawRect(rowColHold, 0, 0, __width, __height, __rowCols[0], 100);
            } else {
                var _local2 = 0;
                while (_local2 < __data.length) {
                    var _local5 = getHeight(_local2);
                    drawRect(rowColHold, 0, getY(_local2), __width, _local5, getColors(_local2), 100);
                    _local2++;
                }
                var _local9 = 0;
                if (__data.length != 0) {
                    _local9 = getY(__data.length - 1) + getHeight(__data.length - 1);
                }
                if (_local9 < __height) {
                    var _local8 = Math.ceil((__height - _local9) / __rowHeight);
                    if (__data.length == 0) {
                        var _local6 = 1;
                        var _local7 = 0;
                    } else {
                        var _local6 = __data.length - 1;
                        var _local7 = getY(_local6) + getHeight(_local6);
                     }
                    var _local3 = 0;
                    while (_local3 < _local8) {
                        var _local4 = (_local6 + _local3) + 1;
                        drawRect(rowColHold, 0, _local7 + (_local3 * __rowHeight), __width, __rowHeight, getColors(_local4), 100);
                        _local3++;
                    }
                }
             }
        }
        function _resize(from, w) {
            var _local2 = from;
            while (_local2 < __data.length) {
                var _local3 = __data[_local2];
                _local3.mc.id = _local2;
                var _local4 = getHeight(_local2);
                sizeRow(_local3.mc, w, _local4);
                _local2++;
            }
        }
        function sizeRow(mc, w, h) {
            mc.setSize(w, h, __width);
            if (mc.hl._visible == true) {
                mc.hl._width = w + 1;
                mc.hl._height = h;
            }
        }
        function _relocate(from) {
            var _local2 = from;
            while (_local2 < __data.length) {
                var _local3 = __data[_local2];
                var _local4 = pRender[_local2];
                _local3.mc._y = getY(_local2);
                _local3.mc.id = _local2;
                _local2++;
            }
            _checkScroll();
            _drawBackground();
        }
        function _checkScroll() {
            var _local3 = getY(__data.length - 1) + getHeight(__data.length - 1);
            if (_local3 > __height) {
                vScroll._visible = true;
                vScroll._x = __width - (vScroll.width + 2);
                offset = 14;
            } else {
                vScroll._visible = false;
                offset = 0;
                rowHolder._y = 0;
             }
            if ((__maxWidth > (__width - offset)) && (fromWidth != true)) {
                hScroll._visible = true;
                yofs = 14;
                hScroll._y = __height - 15;
            } else {
                hScroll._visible = false;
                yofs = 0;
                rowHolder._x = 0;
             }
            if (vScroll._visible == true) {
                vScroll.setSize(__height - 4);
                var _local2 = (_local3 + yofs) + 2;
                vScroll.setScrollProperties(__height, 0, _local2 - __height);
            }
            if (hScroll._visible == true) {
                hScroll.setSize((__width - 4) - offset);
                var _local4 = offset;
                var _local2 = __maxWidth;
                hScroll.setScrollProperties(_local2, 0, _local2 - (__width - 14));
            }
            rowMask.clear();
            drawRect(rowMask, 1, 1, (__width - offset) - 4, (__height - 3) - yofs, 16777215, 100);
        }
        function setSize(w, h) {
            if (w > __width) {
                var _local4 = true;
            }
            __width = w;
            __height = h;
            onChangeWidth(this, w);
            rowMask.clear();
            drawRect(rowMask, 1, 1, (w - offset) - 4, (h - 3) - yofs, 16777215, 100);
            listBase.clear();
            drawRect(listBase, 0, 0, w, h, __border, __borderAlpha);
            drawRect(listBase, 1, 1, w - 2, h - 2, __background, __backgroundAlpha);
            if (_local4 == true) {
                _drawBackground();
            }
            rowColMask.clear();
            drawRect(rowColMask, 1, 1, w - 2, h - 2, 0, 0);
            selectedIndex = (__selectedIndex);
        }
        var __rowHeight = 20;
        var __background = 0xFFFFFF;
        var __border = 0xCCCCCC;
        var __backgroundAlpha = 100;
        var __borderAlpha = 100;
        var __padding = 3;
        var offset = 0;
        var yofs = 0;
        var hLines = false;
    }
