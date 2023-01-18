    class UI.general.ShadowBox extends UI.core.movieclip
    {
        var createEmptyMovieClip, space1, space4, space5, __width, __get__height, __height, __get__width, space2, drawRect;
        function ShadowBox () {
            super();
            this.createEmptyMovieClip("space1", 0);
            this.createEmptyMovieClip("space2", 1);
            this.createEmptyMovieClip("space3", 2);
            this.createEmptyMovieClip("space4", 3);
            this.createEmptyMovieClip("space5", 4);
            space1.attachMovie("SB_1", "p1", 0);
            space1.attachMovie("SB_2", "p2", 1);
            space1.attachMovie("SB_3", "p3", 2);
            space1.attachMovie("SB_4", "p4", 3);
            space1.attachMovie("SB_5", "p5", 4);
            space1.attachMovie("SB_6", "p6", 5);
            space1.attachMovie("SB_7", "p7", 6);
            space1.p3._y = space1.p1._height;
            space1.p4._y = space1.p2._height;
            space1.p6._x = space1.p5._width;
            space1._alpha = 20;
            space4.attachMovie("SB_S1", "p1", 0);
            space4.attachMovie("SB_S2", "p2", 1);
            space4.attachMovie("SB_S3", "p3", 2);
            space4.p1._y = (space4.p2._y = (space4.p3._y = 2));
            space4.p1._x = 5;
            space4.p2._x = 5 + space4.p1._width;
            space5.attachMovie("SB_O1", "p1", 0);
            space5.attachMovie("SB_O2", "p2", 1);
            space5.attachMovie("SB_O3", "p3", 2);
            space5.attachMovie("SB_O4", "p4", 3);
            space5.attachMovie("SB_O4", "p5", 4);
            space5.attachMovie("SB_O5", "p6", 5);
            space5.attachMovie("SB_O6", "p7", 6);
            space5.attachMovie("SB_O7", "p8", 7);
            space5.p1._y = (space5.p2._y = (space5.p3._y = 2));
            space5.p1._x = 4;
            space5.p2._x = 4 + space5.p1._width;
            space5.p4._y = (space5.p5._y = space5.p1._y + space5.p1._height);
            space5.p4._x = 4;
            space5.p6._x = 4;
            space5.p7._x = space5.p6._x + space5.p6._width;
            space4._alpha = 70;
        }
        function set height(h) {
            setSize(__width, h);
            //return (__get__height());
        }
        function set width(w) {
            setSize(w, __height);
            //return (__get__width());
        }
        function setSize(width, height) {
            __width = width;
            __height = height;
            space1.p2._x = width - space1.p2._width;
            space1.p3._height = height - (space1.p1._height + space1.p5._height);
            space1.p4._x = width - space1.p4._width;
            space1.p4._height = height - (space1.p2._height + space1.p7._height);
            space1.p5._y = height - space1.p5._height;
            space1.p6._width = width - (space1.p5._width + space1.p7._width);
            space1.p6._y = height - space1.p6._height;
            space1.p7._x = width - space1.p7._width;
            space1.p7._y = height - space1.p7._height;
            space2.clear();
            drawRect(space2, 3.5, 1, width - 7.3, height - 5, __fill, __alpha, 6);
            space4.p2._width = width - ((10 + space4.p1._width) + space4.p3._width);
            space4.p3._x = width - (space4.p3._width + 5);
            space5.p2._width = width - ((space5.p1._width + space5.p3._width) + 8);
            space5.p3._x = width - (4 + space5.p3._width);
            space5.p4._height = (space5.p5._height = height - ((space5.p1._height + space5.p6._height) + 6));
            space5.p5._x = width - (4 + space5.p4._width);
            space5.p6._y = (space5.p8._y = (height - space5.p6._height) - 4);
            space5.p7._y = (height - space5.p7._height) - 4;
            space5.p7._width = width - ((8 + space5.p6._width) + space5.p8._width);
            space5.p8._x = width - (4 + space5.p8._width);
        }
        var __fill = 16777215;
        var __alpha = 20;
    }
