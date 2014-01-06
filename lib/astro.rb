require 'yaml'
require 'virtus'
require 'active_record'
require 'ancestry'
require 'pry'
require_relative './loc_hash'

ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database => 'etc/SootenheimVerge.AstroDB'
)



module Astro
  DISTANCE_PRECISION = 3

  require_relative "./astro/body"
  require_relative "../lib/astro/route_segment"
  require_relative "./astro/route"
  require_relative "./astro/route_map"
  require_relative "../lib/astro/route_init"
  require_relative "./astro/version"
  require_relative "./astro/position"
  require_relative "./astro/star"
  require_relative "./astro/map"
  require_relative './astro/name_generator'

  def self.sv
    Map.load_from('etc/sootenheim_verge_map.yaml')
  end
end
