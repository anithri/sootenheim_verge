module Astro
  class Body < ActiveRecord::Base
    has_ancestry ancestry_column: :parent_id

    INITIAL_MAP = {}

    scope :roots, lambda { where(ancestry_column => [nil, 0]) }

    attr_accessor :factor

    def - (val)
      factor ||= 1.0
      Math.sqrt([:x, :y, :z].map do |v|
        ((self.send(v) / factor) - (val.send(v) / factor)) ** 2
      end.inject(:+))
    end

    def routes
      @routes ||= {}
    end

    def add_route(to, route)
      routes[to] = route
    end

    def find_connection(destination)

    end

    def set_route_to(to, route)
      if @route_to.has_key?(to)
        @route_to[to] = [@route_to[to],route].compact.sort_by{|r| r.length}.first
      end
    end

    def self.find_by_initial(initial)
      INITIAL_MAP[initial] ||= self.roots.where("name like '#{initial}%'").first
    end
  end

end