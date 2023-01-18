    class UI.controls.UIScrollBar.ScrollBarThumb extends MovieClip
    {
        var attachMovie, peice1, peice2, peice4, peice3;
        function ScrollBarThumb () {
            super();
            this.attachMovie("ScrollBar_Thumb_Head", "peice1", 0);
            this.attachMovie("ScrollBar_Thumb_Body", "peice2", 2);
            this.attachMovie("ScrollBar_Thumb_Base", "peice3", 3);
            this.attachMovie("ScrollBar_Thumb_Bars", "peice4", 4);
            peice2._y = peice1._height;
            peice4._x = 3;
        }
        function setState(i) {
            peice1.gotoAndStop(i);
            peice2.gotoAndStop(i);
            peice3.gotoAndStop(i);
            peice4.gotoAndStop(i);
        }
        function setSize(size) {
            peice2._height = size - (peice1._height + peice3._height);
            peice3._y = peice2._y + peice2._height;
            peice4._y = (size / 2) - 3;
        }
    }
