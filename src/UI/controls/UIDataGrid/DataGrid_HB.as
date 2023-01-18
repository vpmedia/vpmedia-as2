    class UI.controls.UIDataGrid.DataGrid_HB extends UI.core.events
    {
        var createEmptyMovieClip, attachMovie, createTextField, label_txt, over, sortMode, hitSpace, dragPart, setMask, mask, _parent, id, drawRect;
        function DataGrid_HB () {
            super();
            this.createEmptyMovieClip("UIBase", 0);
            this.attachMovie("DataGrid_Over", "over", 1);
            this.createTextField("label_txt", 2, 0, 0, 50, 16);
            this.createEmptyMovieClip("mask", 3);
            this.createEmptyMovieClip("hitSpace", 4);
            this.createEmptyMovieClip("dragPart", 5);
            label_txt.autoSize = true;
            label_txt.selectable = false;
            label_txt.owner = this;
            var _local3 = new TextFormat ();
            _local3.font = "arial";
            _local3.size = 10;
            label_txt.setNewTextFormat(_local3);
            over._y = 2;
            over._x = -10;
            sortMode = 0;
            var owner = this;
            hitSpace.onRollOver = function () {
                owner.dispatchEvent("onRollOver", {target:owner});
                if (owner.over._currentframe != 3) {
                    owner.over.gotoAndStop(2);
                }
            };
            hitSpace.onPress = function () {
                owner.over.gotoAndStop(3);
            };
            hitSpace.onRelease = function () {
                owner.doSort();
                owner.over.gotoAndStop(3);
            };
            hitSpace.onRollOut = function () {
                owner.dispatchEvent("onRollOut", {target:owner});
                if (owner.over._currentframe != 3) {
                    owner.over.gotoAndStop(1);
                }
            };
            hitSpace.onDragOut = function () {
                owner.dispatchEvent("onRollOut", {target:owner});
                owner._parent._parent.lastSort.over.gotoAndStop(0);
                owner._parent._parent.sArrow._visible = false;
                owner._parent._parent.lastSort = owner;
                owner._parent._parent.doDrag(owner);
            };
            hitSpace._focusrect = false;
            hitSpace.tabEnabled = false;
            dragPart.onRollOver = function () {
                if (owner.over._currentframe != 3) {
                    owner.over.gotoAndStop(2);
                }
                owner._parent._parent.showDrag(owner);
            };
            dragPart.onRollOut = function () {
                if (owner.over._currentframe != 3) {
                    owner.over.gotoAndStop(1);
                }
                owner._parent._parent.hideDrag();
            };
            dragPart.onReleaseOutside = function () {
                if (owner.over._currentframe != 3) {
                    owner.over.gotoAndStop(1);
                }
                owner._parent._parent.hideDrag();
            };
            dragPart.onRelease = function () {
                owner._parent._parent.hideDrag();
            };
            dragPart.onPress = function () {
                owner._parent._parent.beginDrag(owner);
            };
            dragPart._focusrect = false;
            dragPart.tabEnabled = false;
            hitSpace.useHandCursor = (dragPart.useHandCursor = false);
            this.setMask(mask);
        }
        function doSort() {
            if (sortMode == 0) {
                sortMode = 1;
            } else {
                sortMode = 0;
             }
            over.gotoAndStop(sortMode + 1);
            _parent._parent.doSort(id, sortMode, this);
        }
        function set label(l) {
            label_txt.text = l;
            //return (label);
        }
        function get label() {
            return (label_txt.text);
        }
        function get bestWidth() {
            return (label_txt.textWidth);
        }
        function setWidth(w) {
            label_txt._width = w;
            mask.clear();
            drawRect(mask, -11, 0, w + 11, 16, 0, 100);
            hitSpace.clear();
            drawRect(hitSpace, 0, 0, w + 4, 16, 0, 0);
            drawRect(hitSpace, w - 1, 1, 1, 14, 10066327, 100);
            dragPart.clear();
            drawRect(dragPart, w - 6, 0, 12, 16, 0, 0);
            over._width = w + 10;
        }
    }
