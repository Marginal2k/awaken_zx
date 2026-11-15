# STATION: таблица переименований меток (старое имя -> новое)

Метки `src/station/*.asm` приведены к читаемому виду; байты не изменились (проверка: `python build.py`, `--test-return`, `--test-ending` дают те же sha256 образов `build/station/*`, `build/flight/*` и `.trd`; `python tools/verify_original.py all` - 11 x BYTE-EXACT). Старое имя оставлено в комментарии `; orig: ИМЯ` у определения.

Принципы: имена, смысл которых неочевиден, не менялись (автоматические имена дизассемблера `Lc8b2`, `Ld73d`, `LL4036`, `lcd1e`, `Lc6xx` и т.п.). Метки переходов, на которые ссылается только их участок кода, стали локальными (`.имя`, видны до следующей глобальной метки; имя при этом сохранено): **748** локальных меток. Переименовано определений: **225**.

Константы оборудования (порты, коды команд, страницы): `src/station/EQUS.asm` (`PORT_*`, `OPCODE_*`, `PG_SHADOW0`, `PG*`, `SYSVAR_IY`).

## Не переименованные (frozen) метки

Не менялись: (1) все метки файлов `DATA_M.asm`, `DATAT.asm`, `DATA3D.asm` (данные, генерируются/правятся ассет-техником), в том числе **запись состояния `TIME`..`ABONS`** (23 меток, одинаковая раскладка в станции и полёте, см. `src/common/state.inc`):

`TIME`, `PLACE`, `PLANET`, `WHERE`, `WPLANET`, `SHIP`, `SKIMMER`, `STATUS`, `SUMM`, `TONN`, `TWRI`, `WKRBI`, `FUEL`, `WSKMI`, `NEWS`, `ORDER`, `SPEED`, `DALNO`, `MSTARS`, `WAY`, `WAYMASK`, `PSTARS`, `ABONS`

(2) метки, на которые ссылаются генераторы ассетов, `build.py`, `src/common/*`, `tools/xp/*`, `tools/scen/*` или `assets/text/*`:

`Button`, `CR`, `DEPACK`, `ET`, `LINES`, `Mode`, `NAME`, `PGMUZ`, `PKOL`, `RUN`, `STK7`, `Speed`, `TKOL`, `WKKOL`, `WSKOL`, `Window`, `x2`

(3) макросы `MACRO.asm` (`ADRXX00`, `SUB_BC`, `EXD`, `PAGE_`, `PAGES` ...) - ими пользуется весь код; (4) метки LANG-интерпретатора (`_IF`, `T_TXT`, `U_SHIP`, `CODE2`, `KCOM2` ...) - система команд языка Paradox, имена задокументированы в шапке `LANG.asm`; (5) метки окон и кнопок `W*`/`B*`/`N*`/`I*`/`F_S*` (OBR.asm, OBR2.asm), модели `Kobrad` ... (OBJX.asm, на них ссылается DATA3D).

## Соглашения исходного автора (имена сохранены)

| префикс/форма | значение |
|--|--|
| `W<имя>` / `W<имя>C` / `W<имя>_` | окно: обработчик, подпроцедура "курсор в области окна", процедура вывода окна (Outwin/BLACKW) |
| `B<имя>` / `B<имя>_` | кнопка: обработчик и дескриптор вывода (Outbut) |
| `N<имя>`, `I<имя>`, `F_Sxx` | выбор пункта списка окна (MARKO), индекс первого видимого пункта, реакция на огонь/отмену |
| `D<имя>n` | процедуры вывода пунктов списка окна |
| `Sm_ij`, `Gm_ij`, `Om_ij`, `Mv?n` | элементы матрицы поворота 3D (XR2): задание, чтение, умножение |
| `Lc9xx`, `lc9xx`, `Lcdxx` | клиппирование линий (CLPXR1, DRAWLIN): имена по адресу дизассемблера |
| `S0n`, `S_0n`, `S0n_`, `S_0n_` | rept-процедуры вывода символа со сдвигом n пикселей (PNT) |
| `_XXX`, `U_*`, `S_*`, `CODEn`/`KCOMn` | команды, аргументы и таблицы языка Paradox (LANG) |

