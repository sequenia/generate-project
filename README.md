# ProjectGenerate

## Необходимые зависимости

- Установите [`rbenv`](https://github.com/rbenv/rbenv). Установка должна быть выполнена без команды `sudo` (`sudo chown -R {user} ~/.rbenv`)

- `tuist`. Средство по генерации проектов XCode по мета-описанию с помощью swift-файлов. Инструкцию можно найти [здесь](https://docs.tuist.io/tutorial/get-started)

## Старт
- Выполните команду `brew install sequenia/formulae/project-generate`
- Перейдите в директорию, где должен быть создан проект
- Выполните команду `project-generate gen`. Команда задаст несколько последовательных вопросов:
  - имя проекта (согласованное с project manager-ом имя проекта)
  - bundle id проекта (согласованный с project manager-ом идентификатор проекта)
  - дебаговый bundle id проекта. Если разработка сразу будет вестись под аккаунтом заказчика - шаг может быть пропущен, если же нет - должен быть указан bundle id формата  `<оригинальный bundle id>.dev`
  - префикс задач YouTrack
  - идентификатор команды (по умолчанию задается идентификатор Sequenia)
  - имя компании-разработчка (по умолчанию задается Sequenia)
- Перейдите в директорию созданого проекта
- Выполните команду `tuist up`
- Откройте в XCode `{NameProject}.xcworkspace`

## Общая структура проекта
Проект использует архитектуру VUPER, где:

- V - View, UI экрана
- U - UseCase, операция по загрузке/обработке данных
- P - Presenter, слой, отвечющий за бизнес-логику экрана
- E - Entiry, данные, отображаемые на экране
- R - Router, навигация экрана

Таблицы и коллекции построены на основе библиотеки [`SQDifferenceKit`](https://github.com/sequenia/SQDifferenceKit), надстройка над библиотекой [`DifferenceKit`](https://github.com/ra1028/DifferenceKit)

## Создание нового экрана приложения
Выполните в терминале одну из двух команд

Для обычного ViewController-а
```
bundle exec generamba gen ScreenName VuperModule_4.0
```

Для ViewController-а с таблицей
```
bundle exec generamba gen ScreenName VuperModuleTable_4.0
```

## Создание новой табличной ячейки
Выполните в терминале одну из двух команд

Для обычной табличной ячейки
```
bundle exec generamba gen CellName TableCell
```

Для табличной ячейки с встроенной в нее коллекцией
```
bundle exec generamba gen CellName TableCollectionCell
```

## Создание новой коллекционной ячейки
Выполните в терминале одну из двух команд

Для обычной коллекционной ячейки
```
bundle exec generamba gen CollectionCell TableCell
```

Для коллекционной ячейки с встроенной в нее коллекцией
```
bundle exec generamba gen CellName CollectionCollectionCell
```

