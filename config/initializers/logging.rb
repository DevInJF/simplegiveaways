require 'logging'

Logging.color_scheme('bright',
  levels: {
    info: :green,
    warn: :yellow,
    error: :red,
    fatal: [:white, :on_red]
  },
  date: :blue,
  logger: :cyan,
  message: :magenta
)

Logging.appenders.stdout(
  'stdout',
  layout: Logging.layouts.pattern(
    pattern: '[%d] %-5l %c: %m\n',
    color_scheme: 'bright'
  )
)

Logging.appenders.file(
  'log/development/debug.log',
  layout: Logging.layouts.pattern(
    pattern: '[%d] %-5l %c: %m\n',
    color_scheme: 'bright'
  )
)

$log = Logging.logger['SGA']
$log.add_appenders(
    Logging.appenders.stdout,
    Logging.appenders.file("#{Rails.root}/log/development/debug.log")
)
