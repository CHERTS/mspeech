###Набор компонентов MGSoft для Delphi

[In English / По-английски](README.md)

Автор:		Михаил Григорьев<br>
E-Mail: 	sleuthhound@gmail.com<br>
ICQ: 		161867489<br>
WWW:		http://www.programs74.ru<br>
Лицензия:	GNU GPLv3<br>

####Системные требования:

ОС:		Win2000/XP/2003/Vista/7/8<br>
Среда Delphi:	RAD Studio XE5,XE8 (возможна сборка компонентов под всю линейку Delphi от версии 7 до XE8)<br>


####Состав компонентов:

TMGSAPI				- VCL компонент для синтеза речи через Microsoft SAPI;<br>
TMGGoogleTTS			- VCL компонент для синтеза речи через Google Text-to-Speech;<br>
TMGYandexTTS			- VCL компонент для синтеза речи через Yandex Text-to-Speech;<br>
TMGNuanceTTS			- VCL компонент для синтеза речи через Nuance Text-to-Speech;<br>
TMGISpeechTTS			- VCL компонент для синтеза речи через iSpeech Text-to-Speech;<br>
TMGTessOCR			- VCL компонент для распознавания текста используя библиотеку TesseractOCR;<br>
TMGOSInfo			- VCL компонент для получения информации о версии ОС, разрядности, версии Internet Explorer и др.;<br>
TMGButtonGroup			- VCL компонент для организации группы кнопок;<br>
TMGHotKeyManager		- VCL компонент для регистрации глобальных горячих клавиш в ОС;<br>
TMGSMTP				- VCL компонент для отправки почты по SMTP (поддерживает TLS и SSL);<br>
TMGWindowHook			- VCL компонент предназначен для обработки оконных сообщений, приходящих элементам - наследникам TWinControl (которые являются окнами в смысле Windows), без создания компоненты - наследника;<br>
TMGFormStorage			- VCL компонент для сохранения и восстанавления размеров и положения формы, а так же различных контролов на ней;<br>
TMGFormPlacement		- VCL компонент для сохранения и восстанавления размеров и положения формы;<br>
TMGThread			- VCL компонент для организации потоков;<br>
TMGTrayIcon			- VCL компонент для сворачивания программы в систрей;<br>
TMGTextReaderA,TMGTextReaderW 	- nonVLC компонент для чтения больших файлов методом отражения файла с диска в память;<br>
TMGThreadStringList		- nonVLC компонент, поточный StringList;<br>


####Возможности компонентов по синтезу речи:

TMGSAPI 	- Синтез речи через Microsoft SAPI5 (офлайн синтез речи, при использовании бесплатного синтезатора RHVoice возможен очень качественный синтез речи на русском и английском языке (мужской и женский голос)).<br>
TMGGoogleTTS 	- Синтез речи через Google Text-to-Speech API (онлайн синтез речи на 17 языках - Арабский, Датский, Немецкий, Греческий, Английский, Испанский, Финский, Французский, Итальянский, Японский, Корейский, Нидерландский (Голландский), Польский, Португальский, Русский, Турецкий, Китайский)<br>
TMGYandexTTS  	- Синтез речи через Yandex Text-to-Speech API (онлайн синтез речи на 10 языках - Немецкий, Английский, Испанский, Французский, Итальянский, Нидерландский (Голландский), Польский, Португальский, Русский, Турецкий)<br>
TMGISpeechTTS	- Синтез речи через iSpeech Text-to-Speech API (онлайн синтез речи (платный сервис) на 28 языках - есть женские и мужские голоса, подробности http://www.ispeech.org)<br>
TMGNuanceTTS	- Синтез речи через Nuance Text-to-Speech API (онлайн синтез речи (платный сервис) >60 языков - есть женские и мужские голоса, подробности http://nuancemobiledeveloper.com)<br>


####Возможности компонентов по распознаванию текста:

TMGTessOCR	- Распознавания текста используя библиотеку TesseractOCR, возможно распознавание печатного текста более чем на 100 языках.<br>
		  Компонент TMGTessOCR предоставляет базовый функционал по распознаванию текста из файлов форматов Tiff, Png, Gif, Jpeg;<br>
		  Возможно дописывание функционала под заказ.<br>
		  Для распознавания текста в каталоге Bin/tessdata должны быть файлы нужных языков из репозитария https://github.com/tesseract-ocr/tessdata<br>


####Установка компонентов для RAD Studio XE8:

1. Содержимое папки MGSoft\Lib\Delphi22\Win32\ скопируйте в C:\Users\All Users\Documents\Embarcadero\Studio\16.0\Bpl\
2. Содержимое папки MGSoft\Lib\Delphi22\Win64\ скопируйте в C:\Users\All Users\Documents\Embarcadero\Studio\16.0\Bpl\Win64
3. Запустите RAD Studio XE8, установите компоненты через меню Component -> Install Packages... -> Add..., выберите файл C:\Users\All Users\Documents\Embarcadero\Studio\16.0\Bpl\dclMGSoft220.bpl<br>
4. Добавте папку MGSoft\Lib\Delphi22\Win32\ в список библиотек Library path через меню Tools -> Options... -> Environment options -> Delphi Options -> Library для платформы 32-bit Windows<br>
5. Добавте папку MGSoft\Lib\Delphi22\Win64\ в список библиотек Library path через меню Tools -> Options... -> Environment options -> Delphi Options -> Library для платформы 64-bit Windows<br>
6. Перезапустите RAD Studio XE8<br>
7. Можете использовать компоненты MGSoft и открыть примеры MGSoft\Demos\MGSoftDemo.groupproj<br>


####Удаление компонентов из RAD Studio XE8:

1. Запустите RAD Studio XE8, удалите компоненты через меню Component -> Install Packages... выберите в списке MGSoft Designtime Library и нажмите Remove<br>
2. Удалите путь до компонентов MGSoft из список библиотек Library path через меню Tools -> Options... -> Environment options -> Delphi Options -> Library для платформы 32-bit Windows<br>
3. Удалите путь до компонентов MGSoft из список библиотек Library path через меню Tools -> Options... -> Environment options -> Delphi Options -> Library для платформы 64-bit Windows<br>
4. Закройте RAD Studio XE8<br>
5. Удалите папку MGSoft<br>

####Исходный код компонентов:

Исходный код компонентов TMGSAPI, TMGGoogleTTS, TMGYandexTTS, TMGISpeechTTS, TMGNuanceTTS, TMGTessOCR, TMGOSInfo, TMGSMTP распространяется только после его покупки.<br>
Стоимость исходного кода каждого компонента 1000 рублей или $20. При покупке исходного кода 3 и более компонентов предоставляется скидка 10%.<br>
Исходный код остальных компонентов (TMGButtonGroup, TMGHotKeyManager, TMGWindowHook, TMGFormStorage, TMGFormPlacement, TMGThread, TMGTrayIcon, TMGTextReaderA, TMGTextReaderW, TMGThreadStringList) распространяется по запросу бесплатно.<br>


(c) 2014-2016 by Mikhail Grigorev
