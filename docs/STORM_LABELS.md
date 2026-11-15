# STORM: таблица переименований меток (старое имя -> новое)

Метки `src/storm/*.asm` переименованы для читаемости; байты не изменились (проверка: `python tools/verify_storm.py all`,
sha256 всех собираемых бинарников совпадает с исходным). Старое имя сохранено в комментарии `; orig: ИМЯ` у определения.
Имена, в которых смысл не очевиден, не менялись (в частности, автоматические имена дизассемблера `Lc8b2`, `Ld73d`, `Vx1`, `PP1` и т.п.).
Константы: порты, страницы, экран - в `src/storm/HW.asm` и `src/storm/EQUS.asm`.

Метки переходов, на которые ссылаются только соседние `jr/jp/djnz` того же участка, стали локальными (`.имя`, видимы до
следующей глобальной метки); имя при этом сохранено. Всего локальных меток: 129.

Переименовано определений: 181 (151 различное старое имя). Одно и то же старое имя может иметь разные значения в разных сборках (LAND, VSPRITE, S3D), поэтому таблица разбита по файлам.

## BLK1.asm

| было | стало |
|--|--|
| `Moveu` | `MoveObjects` |
| `Calcstp` | `CalcSteps` |

## BLK2.asm

| было | стало |
|--|--|
| `Repanel` | `RedrawPanel` |
| `Datalin` | `DrawStatusLine` |
| `Fshild` | `DrawShield` |
| `Ffuel` | `DrawFuel` |
| `Ffire` | `DrawFire` |
| `Fspeed` | `DrawSpeed` |

## BLK3.asm

| было | стало |
|--|--|
| `Datal` | `DrawGauge` |

## BLK5.asm

| было | стало |
|--|--|
| `Korni` | `SquareRootTab` |

## BLK6.asm

| было | стало |
|--|--|
| `Precord` | `SetCoordsByMove` |

## BLK7.asm

| было | стало |
|--|--|
| `Vsline` | `VisibleLine` |
| `Shmtrx` | `ShipMatrix` |
| `Outline` | `DrawLine3d` |
| `Masklin` | `LineMask` |

## EQUS.asm

| было | стало |
|--|--|
| `PS` | `TURN_STEP` |
| `Olen` | `OBJ_LEN` |
| `A3D` | `OBJ_COUNT` |
| `ADHIDE` | `DROP_CODE_ADDR` |
| `PG3D` | `PAGE_3D` |
| `PGSPR` | `PAGE_VOXEL` |
| `PGNORM` | `PAGE_NORMAL` |
| `HSCR` | `HIDDEN_SCREEN` |
| `Splayer` | `PLAYER_INDEX` |
| `Vox` | `VOX_DRAW` |
| `TAKESPD` | `VOX_TAKE_SPEED` |
| `OUTALL` | `VOX_OUT_ALL` |
| `NEWPOS` | `VOX_NEW_POS` |
| `NEWPSS` | `VOX_NEW_POS2` |
| `RETURN` | `VOX_RETURN` |
| `RRT` | `VOX_TURN_RIGHT` |
| `RLT` | `VOX_TURN_LEFT` |
| `D3D2` | `VOX_DRAW_3D2` |
| `INIT` | `ENG3D_INIT` |
| `OUTALL2` | `ENG3D_OUT_ALL` |
| `NXTO` | `ENG3D_NEXT_OBJECT` |
| `ADI3D` | `ENG3D_OBJECT_INDEX` |
| `MOVEON` | `ENG3D_MOVE_ON` |
| `PRECORD` | `ENG3D_PRECORD` |
| `NULMOVE` | `ENG3D_NULL_MOVE` |
| `FLINE` | `ENG3D_LINE` |
| `STPTURN` | `MAX_TURN` |

## LAND.asm

