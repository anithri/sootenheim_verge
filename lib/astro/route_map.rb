module Astro
  class RouteMap

    attr_reader :segments, :routes

    def initialize
      @segments = LocHash.new
      @routes = LocHash.new
    end

    def route_from(f, t)
      route = @routes[f,t]
      return route if route
      #calc_route(f,t)
    end

    def calc_route(f,t)
      gen = 0
      while gen < 100 && @routes[f,t]
        gen += 2
        puts "Generation: #{gen}"
        extend_routes(f, t)
      end
    end

    def extend_routes(from, towards)
      possible_midpoints(towards).each do |mid_point|
        @routes.starts_with?(from).each do |starting|
          next unless starting.to == mid_point
          segments = starting.segments + [@segments[mid_point, towards]]
          add_route segments
        end
      end
    end

    def possible_midpoints(towards)
      @routes.ends_with?(towards).map(&:from).uniq
    end

    def add_route(segments)
      f,t = segments.first, segments.last
      @routes.add_shortest Astro::Route.new segments: segments
      @routes[f,t]
    end

    def add_segment(f, t, factor)
      return @segments[f,t] if @segments[f,t]

      s = Astro::RouteSegment.new(from: f, to: t, factor_id: factor)
      @segments.add s
      @routes.add Astro::Route.new(segments: [s])
      @segments[f,t]
    end
  end
end