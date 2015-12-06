###Набор компонентов MGSoft

Автор:		Михаил Григорьев
E-Mail: 	sleuthhound@gmail.com
ICQ: 		161867489
WWW:		http://www.programs74.ru
Лицензия:	GNU GPLv3

Системные требования:
---------------------

ОС:		Win2000/XP/2003/Vista/7/8
Среда Delphi:	RAD Studio XE8 (возможна сборка компонентов под всю линейку Delphi от версии 7 до XE8)


Состав компонентов:
-------------------

TMGSAPI				- VCL компонент для синтеза речи через Microsoft SAPI;
TMGGoogleTTS			- VCL компонент для синтеза речи через Google Text-to-Speech;
TMGYandexTTS			- VCL компонент для синтеза речи через Yandex Text-to-Speech;
TMGNuanceTTS			- VCL компонент для синтеза речи через Nuance Text-to-Speech;
TMGISpeechTTS			- VCL компонент для синтеза речи через iSpeech Text-to-Speech;
TMGTessOCR			- VCL компонент для распознавания текста используя библиотеку TesseractOCR;
TMGOSInfo			- VCL компонент для получения информации о версии ОС, разрядности, версии Internet Explorer и др.;
TMGButtonGroup			- VCL компонент для организации группы кнопок;
TMGHotKeyManager		- VCL компонент для регистрации глобальных горячих клавиш в ОС;
TMGSMTP				- VCL компонент для отправки почты по SMTP (поддерживает TLS и SSL);
TMGWindowHook			- VCL компонент предназначен для обработки оконных сообщений, приходящих элементам - наследникам TWinControl (которые являются окнами в смысле Windows), без создания компоненты - наследника;
TMGFormStorage			- VCL компонент для сохранения и восстанавления размеров и положения формы, а так же различных контролов на ней;
TMGFormPlacement		- VCL компонент для сохранения и восстанавления размеров и положения формы;
TMGThread			- VCL компонент для организации потоков;
TMGTrayIcon			- VCL компонент для сворачивания программы в систрей;
TMGTextReaderA,TMGTextReaderW 	- nonVLC компонент для чтения больших файлов методом отражения файла с диска в память;
TMGThreadStringList		- nonVLC компонент, поточный StringList;


Возможности компонентов по синтезу речи:
----------------------------------------

TMGSAPI 	- Синтез речи через Microsoft SAPI5 (офлайн синтез речи, при использовании бесплатного синтезатора RHVoice возможен очень качественный синтез речи на русском и английском языке (мужской и женский голос)).
TMGGoogleTTS 	- Синтез речи через Google Text-to-Speech API (онлайн синтез речи на 17 языках - Арабский, Датский, Немецкий, Греческий, Английский, Испанский, Финский, Французский, Итальянский, Японский, Корейский, Нидерландский (Голландский), Польский, Португальский, Русский, Турецкий, Китайский)
TMGYandexTTS  	- Синтез речи через Yandex Text-to-Speech API (онлайн синтез речи на 10 языках - Немецкий, Английский, Испанский, Французский, Итальянский, Нидерландский (Голландский), Польский, Португальский, Русский, Турецкий)
TMGISpeechTTS	- Синтез речи через iSpeech Text-to-Speech API (онлайн синтез речи (платный сервис) на 28 языках - есть женские и мужские голоса, подробности http://www.ispeech.org)
TMGNuanceTTS	- Синтез речи через Nuance Text-to-Speech API (онлайн синтез речи (платный сервис) >60 языков - есть женские и мужские голоса, подробности http://nuancemobiledeveloper.com)


Возможности компонентов по распознаванию текста:
------------------------------------------------

TMGTessOCR	- Распознавания текста используя библиотеку TesseractOCR, возможно распознавание печатного текста более чем на 100 языках.
		  Компонент TMGTessOCR предоставляет базовый функционал по распознаванию текста из файлов форматов Tiff, Png, Gif, Jpeg;
		  Возможно дописывание функционала под заказ.
		  Для распознавания текста в каталоге Bin/tessdata должны быть файлы нужных языков из репозитария https://github.com/tesseract-ocr/tessdata


Установка компонентов для RAD Studio XE8:
-----------------------------------------

1. Запустите RAD Studio XE8, установите компоненты через меню Component -> Install Packages... -> Add..., выберите файл MGSoft\Bin\Delphi22\Win32\dclMGSoft220.bpl
2. Добавте папку MGSoft\Lib\Delphi22\Win32\ в список библиотек Library path через меню Tools -> Options... -> Environment options -> Delphi Options -> Library для платформы 32-bit Windows
3. Добавте папку MGSoft\Lib\Delphi22\Win64\ в список библиотек Library path через меню Tools -> Options... -> Environment options -> Delphi Options -> Library для платформы 64-bit Windows
4. Перезапустите RAD Studio XE8
5. Можете использовать компоненты MGSoft и открыть примеры MGSoft\Demos\MGSoftDemo.groupproj


Удаление компонентов из RAD Studio XE8:
---------------------------------------

1. Запустите RAD Studio XE8, удалите компоненты через меню Component -> Install Packages... выберите в списке MGSoft Designtime Library и нажмите Remove
2. Удалите путь до компонентов MGSoft из список библиотек Library path через меню Tools -> Options... -> Environment options -> Delphi Options -> Library для платформы 32-bit Windows
3. Удалите путь до компонентов MGSoft из список библиотек Library path через меню Tools -> Options... -> Environment options -> Delphi Options -> Library для платформы 64-bit Windows
4. Закройте RAD Studio XE8
5. Удалите папку MGSoft

Исходный код компонентов:
-------------------------

Исходный код компонентов TMGSAPI, TMGGoogleTTS, TMGYandexTTS, TMGISpeechTTS, TMGNuanceTTS, TMGTessOCR, TMGOSInfo, TMGSMTP распространяется только после его покупки.
Стоимость исходного кода каждого компонента 1000 рублей или $20. При покупке исходного кода 3 и более компонентов предоставляется скидка 10%.
Исходный код остальных компонентов (TMGButtonGroup, TMGHotKeyManager, TMGWindowHook, TMGFormStorage, TMGFormPlacement, TMGThread, TMGTrayIcon, TMGTextReaderA, TMGTextReaderW, TMGThreadStringList) распростряняется по запросу бесплатно.


(c) 2014-2015 by Mikhail Grigorev
