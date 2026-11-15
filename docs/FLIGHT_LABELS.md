# FLIGHT: таблица переименований меток (старое имя -> новое)

Метки `src/flight/*.asm` (код полётной части) приведены к читаемому виду; байты не изменились (проверка: `python work/assets_tech/gate.py check` - `DIFF: []`, `MISSING: []`; `python tools/verify_original.py all` - 11 x BYTE-EXACT). Старое имя оставлено в комментарии `; orig: ИМЯ` у определения. `build/flight.sym` меняется (ожидаемо).

Принципы: смысл неочевиден - имя не менялось (автоимена дизассемблера `LCxxx`, `Xxxx`, `ZJxx`, `Lxxxx`; адреса операндов самомодифицируемого кода вроде `STK1`, `COUNTER`). Метки переходов, на которые ссылается только их участок кода и только через `jp`/`jr`/`djnz`, стали локальными (`.имя`, имя сохранено): **415** меток (по всем файлам src/flight, src/boot/intro.asm). Переименовано определений: **136**.

Режимы ИИ (`C_*`, индекс в `AiModeTable`), типы (`T_*`), смещения записи объекта (`ALFA`, `POWOR`, `MODE`, `OMODE`...) и константы порогов описаны в `src/flight/EQUS.asm`; порты - `PORT_PAGE`, `PORT_AY_REG`, `PORT_ULA`.

## Frozen (не переименованы)

Метки, на которые ссылаются `tools/*`, `build.py`, `assets/*` (генераторы, текстовые секции, tablespec, `build/gen/*`), `tools/xp/*`, `tools/scen/*`, запись состояния `TIME`..`ABONS` (`src/common/state.inc`), glue станция<->полёт (`src/common`): 

`ABONS`, `ACTION`, `ATAGTAB`, `BRIGHT`, `CARSB`, `CIRCLE`, `CR`, `CRASH`, `CRSHST`, `CS`, `DALNO`, `DEF`, `DEHRUST`, `DiskSlotSave`, `ED`, `ED_`, `FONT`, `FUEL`, `GENSHIPS`, `IASTER1`, `IASTER2`, `IGRZ1`, `IGRZ2`, `IGRZ3`, `IGRZ4`, `IGRZ5`, `IKRS1`, `IKRS2`, `IKRS3`, `IKRS4`, `IMLT1`, `IMLT2`, `IMLT3`, `IMLT4`, `INDTABK`, `INK`, `INVERSE`, `IPOL1`, `IPOL2`, `IPOL3`, `IPOL4`, `ITRG1`, `ITRG2`, `ITRG3`, `ITRG4`, `ITRG5`, `ITRG6`, `IUFO1`, `IUFO2`, `IUFO3`, `IUFO4`, `IUFO5`, `IUFO6`, `IUFO7`, `JOYSTIK`, `KCANCEL`, `KDOWN`, `KFIRE`, `KLEFT`, `KORNI`, `KRIGHT`, `KUP`, `L90`, `L91`, `MODELSTAR`, `MOUSE`, `MSTARS`, `MULTB`, `MUSIC`, `NEWS`, `NO`, `OBJ3D`, `OBJX`, `OFF`, `ORDER`, `PAPER`, `PKOL`, `PLACE`, `PLANDICTAT`, `PLANET`, `PRINT`, `PSTARS`, `PY`, `REMOVEOBJ`, `RENOBJ`, `RETST`, `RETSTT`, `RND`, `SETGD`, `SETS`, `SETSD`, `SETT`, `SFXA`, `SFXB`, `SHIP`, `SINTB`, `SKIMMER`, `SPEED`, `SPT`, `SS`, `STATUS`, `STK7`, `SUMM`, `Speed`, `TIME`, `TKOL`, `TONN`, `TWRI`, `TYPE`, `T_STATION`, `VOX`, `VOXAL`, `WAY`, `WAYMASK`, `WHERE`, `WKKOL`, `WKRBI`, `WPLANET`, `WSKMI`, `WSKOL`, `XX`, `_ALLTARGET`, `_ANTIROKET`, `_BACK`, `_DESTROY`, `_DOCKING`, `_DROPCARGO`, `_DROPMINE`, `_FREEFLY`, `_FRONT`, `_GAMEOVER`, `_GETTARGET`, `_HAVE`, `_HIPER`, `_LOSTTARGET`, `_MODEOFF`, `_MODEON`, `_NOCARGO`, `_NOMINE`, `_NOROKET`, `_NOTARGET`, `_POWERRAY`, `_ROKET`, `_ROKETGO`, `_SYSTEMOFF`, `_SYSTEMOK`, `_SYSTEMREADY`, `_SYSTEMSOFF`, `_TAKING`, `_TARGETOFF`

