class Date
  def array_from_range(range)
    from = range[0]
    to = range[1]
    dates = []
    (from..0).each {|i| dates.push(i.days.ago(self))}
    (0..to).each {|i| dates.push(i.days.since(self))}
    return dates.reject {|d| d.past? }.uniq
  end
end
