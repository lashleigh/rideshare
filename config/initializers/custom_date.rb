class Time
  def array_from_range(range)
    from = range[0]
    to = range[1]
    dates = []
    (-from..to).each {|i| dates.push(i.days.ago(self))}
    return dates #.reject {|d| d.past? }.uniq
  end
end
