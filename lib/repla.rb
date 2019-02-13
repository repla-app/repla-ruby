# Repla
module Repla
  require_relative 'repla/lib/constants'
  require_relative 'repla/lib/window'
  require_relative 'repla/lib/controller'
  require_relative 'repla/lib/view'
  require_relative 'repla/lib/module'
end

Repla.application_exists || abort('The Repla application is not installed.')