## Режим ИИ -> обработчик

| C_ | режим | обработчик |
|--|--|--|
| 0 `C_STAY` | | `Stay` |
| 1 `C_GOPLANET` | | `GoToPlanet` |
| 2 `C_FIGHT` | | `Fight` |
| 3 `C_GOSTAR` | | `GoToStar` |
| 4 `C_FLYFREE` | | `FlyFree` |
| 5 `C_DEFENCE` | | `Defence` |
| 6 `C_JUMPOUT` | | `HyperJumpEnd` |
| 7 `C_JUMPING` | | `HyperJumpStart` |
| 8 `C_NAVODROKET` | | `MissileHoming` |
| 9 `C_STAYSTAT` | | `StationStay` |
| 10 `C_DEFENCESTAT` | | `StationDefence` |
| 11 `C_STARTPOLICE` | | `PoliceLaunch` |
| 12 `C_BACKPOLICE` | | `PoliceReturn` |
| 13 `C_BACKTOASTER` | | `ReturnToAsteroid` |
| 14 `C_GETCARGO` | | `PickUpCargo` |
| 15 `C_GOAWAY` | | `GoAwayNoCargo` |
| 16 `C_FLYAWAY` | | `FlyAway` |
| 17 `C_TURNOUT` | | `TurnAway` |
| 18 `C_GOASTER` | | `AsteroidDrift` |
| 19 `C_FORSAGE` | | `Afterburner` |
| 20 `C_FLYAROUND` | | `FlyAroundPlayer` |
| 21 `C_RETURN` | | `ReturnAfterFlyAround` |

## Таблица переименований

