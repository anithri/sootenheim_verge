require 'yaml'
require 'virtus'
require 'active_record'
require 'ancestry'

ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database => 'etc/SootenheimVerge.AstroDB'
)

require_relative "./astro/body"
require_relative "./astro/route"
require_relative "./astro/version"
require_relative "./astro/position"
require_relative "./astro/star"
require_relative "./astro/map"
require_relative './astro/name_generator'

module Astro

  def self.sv
    Map.load_from('etc/sootenheim_verge_map.yaml')
  end
end
