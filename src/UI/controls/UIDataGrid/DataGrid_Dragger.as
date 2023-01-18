    class UI.controls.UIDataGrid.DataGrid_Dragger extends UI.core.movieclip
    {
        var attachMovie, bgGrad, _label, __get__label, clear, drawRect;
        function DataGrid_Dragger () {
            super();
            this.attachMovie("DataGrid_Over", "bgGrad", 0);
            this.attachMovie("Label", "_label", 1);
            bgGrad._x = (bgGrad._y = 2);
            bgGrad._height = 12;
            bgGrad.gotoAndStop(3);
            _label._x = 3;
            _label.setFormat("align", "center");
        }
        function set label(s) {
            _label.text = s;
            //return (__get__label());
        }
        function setSize(w) {
            this.clear();
            drawRect(this, 0, 0, w, 16, 7372692, 100);
            drawRect(this, 1, 1, w - 2, 14, 13952493, 100);
            _label.setSize(w - 6, 17);
            bgGrad._width = w - 4;
        }
    }
