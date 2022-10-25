## Моделирование с помощью Julia
Данный пакет добавляет функцию, которая считает и рисует работу PI контроллера с задаными параметрами (конечная точка, время, пропорциональная составляющая P, интегрирующая составляющая I) в файл типа .png, тип параметров должен обязательно быть (int, float, float, float).
После установки через Makefile julia, требуется находиться в папке AQM_PI_RUDN, далее запустить Julia в консоли (команда 'julia') и ввести команды приведенные ниже для установки требующихся пакетов внутри Julia и самого пакета AQM_PI:
```
import Pkg
Pkg.add("ModelingToolkit")
Pkg.add("DifferentialEquations")
Pkg.add("Plots")
include("Analitical/AQM_PI/src/Main.jl")
```
При повторном запуске Julia, достаточно воспользоваться только командой ниже, находясь в директории AQM_PI_RUDN:
```
include("Analitical/AQM_PI/src/Main.jl")
``` 
После установки данных пакетов можно приступать к работе с пакетом AQM_PI.
Вызов команды осуществляется как напримере ниже:
```
Main.AQM_PI.AQM_PI_Sol(100, 100.0, 1.0, 1.0)
```
После исполнения команды, будет создан файл plot.png в папке AQM_PI_RUDN.
Чтобы при повторном вызове не потерять предыдущий результат, рекомендуется переименовать файл или перенести его.