## Таблицы по файлам

### BODY.asm

| было | стало | смысл |
|--|--|--|
| `RET_` | `DoNothing` | Пустой обработчик (ret), заглушка по умолчанию |
| `Dalee` | `StationStart` | Начало работы станции: сброс флагов, генерация цен, первая отрисовка |
| `M1` | `MainLoop` | Главный цикл станции (опрос кнопок, часы, события) |
| `FORRP` | `RepaintFlag` | Флаг: 0 = нужна полная перерисовка экрана (самомодифицируемый операнд) |
| `ZADACHA` | `TaskCall` | Вызов текущей фоновой задачи окна (call патчится) |
| `IXZD` | `TaskIX` | IX текущей задачи |
| `ZADAT` | `TaskProc` | Адрес процедуры текущей задачи (DoNothing по умолчанию) |
| `PLATA` | `FeeFlag` | Флаг: сработало событие платы (вызывает PARADOX, операция 16) |
| `WYDWOR` | `ExpelTimer` | Счётчик выдворения игрока со станции |
| `Int` | `Interrupt` | Обработчик прерывания IM2: музыка, часы, курсор, ввод |
| `FWOST` | `CursorBusy` | Флаг: курсор не рисовать в этом прерывании |
| `LMUSIC` | `MusicLast` | Последний номер мелодии (самомодиф. операнд) |
| `L7` | `AyMixerSaved` | Сохранённый регистр 7 AY (микшер) |
| `INT5` | `MusicPlay` | Вызов проигрывателя музыки (#DB05) |
| `INT3` | `ClockTick` | Счёт кадров и часы игрового времени (BCD в TIME) |
| `JUMP0` | `IntNextJump` | Переход, прочитанный из стека прерывания |
| `STKL` | `IntStackTop` | Вершина стека прерывания |
| `Tfire` | `ReadFireCancel` | Опрос огня/отмены: A = 0 ничего, b0 отмена, b1 огонь |
| `Suroff` | `SurroundOff` | Выключить все объекты среды (патч кода ret) |
| `Suron` | `SurroundOn` | Включить все объекты среды |
| `Adnsur` | `SurroundPtr` | Адрес текущего описателя среды |
| `ACTIV` | `SurroundActivate` | Активация объектов среды |
| `Tident` | `TakeIdent` | Идентификатор объекта под курсором |
| `Tident2` | `TakeIdentXY` | Идентификатор объекта по координатам BC |
| `Fire` | `OnFire` | Обработка нажатия огня (выбор объекта) |
| `UNPROC` | `UnclickHandler` | Адрес обработчика отжатия кнопки |
| `Chccl` | `CheckClickHandler` | Проверка, надо ли выполнять обработчик кнопки |
| `Ibscr` | `InitBufScreen` | Заполнить буфер экрана идентификатором объекта |
| `Itabob` | `InitTabob` | Очистить таблицу объектов |
| `TOOBJ4` | `ObjFieldAddr4` | Адрес поля 4 записи объекта |
| `TOOBJ` | `ObjFieldAddr` | Адрес поля записи объекта: HL = номер, A = смещение |

### BODY3D.asm

| было | стало | смысл |
|--|--|--|
| `INITCLP` | `InitClip3D` | Установка границ клиппирования 3D-вывода |
| `OSHIP` | `DrawShip3D` | Цикл вывода 3D-модели корабля |
| `SETZET` | `AddModelZ` | Прибавить смещение к координате Z объекта |
| `NSHIP_` | `DrawShipMenu` | Вывод всего меню кораблей |
| `ISHIPI` | `CountShipLines` | Подсчёт строк описания корабля |
| `ISHIP` | `InitShipView` | Подготовка вывода корабля |
| `SHIPIND` | `ShipIndex` | Номер показываемого корабля (самомодиф.) |
| `FROMS` | `ShipListFrom` | Номер, с которого показывается список |
| `SHIPI` | `DrawShipInfo` | Вывод информации о корабле |

### BODYOCUR.asm

| было | стало | смысл |
|--|--|--|
| `PGS` | `SetBank` | Сменить только банк (биты 0-2) порта #7FFD, сохранив остальные биты |
| `PG` | `SetPage` | Записать A в порт #7FFD и в NPG |
| `WOST` | `CursorRestoreSafe` | Восстановить фон под курсором, сохраняя регистры |
| `Awost` | `CursorRestore` | Восстановить фон под курсором из буфера |
| `OUTC` | `CursorDrawSafe` | Нарисовать курсор, сохраняя регистры |
| `Outc1` | `CursorDraw` | Сохранить фон и нарисовать курсор (вид зависит от объекта под ним) |
| `Outcur` | `CursorDrawIfMoved` | Нарисовать курсор, если было движение |
| `TESTMOV` | `CursorMoved` | Проверка движения/нажатий (Z = ничего не изменилось) |
| `AKURSA` | `CursorSpritePtr` | Адрес набора спрайтов курсоров |
| `Bufz` | `CursorSaveBuf` | Буфер запоминания фона под курсором |
| `Servms` | `ServeMouse` | Опрос мыши Kempston |
| `Servkj` | `ServeJoystick` | Опрос джойстика Kempston |
| `Servqa` | `ServeKeyboard` | Опрос клавиатуры (Q A O P, Space, M) |
| `Gomove` | `CursorMove` | Сдвиг курсора по нажатому направлению |
| `Cler` | `ClearInput` | Сбросить состояние предыдущего опроса |

### CIRCMATH.asm

| было | стало | смысл |
|--|--|--|
| `CIRCLE` | `DrawCircle` | Вывод окружности/круга в окне карты |
| `XQUAD` | `Square` | Квадрат числа A: DE = A^2 |
| `TAKECRD` | `CircleHalfWidth` | X = sqrt(r^2 - Y^2) для окружности |
| `MISLNUP` | `SkipRowsUp` | Пропустить строки сверху |
| `MISLNDN` | `SkipRowsDown` | Пропустить строки снизу |
| `GOSTA` | `FindStateAtMap` | Номер государства по координатам карты |
| `FARER` | `StarDistance` | Расстояние от звезды |

### DOPPROC.asm

| было | стало | смысл |
|--|--|--|
| `INWIN` | `DrawSpriteInWindow` | Вывод спрайта 4x4 в окне |
| `CLINW` | `ClearWindowChars` | Стереть окно по знакоместам |
| `READKEY` | `ReadKey` | Ждать и прочитать код клавиши |
| `TCODE` | `PortToCode` | Порт и маска -> код клавиши |
| `TOCODE` | `PortsToCodes` | Преобразовать порты в коды |
| `TOPORT` | `CodesToPorts` | Преобразовать коды в порты и маски |
| `SCROL` | `ScrollList` | Прокрутка списка в окне |
| `DELMK` | `DeleteLastMark` | Удалить последнюю пометку |
| `CHOOSE` | `DrawMark` | Вывод пометки строки |
| `DELCH` | `EraseMark` | Удаление пометки |
| `MARKO` | `MarkRowStretch` | Пометить строку (окна с изменяемым размером) |
| `MARKo` | `MarkRowFixed` | Пометить строку (окна с фиксированным размером) |
| `LIST1` | `PrintTextByIndex1` | Вывод текста по индексу, раздел 1 |
| `LIST0` | `PrintTextByIndex0` | Вывод текста по индексу, раздел 0 (через OTXT) |
| `LIST` | `PrintTextByIndex` | Вывод текста по индексу, раздел 0 |
| `FLIST1` | `FindTextByIndex1` | Поиск текста по индексу, раздел 1 |
| `FLIST` | `FindTextByIndex` | Поиск текста по индексу |
| `PLIN` | `PrintPlanetInfo` | Вывод информации о планете |
| `STOREW` | `SaveWindowParams` | Запомнить параметры окна |
| `RESTORW` | `RestoreWindowParams` | Восстановить параметры окна |
| `PINFO2` | `PlanetInfoHere` | Данные планеты текущего местонахождения |
| `PINFO` | `PlanetInfo` | Данные планеты системы по номеру |
| `PINFOL2` | `PlanetInfoHereLang` | PINFO2 для вызова из страницы языка |
| `PINFOL` | `PlanetInfoLang` | PINFO для вызова из страницы языка |
| `RETSCR` | `ShowCursorBack` | Вернуть курсор после вывода |
| `HIDESCR` | `HideCursor` | Убрать курсор перед выводом в экран |
| `TESTSZ` | `TestWindowOut` | Проверка вылета окна за экран |
| `LINE2` | `LineWindow2` | Описатель линии (нижняя строка) |
| `HIDEP1` | `MenuHideAll` | Пункт меню: скрыть все |
| `HIDEP2` | `MenuCloseWindows` | Пункт меню: закрыть окна |
| `HIDEP3` | `MenuSaveSurround` | Пункт меню: запомнить среду |
| `HIDEP4` | `MenuArrange` | Пункт меню: расставить |
| `HIDEP5` | `MenuSetupSurround` | Пункт меню: установки среды |
| `HIDEP6` | `MenuSetupGame` | Пункт меню: установки игры |
| `HIDEP7` | `MenuRestore` | Пункт меню: восстановиться |
| `AMPLAN` | `PlanetCount` | Количество планет в системе |
| `NATISNU` | `PressButtonPair` | Нажатие одной кнопки и отжатие другой |
| `KOLLIN` | `CountTextLines` | Количество строк в тексте |
| `FROMLIN` | `PrintFromLine` | Вывод текста с номера строки |
| `OPENER` | `OpenErrorWindow` | Подготовить и вывести окно ошибки |
| `OPENER_L` | `OpenErrorWindowLang` | OPENER для вызова из страницы языка |
| `RND` | `Random` | Генератор случайных чисел |
| `RNDO` | `RandomSeed` | Генератор по адресу семени в HL |
| `RANDTT` | `RandomizeTrade` | Генерация таблицы количеств и цен товаров |
| `NORT` | `TradeEmpty` | Нет планет: таблица торговли пуста |
| `NUMSHIP` | `SelectedShipNumber` | Номер выбранного корабля/скимера |

### DRAWLIN.asm

| было | стало | смысл |
|--|--|--|
| `INIt` | `InitLineClip` | Инициализация пределов клиппирования линии |
| `OUTLINE` | `DrawLine` | Вывод линии по вектору координат и маске |
| `VsLINE` | `LineVisible` | Проверка видимости линии |
| `ClipLin` | `ClipLine` | Клиппирование линии |

### HELP.asm

| было | стало | смысл |
|--|--|--|
| `DHLP2_` | `HelpDrawList` | Вывод списка пунктов справки |
| `HLPIND` | `HelpIndex` | Индекс первого видимого пункта справки |
| `DHLP3_` | `HelpDrawItem` | Вывод описания пункта справки |
| `SETHIND` | `HelpSetIndex` | Задать индекс пункта справки |
| `DHLPL1` | `HelpDrawLine` | Вывод строки справки |

### KARTA.asm

| было | стало | смысл |
|--|--|--|
| `KARTOUT` | `DrawGalaxyMap` | Вывод всего на карту (A = инверсия) |
| `CENTRE` | `CenterMap` | Центрировать карту на звезде |
| `CENTRE2` | `CenterMapAt` | Центрирование по координатам |
| `STARCH` | `ChooseStar` | Выбор звезды под курсором |
| `OPRPLAN` | `FindPlanetAtCursor` | Определение планеты под курсором |
| `GENKART` | `GenerateMapTiles` | Генерация четырёх карт (знакомест звёздного поля) |
| `MBUFM` | `BuildVisibleStars` | Создание буфера видимых звёзд |
| `PLANCH` | `ChoosePlanet` | Выбор планеты в окне карты |
| `MOVPLAN` | `AnimatePlanets` | Движение планет в окне |
| `WHO_` | `PlanetCursorKind` | Вид курсора мигающей планеты |
| `WHO` | `PlanetsSelectionKind` | Определение типа выделения планет |
| `PLOUT` | `DrawPlanetSprite` | Вывод спрайта планеты или маркера |
| `FSTAR2` | `FindStarInRoute` | Поиск звезды в буфере маршрута |
| `FSTAR` | `FindStarInMemory` | Поиск звезды в буфере запоминаний |
| `PNTPLN` | `PrintPlanetNameHere` | Печать имени планеты текущей системы |
| `PNTPLAN` | `PrintPlanetName` | Печать имени планеты |
| `CHHS` | `PaintMarkRow` | Закрасить строку для маркировки |
| `PINFO_` | `GetSystemData` | Данные системы по номеру планеты |
| `MARKOL` | `MarkRouteLine` | Определение маски и узлов линии маршрута |
| `SPRP` | `SprPlanet` | Спрайт: просто планета |
| `SPRP2` | `SprPlanetHere` | Спрайт: планета пребывания |
| `SPRP3` | `SprPlanetRoute` | Спрайт: маршрутная планета |
| `SPRP4` | `SprPlanetCursor` | Спрайт: выбор планеты |
| `SPLUS` | `SprPlus` | Спрайт-маркер плюс |
| `SMINI` | `SprMinus` | Спрайт-маркер минус |
| `STREUG` | `SprTriangle` | Спрайт-маркер треугольник |
| `SNULL` | `SprEmpty` | Спрайт-маркер пустой |
| `SKREST` | `SprCross` | Спрайт-маркер крест |
| `SQUADR` | `SprSquare` | Спрайт-маркер квадрат |

### LANG.asm

| было | стало | смысл |
|--|--|--|
| `TAKENUM` | `ReadNumber` | Распознать число из ix |
| `TAKEARG` | `ReadArgument` | Прочесть аргумент |
| `TAKEMEDARG` | `ReadOperator` | Прочесть межаргумент (операцию) |
| `TARGTURN` | `ReadJumpAddress` | Прочесть адрес перехода |
| `TAKEJARG` | `ReadHandlerAddress` | Прочесть адрес обработчика |
| `JUMPSYMB` | `JumpBySymbol` | Переход по таблице обработчиков символов |
| `FINDSYMB` | `FindSymbol` | Поиск символа в таблице |
| `OBRARGU` | `ProcessArgument` | Обработчик аргументов |
| `FINDINTREE` | `FindTextInTree` | Поиск идентификатора текста по дереву персонажа и сцены |
| `TAKETON` | `CountTonnage` | Подсчёт общего веса |
| `PUTWORD` | `PutWord` | Положить слово в буфер аргументов |
| `PUTBYTE` | `PutByte` | Положить байт в буфер аргументов |
| `TAKE_PINFO` | `TakePlanetInfo` | Данные планеты/системы по региону |
| `STKMEM` | `ParadoxSavedSP` | Сохранённый SP интерпретатора |
| `F_EXIT` | `ParadoxExitFlag` | Флаг выхода из языка |
| `ARG` | `ParadoxArgBuf` | Буфер аргументов |
| `ARGD` | `ParadoxArgBuf2` | Дополнительный буфер аргументов |

### LOADER.asm

| было | стало | смысл |
|--|--|--|
| `FILE1` | `FileKarta` | Имя файла KARTA |
| `FILE2` | `FileMuz` | Имя файла музыки |
| `FILE3` | `FileStscr` | Имя файла картинок станции |
| `FILE4` | `FileHelp` | Имя файла HELP |
| `FILE5` | `File3D` | Имя файла D3D |
| `FILE6` | `FileLang` | Имя файла LANG |
| `LD1` | `LoadFiles` | Загрузка файлов в страницы и общая инициализация |

### OBJ.asm

| было | стало | смысл |
|--|--|--|
| `Mactiv` | `ActivateIfOnDesk` | Активизация с проверкой присутствия на столе |
| `Mactive` | `ActivateObject` | Активизировать объект на столе или вписать новый |
| `Delobj` | `DeleteObject` | Удалить объект из буфера экрана |
| `Objtbuf` | `ObjectToBuf` | Записать объект в буфер экрана |
| `Corr` | `CorrectCoords` | Коррекция координат объекта |
| `Outlin` | `OutLine` | Вывод линии |
| `Slin` | `SetLinePrint` | Задать данные печати в линии |
| `Swin` | `SetWindowPrint` | Задать данные печати в окне |
| `Outwin` | `OutWindow` | Вывод окна |
| `Outbut` | `OutButton` | Вывод кнопки |
| `Sbut` | `SetButtonPrint` | Задать данные печати в кнопке |
| `Outrm` | `OutFrame` | Рисование рамки перемещения/размера |
| `Clrlin` | `ClearLine` | Очистить строку на экране под текст |
| `Clinwin` | `ClearInWindow` | Очистить внутренность окна |
| `ERSOBJ` | `EraseObject` | Стереть объект (Z = стёрт) |
| `ERSOBJ2` | `CloseObject` | Закрыть объект |
| `Movsiz` | `MoveSizeObject` | Перемещение и изменение размера объекта |
| `ERASOBJ` | `EraseObjectCore` | Стирание объекта по номеру DE |
| `LASTOBJ` | `LastDeskObject` | Последний объект на столе |
| `FOBJ` | `FindDeskObject` | Поиск объекта на столе |
| `SETCRDS` | `SetupCoords` | Установить сетапные координаты объектов |
| `NEWOBJ` | `OpenObject` | Открыть/активировать объект по шоу-адресу |
| `WINOBR1` | `WindowHandler1` | Обработчик окна: первое нажатие активирует, перемещение/размер |
| `WINOBR2` | `WindowHandler2` | Обработчик окна: сразу ловит огонь и отмену |
| `WINOBR3` | `WindowHandler3` | Обработчик окна: всегда ловит огонь и отмену |
| `BUTOBR1` | `ButtonHandler` | Общий обработчик кнопок |
| `BLACKW` | `SetBlackWindow` | Подготовка вывода чёрных окон |
| `BLACKWP` | `SetBlackWindowPage` | Подготовка вывода чёрных окон (вариант) |
| `WHITEW` | `SetWhiteWindow` | Подготовка вывода белых окон |

### PNT.asm

| было | стало | смысл |
|--|--|--|
| `VTXT` | `VirtualPrint` | Виртуальный вывод строки (только считает координату Y) |
| `OTXT` | `PrintText` | Вывод текста с форматированием |
| `Pntpro` | `PrintGlyph` | Вывод одного символа |
| `Eyw` | `WinEndY` | Нижняя граница окна (самомодиф.) |
| `Exw` | `WinEndX` | Правая граница окна |
| `Bxw` | `WinBeginX` | Левая граница окна |
| `Bxh` | `WinBeginXHi` | Старший байт левой границы |
| `Byw` | `WinBeginY` | Верхняя граница окна |
| `Byh` | `WinBeginYHi` | Старший байт верхней границы |
| `Endpr` | `PrintEnd` | Конец вывода (флаги окончания текста/окна) |
| `Onum2` | `PrintNumber2` | Вывод числа, 2 знака |
| `Onum5` | `PrintNumberPad` | Вывод числа с ведущими нулями |
| `ONUMB` | `PrintNumber` | Вывод числа BC |
| `Outtxt` | `OutText` | Вывод текста до конца окна или экрана |
| `CXTAB1` | `TabStop1` | Табуляция 1 |
| `CXTAB2` | `TabStop2` | Табуляция 2 |
| `CXTAB3` | `TabStop3` | Табуляция 3 |
| `CXTAB4` | `TabStop4` | Табуляция 4 |
| `CXTAB5` | `TabStop5` | Табуляция 5 |
| `Hlt` | `MeasureText` | Длина текста в пикселях до символа B |
| `Hltxt` | `MeasureTextZ` | Длина строки текста в пикселях |
| `SPECSYM` | `PrintSpecialChar` | Вывод спецсимволов (коды #20-#32) |

### XR2.asm

| было | стало | смысл |
|--|--|--|
| `Polygon` | `DrawPolygon` | Вывод закрашенного многоугольника |
| `Renobj` | `RenderObject` | Вывод объекта |
| `Rendi` | `RenderLoop` | Цикл вывода вершин и граней |
| `Calcd` | `CalcProject` | Расчёт проекции точки |