| было | стало |
|--|--|
| `MAKEDRP` | `BuildDropCode` |
| `MDS1` | `BuildDropLoop` |
| `MODUL` | `DropModule` |
| `DROPSCR` | `DropScreen` |
| `DS0` | `DropLine` |
| `DS01` | `DropLineDst` |
| `DS1` | `DropLineEnd` |
| `DLEN` | `DROP_LINE_LEN` |
| `STK92` | `DropSavedSp` |
| `DEFW_` | `InitVarsImage` |
| `DDLEN` | `INIT_VARS_LEN` |
| `DALEE` | `LandingInit` |
| `M2` | `MainLoop` |
| `FILN4` | `FileNamePage4` |
| `FILN3` | `FileNamePage3` |
| `VOXOBJ_` | `DrawVoxelObject` |
| `LEFT` | `CamLeft` |
| `RIGHT` | `CamRight` |
| `NEWPOS_` | `NewPosPaged` |
| `NEWPSS_` | `NewPos2Paged` |
| `UP` | `CamUp` |
| `ZET` | `CamZ` |
| `IKS` | `CamX` |
| `IGR` | `CamY` |
| `DOWN` | `CamDown` |
| `TAKSPD` | `TakeSpeedPaged` |
| `PG` | `SetPage` |
| `TAKEW` | `ReadWord3D` |
| `NEWEFA_` | `SetEffectA` |
| `NEWEFB_` | `SetEffectB` |
| `VOXAD` | `VoxelObjTable` |
| `Messags` | `MsgTable` |
| `Mnums_` | `PrintOrdered` |
| `Mesag` | `FindMessage` |
| `Tbuf` | `TextBuf` |
| `Print` | `PrintText` |
| `Prntnum` | `PrintNumber` |
| `Scroll` | `ScrollText` |
| `Stk5` | `ScrollSavedSp` |
| `Rst10` | `PrintChar` |
| `Cord` | `CursorX` |
| `Pricel` | `DrawSight` |
| `Mpricel` | `MoveSight` |
| `Timer` | `UpdateTimer` |
| `Sfxa` | `SfxChannelA` |
| `Sfxb` | `SfxChannelB` |
| `Sfxn` | `SfxNoise` |
| `Roka` | `SfxRocket` |
| `Eff13` | `SfxEff13` |
| `Eff19` | `SfxEff19` |
| `Eff1` | `SfxEff1` |
| `Eff14` | `SfxEff14` |
| `Eff2` | `SfxEff2` |
| `Eff0` | `SfxEff0` |
| `Eff11` | `SfxEff11` |
| `Eff21` | `SfxEff21` |
| `Datal` | `DrawGauge` |
| `Repanel` | `RedrawPanel` |
| `Datalin` | `DrawStatusLine` |
| `Fshild` | `DrawShield` |
| `Ffuel` | `DrawFuel` |
| `Ffire` | `DrawFire` |
| `Fspeed` | `DrawSpeed` |
| `INTEL` | `UpdateAI` |
| `MODES` | `AiModeTable` |
| `FREEFLY` | `AiFreeFly` |
| `GENS` | `GenerateSkimmers` |
| `GEND` | `GenerateTrees` |
| `FINDOBJ` | `FindObject` |
| `FNDFREE` | `FindFreeObject` |
| `SERVICE` | `ServiceInput` |
| `DIRECTZ` | `KeyState` |
| `MCOORD` | `MouseCoord` |
| `Mports` | `MousePorts` |
| `Servms` | `ReadMouse` |

## NXT.asm

| было | стало |
|--|--|
| `MULL` | `MulADE` |
| `Ren3d` | `Render3d` |
| `NXTO_` | `NextObject` |
| `Matrx` | `ObjectMatrix` |

## OBJX.asm

| было | стало |
|--|--|
| `DREVO1` | `ObjTree1` |
| `DREVO2` | `ObjTree2` |
| `DOM1` | `ObjHouse1` |
| `Sturm` | `ObjSturm` |
| `Trad` | `ObjTrad` |
| `Turi` | `ObjTuri` |
| `Istr` | `ObjIstr` |

## S3D.asm

| было | стало |
|--|--|
| `OUTAL2_` | `OutAll3d` |
| `Moveu` | `MoveObjects` |
| `Calcstp` | `CalcSteps` |
| `Korni` | `SquareRootTab` |
| `Vsline` | `VisibleLine` |
| `Shmtrx` | `ShipMatrix` |
| `Outline` | `DrawLine3d` |
| `Masklin` | `LineMask` |
| `Precord` | `SetCoordsByMove` |
| `Nulmove` | `ClearMoves` |
| `ADI3D_` | `ObjectIndexTab` |
| `Objcts` | `ObjectData` |

## VOXEL.asm

| было | стало |
|--|--|
| `HSCR` | `HIDDEN_SCREEN` |

## VSPRITE.asm

| было | стало |
|--|--|
| `OUTALL_` | `OutAll` |
| `Vox_` | `VoxDraw` |
| `LAND` | `DrawLand` |
| `SKY` | `DrawSky` |
| `NIGHT` | `DarkenSky` |
| `RLT_` | `TurnLeft` |
| `RRT_` | `TurnRight` |
| `TAKSPD_` | `SetSpeed` |
| `MOVING` | `ScrollBackground` |
| `CLER` | `ClearBuffer` |
| `NEWPSS_` | `NewPos2` |
| `NEWPOS_` | `NewPos` |
| `ED_` | `EmergencyExit` |

## XCLP.asm

| было | стало |
|--|--|
| `Clip` | `ClipPolygon` |
| `Mull` | `MulHLDE` |
| `CLIPLIN` | `ClipLine` |

## XR1.asm

| было | стало |
|--|--|
| `MULL` | `MulADE` |
| `Ren3d` | `Render3d` |
| `NXTO_` | `NextObject` |
| `Matrx` | `ObjectMatrix` |

## XR2.asm

| было | стало |
|--|--|
| `INIT_` | `Init3d` |
| `Polygon` | `DrawPolygonSpan` |
| `Renobj2` | `RenderObject2` |
| `Calcd` | `ProjectPoints` |
| `Drwpol` | `DrawPolygon` |
| `Drwpol2` | `DrawPolygonAlt` |
| `Drwlin` | `DrawLine` |
| `Drawl1` | `DrawLineHLDE` |
| `Vsmask` | `VisibilityMask` |
| `Vspoly` | `PolygonVisible` |

## XR2_lc.asm

| было | стало |
|--|--|
| `INIT` | `ENG3D_INIT` |
| `Polygon` | `DrawPolygonSpan` |
| `Renobj2` | `RenderObject2` |
| `Calcd` | `ProjectPoints` |
| `Drwpol` | `DrawPolygon` |
| `Drwpol2` | `DrawPolygonAlt` |
| `Drwlin` | `DrawLine` |
| `Drawl1` | `DrawLineHLDE` |
| `Vsmask` | `VisibilityMask` |
| `Vspoly` | `PolygonVisible` |