| старое | новое | смысл |
|--|--|--|
| `ITAB` | `AiModeTable` | таблица обработчиков режимов ИИ (индекс = C_*) |
| `NTH` | `AiModeNone` | пустой режим (ret) |
| `OBLET` | `FlyAroundPlayer` | C_FLYAROUND: облёт игрока, поворот на 20 градусов по BETA |
| `WOZWRAT` | `ReturnAfterFlyAround` | C_RETURN: возврат после облёта, поворот назад |
| `FORSAGE` | `Afterburner` | C_FORSAGE: форсаж объекта |
| `GETCARGO` | `PickUpCargo` | C_GETCARGO: подобрать груз |
| `BACKAS` | `ReturnToAsteroid` | C_BACKTOASTER: возврат на астероид |
| `SROKA` | `MissileAttackStation` | ракетная атака на станцию |
| `GOAWAY` | `GoAwayNoCargo` | C_GOAWAY: просто улететь, не беря груз |
| `GOSUN` | `GoToStar` | C_GOSTAR: движение по заданному углу (к звезде) |
| `GOEAR` | `GoToPlanet` | C_GOPLANET: лететь на планету |
| `GOSIMPLY` | `MoveStraight` | общий шаг движения по текущим углам |
| `FIGHT` | `Fight` | C_FIGHT: нападение на объект |
| `NAVODFIRE` | `AimNose` | наведение носа на цель |
| `FIROK` | `MissileAttack` | ракетная атака |
| `DEFENCE` | `Defence` | C_DEFENCE: защита от нападения |
| `BACKUP` | `PoliceReturn` | C_BACKPOLICE: возврат на станцию, стадия 2 |
| `TURNOUT` | `TurnAway` | C_TURNOUT: повернуть в сторону |
| `OTLET` | `FlyAway` | C_FLYAWAY: отлёт в заданном направлении |
| `STARTPOLICE` | `PoliceLaunch` | C_STARTPOLICE: пуск полиции из станции |
| `STATDEF` | `StationDefence` | C_DEFENCESTAT: станция сбивает ракеты |
| `STYSTAT` | `StationStay` | C_STAYSTAT: станция проверяет статус игрока |
| `NAVODROKET` | `MissileHoming` | C_NAVODROKET: ракета идёт по следу цели |
| `JUMPING` | `HyperJumpStart` | C_JUMPING: начало гиперперехода |
| `JUMPOUT` | `HyperJumpEnd` | C_JUMPOUT: конец гиперперехода |
| `STAY` | `Stay` | C_STAY: стоять |
| `FREEFLY` | `FlyFree` | C_FLYFREE: полёт без управления с вращением |
| `GOASTER` | `AsteroidDrift` | C_GOASTER: движение астероида |
| `SHIPINTELEGENT` | `ShipAI` | главный цикл ИИ: обход всех объектов, вызов обработчика режима |
| `PRECORD` | `ApplyPlayerMotion` | смещение координат всех объектов по движению игрока |
| `GETADRY` | `ObjAddrFromIndexIY` | адрес вектора объекта по индексу, в iy |
| `GETADR` | `ObjAddrFromIndex` | адрес вектора объекта по индексу, в hl |
| `GETINDX` | `ObjIndexFromIX` | индекс объекта по адресу в ix |
| `GETINDY` | `ObjIndexFromIY` | индекс объекта по адресу в iy |
| `GETIND` | `ObjIndexFromHL` | индекс объекта по адресу в hl |
| `FINDOB` | `FindAnyObject` | найти какой-нибудь объект |
| `FINDPEACE` | `FindPeaceful` | найти мирного |
| `FINDALL` | `FindAnyNotUfo` | найти любого, кроме УФО |
| `FINDUFO` | `FindUfo` | найти УФО |
| `FINDPIRAT` | `FindPirate` | найти пирата |
| `TESTSUBJ` | `CheckSubjectGone` | проверка, исчез ли субъект персонажа |
| `FIREING` | `ShipFire` | выстрел персонажа |
| `FLOTSTART` | `FleetStart` | проверка условий и старт флота |
| `FINDASTER` | `FindAsteroid` | найти астероид |
| `FINDOBJ` | `FindObjectByType` | поиск первого объекта по типу в d |
| `FINDFREE` | `FindFreeSlot` | найти свободный вектор объекта |
| `NEARCARGO` | `FindNearestCargo` | найти ближайший груз |
| `CHECKOBJ` | `CanTakeCargo` | флаг z: объект умеет брать грузы |
| `YESCARGO` | `HasCargoToTake` | проверка наличия грузов для объекта |
| `MAKEEXPLO` | `MakeExplosion` | данные о взрыве и осколках объекта |
| `RASTOY` | `DistanceHigh` | расстояние (кратное #100) между ix и iy |
| `OUTLINE` | `DrawLine3D` | вывод линии по 3D-координатам |
| `VSLINE` | `CheckLineVisible` | проверка видимости линии |
| `MNUMS_` | `PrintNumbersInOrder` | вывод номеров по порядку |
| `PNUM` | `PrintNumScroll` | вывод числа в компе со скроллом |
| `PNUM2` | `PrintNumNoScroll` | вывод числа в компе без скролла |
| `GAMEOVER` | `GameOver` | конец игры (гибель) |
| `NEWROKET` | `NewMissile` | создать ракету |
| `RKN11` | `InitMissile` | инициализация ракеты |
| `REPANEL` | `RedrawPanel` | перерисовка индикаторов панели |
| `KILLTRASH` | `KillTrash` | убрать весь мусор форсажа |
| `TRASHINI` | `InitTrash` | инициализация мусора при ускорении |
| `RNDTURN` | `RandomTurns` | случайные повороты |
| `ONWAY` | `AimAtObject` | наведение носа объекта на другой объект |
| `CHNPOL` | `CheckPolicePair` | не менее двух полицейских на нападающего |
| `CHARCO` | `MoveMissiles` | изменение координат ракет |
| `STABL` | `HitStatusTable` | таблица индексирования статуса при попадании |
| `SHUT` | `PlayerHit` | регистрация попадания игрока в объект |
| `CHSTATUS` | `ChangeStatus` | смена статуса игрока |
| `FLINE` | `DrawPlayerLaser` | рисование лазера игрока |
| `DROPCARGO` | `DropCargo` | бросить груз |
| `NEWCARGO` | `SpawnCargo` | создать контейнер с грузом или мину |
| `NEWORD` | `NewOrder` | новое задание в зависимости от типа |
| `DATALINES` | `DrawDataLines` | вызов рисования даталиний |
| `NWSUN` | `NewSun` | новое солнце |
| `BLACKSUN` | `MakeBlackHole` | генерация чёрной дыры |
| `SUNB` | `BlackHoleControl` | управление чёрной дырой |
| `MVSUN` | `MoveSun` | управление звездой, изменение координат |
| `FARSUN` | `NearestSunDistance` | наименьшее расстояние от игрока до солнца |
| `FAREAR` | `PlanetDistance` | расстояние от игрока до ближайшей планеты |
| `OUTSUN` | `DrawSun` | вывод солнца |
| `OUTEAR` | `DrawPlanet` | вывод планеты |
| `GGALD` | `GenAllStars` | генерация всех звёзд |
| `NEWVSPR` | `NewVoxelSprite` | занести в буфер данные о новом воксельном спрайте |
| `MOVEON` | `MoveShipsForward` | сдвиг кораблей по движению вперёд |
| `GOSTA` | `GovernmentAt` | государство, в котором находится карта |
| `SETCONTROL` | `ControlsHandler` | управление полётом: опрос клавиш |
| `LAUNG1` | `LaunchMissile1` | пуск ракеты 1 |
| `LAUNG2` | `LaunchMissile2` | пуск ракеты 2 |
| `LAUNG3` | `LaunchMissile3` | пуск ракеты 3 |
| `NOCELS` | `ShowNoTarget` | сообщение "нет цели" |
| `HIPER` | `HyperJump` | вызов гиперпрыжка |
| `UNROKET` | `AntiMissile` | противоракетная система |
| `CLRMARK` | `CancelTargets` | отмена захвата целей |
| `NAVOD` | `MissileGuidanceMode` | режим наведения ракеты |
| `FLINE2` | `FireButton` | кнопка FIRE в разных режимах |
| `ZAHWAT` | `TargetLockToggle` | вкл/выкл режим захвата цели |
| `TURNLIGHTER` | `ToggleLight` | переключение подсветки |
| `JUMPDRIVE` | `PlayerAfterburner` | форсаж двигателя игрока |
| `FREECONTROL` | `FreeFlightControl` | свободный полёт |
| `DROPCR` | `DropCargoKey` | сброс груза |
| `DROPMINE` | `DropMineKey` | сброс мины |
| `RETURNSYS` | `ReturnSystem` | система возврата |
| `FRONTBACK` | `FrontBackView` | задний/передний виды |
| `GAZ` | `Throttle` | прибавить газ |
| `MAXSPEED` | `SetMaxSpeed` | максимальная скорость |
| `TORMOZ` | `Brake` | торможение |
| `LEFTT` | `RollLeft` | поворот влево |
| `RIGHTT` | `RollRight` | поворот вправо |
| `LEFTF` | `TurnLeft` | вращение влево |
| `RIGHTF` | `TurnRight` | вращение вправо |
| `UPP` | `PitchUp` | вверх |
| `DOWNN` | `PitchDown` | вниз |
| `COMPOS` | `DrawCompass` | компас (чистка и вывод) |
| `MINISPRITE` | `DrawMiniSprite` | вывод спрайта 3x3 (6 байт) |
| `RADAR` | `DrawRadar` | радар |
| `MOTAB` | `RadarMotionTable` | таблица радара |
| `PRICEL` | `DrawCrosshair` | рисование прицела |
| `MPRICEL` | `CrosshairSprite` | спрайт прицела |
| `TIMER` | `ShowTime` | вывод и изменение времени на панели |
| `PRNUM` | `PrintBcd` | печать числа в BCD из a |
| `PRINTNUM` | `PrintNumber` | вывод числа |
| `RECORD` | `ToShipCoords` | преобразование координат по обратной матрице |
| `PEREWOROT` | `InvertMatrix` | сделать матрицу обратной |
| `WAYUNGLE` | `AimAngles` | точное определение двух углов наведения носа |
| `MMATRX` | `CallMatrix` | вызов расчёта матрицы пространства |
| `CALC2D3D` | `Project3Dto2D` | перевод из 3D в 2D |
| `CALCUNGLE` | `CalcAngle` | угол между объектами по плоскости |
| `ATAGDIV` | `ArcTanDiv` | расчёт arctg(hl/de) |
| `FDIV` | `FastDivide` | быстрое деление со знаком |
| `TURNMATR` | `TurnMatrix` | преобразование матрицы пространства в обратную |
| `SHMTRX` | `ShipMatrix` | матрица-вектор корабля |
| `SIZEOBJ` | `ObjectSize` | размер объекта по индексу |
| `PINFO` | `PlanetInfo` | информация о планете системы |
| `CLRBUFS` | `ClearBuffers` | чистка буферов спрайтов и объектов |
| `RETSTAT` | `ReturnToStation` | возврат на станцию |
