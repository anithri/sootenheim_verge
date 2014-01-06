class LocHash

  def initialize(auto_reverse = true)
    @store = {}
    @reverse = auto_reverse
  end

  def [](*loc)
    @store[loc.flatten]
  end

  def all
    @store.values
  end

  def add(e)
    return nil unless e.valid?
    if @reverse
      rev = e.inverse
      @store[rev.loc] = rev
    end
    @store[e.loc] = e
  end

  def add_shortest(e)
    add [e,self[e.loc]].compact.min_by(&:length)
  end

  def starts_with?(from)
    @store.keys.select{|f,t| f == from}.map{|loc| @store[loc]}
  end

  def ends_with?(to)
    @store.keys.select{|f,t| t == to}.map{|loc| @store[loc]}
  end

  def count
    @store.count
  end



end