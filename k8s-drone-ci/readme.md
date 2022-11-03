расшифровка видео https://www.youtube.com/watch?v=myCcJJ_Fk10

Introduction to Drone CI: Kubernetes DevOps CI/CD

Мы будем говорить о Drone CI. 
Что такое Drone CI? Drone CI – это автоматизированная платформа непрерывной доставки на основе контейнеров, где мы можем легко определять конвейеры как код. 
Способ, в котором это работает, заключается в том, что вы подключаете его к любому поставщику управлениями версиями, к такому, как GitHub, GitLab, Bitbucket и многим другим. 
Drone основан на контейнерах, поэтому технически он может работать на любой платформе. И вы можете запускать все свои этапы конвейеров в контейнере Docker. Так что технически вы можете компилировать и запускать любой тип языка. 
Мы пишем конвейеры в упрощенной, читаемой форме с множеством возможностей плагинов. У него, действительно, классная настройка. У него простая конфигурация.
Мы изолируем наши этапы сборки в контейнерах Docker, поэтому нам не нужно устанавливать случайные вещи на наших серверах сборки. Он также хорошо масштабируется, особенно в Kubernetes. Так что без лишних слов давайте сразу приступим и установим это. 
Итак, один street thing, один street Drone CI интегрируется с другими различными поставщиками облачного управления версиями. 
Мы собираемся взглянуть на GitHub.
Первое, что нам понадобится, это Drone-сервер. И вы можете развернуть его в любой инфраструктуре. И нам нужно дать серверу Drone общедоступный IP-адрес. 
Мы собираемся развернуть службу Kubernetes, чтобы выставить это на всеобщее обозрение. Ему понадобится IP-адрес. 
Чтобы это сделать, вы можете либо создать балансировщик нагрузки сервисного типа в Kubernetes, либо использовать порт узла. 
Что я собираюсь сделать в этом видео? Я предпочитаю показывать это с помощью входов в Kubernetes. Я собираюсь поставить перед этим ingress. И причина этого в том, что я могу поставить перед ним сертификаты TLS и SSL, чтобы я мог защитить его и сделать его безопасным. 
Нам нужно зайти на GitHub. Мы должны зарегистрировать приложение OAuth. OAuth позволяет пользователю проходить аутентификацию. 
Сервер Drone использует множество форм аутентификации, которые предоставляет сервер управления версиями. Значит, мы должны зарегистрировать приложение OAuth. 
Что произойдет, когда GitHub обнаружит коммиты? GitHub запустит webhook на наш сервер Drone. Так что, когда происходит сборка или происходит запрос на фиксацию или извлечение, GitHub сообщает нашему серверу через webhook. Задание будет поставлено в очередь на сервере Drone. Теперь сервер Drone ничего не может сделать сам по себе. 
Для того чтобы выполнить какое-либо конвейерное действие, нам нужно установить runner. Сейчас доступно много типов runners. Мы собираемся взглянуть на Kubernetes runner. 
Что делает Kubernetes runner? Он взаимодействует с API Kubernetes и может создавать модули на основе заданий, которые он пытается запустить. Так что, если кто-то проверяет код на GitHub или запускает наш триггер, GitHub использует webhook и отправляет запрос на наш сервер Drone. Он выстраивает конвейер в очередь вот здесь и отправляет его нашему runner. 
Эта аутентификация выполняется с помощью общего секрета. Поэтому мы создадим общий секрет, чтобы эти два компонента могли доверять друг другу. 
Что происходит потом? Runner Kubernetes вызовет API Kubernetes. И он создаст модуль для запуска нашего конвейера. В зависимости от того, сколько у нас шагов и насколько сложен наш конвейер, этот runner может создать несколько модулей. Прелесть этого конвейерного рабочего процесса заключается в том, что все эти задания выполняются как контейнеры Docker. И когда конвейер будет завершен, Kubernetes runner уничтожит модули. 
Итак, начиная слева направо, мы собираемся настроить вход в нашу службу, чтобы получить общедоступный AP-адрес или запись имени хоста, который мы можем использовать. 
Перейдем на GitHub и настроим приложение OAuth и подключим его к этому IP-адресу. А затем мы развернем сервер Drone, а также Kubernetes runner. 
Это исходный код YouTube-серии Docker development. Это на GitHub. Мы собираемся взглянуть на папку Drone CI. 
Прежде чем мы начнем, Drone CI нуждается в базе данных в качестве серверной части для хранения своих данных. 
Теперь команда Drone CI рекомендует Postgres. Так что, если вы работаете в облаке и у вас есть доступ к Postgres, я настоятельно рекомендую использовать это. Но в этой демонстрации я просто собираюсь придерживаться версии Kubernetes. 
Я собираюсь развернуть карту конфигурации с моим именем базы данных Postgres. Я просто введу туда имя пользователя и пароль. Я рекомендую использовать секрет. И тогда у нас есть набор с сохранением состояний из одной копии. 
Мы используем Postgres 10.4. И мы собираемся предоставить эту базу данных нашему серверу Drone, используя кластерный IP сервиса. Это означает, что наш сервис сможет взаимодействовать с базой данных Postgres и хранить там все свои данные. 
Итак, я запускаю одноузловой кластерный Kubernetes на digital SSL. Я собираюсь сказать, что kubectl создает пространство имен. И собираюсь создать пространство имен под названием Drone. Именно там мы будем хранить все наши ресурсы. 
А потом я собираюсь сказать «kubectl –n Drone». Я собираюсь подать заявку на нашу папку. 
Теперь мы пойдем дальше и создадим нашу базу данных. А потом мы можем приступить к развертыванию сервера. 
Когда у нас есть один экземпляр Postgres, мы собираемся действовать дальше. 
Посмотрите на сервер. На сервере у нас есть необходимый файл yml.
Первое, что нам нужно сделать, это получить конечную точку. Мы собираемся взглянуть на службу. 
Мы собираемся подать заявку в том же пространстве имен. Мы собираемся применить служебную папку сервера Drone. Это позволит создать сервис. Если мы это сделаем, kubectl получит обслуживание. 
Вы увидите в моем кластере, что я не собираюсь получать для этого никакого внешнего IP-адреса. Так что если вы взглянете на сервис yml, то увидите, что я установил кластерный IP, потому что я собираюсь экспортировать свой сервер Drone, используя ingress.
Если вы не собираетесь использовать ingress, не стесняйтесь менять этот кластерный IP-адрес либо на балансировщик нагрузки, либо на порт узла. Так что вы можете получить внешний IP-адрес ниже, который вы можете использовать для настройки аутентификации OAuth. 
Чтобы выставить вместо использования порта узла или сервера балансировки нагрузки, я собираюсь использовать ingress. 
Итак, у меня здесь есть ingress. Я просто вызываю Drone сервер. Я управляю контроллером входа трафика. Я собираюсь предоставить доступ к нему через TLS HTTP и я создал пользовательский домен под названием Drone на своем веб-сайте. И он будет указывать на ту службу, которую мы только что создали. 
Я собираюсь сказать, что kubectl применяет f. И я собираюсь применить сервер. Мы собираемся применить входной yml. Так что вместо использования общедоступного IP-адреса я собираюсь использовать это имя хоста, а затем настроить приложение OAuth таким образом.
Теперь, чтобы настроить аутентификацию, вам нужно настроить на GitHub. Нужно зайти в свою учетную запись и перейти в настройки, а затем нажать на настройки разработчика. И перейти в приложение в OAuth.
Вы видите, что у меня уже создано приложение для Drone, поэтому вам нужно нажать «Создать приложение OAuth». Затем вы можете использовать слово «Drone». И далее нужно ввести url-адрес домашней страницы или свой общедоступный IP-адрес, который вы создали. 
Если вы используете балансировщик нагрузки типа сервис или порт узла, вы получите либо имя хоста, либо IP-адрес в зависимости от вашего облачного провайдера. 
Введите это здесь. А затем вам нужна конечная точка входа в систему. Вам нужно убедиться, что вы поместили то же самое здесь на url обратного вызова. Но у вас есть логин/. Это будет в основной настройке сервера Drone и настройке GitHub для проверки подлинности. 
Пользователи, которые заходят по url-адресу вашего сервера Drone, будут проходить аутентификацию через GitHub. 
А потом вам нужно зарегистрировать свое заявление. Сделав это, вы получите идентификатор клиента GitHub и секрет клиента GitHub. 
Далее вам надо сохранить это, чтобы мы могли создать учетные данные, позволяющие аутентификации работать. 
Посмотрим на документацию. Мы создали приложение OAuth. Мы прошли через этот процесс. И в основном у нас есть идентификатор клиента и секрет клиента для GitHub, который готовый к работе. 
Следующее, что нам понадобится, это общий секрет. Это очень просто. Я собираюсь использовать Docker. Я собираюсь использовать быстрый debian контейнер. 
Затем я собираюсь использовать openssl для создания быстрого общего секрета. Я просто скажу: «apt-get updade» и «apt-get install –y openssl».
Как только у меня появится утилита openssl, я просто скажу «openssl» и сгенерирую случайный шестнадцатеричный символ. 
Вот и все. Это наш общий секрет, который мы собираемся использовать. 
Что я здесь сделал? Я создал секретный пример Kubernetes для вашего использования. 
Далее мы собираемся определить аутентификатор клиента GitHub. Вам нужно взять base64 из того значения, которое предоставил вам GitHub. Тогда вам нужна база с секретом клиента. А затем нужно положить это сюда. 
Потом вам нужно взять этот общий секрет, который мы создали внизу, и поместить его в качестве секрета RPC. Это позволит runner и серверу общаться друг с другом и проходить аутентификацию. 
Далее вам нужно поместить сюда свою строку подключения к базе данных Postgres. 
Я просто привел здесь несколько примеров. Вот как выглядел бы мой. 
Есть еще несколько вещей, которые мы должны добавить. 
Хост сервера важен, потому что это точка Drone. Какими бы ни были ваш IP-адрес или имя хоста, которые вы зарегистрировали, вы должны указать это здесь. А потом вам нужно создать пользователя-администратора. Это пользователь GitHub.
Вы можете видеть, что я ввел имя пользователя. А затем моего пользователя GitHub, а затем сказал: «admin: true». Это позволит нам войти и настроить репозиторий, как только мы запустим эту штуку. 
Если вы хотите знать, как искать секреты, чтобы заполнить секретный yml, то это очень просто. Просто создайте что-то типа контейнера Linux, чтобы у вас был доступ к инструменту base64. И все, что вам нужно сделать, это просто повторить значение. Это большой секрет. 
Повторите этот канал или echo. А затем убедитесь, что вы поставили «минус», чтобы предотвратить проблемы с новой линией. Затем передайте это в base64 –w. Это попытка избежать обертывания линий. 
Мы это делаем. Мы берем это значение вплоть до знаков равенства и вставляем его в наш файл yml. Это просто пример. 
Когда я заполнил свой секретный yml, я просто скажу kubectl’у «apply» и применю секретный yml. Теперь у нас есть наш пункт въезда в трафик, который готовый к работе. 
У нас есть готовая конфигурация. И нам нужно приступить к развертыванию сервера. 
Давайте взглянем на сервер. Yml – это базовое развертывание в Kubernetes. Это одна копия. Мы также даем ему название Drone-server. Это образ, который мы хотим запустить, поэтому версия, которую мы запускаем, это 1.6.5. 
Мы открываем порт 80 и порт 443, а остальное говорит само за себя. 
Сервер Drone использует переменные окружения configs так, что в основном это просто переменные окружения для его настройки.
Если вы перейдете в Doc’s Drone и нажмете на ссылку, то увидите огромный список переменных среды. Все опции довольно хорошо задокументированы. И это действительно упрощает настройку. 
Я упростил задачу, подключив все эти переменные среды к тому секрету, который мы только что применили. 
Дальше я просто скажу: «kubectl –n Drone apply». Я собираюсь применить файл развертывания, который будет использоваться для создания нашего сервера. 
Прежде чем вы двинетесь дальше, вам нужно дважды проверить – все ли работает.
Вы делаете get pods и видите, что у вас есть Drone сервер, а также запущенная база данных. И вы хотите убедиться, что этот сервер действительно может взаимодействовать с базой данных. 
Первое, что вам нужно сделать, это сделать logs … в этом модуле и убедиться, что все выглядит хорошо. 
Итак, все загружено. Учетная запись создана, все запущено. Все готово к работе. Вам нужно убедиться, что он запускает этот планировщик прямо сейчас.
Как я уже говорил ранее, сервер не может много сделать без запуска runner, потому что сервер ждет, пока задания встанут в очередь. 
Нам нужно определить runner. Мы собираемся взглянуть на runners. Вы можете сделать это на docs.Drone.io. Взгляните на обзор. Есть куча runners, которые вы можете определить. 
Мы собираемся использовать Kubernetes, потому что он достаточно масштабируемый. 
Если вы нажмете на это, они в основном дадут вам несколько советов об известных проблемах с примерами. Если вы собираетесь это установить, они дадут вам некоторую конфигурацию. 
Итак, мы собираемся определить секрет. Это наш общий секрет, который мы только что создали. По сути, позвольте runner и серверу общаться, чтобы они прошли весь процесс установки. 
Нам нужно определить role bac, чтобы установщик Kubernetes мог фактически взаимодействовать с IP сервером для создания заданий для конвейеров, которые мы собираемся запускать.  
Теперь давайте посмотрим на папку Runner. Если мы нажмем на эту папку, у нас будет rbac. Глянем на rbac. Это очень просто. Есть только роль, а затем привязка к роли. 
Итак, мы собираемся запустить этот runner от имени учетной записи службы, которая привязана к этому набору разрешений. Так что это разрешение на очень высоком уровне позволяет Kubernetes runner создавать модули и управлять модулями внутри пространства имен Drone. Это позволит исполнителю ставить задания в очередь пространства имен Drone и запускать наши пользовательские конвейеры. 
Без дальнейших церемоний мы собираемся применить Drone runner. В папке с Drone мы скажем: «kubectl –n Drone apply». Мы собираемся применить правило rbac. 
Теперь давайте посмотрим на Drone runner. Drone runner – это еще одно развертывание Kubernetes с одной репликой. И оно использует точно такие же типы конфигурации. Так что мы должны просто быстро просмотреть их. 
У нас есть пространство имен по умолчанию под названием «Drone». Мы хотим, чтобы runner использовал пространство имен Drone, а не пространство имен по умолчанию. Мы также даем ему служебную учетную запись для использования. Это значит, что он будет использовать учетную запись службы Drone runner. 
Обратите внимание, что у нас также указана учетная запись службы. Они должны соответствовать. А затем мы определяем хост, который наш Kubernetes runner будет использования для общения с сервером, чтобы он мог общаться внутри. Это не обязательно должно проходить через общедоступный IP-адрес.
А затем наш общий секрет, который мы определили как секрет, можем использовать повторно. И у нас есть учетная запись службы. Так что это очень просто. 
Я собираюсь пойти дальше и просто применить этот файл. 
Теперь у нас есть аутентификация на GitHub. У нас есть наша конечная точка. У нас есть Drone-сервер. И у нас есть наш Kubernetes runner. 
Когда Drone сервер запущен и работает, давайте посмотрим, что мы можем сделать. Тут-то и становится по-настоящему интересно. 
Мы отправляемся к нашему веб-сайту Drone. Так что либо ваша входная точка, либо общедоступный IP-адрес попросят вас пройти аутентификацию с помощью GitHub.
Вы видите, как я аутентифицирован. И первое, что он делает, это фактически сканирует все ваши репозитории, к которым у вас есть доступ, чтобы вы могли видеть, что у меня есть серия Docker development на YouTube здесь. Если я нажму на это, вы увидите, что нам нужно будет активировать его. 
Теперь посмотрите, что это делает. Если мы перейдем к нашему репозиторию и нажмем на настройки, и нажмем на Webhooks, то вы увидите, что у меня нет определенных webhooks. Как только я нажму на этого парня и скажу «активировать», что это будет делать? Это вызовет несколько вызовов API на GitHub. Он пойдет и подключит наш репозиторий. Если мы перейдем к webhook здесь, мы обновим это. 
Мы видим, что он уже настроен, так что мы можем определить триггеры. Я думаю, что по умолчанию используется значение create, delete. Здесь есть пара вещей. 
Мы можем отредактировать это, чтобы мы могли видеть, что было создано в этом репозицитории. Есть куча вещей, которые мы можем сделать с точки зрения событий, которые мы хотим использовать. Так что для сборок вы вероятно просто хотите делать коммиты нажатий и тому подобное, но это дает вам гибкость. 
А затем мы возвращаемся к серии Docker development на YouTube. Я хочу настроить его как надежное хранилище, а потом нажать кнопку «Сохранить». 
Здесь есть кое-что классное, например, секреты. Вы можете добавлять секреты, чтобы секреты были введены в ваш конвейер. Вы также можете выполнять задания cron. И да, это довольно круто. Вы тоже можете планировать эти трубопроводы. 
Теперь давайте взглянем на наш конвейер. Если я сверну все эти папки, и мы посмотрим на папку Drone CI, у меня будет файл Drone.yml. Это мой конвейер Kubernetes. И это базовый тип конвейера для Kubernetes, где мы просто будем выполнять команды Docker. Так что мы можем делать такие вещи, как Docker login, Docker build, Docker push, потому что все основано на контейнерах, поэтому нам не нужно ничего устанавливать на наш сервер сборки. Таким образом, мы можем избежать всей этой боли. 
Чтобы вы могли видеть, у нас есть шаг, который называется build-push. Мы используем образ Docker: dint. А затем мы создаем для него некоторые среды. 
Вы можете видеть, что эта возможность добавлять секреты. 
Я собираюсь создать секрет под названием Docker_user и Docker_password, который позволит мне вход в Docker. Это так вы вводите секреты по конвейеру. 
А потом я собираюсь скомпилировать контейнер goland. 
Я собираюсь запустить сборку Docker на образе goland. Я собираюсь пометить это, а затем я собираюсь сделать Docker push. Так что это очень простой пример, но так же и очень мощный для производственных систем CI/CD. 
Чтобы вы могли видеть, я перешел к секретам и добавил имя пользователя и логин Docker, чтобы они соответствовали секрету, который у нас есть здесь. 
Есть еще одна вещь, которую мы должны сделать. Мы должны указать серверу Drone на файл Drone.yml, чтобы он мог найти наш конвейер. Чтобы это сделать, я просто укажу Drone-ci/drone.yml. Это должно сработать. Это должно быть правильным местом. Я сохраню, и мы увидим, что это обновлено. 
А как же нам теперь это запустить? Я собираюсь добавить сюда еще одного персонажа, чтобы вызвать изменения в нашем конвейере. А потом я собираюсь сохранить это. Мы увидим, как начнется конвейер. И это начнется довольно быстро. 
Я только что добавил туда hash. Чтобы просто внести изменения, я щелкну по этому файлу. 
Теперь я проверю это в системе управления версиями. Просто проверю изменения. Давайте передадим это в наш филиал. И это произойдет довольно быстро. Смотрите, что сейчас произойдет. GitHub запустит webhook на наш сервер. Мы видим, что наш сервер находится прямо здесь. Он уже продвинулся вперед, обнаружив это изменение. Это пошло вперед и поставило работу в очередь. Так что, если я нажму на это, мы увидим, что все запущено. Здесь уже запущена команда Docker. 
Мы можем пойти дальше и нажать на это. Наш шаг выглядит так, как будто он занят. Это сон. Это сон, который мы видим справа, слева он выполняет вход в систему Docker. Это делает сборку Docker. Это все происходит. Docker build. Похоже, все происходит именно так. 
Мы посмотрим на пространство имен Drone, чтобы увидеть, что происходит. Если мы скажем: «получить капсулы», мы должны быть в состоянии увидеть, что наш Drone runner создал капсулу. Значит, все эти конвейерные штуки, которые мы здесь видим, запущены внутри этой капсулы. 
Мы видим, что наша сборка работает. Значит, это произошло очень быстро. Мы видим, что он прошел весь этап сборки Docker и построил наш контейнер. 
Это было небольшое приложение на Go, так что его создание не заняло много времени. Это пошло дальше и переместило наш образ Docker в Docker hub. Это очень простой контейнерный конвейер. Это очень мощная система CI/CD. 
Я думаю, что вы можете сделать довольно много из этого. Это очень похоже на действие GitHub. Он просто использует вашу собственную инфраструктуру для планирования и выполнения развертывания автоматизации. Это Drone CI, который представляет собой встроенную в контейнер автоматизацию и платформу CI/CD.