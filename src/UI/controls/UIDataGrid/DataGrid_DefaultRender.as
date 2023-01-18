    class UI.controls.UIDataGrid.DataGrid_DefaultRender extends MovieClip
    {
        var createTextField, label;
        function DataGrid_DefaultRender () {
            super();
            this.createTextField("label", 0, 0, 1, 100, 20);
            label.selectable = false;
            var _local3 = new TextFormat ();
            _local3.font = "Verdana";
            _local3.size = 10;
            label.setNewTextFormat(_local3);
            label._y = 2;
        }
        function setData(data) {
            if (data != undefined) {
                label.text = data;
            }
        }
        function getData() {
            return (label.text);
        }
        function getBestHeight() {
            return (20);
        }
        function setWidth(w) {
            label._width = w;
            label._height = getBestHeight();
        }
    }
