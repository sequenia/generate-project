# ProjectGenerate

## Необходимые зависимости

- [`rbenv`](https://github.com/rbenv/rbenv) - менеджер версий ruby. Установка должна быть выполнена без команды `sudo`
- [`tuist`](https://docs.tuist.io/tutorial/get-started) - cредство по генерации проектов XCode по мета-описанию с помощью swift-файлов
- [`mint`](https://github.com/yonaskolb/Mint) - средство запуска swift-пакетов

## Старт
- Выполните команду `brew install sequenia/formulae/project-generate`
- Перейдите в директорию, где должен быть создан проект
- Выполните команду `project-generate gen`. Команда задаст несколько последовательных вопросов:
  - имя проекта (согласованное с project manager-ом имя проекта)
  - bundle id проекта (согласованный с project manager-ом идентификатор проекта)
  - минимальная поддерживаемая версия iOS (по умолчанию 14)
  - язык приложения (по умолчанию английский)
  - префикс задач YouTrack
  - идентификатор команды (по умолчанию задается идентификатор Sequenia)
  - имя компании-разработчка (по умолчанию задается Sequenia)
- Перейдите в директорию созданого проекта
- Выполните команду ` mint run tuist/tuist-up`
- Откройте в XCode `{NameProject}.xcworkspace`

## Troubleshooting
Если в процессе генерации проекта возникнет ошибка вида PermissionDenied, выполните последовательно команды
```
$ sudo chown -R 4{whoami} ~/.rbenv
$ sudo chown -R ${whoami} ~/.generamba
```
