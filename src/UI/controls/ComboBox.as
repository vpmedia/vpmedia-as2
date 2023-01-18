    class UI.controls.ComboBox extends UI.core.events
    {
        var isOpen, hasChanged, __listHeight, __listWidth, createEmptyMovieClip, createTextField, attachMovie, lb, label_txt, ComboArrow, UISpace, space4, HitArea, notab, outSideML, dispatchEvent, textDown, drawRect, __width, __get__input, __get__listHeight, __get__listWidth, dropMask, __down, __over, __staticLabel, __get__staticLabel, lastSelected, localToGlobal, __get__StageHeight, direction, returnTo;
        function ComboBox () {
            super();
            isOpen = false;
            hasChanged = false;
            __listHeight = 80;
            __listWidth = 80;
            this.createEmptyMovieClip("UISpace", 0);
            this.createTextField("label_txt", 1, 0, 0, 50, 50);
            this.attachMovie("ComboBox_Arrow", "ComboArrow", 2);
            this.createEmptyMovieClip("HitArea", 3);
            this.createEmptyMovieClip("dropMask", 4);
            this.attachMovie("List", "lb", -1);
            lb._visible = false;
            lb.focusRect = false;
            lb.blockFocus();
            lb.addListener("change", onChange, this);
            label_txt.selectable = false;
            label_txt.owner = this;
            var _local4 = new TextFormat ();
            _local4.font = "Verdana";
            _local4.size = 10;
            label_txt.setNewTextFormat(_local4);
            label_txt._x = (label_txt._y = 4);
            label_txt.text = "";
            ComboArrow._y = 7;
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
            space4 = UISpace;
            space4.attachMovie("SB_S1", "p1", 9);
            space4.attachMovie("SB_S2", "p2", 10);
            space4.attachMovie("SB_S3", "p3", 11);
            space4.p1._x = (space4.p2._x = (space4.p3._x = 2));
            space4.p1._y = (space4.p2._y = (space4.p3._y = 2));
            space4.p2._x = 2 + space4.p1._width;
            space4.p1._yscale = 50;
            space4.p2._yscale = 50;
            space4.p3._yscale = 50;
            HitArea.owner = this;
            HitArea.onPress = function () {
                owner.doPress();
            };
            HitArea.onRollOver = function () {
                owner.__over = true;
                owner.doRollOver();
            };
            HitArea.onRollOut = function () {
                owner.__over = false;
                owner.doRollOut();
            };
            HitArea.onRelease = (HitArea.onReleaseOutside = function () {
                owner.setSurface(1);
            });
            notab(HitArea);
            HitArea.useHandCursor = false;
            outSideML = new Object ();
            var owner = this;
            outSideML.onMouseDown = function () {
                var _local3 = owner.lb.listBase.hitTest(_root._xmouse, _root._ymouse, false);
                var _local2 = owner.HitArea.hitTest(_root._xmouse, _root._ymouse, false);
                if ((!_local3) && (!_local2)) {
                    owner.showList(false, false);
                }
            };
            setSurface(1);
        }
        function onTChange() {
            dispatchEvent("textChange", {target:this});
        }
        function onFocusIn() {
            dispatchEvent("setFocus", {target:this});
        }
        function onFocusOut() {
            dispatchEvent("killFocus", {target:this});
        }
        function set input(b) {
            if (b == true) {
                UISpace._visible = false;
                this.attachMovie("TextInput", "label_txt", 1);
                label_txt.addListener("change", onTChange, this);
                label_txt.setSize(100, 20);
                label_txt.addListener("focusIn", onFocusIn, this);
                label_txt.addListener("focusOut", onFocusOut, this);
                if (!textDown) {
                    this.createEmptyMovieClip("textDown", 5);
                    drawRect(textDown, 0, -1, 17, 20, 8625087, 100);
                    textDown._y = 1;
                    textDown.attachMovie("Button_body", "body", 0);
                    textDown.body.gotoAndStop(2);
                    textDown.body._width = 15;
                    textDown.body._x = 1;
                    textDown.body._height = 18;
                    drawRect(textDown, 0, 0, 1, 18, 7308196, 100);
                    textDown.createEmptyMovieClip("l2", 1);
                    drawRect(textDown.l2, 1, 0, 1, 18, 16777215, 20);
                    textDown.attachMovie("SB_S2", "hl", 2);
                    textDown.hl._x = 1;
                    textDown.hl._y = 0;
                    textDown.hl._width = 15;
                    textDown.hl._height = 8;
                    textDown.attachMovie("ComboBox_Arrow_p2", "a", 3);
                    textDown.a._x = 5;
                    textDown.a._y = 7;
                    ComboArrow._visible = false;
                }
            }
            __input = b;
            setSize(__width);
            //return (__get__input());
        }
        function get hitClip() {
            if (lb._visible == true) {
                return (lb);
            } else {
                return (HitArea);
             }
        }
        function set listHeight(nh) {
            __listHeight = nh;
            redraw();
            //return (__get__listHeight());
        }
        function set listWidth(nw) {
            __listWidth = nw;
            redraw();
            //return (__get__listWidth());
        }
        function setText(t) {
            label_txt.text = t;
        }
        function get text() {
            return (label_txt.text);
        }
        function redraw() {
            var _local4 = __listHeight;
            var _local3 = 0;
            var _local2 = 0;
            while (_local2 < lb.length) {
                if (lb.getItemAt(_local2).type == "spacer") {
                    _local3 = _local3 + 3;
                } else {
                    _local3 = _local3 + 20;
                 }
                _local2++;
            }
            _local3 = _local3 + 4;
            if (_local3 < _local4) {
                _local4 = _local3;
            }
            var _local5 = __listWidth;
            if (__width > _local5) {
                _local5 = __width;
            }
            lb.setSize(_local5, _local4);
            dropMask.clear();
            drawRect(dropMask, 0, 0, _local5, _local4, 16777215, 100);
        }
        function doPress() {
            __down = true;
            setSurface(3);
            showList(!isOpen, false);
            isOpen = isOpen;
            dispatchEvent("onRollOut", {target:this});
        }
        function doRollOver() {
            dispatchEvent("onRollOver", {target:this});
            if (UISpace.bll._currentframe != 4) {
                setSurface(2);
            }
        }
        function doRollOut() {
            dispatchEvent("onRollOut", {target:this});
            if (__over != true) {
                setSurface(1);
            }
        }
        function onSetFocus() {
            if (Key.isDown(9)) {
                doRollOver();
            }
            lb.onSetFocus();
        }
        function onKillFocus() {
            doRollOut();
            lb.onKillFocus();
            dispatchEvent("onRollOut", {target:this});
        }
        function onKeyDown() {
            if (isOpen == false) {
                if (Key.isDown(13) || (Key.isDown(32))) {
                    showList(true);
                }
            } else {
                lb.onKeyDown();
                if (Key.isDown(13) || (Key.isDown(32))) {
                    onChange();
                }
                if (Key.isDown(27)) {
                    onChange();
                }
             }
        }
        function onChange(data) {
            if (data["key"] != true) {
                showList(false);
                isOpen = false;
                if (!__staticLabel) {
                    if (__input == true) {
                        label_txt.setText(lb.selectedItem.label);
                    } else {
                        label_txt.text = lb.selectedItem.label;
                     }
                }
            }
        }
        function set staticLabel(s) {
            __staticLabel = s;
            label_txt.text = s;
            //return (__get__staticLabel());
        }
        function addItem(data, rd) {
            lb.addItem(data, rd);
        }
        function addItemAt(i, data, rd) {
            lb.addItemAt(i, data, rd);
        }
        function removeItemAt(i) {
            lb.removeItemAt(i);
        }
        function removeAll() {
            lb.removeAll();
        }
        function get selectedItem() {
            return (lb.selectedItem);
        }
        function set selectedIndex(i) {
            lb.selectedIndex = i;
            lastSelected = lb.selectedItem;
            if (!__staticLabel) {
                if (__input == true) {
                    label_txt.setText(lb.selectedItem.label);
                } else {
                    label_txt.text = lb.selectedItem.label;
                 }
            }
            //return (selectedIndex);
        }
        function get selectedIndex() {
            return (lb.selectedIndex);
        }
        function getItemAt(i) {
            return (lb.getItemAt(i));
        }
        function get length() {
            return (lb.length);
        }
        function getListPos() {
            var _local4 = {x:0, y:0};
            this.localToGlobal(_local4);
            var _local2 = false;
            var _local6 = false;
            if (((_local4.y + 24) + lb.height) <= Stage.height) {
                _local2 = true;
            }
            if ((_local4.y - lb.height) >= 0) {
                _local6 = true;
            }
            var _local3;
            if (direction == 0) {
                _local2 = false;
            } else if (direction == 1) {
                _local2 = true;
            }
            if (_local2 == true) {
                var _local5 = -lb.height;
                if (__input != true) {
                    var _local7 = 23;
                    _local3 = (-lb.height) + 23;
                } else {
                    var _local7 = 19;
                    _local3 = (-lb.height) + 19;
                 }
            } else {
                var _local5 = 0;
                var _local7 = -lb.height;
                _local3 = 0;
             }
            return ({start:_local5, end:_local7, returnPos:_local3});
        }
        function showList(s, inform) {
            isOpen = s;
            if (s == true) {
                firstOpen = true;
                redraw();
                Mouse.addListener(outSideML);
                hasChanged = false;
                motion = 1;
                if (lb.length != 0) {
                    lb._visible = true;
                }
                lb.onSetFocus();
                var _local2 = getListPos();
                returnTo = _local2.returnPos;
                var _local4 = _local2.start;
                var _local3 = _local2.end;
                dropMask._y = _local3;
                var _local5 = new mx.transitions.Tween(lb, "_y", mx.transitions.easing.Strong.easeOut, _local4, _local3, __speed, false);
                dispatchEvent("open", {target:this});
            } else {
                Mouse.removeListener(outSideML);
                motion = 0;
                var _local5 = new mx.transitions.Tween(lb, "_y", mx.transitions.easing.Strong.easeOut, lb._y, returnTo, __speed, false);
                lb.onKillFocus();
                var owner = this;
                _local5.onMotionFinished = function () {
                    if (owner.motion == 0) {
                        owner.lb._visible = false;
                    }
                };
                if (inform != false) {
                    dispatchEvent("close", {target:this});
                    if (lb.selectedItem != undefined) {
                        if (lastSelected != lb.selectedIndex) {
                            dispatchEvent("change", {target:this});
                        }
                    }
                    lastSelected = lb.selectedIndex;
                }
             }
        }
        function setSize(width) {
            if (__listWidth == __width) {
                __listWidth = __width;
            }
            __width = width;
            var _local3 = 24;
            if (__input == true) {
                textDown._x = width - 17;
                label_txt.setSize(width - 15, 20);
                HitArea.clear();
                drawRect(HitArea, width - 16, 0, 16, _local3, 16777215, 0);
            } else {
                label_txt._width = width - 15;
                UISpace.bll._y = (UISpace.blr._y = (UISpace.blbb._y = _local3 - 5));
                UISpace.blr._x = (UISpace.btr._x = (UISpace.brb._x = width - 5));
                UISpace.btb._width = width - 10;
                UISpace.body._width = (UISpace.blbb._width = width - 10);
                UISpace.body._height = (UISpace.blb._height = (UISpace.brb._height = _local3 - 10));
                var _local4 = width - 4;
                space4.p2._width = _local4 - (space4.p1._width + space4.p3._width);
                space4.p3._x = (_local4 - space4.p3._width) + 2;
                HitArea.clear();
                drawRect(HitArea, 0, 0, width, _local3, 16777215, 0);
                lb.setMask(dropMask);
             }
            ComboArrow._x = width - 18;
            redraw();
        }
        function clearSelection() {
            lb.clearSelection();
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
            if (__input != true) {
                UISpace.bll.gotoAndStop(_local2);
                UISpace.blr.gotoAndStop(_local2);
                UISpace.btl.gotoAndStop(_local2);
                UISpace.btr.gotoAndStop(_local2);
                UISpace.btb.gotoAndStop(_local2);
                UISpace.body.gotoAndStop(_local2);
                UISpace.blb.gotoAndStop(_local2);
                UISpace.brb.gotoAndStop(_local2);
                UISpace.blbb.gotoAndStop(_local2);
            } else {
                textDown.body.gotoAndStop(_local2);
             }
        }
        function activateButton() {
            HitArea.owner = this;
            HitArea.onPress = function () {
                this.owner.doPress();
            };
            HitArea.onRollOver = function () {
                this.owner.__over = true;
                this.owner.doRollOver();
            };
            HitArea.onRollOut = function () {
                this.owner.__over = false;
                this.owner.doRollOut();
            };
            HitArea.onRelease = (HitArea.onReleaseOutside = function () {
                this.owner.setSurface(1);
            });
            Selection.setFocus(null);
            __active = true;
        }
        function deactivateButton() {
            HitArea.onPress = (HitArea.onRollOver = (HitArea.onRollOut = (HitArea.onRelease = null)));
            __active = false;
        }
        function isActive() {
            return (__active);
        }
        var __speed = 12;
        var motion = 1;
        var __input = false;
        var firstOpen = false;
        var __active = true;
    }
