require 'irbtools/configure'
Irbtools.remove_library :paint
Irbtools.remove_library :fancy_irb
Irbtools.remove_library :hirb
Irbtools.add_library :paint, :late => true do Wirb.load_schema :classic_paint if defined? Wirb end
Irbtools.start
require 'irb/completion'
require 'pp'

require 'astro'

