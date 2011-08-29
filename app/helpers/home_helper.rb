module HomeHelper
  def start_date_array
    [["Use exact date above", "exact"], 
      ["1 day before",           "onebefore"], 
      ["1 day after",            "oneafter"], 
      ["1 day before and after", "one"], 
      ["2 days before and after","two"], 
      ["3 days before and after","three"]]
  end
  def start_date_options(val)
    val = "two" unless start_date_array.map{|a,b| b}.include? val
    start_date_array.map{|a,b| [a,b,b==val ? "selected='selected'" : ""]}
          .map{|a,b,c| "<option value=#{b} #{c}>#{a}</option>"}.join.html_safe
  end
end
