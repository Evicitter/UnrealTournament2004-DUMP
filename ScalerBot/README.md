## Описание

Экспериментальный мутатор изменяющий размер персонажей ботов и игрока в игре UT2004, т.к. в отличие от UT2003 боты в игре кажутся мелкими. Последняя редакция 02 декабря 2006 года.

## Установка

Добавить в UT2004.ini -> [Editor.EditorEngine]. EditPackages=ScalerBot<br>
НАПРИМЕР:<br>
EditPackages=UTV2004c<br>
EditPackages=UTV2004s<br>
**EditPackages=ScalerBot**<br>
CutdownPackages=Core<br>
CutdownPackages=Editor<br>
<br>
Запустить "System\UCC.exe make"<br>

## UNDONE

После приседания бота или игрока, персонаж начинает проваливаться в землю. Неправильно восстанавливается переменная *CollisionHeight* после *CrouchHeight* в классе *xPawn*.

