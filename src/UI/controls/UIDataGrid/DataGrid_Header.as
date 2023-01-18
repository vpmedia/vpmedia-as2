    class UI.controls.UIDataGrid.DataGrid_Header extends UI.core.movieclip
    {
        var children, mListner, byID, l_count, colList, inDrag, mListner2, __idStr, history, oList, createEmptyMovieClip, attachMovie, __menu, drawRect, positionator, over, dragUI, sArrow, hideDown, addToolTip, firstOrder, labelSpace, _xmouse, isDrag, __width, _parent, menuDP, byX, lastSort, isDragClip, globalToLocal, lastPos, baseSpace;
        function DataGrid_Header () {
            super();
            children = new Array ();
            mListner = new Object ();
            byID = new Object ();
            l_count = 0;
            colList = ",";
            inDrag = false;
            mListner2 = new Object ();
            var _local5 = this;
            var _local6 = "";
            while (_local5 != _root) {
                _local6 = _local6 + (_local5._name + "_");
                _local5 = _local5._parent;
            }
            __idStr = _local6;
            history = _global.l_cache.getProp(_local6, new Object ());
            if (history.orders) {
                oList = history.orders;
            } else {
                oList = "";
             }
            this.createEmptyMovieClip("baseSpace", 0);
            this.attachMovie("DataGrid_Over", "over", 1);
            this.createEmptyMovieClip("labelSpace", 2);
            this.attachMovie("DataSortArrow", "sArrow", 3);
            this.createEmptyMovieClip("positionator", 5);
            this.attachMovie("Menu", "__menu", 9);
            this.createEmptyMovieClip("hideDown", 10);
            __menu.addListener("click", onClick, this);
            drawRect(positionator, 0, 0, 1, 16, 0, 100);
            positionator._visible = false;
            over._x = (over._y = 2);
            dragUI._visible = false;
            dragUI._y = 1;
            sArrow._visible = false;
            sArrow._y = 6;
            drawRect(hideDown, 0, 0, 12, 16, 7372692, 100);
            drawRect(hideDown, 1, 1, 10, 14, 13689582, 100);
            hideDown.attachMovie("DataGrid_Over", "over", 0);
            hideDown.over._x = (hideDown.over._y = 2);
            hideDown.over._width = 8;
            hideDown.over._height = 12;
            hideDown.attachMovie("DataSortArrow", "arrow", 1);
            hideDown.arrow._x = 3;
            hideDown.arrow._y = 6;
            var owner = this;
            mListner.onMouseMove = function () {
                owner.doSizeMove();
            };
            mListner.onMouseUp = function () {
                owner.doSizeUp();
            };
            mListner2.onMouseMove = function () {
                owner.doDragMove();
            };
            mListner2.onMouseUp = function () {
                owner.doDragUp();
            };
            hideDown.onPress = function () {
                this.over.gotoAndStop(2);
                owner.onShowMenu();
            };
            hideDown.onRelease = (hideDown.onReleaseOutside = function () {
                this.over.gotoAndStop(1);
            });
            dragUI.onRelease = (dragUI.onReleaseOutside = function () {
                owner.hideDrag();
            });
            dragUI._focusrect = false;
            dragUI.tabEnabled = false;
            dragUI.useHandCursor = false;
            hideDown.useHandCursor = false;
            hideDown.tabEnabled = false;
            hideDown._focusrect = false;
        }
        function getLabelData(id) {
            var _local2 = 0;
            while (_local2 < children.length) {
                var _local3 = children[_local2];
                if (_local3.id == id) {
                    return (_local3);
                }
                _local2++;
            }
        }
        function setTooltip(id, tip) {
            addToolTip(tip, getLabelData(id).mc);
        }
        function createChild(id, label, width, overhead) {
            if (history[id]) {
                width = history[id].width;
            } else {
                history[id] = new Object ();
                history[id].width = width;
                history[id].forceNS = false;
                firstOrder = true;
             }
            colList = colList + (id + ",");
            var _local2 = labelSpace.attachMovie("DataGrid_HB", "l" + l_count, l_count);
            l_count++;
            width = width - spacer;
            _local2.label = label;
            _local2.setWidth(width);
            _local2.id = id;
            children.push({id:id, mc:_local2, width:width, label:label, forceNS:history[id].forceNS});
            fromOrders(overhead);
            redraw();
			
            return (_local2);
        }
        function fromOrders(overhead) {
            if (oList != "") {
                var _local4 = oList.split(",");
                _local4.pop();
                if (overhead) {
                    if (children.length != overhead) {
                        return (undefined);
                    }
                }
                if ((_local4.length == children.length) && (oList.indexOf("undefined") == -1)) {
                    var _local5 = new Object ();
                    var _local2 = 0;
                    while (_local2 < children.length) {
                        _local5[children[_local2].id] = _local2;
                        _local2++;
                    }
                    var _local6 = new Array ();
                    var _local3 = 0;
                    while (_local3 < _local4.length) {
                        _local6.push(children[_local5[_local4[_local3]]]);
                        _local3++;
                    }
                    if (_local6.length == children.length) {
                        children = _local6;
                    }
                }
            }
        }
        function showDrag(mc) {
        }
        function beginDrag(mc) {
            dragUI._x = _xmouse - 8;
            dragUI._visible = true;
            inDrag = true;
            isDrag = mc;
            Mouse.addListener(mListner);
        }
        function hideDrag() {
            if (inDrag != true) {
                dragUI._visible = false;
            }
        }
        function doSizeMove() {
            var _local2 = _xmouse;
            if (_local2 < isDrag._x) {
                _local2 = isDrag._x;
            }
            var _local3 = (__width - 1) - hideDown._width;
            if (_local2 > _local3) {
                _local2 = _local3;
            }
            children[isDrag.index].width = _local2 - isDrag._x;
            history[children[isDrag.index].id].width = _local2 - isDrag._x;
            _parent.drawBlackLine(_local2);
            dragUI._x = _local2 - 9;
            redraw();
        }
        function doSizeUp() {
            var _local2 = _xmouse;
            if (_local2 < isDrag._x) {
                _local2 = isDrag._x;
            }
            var _local3 = (__width - 1) - hideDown._width;
            if (_local2 > _local3) {
                _local2 = _local3;
            }
            history[children[isDrag.index].id].width = (_local2 - isDrag._x) + spacer;
            children[isDrag.index].width = _local2 - isDrag._x;
            _parent.sizeHolder.clear();
            Mouse.removeListener(mListner);
            dragUI._visible = false;
            redraw();
        }
        function redraw() {
            var _local5 = spacer;
            var _local7 = new Object ();
            menuDP = new Array ();
            byX = new Object ();
            byID = new Object ();
            history.orders = "";
            var _local4 = 0;
            while (_local4 < children.length) {
                var _local3 = children[_local4];
                if (_local3.mc.id != undefined) {
                    if (_local3.width < 14) {
                        _local3.width = 14;
                    }
                    history.orders = history.orders + (_local3.mc.id + ",");
                    _local3.mc.index = _local4;
                    _local3.mc.id = _local3.id;
                    byID[_local4] = _local3.id;
                    var _local6 = (_local5 + _local3.width) + 11;
                    if ((_local6 > __width) || (_local3.forceNS == true)) {
                        _local7[_local3.id] = {visible:false};
                        _local3.mc._visible = false;
                    } else {
                        _local7[_local3.id] = {x:_local5, width:_local3.width};
                        _local3.mc._x = _local5;
                        byX[_local5] = _local3;
                        _local3.mc._visible = true;
                        _local3.mc.setWidth(_local3.width);
                        _local3.mc._xscale = (_local3.mc._yscale = 100);
                        _local5 = _local5 + (_local3.width + spacer);
                     }
                    menuDP.push({label:_local3.mc.label, data:_local4, type:"check", selected:!_local3.forceNS});
                }
                _local4++;
            }
            sArrow._x = lastSort._x - 8;
            sArrow._visible = lastSort._visible;
            _global.l_cache.setProp(__idStr, history);
            _parent.sizeCells(_local7);
        }
        function doDrag(mc) {
            isDragClip = mc;
            _root.datagrid_dragger.label = mc.label;
            _root.datagrid_dragger.setSize(mc.bestWidth + 30);
            _root.datagrid_dragger._x = _root._xmouse;
            _root.datagrid_dragger._y = _root._ymouse - 16;
            _root.datagrid_dragger.swapDepths(_root.getNextHighestDepth());
            _root.datagrid_dragger._visible = true;
            Mouse.addListener(mListner2);
        }
        function doDragMove() {
            positionator._visible = true;
            _root.datagrid_dragger._x = _root._xmouse;
            _root.datagrid_dragger._y = _root._ymouse - 16;
            positionator._x = findSnap(_root._xmouse);
        }
        function findSnap(x) {
            var _local10 = {x:x, y:0};
            this.globalToLocal(_local10);
            x = _local10.x;
            if (x <= 0) {
                lastPos = 0;
                return (0);
            }
            var _local9 = children[children.length - 1];
            _local9 = _local9.mc._x + _local9.width;
            if (x > _local9) {
                lastPos = children.length;
                return (_local9);
            }
            var _local3 = 0;
            while (_local3 < children.length) {
                var _local5 = children[_local3];
                if (_local5.mc._visible == false) {
                } else {
                    var _local7 = _local5.mc;
                    var _local2 = _local7._x - spacer;
                    var _local4 = _local5.width + spacer;
                    if ((x > _local2) && (x < (_local2 + _local4))) {
                        var _local8 = _local2 + (_local4 / 2);
                        if (x > _local8) {
                            lastPos = _local3 + 1;
                            return (_local2 + _local4);
                        } else {
                            lastPos = _local3;
                            return (_local2);
                         }
                    }
                 }
                _local3++;
            }
            lastPos = 0;
            return (0);
        }
        function doDragUp() {
            Mouse.removeListener(mListner2);
            positionator._visible = false;
            var _local3 = isDragClip.index;
            if (_local3 < lastPos) {
                lastPos--;
            }
            var _local4 = children[_local3];
            children.splice(_local3, 1);
            var _local5;
            if (lastPos == undefined) {
                _local5 = children.length;
                children.push(_local4);
            } else {
                _local5 = lastPos;
                children.splice(lastPos, 0, _local4);
             }
            redraw();
            _root.datagrid_dragger._visible = false;
        }
        function doSort(id, mode, mc) {
            if (lastSort != mc) {
                lastSort.over.gotoAndStop(1);
                lastSort.sortMode = 0;
            }
            _parent.doSort(id, mode);
            sArrow._x = mc._x - 8;
            sArrow._visible = true;
            sArrow.gotoAndStop(mode + 1);
            lastSort = mc;
        }
        function onShowMenu() {
            __menu.headerLabel = "Columns";
            __menu.dataProvider = menuDP;
            __menu.show(__width - __menu.width, 16);
        }
        function onClick(evt) {
            var _local2 = children[evt.data];
            if (evt.target.selected == true) {
                _local2.forceNS = false;
            } else {
                _local2.forceNS = true;
             }
            history[_local2.id].forceNS = _local2.forceNS;
            redraw();
        }
        function setSize(w) {
            __width = w;
            baseSpace.clear();
            drawRect(baseSpace, 0, 0, w, 16, 7506344, 100);
            drawRect(baseSpace, 1, 1, w - 2, 14, 14477807, 100);
            over._width = w - 4;
            hideDown._x = w - 12;
            redraw();
        }
        var spacer = 11;
    }
