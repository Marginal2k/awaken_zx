            create $M,29
            create $J,76
            create $R,10
            include "MACRO_"
            include "EQUS_"



            org  #A300


            ent  $
            include "INIT_"

УПРАВЛЕНИЕ
            include "BODY_"

END

КЛИПИРОВАНИЕ
            include "CLIPMAT_"
ВСЕ 3Д
            include "3D-II_"
            include "3D-I_"

ТАБЛИЦЫ
            ADRXX00
            include "3DTABS_"
ОБЪЕКТЫ
            include "OBJECTS_"


